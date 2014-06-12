scss: py_env build scss/main.scss
	bash -c 'source py_env/bin/activate && \
    	pyscss -o build/main.css scss/main.scss'

py_env: requirements-dev.txt
	virtualenv py_env

	bash -c 'source py_env/bin/activate && \
		pip install -r requirements-dev.txt'

install-local.py: py_env make_bootstrap.py
	bash -c '. py_env/bin/activate && \
		python make_bootstrap.py'

clean:
	rm -rf py_env
	rm -rf build_dir

build_dir:
	mkdir build

open: scss
	(which google-chrome && google-chrome index.html) || \
	(which firefox && firefox index.html) &
