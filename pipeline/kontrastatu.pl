#!/usr/bin/perl
# v0.3 kontrastea: Claude (nagusia) vs Decider (bigarren iritzia) — gaiak eta "ez du aipatzen" bakarrik.
# Erabilera: perl kontrastatu.pl <claude-v0.3.tsv> <decider.jsonl>
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';
my ($tsv, $jsonl) = @ARGV;
my $MUGA = 0.5;
my @G = map { sprintf 'G%02d', $_ } 1 .. 21;     # G22 eta G99: Decider-ek ez ditu
my @S = map { sprintf 'S%02d', $_ } 1 .. 10;

my %dec;
open my $J, '<:utf8', $jsonl or die $!;
while (my $l = <$J>) {
    my ($id) = $l =~ /^\{"id":"([^"]+)"/ or next;
    my %r;
    while ($l =~ /"(G\d\d)":\{"type":"noul","noul":([0-9.eE+-]+)/g) { $r{$1} = $2 }
    while ($l =~ /"(S\d\d)":\{"type":"choice","choice":"([^"]*)".*?"confidence":([0-9.eE+-]+)/g) { $r{$1} = $2; $r{"$1:c"} = $3 }
    $dec{$id} = \%r;
}

my (%n, @des);
open my $T, '<:utf8', $tsv or die $!;
while (<$T>) {
    next if /^#|^id\t/; chomp;
    my @c = split /\t/; my ($id, $gaiak, $s) = @c[0, 1, 9];
    my $d = $dec{$id} or next;
    my %cg = map { $_ => 1 } split /,/, $gaiak;
    my @nag = grep { $_ ne 'G22' && $_ ne 'G99' } split /,/, $gaiak;
    if (@nag) { $n{nag}++; if (($d->{$nag[0]} // 0) >= $MUGA) { $n{nag_ok}++ } else { push @des, sprintf '%s gaia nagusia %s: Decider p=%.2f', $id, $nag[0], $d->{$nag[0]} // 0 } }
    for my $g (@G) {
        my $dc = ($d->{$g} // 0) >= $MUGA ? 1 : 0; my $cc = $cg{$g} ? 1 : 0;
        $n{tp}++ if $dc && $cc; $n{fp}++ if $dc && !$cc; $n{fn}++ if !$dc && $cc;
        push @des, sprintf '%s %s: Claude=%s Decider p=%.2f', $id, $g, $cc ? 'bai' : 'ez', $d->{$g} // 0 if $dc != $cc && abs(($d->{$g} // 0) - 0.5) > 0.3;
    }
    my %cs = map { (split /=/)[0] => 1 } grep { /=/ } split /;/, $s;
    for my $k (@S) {
        my $dez = (($d->{$k} // 'ez') eq 'ez') ? 1 : 0; my $cez = $cs{$k} ? 0 : 1;
        $n{s_tot}++; $n{s_ok}++ if $dez == $cez;
        push @des, sprintf '%s %s: Claude=%s Decider=%s (%.2f)', $id, $k, $cez ? 'ez' : 'jarrera', $d->{$k} // '?', $d->{"$k:c"} // 0 if $dez != $cez;
    }
}
my $prec = $n{tp} / (($n{tp} + $n{fp}) || 1); my $rec = $n{tp} / (($n{tp} + $n{fn}) || 1);
printf "Gaia nagusia (Claude) Decider-ek ere: %d/%d (%.0f%%)\n", $n{nag_ok}, $n{nag}, 100 * $n{nag_ok} / $n{nag};
printf "Gaiak G01–G21: precision %.0f%% · recall %.0f%% (Claude erreferentzia)\n", 100 * $prec, 100 * $rec;
printf "Baieztapenak, 'ez du aipatzen' bai/ez: %d/%d (%.1f%%)\n", $n{s_ok}, $n{s_tot}, 100 * $n{s_ok} / $n{s_tot};
printf "\nBerrikusteko desadostasunak (%d):\n", scalar @des; print "  $_\n" for @des;
