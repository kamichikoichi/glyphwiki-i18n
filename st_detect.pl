use utf8;
binmode STDOUT, ":utf8";

open my $fhs, "<:utf8", "zhs.done.txt";
open my $fht, "<:utf8", "zht.done.txt";

my $count = 0;
my %d = ();
my $mode = 0;
while(<$fhs>){
  $s = $_;
  $t = <$fht>;
  if(substr($s, 0, 1) eq ":"){
    $mode = 0;
  } else {
    $mode++;
  }
  if($mode == 2){
    for($i = 0; $i < length($s); $i++){
      $d{substr($s, $i, 1)} .= substr($t, $i, 1);
    }
  }
}

foreach(sort(keys(%d))){
  my @t = split(//, $d{$_});
  my %t = ();
  foreach(@t){
    $t{$_}++;
  }
  my $t = join('', keys(%t));
  #if($_ ne $t){
    print "$_\t$t\n";
  #}
}
