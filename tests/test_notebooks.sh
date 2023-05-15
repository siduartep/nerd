#!/usr/bin/env bash
#
# Run Jupyter notebooks

# Use Bash strict mode
set -euo pipefail

# Set up
cd /workdir || exit
rm --force /workdir/examples/*.py
jupyter nbconvert /workdir/examples/*.ipynb --to script

# Run scripts
error=0
for script in /workdir/examples/*.py
do
    ipython "${script}"
    error=$((error+$?))
done
exit ${error}
