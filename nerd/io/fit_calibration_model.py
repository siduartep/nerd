import numpy as np


def fit_calibration_model(calibration_data):
    parameters = np.polyfit(calibration_data["aperture_diameter"], calibration_data["flux"], 2)
    return np.poly1d(parameters)
