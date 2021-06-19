#!/usr/local/bin/perl -w
#use strict;
use warnings;
use corpus;
use sv;

package <tempstem>;

# <steps>

sub new {
  my ($self) = $_[0];
  my $objref = {
		_c => "[^aeiou]",
		_v => "[aeiouy]",
		_C => "[^aeiou][^aeiouy]*",
		_V => "[aeiouy][aeiou]*",
# <corpus>
# <sv>
		_word => "",
		_name => "<tempstem>"
	       };
  
  my ($class) = ref($self) || $self;

  bless $objref, $class;

  return $objref;
}

1;
