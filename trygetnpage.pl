#!perl

use common::sense;
use DDP;
use Web::Scraper;
use URI;

my $url = URI->new(
    'http://g1.globo.com/rs/noticia/plantao.html');

my $dom = scraper{
    process 'span', 'npages[]' => 'TEXT'};

my $scrape = $dom->scrape($url);
p$scrape->{npages}[78];



