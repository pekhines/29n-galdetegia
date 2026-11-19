#!/usr/bin/perl
# Partidu baten laburpena Claude-ren sailkapenetik (kodeketa-liburua v0.3).
# Erabilera: perl laburpena.pl <claude-v0.3.tsv> <unitateak.tsv> <IZENA>  > laburpena.md
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';

my ($lab, $uni, $izena) = @ARGV;
my %GAIA = (G01=>'Etxebizitza',G02=>'Lana',G03=>'Pentsioak',G04=>'Osasuna',G05=>'Hezkuntza',G06=>'Zaintza/gizarte-zerbitzuak',
  G07=>'Zergak',G08=>'Gastu publikoa/administrazioa',G09=>'Bizi-kostua',G10=>'Ekonomia/industria',G11=>'Klima/energia',
  G12=>'Garraioa/azpiegiturak',G13=>'Immigrazioa',G14=>'Segurtasuna/justizia',G15=>'Berdintasuna/LGTBI',G16=>'Euskara/kultura',
  G17=>'Autogobernua',G18=>'Erabakitzeko eskubidea',G19=>'Presoak/memoria',G20=>'Europa/kanpo-politika',G21=>'Landa/nekazaritza',
  G22=>'Demokrazia/erakundeak',G99=>'Erretorika/orokorra');
my %S = (S01=>'Alokairuen prezioak legez mugatu',S02=>'Lanaldia murriztu soldata jaitsi gabe',S03=>'Osasun publikoa indartu, itun pribatuak mugatu',
  S04=>'Zerga gehiago aberastasun handiei',S05=>'Pentsioak KPIaren arabera',S06=>'Erregularizazio orokorra',S07=>'Administrazioan euskara-eskakizuna blindatu',
  S08=>'Nazio-aitortza eta aldebikotasuna',S09=>'Independentzia-erreferendum lotesleko eskubidea',S10=>'Presoei espetxe-legedi arrunta');

my %txt;
open my $U, '<:utf8', $uni or die $!;
while (<$U>) { chomp; my ($id, $at, $or, $t) = split /\t/; $txt{$id} = { at => $at, or => $or, t => $t }; }

my (@rows);
open my $L, '<:utf8', $lab or die $!;
while (<$L>) { next if /^#|^id\t/; chomp; my @c = split /\t/; push @rows, { id=>$c[0], G=>$c[1], D1=>$c[2], D2=>$c[3], D3=>$c[4], D4=>$c[5], D5=>$c[6], D6=>$c[7], D7=>$c[8], S=>$c[9], oh=>$c[10] // '-' }; }
my $N = @rows;

sub first { (split /\|/, shift)[0] }
sub has { my ($v, $x) = @_; return scalar grep { $_ eq $x } split /\|/, $v }
sub mean { my @a = @_; return 0 unless @a; my $s = 0; $s += $_ for @a; $s / @a }
sub laburtu { my $t = shift; $t = substr($t, 0, 230) . '…' if length($t) > 230; $t =~ s/\|/\\|/g; $t }

print "## $izena\n\n";

# --- Baieztapenak ---
print "### Jarrera 10 baieztapenetan\n\n| # | Baieztapena | Jarrera | Unitateak | Froga nagusia |\n|---|---|---|---|---|\n";
for my $k (sort keys %S) {
    my @ev;
    for my $r (@rows) {
        for (split /;/, $r->{S}) { my ($kk, $v) = split /=/; next unless $kk && $kk eq $k;
            my @vals = split /\|/, $v; my $m = mean(@vals);
            push @ev, { id => $r->{id}, v => $m, d5 => mean(split /\|/, $r->{D5}), zeh => ($r->{oh} =~ /ZEHARKA/ ? 1 : 0) }; }
    }
    if (!@ev) { print "| $k | $S{$k} | **Ez du aipatzen** | 0 | — (C aukera: botoak / 2023ko programa) |\n"; next; }
    my @zuz = grep { !$_->{zeh} } @ev;
    my @bas = @zuz ? @zuz : @ev;
    # Jarrera: batez bestekoaren zeinua; magnitudea = zeinu bereko froga esplizituena
    my $m = mean(map { $_->{v} } @bas);
    my @same = grep { $m == 0 ? $_->{v} == 0 : $_->{v} * $m > 0 } @bas;
    my ($best) = sort { abs($b->{v}) <=> abs($a->{v}) or $b->{d5} <=> $a->{d5} } (@same ? @same : @bas);
    my $mag = int(abs($best->{v}) + 0.5);
    my $pos = $m > 0 ? "+$mag" : $m < 0 ? "-$mag" : "0";
    $pos = "0" if $mag == 0;
    my $u = $txt{$best->{id}};
    my $oharra = @zuz ? '' : ' (zeharka)';
    printf "| %s | %s | **%s**%s | %d | %s (or. %s): «%s» |\n", $k, $S{$k}, $pos, $oharra, scalar @ev, $best->{id}, $u->{or}, laburtu($u->{t});
}

# --- Gaiak ---
my %g;
for my $r (@rows) { $g{$_}++ for split /,/, $r->{G}; }
print "\n### Programaren pisua gaika (unitate-kopurua, %)\n\n";
print join(' · ', map { sprintf '%s %d (%.0f%%)', $GAIA{$_} // $_, $g{$_}, 100 * $g{$_} / $N } sort { $g{$b} <=> $g{$a} } keys %g), "\n";

# --- Dimentsioak ---
my %c;
for my $r (@rows) {
    for my $d (qw(D1 D2 D3 D4)) { next if $r->{$d} eq 'ez'; $c{"$d:" . first($r->{$d})}++; $c{"$d:" . first($r->{$d}) . ':ziur'}++ unless $r->{$d} =~ /\|/; }
    $c{D6}++ if $r->{D6} =~ /^1/;
    my $d5 = mean(split /\|/, $r->{D5}); $c{D5sum} += $d5; $c{D5_3}++ if $d5 >= 3; $c{D5_0}++ if $d5 == 0;
    for (split /;/, $r->{D7}) { my ($gr, $v) = split /=/; next unless $v; $c{"D7:$gr:" . first($v)}++; }
}
my $p = sub { sprintf '%d (%.0f%%)', $_[0] // 0, 100 * ($_[0] // 0) / $N };
print "\n### Zeharkako dimentsioak ($N unitate)\n\n| Dimentsioa | Emaitza |\n|---|---|\n";
printf "| Ongizatea (D1) | zabaldu %s · mantendu %s · **murriztu %s** |\n", map { $p->($c{"D1:$_"}) } qw(zabaldu mantendu murriztu);
printf "| Lan-eskubideak (D2) | hobetu %s · mantendu %s · **murriztu %s** |\n", map { $p->($c{"D2:$_"}) } qw(hobetu mantendu murriztu);
printf "| Zergak (D3) | igo handiei %s · igo orokorrean %s · jaitsi handiei %s · jaitsi orokorrean %s |\n", map { $p->($c{"D3:$_"}) } qw(igo_handiei igo_orokorra jaitsi_handiei jaitsi_orokorra);
printf "| Gastu publikoa (D4) | handitu %s · murriztu %s · berrantolatu %s |\n", map { $p->($c{"D4:$_"}) } qw(handitu murriztu berrantolatu);
printf "| Zehaztasuna (D5, 0–3) | batez bestekoa **%.2f** · zenbaki/epe/finantzaketadunak %s · erretorika hutsa %s |\n", $c{D5sum} / $N, $p->($c{D5_3}), $p->($c{D5_0});
printf "| Finantzaketa adierazita (D6) | %s |\n", $p->($c{D6});
print "| Taldeak (D7, onura / kaltea) | " . join(' · ', map { sprintf '%s %d/%d', $_, $c{"D7:$_:onura"} // 0, $c{"D7:$_:kaltea"} // 0 } qw(langileak pentsiodunak prekarioak gazteak emakumeak etorkinak autonomoak enpresahandiak errentaaltuak)) . " |\n";

# --- Murrizketen radarra ---
print "\n### Murrizketen radarra\n\n*Ongizatea, lan-eskubideak edo gastua murrizten dituztenak (D1/D2/D4 = murriztu), eta eufemismo/eskubide-murrizketa oharra dutenak. `a|b` = eztabaidagarria, berrikusteko.*\n\n";
my $n = 0;
for my $r (@rows) {
    my @why;
    for my $d (qw(D1 D2 D4)) { push @why, "$d=$r->{$d}" if has($r->{$d}, 'murriztu'); }
    push @why, $1 if $r->{oh} =~ /(MURRIZKETA\??|ESKUBIDE-MURRIZKETA|ATZERAPENA)/;
    next unless @why;
    my $u = $txt{$r->{id}}; $n++;
    printf "- **%s** (or. %s) [%s] — %s%s\n", $r->{id}, $u->{or}, join(', ', @why), laburtu($u->{t}), ($r->{oh} ne '-' ? "  \n  _Oharra: $r->{oh}_" : '');
}
print "- (bat ere ez)\n" unless $n;

# --- Aurrerapen sozialak ---
my @aur = grep { $_->{D1} =~ /^zabaldu/ || $_->{D2} =~ /^hobetu/ } @rows;
printf "\n### Aurrerapen sozialak\n\nOngizatea zabaltzen edo lan-eskubideak hobetzen dituzten unitateak: **%s**. Zehatzenak (D5 = 3):\n\n", $p->(scalar @aur);
for my $r (grep { mean(split /\|/, $_->{D5}) >= 3 } @aur) { my $u = $txt{$r->{id}}; printf "- **%s** (or. %s) — %s\n", $r->{id}, $u->{or}, laburtu($u->{t}); }
print "\n";
