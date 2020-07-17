function plotDensityVsApertureSpeed(diametro, rapidez, densidad)
    limiteInferiorDensidad = 0;
    limiteSuperiorDensidad = 30;
    deltaDensidad = 2;
    vectorContornosDensidad = limiteInferiorDensidad:deltaDensidad:limiteSuperiorDensidad;
    contourf(diametro, rapidez, densidad, vectorContornosDensidad)
    hold on
    colormap(gray)
    [resultadoContorno, hContorno] = contour(diametro, rapidez, densidad, vectorContornosDensidad, 'k');
    clabel(resultadoContorno, hContorno, 'FontSize', 18, 'Color', 'w');
    caxis([-10 limiteSuperiorDensidad + 25]);
    colorbar('Limits', [0, limiteSuperiorDensidad], 'Direction', 'reverse');
    axis tight
end
