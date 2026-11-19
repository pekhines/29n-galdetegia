#!/usr/bin/perl
# Podemos 2026 programa ("Así de básico: Paz, casa y trabajo") unitateetan zatitu.
# Erabilera: perl zatitu-podemos.pl podemos-2026.txt > podemos-2026-unitateak.tsv
# Irteera (goibururik gabe): id \t atala \t orria \t testua
#  - Neurri zenbakidunak (1–442, sekuentzia egiaztatuta): POD-NNN; barruko buletak neurrian bertan.
#  - Atal-sarrerako prosa, paragrafoka: POD-pOOO-k (aurkibidea eta azala kanpo).
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';
open my $fh, '<:utf8', $ARGV[0] or die "$ARGV[0]: $!";
local $/; my $all = <$fh>; close $fh;
my @pages = split /\f/, $all;

my @HEADS = ('ASÍ DE BÁSICO: PAZ, CASA Y TRABAJO.', 'LAS CASAS SON PARA VIVIR.', 'LOS PRECIOS TIENEN QUE BAJAR',
  'PAZ. PARAR LAS GUERRAS.', 'TRABAJAR MENOS PARA VIVIR MEJOR.', 'VIDA SOLO HAY UNA. PLANETA SOLO HAY UNO.',
  'VIDAS QUE MEREZCAN LA PENA SER VIVIDAS', 'SERVICIOS PÚBLICOS PARA GARANTIZAR VIDAS DIGNAS',
  'PLANETA SOLO HAY UNO', 'ESPAÑA, REPÚBLICA PLURINACIONAL.');
my %ishead = map { $_ => 1 } @HEADS;

my ($kap, $num, $mode, $cur, $pp, %pcount) = ('', 0, 'none', undef, '');
my @units;
sub clean { my $t = shift; $t =~ s/\s+/ /g; $t =~ s/^ | $//g; $t =~ s/\.$/./; return $t; }
sub flush {
    return unless defined $cur;
    my $t = clean($cur->{txt});
    if ($cur->{id} =~ /^POD-p/ && (() = $t =~ /\S+/g) > 160) {
        # Prosa luzea: esaldi-mugetan ~150 hitzeko zatiak
        my @sent = split /(?<=[.!?])\s+(?=[\p{Lu}¿¡«"])/, $t;
        my ($buf, $k) = ('', 0);
        for my $s (@sent) {
            $buf .= ($buf ? ' ' : '') . $s;
            if ((() = $buf =~ /\S+/g) >= 150) { push @units, [$cur->{id} . chr(97 + $k++), $cur->{atala}, $cur->{orria}, $buf]; $buf = ''; }
        }
        push @units, [$cur->{id} . chr(97 + $k++), $cur->{atala}, $cur->{orria}, $buf] if $buf ne '';
    } else {
        push @units, [$cur->{id}, $cur->{atala}, $cur->{orria}, $t] if length($t) > 3;
    }
    undef $cur;
}

my $pending = '';   # bi lerroko izenburuak lotzeko
for my $pi (2 .. $#pages) {             # 1–2 orriak: azala eta aurkibidea
    my $page = $pi + 1;
    my $txt = $pages[$pi];
    $txt =~ s/(\p{L})-\n\s*(\p{Ll})/$1$2/g;    # marratxoz zatitutako hitzak
    my @lines = split /\n/, $txt;
    for my $l (@lines) {
        my $s = clean($l);
        next if $s eq 'PROGRAMA ELECTORAL' || $s =~ /^\d{1,3}$/;
        # Atal-izenburuak (batzuk bi lerrotan)
        my $try = $pending ? "$pending $s" : $s;
        if ($ishead{$try}) { flush(); $kap = $try; $kap =~ s/\.$//; $mode = 'prosa'; $pending = ''; next; }
        if ($s ne '' && $s eq uc($s) && $s =~ /\p{Lu}{3}/ && !$pending && grep { index($_, $s) == 0 } @HEADS) { $pending = $s; next; }
        $pending = '';
        if ($s eq '') {   # paragrafo-muga prosan
            if ($mode eq 'prosa' && defined $cur && $cur->{txt} =~ /[.:]\s*$/) { flush(); }
            next;
        }
        if ($s =~ /^(\d{1,3})\.\s+(\S.*)$/ && $1 == $num + 1) {
            flush(); $num = $1; $mode = 'neurria';
            $cur = { id => sprintf('POD-%03d', $num), atala => $kap, orria => $page, txt => $2 };
            next;
        }
        if ($mode eq 'prosa') {
            if (!defined $cur) {
                my $k = ++$pcount{$page};
                $cur = { id => sprintf('POD-p%03d-%d', $page, $k), atala => $kap, orria => $page, txt => '' };
            }
            $cur->{txt} .= " $s";
        } elsif ($mode eq 'neurria') {
            $cur->{txt} .= " $s" if defined $cur;
        }
    }
}
flush();
print join("\t", @$_), "\n" for @units;
