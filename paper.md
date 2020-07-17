---
title: 'NERD: Numerical Estimation of Rodenticide Density'
tags:
  - aerial broadcast
  - bait bucket
  - Python
  - rodent eradication
  - rodenticide bait density
authors:
  - name: Evaristo Rojas-Mayoral
    orcid: 0000-0001-6812-9562
    affiliation: 1
  - name: Braulio Rojas-Mayoral
    affiliation: 1
  - name: Fernando I. Alvarez-Santana
    affiliation: 1
  - name: Federico A. Méndez-Sánchez
    affiliation: 1
affiliations:
  - name: Grupo de Ecología y Conservación de Islas, A.C. 
    index: 1
date: 16 July 2020
bibliography: references.bib

---

# Summary

Invasive rodents are present on approximately 90% of the world's islands and constitute one of the
most serious threats to both endemic and native island species. The eradication of rodents is
central to island conservation efforts and the aerial broadcast of rodenticide bait is the preferred
dispersal method. To maximize the efficiency of rodent eradication campaigns utilizing aerial
dispersal methods, the generation of accurate and real-time bait density maps are needed.
Traditionally, creating maps to estimate the spatial dispersion of bait on the ground has been
carried out using GIS, which is based on several untested assumptions and is time intensive. To
improve accuracy and speed up the evaluation of aerial operations, we developed a new tool called
NERD: Numerical Estimation of Rodenticide Density. NERD is the implementation of a mathematical
model, in the computing language of MATLAB, which performs calculations with increased accuracy,
displaying results almost in real-time. At its core, the model is a probability density function
describing bait density as a function of the aperture diameter of the bait bucket, the helicopter
speed, and the wind speed. NERD also facilitates the planning of helicopter flight paths and allows
for the instant identification of bait gaps. NERD was effectively used in two recent and successful
rodent eradication campaigns in Mexico: the mouse eradication on San Benito Oeste Island (400 ha) in
the Mexican Pacific, and the rat eradication on Cayo Centro Island (539 ha) from Banco Chinchorro,
in the Mexican Caribbean. The latter represents the largest rodent eradication on a wet tropical
island to date. NERD has proven its efficacy and and can significantly reduce the overall cost of
large-scale rodent eradication campaigns.

# Introduction

The effects of invasive rodent species on island ecosystems are incredibly deleterious, especially
on islands that present high levels of endemism and islands that have evolved in the absence of
predators occupying similar niches to the invasive rodent species or higher order predators
[@Meyers2000]. Under these circumstances, the presence of invasive rodents on islands can lead to
the rapid decline and extinction of native plant and animal species [@Medina2011; @Towns2006]. The
resultant losses are reflected in reduced biodiversity on the affected islands and in many cases,
the emergence of the invasive rodent as the dominant species. In severe cases of rodent invasion,
key island ecosystem services are lost [@Towns2006]. As such, the first step in island restoration
and biodiversity recovery is the eradication of invasive rodent species.

Of the various means of rodent eradication on islands, the aerial broadcast of rodenticide bait is
one of the preferred methods given the obvious advantages. The aerial dispersal of rodenticide can
cover large areas quickly and can mitigate the challenges associated with complex topography. To
assess the effectiveness of an aerial operation, bait density maps are required to evaluate the
spatial variation of bait availability on the ground. However, creating bait density maps has been
traditionally slow and impractical in the field, while taking in situ measurements to evaluate
aerial work is difficult given the challenges associated with field conditions, topography, and
available manpower.

To address these challenges, we have developed NERD: Numerical Estimation of Rodenticide Dispersal.
NERD facilitates the planning of helicopter rodenticide dispersal campaigns by generating bait
density maps automatically and allowing for the instant identification of bait gaps with fewer in
situ measurements. NERD consists of two components, a mathematical model and its implementation in
the computing language of MATLAB. The mathematical model is based on prior calibration experiments
in which the mass flow of rodenticide through a bait bucket is measured. At its core, the model is a
probability density function that describes bait density as a function of bucket aperture diameter,
helicopter speed, and wind speed.

# Formulation

The objective of this section is to show that the function $\sigma(x,y)$ used to represent the
superficial bait density (kg/m$^2$), must comply with the following property
$$\int_{-\frac{w}{2}}^{+\frac{w}{2}} \sigma(x)dx=\frac{\dot{m}}{s},$$ where $\dot{m}$ is the bait
flow (kg/s), $s$ is the speed of the helicopter (m/s), and $w$ is the swath width (m).

![Schematic of a helicopter’s flight path over a swath with three dispersal cells; $w$ is the swath
width; $\delta y$ is the distance between two GPS points; and $A_{\mbox{cell}}$ is the area of a
dispersal cell.\label{fig:esquemaHelicoptero}](helicopter-flight-path.svg)

We set the origin of a Cartesian coordinate system on the middle point of the inferior side of a
rectangle with base $w$ and height $\delta y$. This way, the inferior side is found at $y=0$, the
superior side at $y=\delta y$,the left side at $x=-\frac{w}{2}$ and the right side at
$x=+\frac{w}{2}$.

After the helicopter completes a pass, in each point $(x,y)$ of the rectangle a superficial bait
density is obtained $\sigma(x,y)$. The definition of the superficial bait density of mass $m$
indicates that $\sigma(x,y)=\frac{dm}{dA}$. Rewriting the superficial density substituting $dA$ by
$dydx$ and integrating along the dispersion cell, it follows that % Ambiente para incluir ecuación y
etiquetarla \begin{equation} \delta m=\int_{-\frac{w}{2}}^{+\frac{w}{2}} \int_{0}^{\delta y}
\sigma(x,y)dydx. \label{eq:masaEsIntegralDobleDeDensidad} \end{equation}

\begin{figure} \centering % Ambiente para incluir subfigura \begin{subfigure}[b]{0.45\textwidth}
  \includegraphics[width=\textwidth]{../resultados/png/constant-bait-density.png} \caption{Constant
  bait density along each swath.} \label{fig:densidadConstante} \end{subfigure}
  \begin{subfigure}[b]{0.45\textwidth}
  \includegraphics[width=\textwidth]{../resultados/png/variable-bait-density.png} \caption{Variable
  bait density along each swath.} \label{fig:densidadVariable} \end{subfigure} \caption{Hypothetical
  island with bait swaths. Each green band represents one bait swath. The intensity of the bait
  swath color corresponds to its density, with darker colors indicating greater densities.
  }
\end{figure}


Assuming superficial density is uniform with respect to the helicopter’s flight path, represented in
Figure \ref{fig:densidadConstante}, equation \eqref{eq:masaEsIntegralDobleDeDensidad} becomes
\begin{equation} \frac{\delta m}{\delta y}=\int_{-\frac{w}{2}}^{+\frac{w}{2}}\sigma(x)dx.
\label{eq:densidadLineal} \end{equation}

The left-hand side of the equation represents the linear bait density which is related with the mass
flow of bait from the bucket and the speed of the helicopter.  A helicopter equipped with a
dispersion bucket with a constant mass flow rate, \begin{equation} \dot{m}=\frac{\delta m}{\delta t}
\label{eq:flujoMasico} \end{equation} flies from the point $(0,0)$ to the point $(0,\delta y)$ with
a speed of \begin{equation} s=\frac{\delta y}{\delta t}. \label{eq:rapidez} \end{equation}

Combining equations \eqref{eq:flujoMasico} and \eqref{eq:rapidez}, the linear bait density
\begin{equation} \frac{\delta m}{\delta y}=\frac{\dot{m}}{s},
\label{eq:densidadLinealEsflujoSobreRapidez} \end{equation} is obtained.

Finally, setting equations \eqref{eq:densidadLineal} and
\eqref{eq:densidadLinealEsflujoSobreRapidez} equal to each other, we obtain \begin{equation}
\int_{-\frac{w}{2}}^{+\frac{w}{2}} \sigma(x)dx=\frac{\dot{m}}{s}.
\label{eq:integralDeDensidadEsflujoSobreRapidez} \end{equation}

Equation \eqref{eq:integralDeDensidadEsflujoSobreRapidez}  relates a density that is needed in the
field with the variables of the bait dispersal mechanism.
