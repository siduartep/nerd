import os
import pandas as pd
from nerd.io import import_tracmap, tracmap2csv, import_calibration_data, select_density_function
from pandas._testing import assert_frame_equal
import numpy as np
from numpy.testing import assert_array_almost_equal
from nerd.density_functions import uniform
from nerd.io.import_data import check_output_directory, import_multifile_tracmap


def test_tracmap2csv():
    expected_csv = pd.read_csv("tests/data/expected_input_data.csv")
    tracmap2csv(
        tracmap_filename="tests/data/tracmap_sample_data.txt",
        csv_filename="tests/data/imported_data.csv",
    )
    obtained_csv = pd.read_csv("tests/data/imported_data.csv")
    assert_frame_equal(expected_csv, obtained_csv)


def test_import_tracmap_without_csvfilename():
    expected_utm_data = pd.read_csv("tests/data/expected_utm_data.csv")
    obtained_utm_data = import_tracmap(tracmap_filename="tests/data/tracmap_sample_data.txt")
    assert_frame_equal(expected_utm_data, obtained_utm_data)
    os.remove("input_data.csv")


def test_import_tracmap_with_csvfilename():
    test_csv_filename = "test_csv_filename.csv"
    expected_utm_data = pd.read_csv("tests/data/expected_utm_data.csv")
    obtained_utm_data = import_tracmap(
        tracmap_filename="tests/data/tracmap_sample_data.txt", csv_filename=test_csv_filename
    )
    assert os.path.isfile(test_csv_filename)
    assert_frame_equal(expected_utm_data, obtained_utm_data)
    os.remove(test_csv_filename)


def test_import_calibration_data():
    expected_utm_data = "tests/data/expected_calibration_data.csv"
    obtained_utm_data = import_calibration_data(expected_utm_data)
    assert_array_almost_equal(
        obtained_utm_data, np.array([6.86905404e-04, -6.19897620e-02, 1.72530268e00])
    )


def test_select_density_function():
    expected_function = uniform
    obtained_function = select_density_function("uniform")
    assert expected_function == obtained_function


def test_check_output_directory():
    output_path = "./example_dir"
    check_output_directory(output_path)
    directory_exists = os.path.exists(output_path)
    assert directory_exists is True


def test_import_multifile_tracmap():
    config_file_path = "tests/data/nerd_config.json"
    config_file = pd.read_json(config_file_path)
    tracmap_data = import_multifile_tracmap(config_file, "input_concatenated_data.csv")
    assert tracmap_data is not None
