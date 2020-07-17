FROM jupyter/minimal-notebook
COPY examples/calibration-demo.ipynb /workdir/
COPY examples/data /workdir/data
RUN pip install \
    git+https://github.com/IslasGECI/nerd \
    matplotlib \
    pandas
USER root
WORKDIR /workdir
CMD ["bash", "-c", "umask 000 && jupyter lab --ip=0.0.0.0 --allow-root --NotebookApp.token=''"]
