all: install tests

.PHONY: \
    all \
    build \
    build_demo \
    clean \
    install \
    lint \
    run_demo \
    tests \

build:
	docker build --tag=islasgeci/nerd .

install:
	pip install --editable .

lint:
	pylint nerd

tests:
	pytest --cov=nerd --cov-report=term --verbose

clean:
	rm --force --recursive .pytest_cache
	rm --force --recursive $(find . -name '__pycache__')

#Demonstration
build_demo:
	docker build --file Dockerfile.demo --tag=islasgeci/nerd_demo .

run_demo:
	docker run --publish 8080:8888 --rm islasgeci/nerd_demo
