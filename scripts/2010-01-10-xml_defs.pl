# http://stackoverflow.com/questions/4643776/simple-xml-question-for-perl-how-to-retrieve-specific-elements/4645838#4645838

use XML::Twig;

my $content = do { local $/; <DATA> };      # get data

XML::Twig->new(twig_handlers => {
    definition => sub {
        warn "---\n",
            "sequence = ",     $_->att('sequence'), "\n",
            "text = ",         $_->first_child_trimmed_text('text'), "\n",
            "headword = ",     $_->first_child_trimmed_text('headword'), "\n",
            "partOfSpeech = ", $_->first_child_trimmed_text('partOfSpeech'), "\n";
        $_->purge;
    },
})->parsestring($content);


__DATA__
<definitions>
<definition sequence="0" id="0">
<text>
To withdraw one's support or help from, especially in spite of duty, allegiance, or responsibility; desert:  abandon a friend in trouble.
</text>
<headword>abandon</headword>
<partOfSpeech>verb-transitive</partOfSpeech>
</definition>
<definition sequence="1" id="0">

<text>
To give up by leaving or ceasing to operate or inhabit, especially as a result of danger or other impending threat:  abandoned the ship.
</text>
<headword>abandon</headword>
<partOfSpeech>verb-transitive</partOfSpeech>
</definition>

<definition sequence="2" id="0">

<text>
To surrender one's claim to, right to, or interest in; give up entirely. See Synonyms at relinquish.
</text>
<headword>abandon</headword>
<partOfSpeech>verb-transitive</partOfSpeech>
</definition>

</definitions>
