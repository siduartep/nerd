#!/usr/bin/env bash
#
# Run Jupyter notebooks

# Use Bash strict mode
set -euo pipefail

# Set up
cd /workdir || exit
rm --force /workdir/*.py
jupyter nbconvert --to script /workdir/*.ipynb

# Run scripts
error=0
for script in *.py
do
    ipython "${script}"
    error=$((error+$?))
done
exit ${error}
