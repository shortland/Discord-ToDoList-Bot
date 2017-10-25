#!/usr/bin/perl

package Methods::Remove;

use v5.10;
use strict;
use warnings;

use Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(remove_item);
our @EXPORT = qw(remove_item);

use File::Slurp;
use JSON;

sub remove_item {
	my ($path, $userID, $dataNum) = @_;

	my $original_hash = read_file($path);
	my $c_json = decode_json($original_hash)->{$userID};

	if (!defined $c_json) {
		return "You don't have any items to do!";
	}
	else {
		return remove_english_format($original_hash, $dataNum, $path, $userID);
	}
}

sub remove_english_format {
	my ($original_hash, $num, $path, $userID) = @_;

	my $stringBuilder = "";
	my $counter;
	my $data = decode_json($original_hash);
	foreach my $itemTitle (@{$data->{$userID}{items}}) {
		#$stringBuilder .= "" . ++$counter . ".) " . $itemTitle->{name} . "\n" if (!$itemTitle->{done});
		if (++$counter =~ /^($num)$/) {
			#delete $data->{$userID}{items}[$counter - 1];
			splice @{$data->{$userID}{items}}, ($counter-1), 1;
			# this would be for marking is complete, not removing.
			#$data->{$userID}{items}[$counter - 1]{"done"} = JSON::true;
			$data = encode_json($data);
			write_file($path, $data);
			return "Item #" . $num . " has been removed";
		}
		else {
			#return "er: cannot locate";
		}
	}
	return "Couldn't find that item";
	#return "**To Do List:**\n" . $stringBuilder;
}

1;