#!/usr/bin/env perl
use aprsParser;


my $call = "YOURCALLHERE";

my $numOfPackets = 1;

if($#ARGV >= 0){$call = $ARGV[0];}
if($#ARGV >= 1){$numOfPackets = $ARGV[1];}

@pack = aprsParser::getPackets($call,$numOfPackets);
doStuffWithPacket(@pack);

sub doStuffWithPacket
{
    my @packs = @_;
    my $last = $#packs;
    my ($time,$path,$message) = ($packs[$last]{'time'},$packs[$last]{'path'},$packs[$last]{'message'});
    #print "Sent on: " . $time . "\n";
    #print "Sent along: $path\n";
    #print "Message: $message\n";
    
    my ($time_and_lat,$lon_and_wind_direction,$weather) = split /\//,$message;
    print "As of: $time\n";
    printf "Temperature: %3dF\n", $weather =~ /t(.*)r/i;
    printf "Humidity: %3d\%\n", $weather =~ /h(.*)./i;
    printf "Rain: %3d inches\n" , $weather =~ /r(.*)p/i;
    my @wind = $message =~ /\_(.*)g/;
    my @gust = $message =~ /g(.*)t/;
    my ($direction,$speed) = split /\//,"@wind";
    printf "Wind: %3d mph at %3d degrees with %3d mph gusts.\n",/\_(.*)g/,($speed,$direction,@gust);
    
}

1;
