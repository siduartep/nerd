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
    corresponding: true
    affiliation: 1
  - name: Braulio Rojas-Mayoral
    orcid: 0000-0003-2358-2843
    affiliation: 1
  - name: Federico A. Méndez-Sánchez
    orcid: 0000-0002-3467-0008
    affiliation: 1
affiliations:
  - name: Grupo de Ecología y Conservación de Islas
    index: 1
bibliography: references.bib

...

# Summary

Invasive rodents are present on approximately 90% of the world's islands and constitute one of the most serious threats to both endemic and native island species. The eradication of rodents is central to island conservation efforts and the aerial broadcast of rodenticide bait is the preferred dispersal method. To maximize the efficiency of rodent eradication campaigns utilizing aerial dispersal methods, the generation of accurate and real-time bait density maps are needed.
Traditionally, the creation of ground-level bait dispersion maps has relied on Geographic Information System (GIS), an approach that is time-consuming and based on untested assumptions. In order to improve accuracy and expedite the evaluation of aerial operations, we developed a mathematical model called NERD: Numerical Estimation of Rodenticide Density, which performs calculations with heightened precision and provides immediate results. At its core, the model is a probability density function describing bait density as a function of the aperture diameter of the bait bucket and the helicopter speed. NERD also facilitates the planning of helicopter flight paths allowing the instant identification of bait gaps. Furthermore, the effectiveness of the model was effectively demonstrated through its successful utilization in two successful rodent eradication campaigns in Mexico: the mice eradication on San Benito Oeste Island (400 ha) in the Mexican Pacific, and the rats eradication on Cayo Centro Island (539 ha) from Banco Chinchorro, in the Mexican Caribbean. Notably, the latter campaign represents the largest rodent eradication on a wet tropical island to date. NERD's efficacy has been proven, and it has the potential to significantly reduce the overall cost of large-scale rodent eradication campaigns.

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

# Statement of need

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
situ measurements. The mathematical model is based on prior calibration experiments
in which the mass flow of rodenticide through a bait bucket is measured. At its core, the model is a
probability density function that describes bait density as a function of bucket aperture diameter and
helicopter speed.

# Formulation

The objective of this section is to show that the function $\sigma(x,y)$ used to represent the
superficial bait density (kg/m$^2$), must comply with the following property:
$$\int_{-\frac{w}{2}}^{+\frac{w}{2}} \sigma(x)dx=\frac{\dot{m}}{s}$$ where $\dot{m}$ is the bait
flow (kg/s), $s$ is the speed of the helicopter (m/s), and $w$ is the swath width (m).

![Schematic of a helicopter’s flight path over a swath with three dispersal cells; $w$ is the swath
width; $\delta y$ is the distance between two GPS points; and $A_{\mbox{cell}}$ is the area of a
dispersal cell. \label{fig:esquemaHelicoptero}](figures/helicopter-flight-path.png)



We set the origin of a Cartesian coordinate system on the middle point of the inferior side of a
rectangle with base $w$ and height $\delta y$. This way, the inferior side is found at $y=0$, the
superior side at $y=\delta y$,the left side at $x=-\frac{w}{2}$ and the right side at
$x=+\frac{w}{2}$.


After the helicopter completes a pass, in each point $(x,y)$ of the rectangle a superficial bait
density is obtained $\sigma(x,y)$. The definition of the superficial bait density of mass $m$
indicates that $\sigma(x,y)=\frac{dm}{dA}$. Rewriting the superficial density substituting $dA$ by
$dydx$ and integrating along the dispersion cell, it follows that: \begin{equation} \delta m=\int_{-\frac{w}{2}}^{+\frac{w}{2}} \int_{0}^{\delta y}
\sigma(x,y)dydx \label{eq:masaEsIntegralDobleDeDensidad} \end{equation}

Assuming superficial density is uniform with respect to the helicopter’s flight path, equation \eqref{eq:masaEsIntegralDobleDeDensidad} becomes
\begin{equation} \frac{\delta m}{\delta y}=\int_{-\frac{w}{2}}^{+\frac{w}{2}}\sigma(x)dx.
\label{eq:densidadLineal} \end{equation}

The left-hand side of the equation represents the linear bait density which is related with the mass
flow of bait from the bucket and the speed of the helicopter.  A helicopter equipped with a
dispersion bucket with a constant mass flow rate, \begin{equation} \frac{\dot{m}}{1}=\frac{\delta m}{\delta t}\end{equation}
\begin{equation} {\delta t}=\frac{\delta m}{\dot{m}}
\label{eq:flujoMasico} \end{equation}

flies from the point $(0,0)$ to the point $(0,\delta y)$ with a speed of:
\begin{equation} \frac{s}{1}=\frac{\delta y}{\delta t} \end{equation}
\begin{equation} {\delta t}=\frac{\delta y}{s}
\label{eq:rapidez} \end{equation}

Combining equations \eqref{eq:flujoMasico} and \eqref{eq:rapidez}, the linear bait density
\begin{equation} \frac{\delta m}{\delta y}=\frac{\dot{m}}{s} \end{equation}

\begin{equation} \frac{\delta m}{\dot{m}}=\frac{\delta y}{s} \end{equation}

\begin{equation} \frac{\delta m}{\delta y}=\frac{\dot {m}}{s} \end{equation}

\label{eq:densidadLinealEsflujoSobreRapidez} is obtained.

Finally, setting equations \eqref{eq:densidadLineal} and
\eqref{eq:densidadLinealEsflujoSobreRapidez} equal to each other, we obtain \begin{equation}
\int_{-\frac{w}{2}}^{+\frac{w}{2}} \sigma(x)dx=\frac{\dot{m}}{s}.
\label{eq:integralDeDensidadEsflujoSobreRapidez} \end{equation}

Equation \eqref{eq:integralDeDensidadEsflujoSobreRapidez}  relates a density that is needed in the
field with the variables of the bait dispersal mechanism.

# Calibration

Assuming the density is independent of $x$, i.e. $\sigma$ does not change along the swath width,
equation \eqref{eq:integralDeDensidadEsflujoSobreRapidez} can be easily solved to obtain

\begin{equation}
  \sigma = \frac{\dot{m}}{s\cdot w}.
  \label{eq:densidadEsFlujoSobreProductoRapidezPorAncho}
\end{equation}

In order to write equation \eqref{eq:densidadEsFlujoSobreProductoRapidezPorAncho} as a function of
the aperture diameter of the bait bucket, we express the mass flow rate of bait as a function of the
aperture diameter, $\dot{m}(d)$. To do this, the bait in the bucket was weighed and the time
required to empty the bucket was measured and repeated using several aperture diameters. Figure
\ref{fig:flujoDeApertura} shows the results from the calibration as well as the fitted model.

## Calibration Demonstration


```python
import nerd
import nerd.calibration
import nerd.density_functions
```


```python
%matplotlib inline
import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch
import numpy as np
import pandas as pd
```

## Fit flow rate


```python
flow_data = pd.read_csv("/workdir/data/flujo.csv")
flow_data = flow_data[flow_data.estado_cebo == "nuevo"][["apertura", "flujo"]]
```


```python
aperture_diameters = flow_data.apertura.values
flow_rates = flow_data.flujo.values
flow_rate_function = nerd.calibration.fit_flow_rate(aperture_diameters, flow_rates)
```


```python
x = np.linspace(min(aperture_diameters) - 10, max(aperture_diameters) + 10)
y = flow_rate_function(x)
fontsize = 25


plt.plot(x, y)
plt.plot(aperture_diameters, flow_rates, "o", markeredgecolor="k")
plt.xlabel("Aperture diameter (mm)", size=fontsize)
plt.ylabel("Mass flow rate (kg/s)", size=fontsize)
plt.xlim(50, 100)
plt.ylim(0, 3)
plt.xticks(size=fontsize)
plt.yticks(size=fontsize)
plt.savefig("calibration.png", dpi=300, transparent=True)
```


    
![png](paper_files/paper_25_0.png)
    


![Flow rate $\dot{m}$ (kg/s) as a function of aperture diameter, $d$ (mm); each symbol represents a
calibration event and the black curve is the quadratic model fitted to the data.
\ref{fig:densidadDeAperturaYRapidez} Surface bait density $\sigma$ (kg/ha) as a function of aperture
diameter $d$ (mm), and speed $s$ (km/hr). The horizontal axis shows the aperture diameter of the
bait bucket and the vertical axis shows the helicopter's speed. The resulting bait density on the
ground is shown in the second vertical color axis. $\dot{m}(d)$.
\label{fig:flujoDeApertura}]

The resulting three-dimensional model, $$\sigma(d,s)= \frac{\dot{m}(d)}{s\cdot w},$$ is shown in
Figure \ref{fig:densidadDeAperturaYRapidez}. During the planning stage of an eradication campaign,
this model can be used to determine the diameter of the bait bucket needed to achieve the desired
bait density on the ground, ensuring efficient bait coverage, while maximizing resources, time and
labor force.

## Swath width


```python
density_profile = pd.read_csv("/workdir/data/perfil.csv")
```


```python
distance = density_profile.distance.values
density_kg_per_ha = density_profile.density.values
density = density_kg_per_ha / 1e4  # To convert densities to kg per square meter
swath_width = nerd.calibration.get_swath_width(distance, density)
```


```python
plt.plot(distance, density_kg_per_ha, "o")
plt.xlabel("Position from flightpath (m)", size=fontsize)
plt.ylabel("Bait Density (kg/ha)", size=fontsize)
plt.xlim(-40, 40)
plt.ylim(0, 6)
plt.xticks(size=fontsize)
plt.yticks(size=fontsize)
plt.text(
    -0.5,
    3,
    "Flightpath",
    size=15,
    color="k",
    rotation=90,
    bbox=dict(facecolor="w", edgecolor="none"),
)
plt.axvline(0, color="k")
# plt.axvline(swath_width/2, color="k")
plt.savefig("plots.png", dpi=300, transparent=True)
```


    
![png](paper_files/paper_31_0.png)
    


## Select best density function


```python
aperture_diameter_data = 55  # milimetres
helicopter_speed_data = 20.5778  # meters per second (40 knots)
```


```python
density_function = nerd.calibration.get_best_density_function(
    distance,
    density,
    aperture_diameter_data,
    helicopter_speed_data,
    swath_width,
    flow_rate_function,
)
estimated_profile = nerd.solver(
    aperture_diameter_data,
    helicopter_speed_data,
    swath_width,
    density_function,
    flow_rate_function,
)
```


```python
x = np.linspace(min(distance), max(distance))
y = estimated_profile(x)
estimated_density = estimated_profile(distance)
plt.figure(figsize=[11, 8])
plt.plot(x, y, "r", label="estimated density")
plt.vlines(distance, density, density + estimated_density - density, "k")
plt.plot(
    distance,
    density,
    "s",
    color="orange",
    markeredgecolor="black",
    label="real density",
)
plt.xlabel("Distance (m)")
plt.ylabel("Density (kg/m$^2$)");
```


    
![png](paper_files/paper_35_0.png)
    


## Calibration model


```python
aperture_diameters_domain = np.linspace(min(aperture_diameters), max(aperture_diameters))
helicopter_speeds_domain = np.linspace(10, 50)
density_matrix = nerd.calibration.model(
    aperture_diameters_domain,
    helicopter_speeds_domain,
    swath_width,
    nerd.density_functions.uniform,
    flow_rate_function,
)
helicopter_speed_kmh = helicopter_speeds_domain * 3.6
```

    /opt/conda/lib/python3.10/site-packages/scipy/optimize/_minpack_py.py:178: RuntimeWarning: The iteration is not making good progress, as measured by the 
      improvement from the last ten iterations.
      warnings.warn(msg, RuntimeWarning)



```python
density_matrix[0]
```




    array([0.00060909, 0.00062693, 0.00064619, 0.00066687, 0.00068896,
           0.00071247, 0.00073739, 0.00076374, 0.00079149, 0.00082066,
           0.00085125, 0.00088326, 0.00091668, 0.00095152, 0.00098777,
           0.00102544, 0.00106453, 0.00110503, 0.00114695, 0.00119028,
           0.00123503, 0.0012812 , 0.00132878, 0.00137778, 0.00142819,
           0.00148003, 0.00153327, 0.00158794, 0.00164402, 0.00170151,
           0.00176042, 0.00182075, 0.0018825 , 0.00194566, 0.00201023,
           0.00207623, 0.00214364, 0.00221246, 0.0022827 , 0.00235436,
           0.00242743, 0.00250192, 0.00257783, 0.00265515, 0.00273389,
           0.00281404, 0.00289562, 0.0029786 , 0.003063  , 0.00314882])




```python
fig, ax = plt.subplots(figsize=(20, 10))
color_contour = ax.contourf(
    aperture_diameters_domain,
    helicopter_speeds_domain,
    density_matrix * 1e4,
    zorder=0,
    vmin=0,
    vmax=20,
)
line_contour = ax.contour(
    aperture_diameters_domain,
    helicopter_speeds_domain,
    density_matrix * 1e4,
    levels=color_contour.levels,
    colors="k",
)
cbar = fig.colorbar(color_contour)
ax.clabel(line_contour, line_contour.levels, inline=True, fontsize=20, fmt="%1.0f")
plt.xlabel("Aperture diameter (mm)", size=fontsize)
plt.ylabel("Helicopter speed (km/h)", size=fontsize)
# plt.ylim(40/3.6, 150/3.6)
ytickslocs = ax.get_yticks()
y_ticks_kmh = ytickslocs * 3.6
plt.yticks(ytickslocs, y_ticks_kmh.astype(int), size=fontsize)
plt.xticks(size=fontsize)
cbar.ax.set_ylabel("Density (kg/ha)", size=fontsize)
cbar.ax.tick_params(labelsize=fontsize)
plt.axhline(18.0056, color="r", linewidth=2)
plt.text(65, 18.6, "35 knot", size=fontsize, color="k")
plt.savefig("contour_plot.png", dpi=300, transparent=True)
```


    
![png](paper_files/paper_39_0.png)
    


![Flow rate $\dot{m}$ (kg/s) as a function of aperture diameter, $d$ (mm); each symbol represents a
calibration event and the black curve is the quadratic model fitted to the data.
\ref{fig:densidadDeAperturaYRapidez} Surface bait density $\sigma$ (kg/ha) as a function of aperture
diameter $d$ (mm), and speed $s$ (km/hr). The horizontal axis shows the aperture diameter of the
bait bucket and the vertical axis shows the helicopter's speed. The resulting bait density on the
ground is shown in the second vertical color axis. $\sigma(d,s)= \frac{\dot{m}(d)}{s\cdot w}$.
\label{fig:densidadDeAperturaYRapidez}]

# Application

For a given island, a particular bait density is required on the ground for a successful rodent
eradication. This density is determined after studying the ecosystems of the island and the biology
of the invasive target species. Given the required bait density and the total area of the island,
the minimum amount of bait needed for the eradication operation can be calculated using NERD. While
planning helicopter flights paths, it is assumed that the bait density within each swath is
constant, but variable between swaths.

Assuming a variable bait density along each swath but uniform density across the swath, we can
estimate bait density with greater precision after the aerial dispersal given that the bait density
for each cell is calculated between two consecutive points recorded by the GPS. This case considers
the effects on density when the helicopter flies with variable speed (Figure
\ref{fig:densidadSimetrica}).

To account for the well known fact that we have a higher density of rodenticide right bellow of the
helicopter and lower densities along the edges of the swath, we can assume a variable bait density
both along and across each swath.  This allows for the detection of areas where the bait density is
below the lower limit of the target bait density or of gaps on the ground without any bait.

## Tiling demo


```python
from nerd.io import Nerd
from nerd.density_functions import normal
import matplotlib.pyplot as plt

%matplotlib inline
plt.rcParams["figure.figsize"] = (10, 10)
```

# Setting up field parameters


```python
from nerd.io import Nerd
```


```python
config_filepath = "/workdir/data/nerd_config.json"
```


```python
nerd_model = Nerd(config_filepath)
nerd_model.calculate_total_density()
nerd_model.export_results_geojson(target_density=0.002)
```

    100%|██████████| 6269/6269 [03:59<00:00, 26.23it/s]



    
![svg](paper_files/paper_49_1.svg)
    


# Discussion

NERD: Numerical Estimation of Rodenticide Dispersal provides provides a model, based on
past calibration experiments in which the mass flow of bait through a bait bucket is measured, that
describes bait density as a function of the aperture diameter, the helicopter speed, and the wind
speed. NERD can assist in the planning of the aerial operations as well as during the eradication,
giving near real-time feedback allowing for on-the-spot corrections during the operation. The final
product of NERD is a bait density map generated in a matter of seconds, which permits better
planning and the automatization of an otherwise difficult and slow processes, while allowing for the
instant identification of bait gaps and the efficient use of resources.

# References
