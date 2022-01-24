from nerd.io.import_data import (
    import_calibration_data,
    import_tracmap,
    import_multifile_tracmap,
    check_output_directory,
)
from nerd.mapping.tiling import (
    calculate_total_density,
    density_contours_intervals,
    generate_contours,
)
import geojsoncontour
import json
import pandas as pd


class Nerd:
    def __init__(self, config_file_path):
        self.config_file = pd.read_json(config_file_path)
        self.tracmap_data = import_multifile_tracmap(
            self.config_file, "input_concatenated_data.csv"
        )
        self.spatial_resolution = self.config_file["spatial_resolution"][0]
        self.flow_rate_function = import_calibration_data(
            self.config_file["input_calibration_data"][0]
        )

    def calculate_total_density(self):
        self.x_grid, self.y_grid, self.total_density = calculate_total_density(
            self.tracmap_data,
            self.config_file,
            self.spatial_resolution,
            self.flow_rate_function,
        )

    def export_results_geojson(self, target_density):
        levels = density_contours_intervals(target_density, self.total_density)
        contours, contours_dict = generate_contours(
            self.x_grid, self.y_grid, self.total_density, levels
        )
        geojson = geojsoncontour.contourf_to_geojson(contourf=contours, unit="m")
        geojson = json.loads(geojson)
        check_output_directory(self.config_file["output_path"][0])
        with open(
            "{}/nerd_geojson.json".format(self.config_file["output_path"][0]), "w"
        ) as outfile:
            json.dump(geojson, outfile)
