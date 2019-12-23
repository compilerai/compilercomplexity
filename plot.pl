#!/usr/bin/perl -w

use strict;
use warnings;

$#ARGV >= 0 or die "Usage: plot.pl <gcc|llvm>";
my $compiler = $ARGV[0];

my $date = get_commit_date($compiler);
my $tot = count_total($compiler);
#print "Number of lines in $compiler: $tot\n";
print "$compiler\t$date\t$tot\n";

sub count_total {
  my $compiler = shift;
  if ($compiler eq "llvm") {
    system("mv llvm/test llvm/docs llvm/examples llvm/unittests llvm/utils llvm/bindings .");
    system("mv llvm/.git llvm.git");
    system("find llvm -type f | xargs wc -l | cat > wc.out");
    system("mv test docs examples unittests utils bindings llvm");
    system("mv llvm.git llvm/.git");
    my $tot = count_total_in_wc_out("wc.out");
    system("rm -f wc.out");
    return $tot;
  } elsif ($compiler eq "gcc") {
    system("mv gcc/.git gcc.git");
    system("find gcc -type f | xargs wc -l | cat > wc.out");
    system("mv gcc.git gcc/.git");
    my $tot = count_total_in_wc_out("wc.out");
    system("rm -f wc.out");
    return $tot;
  } else {
    die "unrecognized compiler: $compiler\n";
  }
};

sub count_total_in_wc_out {
  my $wc_out = shift;
  open(my $in, "<$wc_out");
  my $ret = 0;
  while (my $line = <$in>) {
    if ($line =~ / (\d*) total/) {
      my $t = $1;
      $ret += $t;
    }
  }
  close($in);
  return $ret;
};

sub get_commit_date {
  my $gitrep = shift;
  my $date = `cd $gitrep && git show -s --format=%ci && cd ..`;
  chomp($date);
  return $date;
};
