#!/bin/sh

curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
python /tmp/get-pip.py
pip install pre-commit --upgrade
