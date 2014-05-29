#!/bin/sh

curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
python /tmp/get-pip.py
pip install git+git://github.com/pre-commit/pre-commit#egg=pre_commit
