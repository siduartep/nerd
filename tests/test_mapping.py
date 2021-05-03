from nerd.mapping import (
    calculate_cell_density_in_border,
    calculate_directions,
    cell_edges_slopes,
    check_directions,
    density_in_tile,
    generate_cell_from_coordinates,
    generate_tile_direction_arrays,
    orthogonal_slope,
    reorder_end_tile,
    safe_divition,
    sign_of_direction,
    slope_between_two_points,
    is_inside_tile,
    generate_contours,
    create_contour_polygon_list,
    export_contour_list_as_shapefile,
)
from nerd.density_functions import uniform
from unittest import TestCase
from shapely import geometry

import hashlib
import matplotlib as mpl
import numpy as np
import types


class TestMapping(TestCase):
    def setUp(self) -> None:
        self.stripe_width = 60
        self.b = 2
        self.c = 0
        self.x = [-1, 2, 3, 4, 5, 6]
        self.y = [2, 4, 6, 8, 10, 12]
        self.node = 2
        self.spatial_resolution = 5
        self.half_stripe_width = int(self.stripe_width / 2)
        self.density_domain = np.linspace(
            -self.half_stripe_width, self.half_stripe_width, self.spatial_resolution
        )
        self.uniform_density = uniform(self.density_domain, self.stripe_width, 10)
        self.n_contours = 2
        self.x_coordinates = np.arange(0, 100, 2)
        self.y_coordinates = np.arange(0, 100, 2)
        self.total_density_reshaped = np.eye(50, 50)
        self.x_grid, self.y_grid = np.meshgrid(self.x_coordinates, self.y_coordinates)
        self.x_tile_coordinates = [
            29.832815729997474,
            -23.832815729997474,
            -22.832815729997474,
            30.832815729997474,
            29.832815729997474,
        ]

        self.y_tile_coordinates = [
            -7.416407864998737,
            19.41640786499874,
            21.41640786499874,
            -5.416407864998737,
            -7.416407864998737,
        ]
        self.flipped_x_tile_coordinates = [
            29.832815729997474,
            -23.832815729997474,
            30.832815729997474,
            -22.832815729997474,
            29.832815729997474,
        ]

        self.flipped_y_tile_coordinates = [
            -7.416407864998737,
            19.41640786499874,
            -5.416407864998737,
            21.41640786499874,
            -7.416407864998737,
        ]

    def test_safe_divition(self):
        expected = 60 / 2
        obtained = safe_divition(self.stripe_width, self.b)
        assert expected == obtained

    def test_safe_divition_by_zero(self):
        expected = np.inf
        obtained = safe_divition(self.stripe_width, self.c)
        assert expected == obtained

    def test_slope_between_two_points(self):
        expected = 1.0
        obtained = slope_between_two_points(2, 1, 2, 1)
        assert expected == obtained

    def test_orthogonal_slope(self):
        expected = -1
        obtained = orthogonal_slope(1)
        assert expected == obtained

    def test_slopes_from_coordinates(self):
        expected = (-0.5, -0.5)
        obtained = cell_edges_slopes(self.x, self.y, self.node)
        assert expected == obtained

    def test_generate_tile_from_coordinates(self):
        obtained_x_tile, obtained_y_tile = generate_cell_from_coordinates(
            self.x, self.y, self.node, self.stripe_width, self.spatial_resolution
        )
        assert self.x_tile_coordinates == obtained_x_tile
        assert self.y_tile_coordinates == obtained_y_tile

    def test_density_in_tile(self):
        obtained_lambda_density_function = density_in_tile(
            self.x_tile_coordinates,
            self.y_tile_coordinates,
            self.uniform_density,
            self.spatial_resolution,
        )
        assert isinstance(obtained_lambda_density_function, types.FunctionType)
        obtained_density = obtained_lambda_density_function(1, 8)
        expected_density = np.array(10)
        np.testing.assert_array_almost_equal(expected_density, obtained_density)

    def test_calculate_cell_density_in_border(self):
        xx, yy = calculate_cell_density_in_border(
            self.x_tile_coordinates, self.y_tile_coordinates, self.spatial_resolution
        )
        expexted_xx_array = np.array(
            [
                29.83281573,
                16.41640786,
                3.0,
                -10.41640786,
                -23.83281573,
                30.83281573,
                17.41640786,
                4.0,
                -9.41640786,
                -22.83281573,
            ]
        )
        expected_yy_array = np.array(
            [
                -7.41640786,
                -0.70820393,
                6.0,
                12.70820393,
                19.41640786,
                -5.41640786,
                1.29179607,
                8.0,
                14.70820393,
                21.41640786,
            ]
        )
        np.testing.assert_array_almost_equal(xx, expexted_xx_array)
        np.testing.assert_array_almost_equal(yy, expected_yy_array)

    def test_calculate_directions(self):
        obtained_angle = calculate_directions([0, 0, 1, 1, 0], [0, 1, 0, 1, 0])
        second_obtained_angle = calculate_directions(
            self.x_tile_coordinates, self.y_tile_coordinates
        )
        assert obtained_angle == np.pi
        assert second_obtained_angle == 0

    def test_sign_of_direction(self):
        obtained_angle = sign_of_direction([1, 0], [1, 0])
        second_obtained_angle = sign_of_direction([1, 0], [0, 1])
        third_obtained_angle = sign_of_direction([5, 3], [4, 2])
        assert obtained_angle == 0
        assert second_obtained_angle == np.pi / 2
        assert third_obtained_angle == 0.07677189126977907

    def test_generate_tile_direction_arrays(self):
        obtained_directions_arrays = generate_tile_direction_arrays(
            self.x_tile_coordinates, self.y_tile_coordinates
        )
        expected_u_array = np.array([-53.665631, 26.832816])
        expected_v_array = np.array([-53.665631, 26.832816])
        np.testing.assert_array_almost_equal(obtained_directions_arrays[0], expected_u_array)
        np.testing.assert_array_almost_equal(obtained_directions_arrays[1], expected_v_array)

    def test_reorder_end_tile(self):
        obtained_x_tile_coordinates, obtained_y_tile_coordinates = reorder_end_tile(
            self.x_tile_coordinates, self.y_tile_coordinates
        )
        assert obtained_x_tile_coordinates == self.flipped_x_tile_coordinates
        assert obtained_y_tile_coordinates == self.flipped_y_tile_coordinates

    def test_check_directions(self):
        obtained_x_tile_coordinates, obtained_y_tile_coordinates = check_directions(
            self.flipped_x_tile_coordinates, self.flipped_y_tile_coordinates
        )
        assert obtained_x_tile_coordinates == self.x_tile_coordinates
        assert obtained_y_tile_coordinates == self.y_tile_coordinates

    def test_check_directions_2(self):
        x_tile_test = [0, 1, 0.32020140, 0, 0]
        y_tile_test = [0, 0, 0.93962620, 0, 0]
        obtained_x_tile_coordinates, obtained_y_tile_coordinates = check_directions(
            x_tile_test.copy(), y_tile_test.copy()
        )
        assert obtained_x_tile_coordinates == x_tile_test
        assert obtained_y_tile_coordinates == y_tile_test

    def test_check_directions_3(self):
        x_tile_test = [0, 0, 1, 0, 0]
        y_tile_test = [0, 1, 1, 1, 0]
        obtained_x_tile_coordinates, obtained_y_tile_coordinates = check_directions(
            x_tile_test.copy(), y_tile_test.copy()
        )
        assert obtained_x_tile_coordinates == x_tile_test
        assert obtained_y_tile_coordinates == y_tile_test

    def test_is_inside_tile(self):
        points_to_tests = np.array([np.array([1, 0]), np.array([8, 1])]).T
        obtained_boolean_mask = is_inside_tile(
            self.x_tile_coordinates, self.y_tile_coordinates, points_to_tests
        )
        assert obtained_boolean_mask[0]
        assert ~obtained_boolean_mask[1]

    def test_generate_contours(self):
        expected_density_values = [0.0, 0.4, 0.8]
        contour, contour_dict = generate_contours(
            self.x_grid, self.y_grid, self.total_density_reshaped, n_contours=self.n_contours
        )
        for key in contour_dict.keys():
            assert isinstance(key, mpl.collections.PathCollection)
        assert list(contour_dict.values()) == expected_density_values
        assert isinstance(contour, mpl.contour.QuadContourSet)
        contour, contour_dict = generate_contours(
            self.x_grid, self.y_grid, self.total_density_reshaped
        )
        obtained_number_of_contours = len(list(contour_dict.keys()))
        expected_number_of_contours = 20
        assert obtained_number_of_contours == expected_number_of_contours

    def test_create_contour_polygon_list(self):
        contour, contour_dict = generate_contours(
            self.x_grid, self.y_grid, self.total_density_reshaped, n_contours=self.n_contours
        )
        obtained_polygon_list = create_contour_polygon_list(contour, contour_dict)
        expected_poligon_list_element_keys = ["poly", "props"]
        obtained_poligon_list_element_keys = list(obtained_polygon_list[0].keys())
        expected_props_dict_keys = ["z"]
        obtained_props_dict_keys = list(obtained_polygon_list[0]["props"].keys())
        assert isinstance(obtained_polygon_list, list)
        for polygon_dict in obtained_polygon_list:
            assert isinstance(polygon_dict, dict)
            assert isinstance(polygon_dict["poly"], geometry.polygon.Polygon)
            assert isinstance(polygon_dict["props"], dict)
            assert isinstance(polygon_dict["props"]["z"], float)
        assert obtained_poligon_list_element_keys == expected_poligon_list_element_keys
        assert obtained_props_dict_keys == expected_props_dict_keys

    def test_export_contour_list_as_shapefile(self):
        contour, contour_dict = generate_contours(
            self.x_grid, self.y_grid, self.total_density_reshaped, n_contours=self.n_contours
        )
        obtained_polygon_list = create_contour_polygon_list(contour, contour_dict)
        output_path = "tests/test_shapefile.shp"
        export_contour_list_as_shapefile(obtained_polygon_list, output_path)
        md5_hash = hashlib.md5()
        a_file = open(output_path, "rb")
        content = a_file.read()
        md5_hash.update(content)
        obtained_hash = md5_hash.hexdigest()
        expected_hash = "30e405e870cda15ea85eb185402e22ae"
        assert obtained_hash == expected_hash
