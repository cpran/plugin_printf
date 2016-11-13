#!/usr/bin/env perl

use warnings;
use strict;
use diagnostics;

my $file = shift @ARGV;
open(my $fh, ">>", $file)
  or die "Can't open < $file: $!";

$ARGV[0] =~ s/\\t/\t/;
$ARGV[0] =~ s/\\n/\n/;
printf $fh @ARGV;
