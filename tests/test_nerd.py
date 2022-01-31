from nerd.io import Nerd
from unittest import TestCase
import hashlib
import os
import numpy as np
import pandas as pd


class TestNerd(TestCase):
    def setUp(self) -> None:
        self.expected_config_file = "tests/data/expected_nerd_config.json"
        self.config_json = pd.read_json(self.expected_config_file)
        self.input_calibration_data = "tests/data/expected_calibration_data.csv"

    def test_full_workflow(self):
        expected_results_filename = "outputs/nerd_geojson.json"
        imported_concatenated_csv = "outputs/input_concatenated_data.csv"
        expected_levels = np.array([0.01, 0.019, 0.021, 0.04, 1.576378, 7.295223])
        if os.path.exists(expected_results_filename):
            os.remove(expected_results_filename)
        if os.path.exists(imported_concatenated_csv):
            os.remove(imported_concatenated_csv)
        nerd_model = Nerd(self.expected_config_file)
        nerd_model.calculate_total_density()
        nerd_model.export_results_geojson(target_density=0.02)
        assert os.path.isfile(expected_results_filename)
        np.testing.assert_array_almost_equal(
            nerd_model.calculated_levels, expected_levels, decimal=2
        )
        assert os.path.isfile(imported_concatenated_csv)
        os.remove(expected_results_filename)
        os.remove(imported_concatenated_csv)
        os.rmdir("outputs")


def assess_hash(test_csv_filename, expected_hash):
    md5_hash = hashlib.md5()
    a_file = open(test_csv_filename, "rb")
    content = a_file.read()
    md5_hash.update(content)
    obtained_hash = md5_hash.hexdigest()
    assert expected_hash == obtained_hash
