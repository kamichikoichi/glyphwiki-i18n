use utf8;
binmode STDOUT, ":utf8";

%table = ();
open my $fh, "<:utf8", "st_table.txt";
while(<$fh>){
  $_ =~ s/[\r\n]+$//;
  @temp = split(/\t/);
  $table{$temp[0]} = $temp[1];
}
close $fh;

open my $fh, "<:utf8", "zh.done.txt";
open my $fhs, ">:utf8", "zhs.done.txt";
open my $fht, ">:utf8", "zht.done.txt";

my $m = 0;
while(<$fh>){
  my $target = $_;
  $m++;
  if(substr($target, 0, 1) eq ":"){
    $m = 0;
  }
  if($m != 2){
    print $fhs $target;
    print $fht $target;
  } else {
    for($i = 0; $i < length($target); $i++){
      my $char = substr($target, $i, 1);
      if($char =~ m/[一-龠]/){
        if(!exists($table{$char})){
          print "ERROR: $char\n";
        } else {
          print $fhs $char;
          print $fht $table{$char};
        }
      } elsif($char eq "★"){
        print $fhs substr($target, $i + 1, 1);
        print $fht substr($target, $i + 2, 1);
        $i = $i + 3;
      } else {
        print $fhs $char;
        print $fht $char;
      }
    }
  }
}

close $fh;
close $fhs;
close $fht;
