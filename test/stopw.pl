use Lingua::StopWords qw( getStopWords );
my $stopwords = getStopWords('pt');
 
my @words = qw(Preso quarto suspeito de linchar até a morte homem em Porto Alegre);
 
# prints "walrus goo goo g'joob"
print join ' ', grep { !$stopwords->{$_} } @words;
print "\n";
