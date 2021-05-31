FROM python:3
WORKDIR /workdir
COPY . .
RUN pip install \
    autopep8 \
    black \
    codecov \
    flake8 \
    ipykernel \
    mutmut \
    pylint \
    pytest-cov \
    pytest \
    rope
CMD make
