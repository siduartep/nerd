%% Grafica perfil de densidad
% Se usan los datos de prueba de dispersión de rodenticida en Oxnard, CA.
clc, clear, close all
%% Preámbulo
% Agrega directorio de funciones, obtiene ruta del archivo de datos y de la
% carpeta de resultados
toolboxes.addFunctionsPath()
rutaDatosTexto = toolboxes.getTextDataPath();
nombreArchivo = [rutaDatosTexto filesep 'datapackage' filesep 'nerd' filesep 'perfil.csv'];
rutaResultados = toolboxes.getResultsPath();

%% Data wrangling
% Importa los datos
TablaDatos = datatools.importTabularDataResource(nombreArchivo);
nombreX = 'distancia';
nombreY = 'densidad';
distancia_m = TablaDatos.getValue(nombreX);
densidad_kg_ha = TablaDatos.getValue(nombreY);

%% Grafica perfil de densidad
plot(distancia_m, densidad_kg_ha,'.k','Markersize',35,'LineWidth',2)
xlabel([TablaDatos.getVariableLongName(nombreX) ' (' TablaDatos.getVariableUnits(nombreX) ')'], 'fontsize', 14)
ylabel([TablaDatos.getVariableLongName(nombreY) ' (' TablaDatos.getVariableUnits(nombreY) ')'], 'fontsize', 14)
grid on
box off
eje = gca;
eje.FontSize = 15;

%% Exporta gráfica
print([rutaResultados filesep 'perfil_densidad.png'],'-dpng','-r600')
