SHELL := /usr/bin/bash

.PHONY: top
top: default

.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  default       Initialize virtualenv then autobuild"
	@echo "  docs-server   Serve docs with autobuild"
	@echo "  docs-clean    Clean docs"
	@echo "  docs-html     Build HTML docs"
	@echo "  docs-pdf      Build HTML docs"
	@echo "  init-venv     Initialize virtualenv"
	@echo "  format        Format code with isort and black"
	@echo "  lint          Lint code with flake8, isort and black"
	@echo "  format-black  Format code with black"
	@echo "  lint-black    Lint code with black"
	@echo "  format-isort  Format code with isort"
	@echo "  lint-isort    Lint code with isort"
	@echo "  lint-flake8   Lint code with flake8"
	@echo "  test          Run tests"
	@echo "  test-update-snapshots"
	@echo "                Run tests and update snapshots"

.PHONY: default
default: init-venv docs-server

.PHONY: docs-server
docs-server:
	source venv/bin/activate && \
		sphinx-autobuild -b html src/ build/html

.PHONY: docs-clean
docs-clean:
	make -C src clean

.PHONY: docs-html
docs-html:
	make -C src html

.PHONY: docs-pdf
docs-pdf:
	make -C src latexpdf

.PHONY: init-venv
init-venv:
		test -e venv || ( \
			virtualenv venv && \
			source venv/bin/activate && \
			pip install -r requirements.txt \
			)

.PHONY: format
format: format-isort format-black

.PHONY: lint
lint: lint-flake8 lint-isort lint-black

.PHONY: format-black
format-black:
	black -l 100 .

.PHONY: lint-black
lint-black:
	black -l 100 --check .

.PHONY: format-isort
format-isort:
	isort --force-sort-within-sections --profile=black .

.PHONY: lint-isort
lint-isort:
	isort --force-sort-within-sections --profile=black --check .

.PHONY: lint-flake8
lint-flake8:
	flake8

.PHONY: test
test:
	TZ=UTC LC_ALL=C pytest .

.PHONY: test-update-snapshots
test-update-snapshots:
	TZ=UTC LC_ALL=C pytest --snapshot-update .
