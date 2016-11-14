#!/usr/bin/env perl

$ARGV[0] =~ s/\\t/\t/;
$ARGV[0] =~ s/\\n/\n/;

my $v = sprintf shift @ARGV, @ARGV;
$v =~ s/\0//;
print $v;
