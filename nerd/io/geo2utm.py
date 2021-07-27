import pandas as pd

column_names = ["date", "time", "Lat", "Lon", "Speed", "heading", "Logging_on", "altitude"]


def geo2utm(input):
    tracmap_data = pd.read_csv(
        input, header=None, names=column_names, usecols=[i for i in range(1, 9)]
    )
    tracmap_data.to_csv(output, index=False)
