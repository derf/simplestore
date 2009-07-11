#!/usr/bin/env perl
use strict;
use warnings;
use Pod::Checker;
use Test::More tests => 8;
my $testfile = "/tmp/simplestore-test-$$";

my $hash;

is(podchecker('lib/Simplestore.pm'), 0, "Valid POD");

BEGIN {use_ok('Simplestore')}
require_ok('Simplestore');

$hash = {foo => "bar\nbar"};
ok(Simplestore::save($testfile, $hash), 'save hash 1');
undef $hash;

ok($hash = Simplestore::load($testfile), 'load hash 1');
is($hash->{foo}, "bar\nbar", 'successful storage & load');

$hash = {dude => "dudette\nfoo"};
$hash = Simplestore::load($testfile, $hash);
is($hash->{dude}, "dudette\nfoo", 'load: preserve hash keys');

$hash = {foo => "moose\nbaz"};
$hash = Simplestore::load($testfile, $hash);
is($hash->{foo}, "bar\nbar", 'load: overwrite conflicting hash keys');

unlink($testfile);
