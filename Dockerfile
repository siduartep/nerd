FROM python:3.8
WORKDIR /workdir
COPY . .
RUN pip install \
    autopep8 \
    black \
    codecov \
    descartes \
    fiona \
    flake8 \
    json \
    mutmut \
    osmnx \
    pandas \
    pylint \
    pytest-cov \
    pytest==5.0.1 \
    rope \
    shapely

RUN pip install --requirement requirements.txt
CMD make
