#!/usr/bin/env perl

require Encode;

my $file = shift @ARGV;
open(my $fh, ">>", $file)
  or die "Can't open < $file: $!";

$ARGV[0] =~ s/\\t/\t/g;
$ARGV[0] =~ s/\\n/\n/g;

my $v = sprintf shift @ARGV, map { Encode::decode_utf8($_) } @ARGV;
$v =~ s/\0//;
print $fh $v;
