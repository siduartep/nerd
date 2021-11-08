all: mutants

module = nerd
codecov_token = 84e068b0-5f49-4a9e-b08a-b90e880fbc6a

define lint
	pylint \
        --disable=bad-continuation \
        --disable=missing-class-docstring \
        --disable=missing-function-docstring \
        --disable=missing-module-docstring \
        ${1}
endef

.PHONY: \
		all \
		check \
		clean \
		coverage \
		format \
		linter \
		mutants \
		setup \
		tests

check:
	black --check --line-length 100 ${module}
	black --check --line-length 100 setup.py
	black --check --line-length 100 tests
	flake8 --max-line-length 100 ${module}
	flake8 --max-line-length 100 setup.py
	flake8 --max-line-length 100 tests

clean:
	rm --force --recursive ${module}.egg-info
	rm --force --recursive ${module}/__pycache__
	rm --force --recursive ${module}/calibration/__pycache__
	rm --force --recursive ${module}/density_functions/__pycache__
	rm --force --recursive ${module}/mapping/__pycache__
	rm --force --recursive ${module}/io/__pycache__
	rm --force --recursive tests/__pycache__
	rm --force .mutmut-cache
	rm --force tests/data/imported_data.csv
	rm --force tests/test_shapefile.*
	rm --force XXinput_data.csvXX

coverage: setup
	pytest --cov=${module} --cov-report=xml --verbose && \
	codecov --token=${codecov_token}

format:
	black --line-length 100 ${module}
	black --line-length 100 setup.py
	black --line-length 100 tests

setup:
	pip install --editable .

linter:
	$(call lint, ${module})
	$(call lint, tests)

mutants: setup
	mutmut run --paths-to-mutate ${module}

tests:
	pytest --verbose