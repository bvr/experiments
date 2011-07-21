
while(<DATA>) {
    chomp;
    print "$_\t$1\n" if /\((\d+)[:)]/;
}

__DATA__
signal(123)
pressSensorAilCurrentStimT(436:436+5)
round(100*signal(123))
round(1000*pressSensorAilCurrentStimT(436:436+5))/1000
