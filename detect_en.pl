use utf8;
binmode STDOUT, ":utf8";

$target_lang = "en";
$target_cur = "$target_lang.txt";
$target_unused = "$target_lang.unused.txt";
$target_done = "$target_lang.done.txt";
$target_notyet = "$target_lang.notyet.txt";
$target_done_new = "$target_lang.done.new.txt";
$target_notyet_new = "$target_lang.notyet.new.txt";

$done = "";
$notyet = "";
$result = "";

if(-e $target_cur || -e $target_unused || -e $target_done_new || -e $target_notyet_new){
  print "Error. Clean files first.\n";
  exit;
}

%current = ();
open(my $fh, "<:utf8", $target_notyet);
while(<$fh>){
  if($_ =~ m/^[:!]/){
    next;
  }
  if($_ =~ m/^(\r\n|\r|\n)$/){
    next;
  }
  $ja = $_;
  $ja =~ s/(\r\n|\r|\n)$//;
  $local = <$fh>;
  $local =~ s/(\r\n|\r|\n)$//;
  if($ja ne $local){
    $current{$ja} = $local;
  }
}
close $fh;
open(my $fh, "<:utf8", $target_done);
while(<$fh>){
  if($_ =~ m/^[:!]/){
    next;
  }
  if($_ =~ m/^(\r\n|\r|\n)$/){
    next;
  }
  $ja = $_;
  $ja =~ s/(\r\n|\r|\n)$//;
  $local = <$fh>;
  $local =~ s/(\r\n|\r|\n)$//;
  if($ja ne $local){
    $current{$ja} = $local;
  }
}
close $fh;
%current2 = %current;

@files = ();
push(@files, "/cygdrive/c/Users/kamichi/Dropbox/kamichi/home/www/glyphwiki.org/index.cgi");
opendir($dh, "/cygdrive/c/Users/kamichi/Dropbox/kamichi/home/glyphwiki/") or die $!;
foreach(grep(/(common|config|page.+)\.pl$/, readdir($dh))){
  if($_ !~ m/^(en|ko|zhs)./){
    push(@files, "/cygdrive/c/Users/kamichi/Dropbox/kamichi/home/glyphwiki/$_");
  }
}
closedir($dh);

foreach(@files){
	$fn = $_;
	%cand = ();
	open(my $fh, "<:utf8", $_);
  $line = 1;
  while(<$fh>){
    if($_ =~ m/^[ \t]*([^\#]*[^ -~\r\n\t]+[^\#]*)(\#.*)?[\r\n]+$/){
      if($_ !~ m/\#.*ja_mama/){
        $cand{$1} .= $line.",";
      }
    }
		$line++;
  }
  close($fh);
  $buffer1 = "";
  $buffer2 = "";
  $buffer3 = "";
  foreach(sort({$cand{$a} <=> $cand{$b}} keys(%cand))){
    if(exists($current{$_})){
      $buffer1 .= ":".substr($cand{$_}, 0, length($cand{$_}) - 1)."\n$_\n$current{$_}\n";
      $buffer3 .= ":".substr($cand{$_}, 0, length($cand{$_}) - 1)."\n$_\n$current{$_}\n";
      delete($current2{$_});
    } else {
      $buffer2 .= ":".substr($cand{$_}, 0, length($cand{$_}) - 1)."\n$_\n$_\n";
      $buffer3 .= ":".substr($cand{$_}, 0, length($cand{$_}) - 1)."\n$_\n$_\n";
    }
  }
  $done .= "!".$fn."\n".$buffer1."\n";
  $notyet .= "!".$fn."\n".$buffer2."\n";
  $result .= "!".$fn."\n".$buffer3."\n";
}

$unused = "";
foreach(sort({$current2{$a} <=> $current2{$b}} keys(%current2))){
  $unused .= ":\n$_\n$current2{$_}\n";
}

open(my $fh, ">:utf8", $target_cur);
print $fh $result;
close $fh;
open(my $fh, ">:utf8", $target_done_new);
print $fh $done;
close $fh;
open(my $fh, ">:utf8", $target_notyet_new);
print $fh $notyet;
close $fh;
open(my $fh, ">:utf8", $target_unused);
print $fh $unused;
close $fh;
