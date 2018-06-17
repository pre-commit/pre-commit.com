import collections
import json
import multiprocessing
import os.path
import subprocess
import tempfile
from typing import Any
from typing import Dict
from typing import Tuple

import aspy.yaml
from pre_commit.clientlib import load_manifest


def get_manifest(repo_path: str) -> Tuple[str, Dict[str, Any]]:
    print(f'*** {repo_path}')
    with tempfile.TemporaryDirectory() as directory:
        repo_dir = os.path.join(directory, 'repo')
        subprocess.call(('git', 'clone', '-q', repo_path, repo_dir))
        manifest_path = os.path.join(repo_dir, '.pre-commit-hooks.yaml')
        # Validate the manifest just to make sure it's ok.
        load_manifest(manifest_path)
        return (repo_path, aspy.yaml.ordered_load(open(manifest_path)))


def main() -> int:
    repos = aspy.yaml.ordered_load(open('all-repos.yaml'))
    pool = multiprocessing.Pool(4)
    hooks_json = collections.OrderedDict(pool.map(get_manifest, repos))

    with open('all-hooks.json', 'w') as hooks_json_file:
        json.dump(hooks_json, hooks_json_file, indent=4)
    return 0


if __name__ == '__main__':
    exit(main())
