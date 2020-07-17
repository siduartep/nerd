% Improving estimation and visualization of aerial work during rat eradications
% Grupo de Ecología y Conservación de Islas (GECI) \newline Evaristo Rojas
% July 24, 2015

Rat eradication on islands
========================================================

Aerial broadcast of rodenticide bait is one of the preferred methods of rat eradication

![Helicopter with bucket al Banco Chinchorro, 2015](..\images\j12.png)

Rat eradication on islands
========================================================

Challenges:

\begin{itemize}
  \setlength\itemsep{1em}
  \item Creating bait density maps to visualize spatial variation of bait availability is slow
  \item Taking \textit{in situ} measurements to evaluate aerial work is difficult
\end{itemize}

Numerical Estimation of Rodenticide Dispersal (NERD)
========================================================

Improvements:

\begin{itemize}
  \setlength\itemsep{1em}
  \item Facilitates planning of helicopter work
  \item Generates bait density maps automatically
  \item Allows instant identification of bait gaps with less \textit{in situ} measurements
\end{itemize}

(Samaniego-Herrera, et al. 2015)

Content of this talk
========================================================

NERD:

\begin{itemize}
  \setlength\itemsep{1em}
  \item Mathematical model
  \item Computer program
  \item Group of people
\end{itemize}

Conceptual diagram
========================================================

![Helicopter's swath variables](..\images\helicopterSwathModel.png)

NERD Model (background)
========================================================

Average bait density:
$$ \sigma = \frac{m}{A} $$

Hypothetical example:

$$ \sigma = \frac{4,000 \ \textnormal{kg}}{500 \ \textnormal{ha}} = 8 \ \frac{\textnormal{kg}}{\textnormal{ha}} $$ (easiest way for the whole island)

NERD Model
========================================================

Bait density $\leftarrow$ Aperture diameter + Helicopter speed + Wind speed

Calibration
========================================================

![Calibration](..\images\j67.png)

Flow vs aperture $f(a)$
========================================================

![Flow rate vs aperture size $f(a)=7\times 10^{-4}a^2-0.062a+1.73$](..\images\flowVsAperture.png)

Uniform distribution
========================================================
Problem: Obtained $f$ not $\sigma$

. . .

\begin{itemize}
  \setlength\itemsep{1em}
  \item Let $a=75$ mm $\implies$ $f\approx 1$ kg/s \pause
  \item Helicopter's GPS takes one point every second \pause
  \item $\implies m\approx 1$ kg between two GPS points \pause
  \item $s$ = 35 knots = 18 m/s $\implies \Delta y = 18$ m \pause
  \item Assuming a swath width $w = 65$ m \pause
  \item $\implies A_\textnormal{cell} = 18\times 65 = 1170 \ \textnormal{m}^2 = 0.117$ ha \pause
  \item $\implies \sigma = \frac{1 \ \textnormal{kg}}{.117 \ \textnormal{ha}} \approx 8 \ \frac{\textnormal{kg}}{\textnormal{ha}}$ (within a cell) \pause
\end{itemize}
$$\sigma:=\sigma(a,s)$$


Density vs aperture $\sigma(a)$
========================================================

![Bait density as a function of aperture size](..\images\densityVsAperture.png)

Bait density vs aperture & speed $\sigma(a,s)$
========================================================

![Bait density as a function of aperture size and helicopter speed](..\images\density.png)

What about the wind?
========================================================

Bait density $\leftarrow$ Aperture diameter + Helicopter speed + Wind speed

so, what about the wind speed?

Bait density profile
========================================================

![Bait density profile](..\images\densityProfile.png)

Probability density function
========================================================

$$\int_{-\frac{w}{2}}^{+\frac{w}{2}} \sigma(x) dx = \frac{f(a)}{s}$$
\pause
$$\Downarrow$$
$$\int_{-\frac{w}{2}}^{+\frac{w}{2}} \sigma(x) dx = \frac{\sfrac{\Delta m}{\Delta t}}{\sfrac{\Delta y}{\Delta t}}$$
$$\Downarrow$$
$$\Delta y \cdot \int_{-\frac{w}{2}}^{+\frac{w}{2}} \sigma(x) dx = \Delta m$$

NERD Software
========================================================

![NERD Software](..\images\screenshot01.png)

NERD Software
========================================================

![Session](..\images\screenshot23.png)

NERD Software
========================================================

![Input](..\images\screenshot456.png)

NERD Software
========================================================

![Coastline](..\images\screenshot07.png)

NERD Software
========================================================

![Output](..\images\screenshot08.png)

NERD Software
========================================================

![Result](..\images\screenshot09.png)

Final result
========================================================

![Bait density map](..\images\map.png)

NERD Team
========================================================

![Evaristo, Charlie, Rob, Fede, and Rob](..\images\j45.png)

NERD Team
========================================================

![Rob, Fede, Ara, Evaristo, and Ana](..\images\nerd-team-2.png)

Acknowledgement
========================================================

![GECI](..\images\geci.png)

References
========================================================

- Samaniego-Herrera, A., Aguirre-Muñoz A., Méndez-Sánchez, F., Rojas-Mayoral, E. and Cárdenas-Tapia, A. 2015. Pushing the boundaries of rodent eradications on tropical islands: Ship rat eradication on Cayo Centro, Banco Chinchorro, Mexico. 27th International Congress for Conservation Biology. Montpellier, France, 2-6 August 2015.
