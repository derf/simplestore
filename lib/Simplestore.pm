#!/usr/bin/env perl
## Library for the Simplestore format
## Copyright © 2009 by Daniel Friesel <derf@derf.homelinux.org>
## License: WTFPL <http://sam.zoy.org/wtfpl>
use strict;
use warnings;
use Carp;

our (@ISA, @EXPORT, $VERSION);
require Exporter;
@ISA = ('Exporter');
@EXPORT = ('load', 'save');
$VERSION = '1.0';

sub load {
	my $file = shift;
	my ($store, $key, $value);
	$store = shift if @_;
	open(my $handle, '<', $file) or confess("Cannot read $file: $!");
	while (<$handle>) {
		chomp;
		/^(\S+)\s+(.*)$/ or next;
		($key, $value) = ($1, $2);
		if (exists($store->{$key})) {
			$store->{$key} .= "\n$value";
		} else {
			$store->{$key} = $value;
		}
	}
	close($handle);
	return($store);
}

sub save {
	my ($file, $store) = @_;
	my $key;
	open(my $handle, '>', $file) or confess("Cannot open $file: $!");
	foreach $key (keys(%$store)) {
		foreach (split(/\n/, $store->{$key})) {
			print $handle "$key\t$_\n";
		}
	}
	close($handle);
}

1;
