import numpy as np
import pandas as pd
import pytest

import nerd
import nerd.calibration
import nerd.density_functions

@pytest.fixture()
def density_profile():
    return pd.read_csv("examples/data/perfil.csv")

@pytest.fixture()
def distance(density_profile):
    return density_profile.distancia.values

@pytest.fixture()
def density(density_profile):
    density_kg_per_ha = density_profile.densidad.values
    return density_kg_per_ha / 1e4 # To convert densities to kg per square meter

@pytest.fixture()
def flow_data():
    flow_data = pd.read_csv("examples/data/flujo.csv")
    return flow_data[flow_data.estado_cebo == "nuevo"][["apertura","flujo"]]

@pytest.fixture()
def aperture_diameters(flow_data):
    return flow_data.apertura.values

@pytest.fixture()
def flow_rates(flow_data):
    return flow_data.flujo.values

@pytest.fixture()
def swath_width():
    return 60

@pytest.fixture()
def flow_rate_function():
    return np.poly1d([0.0007, 0.06, 1.7])

def test_fit_flow_rate(aperture_diameters, flow_rates):
    flow_rate_function = nerd.calibration.fit_flow_rate(aperture_diameters, flow_rates)

    x = np.linspace(min(aperture_diameters),max(aperture_diameters))
    y = flow_rate_function(x)

def test_swath_width(distance, density):
    swath_width = nerd.calibration.get_swath_width(distance, density)

def test_select_best_density_function(distance, density, swath_width, flow_rate_function):
    aperture_diameter_data = 55 # milimetres
    helicopter_speed_data = 20.5778 # meters per second (40 knots)

    density_function = nerd.calibration.get_best_density_function(distance, density, aperture_diameter_data, helicopter_speed_data, swath_width, flow_rate_function)
    estimated_profile = nerd.solver(aperture_diameter_data, helicopter_speed_data, swath_width, density_function, flow_rate_function)

    x = np.linspace(min(distance), max(distance))
    y = estimated_profile(x)
    estimated_density = estimated_profile(distance)

def test_calibration_model(aperture_diameters, swath_width,flow_rate_function):
    aperture_diameters_domain = np.linspace(min(aperture_diameters),max(aperture_diameters))
    helicopter_speeds_domain = np.linspace(10,40)
    density_matrix = nerd.calibration.model(aperture_diameters_domain,helicopter_speeds_domain,swath_width,nerd.density_functions.uniform,flow_rate_function)
