from __future__ import absolute_import
from __future__ import unicode_literals

import collections
import json
import os.path
import subprocess
import tempfile

import aspy.yaml
from pre_commit.clientlib import load_manifest


def get_manifest_from_repo(repo_path):
    with tempfile.TemporaryDirectory() as directory:
        repo_dir = os.path.join(directory, 'repo')
        subprocess.call(('git', 'clone', repo_path, repo_dir))
        manifest_path = os.path.join(repo_dir, '.pre-commit-hooks.yaml')
        manifest_path_legacy = os.path.join(repo_dir, 'hooks.yaml')
        if os.path.exists(manifest_path):
            path = manifest_path
        else:
            path = manifest_path_legacy
        # Validate the manifest just to make sure it's ok.
        load_manifest(path)
        return aspy.yaml.ordered_load(open(path))


def main():
    repos = aspy.yaml.ordered_load(open('all-repos.yaml'))
    hooks_json = collections.OrderedDict()
    for repo in repos:
        hooks_json[repo] = get_manifest_from_repo(repo)

    with open('all-hooks.json', 'w') as hooks_json_file:
        json.dump(hooks_json, hooks_json_file, indent=4)


if __name__ == '__main__':
    exit(main())
