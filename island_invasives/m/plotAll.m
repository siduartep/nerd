clear, close all, clc, hold on, axis equal

spatialResolution=1; % [m]

%%% Foto fondo
filename='C:\Users\ALIEN-GECI\Desktop\Imagenes satelitales Banco Chinchorro\CCentro_RGB.tif';
[cc, R, bbox] = geotiffread(filename);
mapshow(cc, R);

%%% Línea de costa
S.CoastlineFiles{1}=['C:\Users\Public\Documents\Datos\Erradicación de roedores\Cayo Centro 2015\NERD Input\Linea costa CC NERD\CC_Linea de costa_NERD_2015.shp'];
[xv,yv]=getCoastline(S,'16 N');
plot(xv,yv,'g')

%%% Nodos
% minX=min(xv)-100;
% maxX=max(xv)+100;
% minY=min(yv)-100;
% maxY=max(yv)+100;
% [X Y]=meshgrid(minX:maxX,minY:maxY);
% 
% if false
%     tic
%     in = inpolygon(X,Y,xv,yv);
%     disp([num2str(toc/60) ' min'])
% else
%     load matlab in
% end
% hIn=plot(X(in),Y(in),'g.');
% hOut=plot(X(~in),Y(~in),'b.');

%%% Galletas
filename='C:\Users\ALIEN-GECI\Desktop\Memoria USB\Galletas_perimetro_CC_50mV2.shp';
Galletas = shaperead(filename);
plot([Galletas.X]',[Galletas.Y]','r.');

filename='C:\Users\ALIEN-GECI\Desktop\Memoria USB\BCHCC_Galletas_tox_islotes.shp';
Islotes = shaperead(filename);
plot([Islotes.X]',[Islotes.Y]','b.');

%%% Plots
consumo_xy=csvread('C:\Users\Public\Documents\Datos\Erradicación de roedores\Cayo Centro 2015\Datos crudos\CC Plots definitivos CC Marzo 2015.csv',1,0);
theta=linspace(0,2*pi);
x=3*cos(theta);
y=3*sin(theta);
plot(consumo_xy(:,1),consumo_xy(:,2),'w.','markersize',10)
for i=1:length(consumo_xy);
    plot(x+consumo_xy(i,1),y+consumo_xy(i,2),'y','linewidth',2)
end

%%% Helipuerto
heli=[
465701	2053653
465707	2053635
465723	2053638
465720	2053656
465701	2053653];
plot(heli(:,1),heli(:,2),'g:','linewidth',4);
