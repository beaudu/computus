# EASTER: Easter Sunday
## easter.m
This little function computes the date of Easter Sunday for present year or specific years, using Oudin's algorithm. It works for the entire Julian calendar (starting 325 AD) and Gregorian calendar (after 1583 AD).

Easter day is useful to calculate other Christian feasts, like
Ash Wednesday (Easter - 46), Good Friday (Easter - 2), Ascension Thursday (Easter + 39), Pentecost (Easter + 49) and others.

The function might recognise most of the Christian days related to Easter.

## Examples

```matlab
>> easter 
Sunday 21 April 2019 
>> easter(2024) 
Sunday 31 March 2024 
>> easter ash 
Wednesday 06 March 2019 
>> easter(2020:2022,'ascension') 
Thursday 21 May 2020 
Thursday 13 May 2021 
Thursday 26 May 2022
```

See help for syntax, and details.

## Author
**François Beauducel**, [IPGP](www.ipgp.fr), [beaudu](https://github.com/beaudu), beauducel@ipgp.fr 

## Documentation
See help for syntax, and script comments for details.
