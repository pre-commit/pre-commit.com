all: install-hooks build/main_bs5.css index.html hooks.html

.PHONY: install-hooks
install-hooks: venv
	venv/bin/pre-commit install

build/main_bs5.css: node_modules build scss/main_bs5.scss scss/_variables.scss
	node_modules/.bin/sass --style=compressed --load-path=. scss/main_bs5.scss build/main_bs5.css

index.html hooks.html: venv base.mako index.mako hooks.mako make_templates.py template_lib.py sections/*.md
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
		build assets *.html *.png *.svg favicon.ico

clean:
	rm -rf venv build node_modules *.html

build:
	mkdir -p build

.PHONY: open
open: all
	(which google-chrome && google-chrome index.html) || \
	(which firefox && firefox index.html) &
