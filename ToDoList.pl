#!/usr/bin/env perl

use v5.10;
use strict;
use warnings;

binmode STDOUT, ":utf8";

use Config::Tiny;
use Bot::Goose;
use Command::ToDoList;
use Data::Dumper;

# Fallback to "config.ini" if the user does not pass in a config file.
my $config_file = $ARGV[0] // 'config.ini';
my $config = Config::Tiny->read($config_file, 'utf8');
say localtime(time) . " Loaded Config: $config_file";

my $self = {};  # For miscellaneous information about this bot such as discord id

# Initialize the bot
my $bot = Bot::Goose->new(%{$config});

# Register the commands
# The new() function in each command will register with the bot.
Command::ToDoList->new		('bot' => $bot);

# Start the bot
$bot->start();
