<img src="https://www.islas.org.mx/img/logo.svg" width="256" />

# Numerical Estimation of Rodenticide Density

The eradication of rodents is central to island restoration efforts and the aerial broadcast of
rodenticide bait is the preferred dispersal method. To improve accuracy and expedite the evaluation
of aerial operations, we developed an algorithm for the numerical estimation of rodenticide density
(NERD). The NERD algorithm performs calculations with increased accuracy, displaying results almost
in real-time. NERD describes the relationship between bait density, the mass flow rate of
rodenticide through the bait bucket, and helicopter speed and produces maps of bait density on the
ground. NERD also facilitates the planning of helicopter flight paths and allows for the instant
identification of areas with low or high bait density.

## Installation

```
pip install geci-nerd
```

## Demonstration

### Jupyter Notebooks

- [IslasGECI.org](http://islasgeci.org:8080)
- [GitHub](https://github.com/IslasGECI/nerd/blob/develop/examples/)

### Docker

Build image:
```shell
docker build --file Dockerfile.demo --tag=islasgeci/nerd_demo .
```

Run container:
```shell
docker run --publish 8080:8888 --rm islasgeci/nerd_demo
```

## References

- [_E. Rojas-Mayoral, F.A. Méndez-Sánchez, B. Rojas-Mayoral and A. Aguirre-Muñoz._ (2019).
  **Improving the efficiency of aerial rodent eradications by means of the numerical estimation of
  rodenticide
  density.**](http://www.issg.org/pdf/publications/2019_Island_Invasives/PrintFiles/Rojas-Mayoral.pdf)

---

[Grupo de Ecología y Conservación de Islas](https://www.islas.org.mx/)
