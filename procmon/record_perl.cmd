start procmon /loadconfig perl.pmc /quiet /minimized /backingfile saved_perl.pml

REM do something

procmon /terminate
procmon /openlog saved_perl.pml /saveas saved_perl.csv
