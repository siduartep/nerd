function densidad=calculateDensity(ancho,diametro,rapidezNudos)
rapidez = rapidezNudos *1.852; % km/hr
flujo=calculateFlow(diametro); % kg/seg
densidad = flujo./(rapidez.*ancho) *(3600/1000)*10000; % kg/ha