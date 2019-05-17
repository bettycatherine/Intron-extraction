#!/usr/bin/perl
open IN, "<acijub.ortho_exon1";
open OUT, ">acijub.ortho_intron";
@line=<IN>;
chomp(@line);
for ($i=0;$i<$#line;$i++) {
	if ($line[$i]=~/^\>/) {
		print OUT "$line[$i] canfam[ori:chromosone:intronstart:intronend]\tacijub[ori:chromosone:intronstart:intronend]\n";
	}else{
		if ($line[$i+1]!~/^\>/) {
	($s1,$e1)=$line[$i]=~/\[(\d+)\:.*\[(\d+)\:/;	
	($s2,$e2)=$line[$i+1]=~/\[(\d+)\:.*\[(\d+)\:/;	
	@tmp1=split(/\:/,$line[$i]);
	@tmp2=split(/\:/,$line[$i+1]);
	$tmp1[7]=~s/(\d+)\].*/\1/;
	$tmp1[14]=~s/(\d+)\]/\1/;
	$tmp2[7]=~s/(\d+)\].*/\1/;
	$tmp2[14]=~s/(\d+)\]/\1/;
		if ($s1+1 eq $s2 and $e1+1 eq $e2) {
		  if ($tmp1[4]>0) {
			  $line[$i] .= "\t$tmp1[4]:$tmp1[5]:$tmp1[7]:$tmp2[6]";
		  }else{
			  $line[$i] .= "\t$tmp1[4]:$tmp1[5]:$tmp1[6]:$tmp2[7]";
		  }
			
			if ($tmp1[11]>0) {
				print OUT "$line[$i]\t$tmp1[11]:$tmp1[12]:$tmp1[14]:$tmp2[13]\n";
			}else{
				print OUT "$line[$i]\t$tmp1[11]:$tmp1[12]:$tmp1[13]:$tmp2[14]\n";
			}
			
		}
	}else{
		print OUT "$line[$i]\n";
	}
 }
}
print OUT "$line[$#line]\n";
close IN;
close OUT;
