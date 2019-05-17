#!/usr/bin/perl
open IN, "<acijub.position";
open OUT, ">acijub.ortho_exon1";
@line=<IN>;
chomp(@line);
for ($i=0;$i<=$#line;$i++) {
	if ($line[$i]=~/^\>/) {
		print OUT "$line[$i]\n";
		@pos1=split(/\s+/,$line[$i+1]);
		@pos2=split(/\s+/,$line[$i+2]);
		for ($j=0;$j<=$#pos1;$j++) {
			($s1,$e1)=$pos1[$j]=~/^(\d+)\:(\d+)/;
			@aa=split /:/,$pos1[$j];
			for ($k=0;$k<=$#pos2;$k++) {
				($s2,$e2)=$pos2[$k]=~/^(\d+)\:(\d+)/;
				@bb=split /:/,$pos2[$k];
				if($aa[3]==$bb[3]){
					print OUT "$pos1[$j]\t$pos2[$k]\n";
					last;
				}
			}
		}	
	}	    	    
}			
close IN;
close OUT;
