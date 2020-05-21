#!/usr/bin/env python
from __future__ import absolute_import
from __future__ import print_function
from __future__ import unicode_literals

import contextlib
import distutils.spawn
import hashlib
import io
import os.path
import shutil
import subprocess
import sys
import tarfile


if str is bytes:
    from urllib import urlopen  # type: ignore
else:
    from urllib.request import urlopen

if False:
    from typing import Generator


TGZ = (
    'https://files.pythonhosted.org/packages/a4/e3/'
    '1f067de470e3a86875ed915438dc3bd781fb0346254f541190a09472b677/'
    'virtualenv-16.7.10.tar.gz'
)
CHECKSUM = 'e88fdcb08b0ecb11da97868f463dd06275923f50d87f4b9c8b2fc0994eec40f4'
PKG_PATH = '/tmp/.virtualenv-pkg'


def clean(dirname):
    # type: (str) -> None
    if os.path.exists(dirname):
        shutil.rmtree(dirname)


@contextlib.contextmanager
def clean_path():
    # type: (...) -> Generator[None, None, None]
    try:
        yield
    finally:
        clean(PKG_PATH)


def virtualenv(path):
    # type: (str) -> int
    clean(PKG_PATH)
    clean(path)

    print('Downloading ' + TGZ)
    tar_bytes = urlopen(TGZ).read()
    checksum = hashlib.sha256(tar_bytes).hexdigest()
    if checksum != CHECKSUM:
        print(
            'Checksums did not match. '
            'Got {}, expected {}.'.format(checksum, CHECKSUM),
            file=sys.stderr,
        )
        return 1

    tar_stream = io.BytesIO(tar_bytes)
    with contextlib.closing(tarfile.open(fileobj=tar_stream)) as tarfile_obj:
        # Chop off the first path segment to avoid having the version in
        # the path
        for member in tarfile_obj.getmembers():
            _, _, member.name = member.name.partition('/')
            if member.name:
                tarfile_obj.extract(member, PKG_PATH)
    print('Done.')

    with clean_path():
        return subprocess.call((
            sys.executable, os.path.join(PKG_PATH, 'virtualenv.py'), path,
        ))


def main():
    # type: (...) -> int
    venv_path = os.path.join(os.environ['HOME'], '.pre-commit-venv')
    bin_dir = os.path.join(os.environ['HOME'], 'bin')
    script_src = os.path.join(venv_path, 'bin', 'pre-commit')
    script_dest = os.path.join(bin_dir, 'pre-commit')

    if sys.argv[1:] == ['uninstall']:
        clean(PKG_PATH)
        clean(venv_path)
        if os.path.lexists(script_dest):
            os.remove(script_dest)
        print('Cleaned ~/.pre-commit-venv ~/bin/pre-commit')
        return 0

    if virtualenv(venv_path):
        return 1

    subprocess.check_call((
        os.path.join(venv_path, 'bin', 'pip'), 'install', 'pre-commit',
    ))

    print('*' * 79)
    print('Installing pre-commit to {}'.format(script_dest))
    print('*' * 79)

    if not os.path.exists(bin_dir):
        os.mkdir(bin_dir)

    # os.symlink is not idempotent
    if os.path.exists(script_dest):
        os.remove(script_dest)

    os.symlink(script_src, script_dest)

    if not distutils.spawn.find_executable('pre-commit'):
        print('It looks like {} is not on your path'.format(bin_dir))
        print('You may want to add it.')
        print('Often this does the trick: source ~/.profile')

    return 0


if __name__ == '__main__':
    exit(main())
