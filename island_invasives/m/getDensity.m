clear
graficar=false;
load('C:\Users\Public\Documents\Datos\Erradicación de roedores\Cayo Centro 2015\NERD Output\20150328T151042_2da_01-06_nerd.mat','X','Y','totalDensity','spatialResolution');
figure
hold on
filename='C:\Users\ALIEN-GECI\Desktop\Imagenes satelitales Banco Chinchorro\CCentro_RGB.tif';
if graficar
    [cc, R, bbox] = geotiffread(filename);
    mapshow(cc, R);
end
h=pcolor(X,Y,totalDensity);
shading flat
axis equal
caxis([0 ceil(prctile(totalDensity(totalDensity>0),95)/10)*10])
if graficar
    set(h,'FaceAlpha',.5);
end
if ~graficar
    colorbar
end

%%% Línea de costa
S.CoastlineFiles{1}=['C:\Users\Public\Documents\Datos\Erradicación de roedores\Cayo Centro 2015\NERD Input\Linea costa CC NERD\CC_Linea de costa_NERD_2015.shp'];
[xv,yv]=getCoastline(S,'16 N');
h1=plot(xv,yv,'w','linewidth',2);
h2=plot(xv,yv,'k','linewidth',1);

%%% Plots
consumo_xy=csvread('C:\Users\Public\Documents\Datos\Erradicación de roedores\Cayo Centro 2015\Datos crudos\CC Plots definitivos CC Marzo 2015.csv',1,0);
theta=linspace(0,2*pi);
x=3*cos(theta);
y=3*sin(theta);
plot(consumo_xy(:,1),consumo_xy(:,2),'w.','markersize',10)
for i=1:length(consumo_xy);
    plot(x+consumo_xy(i,1),y+consumo_xy(i,2),'y','linewidth',2)
end

title('Haz zoom y Presiona ENTER...','fontsize',14)
zoom
pause
ejes=axis;
enZoom=(X>=ejes(1)&X<=ejes(2)&Y>=ejes(3)&Y<=ejes(4));
enZoom=enZoom&totalDensity>0;
d=nanmean(totalDensity(enZoom));
title(['Densidad promedio: ' num2str(round(d*10)/10) ' kg/ha. Haz clic...'],'fontsize',14)
disp(['Densidad promedio: ' num2str(round(d*10)/10) ])
[xi,yi]=ginput(1);
zi = interp2(X,Y,totalDensity,xi,yi);
title(['Densidad puntual: ' num2str(round(zi*10)/10)],'fontsize',14)
disp(['Densidad puntual: ' num2str(round(zi*10)/10)])
drawnow;
bins=linspace(0,ceil(prctile(totalDensity(enZoom),95)/10)*10,11);
bins=bins(2:end);
figure
hist(totalDensity(enZoom),bins)
xlabel('Densidad kg/ha')
ylabel(['\times ' num2str(spatialResolution^2) ' m^2'])
ejes=axis;
axis([min(bins)-mean(diff(bins))/2 max(bins)+mean(diff(bins))/2 ejes(3:4)])
