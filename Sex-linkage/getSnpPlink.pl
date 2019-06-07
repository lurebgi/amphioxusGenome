#!/usr/bin/perl
use strict;
use List::Util;

open(IN1,"$ARGV[0]") || die "Can't open IN1!\n";##sample
open(IN2,"$ARGV[1]") || die "Can't open IN2!\n";##haps
open(OUT1,">$ARGV[2]") || die "Can't open OUT1!\n";##map
open(OUT2,">$ARGV[3]") || die "Can't open OUT2!\n";##ped

my @sample;
while(<IN1>){
	chomp;
	s/\_female/female/g;
	s/\_male/male/g;
	next unless(/^female|^male/);
	my @tmp=split /\s+/,$_;
	push(@sample,$tmp[0]);
}

my $count;
my %hash;
while(<IN2>){
	chomp;
	my @tmp=split /\s+/,$_;
	$count++;
	my $sam=0;
	my $c1=0;
	my $c2=0;
	for(my $i=5;$i<=$#tmp;$i++){
		if($tmp[$i]==0){
			$c1++;
		}
		else{
			$c2++;
		}
	}
	next if($c1==0 || $c2==0);
	print OUT1 "$tmp[0]\t$tmp[0]:$tmp[2]\t0\t$tmp[2]\n";
	for(my $i=5;$i<=$#tmp;$i+=2){
		my ($a1,$a2);
		if($tmp[$i]==0){
			$a1=$tmp[3];
		}
		else{
			$a1=$tmp[4];
		}
		if($tmp[$i+1]==0){
			$a2=$tmp[3];
		}
		else{
			$a2=$tmp[4];
		}
		$hash{$sam}{$count}="$a1\t$a2";
		$sam++;
	}
}

for(my $i=0;$i<=$#sample;$i++){
	my $sex;
	if($sample[$i]=~ /female/){
		$sex=1;
	}
	else{
		$sex=2;
	}
	print OUT2 "$sample[$i]\t$sample[$i]\t0\t0\t3\t$sex";
	foreach my $key(sort {$a <=> $b} keys %{$hash{$i}}){
		print OUT2 "\t$hash{$i}{$key}";
	}
	print OUT2 "\n";
}
close IN1;
close IN2;
close OUT1;
close OUT2;
