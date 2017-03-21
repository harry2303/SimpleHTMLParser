#!/usr/bin/perl
       
use strict;
  
package ParseTrashHTML;
use base qw(HTML::Parser);
use LWP::Simple();

my $html;
my $lookupTag = "span";
my $curTag    = "";
my $url       = "http://www.kreis-alzey-worms.eu/verwaltung/abfall/termine.php?Location=W%C3%B6rrstadt&Type=Next";  

sub start {
     my ($self, $tag, $attr, $attrseq, $origtext) = @_;
     # save the current HTML tag for later checks
       $curTag = $tag;
}
      
sub text {
      my ($self, $text) = @_;
      # check if current Tag is equal to lookup Tag
      if ($curTag eq $lookupTag) {
      # check if $text contains only white spaces
         if ($text =~ /^\s*$/) {
               $lookupTag = "a";
         } else {
          print "$text\n";
          $lookupTag = "span";
          }
      }      
}
  
sub comment {
     my ($self, $comment) = @_;
     # if ($curTag eq $lookupTag) {
     # print "<!—", $comment, "—>\n";
     # }
}
  
sub end {
     my ($self, $tag, $origtext) = @_;
    # if ($tag eq $lookupTag) {
    # print "END: $origtext\n";
    # }
}
  
package main;  
  
my $p = new ParseTrashHTML;
$html = LWP::Simple::get($url);
$p->parse( $html );

# HTML structure to parse, to get the data
#
# Case 1:
# <span> <a href="/verwaltung/abfall/abfallarten/restmuell.php">Restabfall</a> </span>
#
# Case 2:
#  <span>21.03.2017</span>
#

