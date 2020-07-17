function plotFlowRate(diametroApertura, flujoCebo, ajustePolinomio)
% Grafica los datos crudos del flujo de cebo vs el diametro de la apertura
figure, hold on
plot(diametroApertura, flujoCebo, '.', 'markersize', 30, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')

% Grafica el modelo ajustados sobre la gráfica de los datos crudos
dominioPolinomio = linspace(min(diametroApertura), max(diametroApertura));
plot(dominioPolinomio, polyval(ajustePolinomio, dominioPolinomio), 'k', 'linewidth', 2)