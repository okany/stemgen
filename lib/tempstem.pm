#!/usr/local/bin/perl -w
#
# This file is part of the Stemming Algorithms Application Generator Software
# distribution (https://github.com/okany/stemgen).
# Copyright (c) 2009 - 2021 Okan Yilmaz
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
use warnings;
use corpus;
use sv;

#
# stemming algorithm package template
#
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
