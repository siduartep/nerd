all: mutants

repo = nerd
codecov_token = 84e068b0-5f49-4a9e-b08a-b90e880fbc6a

.PHONY: all clean format install lint mutants tests

clean:
	rm --force .mutmut-cache
	rm --recursive --force ${repo}.egg-info
	rm --recursive --force ${repo}/__pycache__
	rm --recursive --force test/__pycache__

format:
	black --check --line-length 100 ${repo}
	black --check --line-length 100 tests

install:
	pip install --editable .

lint:
	flake8 --max-line-length 100 ${repo}
	flake8 --max-line-length 100 tests
	pylint \
        --disable=bad-continuation \
        --disable=missing-function-docstring \
        --disable=missing-module-docstring \
        ${repo}
	pylint \
        --disable=bad-continuation \
        --disable=missing-function-docstring \
        --disable=missing-module-docstring \
        tests

mutants:
	mutmut run --paths-to-mutate ${repo}

tests: install
	pytest --cov=${repo} --cov-report=xml --verbose && \
	codecov --token=${codecov_token}
