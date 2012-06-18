rubyday-2012-prizes
===================

The scripts used to determine the winners

What we did
-----------

* Exported in CSV format (data.csv) the data collected by this [form](https://docs.google.com/spreadsheet/viewform?formkey=dGwtOXpkeXAtZHRJV0Z6OGtFTlA1MWc6MQ#gid=0)

```bash
./set_scores
./rankings
```

* Retrieved the attendees list (175 people) and iterated a random extraction within an IRB session:

$ irb
irb(main):001:0> (rand * 175).round
