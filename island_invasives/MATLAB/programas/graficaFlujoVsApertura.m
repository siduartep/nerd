%% Gráfica del flujo de cebo en función de la apertura 
% Grafica el flujo de salida de cebo a través de la cubeta en función del
% díametro de la apertura
clc, clear, close all

%% Preámbulo
% Agrega directorio de funciones, obtiene ruta del archivo de datos y de la
% carpeta de resultados
toolboxes.addFunctionsPath()
rutaDatosTexto = toolboxes.getTextDataPath();
nombreArchivo = [rutaDatosTexto filesep 'datapackage' filesep 'nerd' filesep 'flujo.csv'];
rutaResultados = toolboxes.getResultsPath();

%% Data wrangling
% Importa los datos y selecciona los datos del cebo nuevo
TablaDatos = datatools.importTabularDataResource(nombreArchivo);
isNewBait = @(x) x.estado_cebo == "nuevo";
TablaDatosCeboNuevo = TablaDatos.where(isNewBait);
nombreX = 'apertura';
nombreY = 'flujo';

%% Grafica del flujo vs apertura
% Ajusta un modelo a los datos y grafica los datos crudos y el modelo
% ajustado
[diametroApertura, flujoCebo, ajusteCuadratica] = fitFlowRate(TablaDatosCeboNuevo, nombreX, nombreY);
plotFlowRate(diametroApertura, flujoCebo, ajusteCuadratica)
xlabel([TablaDatos.getVariableLongName(nombreX) ' (' TablaDatos.getVariableUnits(nombreX) ')'], 'fontsize', 14)
ylabel([TablaDatos.getVariableLongName(nombreY) ' (' TablaDatos.getVariableUnits(nombreY) ')'], 'fontsize', 14)
set(gca, 'fontsize', 14)
grid on

%% Exporta gráfica
print([rutaResultados filesep 'flujo_vs_apertura'], '-dpng', '-r600')