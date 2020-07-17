# I. Definición del _phony_ *all* que enlista todos los objetivos principales
# ===========================================================================
all: README.pdf entrega/nerd_paper.pdf


# II. Declaración de las variables
# ===========================================================================
# Nombre de los archivos que contienen las secciones del artículo
nombreArchivosTex = \
	entrega/nerd_paper.tex \
	entrega/abstract.tex \
	entrega/resumen.tex \
	entrega/introduction.tex \
	entrega/formulation.tex \
	entrega/calibration.tex \
	entrega/application.tex \
	entrega/discussion.tex
# Nombre del archivo que contiene las referencias del artículo
nombreArchivoBib = \
	entrega/references.bib

# Nombres base (sin ruta ni extensión) de los figuras
nombresFiguras = \
	resultados/densidad_vs_apertura_y_rapidez.png \
	resultados/flujo_vs_apertura.png \
	resultados/mapa_densidad.png \
	resultados/perfil_densidad.png


# III. Reglas para construir los objetivos principales
# ===========================================================================
# Módulo para generar el README
README.pdf: README.md
	pandoc README.md -o README.pdf #La fuente README.md debe estar en UTF-8 por el pandoc
	start "" /max "README.pdf"

# Módulo para generar el artículo
entrega/nerd_paper.pdf: $(nombreArchivosTex) $(nombresFiguras) $(nombreArchivoBib)
	if not exist "$(subst /,\,$(@D))" mkdir $(subst /,\,$(@D))
	cd entrega && pdflatex -synctex=1 -interaction=nonstopmode nerd-paper.tex
	cd entrega && bibtex nerd_paper
	cd entrega && pdflatex -synctex=1 -interaction=nonstopmode nerd_paper.tex
	cd entrega && pdflatex -synctex=1 -interaction=nonstopmode nerd_paper.tex
	start "" /max "entrega/nerd_paper.pdf"


# IV. Reglas para construir las dependencias de los objetivos principales
# ===========================================================================
resultados/densidad_vs_apertura_y_rapidez.png: MATLAB/programas/graficaDensidadVsAperturaRapidez.m
	if not exist "$(subst /,\,$(@D))" mkdir $(subst /,\,$(@D))
	runMatlab "MATLAB/programas/graficaDensidadVsAperturaRapidez.m"

resultados/flujo_vs_apertura.png: MATLAB/programas/graficaFlujoVsApertura.m \\$(COMPUTERNAME)\datos-texto\datapackage\nerd\flujo.csv
	if not exist "$(subst /,\,$(@D))" mkdir $(subst /,\,$(@D))
	runMatlab "MATLAB/programas/graficaFlujoVsApertura.m"

resultados/mapa_densidad.png: MATLAB/programas/graficaMapaDensidadChinchorro.m \\$(COMPUTERNAME)\datos\20150709T115340_nerd.mat
	if not exist "$(subst /,\,$(@D))" mkdir $(subst /,\,$(@D))
	runMatlab "MATLAB/programas/graficaMapaDensidadChinchorro.m"

resultados/perfil_densidad.png: MATLAB/programas/graficaPerfilDensidad.m \\$(COMPUTERNAME)\datos-texto\datapackage\nerd\perfil.csv
	if not exist "$(subst /,\,$(@D))" mkdir $(subst /,\,$(@D))
	runMatlab "MATLAB/programas/graficaPerfilDensidad.m"


# V. Reglas del resto de los phonies
# ===========================================================================
# Phony para exportar figuras en PNG
figuras: $(nombresFiguras)

# Phony usado para limpiar residuos de LaTeX y carpeta de resultados generados (PNGs)
clean:
	del entrega\*.pdf
	del entrega\*.aux
	del entrega\*.bbl
	del entrega\*.blg
	del entrega\*.log
	del entrega\*.gz
	del entrega\*.toc
	del /F /S /Q resultados\png 1>nul & rmdir /S /Q resultados\png

