#!/usr/local/bin/perl -w
use warnings;

###
### this package contains a library of porter algorithm which is developed by a human
###
package porterd;

sub stem {
  my ($self, $word, $debug) = @_;
  # word needs to be longer than 3 characters
  if(length($word) < 3) {
    return $word;
  }
  # map y to Y
  $word =~ /^./;
  $firstchar = $&;
  if($firstchar =~ /^y/) {
    $word = ucfirst $word;
  }

  # Step 1a
  if (($word =~ /(ss|i)es$/) || ($word =~ /([^s])s$/)){
    $word=$`.$1;
    if($debug) {
      print "Step 1a=$word\n";
    }
  }

  # Step 1b
  if ($word =~ /eed$/) {
    if ($` =~ /$self->{_mgr0}/o) {
      chop($word); } }
  elsif ($word =~ /(ed|ing)$/) {
    $stem = $`;
    if ($stem =~ /$self->{_vns}/o) {
      $word = $stem;
      if ($word =~ /(at|bl|iz)$/) {
	$word .= "e";
      }
      elsif ($word =~ /([^aeiouylsz])\1$/) {
	chop($word);
      }
      elsif ($word =~ /"^{$self->{_C}}{$self->{_v}}[^aeiouwxy]$"/o) {
	$word .= "e";
      }
      if($debug) {
	print "Step 1b=$word\n";
      }
    }
  }

  # Step 1c
  if ($word =~ /y$/) {
    $stem = $`;
    if ($stem =~ /$self->{_vns}/o) {
      $word = $stem."i";
      if($debug) {
	print "Step 1c=$word\n";
      }
    }
  }

  # Step 2
  if ($word =~ /(ational|tional|enci|anci|izer|abli|alli|entli|eli|ousli|ization|ation|ator|alism|iveness|fulness|ousness|aliti|iviti|biliti)$/) {
    $stem = $`;
    $suffix = $1;
    if ($stem =~ /$self->{_mgr0}/o) {
      $word = $stem . $self->{_st2}->{$suffix};
      if($debug) {
	print "Step 2=$word\n";
      }
    }
  }

  # Step 3
  if ($word =~ /(icate|ative|alize|iciti|ical|ful|ness)$/) {
    $stem = $`;
    $suffix = $1;
    if ($stem =~ /$self->{_mgr0}/o) {
      $word = $stem . $self->{_st3}->{$suffix};
      if($debug) {
	print "Step 3=$word\n";
      }
    }
  }

  # Step 4
  if ($word =~ /(al|ance|ence|er|ic|able|ible|ant|ement|ment|ent|ou|ism|ate|iti|ous|ive|ize)$/) {
    $stem = $`;
    if ($stem =~ /$self->{_mgr1}/o) {
      $word = $stem;
      if($debug) {
	print "Step 4=$word\n";
      }
    }
  }
  elsif ($word =~ /(s|t)(ion)$/) {
    $stem = $` . $1; 
    if ($stem =~ /$self->{_mgr1}/o) {
      $word = $stem;
      if($debug) {
	print "Step 4=$word\n";
      }
    }
  }

  #  Step 5
  if ($word =~ /e$/) {
    $stem = $`;
    if ($stem =~ /$self->{_mgr1}/o ||
	($stem =~ /$self->{_meq1}/o && $stem =~ /$self->{_c}$self->{_v}$self->{_c}$/o && $stem =~ /[^wxy]$/o)) { 
      $word = $stem;
      if($debug) {
	print "Step 5=$word\n";
      }
    }
  }
  
  if ($word =~ /ll$/ && $word =~ /$self->{_mgr1}/o) {
    chop($word);
  }

  # and turn initial Y back to y
  if ($firstchar =~ /^y/) {
    $word = lcfirst $word;
  }

  return $word;
}

#
# create an instance of the porter algorithm
#
sub new {
  my ($self) = $_[0];
  my $objref = {
		_c => "",
		_v => "",
		_C => "",
		_V => "",
		_mgr0 => "",
		_mgr1 => "",
		_vns => "",
		_st2 => 0,
		_st3 => 0
	       };
  
  my ($class) = ref($self) || $self;

  bless $objref, $class;
  $objref->{_c} = "[^aeiou]";
  $objref->{_v} = "[aeiouy]";
  $objref->{_C} = $objref->{_c}."[^aeiouy]*";
  $objref->{_V} = $objref->{_v}."[aeiou]*";
  $objref->{_mgr0} = "^($objref->{_C})?$objref->{_V}$objref->{_C}";
  $objref->{_meq1} = "^($objref->{_C})?$objref->{_V}$objref->{_C}($objref->{_V})?".'$';
  $objref->{_mgr1} = "^($objref->{_C})?$objref->{_V}$objref->{_C}$objref->{_V}$objref->{_C}";
  #print $objref->{_mgr1}."\n";
  $objref->{_vns} = "^($objref->{_C})?$objref->{_v}";

  $objref->{_st2}->{'ational'} = 'ate';
  $objref->{_st2}->{'tional'} = 'tion';
  $objref->{_st2}->{'enci'} = 'ence';
  $objref->{_st2}->{'anci'} = 'ance';
  $objref->{_st2}->{'izer'} = 'ize';
  $objref->{_st2}->{'abli'} = 'able';
  $objref->{_st2}->{'alli'} = 'al';
  $objref->{_st2}->{'entli'} = 'ent';
  $objref->{_st2}->{'eli'} = 'e';
  $objref->{_st2}->{'ousli'} = 'ous';
  $objref->{_st2}->{'ization'} = 'ize';
  $objref->{_st2}->{'ation'} = 'ate';
  $objref->{_st2}->{'ator'} = 'ate';
  $objref->{_st2}->{'alism'} = 'al';
  $objref->{_st2}->{'iveness'} = 'ive';
  $objref->{_st2}->{'fulness'} = 'ful';
  $objref->{_st2}->{'ousness'} = 'ous';
  $objref->{_st2}->{'aliti'} = 'al';
  $objref->{_st2}->{'iviti'} = 'ive';
  $objref->{_st2}->{'biliti'} = 'ble';
  $objref->{_st2}->{'logi'} = 'log';

  $objref->{_st3}->{'icate'} = 'ic';
  $objref->{_st3}->{'ative'} = '';
  $objref->{_st3}->{'alize'} = 'al';
  $objref->{_st3}->{'iciti'} = 'ic';
  $objref->{_st3}->{'ical'} = 'ic';
  $objref->{_st3}->{'ful'} = '';
  $objref->{_st3}->{'ness'} = '';

  #print "_c=$objref->{_c} \n";
  #print "_v=$objref->{_v} \n";
  #print "_C=$objref->{_C} \n";
  #print "_mgr0=$objref->{_mgr0} \n";
  #print "_meq1=$objref->{_meq1} \n";
  #print "_mgr1=$objref->{_mgr1} \n";
  #print "_vns=$objref->{_vns} \n";

  return $objref;

}

1;
