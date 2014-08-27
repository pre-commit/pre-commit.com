from __future__ import absolute_import
from __future__ import unicode_literals

import contextlib
import io
import os.path
import shutil
import subprocess
import tempfile

import aspy.yaml
import ordereddict
import simplejson
from pre_commit.clientlib.validate_manifest import load_manifest


@contextlib.contextmanager
def tempdir():
    directory = tempfile.mkdtemp()
    try:
        yield directory
    finally:
        shutil.rmtree(directory)


def get_manifest_from_repo(repo_path):
    with tempdir() as directory:
        repo_dir = os.path.join(directory, 'repo')
        subprocess.call(['git', 'clone', repo_path, repo_dir])
        manifest_path = os.path.join(repo_dir, 'hooks.yaml')
        # Validate the manifest just to make sure it's ok.
        load_manifest(manifest_path)
        return aspy.yaml.ordered_load(io.open(manifest_path))


def main():
    repos = aspy.yaml.ordered_load(io.open('all-repos.yaml'))
    hooks_json = ordereddict.OrderedDict()
    for repo in repos:
        hooks_json[repo] = get_manifest_from_repo(repo)

    with open('all-hooks.json', 'w') as hooks_json_file:
        simplejson.dump(hooks_json, hooks_json_file, indent=4)


if __name__ == '__main__':
    exit(main())
