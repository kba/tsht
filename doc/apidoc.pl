#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
my $out = '';
for my $filename (@ARGV) {
    my ($lib) = ($filename =~ m/tsht-([^\.]+)/);
    open my $fh, "<", $filename or die "$!";
    my $curline = 0;
    while (<$fh>) {
        $curline += 1;
        if ($curline == 1) {
            next;
        }
        if (/^# (#+\s*(.*))/) {
            $out .= "\n$1\n\n";
            $out .= "[source](./$filename#L$curline)\n";
            $out .= "[test](./test/$lib/$2.tsht)\n";
        } elsif (/^#\s?(.*)/) {
            $out .= "$1\n";
        }
    }
}
print $out;
