%% Gráfica de la densidad en función de la apertura y rapidez
% Grafica un mapa de la densidad de rodenticida en función del diámetro de
% apertura de la cubeta y la rapidez del helicóptero
clc, clear, close all

%% Preámbulo
% Agrega directorio de funciones, obtiene ruta del archivo de datos y de la
% carpeta de resultados
toolboxes.addFunctionsPath()
rutaDatosTexto = toolboxes.getTextDataPath();
nombreArchivoFlujo = [rutaDatosTexto filesep 'datapackage' filesep 'nerd' filesep 'flujo.csv'];
nombreArchivoPerfil = [rutaDatosTexto filesep 'datapackage' filesep 'nerd' filesep 'perfil.csv'];
rutaResultados = toolboxes.getResultsPath();


%% Data wrangling
% Importa los datos y selecciona los datos del cebo nuevo
TablaDatosPerfil = datatools.importTabularDataResource(nombreArchivoPerfil);
TablaDatosFlujo = datatools.importTabularDataResource(nombreArchivoFlujo);
isNewBait = @(x) x.estado_cebo == "nuevo";
TablaDatosCeboNuevo = TablaDatosFlujo.where(isNewBait);
nombreX = 'apertura';
nombreY = 'flujo';

%% Define el dominio de la densidad
% Las dos variables independientes son diámetro de apertura y rapidez del
% helicóptero
[diametroApertura_mm, ~, ajusteCuadratica] = fitFlowRate(TablaDatosCeboNuevo, nombreX, nombreY);
diametroMinimo = min(diametroApertura_mm);
diametroMaximo = max(diametroApertura_mm);
intervaloDiametroApertura_mm = linspace(diametroMinimo, diametroMaximo);
intervaloRapidezHelicoptero_km_hr = linspace(30,150);

%% Calcula la densidad suponiendo distribución uniforme
anchoBanda_m = 60;
factorConversion = 3.6e4; % Para convertir densidad a kg/ha
[diametro_mm, rapidez_km_hr] = meshgrid(intervaloDiametroApertura_mm, intervaloRapidezHelicoptero_km_hr);
flujoVector = polyval(ajusteCuadratica, diametro_mm(:));
flujo_kg_s = reshape(flujoVector,size(diametro_mm));
densidad_kg_ha = flujo_kg_s./(rapidez_km_hr.*anchoBanda_m) * factorConversion;

%% Gráfica de densidad en función de apertura y rapidez
plotDensityVsApertureSpeed(diametro_mm, rapidez_km_hr, densidad_kg_ha)
xlabel([TablaDatosFlujo.getVariableLongName(nombreX) ' (' TablaDatosFlujo.getVariableUnits(nombreX) ')'], 'fontsize', 14)
ylabel([TablaDatosFlujo.getVariableLongName(nombreY) ' (' TablaDatosFlujo.getVariableUnits(nombreY) ')'], 'fontsize', 14)
set(gca, 'fontsize', 14)
print([rutaResultados filesep 'densidad_vs_apertura_y_rapidez'],'-dpng','-r600');
