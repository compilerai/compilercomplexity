#!/usr/bin/perl -w

use strict;
use warnings;

$#ARGV >= 1 or die "Usage: plot.pl <gcc|llvm> <commitcount-filename> [<every-nth-commit>]";
my $compiler = $ARGV[0];
my $commitcount_filename = $ARGV[1];
my $every_nth_commit = 1;
if ($#ARGV >= 2) {
  $every_nth_commit = int($ARGV[2]);
}

my $need_to_commit = identify_need_to_commit($compiler, $commitcount_filename, $every_nth_commit);
if ($need_to_commit) {
  my $date = get_commit_date($compiler);
  my $tot = count_total($compiler);
  #print "Number of lines in $compiler: $tot\n";
  print "\t$compiler\t$date\t$tot\n";
}

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

sub identify_need_to_commit {
  my $compiler = shift;
  my $commitcount_filename = shift;
  my $every_nth_commit = shift;

  if (not (-e $commitcount_filename)) {
    open(my $outfp, ">$commitcount_filename");
    print $outfp "LAST COMMITTED: 0\n";
    print $outfp "LAST SEEN: 0\n";
    close($outfp);
    return 1;
  }
  open(my $infp, "<$commitcount_filename");
  my $line1 = <$infp>;
  my $line2 = <$infp>;
  close($infp);
  $line1 =~ /LAST COMMITTED: (\d*)$/ or die;
  my $last_committed = int($1);
  $line2 =~ /LAST SEEN: (\d*)$/ or die;
  my $last_seen = int($1);
  my $cur_seen = $last_seen + 1;
  my $cur_committed = $last_committed;
  if ($cur_seen >= $last_committed + $every_nth_commit) {
    $cur_committed = $cur_seen;
  }
  open(my $outfp, ">$commitcount_filename");
  print $outfp "LAST COMMITTED: $cur_committed\n";
  print $outfp "LAST SEEN: $cur_seen\n";
  close($outfp);
  return $cur_committed > $last_committed;
};
