#!/usr/bin/env bash
#
# Run Jupyter notebooks

jupyter nbconvert --to script examples/*.ipynb
error=0
for script in examples/*.py
do
    python "${script}"
    error=$((error+$?))
done
exit ${error}
