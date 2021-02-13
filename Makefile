all: install-hooks build/main_bs4.css all-hooks.json index.html hooks.html

.PHONY: install-hooks
install-hooks: venv
	venv/bin/pre-commit install

build/main_bs4.css: venv node_modules build scss/main_bs4.scss scss/_variables.scss
	venv/bin/pysassc -s compressed scss/main_bs4.scss build/main_bs4.css

all-hooks.json: venv make_all_hooks.py all-repos.yaml
	venv/bin/python make_all_hooks.py

index.html hooks.html: venv all-hooks.json base.mako index.mako hooks.mako make_templates.py sections/*.md
	venv/bin/python make_templates.py

venv: requirements-dev.txt Makefile
	rm -rf venv
	virtualenv venv -ppython3
	venv/bin/pip install -r requirements-dev.txt

node_modules: package.json
	( \
		npm install && \
		npm prune && \
		touch $@ \
	) || touch $@ --reference $^ --date '1 day ago'

push: venv
	venv/bin/markdown-to-presentation push \
		.nojekyll README.md CNAME \
		build assets node_modules *.html *.png *.svg favicon.ico \
		all-hooks.json install-local.py

clean:
	rm -rf venv build node_modules *.html all-hooks.json

build:
	mkdir -p build

.PHONY: open
open: all
	(which google-chrome && google-chrome index.html) || \
	(which firefox && firefox index.html) &
