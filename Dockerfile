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

RUN pip install --requirement requirements.txt
CMD make
