#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'AnyEvent::Telegram' ) || print "Bail out!\n";
}

diag( "Testing AnyEvent::Telegram $AnyEvent::Telegram::VERSION, Perl $], $^X" );
