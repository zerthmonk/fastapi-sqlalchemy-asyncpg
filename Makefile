.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build:	## Build project with compose
	docker-compose build

.PHONY: start
start:  ## Run project with compose
	docker-compose up --remove-orphans --force-recreate

.PHONY: stop
stop:  	## Run project with compose
	docker-compose down --remove-orphans

.PHONY: clean
clean: ## Clean Reset project containers with compose
	docker-compose down -v --remove-orphans

.PHONY: requirements
requirements:	## Refresh requirements.txt from pipfile.lock
	pipenv requirements > requirements.txt

.PHONY: test
test:	## Run project tests
	docker-compose -f docker-compose.yml -f docker-compose.test.yml  run --rm skaben pytest

.PHONY: safety
safety:	## Check project and dependencies with safety https://github.com/pyupio/safety
	docker-compose run --rm skaben safety check

.PHONY: py-upgrade
py-upgrade:	## Upgrade project py files with pyupgrade library for python version 3.10
	pyupgrade --py310-plus `find skaben -name "*.py"`

.PHONY: lint
lint:  ## Lint project code.
	isort skaben tests --check
	flake8 --config .flake8 skaben tests
	mypy skaben tests
	black skaben tests --line-length=120 --check --diff


.PHONY: format
format:  ## Format project code.
	isort skaben tests
	autoflake --remove-all-unused-imports --recursive --remove-unused-variables --in-place skaben tests --exclude=__init__.py
	black skaben tests --line-length=120
