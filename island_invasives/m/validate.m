function mpe = validate(filenameMAT,filenameCSV)
data = csvread(filenameCSV,1,0);
xi=data(:,1);
yi=data(:,2);
z=data(:,3);
esDato = isfinite(z);
xi=xi(esDato);
yi=yi(esDato);
z=z(esDato);
load(filenameMAT,'X','Y','totalDensity');
opcion = 1; % Escojer método para evaluar densidad en el cuadrante
if opcion==1
    %%% Opción 1: Densidad en el centro del cuadrante
    zi = interp2(X,Y,totalDensity,xi,yi);
elseif opcion==2
    %%% Opción 2: Densidad promedio en todo el cuadrante
    theta=linspace(0,2*pi,20);
    r=3;
    xQuadrat=r*cos(theta);
    yQuadrat=r*sin(theta);
    nQuadrats=length(z);
    zi=nan(nQuadrats,1);
    for iQuadrat=1:nQuadrats
        inQuadrat=inpolygon(X,Y,xQuadrat+xi(iQuadrat),yQuadrat+yi(iQuadrat));
        zi(iQuadrat) = nanmean(totalDensity(inQuadrat));
    end
end
% http://en.wikipedia.org/wiki/Mean_percentage_error
mpe = mean((zi-z)./z*100);
% http://en.wikipedia.org/wiki/Mean_absolute_percentage_error
mape = mean(abs((zi-z)./z*100));

pem=(mean(zi)-mean(z))/mean(z)*100;

disp(['Mean percentage error: ' num2str(round(mpe*10)/10) '%'])
disp(['Mean absolute percentage error: ' num2str(round(mape*10)/10) '%'])
disp(['Percentage error of the mean: ' num2str(round(pem*10)/10) '%'])

figure
plot(z,zi,'r.','markersize',15)
hold on
plot([0 max([z(:);zi(:)])],[0 max([z(:);zi(:)])])
for i=1:length(z)
    text(z(i),zi(i),num2str(i),'fontsize',14)
end
axis image
title(['Mean percentage error: ' num2str(round(mpe)) '%'],'fontsize',16)
xlabel('Measured density (kg/ha)','fontsize',14)
ylabel('Estimated density (kg/ha)','fontsize',14)
set(gca,'fontsize',14)
grid on

figure
pcolor(X,Y,totalDensity)
shading flat
axis equal
hold on
plot(xi,yi,'k.','markersize',15)
plot(xi,yi,'w*')
for i=1:length(xi)
    text(xi(i),yi(i),num2str(i),'fontsize',14,'color','w')
end
ylabel('Northing (mN)','fontsize',14)
xlabel('Easting (mE)','fontsize',14)
set(gca,'fontsize',14)
colorbar
disp('Measured, Estimado')
disp([z zi])
