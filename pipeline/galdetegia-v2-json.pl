#!/usr/bin/perl
# Galdetegia v2 → datuak/galdetegia-v2.json (web-tresnarako datu gardenak).
# Batzen ditu: datuak/galdetegia-v2.tsv (posizioak), datuak/galdetegia-v2-azalpenak.tsv,
#              datuak/c-aukera.tsv (bozketak), datuak/iturriak.tsv (PDFak) eta iturriak/*/*-unitateak.tsv (orriak).
# Kontaketa-moduak eta formulak: pipeline/Galdetegia.pm (simulazioak ere bera erabiltzen du).
# Gelaxka guztiek azalpena dutela egiaztatzen du; falta bada, errorearekin amaitzen da.
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
BEGIN { my $d = $0; $d =~ s{/?[^/]*$}{}; $d = "." if $d eq ""; unshift @INC, $d; }
{ my $d = $0; $d =~ s{/?[^/]*$}{}; $d = "." if $d eq ""; chdir "$d/.." or die "chdir: $!"; }
use Galdetegia;

my @P = @Galdetegia::P; my %IZEN = %Galdetegia::IZEN; my %W = %Galdetegia::W;
my @BLOKEAK = qw(etxebizitza lana nazioa ekonomia euskara osasuna segurtasuna immigrazioa pentsioak);
my %BIZEN = (etxebizitza => 'Etxebizitza', lana => 'Lana eta soldatak', nazioa => 'Euskal nazioa eta autogobernua',
             ekonomia => 'Ekonomia', euskara => 'Euskara', osasuna => 'Osasuna', segurtasuna => 'Segurtasuna',
             immigrazioa => 'Immigrazioa', pentsioak => 'Pentsioak');
my %BMOTA = ('bozketa' => 'bozketa', 'bozketa+2023' => 'bozketa eta 2023ko programa', 'Mahaia' => 'Kongresuko Mahaiaren erabakia',
             'adierazpena' => 'adierazpen publikoa (ez da bozketa)');

sub js { my $s = shift; return 'null' unless defined $s; $s =~ s/\\/\\\\/g; $s =~ s/"/\\"/g; $s =~ s/\n/\\n/g; $s =~ s/\t/ /g; return "\"$s\""; }
sub num { my $x = shift; return 'null' unless defined $x; my $s = sprintf('%.2f', $x); $s =~ s/\.?0+$//; $s = '0' if $s eq '-0'; return $s; }
sub sg { my $x = shift; return $x > 0 ? "+$x" : "$x"; }
sub eu { my $x = shift; (my $s = sg($x)) =~ s/\./,/; $s =~ s/^-/−/; return $s; }
sub obj { my @kv = @_; my @o; while (@kv) { my ($k, $v) = splice @kv, 0, 2; push @o, "\"$k\": $v" if defined $v; } return '{' . join(', ', @o) . '}'; }

# Iturriak eta unitateen orriak
my %SRC;
for (Galdetegia::rd('datuak/iturriak.tsv')) { next if /^alderdia\t/; my @c = split /\t/; $SRC{$c[0]} = { izenburua => $c[1], url => $c[2] }; }
my %ORRIA;
for my $f (glob 'iturriak/*/*-unitateak.tsv') { for (Galdetegia::rd($f)) { my @c = split /\t/; $ORRIA{$c[0]} = $c[2] if @c >= 3; } }
sub alderdia_id { my $u = shift; for my $p (@P) { return $p if $u =~ /^\Q$p\E-/; } return undef; }

# Azalpenak
my %AZ;
for (Galdetegia::rd('datuak/galdetegia-v2-azalpenak.tsv')) { next if /^id\t/; my ($id, $p, $t) = split /\t/; $AZ{$id}{$p} = $t; }

my ($items, $err) = Galdetegia::kargatu();
my @err = @$err;
my %n;

my @bj;
for my $it (@$items) {
    my @gj;
    for my $p (@P) {
        my $g = $it->{gelaxkak}{$p};
        my $id = $it->{id};

        # Programa-geruza
        my ($prog, $mota);
        if (defined $g->{p}) {
            $mota = $g->{z} ? 'zeharka' : 'programa';
            my $az = $AZ{$id}{$p} // do { push @err, "azalpenik ez: $id $p"; '' };
            my @src;
            for my $u (split /,/, $g->{frogak}) {
                my $pa = alderdia_id($u) // $p; my $or = $ORRIA{$u};
                push @err, "unitatea ez da aurkitu: $u ($id $p)" unless defined $or;
                push @src, obj(mota => js('programa'), unitatea => js($u), orria => js($or), url => js($SRC{$pa}{url} . (defined $or ? "#page=$or" : '')));
            }
            $prog = obj(balioa => num($g->{p}), zeharka => ($g->{z} ? 'true' : 'false'), azalpena => js($az), iturriak => '[' . join(', ', @src) . ']');
        } else {
            $mota = $g->{c} ? 'C-' . $g->{bozka}{mota} : 'isilik';
            my $az = $AZ{$id}{$p} // 'Programak ez du gaia aipatzen.';
            $az = 'Programak ez du gaia aipatzen.' if $g->{c} && !defined $AZ{$id}{$p};
            $prog = obj(balioa => 'null', azalpena => js($az), iturriak => '[]');
        }
        $n{$mota}++; $n{'aho-batekoa'}++ if $g->{ahobatekoa}; $n{kontraesana}++ if $g->{kontraesana};

        # Bozka-geruza
        my $bozka = 'null';
        if (defined $g->{v} || $g->{ahobatekoa}) {
            my $b = $g->{bozka};
            $bozka = obj(balioa => num($g->{v} // $b->{balioa}), zenbatzen => ($g->{ahobatekoa} ? 'false' : 'true'), mota => js($b->{mota}), data => js($b->{data}), azalpena => js($b->{froga}),
                         oharra => (defined $b->{oharra} ? js($b->{oharra}) : undef), iturriak => '[' . ($b->{url} ? obj(mota => js('bozketa'), url => js($b->{url})) : '') . ']');
        }

        # Kontaketa bi moduetan + txartel-testua
        my @k;
        for my $m (@Galdetegia::MODUAK) {
            my ($x, $d) = Galdetegia::posizioa($g, $m);
            my $t;
            my $bz = defined $g->{v} ? sprintf('%s (%s) bozka: %s', $g->{bozka}{data}, $BMOTA{ $g->{bozka}{mota} } // $g->{bozka}{mota}, eu($g->{v})) : undef;
            if (defined $g->{p} && !$g->{kontraesana}) {
                $t = 'Programa: ' . eu($g->{p}) . ($bz && $g->{p} != $g->{v} ? ". $bz (norabide berean; programak agintzen du)" : $bz ? ". $bz (bat dator)" : '') . '.';
            } elsif ($g->{kontraesana}) {
                $t = 'Programa: ' . eu($g->{p}) . ". $bz. Kontraesana → " . ($m eq 'bozketak' ? 'batez bestekoa: ' : 'programa, 0,5 bozkaren norabidean: ') . eu($x) . '.';
            } elsif (defined $g->{v}) {
                $t = 'Programak ez du ezer esaten. ' . $bz . '. → ' . ($m eq 'bozketak' ? 'bozka posizio gisa: ' . eu($x)
                     : $d ? 'neutroa (0,5), bozkaren norabidean desenpatea (±0,125 gehienez)' : 'neutroa (0,5); abstentzioa edo jarrera nahasia');
                $t .= '.';
            } elsif ($g->{ahobatekoa}) {
                $t = sprintf('Programak ez du ezer esaten. %s bozketa aho batekoa izan zen (PP eta Vox barne), eta ez du alderdirik bereizten → ez da kontatzen; neutroa (0,5).', $g->{bozka}{data});
            } else {
                $t = 'Programak ez du ezer esaten, eta ez da bozketarik aurkitu → neutroa (0,5).';
            }
            push @k, "\"$m\": " . obj(posizioa => num($x), desenpatea => (defined $x ? undef : $d), testua => js($t));
        }

        push @gj, '        ' . obj(alderdia => js($p), mota => js($mota), kontraesana => ($g->{kontraesana} ? 'true' : 'false'),
                                  programa => $prog, bozka => $bozka, kontaketa => '{' . join(', ', @k) . '}');
    }
    push @bj, "    {\"id\": " . js($it->{id}) . ", \"blokea\": " . js($it->{blokea}) . ", \"testua\": " . js($it->{testua}) . ",\n      \"gelaxkak\": [\n" . join(",\n", @gj) . "\n      ]}";
}
if (@err) { print STDERR "AKATSAK:\n  ", join("\n  ", @err), "\n"; exit 1; }

my $o = "{\n";
$o .= "  \"bertsioa\": \"v2.2\",\n  \"data\": \"2026-11-19\",\n";
$o .= "  \"puntuazioa\": {\n";
$o .= "    \"adostasuna\": \"posizioa (x) badago: 1 - |erantzuna - x| / 4; bestela: 0.5 + desenpatea * erantzuna * $Galdetegia::DESENPATEA\",\n";
$o .= "    \"pisua\": \"blokearen pisua / blokeko baieztapen-kopurua (x2 'oso garrantzitsua' bada)\",\n";
$o .= "    \"emaitza\": \"sum(pisua*adostasuna)/sum(pisua)*100; 'ez dakit' erantzunak ez dira zenbatzen\",\n";
$o .= "    \"lehenetsia\": \"programak\",\n";
$o .= "    \"moduak\": {\n";
$o .= "      \"programak\": \"2026ko programek erabakitzen dute. Bozketak desenpate gisa soilik: programa isilik badago, 0,5 ± 0,125 gehienez bozkaren norabidean; programak eta bozkak norabide kontrakoa badute, posizioa 0,5 mugitzen da bozkaren aldera.\",\n";
$o .= "      \"bozketak\": \"Azken lau urteetako (XV. legegintzaldia, 2023-2026) Kongresuko jokabidea programaren pareko: programa isilik badago, bozka da posizioa; kontraesana badago, programaren eta bozkaren batez bestekoa.\"\n";
$o .= "    },\n";
$o .= "    \"aho_batekoak\": \"Aho bateko bozketak txarteletan agertzen dira (zenbatzen: false), baina ez dira kontatzen: ez dute alderdirik bereizten.\",\n";
$o .= "    \"kontraesana\": \"programak eta bozkak zeinu kontrakoa dute (bata > 0, bestea < 0); norabide bereko intentsitate-aldeak ez dira kontraesana\"\n  },\n";
$o .= "  \"motak\": {\"programa\": \"Programak esplizituki dio\", \"zeharka\": \"Programatik ondorioztatua, ez esplizitua\", \"C-bozketa\": \"Programa isilik; Kongresuko bozketa (XV. legegintzaldia)\", \"C-bozketa+2023\": \"Programa isilik; bozketa eta 2023ko programa\", \"C-Mahaia\": \"Programa isilik; Kongresuko Mahaiaren erabakia\", \"C-adierazpena\": \"Programa isilik; adierazpen publikoa (ez da bozketa)\", \"isilik\": \"Ez programarik ez bozketarik\"},\n";
$o .= "  \"alderdiak\": [" . join(', ', map { obj(id => js($_), izena => js($IZEN{$_}), programa => js($SRC{$_}{izenburua}), url => js($SRC{$_}{url})) } @P) . "],\n";
$o .= "  \"blokeak\": [" . join(', ', map { obj(id => js($_), izena => js($BIZEN{$_}), pisua => $W{$_}) } @BLOKEAK) . "],\n";
$o .= "  \"baieztapenak\": [\n" . join(",\n", @bj) . "\n  ]\n}\n";
open my $out, '>:utf8', 'datuak/galdetegia-v2.json' or die $!; print $out $o; close $out;

print "datuak/galdetegia-v2.json: ", scalar(@$items), " baieztapen × ", scalar(@P), " alderdi\n";
printf "  %-16s %d\n", $_, $n{$_} for sort keys %n;
