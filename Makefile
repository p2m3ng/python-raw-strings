## TESTS
test:
	py.test

coverage:
	py.test --cov=.

covreport: coverage
	coverage html
	google-chrome htmlcov/index.html

## REQUIREMENTS

freeze:
	pip freeze | grep -v "pkg-resources" > requirements.txt

# CLEAN

clean: clean-build clean-pyc clean-test ## remove all build, test, coverage and Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr prof/
	rm -fr .eggs/
	find . -path ./venv -prune -o -name '*.egg-info' -exec rm -fr {} +
	find . -path ./venv -prune -o -name '*.egg' -exec rm -f {} +
	find . -path ./venv -prune -o -name '*.egg' -exec rm -rf {} +

clean-pyc: ## remove Python file artifacts
	find . -path ./venv -prune -o -name '*.pyc' -exec rm -f {} +
	find . -path ./venv -prune -o -name '*.pyo' -exec rm -f {} +
	find . -path ./venv -prune -o -name '*~' -exec rm -f {} +
	find . -path ./venv -prune -o -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache

prune-venv:
	rm -fr venv/

# Deploy

deploy: clean
	python3 setup.py sdist

# Git

commit:
	make clean
	flake8
	make test
	make freeze
	git status
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]
	git add .
	git commit -a
