#!/usr/bin/perl

use v5.10;
use strict;
use warnings;

use File::Slurp;
use JSON;

use Methods::Insert;
use Methods::Read;
use Methods::Remove;

my $path = "data/items.json";
my ($method, $ownerID, $data) = @ARGV;

if ($method =~ /^read$/) {
	print read_item($path, $ownerID, 1);
	exit;
}
elsif ($method =~ /^insert$/) {
	print insert_item($path, $ownerID, 1, $data);
	exit;
}
elsif ($method =~ /^remove$/) {
	print remove_item($path, $ownerID, $data);
	exit;
}
else {
	print "Unrecognized method (".$method.")";
	exit;
}