#!/usr/bin/perl

package Methods::Insert;

use v5.10;
use strict;
use warnings;

use Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(insert_item);
our @EXPORT = qw(insert_item);

use File::Slurp;
use JSON;

sub insert_item {
	my ($path, $userID, $decode, $data) = @_;
	
	my $c_json = read_file($path);
	$c_json = decode_json($c_json);

	if (!defined $c_json->{$userID}) {

		$c_json->{$userID}->{"items"}->[0]{"name"} = $data;
		$c_json->{$userID}->{"items"}->[0]{"create"} = time;
		$c_json->{$userID}->{"items"}->[0]{"done"} = JSON::false;
		$c_json = encode_json($c_json);

		write_file($path, $c_json);
		return "Your list has been started!\nThat's been added to your list!";
	}
	else {
		# already have a pre-existing key, insert new item
		my $newIndex = $c_json->{$userID}{items};
		$newIndex = scalar @{$newIndex};

		$c_json->{$userID}->{"items"}->[$newIndex]{"name"} = $data;
		$c_json->{$userID}->{"items"}->[$newIndex]{"create"} = time;
		$c_json->{$userID}->{"items"}->[$newIndex]{"done"} = JSON::false;
		$c_json = encode_json($c_json);

		write_file($path, $c_json);
		return "That's been added to your list! (#".(++$newIndex).")";
	}
}
1;