package aprsParser;
#This module parses packets from APRS.FI
#Right now, it only prints the first packet's parts.
#The packet is divided into the time (UTC),
#the path, and the message.
#
#Arguments are listed at the beginning, including
#the call to watch and the number of packets to get from the website
#
#Requires:  LWP::Simple, LWP::UserAgent, HTTP::Request,
#HTTP::Response, HTML::Strip


use LWP::Simple;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use HTML::Strip;

#arguments are (call, packet limit)
sub getPackets
{
    my ($call,$packetLimit) = @_;
    my $url = "http://aprs.fi/?c=raw&call=$call&limit=$packetLimit";

    my $browser = LWP::UserAgent->new();
    $browser->timeout(10);
    my $request = HTTP::Request->new(GET => $url);
    my @fullHtml = split /\n/,$browser->request($request)->content;

    my $hs = HTML::Strip->new();
    my @packets;
    my $i = 0;
    foreach my $line (@fullHtml)
    {
	if($line =~ m/raw_line/i)
	{
	    my $packet = $hs->parse($line);
	    my $len = length($packet);
	    my ($time,$path,$message) = $packet =~ /^(.*):(.*):(.*)$/;
	    push(@packets,{"time"=>$time,"path"=>$path,"message"=>$message});
	    $hs->eof;
	}
    }
    
    return (@packets);
}


1;

