all: install_pre_commit build/main.css

install_pre_commit: py_env
	bash -c 'source py_env/bin/activate && \
		pre-commit install'

build/main.css: node_env build_dir scss/main.scss
	bash -c 'source py_env/bin/activate && \
    	pyscss -o build/main.css scss/main.scss'

py_env: requirements-dev.txt
	virtualenv py_env

	bash -c 'source py_env/bin/activate && \
		pip install -r requirements-dev.txt'

node_env: py_env
	bash -c 'source py_env/bin/activate && \
		nodeenv node_env --prebuilt && \
		source node_env/bin/activate && \
		npm install -g bower && \
		bower install'

install-local.py: py_env make_bootstrap.py
	bash -c '. py_env/bin/activate && \
		python make_bootstrap.py'

clean:
	rm -rf py_env node_env build bower_components

build_dir:
	mkdir build

open: scss
	(which google-chrome && google-chrome index.html) || \
	(which firefox && firefox index.html) &
