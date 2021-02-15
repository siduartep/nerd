import numpy as np


def slope_between_two_points(Y2, Y1, X2, X1):
    return safe_divition(Y2 - Y1, X2 - X1)


def orthogonal_slope(slope):
    return safe_divition(-1, slope)


def safe_divition(x, y):
    if y == 0:
        return float("inf")
    return x / y


def slopes_from_coordinates(X, Y, node):
    start_slope = orthogonal_slope(
        slope_between_two_points(Y[node + 1], Y[node - 1], X[node + 1], X[node - 1])
    )
    end_slope = orthogonal_slope(
        slope_between_two_points(Y[node + 2], Y[node], X[node + 2], X[node])
    )
    return start_slope, end_slope


def calculate_tile_y_limits(slope, limit_x, x_coord, y_coord):
    return slope * (limit_x - x_coord) + y_coord


def tile_y_coordinates(start_orthogonal_slope, end_orthogonal_slope, X_rect, X, Y, node):
    startY1 = calculate_tile_y_limits(start_orthogonal_slope, X_rect[1], X[node], Y[node])
    startY2 = calculate_tile_y_limits(start_orthogonal_slope, X_rect[2], X[node], Y[node])
    endY2 = calculate_tile_y_limits(end_orthogonal_slope, X_rect[3], X[node + 1], Y[node + 1])
    endY1 = calculate_tile_y_limits(end_orthogonal_slope, X_rect[4], X[node + 1], Y[node + 1])
    return [startY1, startY2, endY2, endY1, startY1]


def calculate_tile_x_limits(r, orthogonal_slope, x_coord):
    return r / np.sqrt(orthogonal_slope ** 2 + 1) + x_coord


def tile_x_coordinates(r, start_orthogonal_slope, end_orthogonal_slope, X, node):
    startX1 = calculate_tile_x_limits(r, start_orthogonal_slope, X[node])
    startX2 = calculate_tile_x_limits(-r, start_orthogonal_slope, X[node])
    endX1 = calculate_tile_x_limits(r, end_orthogonal_slope, X[node + 1])
    endX2 = calculate_tile_x_limits(-r, end_orthogonal_slope, X[node + 1])
    return [startX1, startX2, endX2, endX1, startX1]


def generate_tile_from_coordinates(X, Y, node, stripe_width, spatial_resolution):
    r = stripe_width / 2
    start_orthogonal_slope, end_orthogonal_slope = slopes_from_coordinates(X, Y, node)
    X_rect = tile_x_coordinates(r, start_orthogonal_slope, end_orthogonal_slope, X, node)
    Y_rect = tile_y_coordinates(start_orthogonal_slope, end_orthogonal_slope, X_rect, X, Y, node)
    return X_rect, Y_rect



