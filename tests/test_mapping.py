from nerd.mapping import (
    safe_divition,
    slope_between_two_points,
    orthogonal_slope,
    cell_edges_slopes,
    generate_cell_from_coordinates,
)
from unittest import TestCase
import numpy as np


class TestMapping(TestCase):
    def setUp(self) -> None:
        self.a = 60
        self.b = 2
        self.c = 0
        self.x = [-1, 2, 3, 4, 5, 6]
        self.y = [2, 4, 6, 8, 10, 12]
        self.node = 1
        self.stripe_width = 60
        self.spatial_resolution = 5

    def test_safe_divition(self):
        expected = 60 / 2
        obtained = safe_divition(self.a, self.b)
        assert expected == obtained

    def test_safe_divition_by_zero(self):
        expected = np.inf
        obtained = safe_divition(self.a, self.c)
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
        expected_x_tile = [
            23.213203435596423,
            -19.213203435596423,
            -23.832815729997474,
            29.832815729997474,
            23.213203435596423,
        ]
        expected_y_tile = [
            -17.213203435596423,
            25.213203435596423,
            19.41640786499874,
            -7.416407864998737,
            -17.213203435596423,
        ]
        obtained_x_tile, obtained_y_tile = generate_cell_from_coordinates(
            self.x, self.y, self.node, self.stripe_width, self.spatial_resolution
        )
        assert expected_x_tile == obtained_x_tile
        assert expected_y_tile == obtained_y_tile
