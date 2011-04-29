use 5.010;
$sqlquery = sprintf("select sum(f.expenditure)
                     from funds f,ledger l
                     where l.ledger_id in (select ledger_id from ledger
                                           where upper(ledger_name) like 'MONOACQ%' and
                                           substr(ledger_name,length(ledger_name)-4, 5) = '%s') and
                                  f.ledger_id = l.ledger_id and
                                  substr(f.funds_name, 1, instr(f.funds_name,',')-1) like '%e' ", $lastfiscyear);

say $sqlquery;
