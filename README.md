# COMPUTUS: Easter Sunday
## computus.m
This little function computes the date of Easter Sunday for present year or specific years, using Oudin's algorithm. It works for the entire Julian calendar (starting 325 AD) and Gregorian calendar (after 1583 AD). An option allows to use the Western Orthodox Church calendar instead of the default Catholic Church.

Easter day is useful to calculate other Christian feasts, like
*Ash Wednesday* (Easter - 46), *Good Friday* (Easter - 2), *Ascension Thursday* (Easter + 39), *Pentecost* (Easter + 49) and others.

The function might recognize most of the Christian days related to Easter, and understand English and French feast names.

## Examples

```matlab
>> computus
Sunday 04 April 2021
>> computus orthodox
Sunday 02 May 2021
>> computus(2024)
Sunday 31 March 2024
>> computus ash
Wednesday 06 March 2019
>> computus(2020:2022,'ascension')
Thursday 21 May 2020
Thursday 13 May 2021
Thursday 26 May 2022
```

See help for syntax, and details.

## Author
**François Beauducel**, [IPGP](www.ipgp.fr), [beaudu](https://github.com/beaudu), beauducel@ipgp.fr

## Documentation
Type `doc computus` for syntax, and see script comments for details. See also [![View computus on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://fr.mathworks.com/matlabcentral/fileexchange/30885-computus) for users community comments.
