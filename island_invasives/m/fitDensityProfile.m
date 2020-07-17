function densityFunction=fitDensityProfile(swathWidth,graficar)
% [swathWidth] = m
if nargin==1
    graficar=false;
end
densityProfileFilename='.\DensityProfiles.mat';
load(densityProfileFilename)
y=densityProfile.y;
x=densityProfile.x(isfinite(y));
y=densityProfile.y(isfinite(y));
x=x(:);
y=y(:);
[x,indSort] = sort(x,1,'ascend');
y=y(indSort);

%%% Skew Trapezoidal Distribution
w  = swathWidth;
A  = sum(diff(x).*(y(1:end-1)+y(2:end))/2); % Numerical integration (trapezoidal rule, not related with the name of the distribution)
[l,r]=meshgrid(linspace(1,w-1),linspace(1,w-1));
l=l(:);
r=r(:);
isOk=(l+r)<w;
l(~isOk)=[];
r(~isOk)=[];
m = w-(l+r);
h  = 2*A./(l+2*m+r);
x1 = -w/2+l;
x2 = x1+m;
n = length(x1);
xMin=min([-w/2; x]);
xMin=xMin-eps(xMin);
xMax=max([+w/2; x]);
xMax=xMax+eps(xMax);
for i=1:n
    yj=interp1([xMin -w/2 x1(i) x2(i) +w/2 xMax],[0 0 h(i) h(i) 0 0],x);
    error_rms(i)=sqrt(mean((yj-y).^2));
end
indMin = find(error_rms==min(error_rms),1);
x1=x1(indMin);
x2=x2(indMin);
h=h(indMin);
if graficar
    figure
    plot(x,y,'.-','linewidth',2,'markersize',15)
    hold on
    % plot([-w/2 x1 x2 +w/2],[0 h h 0],'k','linewidth',3)
    % title(densityProfile.name)
    title('Density Profile: Oxnard 2013', 'fontsize',16)
    xlabel('Distance from flight path (m)', 'fontsize',14)
    ylabel('Bait density (kg/ha)','fontsize',14)
    set(gca,'FontSize',14)
end
windSpeed=densityProfile.windSpeed;
windAngle     = (-densityProfile.windDirection   -90)*pi/180; % convert from meteorological convention (direction FROM which the wind is blowing) to polar (math)
windVector    = windSpeed*[cos(windAngle) sin(windAngle)];
profileAngle  = (-densityProfile.profileDirection+90)*pi/180; % convert from vector azimuth to polar (math)
profileVector =           [cos(profileAngle) sin(profileAngle)];
normalWindSpeed=dot(windVector,profileVector);
if normalWindSpeed==0
    normalWindSpeed=eps;
end

xShift = (x1+x2)/2;

%%% >>> Substituting x1, x2, and h on the interp1 equation:
% x1 = -(x2-x1)/2+xShift*wSpeed/normalWindSpeed;
% x2 = +(x2-x1)/2+xShift*wSpeed/normalWindSpeed;
% h  = 2*baitFlow/(hSpeed*(x2-x1+w));
% densityFunction=interp1([xMin -w/2 x1 x2 +w/2 xMax],[0 0 h h 0 0],x);
%%% <<<

densityFunction=@(x,apertureDiameter,hSpeed,wSpeed) interp1([xMin -w/2 max(-w/2+1, -(x2-x1)/2+xShift*wSpeed/normalWindSpeed) min(+w/2-1, +(x2-x1)/2+xShift*wSpeed/normalWindSpeed) +w/2 xMax],[0 0 2*calculateFlow(apertureDiameter)/(hSpeed*(min(+w/2-1, +(x2-x1)/2+xShift*wSpeed/normalWindSpeed)-max(-w/2+1, -(x2-x1)/2+xShift*wSpeed/normalWindSpeed)+w)) 2*calculateFlow(apertureDiameter)/(hSpeed*(min(+w/2-1, +(x2-x1)/2+xShift*wSpeed/normalWindSpeed)-max(-w/2+1, -(x2-x1)/2+xShift*wSpeed/normalWindSpeed)+w)) 0 0],x);

%%% >>> units:
% [x] = m
% [apertureDiameter] = mm
% [hSpeed] = m/s (since [calculateFlow] = kg/s)
% [wSpeed] = [normalWindSpeed] = km/hr = [densityProfile.units.windSpeed]
% [densityFunction] = kg/m^2
%%% <<<
