#!/usr/bin/env bash
#
# Run Jupyter notebooks

# Set up
cd /workdir || exit
rm --force examples/*.py
jupyter nbconvert --to script examples/*.ipynb
cd examples || exit

# Run scripts
error=0
for script in *.py
do
    ipython "${script}"
    error=$((error+$?))
done
exit ${error}
