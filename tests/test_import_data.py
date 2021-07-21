import pandas as pd
from nerd.io import import_tracmap
from pandas._testing import assert_frame_equal


def test_import_tracmap():
    expected_csv = pd.read_csv("tests/data/expected_input_data.csv")
    import_tracmap(
        input="tests/data/tracmap_sample_data.txt", output="tests/data/imported_data.csv"
    )
    obtained_csv = pd.read_csv("tests/data/imported_data.csv")
    assert_frame_equal(expected_csv, obtained_csv)
