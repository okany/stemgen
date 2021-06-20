#!/usr/local/bin/perl -w
#use strict;
use warnings;
use IO::Socket;

package corpus;

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

sub dump {
    my ($self) = $_[0];
    my ($ofname) = $_[1];
    open(OFILE, ">$ofname") or die "can't open file: $!";
    while (my ($key, $value) = each(%{$self->{_wlist}})) {
        print OFILE $key . "\n";
    }
    close(OFILE);
}

sub index_array {

    my ($self) = $_[0];
    my $ind = 0;
    for my $word (sort keys %{$self->{_wlist}}) {
        $self->{_warr}[$ind] = $word;
        $self->{_wlist}->{$word}->{index} = $ind++;
    }
    $self->{_wsize} = $ind;
}

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
