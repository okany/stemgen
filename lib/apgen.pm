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
use v5.10;
use feature qw( switch );
no warnings qw( experimental::smartmatch );

###
### apgen library which parses the rule file and generates code for a new conflation algorithm
###
package apgen;

#
# read append functionality
#
sub read_append {

    given ($_[1]) {
        when ("suffix") {
            $retval = '$' . "stem =~ s/" . '$' . "/$_[2]/";
        }
        when ("prefix") {
            $retval = '$' . "stem =~ s/^/$_[2]/";
        }
        default {$retval = "\n";}
    }

    return $retval;
}

#
# read and replace functionality
#
sub read_replace {
    given ($_[1]) {
        when ('suffix') {
            $retval = '$' . "stem =~ s/$_[2]" . '$' . "/$_[3]/";
        };
        when ("prefix") {
            $retval = '$' . "stem =~ s/^$_[2]/$_[3]/";
        };
        when ("any") {
            $retval = '$' . "stem =~ s/$_[2]/$_[3]/";
        };
        when ("all") {
            $retval = '$' . "stem =~ s/$_[2]/$_[3]/g";
        }
        default {$retval = "\n";}
    }
    return $retval;
}

#
# read and remove functionality
#
sub read_remove {
    given ($_[1]) {
        when ("suffix") {
            $retval = '$' . "stem =~ s/$_[2]" . '$' . "//";
        };
        when ("first") {
            $retval = '$' . "stem =~ s/^.//";
        };
        when ("prefix") {
            $retval = '$' . "stem =~ s/^$_[2]//";
        };
        when ("last") {
            $retval = '$' . "stem =~ s/." . '$' . "//";
        };
        when ("any") {
            $retval = '$' . "stem =~ s/$_[2]//";
        };
        when ("all") {
            $retval = '$' . "stem =~ s/$_[2]//g";
        }
        default {$retval = "\n";}
    }

    return $retval;
}

#
# read and check if it is a vovel
#
sub read_isVowel {
    given ($_[3]) {
        when ("first") {
            $retval = '$' . "$_[2] =~ /^$_[0]->{_vowel}/";
        };
        when ("last") {
            $retval = '$' . "$_[2] =~ /($_[0]->{_vowel}|.y)" . '$' . "/";
        }
        when ("any") {
            $retval = '$' . "$_[2] =~ /($_[0]->{_vowel}|.y)/";
        }
        default {$retval = "";}
    }

    return $retval;
}

#
# read and check if it is a consonant
#
sub read_isConsonant {
    given ($_[3]) {
        when ("first") {
            $retval = '$' . "$_[2] =~ /^$_[0]->{_cons}/";
        };
        when ("last") {
            $retval = '$' . "$_[2] =~ /($_[0]->{_cons}|$_[0]->{_vowel}y)" . '$' . "/";
        };
        when ("any") {
            $retval = '$' . "$_[2] =~ /($_[0]->{_cons}|^y)/";
        }
        default {$retval = "";}
    }

    return $retval;
}

sub read_isMeasure {
    $retval = '$' . "$_[2] =~ /^($_[0]->{_consseq})?";
    $opr = $_[3];
    given ($opr) {
        when ("=") {$rep = $_[4]};
        when (">=") {$rep = $_[4]};
        when (">") {$rep = $_[4] + 1}
        default {}
    }

    for ($i = 0; $i < $rep; $i++) {
        $retval = $retval . $_[0]->{_vowelseq} . $_[0]->{_consseq};
    }

    if ($opr eq "=") {
        $retval = $retval . "(" . $_[0]->{_vowelseq} . ")?\$/o";
    }
    else {
        $retval = $retval . "/o";
    }
    return $retval;
}

#
# read and match the content
#
sub read_match {
    $begin = '$' . "stem =~ /";
    $end = "/";
    $or = 0;
    given ($_[2]) {
        when ("prefix") {
            $begin = $begin . "^";
        };
        when ("suffix") {
            $end = '$' . $end;
        };
        when ("both") {
            $begin = $begin . "^";
            $end = '$' . $end;
        };
        when ("any") {
        }
    }

    for ($mid = "", $i = 3; $i < @_; $i++) {
        given ($_[$i]) {
            when ("double") {
                if (defined($_[$i + 1])) {
                    $i++;
                    if ($_[$i] eq "consonant") {
                        $mid = $mid . "($_[0]->{_cons})\\1";
                    }
                    elsif ($_[$i] eq "consonanty") {
                        $mid = $mid . "($_[0]->{_consy})\\1";
                    }
                    elsif ($_[$i] eq "vowel") {
                        $mid = $mid . "($_[0]->{_vowel})\\1";
                    }
                    elsif ($_[$i] eq "vowely") {
                        $mid = $mid . "($_[0]->{_vowely})\\1";
                    }
                    else {
                        $mid = $mid . "$_[$i]$_[$i]";
                    }
                }
            };
            when ("consonant") {
                $mid = $mid . "($_[0]->{_cons})";
            };
            when ("consonantny") {
                $mid = $mid . "($_[0]->{_consny})";
            };
            when ("vowel") {
                $mid = $mid . "($_[0]->{_vowel})";
            }
            when ("vowely") {
                $mid = $mid . "($_[0]->{_vowely})";
            }
            when ("or") {
                $or = 1;
                $mid = $mid . '|';
            }
            default {
                $mid = $mid . $_[$i];
            }
        }
    }

    if ($or) {
        $mid = "(" . $mid . ")";
    }
    return $begin . $mid . $end;

}

#
# conditional read
#
sub read_cond {
    my ($self, @words) = @_;

    $rname = "cond" . $words[0];
    shift(@words);
    given ($words[0]) {
        when ("append") {$self->{_rule}->{$rname} = read_append(@words);}
        when ("match") {$self->{_rule}->{$rname} = $self->read_match(@words);}
        when ("replace") {$self->{_rule}->{$rname} = read_replace(@words);}
        when ("remove") {$self->{_rule}->{$rname} = read_remove(@words);}
        when ("isVowel") {$self->{_rule}->{$rname} = $self->read_isVowel(@words);}
        when ("isConsonant") {$self->{_rule}->{$rname} = $self->read_isConsonant(@words);}
        when ("isMeasure") {$self->{_rule}->{$rname} = $self->read_isMeasure(@words);}
        when ("isa") {$self->{_rule}->{$rname} = $self->read_match(@words);}
        when ("length") {$self->{_rule}->{$rname} = 'length($' . "$words[1]) $words[2] $words[3]";}
        default {}
    }
    print $rname . " " . $self->{_rule}->{$rname} . "\n";
}

#
# readn and step
#
sub read_steps {
    my ($self, $ind, $element, $tab, @words) = @_;

    #$sname = "step".$words[0];
    #shift(@words);
    my ($j) = 0;
    $j = @{$self->{_step}[$ind]};

    #$func = $words[0];
    $first = $j;
    $intact = 0;
    given ($words[0]) {
        when ("if") {
            if ($element eq "word") {
                $self->{_step}[$ind][$j++] = $tab . "if ((" . '$' . "stem=" . '$' . "$element) and ";
            }
            else {
                $self->{_step}[$ind][$j++] = $tab . "if (";
            }
            $func = "if";
            shift(@words);
        };
        when ("then") {
            if (defined($words[1]) and $words[1] eq "if") {
                $self->{_step}[$ind][$j++] = "\n" . $tab . "  if (";
                $func = "thenif";
                shift(@words);
            }
            elsif ($func eq "thenif") {
                $self->{_step}[$ind][$j++] = "\n";
                $func = "thenthen";
                $tab = $tab . "  ";
            }
            else {
                $self->{_step}[$ind][$j++] = "\n";
                $func = "then";
                $tab = $tab . "  ";
            }
            shift(@words);
        }
        when ("else") {
            if (defined($words[1]) and $words[1] eq "if") {
                if ($element eq "word") {
                    $self->{_step}[$ind][$j++] = $tab . "elsif ((" . '$' . "stem=" . '$' . "$element) and ";
                }
                else {
                    $self->{_step}[$ind][$j++] = $tab . "elsif (";
                }
                $func = "if";
                shift(@words)
            }
            else {
                $self->{_step}[$ind][$j++] = $tab . "else {\n";
                $func = "then";
                $tab = $tab . "  ";
            }
            shift(@words);
        }
        default {$func = $words[0];}
    }
    for ($i = 0; $i < @words; $i++) {
        given ($words[$i]) {
            when ("and") {
                if ($func =~ /^(if|thenif)$/) {
                    $self->{_step}[$ind][$j++] = " and ";
                }
                else {
                    $self->{_step}[$ind][$j++] = "\n";
                }
            }
            when ("or") {$self->{_step}[$ind][$j++] = " or ";};
            when ("not") {$self->{_step}[$ind][$j++] = " !";};
            when ("set") {
                if ($words[$i + 2] =~ /^[0-9]*$/) {
                    $self->{_step}[$ind][$j++] = $tab . '$' . $words[$i + 1] . ' = ' . $words[$i + 2] . ";";
                }
                elsif ($words[$i + 2] eq "length") {
                    $self->{_step}[$ind][$j++] = $tab . '$' . $words[$i + 1] . ' = ' . $words[$i + 2] . '($' . $words[$i + 3] . ");";
                    $i++;
                }
                else {
                    $self->{_step}[$ind][$j++] = $tab . '$' . $words[$i + 1] . ' = $' . $words[$i + 2] . ";";
                }
                $i += 2;
            };
            when ("call") {
                $self->{_step}[$ind][$j++] = $tab . '$word = $self->' . "$words[$i + 1]$words[$i + 2](" . '$word, $debug' . ");";
                $i += 2;
            };
            when ("intact") {
                $self->{_step}[$ind][$j++] = '($word eq $self->{_word})';
            };
            when ("break") {
                $self->{_step}[$ind][$j++] = $tab . 'last;';
            };
            when ("lookup") {
                $i++;
                $self->{_step}[$ind][$j++] = 'defined($self->{_corp}->{_wlist}{$' . "$words[$i]" . "})";
            }
            when ("segment") {
                if ($words[$i + 1] eq "get") {
                    $self->{_step}[$ind][$j++] = $tab . '$word = $self->{_sv}->determine_stem($word);';
                    $i++;
                }
                elsif ($words[$i + 1] eq "add") {
                    $self->{_step}[$ind][$j++] = $tab . '$self->{_sv}->add_segment($' . $words[$i + 2] . ');';
                    $i += 2;
                }
                else {
                    $i++;
                    $self->{_step}[$ind][$j++] = $tab . '$self->{_sv}->reset_segments();';
                }
            }
            when ("cutoff") {
                $i++;
                $self->{_step}[$ind][$j++] = '$i == $self->{_sv}->{_cutoff}';
            }
            when ("successor") {
                $i++;
                $self->{_step}[$ind][$j++] = "\n           ";
                $self->{_step}[$ind][$j++] = 'defined($self->{_sv}->{_pfix}->{$' . "$words[$i]" . '}->{succ}) and';
                $self->{_step}[$ind][$j++] = "\n           ";
                $self->{_step}[$ind][$j++] = 'defined($self->{_sv}->{_pfix}->{$' . "$words[$i + 2]" . '}->{succ}) and ';
                $self->{_step}[$ind][$j++] = "\n           ";
                $self->{_step}[$ind][$j++] = '($self->{_sv}->{_pfix}->{$' . "$words[$i++]" . '}->{succ}';
                $self->{_step}[$ind][$j++] = " $words[$i++] ";
                $self->{_step}[$ind][$j++] = '$self->{_sv}->{_pfix}->{$' . "$words[$i]" . '}->{succ})';
                $self->{_step}[$ind][$j++] = "\n           ";
            }
            when ("defined") {
                $self->{_step}[$ind][$j++] = 'defined($self->{_sv}->{_pfix}->{$' . "$words[$i + 1]}->{$words[$i + 2]})";
                $i += 2;
            }
            when ("entropy") {
                $i++;
                $self->{_step}[$ind][$j++] = 'defined($self->{_sv}->{_pfix}->{$' . "$words[$i]" . '}{entropy}) and ';
                $self->{_step}[$ind][$j++] = '($self->{_sv}->{_pfix}->{$' . "$words[$i++]" . '}{entropy}';
                $self->{_step}[$ind][$j++] = " $words[$i++] $words[$i])";
            }
            default # this must be a rule
            {
                if ($func =~ /^(if|thenif)$/) {
                    $self->{_step}[$ind][$j++] = "(" . $self->{_rule}->{"cond" . $words[$i]} . ")";
                }
                else {
                    $self->{_step}[$ind][$j++] = $tab . $self->{_rule}->{"cond" . $words[$i]} . ";";
                }
            };
        }
    }
    if ($func =~ /^(if|thenif)$/) {
        $self->{_step}[$ind][$j++] = ") {";
    }
    elsif ($func eq "then") {
        chop($tab);
        chop($tab);
        $self->{_step}[$ind][$j++] = "\n" . $tab . "}\n";
    }
    elsif ($func eq "thenthen") {
        $self->{_step}[$ind][$j++] = "\n" . $tab . "  }\n" . $tab . "}\n";
    }
    else {
        $self->{_step}[$ind][$j++] = "\n";
    }
}

#
# read definition file
#
sub read_def_file {

    my ($self, $rfile, $ofile) = @_;

    $sindex = 0;
    $oper = "";
    my ($tab) = "  ";
    while ($def = <$rfile>) {
        chomp($def);
        $def =~ s/^( )*//g;
        my (@words) = split(/ /, $def);
        if (!defined($words[0]) or $words[0] =~ /^#/) {
            next;
        }
        elsif ($words[0] eq "BEGIN") {
            # begin
            if ($words[1] =~ /^(step|stem)$/) {
                $oper = "step";
                if ($words[1] eq "step") {
                    $self->{_step}[$sindex][0] = "sub step$words[2] {\n\n";
                    $self->{_step}[$sindex][1] = $tab . 'my($self, $word, $debug) = @' . "_;\n\n";
                }
                else {
                    $self->{_step}[$sindex][0] = "sub stem {\n\n";
                    $self->{_step}[$sindex][1] = $tab . 'my($self, $word, $debug) = @' . "_;\n\n";
                    $self->{_step}[$sindex][2] = $tab . '$self->{_word} = $word;' . "\n";
                }
            }
            elsif ($words[1] eq "iterate") {
                my ($j);
                $j = @{$self->{_step}[$sindex]};
                $self->{_step}[$sindex][$j] = $tab . 'for($stop=0,$prev_word=$word;!$stop;$prev_word=$word) {' . "\n";
                $oper = "iterate";
                $tab = $tab . "  ";
            }
            elsif ($words[1] eq "rules") {
                $oper = "rules";
            }
            elsif (($words[1] eq "for-each") and ($words[2] eq "prefix")) {
                $j = @{$self->{_step}[$sindex]};
                $self->{_step}[$sindex][$j++] = "\n" . $tab . 'for($i=2;$i<length($word)-1;$i++){' . "\n";
                $tab = $tab . "  ";
                $self->{_step}[$sindex][$j++] = $tab . '$pred = substr($word,0,$i-1);' . "\n";
                $self->{_step}[$sindex][$j++] = $tab . '$this = substr($word,0,$i);' . "\n";
                $self->{_step}[$sindex][$j++] = $tab . '$succ = substr($word,0,$i+1);' . "\n\n";
                $oper = "for-each";
            }
        }
        elsif ($words[0] eq "END") {
            if ($words[1] =~ /^(step|stem)$/) {
                my ($j);
                $j = @{$self->{_step}[$sindex]};
                $self->{_step}[$sindex][$j++] = $tab . "return " . '$' . "word;\n\n";
                $self->{_step}[$sindex][$j] = "}\n";
                $oper = "";
                $sindex++;
            }
            elsif ($words[1] eq "iterate") {
                my ($j);
                $j = @{$self->{_step}[$sindex]};
                $self->{_step}[$sindex][$j++] = "$tab" . 'if($prev_word eq $word) {$stop = 1}' . "\n";
                chop($tab);
                chop($tab);
                $self->{_step}[$sindex][$j] = "$tab}\n";
            }
            elsif ($words[1] eq "rules") {
                $oper = "";
            }
            elsif (($words[1] eq "for-each") and ($words[2] eq "prefix")) {
                $j = @{$self->{_step}[$sindex]};
                $tab = "  ";
                $self->{_step}[$sindex][$j] = "$tab}\n";
                $oper = "step";
            }
        }
        elsif ($oper eq "step") {
            $self->read_steps($sindex, "word", $tab, @words);
        }
        elsif ($oper eq "iterate") {
            $self->read_steps($sindex, "word", $tab, @words);
        }
        elsif ($oper eq "for-each") {
            $self->read_steps($sindex, "this", $tab, @words);
        }
        elsif ($oper eq "rules") {
            $self->read_cond(@words);
        }
    }

}

#
# create a new stemmer
#
sub new_stemmer {

       my ($self) = @_;

    open($tfile, $self->{_main} . ".pl") or die "can't open file: $!";
    open($nfile, ">$self->{_name}_gen.pl") or die "can't open file: $!";

    while ($line = <$tfile>) {
        if ($line =~ m/<new algorithm>/) {
            print $nfile "  elsif(\$opt_a eq \"$self->{_name}\") { \n";
            print $nfile "    \$category = \"" . $self->{_cat} . "\";\n";
            if ($self->{_cat} eq "s") {
                $self->{_sv} = 1;
                $self->{_corp} = 1;
                print $nfile "    if(!defined(\$opt_c)){\n";
                print $nfile "    	 display_usage();\n";
                print $nfile "    }\n";
                print $nfile "    if(!defined(\$opt_u)){\n";
                print $nfile "    	 \$opt_u = 12;\n";
                print $nfile "    }\n";
                print $nfile "    \$corp = corpus->new(\$opt_c, '".$self->{_corp_path}."');\n";
                print $nfile "    \$sv = sv->new(\$corp, \$opt_u);\n";
                print $nfile "    \$alg = " . $self->{_name} . "->new(\$corp, \$sv); \n";
            }
            elsif ($self->{_cat} eq "d") {
                $self->{_corp} = 1;
                print $nfile "    if(!defined(\$opt_d)){\n";
                print $nfile "    	 display_usage();\n";
                print $nfile "    }\n";
                print $nfile "    \$corp = corpus->new(\$opt_d, '".$self->{_corp_path}."');\n";
                print $nfile "    \$alg = " . $self->{_name} . "->new(\$corp); \n";
            }
            elsif ($self->{_cat} eq "n") {
                $self->{_corp} = 1;
                print $nfile "    if(!defined(\$opt_c)){\n";
                print $nfile "    	 display_usage();\n";
                print $nfile "    }\n";
                print $nfile "    if(!defined(\$opt_n)){\n";
                print $nfile "    	 \$opt_n = 3;\n";
                print $nfile "    }\n";
                print $nfile "    if(!defined(\$opt_t)){\n";
                print $nfile "    	 \$opt_t = 1.6;\n";
                print $nfile "    }\n";
                print $nfile "    \$corp = corpus->new(\$opt_c), '".$self->{_corp_path}."';\n";
                print $nfile "    \$alg = " . $self->{_name} . "->new(\$corp); \n";
            }
            else {
                print $nfile "    \$alg = " . $self->{_name} . "->new(); \n";
            }
            print $nfile "  } \n";
        }
        elsif ($line =~ m/<new use>/) {
            print $nfile "use $self->{_name}; \n";
        }
        elsif ($line =~ m/<algorithm help>/) {
            print $nfile "  print \"              * " . $self->{_name} . "\\n\";\n";
        }
        print $nfile $line;
    }
    close($tfile);
    close($nfile);

    open($ifile, $self->{_lib_path} . $self->{_tempstem} . ".pm") or die "can't open file: $!";
    open($rfile, $self->{_rf_path} . $self->{_name} . ".rl") or die "can't open file: $self->{_name}.rl";
    open($ofile, ">$self->{_lib_path}$self->{_name}.pm") or die "can't open file: $!";

    $self->read_def_file($rfile, $ofile);
    my ($i, $j);
    while ($line = <$ifile>) {
        $line =~ s/<tempstem>/$self->{_name}/g;
        print $ofile $line;
        if ($line =~ m/<steps>/) {
            if (@{$self->{_step}}) {
                for ($i = 0; $i < @{$self->{_step}}; $i++) {
                    for ($j = 0; $j < @{$self->{_step}[$i]}; $j++) {
                        print $ofile $self->{_step}[$i][$j];
                    }
                }
            }
            print $ofile "\n";
        }
        elsif (($line =~ m/<corpus>/) and $self->{_corp}) {
            print $ofile '		_corp => $' . "_[1],\n";
        }
        elsif (($line =~ m/<sv>/) and $self->{_sv}) {
            print $ofile '		_sv => $' . "_[2],\n";
        }
    }
    close($ifile);
    close($ofile);
}

#
# create and instance of application generator
#
sub new {
    my ($self) = $_[0];

    my $objref = {
        _main     => $_[1],
        _lib_path => $_[2],
        _rf_path  => $_[3],
        _corp_path=> $_[4],
        _name     => $_[5],
        _cat      => $_[6],
        _corp     => 0,
        _sv       => 0,
        _debug    => $_[7],
        _tempstem => "tempstem",
        _vowel    => "[aeiou]",
        _vowely   => "[aeiouy]",
        _cons     => "[^aeiou]",
        _consny   => "[^aeiouy]",
        _consseq  => "[^aeiou][^aeiouy]*",
        _vowelseq => "[aeiouy][aeiou]*",
        @_rule    => (),
        @_step    => ()
    };

    my ($class) = ref($self) || $self;

    bless $objref, $class;

    $objref->new_stemmer;

    return $objref;

}
1 ;
