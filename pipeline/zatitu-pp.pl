#!/usr/bin/perl
# PPren 2026ko programa (pdftotext -layout irteera) unitateetan zatitzen du.
# Erabilera: perl zatitu-pp.pl pp-2026.txt > pp-2026-unitateak.tsv
# Irteera (TSV): id  atala  orria  testua
#   - Neurri zenbakidunak (1..249): id = PP-N001 ...
#   - Kapitulu/atal sarrerako paragrafoak: id = PP-I<orria>-<n>
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8'; binmode STDIN, ':utf8';

my $file = shift or die "fitxategia?\n";
open my $fh, '<:utf8', $file or die $!;
local $/ = "\f";
my @pages = <$fh>;
close $fh;

my ($kapitulua, $atala) = ('', '');
my @units;            # {id, atala, orria, testua}
my $cur;              # uneko unitatea
my $intro_n = 0;
my $last = 0;

sub flush {
    return unless $cur;
    my $t = $cur->{testua};
    $t =~ s/(\p{Ll})-\n(\p{Ll})/$1$2/g;    # hitz-zatiketak lerro-amaieran
    $t =~ s/(\p{Lu})-\n(\p{Lu})/$1$2/g;    # berdin letra larriz (izenburuak)
    $t =~ s/\s*\n\s*/ /g;
    $t =~ s/\s+/ /g; $t =~ s/^\s+|\s+$//g;
    $t =~ s/(?<=\.) \d{1,3}$//;              # kanpainarako gordetako neurriaren zenbaki-hondarra
    push @units, { %$cur, testua => $t } if length($t) > 40;
    undef $cur;
}

for my $pi (0 .. $#pages) {
    my $orria = $pi + 1;
    next if $orria < 6 || $orria == 7 || $orria > 76;   # 7 = aurkibidea      # azalak, aurkibidea, kontrazala
    my @lines = split /\n/, $pages[$pi];

    # Alboko zutabea dagoen jakiteko: 15+ koskako lerroen koska ohikoena
    my %ind;
    for (@lines) { next unless /\S/; my ($sp) = /^( *)/; my $n = length $sp; $ind{$n}++ if $n >= 15 && $n <= 40; }
    my ($C) = sort { $ind{$b} <=> $ind{$a} } keys %ind;
    my $nonempty = grep { /\S/ } @lines;
    my $sidebar = (defined $C && $ind{$C} >= 0.4 * $nonempty) ? $C : 0;

    for my $l (@lines) {
        $l =~ s/\s+$//;
        if ($l =~ /^\s*0(\d)\s{2,}(\S.*)$/) { flush(); my $t=$2; $t=~s/\s{3,}.*//; $kapitulua = "0$1 $t"; $atala = q{}; next; }
        if ($sidebar) {
            next if length($l) <= $sidebar;                 # alboko zutabea bakarrik
            my $pre = substr($l, 0, $sidebar);
            my $main = substr($l, $sidebar);
            next unless $main =~ /\S/;
            next if $pre =~ /\S$/ && $main =~ /^\S/;        # alboko testua zutabea gainditzen du
            $l = $main;
        }
        $l =~ s/^\s+//;
        if ($l eq '') { if ($cur && $cur->{id} =~ /^PP-I/) { flush(); } next; }
        next if $l =~ /^\d{1,2}$/ && !$cur;                 # orrialde-zenbakia
        next if $l =~ /^\d{1,2}$/;                          # orrialde-zenbakia (goiburua)
        next if $l =~ /^[‘’']{2}$/;                         # aipu-markak
        next if $l =~ /^(?:(?:\d{1,3}\s+)?Permanezca\b.*|atento a la|campaña para|conocer esta|nueva medida)$/;   # kanpainarako gordetako neurriak

        # Kapitulua: "01     REPARAR"
        if ($l =~ /^0(\d)\s{2,}(\p{Lu}[\p{Lu}\s]+)$/) {
            flush(); $kapitulua = "0$1 $2"; $atala = ''; next;
        }
        # Kapitulu-izenburuaren jarraipena (letra larriz bakarrik, unitaterik gabe)
        if (!$cur && $atala eq '' && $kapitulua ne '' && $l =~ /^[\p{Lu}\s]+$/ && length($l) < 40) {
            $kapitulua .= " $l"; next;
        }
        # Atala: "1.1 LA ADMINISTRACIÓN SERÁ" (+ hurrengo lerroa larriz)
        if ($l =~ /^(\d{1,2}\.\d{1,2})\s+(\p{Lu}.*)$/ && $2 eq uc($2)) {
            flush(); $atala = "$1 $2"; next;
        }
        if (!$cur && $atala ne '' && $l =~ /^[\p{Lu}\s,ÁÉÍÓÚÑÜ\-]+$/ && length($l) < 60) {
            $atala .= " $l"; next;
        }
        # Neurri zenbakiduna: "12      TITULUA. testua"
        if ($l =~ /^(\d{1,3})\s+([«"“]?\p{Lu}(?:\p{Lu}|[\s,]+\p{Lu}).*)$/ && $1 > $last && $1 <= $last + 4) {
            flush(); $last = $1;
            $cur = { id => sprintf('PP-N%03d', $1), atala => ($atala || $kapitulua), orria => $orria, testua => $2 };
            next;
        }
        # Bestela: uneko unitateari gehitu, edo sarrera-paragrafo berria hasi
        if ($cur) { $cur->{testua} .= "\n$l"; }
        else {
            $intro_n++;
            $cur = { id => sprintf('PP-I%02d-%02d', $orria, $intro_n), atala => ($atala || $kapitulua || 'Presentación'), orria => $orria, testua => $l };
        }
    }
    # Sarrera-paragrafoak ez dira orrialdez orrialde jarraitzen; neurriak bai
    flush() if $cur && $cur->{id} =~ /^PP-I/;
}
flush();

for my $u (@units) {
    my $a = $u->{atala}; $a =~ s/\s+/ /g;
    print join("\t", $u->{id}, $a, $u->{orria}, $u->{testua}), "\n";
}
