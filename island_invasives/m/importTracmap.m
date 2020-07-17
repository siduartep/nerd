function S=importTracmap(fileToRead1)
% Import Tracmap data.
%
% The fields in the text file are:
% date        ddmmyyyy
% time        HH:MM:SS
% Lat         Decimal degrees
% Lon         Decimal degrees
% Speed       Knots (input)
% heading     Degrees
% Logging_on  1 or 0 (Boom State)
% altitude    Metres
%
% Read the manual: Tracmap - VL31 Data logger for use in aircraft

% Import the file
newData1 = importdata(fileToRead1);

% Create new variables in the base workspace from those fields.
vars = fieldnames(newData1);
fieldNames = {'Lat','Lon','Speed','heading','Logging_on','altitude'};
n = length(newData1.data);
S = cell2struct(mat2cell(newData1.data,ones(n,1),ones(6,1)), fieldNames, 2);
[S(1:n).date]       = deal(newData1.textdata{:,2}); % ddmmyyyy
[S(1:n).time]       = deal(newData1.textdata{:,3}); % HH:MM:SS
[S(1:n).Geometry]   = deal('Point');
