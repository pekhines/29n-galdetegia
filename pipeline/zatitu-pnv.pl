#!/usr/bin/perl
# EAJ-PNVren 2026ko programa (pdftotext -layout) unitateetan zatitzen du.
# Erabilera: perl zatitu-pnv.pl pnv-2026.txt > pnv-2026-unitateak.tsv
# Unitateak: neurri zenbakidunak ("01  Agilizar…") → PNV-<atala>-<NN>; paragrafoak → PNV-p<orria>-<n>
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';
my $file = shift or die;
open my $fh, '<:utf8', $file or die $!;
local $/ = "\f"; my @pages = <$fh>; close $fh;

my ($kap, $atala, $azpi) = ('', '', '');
my ($cur, @units, %seen);
my $pn = 0;

sub flush {
    return unless $cur;
    my $t = $cur->{testua};
    $t =~ s/(\p{L})-\n\s*(\p{Ll})/$1$2/g;
    $t =~ s/\s*\n\s*/ /g; $t =~ s/\s+/ /g; $t =~ s/^\s+|\s+$//g;
    push @units, { %$cur, testua => $t } if length($t) > 30;
    undef $cur;
}

for my $pi (2 .. 41) {                      # 3.–42. orrialdeak (azala eta aurkibidea kanpo)
    my $orria = $pi + 1; $pn = 0;
    for my $l (split /\n/, $pages[$pi]) {
        $l =~ s/\s+$//;
        next if $l =~ /^PROGRAMA ELECCIONES GENERALES 2026/;
        next if $l =~ /^Defendemos Euskadi\s+\d+$/;
        my $s = $l; $s =~ s/^\s+//;
        if ($s eq '') { flush() if $cur && $cur->{mota} eq 'p'; next; }
        next if $s =~ /^(NUESTROS COMPROMISOS|QUÉ PROPONEMOS|EUSKADI ZAINDU)$/;
        if ($s =~ /^(\d\.\d)\s+(\S.*)$/) { flush(); $atala = "$1 $2"; $azpi = ''; next; }          # 1.1 Vivienda…
        if ($l =~ /^(\d\d)\s{2,}(\S.*)$/) {                                      # 01  neurria
            flush();
            my ($nn, $t) = ($1, $2); my ($an) = $atala =~ /^(\d\.\d)/; $an //= '0.0';
            my $id = "PNV-$an-$nn"; $id .= 'b' while $seen{$id}++;
            $cur = { id => $id, atala => join(' > ', grep { $_ ne '' } $atala, $azpi), orria => $orria, testua => $t, mota => 'n' };
            next;
        }
        if ($s =~ /^[\p{Lu}0-9 ,.;:'"«»()\-–—¿?¡!\/]+$/ && $s =~ /\p{Lu}{3}/ && length($s) < 110) {   # LETRA LARRIZKO izenburua
            flush();
            if ($atala eq '' || $s =~ /^[\p{Lu} ,.]+$/ && !$cur && $azpi eq '' && $atala !~ /^\d/) { $kap = $s; }
            $azpi = $s; next;
        }
        if ($cur) {
            if ($cur->{mota} eq 'n' && $l !~ /^\s{3,}/) { flush(); }            # koskarik gabe → neurria amaitu da
            else { $cur->{testua} .= "\n$s"; next; }
        }
        $pn++;
        $cur = { id => sprintf('PNV-p%02d-%02d', $orria, $pn), atala => join(' > ', grep { $_ ne '' } ($atala || 'Sarrera'), $azpi), orria => $orria, testua => $s, mota => 'p' };
    }
    flush() if $cur && $cur->{mota} eq 'p';
}
flush();
print join("\t", @$_{qw(id atala orria testua)}), "\n" for @units;
