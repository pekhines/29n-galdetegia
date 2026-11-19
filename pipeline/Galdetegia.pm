package Galdetegia;
# Galdetegia v2: datuak kargatu eta puntuazioa kalkulatu (bi kontaketa-modu).
# galdetegia-v2.pl (simulazioa) eta galdetegia-v2-json.pl (web-datuak) biek erabiltzen dute.
#
# Gelaxka bakoitzak bi geruza ditu:
#   programa (p): 2026ko programaren posizioa, -2..+2, edo undef programa isilik badago;
#   bozka (v):    XV. legegintzaldiko Kongresuko jokabidea (datuak/c-aukera.tsv), -2..+2, edo undef.
# Kontraesana: p eta v zeinu kontrakoak dira (bata > 0, bestea < 0). 0 vs ± ez da kontraesana.
#
# Kontaketa-moduak:
#   programak (lehenetsia) — programak erabakitzen du; bozketak desenpate gisa soilik:
#     - kontraesana: posizioa 0,5 mugitzen da bozkaren norabidean (adib. PP K4: -1 → -0,5);
#     - programa isilik + bozka: adostasuna 0,5 ± 0,0625·|a|  (bozkaren norabidean; |a|=2 → ±0,125,
#       hau da, posizioa 0,5 mugitzearen baliokidea);
#     - isilik eta bozkarik gabe: 0,5.
#   bozketak — azken lau urteetako bozketak programaren pareko:
#     - kontraesana: programaren eta bozkaren batez bestekoa (PP K4: -1 eta +2 → +0,5);
#     - programa isilik + bozka: bozka posizio osoa da;
#     - isilik eta bozkarik gabe: 0,5.
# Aho bateko bozketak (c-aukera.tsv-n mota "aho-batekoa") ez dira kontatzen: ez dute alderdirik bereizten.
#   Gelaxka isilik geratzen da, eta bozka txartelean informazio gisa agertzen da.
# Bi moduetan: adostasuna = 1 - |a - x| / 4.
use strict; use warnings; use utf8;

our @P = qw(PNV EHB PSOE FA POD PP VOX);
our %IZEN = (PNV => 'EAJ-PNV', EHB => 'EH Bildu', PSOE => 'PSOE', FA => 'Frente Amplio', POD => 'Podemos', PP => 'PP', VOX => 'Vox');
our %W = (etxebizitza => 20, lana => 15, nazioa => 15, ekonomia => 12, euskara => 10,
          osasuna => 10, segurtasuna => 8, pentsioak => 5, immigrazioa => 5);
our @MODUAK = qw(programak bozketak);
our $DESENPATEA = 0.0625;   # adostasun-aldaketa erantzun-puntu bakoitzeko (|a|=2 → 0,125)

my %CMAP = ('PNV' => 'PNV', 'EH Bildu' => 'EHB', 'PSOE' => 'PSOE', 'Frente Amplio' => 'FA', 'Podemos' => 'POD', 'PP' => 'PP', 'Vox' => 'VOX');
my %S2ID = (S02 => 'L1', S04 => 'K1', S06 => 'I1', S09 => 'N2');   # v1eko kodeak; S10 (aho bateko bozketa) v2.2ko N4ri ez dagokio

sub rd { my $f = shift; open my $h, '<:utf8', $f or die "$f: $!"; my @l = grep { !/^#/ && /\S/ } map { chomp; $_ } <$h>; close $h; return @l; }
sub sign { my $x = shift; return $x > 0 ? 1 : $x < 0 ? -1 : 0; }

# C aukera / bozketak: $C{id}{alderdia} = {balioa, mota, data, froga, oharra, url}
sub c_aukera {
    my %C;
    for (rd('datuak/c-aukera.tsv')) {
        next if /^alderdia\t/;
        my ($a, $s, $v, $mota, $data, $froga, $ohar, $url) = split /\t/;
        my $p = $CMAP{$a} or next; my $id = $S2ID{$s} // $s;
        next unless defined $v && $v =~ /^[+-]?\d+$/;   # "ez" = ez da bozketarik aurkitu
        $C{$id}{$p} = { balioa => $v + 0, v1 => ($S2ID{$s} ? 1 : 0), mota => $mota, data => $data, froga => $froga,
                        oharra => (defined $ohar && $ohar ne '-' ? $ohar : undef), url => (defined $url && $url ne '-' ? $url : undef) };
    }
    return \%C;
}

# Galdetegia kargatu. Itzultzen du: [items], non item = {id, blokea, testua, gelaxkak => {P => gelaxka}}
# gelaxka = {p, v, z (zeharka), c (programa isilik, bozkatik betea), frogak, bozka (c-aukera sarrera), kontraesana}
sub kargatu {
    my $C = c_aukera();
    my (@items, @err);
    for (rd('datuak/galdetegia-v2.tsv')) {
        next if /^id\t/;
        my @c = split /\t/;
        my %it = (id => $c[0], blokea => $c[1], testua => $c[2]);
        for my $i (0 .. $#P) {
            my $p = $P[$i];
            my ($val, $ev) = $c[3 + $i] =~ /^([^:]+):?(.*)$/;
            my %g = (frogak => $ev, bozka => $C->{$it{id}}{$p});
            if ($val eq '.') {
                if ($g{bozka}) {
                    if ($g{bozka}{mota} eq 'aho-batekoa') { $g{ahobatekoa} = 1; }   # informazio gisa bakarrik, ez da kontatzen
                    else { push @err, "isilik baina c-aukeran balioa du: $it{id} $p"; }
                }
            } elsif ($val =~ /C/) {
                (my $n = $val) =~ s/C//; $g{c} = 1;
                if (!$g{bozka}) { push @err, "C sarrerarik ez: $it{id} $p"; }
                elsif (!$g{bozka}{v1} && $g{bozka}{balioa} != $n) { push @err, "C balioa ez dator bat: $it{id} $p ($n vs $g{bozka}{balioa})"; }
                $g{v} = $n + 0;
            } else {
                $g{z} = $val =~ /z/; (my $n = $val) =~ s/z//; $g{p} = $n + 0;
                $g{v} = $g{bozka}{balioa} if $g{bozka};
            }
            $g{kontraesana} = (defined $g{p} && defined $g{v} && $g{p} * $g{v} < 0) ? 1 : 0;
            $it{gelaxkak}{$p} = \%g;
        }
        push @items, \%it;
    }
    return (\@items, \@err);
}

# Posizio eraginkorra moduaren arabera: (x, desenpatea). x undef bada, adostasuna 0,5 + desenpatea·a·$DESENPATEA.
sub posizioa {
    my ($g, $modua) = @_;
    my ($p, $v) = ($g->{p}, $g->{v});
    if (defined $p) {
        return ($p, 0) unless $g->{kontraesana};
        return $modua eq 'bozketak' ? (($p + $v) / 2, 0) : ($p + 0.5 * sign($v - $p), 0);
    }
    if (defined $v) { return $modua eq 'bozketak' ? ($v, 0) : (undef, sign($v)); }
    return (undef, 0);
}

sub adostasuna {
    my ($a, $g, $modua) = @_;
    my ($x, $d) = posizioa($g, $modua);
    return defined $x ? 1 - abs($a - $x) / 4 : 0.5 + $DESENPATEA * $a * $d;
}

# $ans: id => -2..2 ; $garrantzi: blokea => 1 ; emaitza: alderdia => 0..100
sub puntuazioa {
    my ($items, $ans, $garrantzi, $modua) = @_;
    my %nblok; $nblok{ $_->{blokea} }++ for @$items;
    my %r;
    for my $p (@P) {
        my ($num, $den) = (0, 0);
        for my $it (@$items) {
            next unless defined $ans->{ $it->{id} };
            my $w = $W{ $it->{blokea} } / $nblok{ $it->{blokea} } * ($garrantzi->{ $it->{blokea} } ? 2 : 1);
            $num += $w * adostasuna($ans->{ $it->{id} }, $it->{gelaxkak}{$p}, $modua); $den += $w;
        }
        $r{$p} = $den ? 100 * $num / $den : 0;
    }
    return \%r;
}

1;
