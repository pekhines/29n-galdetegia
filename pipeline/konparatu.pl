#!/usr/bin/perl
# Decider-en sailkapena eta Claude-ren kalibrazio-etiketak konparatzen ditu.
# Erabilera: perl konparatu.pl decider.jsonl kalibrazioa-claude.tsv
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';

my ($jsonl, $tsv) = @ARGV;
my @GROUPS = qw(langileak pentsiodunak prekarioak gazteak emakumeak etorkinak autonomoak enpresahandiak errentaaltuak);
my @S = map { sprintf 'S%02d', $_ } 1 .. 10;
my $GAIA_MUGA = 0.5;

# --- Decider ---
my %dec;
open my $J, '<:utf8', $jsonl or die $!;
while (my $l = <$J>) {
    my ($id) = $l =~ /^\{"id":"([^"]+)"/ or next;
    my %r;
    while ($l =~ /"(G\d\d|D6)":\{"type":"noul","noul":([0-9.eE+-]+)/g) { $r{$1} = $2 }
    while ($l =~ /"(D[1-4]|D7_\w+|S\d\d)":\{"type":"choice","choice":"([^"]*)".*?"confidence":([0-9.eE+-]+)/g) { $r{$1} = $2; $r{"$1:c"} = $3 }
    if ($l =~ /"D5":\{"type":"score","score":([0-9.eE+-]+)/) { $r{D5} = $1 }
    $dec{$id} = \%r;
}

# --- Claude ---
my @rows;
open my $T, '<:utf8', $tsv or die $!;
while (<$T>) {
    next if /^#/ || /^id\t/; chomp;
    my ($id, $gaiak, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $s) = split /\t/;
    my %d7 = map { $_ => 'ez' } @GROUPS;
    for (split /;/, $d7) { my ($g, $v) = split /=/; $d7{$g} = $v if $v; }
    my %ss = map { $_ => 'ez' } @S;
    for (split /;/, $s) { my ($k, $v) = split /=/; $ss{$k} = $v if $v; }
    push @rows, { id => $id, G => [split /,/, $gaiak], D1 => $d1, D2 => $d2, D3 => $d3, D4 => $d4, D5 => $d5, D6 => $d6, D7 => \%d7, S => \%ss };
}

sub ok { my ($allowed, $got) = @_; return scalar grep { $_ eq $got } split /\|/, $allowed; }

my (%n, %hit, @desados, %conf);
for my $r (@rows) {
    my $d = $dec{$r->{id}} or do { print "FALTA Decider: $r->{id}\n"; next };
    # Gaiak
    my %cg = map { $_ => 1 } @{ $r->{G} };
    my %dg = map { $_ => 1 } grep { ($d->{$_} // 0) >= $GAIA_MUGA } map { sprintf 'G%02d', $_ } 1 .. 21;
    my $nag = $r->{G}[0];
    $n{'Gaia nagusia'}++; $hit{'Gaia nagusia'}++ if $dg{$nag};
    push @desados, "$r->{id} gaia nagusia $nag: Decider p=" . sprintf('%.2f', $d->{$nag} // 0) unless $dg{$nag};
    for my $g (keys %cg) { $n{'Gaiak (recall)'}++; $hit{'Gaiak (recall)'}++ if $dg{$g}; }
    for my $g (keys %dg) { $n{'Gaiak (precision)'}++; $hit{'Gaiak (precision)'}++ if $cg{$g}; }
    # D1-D4
    for my $k (qw(D1 D2 D3 D4)) {
        my $got = $d->{$k} // '?'; my $c = $d->{"$k:c"} // 0;
        $n{$k}++;
        if (ok($r->{$k}, $got)) { $hit{$k}++; push @{ $conf{ok} }, $c }
        else { push @{ $conf{bad} }, $c; push @desados, sprintf "%s %s: Claude=%s Decider=%s (%.2f)", $r->{id}, $k, $r->{$k}, $got, $c }
    }
    # D5
    $n{D5}++;
    my $s5 = $d->{D5} // -9;
    if (abs($s5 - $r->{D5}) <= 0.75) { $hit{D5}++ } else { push @desados, sprintf "%s D5: Claude=%s Decider=%.2f", $r->{id}, $r->{D5}, $s5 }
    # D6
    $n{D6}++;
    my $p6 = ($d->{D6} // 0) >= 0.5 ? 1 : 0;
    if ($p6 == $r->{D6}) { $hit{D6}++ } else { push @desados, sprintf "%s D6: Claude=%s Decider p=%.2f", $r->{id}, $r->{D6}, $d->{D6} // 0 }
    # D7
    for my $g (@GROUPS) {
        my $k = "D7_$g"; my $got = $d->{$k} // '?'; my $c = $d->{"$k:c"} // 0;
        my $cl = $r->{D7}{$g};
        my $bucket = ($cl eq 'ez') ? 'D7 (Claude: ez)' : 'D7 (Claude: eragina)';
        $n{$bucket}++;
        if (ok($cl, $got)) { $hit{$bucket}++; push @{ $conf{ok} }, $c }
        else { push @{ $conf{bad} }, $c; push @desados, sprintf "%s %s: Claude=%s Decider=%s (%.2f)", $r->{id}, $k, $cl, $got, $c }
    }
    # S
    for my $k (@S) {
        my $got = $d->{$k} // '?'; my $c = $d->{"$k:c"} // 0;
        my $cl = $r->{S}{$k};
        my $bucket = ($cl eq 'ez') ? 'Baieztapenak (Claude: ez)' : 'Baieztapenak (Claude: jarrera)';
        $n{$bucket}++;
        if (ok($cl, $got)) { $hit{$bucket}++; push @{ $conf{ok} }, $c }
        else { push @{ $conf{bad} }, $c; push @desados, sprintf "%s %s: Claude=%s Decider=%s (%.2f)", $r->{id}, $k, $cl, $got, $c }
    }
}

printf "Unitateak: %d\n\n%-32s %8s %6s\n", scalar(@rows), 'Dimentsioa', 'Adost', '%';
for my $k ('Gaia nagusia', 'Gaiak (recall)', 'Gaiak (precision)', qw(D1 D2 D3 D4 D5 D6), 'D7 (Claude: eragina)', 'D7 (Claude: ez)', 'Baieztapenak (Claude: jarrera)', 'Baieztapenak (Claude: ez)') {
    next unless $n{$k};
    printf "%-32s %4d/%-4d %5.0f%%\n", $k, $hit{$k} // 0, $n{$k}, 100 * ($hit{$k} // 0) / $n{$k};
}
sub stats { my @a = sort { $a <=> $b } @_; return '-' unless @a; my $m = 0; $m += $_ for @a; sprintf 'n=%d batezbestekoa=%.2f mediana=%.2f', scalar @a, $m / @a, $a[int(@a / 2)] }
print "\nDecider-en konfiantza (choice galderak):\n  adostasunean:   ", stats(@{ $conf{ok} // [] }), "\n  desadostasunean: ", stats(@{ $conf{bad} // [] }), "\n";
for my $m (0.6, 0.7, 0.8, 0.9) {
    my $okh = grep { $_ >= $m } @{ $conf{ok} // [] }; my $badh = grep { $_ >= $m } @{ $conf{bad} // [] };
    printf "  muga %.1f: %d erabaki onartuko lirateke automatikoki, horietatik %d desadostasun (%.1f%%)\n", $m, $okh + $badh, $badh, ($okh + $badh) ? 100 * $badh / ($okh + $badh) : 0;
}
print "\nDesadostasunak:\n", map { "  $_\n" } @desados;
