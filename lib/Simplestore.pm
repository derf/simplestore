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

__END__

=head1 NAME

Simplestore - simple storage format for hash refs

=head1 SYNOPSIS


  use Simplestore;

  # somefile contains:
  #   word purrl
  #   foo eggs
  my $hash = load('somefile');
  say $hash->{word}; # purrl

  $hash->{foo} = 'bar';
  $hash->{word} = "Yeah, this is more thon one\nword, I know";
  save('somefile', $hash);

  # somefile contains:
  #   word Yeah, this is more than one
  #   word word, I know
  #   foo bar

=head1 DESCRIPTION

B<Simplestore> is a perl library to store hashes in a very simple,
easy-to-parse file format.

=head1 FUNCTIONS

=over

=item B<load>(I<storefile>[, I<hashref>])

Load the hash saved in I<storefile>. Returns a hash ref containing the hash
saved in I<storefile>.

If I<hashref> is specified, I<storefile> will not be loaded into an empty hash,
but into I<hashref>. However, keys in I<storefile> overwrite those in I<hashref>.

=item B<save>(I<storefile>, I<hashref>)

save I<hashref> in I<storefile>. Returns nothing.

=back

=head1 COPYRIGHT

Copyright (C) 2009 by Daniel Friesel.
Licensed under the terms of the WTFPL <http://sam.zoy.org/wtfpl>.
