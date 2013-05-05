#!perl

use common::sense;
use DDP;
use Lingua::StopWords qw( getStopWords );
use JSON;

my @files = glob 'data/*js';
my $stopwords = getStopWords('pt');
my $cloud = {};

for my $file (@files) {

    say $file;

    open my $fh, "<", "$file";
    my $content = '';

    while( my $line = <$fh> ) {
        $content .= $line
    }
    
    my $json = from_json( $content );
    my $noticia = {};

    # Dicionario de Noticias
    for my $data (@{ $json->{conteudos} }) {
        my ($year)  = ($data->{primeira_publicacao} =~ /,\s(\d+)\s/);
        my ($month) = ($data->{primeira_publicacao} =~ /^([a-z]+)\s/i);
        my ($day)   = ($data->{primeira_publicacao} =~ /^[a-z]+\s(\d+)/i);

        $data->{titulo} =~ s/\s$//;

        push @{ $noticia->{$year}{$month}{$day} }, $data->{titulo};
    }

    for my $ano ( keys %$noticia ){
      for my $mes (keys %{ $noticia->{$ano} }) {
        for my $dia (keys %{ $noticia->{$ano}{$mes} }) {
          for my $titulo ( @{ $noticia->{$ano}{$mes}{$dia} }) {

            $titulo =~ s/,|'//g;
            $titulo =~ s/\d+[h%ª]?//g;
            $titulo =~ s/mortes/morte/gi;
            $titulo =~ s/sa[uú]de/saude/gi;

            my @words_clean = grep { !$stopwords->{$_} } split/\s+/, $titulo;
            
            for my $word (@words_clean){
                next if length $word < 2;
                $cloud->{$ano}{$mes}{lc $word}++;
            }

          }
        }
      }
    }
}

my $print = ";Morte;Saúde\n";

for my $ano ( keys %$cloud ){
  for my $mes (keys %{ $cloud->{$ano} }) {
#    for my $word (keys %{ $cloud->{$ano}{$mes} }) {

    #  next if $word !~ /morte|sa[úu]de/i;

    

     my $occ_morte = $cloud->{$ano}{$mes}{morte};
     my $occ_saude = $cloud->{$ano}{$mes}{saude};
     $print .= "${ano}_$mes;$occ_morte;$occ_saude\n";

#    }
  }
}


open my $fh, '>', 'dump.csv';
print $fh $print;
