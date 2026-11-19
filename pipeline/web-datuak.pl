#!/usr/bin/perl
# Web-tresnaren datuak sortu: docs/datuak/*.json
#   galdetegia.json      ← datuak/galdetegia-v2.json (pipeline/galdetegia-v2-json.pl)
#   atalak.json          ← blokeak, gai-kodeak (G01–G22) eta haien arteko lotura
#   programa-<ID>.json   ← iturriak/*/*-unitateak.tsv + datuak/*/claude-v0.3.tsv (gaiak)
# Erabilera: perl pipeline/galdetegia-v2-json.pl && perl pipeline/web-datuak.pl
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
BEGIN { my $d = $0; $d =~ s{/?[^/]*$}{}; $d = "." if $d eq ""; unshift @INC, $d; }
{ my $d = $0; $d =~ s{/?[^/]*$}{}; $d = "." if $d eq ""; chdir "$d/.." or die "chdir: $!"; }
use Galdetegia;

my $OUT = 'docs/datuak';
-d $OUT or mkdir $OUT or die "$OUT: $!";

sub js { my $s = shift; return 'null' unless defined $s; $s =~ s/\\/\\\\/g; $s =~ s/"/\\"/g; $s =~ s/\n/\\n/g; $s =~ s/\r//g; $s =~ s/\t/ /g; $s =~ s/([\x00-\x1f])/sprintf('\\u%04x', ord $1)/ge; return "\"$s\""; }
sub idatzi { my ($f, $s) = @_; open my $h, '>:utf8', "$OUT/$f" or die "$f: $!"; print $h $s; close $h; printf "  %-24s %7.0f KB\n", $f, (-s "$OUT/$f") / 1024; }

# Alderdien karpetak eta fitxategiak
my %DIR  = (PNV => 'pnv', EHB => 'ehbildu', PSOE => 'psoe', FA => 'frenteamplio', POD => 'podemos', PP => 'pp', VOX => 'vox');
my %UFIT = (PNV => 'pnv-2026', EHB => 'ehbildu-2026', PSOE => 'psoe-2026', FA => 'fa-2026', POD => 'podemos-2026', PP => 'pp-2026', VOX => 'vox-2026');

# Gai-kodeak (02-metodologia.md, kodeketa-liburua v0.3.1) eta galdetegiko blokeekiko lotura
my @GAIAK = (
  [G01 => 'Etxebizitza'], [G02 => 'Lana, soldatak eta lan-eskubideak'], [G03 => 'Pentsioak eta Gizarte Segurantza'],
  [G04 => 'Osasuna'], [G05 => 'Hezkuntza eta unibertsitatea'], [G06 => 'Zaintza, mendekotasuna eta haurtzaroa'],
  [G07 => 'Zergak eta fiskalitatea'], [G08 => 'Gastu publikoa, administrazioa eta ustelkeria'],
  [G09 => 'Bizi-kostua, energia-prezioak eta kontsumoa'], [G10 => 'Ekonomia, industria eta enpresak'],
  [G11 => 'Klima, energia eta ingurumena'], [G12 => 'Garraioa eta azpiegiturak'], [G13 => 'Immigrazioa'],
  [G14 => 'Segurtasuna, justizia eta askatasun zibilak'], [G15 => 'Berdintasuna, feminismoa eta LGTBI'],
  [G16 => 'Euskara, hizkuntzak eta kultura'], [G17 => 'Autogobernua, lurralde-eredua eta Kontzertua'],
  [G18 => 'Erabakitzeko eskubidea eta independentzia'], [G19 => 'Presoak, memoria eta giza eskubideak'],
  [G20 => 'Europa eta kanpo-politika'], [G21 => 'Landa-eremua eta nekazaritza'], [G22 => 'Demokrazia eta erakundeak'],
);
my %BLOKEA_GAIAK = (
  etxebizitza => [qw(G01)], lana => [qw(G02)], nazioa => [qw(G17 G18 G19)], ekonomia => [qw(G07 G08 G09 G10)],
  euskara => [qw(G16)], osasuna => [qw(G04)], segurtasuna => [qw(G14)], immigrazioa => [qw(G13)], pentsioak => [qw(G03)],
);
my %G2B; for my $b (keys %BLOKEA_GAIAK) { $G2B{$_} = $b for @{ $BLOKEA_GAIAK{$b} }; }
my @BESTEAK = grep { !$G2B{$_} } map { $_->[0] } @GAIAK;

# 1. Galdetegia (kopia zuzena; JSONa galdetegia-v2-json.pl-k sortzen eta egiaztatzen du)
{ open my $i, '<:utf8', 'datuak/galdetegia-v2.json' or die "galdetegia-v2.json: $! (exekutatu lehenik galdetegia-v2-json.pl)";
  local $/; my $s = <$i>; close $i; idatzi('galdetegia.json', $s); }

# 2. Atalak
{ my @b = map { my $b = $_; '{"id": ' . js($b) . ', "gaiak": [' . join(', ', map { js($_) } @{ $BLOKEA_GAIAK{$b} }) . ']}' }
          qw(etxebizitza lana nazioa ekonomia euskara osasuna segurtasuna immigrazioa pentsioak);
  my $s = "{\n  \"gaiak\": {" . join(', ', map { js($_->[0]) . ': ' . js($_->[1]) } @GAIAK) . "},\n"
        . "  \"blokeak\": [" . join(', ', @b) . "],\n"
        . "  \"besteak\": [" . join(', ', map { js($_) } @BESTEAK) . "]\n}\n";
  idatzi('atalak.json', $s); }

# 3. Programak
my @err;
for my $p (@Galdetegia::P) {
    my %gai;
    for (Galdetegia::rd("datuak/$DIR{$p}/claude-v0.3.tsv")) { next if /^id\t/; my @c = split /\t/; $gai{$c[0]} = $c[1]; }
    my @u;
    for (Galdetegia::rd("iturriak/$DIR{$p}/$UFIT{$p}-unitateak.tsv")) {
        my ($id, $atala, $orria, $testua) = split /\t/;
        my $g = $gai{$id}; push(@err, "gairik ez: $id"), next unless defined $g;
        my @g = grep { $_ ne 'G99' } split /,/, $g;
        next unless @g;   # G99 (sarrerak, aurkezpenak) ez dira erakusten
        push @u, '{"id": ' . js($id) . ', "atala": ' . js($atala) . ', "orria": ' . ($orria =~ /^\d+$/ ? $orria : 'null')
               . ', "gaiak": [' . join(', ', map { js($_) } @g) . '], "testua": ' . js($testua) . '}';
    }
    idatzi("programa-$p.json", "{\"alderdia\": " . js($p) . ", \"unitateak\": [\n" . join(",\n", @u) . "\n]}\n");
}
if (@err) { print STDERR "AKATSAK:\n  ", join("\n  ", @err[0 .. ($#err > 20 ? 20 : $#err)]), "\n"; exit 1; }
