use utf8;

$BASEDIR = ''; # for WSL with symlink(/home/kamichi/work)

if($#ARGV < 0){
  print "ERROR: no targets ... use en/ko/zhs/zht/all\n";
  exit;
}
if($ARGV[0] eq "all"){
  @ARGV = ("en", "ko", "zhs", "zht");
}

foreach(@ARGV){
  $lang = $_;
  if($lang !~ m/^(en|ko|zhs|zht)$/){
    print "ERROR: $_\n";
    next;
  } else {
    print "processing $_ ...\n";
  }
  open $fh, "<:utf8", "$lang.txt";
  $buffer = "";
  $fn = "";
  while(<$fh>){
    if($_ =~ m/^\!(.+)\/(.+?)\n$/){
    #if($_ =~ m/^\!\/cygdrive\/c(.+)\/(.+?)\n$/){
      if($buffer ne ""){
        if($target eq "index.cgi"){
          $buffer =~ s/LANG = ''/LANG = '$lang'/;
          $buffer =~ s/LANG_FLAG = ''/LANG_FLAG = '$lang.'/;
        }
        print $fh3 $buffer;
        close $fh3;
        $buffer = "";
      }
      $target = $2;
      open $fh2, "<:utf8", "$BASEDIR$1/$2";
      while(<$fh2>){
        $buffer .= $_;
      }
      close $fh2;
      open $fh3, ">:utf8", "$BASEDIR$1/$lang.$2";
    } elsif($_ =~ m/^:.*\n$/){
      $from = <$fh>;
      $to = <$fh>;
      $from =~ s/\n$//;
      $to =~ s/\n$//;
      $from = quotemeta($from);
      $buffer =~ s/$from/$to/g;
    }
  }
  close $fh;
  
  if($buffer ne ""){
    print $fh3 $buffer;
    close $fh3;
    $buffer = "";
  }
}
print "done.\n";
