#!/usr/bin/perl
# Garapenerako zerbitzari estatiko txikia (GitHub Pages-en ordez, lokalean probatzeko).
# Erabilera: perl pipeline/zerbitzari.pl [karpeta=docs] [ataka=8080]
use strict; use warnings;
use IO::Socket::INET;
my ($root, $port) = (@ARGV ? $ARGV[0] : 'docs', $ARGV[1] // 8080);
{ my $d = $0; $d =~ s{/?[^/]*$}{}; $d = "." if $d eq ""; chdir "$d/.." or die "chdir: $!"; }
my %MIME = (html => 'text/html; charset=utf-8', css => 'text/css; charset=utf-8', js => 'text/javascript; charset=utf-8',
            json => 'application/json; charset=utf-8', svg => 'image/svg+xml', png => 'image/png', ico => 'image/x-icon', txt => 'text/plain; charset=utf-8');
my $srv = IO::Socket::INET->new(LocalAddr => '127.0.0.1', LocalPort => $port, Listen => 10, ReuseAddr => 1) or die "ataka $port: $!";
$| = 1; print "Zerbitzatzen: http://localhost:$port/ ($root)\n";
while (my $c = $srv->accept) {
    my $req = <$c> // ''; while (my $l = <$c>) { last if $l =~ /^\r?\n$/; }
    my ($path) = $req =~ m{^GET\s+(\S+)};
    my ($code, $type, $body) = (404, 'text/plain', 'Ez da aurkitu');
    if (defined $path) {
        $path =~ s/[?#].*//; $path =~ s/%([0-9A-Fa-f]{2})/chr hex $1/ge; $path .= 'index.html' if $path =~ m{/$};
        if ($path !~ /\.\./) {
            my $f = "$root$path";
            if (-f $f && open my $h, '<:raw', $f) { local $/; $body = <$h>; close $h; my ($e) = $f =~ /\.(\w+)$/; ($code, $type) = (200, $MIME{lc($e // '')} // 'application/octet-stream'); }
        }
    }
    print "$code $req" =~ s/\r?\n$//r, "\n";
    print $c "HTTP/1.0 $code " . ($code == 200 ? 'OK' : 'Not Found') . "\r\nContent-Type: $type\r\nContent-Length: " . length($body) . "\r\nCache-Control: no-store\r\nConnection: close\r\n\r\n$body";
    close $c;
}
