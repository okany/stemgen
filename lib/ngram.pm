#!/usr/local/bin/perl -w
#use strict;
use warnings;
use corpus;

package ngram;

sub init_ngram {
  $_[0]->{_corp}->{_wlist}->{$_[1]}->{ngram}->{size}=0;
  $_[0]->{_corp}->{_wlist}->{$_[1]}->{ngram}->{array}=();
}
sub add_ngram {

  my($i, $ng, $index);
  $ng = $_[0]->{_corp}->{_wlist}->{$_[1]}->{ngram};
  for($i=0, $index=$ng->{size};$i<$ng->{size};$i++) {
    if($ng->{array}[$i] gt $_[2]) {
      # insert to this location
      $index = $i;
      $i = $ng->{size};
    }
    elsif ($ng->{array}[$i] eq $_[2]) {
      # it already exists so return
      return;
    }
  }

  # move the following morphemes
  for($i=$ng->{size}; $i>$index;$i--) {
    $ng->{array}[$i]=$ng->{array}[$i-1];
  }

  # insert the new n-gram
  $ng->{array}[$index] = $_[2];

  # increment the size
  $ng->{size}++;
}

sub dump_ngrams {
  my($i, $ng);
  $ng = $_[0]->{_corp}->{_wlist}->{$_[1]}->{ngram};
  print "N-GRAMS FOR $_[1] ARE:\n";
  for($i=0;$i<$ng->{size};$i++) {
    print "$ng->{array}[$i] ";
  }
  print "\n";
}

sub create_ngrams {
  my($i, $word, $subs);
  # create an n-gram hash table for each word
  for my $word (keys %{$_[0]->{_corp}->{_wlist}} ) {
    $_[0]->init_ngram($word);
    for($i=0;$i<=length($word)-$_[0]->{_n};$i++){
      $subs = substr($word,$i,$_[0]->{_n});
      $_[0]->add_ngram($word, $subs);
      #$_[0]->{_corp}->{_wlist}->{$word}->{ngram}{$subs} = 1;
    }
    #$_[0]->dump_ngrams($word);
  }
}

sub common_ngrams {
  my($cm, $i, $j);
  for($i=0,$j=0,$cm=0;($i<$_[1]->{ngram}->{size} && $j<$_[2]->{ngram}->{size});){
    if($_[1]->{ngram}->{array}[$i] eq $_[2]->{ngram}->{array}[$j]) {
      $cm++; $i++; $j++;
    }
    elsif ($_[1]->{ngram}->{array}[$i] lt $_[2]->{ngram}->{array}[$j]) {
      $i++;
    }
    else {
      $j++;
    }
  }
  return $cm;
}

sub insert_cluster {
  my($i);
  for($i=$_[1]->{cnum};($i>$_[2]);$i--) {
    $_[1]->{cluster}[$i] = $_[1]->{cluster}[$i-1];
  }
  $_[1]->{cluster}[$i] = $_[3];
  $_[1]->{cnum}++;
  #print "index=$_[1]->{cluster}[$i] index=$i value=$_[3]\n";
}

sub add_cluster {
  my($i);
  #print "i=$i $_[1]->{cnum} ind=$_[2]\n";
  for($i=0;($i<$_[1]->{cnum});$i++) {
    if($_[1]->{cluster}[$i] == $_[2]) {
      return $i;
    }
    elsif ($_[1]->{cluster}[$i] > $_[2]){
      last;
    }
  }

  $_[0]->insert_cluster($_[1], $i, $_[2]);

  return $i;
}

sub add_clusters {
  my($i);
  #print "i=$i size=$_[1]->{size}\n";
  for($i=0;($i<$_[1]->{size});$i++) {
    #print "index=$_[1]->{array}[$i]->{index}\n";
    $_[0]->add_cluster($_[1], $_[1]->{array}[$i]->{index});
  }
}

sub dump_clusters {
  my($i);
  #print "i=$i size=$_[1]->{size}\n";
  for($i=0;($i<$_[1]->{cnum});$i++) {
    print "$_[0]->{_corp}->{_warr}[$_[1]->{cluster}[$i]]->{word} ";    
  }
  print "\n";
}

sub dump_all_clusters {
  my($i);
  for($i=0;$i<$_[0]->{_corp}->{_wsize};$i++) {
    if($_[0]->{_matrix}[$i]->{cid} == $i) {
      print "CLUSTER $i ";
      $_[0]->dump_clusters($_[0]->{_matrix}[$i]);
    }
  }
}

sub reset_clusters {
  $_[1]->{cnum} = 0;
}

sub find_cluster {
  my($self, $cid) = @_;
  #print "finding cluster $ref->{cid} $cid\n";
  for($ref=$_[0]->{_matrix}[$cid]; 
      $ref->{cid} != $cid; 
      $ref = $_[0]->{_matrix}[$cid]) {
    #print "$ref->{cid} $cid\n";
    $cid = $ref->{cid};
    #die if($ref->{cid}==231);
  };
  return($cid);
}

sub merge_clusters {
  my($i);
  #print "cluster 1 \n";
  #$_[0]->dump_clusters($_[1]);
  #print "cluster 2 \n";
  #$_[0]->dump_clusters($_[2]);
  for($i=0;($i<$_[2]->{cnum});$i++) {
    $_[0]->add_cluster($_[1], $_[2]->{cluster}[$i]);
  }
  #print "merged clusters: \n";
  #$_[0]->dump_clusters($_[1]);
 
}
sub cluster_ngrams {
  my($i, $j, $ind);
  #print "Dumping the matrix".$_[0]->{_corp}->{_wsize}."\n";
  for($i=0;$i<$_[0]->{_corp}->{_wsize};$i++) {
    #$self->{_corp}->{_warr}[$i]->{word};
    #print "Current i=$i \n";
    if(!defined($_[0]->{_matrix}[$i]->{cid})) {
      $_[0]->{_matrix}[$i]->{cid} = $i;
      $_[0]->reset_clusters($_[0]->{_matrix}[$i]);
      #print "i=$i $_[0]->{_matrix}[$i]->{cnum} \n";
      $_[0]->add_cluster($_[0]->{_matrix}[$i], $i);
      $_[0]->add_clusters($_[0]->{_matrix}[$i], $_[0]->{_matrix}[$i]);
      for($j=0;$j<$_[0]->{_matrix}[$i]->{size};$j++) {
	$ind = $_[0]->{_matrix}[$i]->{array}[$j]->{index};
	#print "Current ind=$ind \n";
	if(!defined($_[0]->{_matrix}[$ind]->{cid})){
	  $_[0]->{_matrix}[$ind]->{cid} = $i;
	  $_[0]->reset_clusters($_[0]->{_matrix}[$ind]);
	  #print "i=$i $_[0]->{_matrix}[$i]->{cnum} \n";
	  $_[0]->add_clusters($_[0]->{_matrix}[$i], $_[0]->{_matrix}[$ind]);
	  #$_[0]->dump_clusters($_[0]->{_matrix}[$i]);
	}
	else {
	  my($root);
	  #print "ind=$ind cid=$_[0]->{_matrix}[$ind]->{cid} \n";
	  # need to merge two clusters
	  $root = $_[0]->find_cluster($_[0]->{_matrix}[$ind]->{cid});
	  $_[0]->merge_clusters($_[0]->{_matrix}[$i], $_[0]->{_matrix}[$root]);
	  $_[0]->{_matrix}[$root]->{cid} = $i;
	}
	#print "---\n";
	#print "i=$i j=$j ".$_[0]->{_matrix}[$i]->{array}[$j]->{index}." \n";
      }
    }
  }
}
sub dump_matrix {
  my($i, $j);
  #print "Dumping the matrix".$_[0]->{_corp}->{_wsize}."\n";
  for($i=0;$i<$_[0]->{_corp}->{_wsize};$i++) {
    #print "MAT=".$_[0]->{_matrix}[$i]->{size}."\n";
    for($j=0;$j<$_[0]->{_matrix}[$i]->{size};$j++) {
      print "i=$i j=$j ".$_[0]->{_matrix}[$i]->{array}[$j]->{index}." \n";
    }
  }
}

sub create_matrix {

  my($self) = @_;

  my ($i, $j, $csize, $xref, $yref, $dice);

  for($i=0;$i<$self->{_corp}->{_wsize};$i++) {
    $xref = $self->{_corp}->{_warr}[$i];
    $self->{_matrix}[$i]->{size} = 0;
    for($j=$i+1;$j<$self->{_corp}->{_wsize};$j++) {
      $yref = $self->{_corp}->{_warr}[$j];
      $csize = $self->common_ngrams($xref, $yref);

      $dice = ($csize<<1)/($xref->{ngram}->{size}+$yref->{ngram}->{size});
      if($dice>=$self->{_cutoff}){
	$self->{_matrix}[$i]->{array}[$self->{_matrix}[$i]->{size}]->{index} = $j;
	$self->{_matrix}[$i]->{array}[$self->{_matrix}[$i]->{size}++]->{dice} = $dice;
	print "($xref->{word}, Y=$yref->{word}) [dice=$dice] \n";
      }
    }
  }
}

sub ngram_matrix {

  $_[0]->create_ngrams;
  $_[0]->create_matrix;
  $_[0]->cluster_ngrams;
  $_[0]->dump_all_clusters;
}
sub stem {

  my($self, $word, $debug) = @_;
  print "TBD\n";
  
  if($debug) {
    $self->dump_matrix;
  }
  return $_[1];
}

sub new {
  my ($self) = $_[0];
  my $objref = {
		_corp => $_[1],
		_n => $_[2],
		_cutoff => $_[3],
		_matrix => 0
	       };
  
  my ($class) = ref($self) || $self;

  bless $objref, $class;

  $objref->ngram_matrix;
  #$objref->dump_matrix;

  return $objref;

}
1 ;
