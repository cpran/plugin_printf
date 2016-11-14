#!/usr/bin/env perl

my $file = shift @ARGV;
open(my $fh, ">>", $file)
  or die "Can't open < $file: $!";

$ARGV[0] =~ s/\\t/\t/;
$ARGV[0] =~ s/\\n/\n/;

my $v = sprintf shift @ARGV, @ARGV;
$v =~ s/\0//;
print $fh $v;
