#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 7;
my $testfile = "/tmp/simplestore-test-$$";

my $hash;

BEGIN {use_ok('Simplestore')}
require_ok('Simplestore');

$hash = {foo => "bar\nbar"};
ok(save($testfile, $hash), 'save hash 1');
undef $hash;

ok($hash = load($testfile), 'load hash 1');
is($hash->{foo}, "bar\nbar", 'successful storage & load');

$hash = {dude => "dudette\nfoo"};
$hash = load($testfile, $hash);
is($hash->{dude}, "dudette\nfoo", 'load: preserve hash keys');

$hash = {foo => "moose\nbaz"};
$hash = load($testfile, $hash);
is($hash->{foo}, "bar\nbar", 'load: overwrite conflicting hash keys');

unlink($testfile);
