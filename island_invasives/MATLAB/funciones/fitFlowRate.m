function [diametroApertura, flujoCebo, ajusteCuadratica] = fitFlowRate(Tabla, nombreApertura, nombreFlujo)
% Obtiene valores de las variables de interés
diametroApertura = Tabla.getValue(nombreApertura);
flujoCebo = Tabla.getValue(nombreFlujo);

% Ajusta una cuadrática a los datos
gradoPolinomio = 2;
ajusteCuadratica = polyfit(diametroApertura, flujoCebo, gradoPolinomio);
