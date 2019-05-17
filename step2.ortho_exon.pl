#!/usr/bin/perl
open IN, "<acijub.position";
open OUT, ">acijub.1_ortho_exon";
@line=<IN>;
chomp(@line);
for ($i=0;$i<=$#line;$i++) {
	if ($line[$i]=~/^\>/) {
		print OUT "$line[$i]\n";
	    @pos1=split(/\s+/,$line[$i+1]);
	    @pos2=split(/\s+/,$line[$i+2]);
	    for ($j=0;$j<=$#pos1;$j++) {
			($s1,$e1)=$pos1[$j]=~/^(\d+)\:(\d+)/;
			 for ($k=0;$k<=$#pos2;$k++) {
		      ($s2,$e2)=$pos2[$k]=~/^(\d+)\:(\d+)/;
		      if ($s1<$e2 and $s2<$e1) {
				  if (($e1-$s2+1)/($e1-$s1+1)>0.1 and ($e2-$s1+1)/($e1-$1+1)>=0.1) {
					  print OUT "$pos1[$j]\t$pos2[$k]\n";
					  last;
				  }
			  }
		      
			 }	
		}
	    
	    
	}
	
	
	
}
close IN;
close OUT;
