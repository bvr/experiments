
use XML::Simple;
use Data::Printer;

my $ref = XMLin(\*DATA);

p $ref->{PubmedData};


__DATA__
<all>
<PubmedData>
    <History>
        <PubMedPubDate PubStatus="entrez">
            <Year>2010</Year>
            <Month>6</Month>
            <Day>18</Day>
            <Hour>6</Hour>
            <Minute>0</Minute>
        </PubMedPubDate>
        <PubMedPubDate PubStatus="pubmed">
            <Year>2010</Year>
            <Month>7</Month>
            <Day>19</Day>
            <Hour>6</Hour>
            <Minute>10</Minute>
        </PubMedPubDate>
        <PubMedPubDate PubStatus="medline">
            <Year>2010</Year>
            <Month>8</Month>
            <Day>20</Day>
            <Hour>7</Hour>
            <Minute>0</Minute>
        </PubMedPubDate>
    </History>
    <PublicationStatus>aheadofprint</PublicationStatus>
</PubmedData>
<PubmedData>
    <History>
        <PubMedPubDate PubStatus="entrez">
            <Year>2011</Year>
            <Month>4</Month>
            <Day>18</Day>
            <Hour>10</Hour>
            <Minute>20</Minute>
        </PubMedPubDate>
        <PubMedPubDate PubStatus="pubmed">
            <Year>2011</Year>
            <Month>7</Month>
            <Day>24</Day>
            <Hour>8</Hour>
            <Minute>10</Minute>
        </PubMedPubDate>
        <PubMedPubDate PubStatus="medline">
            <Year>2011</Year>
            <Month>3</Month>
            <Day>4</Day>
            <Hour>5</Hour>
            <Minute>37</Minute>
        </PubMedPubDate>
    </History>
    <PublicationStatus>aheadofprint</PublicationStatus>
</PubmedData>
</all>
