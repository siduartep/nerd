function plotDensity(ancho,rapidezNudos,lenguaje)
if nargin==2
    lenguaje='en';
end
rapidez = rapidezNudos *1.852; % km/hr
[x,y,p]=fitFlowRate; % kg/seg
xMin=min(x);
xMax=max(x);
diametro=linspace(xMin,xMax);
flujo=polyval(p,diametro);
densidad = flujo./(rapidez.*ancho) *(3600/1000)*10000;
figure
plot(diametro,densidad,'k','linewidth',2)
if strcmpi(lenguaje,'ES')
    title(['Rapidez: ' num2str(rapidezNudos) ' nudos. Ancho de banda: ' num2str(ancho) ' m.'],'fontsize',14)
    xlabel('Diámetro de apertura (mm)','fontsize',14);
    ylabel('Densidad (kg/ha)','fontsize',14);
else
    title(['Speed: ' num2str(rapidezNudos) ' knots. Swath width: ' num2str(ancho) ' m.'],'fontsize',14)
    xlabel('Aperture size (mm)','fontsize',14);
    ylabel('Density (kg/ha)','fontsize',14);
end

set(gca,'fontsize',14)
grid on