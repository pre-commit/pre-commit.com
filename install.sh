#!/bin/sh

# Install pip
curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
python /tmp/get-pip.py --user
PATH=$HOME/Library/Python/2.7/bin:$PATH

# Use pip to get a virtualenv
pip install virtualenv
virtualenv ~/.py_env

# Install pre-commit into the virtualenv
bash -c 'PATH=$HOME/Library/Python/2.7/bin:$PATH && source ~/.py_env/bin/activate && pip install --upgrade git+git://github.com/pre-commit/pre-commit#egg=pre_commit'

echo ""
echo ""
echo "$(tput setaf 2)"
echo "Please add the following line to your .bashrc:"
echo "PATH=PATH:~/.py_env/bin"
echo "$(tput sgr0)"
