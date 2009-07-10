#!/usr/bin/env perl
use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
	module_name => 'Simplestore',
	test_files => 'test/simplestore.t',
);
$build->create_build_script;
