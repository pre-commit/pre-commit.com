Before you can run hooks, you need to have the pre-commit package manager
installed.

Using pip:

```bash
pip install pre-commit
```

In a python project, add the following to your requirements.txt (or
requirements-dev.txt):

```
pre-commit
```

As a 0-dependency [zipapp]:

- locate and download the `.pyz` file from the [github releases]
- run `python pre-commit-#.#.#.pyz ...` in place of `pre-commit ...`

[zipapp]: https://docs.python.org/3/library/zipapp.html
[github releases]: https://github.com/pre-commit/pre-commit/releases

Using [homebrew](https://brew.sh):

```bash
brew install pre-commit
```

Using [conda](https://conda.io) (via [conda-forge](https://conda-forge.org)):

```bash
conda install -c conda-forge pre-commit
```

## Quick start

### 1. Install pre-commit

- follow the [install](#install) instructions above
- `pre-commit --version` should show you what version you're using

```cmd
pre-commit --version
```

### 2. Add a pre-commit configuration

- create a file named `.pre-commit-config.yaml`
- you can generate a very basic configuration using
  [`pre-commit sample-config`](#pre-commit-sample-config)
- the full set of options for the configuration are listed [below](#plugins)
- this example uses a formatter for python code, however `pre-commit` works for
  any programming language
- other [supported hooks](hooks.html) are available

```yaml
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.3.0
    hooks:
    -   id: check-yaml
    -   id: end-of-file-fixer
    -   id: trailing-whitespace
-   repo: https://github.com/psf/black
    rev: 21.12b0
    hooks:
    -   id: black
```

### 3. Install the git hook scripts

- run `pre-commit install` to set up the git hook scripts

```console
$ pre-commit install
pre-commit installed at .git/hooks/pre-commit
```

- now `pre-commit` will run automatically on `git commit`!

### 4. (optional) Run against all the files

- it's usually a good idea to run the hooks against all of the files when adding
  new hooks (usually `pre-commit` will only run on the changed files during
  git hooks)

```pre-commit
$ pre-commit run --all-files
[INFO] Initializing environment for https://github.com/pre-commit/pre-commit-hooks.
[INFO] Initializing environment for https://github.com/psf/black.
[INFO] Installing environment for https://github.com/pre-commit/pre-commit-hooks.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...
[INFO] Installing environment for https://github.com/psf/black.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...
Check Yaml...............................................................Passed
Fix End of Files.........................................................Passed
Trim Trailing Whitespace.................................................Failed
- hook id: trailing-whitespace
- exit code: 1

Files were modified by this hook. Additional output:

Fixing sample.py

black....................................................................Passed
```

- oops! looks like I had some trailing whitespace
- consider running that in [CI](#usage-in-continuous-integration) too
