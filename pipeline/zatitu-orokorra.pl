#!/usr/bin/perl
# Programa orokorren zatitzailea (pdftotext -layout irteera): atal zenbakidunak + paragrafoak + buletak.
# Erabilera: perl zatitu-orokorra.pl <testua.txt> <AURRIZKIA> <lehen_orria> <azken_orria> > unitateak.tsv
# Irteera (TSV): id  atala  orria  testua
#   id = <AURRIZKIA>-<orria>-<n>   (adib. EHB-05-03)
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';

my ($file, $pre, $p0, $p1) = @ARGV;
die "erabilera: zatitu-orokorra.pl testua.txt AURRIZKIA lehena azkena\n" unless $p1;
open my $fh, '<:utf8', $file or die $!;
local $/ = "\f";
my @pages = <$fh>;
close $fh;

my $atala = '';
my ($cur, $n) = (undef, 0);
my @units;

sub flush {
    return unless $cur;
    my $t = $cur->{testua};
    $t =~ s/(\p{L})-\n\s*(\p{Ll})/$1$2/g;      # hitz-zatiketak lerro-amaieran
    $t =~ s/\s*\n\s*/ /g; $t =~ s/\s+/ /g; $t =~ s/^\s+|\s+$//g;
    $t =~ s/^•\s*//;
    push @units, { %$cur, testua => $t } if length($t) > 30;
    undef $cur;
}

for my $pi ($p0 - 1 .. $p1 - 1) {
    my $orria = $pi + 1;
    $n = 0;
    for my $l (split /\n/, $pages[$pi]) {
        $l =~ s/\s+$//;
        my $s = $l; $s =~ s/^\s+//;
        if ($s eq '') { flush() if $cur && !$cur->{bulet}; next; }   # paragrafo-muga (buletek ez dute hutsunerik behar)
        next if $s =~ /^P\s?RO\s?G\s?RA\s?M\s?A$/;                   # goiburua
        next if $s =~ /^\d{1,2}$/;                                     # orrialde-zenbakia
        next if $s =~ /^\d{1,3}\s+\p{Lu}[\p{Lu}\s,.:ÁÉÍÓÚÑ]{12,}$/;              # goiburua: "34   DERECHOS SOCIALES…"
        # Atal-izenburua: "1.1.   Etxebizitza", "2. Euskal Herriaren…", "1.5.1 Osasuna…"
        if (my ($hz, $hi) = $s =~ /^(\d{1,2}(?:\.\d{1,2})*\.?)\s+(\p{Lu}.{0,110})$/) { if (($s !~ /[.;:,]$/ || $hi eq uc($hi)) && length($s) < 120 && ($hz =~ /\./ ) && ($hz =~ /\d\.\d/ || length($s) < 70)) {
            flush(); $atala = "$hz $hi"; $atala =~ s/\s+/ /g; $atala =~ s/\.$//; next; }
        }
        if ($s =~ /^[•●▪■]\s*(.*)$/) {                                  # bulet berria
            flush(); $n++;
            $cur = { id => sprintf('%s-%02d-%02d', $pre, $orria, $n), atala => $atala || 'Sarrera', orria => $orria, testua => $1, bulet => 1 };
            next;
        }
        if ($cur) {
            # Bulet baten ondoren koskarik gabeko lerro luzea → paragrafo berria
            if ($cur->{bulet} && $l =~ /^\S/ && $cur->{testua} =~ /[.:]$/) { flush(); }
            else { $cur->{testua} .= "\n$s"; next; }
        }
        $n++;
        $cur = { id => sprintf('%s-%02d-%02d', $pre, $orria, $n), atala => $atala || 'Sarrera', orria => $orria, testua => $s, bulet => 0 };
    }
    # Orrialde-jauzian paragrafoa jarraitzen bada (minuskulaz hasten den lerroa), ez itxi: hurrengo orrian jarraituko du
}
flush();

for my $u (@units) {
    print join("\t", $u->{id}, $u->{atala}, $u->{orria}, $u->{testua}), "\n";
}
