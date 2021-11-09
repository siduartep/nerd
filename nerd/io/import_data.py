from nerd.io.geo2utm import geo2utm
from nerd.calibration.fit_flow_rate import fit_flow_rate
import pandas as pd

column_names = ["date", "time", "Lat", "Lon", "Speed", "heading", "Logging_on", "altitude"]
flux_calibation_colums = ["aperture_diameter", "flux"]


def tracmap2csv(tracmap_filename, csv_filename):
    tracmap_data = pd.read_csv(
        tracmap_filename, header=None, names=column_names, usecols=[i for i in range(1, 9)]
    )
    tracmap_data.to_csv(csv_filename, index=False)


def import_tracmap(tracmap_filename, csv_filename="input_data.csv"):
    tracmap2csv(tracmap_filename, csv_filename)
    return geo2utm(csv_filename)


def import_calibration_data(flux_filename):
    flux_data = pd.read_csv(
        flux_filename,
        header=None,
        skiprows=1,
        names=flux_calibation_colums,
        usecols=[i for i in range(0, 2)],
    )
    return fit_flow_rate(flux_data["aperture_diameter"].to_numpy(), flux_data["flux"].to_numpy())
