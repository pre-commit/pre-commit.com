import functools
import json
import multiprocessing
import os.path
import subprocess
import tempfile
from typing import Any
from typing import Dict
from typing import List
from typing import Tuple

import yaml
from pre_commit.clientlib import load_manifest

Loader = getattr(yaml, 'CSafeLoader', yaml.SafeLoader)
fast_load = functools.partial(yaml.load, Loader=Loader)


def get_manifest(repo_path: str) -> Tuple[bool, str, List[Dict[str, Any]]]:
    print(f'*** {repo_path}')
    with tempfile.TemporaryDirectory() as directory:
        repo_dir = os.path.join(directory, 'repo')
        cmd = ('git', 'clone', '--depth', '1', '-q', repo_path, repo_dir)
        subprocess.check_call(cmd)
        manifest_path = os.path.join(repo_dir, '.pre-commit-hooks.yaml')
        # Validate the manifest just to make sure it's ok.
        manifest = load_manifest(manifest_path)
        # hooks should not set debugging `verbose: true` flag
        for hook in manifest:
            if hook['verbose']:
                print(f'{repo_path} ({hook["id"]}) sets `verbose: true`')
                return False, repo_path, []

        with open(manifest_path) as f:
            return True, repo_path, fast_load(f)


def main() -> int:
    with open('all-repos.yaml') as f:
        repos = fast_load(f)

    hooks_json = {}
    with multiprocessing.Pool(4) as pool:
        for ok, path, manifest in pool.map(get_manifest, repos):
            if not ok:
                return 1
            hooks_json[path] = manifest

    with open('all-hooks.json', 'w') as hooks_json_file:
        json.dump(hooks_json, hooks_json_file, indent=4)
    return 0


if __name__ == '__main__':
    exit(main())
