import numpy as np


def slope_between_two_points(y2, y1, x2, x1):
    return safe_divition(y2 - y1, x2 - x1)


def orthogonal_slope(slope):
    return safe_divition(-1, slope)


def safe_divition(numerator, denominator):
    if denominator == 0:
        return float("inf")
    return numerator / denominator


def cell_edges_slopes(x, y, node_index):
    start_slope = orthogonal_slope(
        slope_between_two_points(
            y[node_index + 1], y[node_index - 1], x[node_index + 1], x[node_index - 1]
        )
    )
    end_slope = orthogonal_slope(
        slope_between_two_points(y[node_index + 2], y[node_index], x[node_index + 2], x[node_index])
    )
    return start_slope, end_slope


def calculate_cell_y_limits(slope, limit_x, x_coord, y_coord):
    return slope * (limit_x - x_coord) + y_coord


def cell_y_coordinates(start_orthogonal_slope, end_orthogonal_slope, x_rect, x, y, node):
    start_y1 = calculate_cell_y_limits(start_orthogonal_slope, x_rect[0], x[node], y[node])
    start_y2 = calculate_cell_y_limits(start_orthogonal_slope, x_rect[1], x[node], y[node])
    end_y2 = calculate_cell_y_limits(end_orthogonal_slope, x_rect[2], x[node + 1], y[node + 1])
    end_y1 = calculate_cell_y_limits(end_orthogonal_slope, x_rect[3], x[node + 1], y[node + 1])
    return [start_y1, start_y2, end_y2, end_y1, start_y1]


def calculate_cell_x_limits(r, orthogonal_slope, x_coord):
    return r / np.sqrt(1 + orthogonal_slope ** 2) + x_coord


def cell_x_coordinates(r, start_orthogonal_slope, end_orthogonal_slope, x, node):
    start_x1 = calculate_cell_x_limits(r, start_orthogonal_slope, x[node])
    start_x2 = calculate_cell_x_limits(-r, start_orthogonal_slope, x[node])
    end_x1 = calculate_cell_x_limits(r, end_orthogonal_slope, x[node + 1])
    end_x2 = calculate_cell_x_limits(-r, end_orthogonal_slope, x[node + 1])
    return [start_x1, start_x2, end_x2, end_x1, start_x1]


def generate_cell_from_coordinates(x, y, node, stripe_width, spatial_resolution):
    r = stripe_width / 2
    start_orthogonal_slope, end_orthogonal_slope = cell_edges_slopes(x, y, node)
    x_rect = cell_x_coordinates(r, start_orthogonal_slope, end_orthogonal_slope, x, node)
    y_rect = cell_y_coordinates(start_orthogonal_slope, end_orthogonal_slope, x_rect, x, y, node)
    return x_rect, y_rect
