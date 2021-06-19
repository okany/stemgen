#!/usr/local/bin/perl -w
#use strict;
use warnings;
use Getopt::Std;
use util;
use corpus;
use ngram;
use sv;
use porterd;
use apgen;
use Switch;
# <new use>

sub run_stemmer() {
  print "Running the stemmer with name ".$opt_a."...\n";
  if((!defined($opt_w) && !defined($opt_s))||(!defined($opt_a))){
    display_usage();
  }
  
  if($opt_a eq "porterd") {
    $category = "a";
    $alg = porterd->new();
  }
  # <new algorithm>
  else {
    display_usage();
  }

  print "\n".uc($opt_a)."\n";
  
  if(defined($opt_w)){
    open(WFILE, $opt_w) or die "can't open file: $!"; 
    while ($word = <WFILE>) {
      chomp($word);
      
      # fix the word
      $word = util::fix_word($word);
      
      if($debug){
	print "fixed word is $word\n";
      }
  
      $stem = $alg->stem($word, $debug);
      print "$word -> $stem\n";
    }
  }
  else { 
    # fix the word
    $word = util::fix_word($opt_s);
    
    if($debug){
      print "fixed word is $word\n";
    }
    
    $stem = $alg->stem($word, $debug);
    print "\n".uc($opt_a).": Stem of $word is \"$stem\"\n";
  } 
}

sub generate_stemmer() {
  print "Generating a new stemmer with name ".$opt_a."...\n";
  if(defined($opt_a) && defined($opt_k)) {
    switch($opt_k){
      case ["n","s","a","d"]
	{
	}
      else
	{
	  display_usage();
	}
    }
    apgen->new($fname, $opt_a, $opt_k, $debug);
    exit;
  }
  else {
    display_usage();
  }
}

our($fname) = $0;
$fname =~ s/^.*\\// ;
$fname =~ s/\.pl$// ;
getopt('a:c:s:n:u:t:d:p:w:v:k:o:p:g:h');

our($opt_a, $opt_c, $opt_s, $opt_n, $opt_u, $opt_k, $opt_t, $opt_d,
    $opt_w, $opt_v, $opt_h, $opt_o, $opt_p, $opt_g, $category);

$category = "a";

if(defined($opt_h)||!defined($opt_o)) {
  display_usage();
}

if(!defined($opt_g)) {
  $debug = 0;
}
else {
  $debug = 1;
}

# generate a new stemmer
switch ($opt_o) {
  case "g" 
    {
     generate_stemmer();
    };
  case "r"
    {
     run_stemmer();
    };
  case "p"
    {
     $corp = corpus->new($opt_c);
     $corp->dump($opt_p);
     exit 0;
    }
  else 
    {
      display_usage();
    }
}

sub display_usage {
  print "Usage: perl $fname.pl -o [g|r|p] [-a algorithm/rule_file] [-k category]\n";
  print "              [-c corpus_file] [-d dictionary]]\n";
  print "              [-s word] [-t dice_threshold] [-u successor_var_cutoff] \n";
  print "              [-w word_file] [-g debug_level] [-p output_file]\n\n";
  print "  Options:\n";
  print "   -o r - to run a stemmer\n";
  print "          supported algorithms:\n";
  print "              * porterd - developed porter\n";
#<algorithm help>
  print "          -w file with words to generate stem for\n";
  print "          -s word to generate stem for\n";
  print "          -d dictioary name (valid for dictionary type of stemmers)\n";
  print "          -c corpus name (valid for n-gram, successor variety)\n";
  print "          -t dice thrshold of ngram (valid for n-gram type of stemmers)\n";
  print "          -u successor variety cutoff (valid for successor variety type of stemmers)\n";
  print "   -o g - to generate a stemmer from a rule file\n";
  print "          the new perl script is generated in the name <rule_file>_gen.pl\n"; 
  print "          -k type of the stemmer:\n"; 
  print "             n - n-gram type algorithm\n";
  print "             s - successor variety type algorithm\n";
  print "             a - affix removal type algorithm\n";
  print "             d - dictionary based algorithm\n";
  print "          -r rule_file with .rl extension\n";
  print "             rule files in this package\n";
  print "               * porter\n";
  print "               * lovins\n";
  print "               * kstem\n";
  print "               * sremoval\n";
  print "               * paice\n";
  print "               * succvar (successor variety)\n";
  print "   -o p - to parse a corpus file\n";
  print "          -p output file (valid for parsing a corpus)\n";
  print "Examples:\n";
  print " -- to generate a stemmer:\n";
  print "       perl $fname.pl -o r -w w.txt -a porterd\n";
  print "       perl $fname.pl -o g -a lovins -k a\n";
  print "       perl $fname.pl -o g -a sremoval -k a\n";
  print "       perl $fname.pl -o g -a paice -k a\n";
  print "       perl $fname.pl -o g -a kstem -k d\n";
  print "       perl $fname.pl -o g -a succvar -k s\n";
  print " -- to run a stemmer: \n";
  print "       perl $fname.pl -o r -a porterd -w w.txt\n";
  print "       perl porter_gen.pl -o r -a porter -s greatings\n";
  print "       perl paice_gen.pl -o r -a paice -w w.txt\n";
  print "       perl lovins_gen.pl -o r -a lovins -w w.txt\n";
  print "       perl sremoval_gen.pl -o r -a sremoval -w w.txt\n";
  print "       perl kstem_gen.pl -o r -a kstem -d usd.txt -w w.txt\n";
  print "       perl succvar_gen.pl -o r -a succvar -c corpus.txt -w -w.txt\n";
  print " -- to parse a corpus file:\n";
  print "       perl $fname.pl -o p -c unprocessed_corpus.txt -p c.txt\n";

  exit;
}
1 ;
