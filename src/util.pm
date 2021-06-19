#!/usr/local/bin/perl -w
#use strict;
use warnings;
use IO::Socket;

package util;

sub fix_word {
  my($word) = $_[0];

  $word =~ tr/A-Z/a-z/; # lowercase it
  $word =~ s/-/DASH/g;
  $word =~ s/\W//g;     # remove non-alhanumeric chars
  $word =~ s/\d//g;
  $word =~ s/_.,"'//g;
  $word =~ s/DASH/-/g;
  $word =~ s/-$//g;
  $word =~ s/^-//g;
  return($word);
}

1;
