#!/usr/bin/perl
# Galdetegia v2: puntuazioa eta bereizmen-simulazioa, bi kontaketa-modutan (programak / bozketak).
# Erabilera: perl pipeline/galdetegia-v2.pl > datuak/galdetegia-v2-simulazioa.txt
# Metodoa: pipeline/Galdetegia.pm eta 07-galdetegia-v2.md.
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
BEGIN { my $d = $0; $d =~ s{/?[^/]*$}{}; $d = "." if $d eq ""; unshift @INC, $d; }
{ my $d = $0; $d =~ s{/?[^/]*$}{}; $d = "." if $d eq ""; chdir "$d/.." or die "chdir: $!"; }
use Galdetegia;

my @P = @Galdetegia::P; my %IZEN = %Galdetegia::IZEN;
my ($items, $err) = Galdetegia::kargatu();
if (@$err) { print STDERR "AKATSAK:\n  ", join("\n  ", @$err), "\n"; exit 1; }

sub fmt { my $r = shift; join('  ', map { sprintf '%s %.0f', $_, $r->{$_} } sort { $r->{$b} <=> $r->{$a} || $a cmp $b } @P); }
sub show2 {
    my ($izena, $ans, $g) = @_;
    printf "%-40s programak:  %s\n", $izena, fmt(Galdetegia::puntuazioa($items, $ans, $g, 'programak'));
    printf "%-40s bozketak:   %s\n", '', fmt(Galdetegia::puntuazioa($items, $ans, $g, 'bozketak'));
}

print "# Kontaketa-moduak: 'programak' (lehenetsia; bozketak desenpate gisa) eta 'bozketak' (XV. legegintzaldiko bozketak programaren pareko).\n\n";

print "## 0. Bozketek eragindako gelaxkak\n\n";
for my $it (@$items) {
    for my $p (@P) {
        my $g = $it->{gelaxkak}{$p};
        next unless defined $g->{v};
        my ($xa, $da) = Galdetegia::posizioa($g, 'programak');
        my ($xb)      = Galdetegia::posizioa($g, 'bozketak');
        my $mota = $g->{kontraesana} ? 'KONTRAESANA' : defined $g->{p} ? 'bat dator' : 'isilik+bozka';
        next if $mota eq 'bat dator';
        printf "%-3s %-5s %-13s programa %-3s bozka %+d  →  programak: %-14s bozketak: %+.1f\n", $it->{id}, $p, $mota,
            (defined $g->{p} ? sprintf('%+d', $g->{p}) : '·'), $g->{v},
            (defined $xa ? sprintf('%+.1f', $xa) : sprintf('0,5%s', $da > 0 ? ' + desenp.' : $da < 0 ? ' − desenp.' : '')), $xb;
    }
}

print "\n## 1. Alderdi bakoitza bere posizioekin erantzuten (posiziorik gabekoak saltatuta)\n\n";
for my $modua (@Galdetegia::MODUAK) {
    print "### $modua\n";
    for my $p (@P) {
        my %a;
        for my $it (@$items) { my ($x) = Galdetegia::posizioa($it->{gelaxkak}{$p}, $modua); $a{ $it->{id} } = $x if defined $x; }
        printf "%-40s %s\n", "$IZEN{$p} (" . scalar(keys %a) . " erantzun)", fmt(Galdetegia::puntuazioa($items, \%a, {}, $modua));
    }
    print "\n";
}

print "## 2. Pertsona-profilak\n\n";
my %prof = (   # v2.2: "−" baieztapenetan (H1 H3 L2 N2 N4 N5 K1 K3 E1 O1 G2 G4 I1) ados = eskuin/zentralista
  'Abertzale ezkertiarra' => { H1=>-2,H2=>2,H3=>-2,L1=>2,L2=>-2,L3=>2,N1=>2,N2=>-2,N3=>2,N4=>-2,N5=>-2,K1=>-2,K2=>2,K3=>-2,K4=>2,E1=>-2,E2=>2,E3=>2,O1=>-2,O2=>2,G1=>2,G2=>-2,G3=>2,G4=>-2,I1=>-2,I2=>2,P1=>2 },
  'Langile ezkertiar ez-abertzalea' => { H1=>-2,H2=>2,H3=>-2,L1=>2,L2=>-2,L3=>0,N1=>0,N2=>1,N3=>0,N4=>0,N5=>0,K1=>-2,K2=>2,K3=>-2,K4=>0,E1=>1,E2=>0,E3=>0,O1=>-2,O2=>2,G1=>1,G2=>-1,G3=>0,G4=>-2,I1=>-1,I2=>1,P1=>2 },
  'Abertzale zentrista' => { H1=>0,H2=>1,H3=>-1,L1=>1,L2=>0,L3=>2,N1=>2,N2=>-1,N3=>2,N4=>-1,N5=>-2,K1=>0,K2=>1,K3=>0,K4=>2,E1=>-1,E2=>2,E3=>1,O1=>-1,O2=>1,G1=>1,G2=>0,G3=>2,G4=>-1,I1=>-1,I2=>1,P1=>2 },
  'Independentista, ekonomian zentrista' => { H1=>0,H2=>1,H3=>-1,L1=>0,L2=>0,L3=>2,N1=>2,N2=>-2,N3=>2,N4=>-2,N5=>-2,K1=>0,K2=>0,K3=>0,K4=>2,E1=>-2,E2=>2,E3=>2,O1=>-1,O2=>1,G1=>1,G2=>0,G3=>2,G4=>-1,I1=>0,I2=>0,P1=>2 },
  'Segurtasunak kezkatutako langilea' => { H1=>-2,H2=>2,H3=>-1,L1=>2,L2=>-2,L3=>0,N1=>0,N2=>0,N3=>0,N4=>1,N5=>0,K1=>-2,K2=>1,K3=>0,K4=>0,E1=>0,E2=>0,E3=>0,O1=>-2,O2=>2,G1=>-1,G2=>2,G3=>0,G4=>0,I1=>1,I2=>-1,P1=>2 },
  'Eskuin moderatua' => { H1=>2,H2=>0,H3=>1,L1=>-1,L2=>1,L3=>0,N1=>-2,N2=>2,N3=>-1,N4=>2,N5=>-1,K1=>1,K2=>-1,K3=>1,K4=>-1,E1=>1,E2=>-1,E3=>0,O1=>0,O2=>1,G1=>-1,G2=>2,G3=>-1,G4=>-1,I1=>2,I2=>-1,P1=>2 },
  'Eskuineko kontserbadorea' => { H1=>2,H2=>-1,H3=>0,L1=>-2,L2=>2,L3=>0,N1=>-2,N2=>2,N3=>-2,N4=>2,N5=>1,K1=>2,K2=>-2,K3=>2,K4=>-1,E1=>2,E2=>-2,E3=>0,O1=>0,O2=>1,G1=>-2,G2=>2,G3=>-2,G4=>1,I1=>2,I2=>-2,P1=>2 },
);
for my $n (sort keys %prof) { show2($n, $prof{$n}, {}); }
show2('Abertzale ezk. (euskara×2, nazioa×2)', $prof{'Abertzale ezkertiarra'}, { euskara => 1, nazioa => 1 });
show2('Langile ezk. (etxebizitza×2, lana×2)', $prof{'Langile ezkertiar ez-abertzalea'}, { etxebizitza => 1, lana => 1 });

print "\n## 3. Alderdien arteko adostasuna (biek posizioa duten baieztapenetan, pisu gabe)\n";
for my $modua (@Galdetegia::MODUAK) {
    print "\n### $modua\n";
    printf "%-6s %s\n", '', join(' ', map { sprintf '%5s', $_ } @P);
    for my $p (@P) {
        printf "%-6s", $p;
        for my $q (@P) {
            my ($s, $n) = (0, 0);
            for my $it (@$items) {
                my ($x) = Galdetegia::posizioa($it->{gelaxkak}{$p}, $modua);
                my ($y) = Galdetegia::posizioa($it->{gelaxkak}{$q}, $modua);
                next unless defined $x && defined $y;
                $s += 1 - abs($x - $y) / 4; $n++;
            }
            printf ' %5s', $n ? sprintf('%.0f', 100 * $s / $n) : '-';
        }
        print "\n";
    }
}

print "\n## 4. Posiziorik gabeko gelaxkak alderdiko (" . scalar(@$items) . "tik)\n\n";
printf "%-6s %9s %9s\n", '', 'programak', 'bozketak';
for my $p (@P) {
    my %n;
    for my $m (@Galdetegia::MODUAK) { $n{$m} = grep { my ($x) = Galdetegia::posizioa($_->{gelaxkak}{$p}, $m); !defined $x } @$items; }
    printf "%-6s %9d %9d\n", $p, $n{programak}, $n{bozketak};
}

print "\n## 5. Onarpen-joeraren proba (erantzun berdina baieztapen guztietan)\n\n";
print "Baieztapenen norabidea orekatuta badago, erantzun uniformeek ez lukete bloke bat bakarrik saritu behar.\n";
for my $a (-2 .. 2) {
    my %ans = map { $_->{id} => $a } @$items;
    show2(sprintf('Dena %+d', $a), \%ans, {});
}
my ($plus, $minus) = (0, 0);
for my $it (@$items) {
    my @e = map { (Galdetegia::posizioa($it->{gelaxkak}{$_}, 'programak'))[0] } qw(EHB FA POD);
    my @r = map { (Galdetegia::posizioa($it->{gelaxkak}{$_}, 'programak'))[0] } qw(PP VOX);
    my $avg = sub { my @v = grep { defined } @_; my $s = 0; $s += $_ for @v; @v ? $s / @v : 0 };
    $avg->(@e) > $avg->(@r) ? $plus++ : $minus++;
}
print "\nNorabidea: $plus baieztapenetan \"ados\" = ezker/abertzale (EHB, FA, POD), $minus baieztapenetan \"ados\" = eskuina (PP, Vox).\n";
