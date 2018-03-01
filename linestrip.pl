use strict;
use warnings;

my $filename = $ARGV[0];

open (STDOUT, "+<$filename") or die "Can't open $filename: $!\n";

my $cnt = 0;

sub flush_ws {
  $cnt = 1 if ($cnt >= 2);
  while ($cnt > 0) {print "\n"; $cnt--; }
}

while (<>) {
  if (/^$/) {
    $cnt++;
  } else {
    flush_ws();
    print $_;
  }
}
flush_ws();

close STDOUT;