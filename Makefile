# To build scss continuously I use `watch -n 0.1 make build/main.css`

all: install-hooks build/main.css all-hooks.json index.html hooks.html

.PHONY: install-hooks
install-hooks: venv
	venv/bin/pre-commit install

build/main.css: nenv build scss/main.scss scss/_variables.scss
	venv/bin/sassc -s compressed scss/main.scss build/main.css

all-hooks.json: venv make_all_hooks.py all-repos.yaml
	venv/bin/python make_all_hooks.py

index.html hooks.html: venv all-hooks.json base.mako index.mako hooks.mako make_templates.py
	venv/bin/python make_templates.py

venv: requirements-dev.txt
	rm -rf venv
	virtualenv venv
	venv/bin/pip install -r requirements-dev.txt

nenv: venv
	rm -rf nenv
	venv/bin/nodeenv nenv --prebuilt && \
		. nenv/bin/activate && \
		npm install -g bower && \
		bower install

clean:
	rm -rf venv nenv build bower_components *.html all-hooks.json

build:
	mkdir -p build

.PHONY: open
open: all
	(which google-chrome && google-chrome index.html) || \
	(which firefox && firefox index.html) &
