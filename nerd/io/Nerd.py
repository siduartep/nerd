from nerd.io.import_data import import_calibration_data, import_tracmap
from nerd.mapping.tiling import (
    calculate_total_density,
    density_contours_intervals,
    generate_contours,
)
import geojsoncontour
import json


class Nerd:
    def __init__(self, dict_parameters):
        self.spatial_resolution = dict_parameters["spatial_resolution"]
        self.width = dict_parameters["width"]
        self.aperture_diameter = dict_parameters["aperture_diameter"]
        self.density_function = dict_parameters["density_function"]
        self.input_data_path = dict_parameters["input_data_path"]
        self.input_calibration_data = dict_parameters["input_calibration_data"]
        self.tracmap_data = import_tracmap(self.input_data_path, self.input_data_path[:-3] + "csv")
        self.flow_rate_function = import_calibration_data(dict_parameters["input_calibration_data"])

    def calculate_total_density(self):
        self.x_grid, self.y_grid, self.total_density = calculate_total_density(
            self.tracmap_data,
            self.width,
            self.spatial_resolution,
            self.aperture_diameter,
            self.density_function,
            self.flow_rate_function,
        )

    def export_results_geojson(self, target_density):
        levels = density_contours_intervals(target_density, self.total_density)
        contours, contours_dict = generate_contours(
            self.x_grid, self.y_grid, self.total_density, levels
        )
        geojson = geojsoncontour.contourf_to_geojson(contourf=contours, unit="m")
        geojson = json.loads(geojson)
        with open("nerd_geojson.json", "w") as outfile:
            json.dump(geojson, outfile)
