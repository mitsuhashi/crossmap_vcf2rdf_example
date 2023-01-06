#!/usr/bin/perl

use strict;

my $jgad_id = $ARGV[0];
my $rdf=$ARGV[1];
my $max_variants_per_ttl = $ARGV[2];
my @rdf = split("/",$rdf);
my $rdf_dir = join("/", splice(@rdf, 0, $#rdf)) . "/$jgad_id";
my $prefix = "";

open(IN, "$rdf") || die "Can't open $rdf";

# Read prefix
while(my $line = <IN>){
  if($line !~ /^\@prefix/){ last; }
  $prefix = $prefix . $line;
}

$prefix .= '@prefix   jga: <http://ddbj.nig.ac.jp/resource/jga-dataset/> .' . "\n\n";

#
# split rdf by $max_variants_per_ttl variants and write it to separate files.
#
for(my $file_idx = 0, my $variants = 0; not eof IN; $file_idx++, $variants = 0){
  my $outfile = "$rdf_dir/$jgad_id.$file_idx.ttl.gz";

  print STDERR $outfile . "\n";

  open(OUT, "| gzip -c > $outfile") || die "Can't open $outfile.";

  print OUT $prefix;

  while(my $line = <IN>){
    print OUT $line;
    if($line =~ /^\[\] a gvo:/){ # first line of variant
      $variants++;
      print OUT "  rdfs:seeAlso jga:$jgad_id ;\n";  # add JGADID
    } elsif($line =~ /^\s+\]\s+\./){  # last line of variant
      if($variants >= $max_variants_per_ttl){
        last;
      }
    }
  }

  close(OUT);
}

close(IN);
