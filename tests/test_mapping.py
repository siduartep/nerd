from nerd.mapping import (
    safe_divition,
    slope_between_two_points,
    orthogonal_slope,
    cell_edges_slopes,
    generate_cell_from_coordinates,
    density_in_tile,
)
from nerd.density_functions import uniform
from unittest import TestCase
import numpy as np
import types


class TestMapping(TestCase):
    def setUp(self) -> None:
        self.stripe_width = 60
        self.b = 2
        self.c = 0
        self.x = [-1, 2, 3, 4, 5, 6]
        self.y = [2, 4, 6, 8, 10, 12]
        self.node = 1
        self.spatial_resolution = 5
        self.half_stripe_width = int(self.stripe_width / 2)
        self.density_domain = np.linspace(
            -self.half_stripe_width, self.half_stripe_width, self.spatial_resolution
        )
        self.uniform_density = uniform(self.density_domain, self.stripe_width, 10)
        self.x_tile_coordinates = [
            23.213203435596423,
            -23.832815729997474,
            -19.213203435596423,
            29.832815729997474,
            23.213203435596423,
        ]
        self.y_tile_coordinates = [
            -17.213203435596423,
            19.41640786499874,
            25.213203435596423,
            -7.416407864998737,
            -17.213203435596423,
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
        expected = (-1, -0.5)
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
        obtained_density = obtained_lambda_density_function(0,10)
        expected_density = np.array(6.63536373)
        np.testing.assert_array_almost_equal(expected_density,obtained_density)
