#!/usr/bin/env perl

$ARGV[0] =~ s/\\t/\t/g;
$ARGV[0] =~ s/\\n/\n/g;

my $v = sprintf shift @ARGV, @ARGV;
$v =~ s/\0//;
print $v;
