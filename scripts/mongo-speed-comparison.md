From [Idiots abound](http://www.idiotsabound.com/did-i-mention-mongodb-is-fast-way-to-go-mongo):

# Did I mention #MongoDb is fast?!?! Way to go

So now that I've got a bunch of data in the database, I figured might as well see what queries looked like.  Let me just say WOW.  The details speak pretty much for themselves, but here's a little background on the tests.

I setup MySQL, MongoDb, and CouchDb on one virtual machine.  I ran a script to insert 100,000 documents I pulled down from wikipedia.  Mysql had a single table with 4 columns. MongoDb and CouchDb were schema-less, but their docs had the exact same four properties.  For MongoDb and Mysql I did a query for the individual document id's. For CouchDb I directly selected the document via their CouchDb id.  In both mysql and MongoDb I indexed the id columns.   Then it was time to do 100,000 queries.

    +-------------------------------------------------------------------------+
    |                         100000 Indexed Queries                          |
    +-------------------------------------------------------------------------+
    |           | Average   | Median    | Deviation | Lap Total  | Total      |
    +-------------------------------------------------------------------------+
    | MongoDb   | 0.00025   | 0.00021   | 0.00019   | 24.99955   | 291.38463  |
    | CouchDb   | 0.01098   | 0.01067   | 0.00972   | 1097.85109 | 1101.09003 |
    | MysqlDb   | 0.00199   | 0.00032   | 0.00518   | 199.32546  | 201.88513  |
    +-------------------------------------------------------------------------+

Let me just say WOW!!!!  MongoDb is ridiculously fast.  I mean really, come on already, that's crazy.  When looking at the totals, the "Lap Total"  will be the one you want to look at.  That is the total of just the individual queries.  The "Total" time spent includes the time doing other things inside the code. In the example above during the Mongo test i was also writing to memcache for the next test.

Now if you are really ready to be impressed, take a look at this.  I dropped the indexes in both MongoDb and Mysql.  I expected these to be a good bit slower, so I did a much smaller result set.  I really don't know what to say to these numbers.

    +-----------------------------------------------------------------------+
    |                      100 Non-Indexed Queries                          |
    +-----------------------------------------------------------------------+
    |           | Average   | Median    | Deviation | Lap Total | Total     |
    +-----------------------------------------------------------------------+
    | MongoDb   | 0.05662   | 0.03704   | 0.19267   | 5.66164   | 5.95255   |
    | CouchDb   | 0.04619   | 0.03035   | 0.04323   | 4.61948   | 4.62373   |
    | MysqlDb   | 1.99975   | 1.68468   | 1.99266   | 199.97469 | 199.97834 |
    +-----------------------------------------------------------------------+

Last but not least, I did one more test.  This time I pre-populated memcache with the records, so I could compare really fast speeds with a known really fast storage medium.  At this point I'm going to stop typing because I can only say "fast" so many times.

    +-----------------------------------------------------------------------+
    |                             1000 Queries                              |
    +-----------------------------------------------------------------------+
    |           | Average   | Median    | Deviation | Lap Total | Total     |
    +-----------------------------------------------------------------------+
    | MongoDb   | 0.00035   | 0.00032   | 0.00022   | 0.35469   | 2.77333   |
    | CouchDb   | 0.0164    | 0.01495   | 0.02076   | 16.39814  | 16.42793  |
    | MysqlDb   | 0.00772   | 0.00826   | 0.00557   | 7.71744   | 7.73784   |
    | Memcached | 0.00015   | 8.0E-5    | 0.00026   | 0.15356   | 1.9688    |
    +-----------------------------------------------------------------------+

