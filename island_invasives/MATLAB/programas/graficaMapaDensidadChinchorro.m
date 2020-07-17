%%
clc, clear, close all

%% Carga datos
load ../../mat/20150709T115340_nerd
chinchorro = islas.Island(RegionID.chinchorro);
chinchorroIslote = chinchorro.Islote(1);

%% Hace |nan| valores de densidad fuera del polígono de la isla
esDentroIsla = inpolygon(X,Y,chinchorroIslote.x,chinchorroIslote.y);
totalDensity(~esDentroIsla) = nan;

%% Define la configuración de los ejes de la gráfica
margen = 250;
limitesEjes = [nanmin(nanmin(X))-margen, nanmax(nanmax(X))+margen, nanmin(nanmin(Y))-margen, nanmax(nanmax(Y))+margen];
ConfiguracionGrafica.nXTicks = 3;
ConfiguracionGrafica.nYTicks = 3;
ConfiguracionGrafica.XLim = limitesEjes(1:2);
ConfiguracionGrafica.YLim = limitesEjes(3:4);
ConfiguracionGrafica.referenciaZonal = ReferenciaZonal.utm;

%% Grafica mapa de densidad de veneno en Banco Chinchorro
figure('units','normalized','outerposition',[0 0 1 1]);
pcolor(X,Y,totalDensity), shading flat
hold on
plot(cumCoastlineX,cumCoastlineY,'Color','k','LineWidth',3)
plot(cumCoastlineX,cumCoastlineY,'Color','w','LineWidth',1)
axis image
hColor = colorbar();
set(hColor.Label,'String','Bait density on ground (kg/ha)','FontSize',20,'FontName','Verdana')
nColores = 300;
paletaColoresVerano = summer(nColores);
paletaColoresOtono = autumn(nColores);
paletaColores = flipud([paletaColoresVerano; flipud(paletaColoresOtono)]); % mapeo.getDensityColorMap();
colormap(flipud(gray))
caxis([0 100])
mapeo.fixTickLabelInMaps(ConfiguracionGrafica)
