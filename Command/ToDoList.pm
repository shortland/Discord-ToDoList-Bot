package Command::ToDoList;

use v5.10;
use strict;
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw(cmd_todolist);

use Mojo::Discord;
use Bot::Goose;

use File::Slurp;

###########################################################################################
# Command Info
my $command = "todolist";
my $access = 0; # Public
my $description = "This is a todolist command for building new actual commands";
my $pattern = '^(~todolist|~t)\s?(\w+)?\s?(.+)?';
my $function = \&cmd_todolist;
my $usage = "N/A";
###########################################################################################

sub new
{
    my ($class, %params) = @_;
    my $self = {};
    bless $self, $class;
     
    # Setting up this command module requires the Discord connection 
    $self->{'bot'} = $params{'bot'};
    $self->{'discord'} = $self->{'bot'}->discord;
    $self->{'pattern'} = $pattern;

    # Register our command with the bot
    $self->{'bot'}->add_command(
        'command'       => $command,
        'access'        => $access,
        'description'   => $description,
        'usage'         => $usage,
        'pattern'       => $pattern,
        'function'      => $function,
        'object'        => $self,
    );
    
    return $self;
}
#
sub cmd_todolist
{
    my ($self, $channel, $author, $msg) = @_;

    my $args = $msg;
    my $pattern = $self->{'pattern'};

    my $method = $2;
    my $title = $3;
    
    my $discord = $self->{'discord'};
    my $replyto = '<@' . $author->{'id'} . '>';
    my $response = $replyto . ", ";

    # show your todo list
    if ($method =~ /^(| |\.)$/) {
        $response .= `./main.pl read $author->{'id'} null`;
        $discord->send_message($channel, $response);
    }
    elsif ($method =~ /^new$/) {
        $title =~ s/ /\\ /g;
        $title =~ s/'/\\'/g;
        $response .= `./main.pl insert $author->{'id'} $title`;
        $discord->send_message($channel, $response);
    }
    elsif ($method =~ /^remove$/) {
        if ($title !~ /^\d+$/) {
            $discord->send_message($channel, $response . " please choose a valid number");
        }
        else {
            $response .= `./main.pl remove $author->{'id'} $title`;
            $discord->send_message($channel, $response);
        }
    }
    elsif ($method =~ /^help$/) {
        $discord->send_message($channel, "~t help - shows this\n~t - shows items on your list\n~t new [to-do-list title here] - add a new item to your list\n~t remove [item # to remove]");
    }
    else {

    }
}

1;