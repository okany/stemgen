			APPLICATION GENERATOR DESCRIPTION
This is an application generator for conflation algorithms in perl language. 
This package includes the following:

 - application generator for stemmers
    * stemgen.pl - main perl routine
    * apgen.pm - application generator class
    * corpus.pm - corpus parsing class
    * ngram.pm - utility class supporting n-gram specific operations
    * porterd.pm - class implementing porter algorithm (developed version)
    * sv.pm - utility class supporting successof variety specific operations
    * util.pm - generic utlity class
    * tempstem.pm - stemmer template used by the application generator

 - rule files for the following stemmers:
    * porter
    * lovins
    * k-stem
    * sremoval
    * paice
    * successor variety

 - unprocesses corpus file (in a separate zip file)
    * unprocessed_corpus.txt

 - processed corpus file
    * corpus.txt

 - usd dictionary
    * usd.txt

 - file containing the list of words that have been tested
    * w.txt

				USAGE

Usage: perl stemgen.pl -o [g|r|p] [-a algorithm/rule_file] [-k category]
              [-c corpus_file] [-d dictionary]]
              [-s word] [-t dice_threshold] [-u successor_var_cutoff] 
              [-w word_file] [-g debug_level] [-p output_file]

  Options:
   -o r - to run a stemmer
          supported algorithms:
              * porterd - developed porter
          -w file with words to generate stem for
          -s word to generate stem for
          -d dictioary name (valid for dictionary type of stemmers)
          -c corpus name (valid for n-gram, successor variety)
          -t dice thrshold of ngram (valid for n-gram type of stemmers)
          -u successor variety cutoff (valid for successor variety type of stemmers)
   -o g - to generate a stemmer from a rule file
          -k type of the stemmer: 
             n - n-gram type algorithm
             s - successor variety type algorithm
             a - affix removal type algorithm
             d - dictionary based algorithm
          -r rule_file with .rl extension
             rule files in this package
               * porter
               * lovins
               * kstem
               * sremoval
               * paice
               * succvar (successor variety)
   -o p - to parse a corpus file
          -p output file (valid for parsing a corpus)
Examples:
 -- to generate a stemmer:
       perl stemgen.pl -o g -a porter -k a
       perl stemgen.pl -o g -a lovins -k a
       perl stemgen.pl -o g -a sremoval -k a
       perl stemgen.pl -o g -a paice -k a
       perl stemgen.pl -o g -a kstem -k d
       perl stemgen.pl -o g -a succvar -k s
 -- to run a stemmer: 
       perl stemgen.pl -o r -a porterd -w w.txt
       perl porter_gen.pl -o r -a porter -s greatings
       perl paice_gen.pl -o r -a paice -w w.txt
       perl lovins_gen.pl -o r -a lovins -w w.txt
       perl sremoval_gen.pl -o r -a sremoval -w w.txt
       perl kstem_gen.pl -o r -a kstem -d usd.txt -w w.txt
       perl succvar_gen.pl -o r -a succvar -c corpus.txt -w -w.txt
 -- to parse a corpus file:
       perl stemgen.pl -o p -c unprocessed_corpus.txt -p c.txt

