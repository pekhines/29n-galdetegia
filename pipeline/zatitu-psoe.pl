#!/usr/bin/perl
# PSOEren 2026ko programa (pdftotext -layout) unitateetan zatitzen du.
# Erabilera: perl zatitu-psoe.pl psoe-2026.txt > psoe-2026-unitateak.tsv
# Unitateak: konpromiso zenbakidunak ("42.  Constituir…" + "o" azpi-puntuak) → PSOE-C042; paragrafoak → PSOE-p<orria>-<n>
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';
my $file = shift or die;
open my $fh, '<:utf8', $file or die $!;
local $/ = "\f"; my @pages = <$fh>; close $fh;

my ($atala, $cur, $last, $prevblank) = ('', undef, 0, 1); my @units;
# Aurkibideko izenburuak (2.-4. orrialdeak) izenburuak ezagutzeko
my @toc; { my $buf = ''; for my $l (split /\n/, join('', @pages[1..3])) { $l =~ s/^\s+|\s+$//g; next if $l eq '' || $l eq 'ÍNDICE'; if ($l =~ /^(.*?)\s*\.{3,}.*?(\d+)$/) { push @toc, norm($buf ? "$buf $1" : $1); $buf = ''; } elsif ($l !~ /^\d+$/) { $buf = $buf ? "$buf $l" : $l; } } }
sub norm { my $x = lc shift; $x =~ s/[^\p{L}\p{N} ]//g; $x =~ s/\s+/ /g; $x =~ s/^ | $//g; $x }
sub is_head { my $n = norm(shift); return 0 if length($n) < 6; for (@toc) { return 1 if index($_, $n) == 0; } 0 }
sub flush {
    return unless $cur;
    my $t = $cur->{testua};
    $t =~ s/(\p{L})-\n\s*(\p{Ll})/$1$2/g;
    $t =~ s/\s*\n\s*/ /g; $t =~ s/\s+/ /g; $t =~ s/^\s+|\s+$//g;
    push @units, { %$cur, testua => $t } if length($t) > 30;
    undef $cur;
}

for my $pi (6 .. 112) {                      # 7.–113. orrialdeak
    my $orria = $pi + 1; my $pn = 0;
    my @L = split /\n/, $pages[$pi];
    my $skip = -1;
    for my $i (0 .. $#L) {
        next if $i <= $skip;
        my $l = $L[$i]; $l =~ s/\s+$//;
        my $s = $l; $s =~ s/^\s+//;
        if ($s eq '') { flush() if $cur && $cur->{mota} eq 'p'; $prevblank = 1; next; }
        if ($s =~ /^\d{1,3}$/ && $l =~ /^\s{10,}/) { next; }                   # orrialde-zenbakia
        if ($s eq 'Compromisos') { flush(); $prevblank = 1; next; }
        # Konpromiso zenbakiduna
        next if $l =~ /^\s{0,4}\d{1,3}\.$/;                               # PDFaren akatsa: zenbakia bakarrik ("426.")
        my $kn;
        if (my ($a, $b, $rest) = $l =~ /^\s{0,4}(?:(\d{1,3})\s+)?(\d{1,3})\.?\s+(\S.*)$/) {
            my @cand = grep { defined } ($a, $b, (length($b) % 2 == 0 && substr($b, 0, length($b)/2) eq substr($b, length($b)/2)) ? substr($b, 0, length($b)/2) : undef);
            ($kn) = grep { $_ > $last && $_ <= $last + 5 } @cand;
            $kn = undef if defined $kn && $l !~ /^\s{0,4}(\d{1,3}\s+)?\d{1,3}\./ && $kn != $last + 1;   # puntu gabeko zenbakiak: hurrengoa bakarrik
            if (defined $kn) { $l = $rest; }
        }
        if (defined $kn) {
            flush(); $last = $kn;
            $cur = { id => sprintf('PSOE-C%03d', $kn), atala => $atala, orria => $orria, testua => $l, mota => 'n' };
            $prevblank = 0; next;
        }
        # Izenburua: hutsunearen ondoren, laburra, puntuazio-amaierarik gabe; hurrengo lerroa ere izenburuaren jarraipena izan daiteke
        if ($s =~ /^[\p{Lu}¿¡]/ && is_head($s) && $l !~ /^\s{0,4}\d{1,3}\.\s/) {
            my $h = $s; my $j = $i + 1;
            while ($j <= $#L && $L[$j] =~ /\S/ && is_head("$h " . ($L[$j] =~ s/^\s+|\s+$//gr))) { $h .= ' ' . ($L[$j] =~ s/^\s+|\s+$//gr); $j++; }
            flush(); $atala = $h; $skip = $j - 1; $prevblank = 1; next;
        }
        $prevblank = 0;
        if ($cur) {
            if ($cur->{mota} eq 'n' && $l !~ /^\s{3,}/ && $s !~ /^o\s/) { flush(); }   # koskarik gabe → konpromisoa amaitu da
            else { $s =~ s/^o\s+/• /; $cur->{testua} .= "\n$s"; next; }
        }
        $pn++;
        $cur = { id => sprintf('PSOE-p%03d-%02d', $orria, $pn), atala => $atala || 'Sarrera', orria => $orria, testua => $s, mota => 'p' };
    }
    flush() if $cur && $cur->{mota} eq 'p';
}
flush();
print join("\t", @$_{qw(id atala orria testua)}), "\n" for @units;
