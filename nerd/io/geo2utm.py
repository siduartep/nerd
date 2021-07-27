import pandas as pd
import utm


def geo2utm(input):
    data = pd.read_csv(input)
    data["easting"], data["northing"], data["zone_number"], data["zone_letter"] = utm.from_latlon(
        data.Lat.values, data.Lon.values
    )
    return data
