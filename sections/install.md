pre-commit is a command-line tool. To check to see if pre-commit is installed,
run it like this:

```bash
pre-commit --version
```

pre-commit is designed for projects in any programming language, and pre-commit
plugins are written in different languages as well. pre-commit itself is built
using Python, and for that reason, you need to make sure that the `python` or
`python3` executable is installed on your machine:

```bash
python --version # or: python3 --version
```

Now, choose one of these official installation methods to install the
pre-commit tool:

### Using [`pipx`](https://pipx.pypa.io/stable/):

```bash
pipx install pre-commit
```

### Using a download from GitHub releases' page:

1. Navigate to [pre-commit's GitHub releases][github releases]
2. Download the `.pyz` file listed there. `.pyz` files only depend on
    Python and include all other dependencies (see [zipapp]).
3. Mark it as executable:
    ```bash
    chmod +x pre-commit-*.pyz
    ```
4. Now run it:
    ```bash
    ./pre-commit-*.pyz --version
    ```
5. To run it as `pre-commit` from any directory, rename the file to
   `pre-commit` and move it to somewhere on your `PATH`.

### As a dependency in your Python project:

If you prefer to install pre-commit in your Python project's virtual
environment, run `pip install pre-commit` or add `pre-commit` to your
`requirements.txt` or `requirements-dev.txt` or `Pipfile` or `pyproject.toml`.


[zipapp]: https://docs.python.org/3/library/zipapp.html
[github releases]: https://github.com/pre-commit/pre-commit/releases

## Quick start

### 1. Add a pre-commit configuration

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
    rev: v2.3.0
    hooks:
    -   id: check-yaml
    -   id: end-of-file-fixer
    -   id: trailing-whitespace
-   repo: https://github.com/psf/black
    rev: 22.10.0
    hooks:
    -   id: black
```

### 2. Install the git hook scripts

- run `pre-commit install` to set up the git hook scripts

```console
$ pre-commit install
pre-commit installed at .git/hooks/pre-commit
```

- now `pre-commit` will run automatically on `git commit`!

### 3. (optional) Run against all the files

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
