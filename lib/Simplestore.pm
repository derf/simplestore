## Library for the Simplestore format
## Copyright © 2009 by Daniel Friesel <derf@derf.homelinux.org>
## License: WTFPL <http://sam.zoy.org/wtfpl>
package Simplestore;
use strict;
use warnings;
use Carp;
use base 'Exporter';

our @EXPORT_OK = ('load', 'save');
my $VERSION = '0.1';

sub load {
	my ($file, $store) = @_;
	my @keys;

	open(my $handle, '<', $file) or confess("Cannot open $file for reading: $!");

	while (<$handle>) {
		chomp;
		if ($_ !~ / ^ (\S+) \s+ (.*) $ /x) {
			next;
		}
		my ($key, $value) = ($1, $2);

		if (exists($store->{$key}) and grep {$_ eq $key} @keys) {
			$store->{$key} .= "\n$value";
		} else {
			$store->{$key} = $value;
			push(@keys, $key);
		}
	}

	close($handle) or confess("Cannot close $file: $!");
	return($store);
}

sub save {
	my ($file, $store) = @_;

	open(my $handle, '>', $file) or confess("Cannot open $file for writing: $!");
	foreach my $key (keys(%{$store})) {
		if ($key !~ / ^ \w+ $ /x) {
			confess("Invalid key name: May only contain alphanumeric and _");
		}
		foreach (split(/\n/, $store->{$key})) {
			print $handle "$key\t$_\n";
		}
	}
	close($handle) or confess("Cannot close $file: $!");
	return 1;
}

1;

__END__

=head1 NAME

Simplestore - simple storage format for hash refs

=head1 SYNOPSIS


  use Simplestore;

  # somefile contains:
  #   word purrl
  #   foo eggs
  my $hash = Simplestore::load('somefile');
  say $hash->{word}; # purrl

  $hash->{foo} = 'bar';
  $hash->{sentence} = "Mind the\nnewnile.";
  Simplestore::save('somefile', $hash);

  # somefile contains:
  #   word purrl
  #   foo bar
  #   sentence Mind the
  #   sentence newline.

=head1 DESCRIPTION

B<Simplestore> is a perl library to store hashes in a very simple,
easy-to-parse file format.

Note that it can only store simple hashes with string/digit values and
word keys (the key must match \w+, like a perl variable name for example).
References or any other complex stuff are not supported.

=head1 FUNCTIONS

Note: The function names are quite generic, so by default they are not
exported.  Use C<< use Simplestore qw/load save/ >> if you want to use them
directly.

=over

=item B<Simplestore::load>(I<storefile>[, I<hashref>])

Load the hash saved in I<storefile>. Returns a hash ref containing the hash
saved in I<storefile>.

If I<hashref> is specified, I<storefile> will not be loaded into an empty hash,
but into I<hashref>. However, keys in I<storefile> overwrite those in I<hashref>.

=item B<Simplestore::save>(I<storefile>, I<hashref>)

save I<hashref> in I<storefile>. Returns nothing.

=back

=head1 STORAGE FORMAT

The store file contains key-value-pairs, each of them separated by a newline,
the key and value are separated by a single tab.
If a value contains newlines, they will be printed, but the next line(s) will be
prefixed by the key. For a little example, see SYNOPSIS.

=head1 MOTIVATION

B<Simplestore> aims to provide a common, simple format to store data.
The format is extremely easy to parse in almost all languages, even C or Shell,
thus Simplestore should offer a good way to exchange non-complex data between
apps of all kinds.

=head1 AUTHOR

Copyright (C) 2009 by Daniel Friesel.
Licensed under the terms of the WTFPL E<lt>http://sam.zoy.org/wtfplE<gt>.
