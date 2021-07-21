def test_import_tracmap():
    expected_csv = read("tests/data/expected_input_data.csv")
    import_tracmap(
        input="tests/data/tracmap_sample_data.txt", output="tests/data/imported_data.csv"
    )
    obtained_csv = read("tests/data/imported_data.csv")
    assert expected_csv == obtained_csv
