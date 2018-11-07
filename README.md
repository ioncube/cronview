# cronview
A per minute expansion report of any given crontab...

For a long time I've been hunting for a way to make sense of complex crontab schedules, and not really 
getting anywhere. So I wrote this quick perl script making use of a wonderful CPAN module that 
does all the heavy lifting!

To use, either pipe in the output of *crontab -l* to the script (with any params such as -u), 
or if you happen to have a crontab stored as a file someplace, then again, either pipe or give
the full path as a parameter to the script.

e.g.

```
crontab -l | ./cronview.pl
```


You will of course need to get the CPAN modules installed for this to work:

```
cpan DateTime
cpan DateTime::Set
cpan DateTime::Event::Cron
```


