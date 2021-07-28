from nerd.io.geo2utm import geo2utm
import pandas as pd

column_names = ["date", "time", "Lat", "Lon", "Speed", "heading", "Logging_on", "altitude"]


def tracmap2csv(tracmap_filename, csv_filename):
    tracmap_data = pd.read_csv(
        tracmap_filename, header=None, names=column_names, usecols=[i for i in range(1, 9)]
    )
    tracmap_data.to_csv(csv_filename, index=False)


def import_tracmap(tracmap_filename):
    csv_filename = "input_data.csv"
    tracmap2csv(tracmap_filename, csv_filename)
    return geo2utm(csv_filename)
