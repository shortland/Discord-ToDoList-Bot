#!/usr/bin/perl

package Methods::Read;

use v5.10;
use strict;
use warnings;

use Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(read_item);
our @EXPORT = qw(read_item);

use File::Slurp;
use JSON;

sub read_item {
	my ($path, $userID, $decode) = @_;

	my $c_json = read_file($path);
	$c_json = decode_json($c_json)->{$userID};

	if ($decode && defined $c_json) {
		$c_json = encode_json($c_json);
	}

	if (!defined $c_json) {
		return "You don't have any items to do!";
	}
	else {
		return read_english_format($c_json);
	}
}

sub read_english_format {
	my ($data) = @_;

	my $stringBuilder = "";
	my $counter;
	$data = decode_json($data);
	foreach my $itemTitle (@{$data->{items}}) {
		$stringBuilder .= "" . ++$counter . ".) " . $itemTitle->{name} . "\n";# if (!$itemTitle->{done});
	}

	return "**To Do List:**\n" . $stringBuilder;
}

1;