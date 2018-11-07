#!/usr/bin/perl
#
# CRONVIEW - Fully expand all run times of cron entries for better 
# understanding of job frequency for the next week
#
# Usage:
#
# Pipe in output of a crontab -l to parse all times, or
# if a filename is given as first param then it will use that instead
#

use strict;
use DateTime;
use DateTime::Set;
use DateTime::Event::Cron;

my $cronsched;

my $now = DateTime->now;
my $now2 = $now->clone;

$now->add(minutes => 1);
$now2->add(days => 7);

while( my $cron=<> ) {

	chomp $cron;
    next if ($cron =~ /^\s*$/); 	
    next if ($cron =~ /^#.*$/); 	

	# extract sections
	my @cronbits = split / /, $cron ;

	# this module does not like dow names for some reason
	# so convert to numeric form
	
	my @dow=( "sun","mon", "tue", "wed", "thu", "fri", "sat", "sun" );

	for(my $d = 0; $d <= 7; $d++ ) {
		$cronbits[4] =~ s/$dow[$d]/$d/;
	}

	# build time portion

	my $crontab="";
	for( my $i = 0; $i < 5; $i++) {
		$crontab = "$crontab $cronbits[$i]";
	}

	# build command line
	
	my $cmd="";
	for( my $i=5; $i < scalar(@cronbits); $i++) {

		$cmd = "$cmd $cronbits[$i]";
	}

	print ".";


	# Spans for DateTime::Set

	my  $span = DateTime::Span->from_datetimes(
			start => $now,
			end   => $now2,
			);
	my %parms = (cron => $crontab, span => $span);
	my $set = DateTime::Event::Cron->from_cron(%parms);
	my $iter = $set->iterator;

	while ( my $dt = $iter->next ) {
		$cronsched->{$dt->year}->{$dt->month}->{$dt->day}->{$dt->hour}->{$dt->minute}.="\n\t\t".$cmd;
	};

} 

# Dump resulting set

for( my $y=$now->year; $y<=$now2->year; $y++ ) {
	for( my $m=1; $m<=12; $m++) {
		for( my $d = 1; $d<=31; $d++) {
			for( my $h = 0; $h <= 24 ; $h++) {
				for( my $min = 0; $min <= 60; $min++ ) {

					my $c=$cronsched->{$y}->{$m}->{$d}->{$h}->{$min};
					if( $c ) {
						print "\n","-"x40;
						print "\n| ".$y." | ".$m." | ".$d." | ".$h." | ".$min."\n".$c."\n";
					}
				}
			} 
		}
	}

}



