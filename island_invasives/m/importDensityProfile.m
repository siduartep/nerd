% DEPRECIATED since february 2015. Do not use.
function importDensityProfile(calibrationFilename)
load(calibrationFilename,'densityProfile');
[filename, pathname, filterindex] = uigetfile('*.xls*', 'Pick a MS-Excel file');
num = xlsread([pathname filename]);
filename=filename(1:max(findstr(filename,'.'))-1);
varname = genvarname(filename);
densityProfile.(varname).x=num(:,1);
densityProfile.(varname).y=num(:,2);
densityProfile.(varname).units.baitFlow='kg/seg';
densityProfile.(varname).units.helicopterSpeed='Knots';
densityProfile.(varname).units.profileDirection='Direction of the profile (independent variable increases or positive x-axis) in azimuth degrees';
densityProfile.(varname).units.windDirection='Direction from which it originates in azimuth degrees';
densityProfile.(varname).units.windSpeed='km/hr';

prompt={'Profile name:', ...
    ['Bite flow rate [' densityProfile.(varname).units.baitFlow ']:'], ...
    ['Helicopter speed [' densityProfile.(varname).units.helicopterSpeed ']:'], ...
    ['Profile direction [' densityProfile.(varname).units.profileDirection ']:'], ...
    ['Wind direction [' densityProfile.(varname).units.windDirection ']:'], ...
    ['Wind speed [' densityProfile.(varname).units.windSpeed ']:'], ...
    };
title='Input Profile Data';
numlines=1;
defaultanswer={filename,'0.5','40','0','0','0'};
answer=inputdlg(prompt,title,numlines,defaultanswer);
densityProfile.(varname).name=answer{1};
densityProfile.(varname).baitFlow=str2num(answer{2});
densityProfile.(varname).helicopterSpeed=str2num(answer{3});
densityProfile.(varname).profileDirection=str2num(answer{4});
densityProfile.(varname).windDirection=str2num(answer{5});
densityProfile.(varname).windSpeed=str2num(answer{6});
save(calibrationFilename,'densityProfile')
fitDensityDistribution(calibrationFilename)
