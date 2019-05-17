#!/usr/bin/perl
use File::Basename;
open IN, "<./structure/acijub.ortho";  #The list orthologous genes.
undef %ortho;
while (<IN>) {
	s/\r\n//;
	chomp;
	($id1,$id2)=$_=~/^(\S+)\s+(\S+)/;
	$ortho{$id1}=$id2;
}
close IN;

@name=glob("../acijub_prank/*.fas"); #The pair wise alignments of CDS sequences.
open OUT, ">acijub.position";
foreach $name (@name) {
	$name1=basename $name;
	($name2)=$name1=~/^(\S+)\.fas/;
    	open IN, "<$name";
    	undef %hash;
    	while (<IN>) {
		s/\r\n//;
		chomp;
		if (/^\>/) {
			($id)=$_=~/^\>(\S+)/;
		}else{
			$hash{$id} .= $_;
		}
	}
	close IN;
	
	undef %canfam;
	open IN, "<./structure/canfam.2"; #ENSEMBLE annotation file of reference species.
	while (<IN>) {
		s/\r\n//;
		chomp;
		if (/^$name2/) {
			@id=split(/\t/,$_);
			$len=$id[15]-$id[14]+1;
			$tmp="$id[10]" . ":$id[13]" . ":$len" . ":$id[6]" . ":$id[2]" . ":$id[11]" . ":$id[12]";
			$canfam{$id[15]}=$tmp;
		}
	}
	close IN;	
	
	undef %acijub;
	open IN, "<./structure/acijub.2"; #ENSEMBLE annotation file of target species.
	while (<IN>) {
		s/\r\n//;
		chomp;
		if (/^$ortho{$name2}/) {
			@id=split(/\t/,$_);
			$len=$id[15]-$id[14]+1;
			$tmp="$id[10]" . ":$id[13]" . ":$len" . ":$id[6]" . ":$id[2]" . ":$id[11]" . ":$id[12]";
			$acijub{$id[15]}=$tmp;
		}
	}
	close IN;
	
	$len=length $hash{canfam};
	$position=0;
	$position2=0;
	undef @pos1;
	undef @pos2;
	$start1=1;
	$start2=1;
	for ($i=0;$i<$len;$i++) {
		$char=substr($hash{canfam},$i,1);
		$char2=substr($hash{acijub},$i,1);
		$j=$i+1;
		if ($char!~/[~-]/) {
		#	print "$char\t$char2\n";
		    $position++;
		    if (exists $canfam{$position}) {
				$tmp="$start1:$j" . "[$canfam{$position}]";
				$start1=$j+1;
				push @pos1, $tmp;
			}
		}
		if ($char2!~/[~-]/) {
			$position2++;
			 if (exists $acijub{$position2}) {
				$tmp="$start2:$j" . "[$acijub{$position2}]";
				$start2=$j+1;
				push @pos2, $tmp;
			}
		}
	}
	
	print OUT ">$name2\taligment_start:alignment_end[exon_prank:exon_name:exon_len:orien:chromose:exon_start:exon_end]\n";
	#print OUT "@pos1\n";
	print OUT "$pos1[0]";
	for ($i=1;$i<=$#pos1;$i++) {
	printf OUT "\t%60s",$pos1[$i];
	}
	print OUT "\n";
	
	#print OUT "@pos2\n";
	print OUT "$pos2[0]";
	for ($i=1;$i<=$#pos2;$i++) {
	printf OUT "\t%60s",$pos2[$i];
	}
	print OUT "\n";
}
close OUT;
