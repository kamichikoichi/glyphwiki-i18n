use utf8;
$lang = "zht";
open $fh, "<:utf8", "$lang.txt";
$buffer = "";
while(<$fh>){
	if($_ =~ m/^\!(.+)\/(.+?)\n$/){
		if($buffer ne ""){
			print $fh3 $buffer;
			close $fh3;
			$buffer = "";
		}
		open $fh2, "<:utf8", "$1/$2";
		while(<$fh2>){
			$buffer .= $_;
		}
		close $fh2;
		open $fh3, ">:utf8", "$1/$lang.$2";
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
