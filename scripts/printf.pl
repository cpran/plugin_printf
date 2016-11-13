#!/usr/bin/env perl

use warnings;
use strict;
use diagnostics;

$ARGV[0] =~ s/\\t/\t/;
$ARGV[0] =~ s/\\n/\n/;
printf @ARGV;
