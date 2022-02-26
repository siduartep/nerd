from setuptools import setup, find_packages

setup(
    author="Ciencia de Datos • GECI",
    author_email="ciencia.datos@islas.org.mx",
    description="Numerical Estimation of Rodenticide Density (NERD)",
    name="geci-nerd",
    packages=find_packages(),
    url="https://github.com/IslasGECI/nerd",
    version="0.3.1",
    install_requires=[
        "descartes",
        "fiona",
        "geojsoncontour",
        "matplotlib",
        "numpy",
        "pandas",
        "scipy",
        "shapely",
        "tqdm",
        "utm",
    ],
)
