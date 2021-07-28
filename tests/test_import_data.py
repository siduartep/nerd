import pandas as pd
from nerd.io import tracmap2csv
from pandas._testing import assert_frame_equal


def test_tracmap2csv():
    expected_csv = pd.read_csv("tests/data/expected_input_data.csv")
    tracmap2csv(
        input="tests/data/tracmap_sample_data.txt", output="tests/data/imported_data.csv"
    )
    obtained_csv = pd.read_csv("tests/data/imported_data.csv")
    assert_frame_equal(expected_csv, obtained_csv)
