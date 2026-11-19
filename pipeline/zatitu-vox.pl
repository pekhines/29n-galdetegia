#!/usr/bin/perl
# Vox 2026 programa ("Es sentido común") unitateetan zatitu.
# Erabilera: perl zatitu-vox.pl vox-2026.txt > vox-2026-unitateak.tsv
# Irteera: id \t atala \t orria \t testua
#  - Bulet gabeko neurria: VOX-NNN (testu osoa).
#  - Buletak dituen neurria: VOX-NNN-k bulet bakoitzeko; neurriaren izenburua atalean.
use strict; use warnings; use utf8;
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8';
open my $fh, '<:utf8', $ARGV[0] or die "$ARGV[0]: $!";
local $/; my $all = <$fh>; close $fh;
my @pages = split /\f/, $all;

my ($kap, $num, $title, $nbul, $cur, $curpage, $started) = ('', 0, '', 0, undef, 0, 0);
my @units;   # [id, atala, orria, testua]
my @titlebuf;

sub clean { my $t = shift; $t =~ s/\s+/ /g; $t =~ s/^ | $//g; return $t; }
sub flush_bullet {
    return unless defined $cur;
    push @units, [$cur->{id}, $cur->{atala}, $cur->{orria}, clean($cur->{txt})];
    undef $cur;
}
sub flush_measure {
    flush_bullet();
    if ($num && !$nbul) {
        push @units, [sprintf('VOX-%03d', $num), $kap, $curpage, clean($title)];
    } elsif ($num && length(clean($title)) > 60) {
        # Buletak dituen neurriaren izenburu luzea: eduki propioa izan dezake
        push @units, [sprintf('VOX-%03d-0', $num), $kap, $curpage, clean($title)];
    }
    $title = '';
}

for my $pi (0..$#pages) {
    my $page = $pi + 1;
    my @lines = split /\n/, $pages[$pi];
    # Marratxoz zatitutako hitzak lotu (minuskula jarraian)
    my $txt = join("\n", @lines);
    $txt =~ s/(\p{L})-\n\s*(\p{Ll})/$1$2/g;
    for my $l (split /\n/, $txt) {
        next if $l =~ /^\s*ES SENTIDO COM[UÚ]N\s*$/;
        next if $l =~ /^\s*\d{1,2}\s*$/;
        next if $l =~ /^\s*$/;
        if ($l =~ /^\s*(\d{1,3})\.\s+(\S.*)$/ && $1 == $num + 1) {
            flush_measure();
            $started = 1; $num = $1; $title = $2; $nbul = 0; $curpage = $page;
            next;
        }
        next unless $started || $l =~ /^\s*[\p{Lu}][\p{Lu} ,]{5,}$/;
        if ($l =~ /^\s*([\p{Lu}][\p{Lu} ,]{5,})\s*$/ && $l !~ /\p{Ll}/) {
            my $h = clean($1);
            next if $h =~ /^(VOTA|PROGRAMA ELECTORAL|ÍNDICE)$/;
            if ($started) { flush_measure(); $num = $num; $title = ''; $nbul = 1; } # izenburu-aldaketa
            # Bi lerroko izenburua (adib. JUSTIZIA)
            if ($h =~ /^Y / && $kap) { $kap .= " $h"; } else { $kap = $h; }
            $kap =~ s/INDEPENDENCIA DE LA JUSTICIA Y/INDEPENDENCIA DE LA JUSTICIA Y/;
            next;
        }
        next unless $started;
        if ($l =~ /^\s*•\s*(.*)$/) {
            flush_bullet();
            $nbul++;
            my $at = "$kap > $num. " . clean($title);
            $at = substr($at, 0, 160);
            $cur = { id => sprintf('VOX-%03d-%d', $num, $nbul), atala => $at, orria => $page, txt => $1 };
            next;
        }
        if (defined $cur) { $cur->{txt} .= " $l"; } else { $title .= " $l"; }
    }
}
flush_measure();
print join("\t", @$_), "\n" for @units;
