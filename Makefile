# To build scss continuously I use `watch -n 0.1 make build/main.css`

all: install_pre_commit build/main.css all-hooks.json index.html hooks.html install-local.py

.PHONY: install_pre_commit
install_pre_commit: py_env
	. py_env/bin/activate && pre-commit install

build/main.css: node_env build scss/main.scss scss/_variables.scss
	. py_env/bin/activate && sassc -s compressed scss/main.scss build/main.css

all-hooks.json: py_env make_all_hooks.py all-repos.yaml
	. py_env/bin/activate && python make_all_hooks.py

index.html hooks.html: py_env all-hooks.json base.mako index.mako hooks.mako make_templates.py
	. py_env/bin/activate && python make_templates.py

install-local.py: py_env make_bootstrap.py
	. py_env/bin/activate && python make_bootstrap.py

py_env: requirements-dev.txt
	rm -rf py_env
	virtualenv py_env
	. py_env/bin/activate && pip install -r requirements-dev.txt

node_env: py_env
	rm -rf node_env
	. py_env/bin/activate && \
		nodeenv node_env --prebuilt && \
		. node_env/bin/activate && \
		npm install -g bower && \
		bower install

clean:
	rm -rf py_env node_env build bower_components *.html install-local.py all-hooks.json

build:
	mkdir -p build

.PHONY: open
open: all
	(which google-chrome && google-chrome index.html) || \
	(which firefox && firefox index.html) &
