#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;

my $heading_prefix = '';
my $toc_prefix = '';
my $print_toc = 0;
my $print_body = 1;

GetOptions(
    "heading-prefix=s" => \$heading_prefix,
    "toc-prefix=s" => \$toc_prefix,
    "body!" => \$print_body,
    "toc!" => \$print_toc,
);

my $toc = '';
my $body = '';
for my $filename (@ARGV) {
    my ($lib) = ($filename =~ m,lib/([^\.]+),);
    next unless $lib;
    $toc .= "$toc_prefix* [$lib](#$lib)\n";
    $body .= "\n$heading_prefix# $lib\n";
    open my $fh, "<", $filename or die "$!";
    my $curline = 0;
    while (<$fh>) {
        $curline += 1;
        if ($curline == 1) {
            next;
        }
        if (/^# (#+)\s+(.*)/) {
            $toc .= "$toc_prefix\t* [$2](#$2)\n";
            $body .= "\n$heading_prefix$1 $2\n\n";
            $body .= "[source](./$filename#L$curline)\n";
            $body .= "[test](./test/$lib/$2.tsht)\n";
        } elsif (/^#\s?(.*)/) {
            $body .= "$1\n";
        }
    }
}
print $toc if $print_toc;
print $body if $print_body;
