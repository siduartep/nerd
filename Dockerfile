FROM python:3
WORKDIR /workdir
COPY . .
RUN pip install \
    autopep8 \
    black \
    codecov \
    flake8 \
    mutmut \
    pandas \
    pylint \
    pytest-cov \
    pytest==5.0.1 \
    rope
RUN pip install --requirement requirements.txt
CMD make
