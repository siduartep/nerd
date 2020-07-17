function S = calculate(S)
tic;
devView     = false;
set(S.Status,'string','Initializing...');drawnow;
clc, cla,
datenumTrimble=@(In) datenum([In.UTC_Date ' ' In.UTC_Time],'yyyymmdd HH:MM:SS.FFF');
datenumTracMapGPS=@(In) In.Time;
datenumTracMapDataLogger=@(In) datenum([In.date ' ' In.time],'ddmmyyyy HH:MM:SS');

%%% Wind data
if isfield(S,'WindSpeed')&&isfield(S,'WindDirection')
    windSpeed     = S.WindSpeed; % km/hr = [densityProfile.units.windSpeed]
    windDirection = S.WindDirection; % Direction from which it originates in azimuth degrees
else
    windSpeed     = zeros(1,length(S.InputFiles));
    windDirection = zeros(1,length(S.InputFiles));
    disp('No wind data entered.');
end

%%% Loading dispersion model
densityProfileFilename='.\DensityProfiles.mat';
load(densityProfileFilename)

%%% Plot input data
set(S.Status,'string','Ploting map...');drawnow;
hAxis=gca;
set(hAxis,'NextPlot','add','DataAspectRatio',[1 1 1],'OuterPosition',[.2 .1 .8 .8]);
cumIn=[];
time=[];
for i=1:length(S.InputFiles)
    
    %%% Read shapefile
    inputFile=S.InputFiles{i};
    set(S.Status,'string',['Reading ' inputFile '...']);drawnow;
    [pathstr,name,ext] = fileparts(inputFile);
    isTracMapDataLogger = strcmp(ext,'.txt');
    isTracMapGPS = strcmp(name(1:3),'log')&&strcmp(ext,'.shp');
    isTrimble = (~isTracMapDataLogger)&&(~isTracMapGPS)&&strcmp(ext,'.shp');
    if isTracMapDataLogger
        In = importTracmap(inputFile);
    elseif isTracMapGPS
        In = importGPS(inputFile);
    else % isTrimble
        In = shaperead(inputFile);
    end
    
    %%% >>> %%%
    %%% Adding wind data
    set(S.Status,'string',['Adding wind data...']);drawnow;
    windAngle = (-windDirection(i)-90)*pi/180; % convert from meteorological convention (direction FROM which the wind is blowing) to polar (math)
    [In(:).Wind_Vector] = deal(windSpeed(i)*[cos(windAngle) sin(windAngle)]);
    %%% <<< %%%
    
    %%% Adding aperture diameters
    set(S.Status,'string',['Adding aperture diameters...']);drawnow;
    [In(:).ApertureDiameter] = deal(S.ApertureDiameter(i));
    
    %%% Add fields Lat Lon to structure
    set(S.Status,'string',['Calculating UTM coordinates...']);drawnow;
    if isTrimble
        [In(:).Lon]=In.X;
        [In(:).Lat]=In.Y;
    end
    
    %%% Transform fields X Y to UTM
    if ~isTracMapGPS
        [x,y,utmZone] = wgs2utm([In(:).Lat],[In(:).Lon]);
        x = num2cell(x(:));
        y = num2cell(y(:));
        utmZone = num2cell(utmZone(:));
        [In(:).X]=x{:};
        [In(:).Y]=y{:};
        [In(:).UTM_Zone]=utmZone{:};
    end
    
    %%% Plot data
    set(S.Status,'string',['Ploting data...']);drawnow;
    pointSpec = makesymbolspec('Point',{'Default','MarkerEdgeColor',[0 rand(1,2)]*.25+.75,'Marker','.'});
    S.H.trajectory(i)=mapshow(In,'SymbolSpec',pointSpec);
    drawnow
    
    %%% Get time
    nIn=length(In);
    t=zeros(nIn,1);
    for iIn=1:nIn
        if isTracMapDataLogger
            t(iIn)=datenumTracMapDataLogger(In(iIn));
        elseif isTracMapGPS
            t(iIn)=datenumTracMapGPS(In(iIn));
        else % isTrimble
            t(iIn)=datenumTrimble(In(iIn));
        end    
    end
    time=[time(:); t(:)];
    
    %%% Concatenate data
    set(S.Status,'string',['Storing data...']);drawnow;
    [In([1 end]).Logging_on]=deal(0); % Mark the first and last point on each file in order to distinguish between flights
    if i>1
        cumIn = rmfield(cumIn, setdiff(fieldnames(cumIn), fieldnames(   In)));
           In = rmfield(   In, setdiff(fieldnames(   In), fieldnames(cumIn)));
    end
    cumIn=[cumIn(:);In(:)];
end
In=cumIn;

%%% Sorting by time
set(S.Status,'string','Sorting by time');drawnow;
[sortedTime,ind] = sort(time);
In=In(ind);

%%% Identify when the disperser is open
set(S.Status,'string',['Identifying when the disperser is open...']);drawnow;
isLogging_on=[In.Logging_on]==1;
isLogging_on=isLogging_on(:);
pointSpec = makesymbolspec('Point',{'Default','MarkerEdgeColor','g','Marker','*'});
S.H.logging_on=mapshow(In(isLogging_on(:)),'SymbolSpec',pointSpec);
drawnow

%%%
set(S.Status,'string','...');drawnow;
nIn=length(In);
isNode=isLogging_on(1:end-1)&(diff(isLogging_on)==0); % The disperser is open and the point is not the last one on a transect
speed = [In(isNode).Speed]' * 0.514444; % The las factor is to convert from knots to m/s
apertureDiameter = [In(isNode).ApertureDiameter]';

%%% Calculating wind speed normal to the helicopter's path
set(S.Status,'string','Calculating wind speed normal to the helicopter''s path');drawnow;
windVector=vertcat(In(isNode).Wind_Vector);
theta = -90*pi/180;
rot   = [cos(theta) -sin(theta);sin(theta) cos(theta)];
indNode=find(isNode);
profileVector = [rot*[[In(indNode+1).X]-[In(indNode).X]; [In(indNode+1).Y]-[In(indNode).Y]]]';
normalWindSpeed=dot(windVector,profileVector./repmat(sqrt(sum(profileVector.^2,2)),1,2),2);
if devView
    S.H.windQuiver       = quiver([In(indNode).X]',[In(indNode).Y]',windVector(:,1),windVector(:,2),1,'b');
    S.H.profileQuiver    = quiver([In(indNode).X]',[In(indNode).Y]',profileVector(:,1),profileVector(:,2),'k');
    S.H.normalWindQuiver = quiver([In(indNode).X]',[In(indNode).Y]',normalWindSpeed.*profileVector(:,1)./sqrt(sum(profileVector.^2,2)),normalWindSpeed.*profileVector(:,2)./sqrt(sum(profileVector.^2,2)),1,'r');
end

%%%
set(S.Status,'string','...');drawnow;
startSlope=([In(indNode+1).Y]-[In(indNode-1).Y])./([In(indNode+1).X]-[In(indNode-1).X]);
startSlope=startSlope(:);
startNormalSlope=-1./startSlope;
endSlope=([In(indNode+2).Y]-[In(indNode).Y])./([In(indNode+2).X]-[In(indNode).X]);
endSlope=endSlope(:);
endNormalSlope=-1./endSlope;
r=S.StripeWidth/2;

spatialResolution=5; % [m]
n=ceil(S.StripeWidth/spatialResolution);
rr=linspace(-r,r,n);
startX1 = +r./sqrt(startNormalSlope.^2+1)+[In(indNode).X]';
startX2 = -r./sqrt(startNormalSlope.^2+1)+[In(indNode).X]';
endX1   = +r./sqrt(endNormalSlope.^2+1)+[In(indNode+1).X]';
endX2   = -r./sqrt(endNormalSlope.^2+1)+[In(indNode+1).X]';
startY1 = startNormalSlope.*(startX1-[In(indNode).X]')+[In(indNode).Y]';
startY2 = startNormalSlope.*(startX2-[In(indNode).X]')+[In(indNode).Y]';
endY1   = endNormalSlope  .*(endX1-[In(indNode+1).X]')+[In(indNode+1).Y]';
endY2   = endNormalSlope  .*(endX2-[In(indNode+1).X]')+[In(indNode+1).Y]';

%%% Calculating dispersal functions
set(S.Status,'string','Calculating dispersal functions: 0%');drawnow;
densityFunction = fitDensityProfile(S.StripeWidth); % densityFunction=@(x,apertureDiameter,hSpeed,wSpeed)
nNodes=length(startX1);
for i=1:nNodes
    if mod(i,round(nNodes/10))==0
        set(S.Status,'string',['Calculating dispersal functions: ' num2str(round(i/nNodes*100)) '%']);drawnow;
    end
    startX=linspace(startX1(i),startX2(i),n);
    startY=linspace(startY1(i),startY2(i),n);
    endX=linspace(endX1(i),endX2(i),n);
    endY=linspace(endY1(i),endY2(i),n);
    xx=[startX endX];
    meanxx=mean(xx);
    yy=[startY endY];
    meanyy=mean(yy);
    
    fInterpDispersion{i}=@(xq,yq) griddata(xx-meanxx,yy-meanyy,repmat(densityFunction(rr,apertureDiameter(i),speed(i),normalWindSpeed(i)),1,2),xq-meanxx,yq-meanyy);
end


%%% Calculating total density
set(S.Status,'string','Calculating total density: 0%');drawnow;
x=floor(min([In.X])):spatialResolution:ceil(max([In.X]));
y=floor(min([In.Y])):spatialResolution:ceil(max([In.Y]));
[X Y]=meshgrid(x,y);
totalDensity=zeros(size(X));
nNodes=length(fInterpDispersion);

for i=1:nNodes
    if mod(i,round(nNodes/10))==0
        set(S.Status,'string',['Calculating total density: ' num2str(round(i/nNodes*100)) '%']);drawnow;
    end
    %%% Calculating orientation of the starting profile
    u = [ startX2(i)-startX1(i) , startY2(i)-startY1(i) ];
    v = [ In(indNode(i)+1).X-In(indNode(i)).X , In(indNode(i)+1).Y-In(indNode(i)).Y];
    cosTheta = dot(u,v)/(norm(u)*norm(v));
    theta = acos(cosTheta);
    UxV=cross([u 0],[v 0]);
    signTheta=sign(UxV(end));
    theta = signTheta*theta;
    % If the angle between forward direction of the transect and the
    % positivedirection of the profile (from p1 to p2) is negative then
    % interchange p1/p2.
    if signTheta==-1
        tempX1  = startX1(i);
        startX1(i) = startX2(i);
        startX2(i) = tempX1;
        tempY1  = startY1(i);
        startY1(i) = startY2(i);
        startY2(i) = tempY1;
    end
    %%% Calculating orientation of the endinging profile
    u = [ endX2(i)-endX1(i) , endY2(i)-endY1(i) ];
    cosTheta = dot(u,v)/(norm(u)*norm(v));
    theta = acos(cosTheta);
    UxV=cross([u 0],[v 0]);
    signTheta=sign(UxV(end));
    theta = signTheta*theta;
    % If the angle between forward direction of the transect and the
    % positivedirection of the profile (from p1 to p2) is negative then
    % interchange p1/p2.
    if signTheta==-1
        tempX1  = endX1(i);
        endX1(i) = endX2(i);
        endX2(i) = tempX1;
        tempY1  = endY1(i);
        endY1(i) = endY2(i);
        endY2(i) = tempY1;
    end
    %%% Defining cells
    x=[startX1(i) startX2(i) endX2(i) endX1(i) startX1(i)];
    y=[startY1(i) startY2(i) endY2(i) endY1(i) startY1(i)];
    
    %%% Evaluate functions
    
    %%%% >>>> Debugging
    % disp([num2str(i) ' de ' num2str(nNodes) ': ' num2str(round(i/nNodes*1000)/10) '%'])
    % if i>460
    %   pause;
    % end
    %%%% <<<<
    
    isInsideCell = inpolygon(X,Y,x,y);
    cellDensity=fInterpDispersion{i}(X(isInsideCell),Y(isInsideCell));
    totalDensity(isInsideCell)=totalDensity(isInsideCell)+cellDensity;
    
    %%% Contruct output structure
    StripCell(i).Geometry='Polygon';
    StripCell(i).BoundingBox=[min(x) min(y);max(x) max(y)];
    StripCell(i).X=x;
    StripCell(i).Y=y;
    StripCell(i).Speed = In(indNode(i)).Speed;
    StripCell(i).Average_Density = mean(cellDensity);
    S.H.node(i)=plot(x,y,'color',.6*ones(3,1));
end

%%% Calculating total mass
totalMass = nansum(totalDensity(:))*(spatialResolution.^2);
totalDensity=totalDensity*(1e4); % The factor is for convesion from kg/m^2 to kg/ha

%%% Plot coastline
set(S.Status,'string',['Importing coastline...']);drawnow;
utmZone=utmzone(In(1).Lat, In(1).Lon);
utmZone(3:4)=[' ' utmZone(end)];
[cumCoastlineX,cumCoastlineY]=getCoastline(S,utmZone);

set(S.Status,'string',['Ploting coastline...']);drawnow;
S.H.coastlinePolygon=plot(cumCoastlineX,cumCoastlineY,'color',[255, 165, 0]./255,'linewidth',2);

%%% Find land
set(S.Status,'string',['Finding data over the land surface...']);drawnow;
% isInsideLand = inpolygon(X,Y,cumCoastlineX,cumCoastlineY);
% totalDensity(~isInsideLand)=0;

%%% Transects
set(S.Status,'string',['Determinating transects...']);drawnow;
indFirstNode=find(diff(isLogging_on)==1)+1;
indLastNode=find(diff(isLogging_on)==-1);
if length(indFirstNode)==length(indLastNode)
    for i=1:length(indFirstNode)
        x=[In(indFirstNode(i):indLastNode(i)).X];
        y=[In(indFirstNode(i):indLastNode(i)).Y];
        Transect(i).Geometry='Line';
        Transect(i).BoundingBox=[min(x) min(y);max(x) max(y)];
        Transect(i).X=x;
        Transect(i).Y=y;
        Transect(i).Initial_UTC   = datestr(sortedTime(indFirstNode(i)));
        Transect(i).Final_UTC     = datestr(sortedTime(indLastNode(i)));
        Transect(i).Total_Seconds = (sortedTime(indLastNode(i))-sortedTime(indFirstNode(i)))*24*60*60;
        Transect(i).Average_Speed = mean([In(indFirstNode(i):indLastNode(i)).Speed]);
        S.H.transect(i)=plot(x,y,'r');
    end
else
    warning('It was not possible to determinate transects')
end

%%% Calculate contour lines of equal density
set(S.Status,'string',['Calculating total density isopleths...']);drawnow;
if isfield(S,'ClassIntervals')
    classIntervals=S.ClassIntervals;
else
    classIntervals=round(linspace(0,ceil(prctile(totalDensity(totalDensity>0),99)),5));
end
[Density, S.H.contourFilled]=contour2shp(X,Y,totalDensity,classIntervals);
disp('Classes of density (intervals):');
disp(char({Density(:).Density}'));
S.H.density=pcolor(X,Y,totalDensity);
shading flat
caxis([0 ceil(prctile(totalDensity(totalDensity>0),96)/10)*10])
% colormap winter
colorbar

%%% Exporting to Shapefile
set(S.Status,'string',['Exporting to Shapefile...']);drawnow;
shapewrite(Transect,[S.OutputFolder filesep 'flight_path.shp']);
shapewrite(StripCell,[S.OutputFolder filesep 'averaged_cells.shp']);
shapewrite(Density,[S.OutputFolder filesep 'estimated_bait_density.shp']);

%%% Calculate Total flight time
dt=1.5; % minutes
set(S.Status,'string',['Calculating total flight time...']);drawnow;
flightTime=diff(sortedTime);
flightTime=flightTime(0<flightTime&flightTime<(dt/(24*60)));
totalFlightTime=cumsum(flightTime);
totalFlightTime=totalFlightTime(end);

%%% Calculate Actual dispersal time
set(S.Status,'string',['Calculating actual dispersal time...']);drawnow;
dispersalTime=diff(sortedTime);
dispersalTime=dispersalTime(0<dispersalTime&dispersalTime<(dt/(24*60))&isNode);
actualDispersalTime=cumsum(dispersalTime);
actualDispersalTime=actualDispersalTime(end);

%%% Calculate percentage of treated area
set(S.Status,'string',['Calculating percentage of treated area...']);drawnow;
meanDensity = mean(totalDensity(totalDensity>0));
% totalArea   = sum(double(isInsideLand(:)));
treatedArea = sum(double(totalDensity(:)>0));
% relativeArea = treatedArea/totalArea;
[row,col]=size(totalDensity);

%%% Display Summary
set(S.Status,'string',['Displaying summary...']);drawnow;
filename=[S.OutputFolder filesep 'Summary_' datestr(now,30) '.md'];
fileId=fopen(filename,'wt');
fprintf(fileId,'Summary\n');
fprintf(fileId,'========\n');
fprintf(fileId,'%s\n',S.Name);
fprintf(fileId,'--------\n');
fprintf(fileId,'- **Execution time:** %3.1f minutes\n', toc/60);
fprintf(fileId,'- **Spatial resolution:** %4.1g x %4.1g m^2\n',spatialResolution,spatialResolution);
fprintf(fileId,'- **Matrix size:** %d x %d\n',row,col);
fprintf(fileId,'- **Stripe Width:** %4.1f m\n', r*2);
fprintf(fileId,'- **Mean density:** %4.1f kg/ha\n',meanDensity);
fprintf(fileId,'- **Total flight time:** %d hours, %4.2f min\n',floor(totalFlightTime*24),(totalFlightTime*24-floor(totalFlightTime*24))*60);
fprintf(fileId,'- **Actual dispersal time:** %d hours, %4.2f min\n',floor(actualDispersalTime*24),(actualDispersalTime*24-floor(actualDispersalTime*24))*60);
fprintf(fileId,'- **Treated area:** %4.1f ha\n',treatedArea*(spatialResolution.^2)*(1e-4));
% fprintf(fileId,'- **Percentage of treated area: %4.1f%%\n',relativeArea*100);
fprintf(fileId,'- **Total dispersed bait:** %d kg\n',round(totalMass));
fclose(fileId);
fclose all;
type(filename)

%%% Saving session
set(S.Status,'string',['Saving session...']);drawnow;
save(S.SessionFile)

%%% Activate controls for toogling visibility
set(S.H.visibleTrajectory,'Visible','On');
set(S.H.visibleLogging_on,'Visible','On');
set(S.H.visibleNode,'Visible','On');
set(S.H.visibleDensity,'Visible','On');
set(S.H.visibleCoastlinePolygon,'Visible','On');
set(S.H.visibleTransect,'Visible','On');
set(S.H.measureTool,'Visible','On');



set(gcf,'menubar', 'figure')

%%% Developer view
if devView
    uistack(S.H.windQuiver,       'top')
    uistack(S.H.profileQuiver,    'top')
    uistack(S.H.normalWindQuiver, 'top')
end

%%% Done
set(S.Status,'string','Done.');drawnow;
