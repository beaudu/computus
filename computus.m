function varargout=computus(varargin)
%COMPUTUS Easter day and other Christian dates
%	COMPUTUS displays the date of Easter Sunday for present year, expressed
%	in the Gregorian calendar.
%
%	COMPUTUS(YEAR) displays the date of Easter for specific YEAR, which
%	can be scalar or vector/matrix.
%
%	COMPUTUS(YEAR,DAY) or COMPUTUS(DAY) calculates other Christian feasts using
%	DAY as one - or any significant part - of the following strings (case
%	insensitive):
%	   'Mardi Gras/Shrove Thurday' (Easter-47)
%	   'Ash Wednesday' (Easter-46)
%	   'Mi-Careme/Mid-Lent' (Easter-24)
%	   'Palm Sunday' (Easter-7)
%	   'Holy Thurday' (Easter-3)
%	   'Good Friday' (Easter-2)
%	   'Holy Saturday' (Easter-1)
%	   'Easter Monday' (Easter+1)
%	   'Ascension Day' (Easter+39)
%	   'Pentecost' (Easter+49)
%	   'Whit Monday' (Easter+50)
%
%	COMPUTUS(...,CHURCH) computes Easter Day for selected CHURCH:
%	   'western', 'occident' or 'catholic' for Western Catholic (default),
%	   'eastern', 'orient' or 'orthodox' for Eastern Orthodox.
%
%	E=COMPUTUS(...) returns day(s) in DATENUM format.
%
%	This function computes Easter Day using the Oudin's algorithm [1940],
%	which is valid for Catholic Easter day from 325 AD (beginning of the
%	Julian calendar).
%
%	Examples:
%	   >> computus
%	   Sunday 21 April 2019
%	   >> computus(2024)
%	   Sunday 31 March 2024
%	   >> computus ash
%	   Wednesday 06 March 2019
%	   >> computus(2020:2022,'ascension')
%	   Thursday 21 May 2020
%	   Thursday 13 May 2021
%	   Thursday 26 May 2022
%
%	Reference:
%	   Oudin, 1940. Explanatory Supplement to the Astronomical Almanac,
%	      P. Kenneth Seidelmann, editor.
%	   Tondering, C, 2008. http://www.tondering.dk/claus/calendar.html
%
%	Author: François Beauducel, <beauducel@ipgp.fr>
%	Created: 2002-12-26 in Guadeloupe (FWI)
%	Updated: 2021-01-10

%	Copyright (c) 2002-2021 François Beauducel, covered by BSD License.
%	All rights reserved.
%
%	Redistribution and use in source and binary forms, with or without
%	modification, are permitted provided that the following conditions are
%	met:
%
%	   * Redistributions of source code must retain the above copyright
%	     notice, this list of conditions and the following disclaimer.
%	   * Redistributions in binary form must reproduce the above copyright
%	     notice, this list of conditions and the following disclaimer in
%	     the documentation and/or other materials provided with the distribution
%
%	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
%	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
%	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
%	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
%	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
%	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
%	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
%	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
%	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
%	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
%	POSSIBILITY OF SUCH DAMAGE.

julian_start = 325;
gregorian_start = 1583;

% default is current year
year = str2double(datestr(now,'yyyy'));

% table of delays from Easter (in days) and feast names
F = { ...
  -47, 'mardi gras fat tuesday shrove tuesday pancake day';
  -46, 'mercredi cendres ash wednesday';
  -24, 'mi careme mid lent';
  -7,  'dimanche rameaux palm sunday';
  -6,  'lundi saint holy monday';
  -5,  'mardi saint holy tuesday';
  -4,  'mercredi saint holy wednesday';
  -3,  'jeudi saint holy thurday maundy thurday';
  -2,  'vendredi saint good friday';
  -1,  'samedi saint holy saturday';
  0,   'dimanche de paques easter sunday';
  1,   'lundi paques easter monday';
  7,   'dimanche divine misericorde divine mercy sunday';
  14,  'misericordia domini';
  21,  'jubilate sunday';
  28,  'cantate sunday';
  39,  'jeudi ascension day';
  49,  'pentecote pentecost';
  50,  'whit monday';
};
feast = '';
orthodox = 0;
k = find(strcmpi(varargin,'eastern') | strcmpi(varargin,'orient') | strcmpi(varargin,'orthodox'));
if ~isempty(k)
	orthodox = 1;
	varargin{k} = [];
end

nargs = nargin - orthodox;

% syntax (YEAR) or (YEAR,FEAST) or (FEAST)
% (strjoin is to accept multi-word as multi-arguments)
if nargs > 0
	if isnumeric(varargin{1}) || ~isnan(str2double(varargin{1}))
		year = varargin{1};
		if ischar(year)
			year = str2double(year);
		end
		if nargs > 1 && all(cellfun(@ischar,varargin(2:end)))
			feast = strjoin(varargin(2:end),' ');
		end
	elseif all(cellfun(@ischar,varargin))
		feast = strjoin(varargin,' ');
	end
end

% looks for days other than Easter Sunday
day = 0;
if ~isempty(feast)
	str = regexprep(feast,'-| de | des | l''''',' ','ignorecase');
	%k = contains(F(:,2),str); % for Matlab > 2016b
	k = ~cellfun(@isempty,strfind(F(:,2),str));
	if sum(k) > 1
		error('Ambiguous name "%s" for FEAST. Be more specific.',feast);
	end
	if sum(k) == 1
		day = F{k,1};
	else
		error('Unknown FEAST name "%s".',feast)
	end
end

% takes integer part of YEAR
year = floor(year);

if any(year < julian_start)
	warning('Some dates are unvalid (before Julian calendar %d AD)',julian_start);
end

G = mod(year,19);	% Golden number - 1

k = (year >= gregorian_start & ~orthodox);
yw = year(k);
ye = year(~k);
if ~isempty(yw)
	C = floor(yw/100);
	C_4 = floor(C/4);
	H = mod(19*G + C - C_4 - floor((8*C + 13)/25) + 15,30);
	K = floor(H/28);
	I = (K.*floor(29./(H + 1)).*floor((21 - G)/11) - 1).*K + H;	% days between the full Moon and March 21
	J = mod(floor(yw/4) + yw + I + 2 + C_4 - C,7);
else
	I = mod(19*G + 15, 30);
	J = mod(ye + floor(ye/4) + I,7);
end
L = I - J;	% number of days from 21 March to the Sunday on or before the Pascal full moon
if orthodox
	M = floor(3 + (L + 40)/44);	% Easter Month
	P = j2g(year,M,28 + L - 31*floor(M/4));	% Easter Sunday
else
	P = datenum(year,3,28 + L);		% Easter Sunday
end
if nargout > 0
	varargout{1} = P + day;
else
	display(datestr(P + day,'dddd dd mmmm yyyy'))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% corrects the day from Julian date to Gregorian
function gd=j2g(year,month,day)

dj = 10*ones(size(year));
dj(year>=1700 & year<1800) = 11;
dj(year>=1800 & year<1900) = 12;
dj(year>=1900 & year<2100) = 13;
dj(year>=2100) = 14;

gd = datenum(year,month,day + dj);
