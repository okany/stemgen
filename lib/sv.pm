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
use IO::Socket;
use corpus;

###
###  package for processing successor variety type conflation algorithms
###
package sv;

#
# dump prefix hash content
sub dump_prefix_hash {
  my($self) = @_;

  for my $subs (keys %{$self->{_pfix}} ) {
    print "SUBS=$subs SUCC=$self->{_pfix}->{$subs}->{succ} FREQ=$self->{_pfix}->{$subs}->{freq} \n";
  }
}

#
# create a new prefix hash
#
sub create_prefix_hash {
  my($self) = @_;

  # create a prefix hash table for each word
  for my $word (keys %{$self->{_corp}->{_wlist}} ) {

    # initialize the predessor
    $pdes = substr($word,0,1);
    if(!defined($self->{_pfix}->{$pdes})){
      # initialize the number of successors
      $self->{_pfix}->{$pdes}->{succ} = 0;
      # initialize the frequency of words with this suffix
      $self->{_pfix}->{$pdes}->{freq} = 1;
    }
    else {
      # increment the frequency of words with this suffix
      $self->{_pfix}->{$pdes}->{freq} ++;
    }

    # generate a hash for all prefixes
    for($i=2;$i<=length($word);$i++){
      $subs = substr($word,0,$i);
      if(!defined($self->{_pfix}->{$subs})){
	# initialize the number of successors
	$self->{_pfix}->{$subs}->{succ} = 0;
	# initialize the frequency of words with this suffix
	$self->{_pfix}->{$subs}->{freq} = 1;
	# increment the number of successors of my predessor
	$self->{_pfix}->{$pdes}->{succ}++;
      }
      else {
	# increment the frequency of words with this suffix
	$self->{_pfix}->{$subs}->{freq}++;
      }
      # update the predessor
      $pdes = $subs;
    }
  }

  #$self->dump_prefix_hash;
}

#
# analyze the prefix hash
#
sub analyze_prefix_hash {
  my($self) = @_;

  for my $subs (keys %{$self->{_pfix}} ) {
    if($self->{_pfix}->{$subs}->{freq} > 11) {
      print "possible prefix=$subs\n";
    }
  }
}

#
# process a corpus to create prefix hash and calculate entropies
#
sub process_corpus {

  # create hash table for prefixes
  $_[0]->create_prefix_hash;

  #$_[0]->analyze_prefix_hash;

  # calculate entropies
  $_[0]->calc_entropies;

}

#
# calculate entropies
#
sub calc_entropies {
  my($self) = @_;

  # create a prefix hash table for each word
  for my $this (keys %{$self->{_pfix}} ) {
    # calculate entropy
    for ($ind=97, $entropy=0; $ind<123 ; $ind++){
      # calculate entropy for each character
      $psucc = $this.chr($ind);
      if(defined($self->{_pfix}->{$psucc}->{freq})){
	$ratio = $self->{_pfix}->{$psucc}->{freq}/$self->{_pfix}->{$this}->{freq};
	#print "$this: $self->{_pfix}->{$this}->{freq} $self->{_pfix}->{$psucc}->{freq}\n";
	$entropy -= (($ratio * log($ratio))/$self->{_log2});
      }
    }
    $self->{_pfix}->{$this}->{entropy} = $entropy;
    #print "$this: $self->{_pfix}->{$this}->{entropy}\n";
  }
}

#
# reset segments
#
sub reset_segments {
  $_[0]->{_segnum} = 0;
}

#
# add a new segment
#
sub add_segment {
  
  $_[0]->{_segment}[$_[0]->{_segnum}++] = $_[1];
}

#
# display all segments
#
sub display_segments {
  my($self, $word) = @_;

  print "WORD=$word has $self->{_segnum} segments:\n";
  for($i=0;$i<$self->{_segnum};$i++){
    $this = substr($word,0,$self->{_segment}[$i]);
    print "SEGMENT=$this\n";
  }
}

#
# determine the stem of a word
#
sub determine_stem {
  my($self, $word) = @_;
  $sub0 = substr($word,0,$self->{_segment}[0]);
  if(($self->{_segnum} > 1) &&
     defined($self->{_pfix}->{$sub0}->{freq}) &&
     $self->{_pfix}->{$sub0}->{freq}>12) {
    $sub1 = substr($word,0,$self->{_segment}[1]);
    return $sub1;
  }
  else {
    return $sub0;
  }
}

#
# main stemming function
#
sub stem {

  my($self, $word, $debug) = @_;

  # reset segment array
  $self->reset_segments();

  for($i=2;$i<length($word)-1;$i++){
    $pred = substr($word,0,$i-1);
    $this = substr($word,0,$i);
    $succ = substr($word,0,$i+1);

    if($i == $self->{_cutoff}){ # cutoff rule
      if ($debug) {
	print "$word/$this: reached the cuttof value=$self->{_cutoff} \n";
      }
      $self->add_segment($i);
    }
    elsif(defined($self->{_corp}->{_wlist}{$this})){ # there exist a corpus word
      if ($debug) {
	print "$word/$this: this is a corpus word \n";
      }
      $self->add_segment($i);
    }
    elsif(defined($self->{_pfix}->{$succ}->{succ})){
      # peak and plateau
      if(($self->{_pfix}->{$this}->{succ} > $self->{_pfix}->{$pred}->{succ}) &&
	 ($self->{_pfix}->{$this}->{succ} > $self->{_pfix}->{$succ}->{succ})) {
        # peak and plateau
	if ($debug) {
	  print "$word/$this: peak and plateau pred=$self->{_pfix}->{$pred}->{succ} this=$self->{_pfix}->{$this}->{succ} succ=$self->{_pfix}->{$succ}->{succ} \n";
	}
	$self->add_segment($i);
      }
      elsif ($self->{_pfix}->{$this}->{entropy}>=5){
	if ($debug) {
	  print "$word/$this: entropy=$self->{_pfix}->{$this}->{entropy}\n";
	}
	$self->add_segment($i);
      }
    }
  }
  $self->add_segment(length($word));

  if($debug) {
    $self->display_segments($word);
  }

  return $self->determine_stem($word);
}

#
# initialize a successor variety algorithm instance
#
sub new {
  my ($self) = $_[0];
  my $objref = {
		_cutoff => $_[2],
		@_segment => (),
		_segnum => 0,
		_sigma => 13*27,
		_log2 => log(2),
		_corp => $_[1],
		%_pfix => ()
	       };

  my ($class) = ref($self) || $self;

  bless $objref, $class;

  $objref->process_corpus;

  return $objref;

}
1 ;
