from setuptools import setup, find_packages

setup(
    name="nerd",
    version="0.3.0",
    packages=find_packages(),
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
