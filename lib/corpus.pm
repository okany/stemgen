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

###
### Package to process a corpus file
###
package corpus;

#
# loads the corpus
#
sub load_corpus {

    my ($self) = $_[0];
    my ($word, $i, $index);
    shift;

    for ($i = 0; $i < @_; $i++) {

        $self->{_fnames}[$i] = $_[$i];
        print "Loading corpus " . $self->{_fnames}[$i] . "\n";
        open(INFILE, $self->{_corp_path}.$self->{_fnames}[$i]) or die "can't open file: $!";

        while (<INFILE>) {
            chomp;
            tr/.:/ /d;
            my (@words) = split;
            for ($index = 0; $index < @words; $index++) {
                $word = $words[$index];
                #$word =~ tr/.,//d;
                #$word = lc($word);
                $word = util::fix_word($word);

                if (length($word) > 2) {
                    if (!defined($self->{_wlist}->{$word})) {
                        $self->{_wlist}->{$word}->{word} = $word;
                        $self->{_wlist}->{$word}->{cnt} = 1;
                        $self->{_wlist}->{$word}->{ngram} = ();
                        $self->{_wlist}->{$word}->{index} = 0;

                        print "$word\n";
                    }
                    else {
                        $self->{_wlist}->{cnt}++;
                    }
                }
            }
        }
        close(INFILE);
    }

    $self->index_array;
}

#
# dumps the content of the corpus
#
sub dump {
    my ($self) = $_[0];
    my ($ofname) = $_[1];
    open(OFILE, ">$ofname") or die "can't open file: $!";
    while (my ($key, $value) = each(%{$self->{_wlist}})) {
        print OFILE $key . "\n";
    }
    close(OFILE);
}

#
# creates an index array
#
sub index_array {

    my ($self) = $_[0];
    my $ind = 0;
    for my $word (sort keys %{$self->{_wlist}}) {
        $self->{_warr}[$ind] = $word;
        $self->{_wlist}->{$word}->{index} = $ind++;
    }
    $self->{_wsize} = $ind;
}

#
# creates a corpus instance
#
sub new {

    my ($self) = $_[0];
    my (@_warr);
    my (@_fnames);
    my (@_wlist);

    shift;
    my $objref = {
        @_fnames => (),
        @_warr  => (),
        _corp_path => $_[1],
        _wsize  => 0,
        @_wlist  => ()
    };

    my ($class) = ref($self) || $self;

    bless $objref, $class;

    $objref->load_corpus(@_);

    return $objref;
}
1;
