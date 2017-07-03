# To build scss continuously I use `watch -n 0.1 make build/main.css`

all: install-hooks build/main.css all-hooks.json index.html hooks.html

.PHONY: install-hooks
install-hooks: venv
	venv/bin/pre-commit install

build/main.css: venv node_modules build scss/main.scss scss/_variables.scss
	venv/bin/sassc -s compressed scss/main.scss build/main.css

all-hooks.json: venv make_all_hooks.py all-repos.yaml
	venv/bin/python make_all_hooks.py

index.html hooks.html: venv all-hooks.json base.mako index.mako hooks.mako make_templates.py
	venv/bin/python make_templates.py

venv: requirements-dev.txt Makefile
	rm -rf venv
	virtualenv venv -ppython3.6
	venv/bin/pip install -r requirements-dev.txt

node_modules: package.json
	( \
		npm install && \
		npm prune && \
		touch $@ \
	) || touch $@ --reference $^ --date '1 day ago'

push: venv
	venv/bin/markdown-to-presentation push \
		--master-branch real_master \
		--pages-branch master \
		.travis.yml README.md CNAME \
		build node_modules *.html *.png favicon.ico \
		all-hooks.json install-local.py

clean:
	rm -rf venv build node_modules *.html all-hooks.json

build:
	mkdir -p build

.PHONY: open
open: all
	(which google-chrome && google-chrome index.html) || \
	(which firefox && firefox index.html) &
