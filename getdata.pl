#!perl

use common::sense;
use LWP::Simple;

my $base_url = 'http://g1.globo.com/dynamo/plantao/rs/#.json';

for my $n (1..789){
    my $url = $base_url;
    $url =~ s/#/$n/; 

    #`mkdir data` if ! -d 'data';
    
    say $url;
    getstore( $url, "data/page$n.js" );
}


# "padrao123" !~ /padrao/; 
