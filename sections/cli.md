All pre-commit commands take the following options:

- `--color {auto,always,never}`: whether to use color in output.
  Defaults to `auto`.  _new in 1.18.0_: can be overridden by using
  `PRE_COMMIT_COLOR={auto,always,never}` or disabled using `TERM=dumb`.
- `-c CONFIG`, `--config CONFIG`: path to alternate config file
- `-h`, `--help`: show help and available options.

_new in 2.8.0_: `pre-commit` now exits with more specific codes:
- `1`: a detected / expected error
- `3`: an unexpected error
- `130`: the process was interrupted by `^C`

## pre-commit autoupdate [options] #pre-commit-autoupdate

Auto-update pre-commit config to the latest repos' versions.

By default, pre-commit will choose the latest tag on the repository's default
branch, preferentially picking a tag that contains a `.` in the case of ties.

Options:

- `--bleeding-edge`: update to the latest commit of the default branch instead
  of the latest tagged version (the default behaviour).
- `--freeze`: _new in 1.21.0_: Store "frozen" hashes in [`rev`](#repos-rev)
  instead of tag names.
- `--repo REPO`: _new in 1.4.1_: Only update this repository. _new in 1.7.0_:
  This option may be specified multiple times.

Here are some sample invocations using this `.pre-commit-config.yaml`:

```yaml
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v2.1.0
    hooks:
    -   id: trailing-whitespace
-   repo: https://github.com/asottile/pyupgrade
    rev: v1.25.0
    hooks:
    -   id: pyupgrade
        args: [--py36-plus]
```

```console
$ : default: update to latest tag on default branch
$ pre-commit autoupdate  # by default: pick tags
Updating https://github.com/pre-commit/pre-commit-hooks ... updating v2.1.0 -> v2.4.0.
Updating https://github.com/asottile/pyupgrade ... updating v1.25.0 -> v1.25.2.
$ grep rev: .pre-commit-config.yaml
    rev: v2.4.0
    rev: v1.25.2
```

```console
$ : update a specific repository to the latest revision of the default branch
$ pre-commit autoupdate --bleeding-edge --repo https://github.com/pre-commit/pre-commit-hooks
Updating https://github.com/pre-commit/pre-commit-hooks ... updating v2.1.0 -> 5df1a4bf6f04a1ed3a643167b38d502575e29aef.
$ grep rev: .pre-commit-config.yaml
    rev: 5df1a4bf6f04a1ed3a643167b38d502575e29aef
    rev: v1.25.0
```

```console
$ : update to frozen versions
$ pre-commit autoupdate --freeze
Updating https://github.com/pre-commit/pre-commit-hooks ... updating v2.1.0 -> v2.4.0 (frozen).
Updating https://github.com/asottile/pyupgrade ... updating v1.25.0 -> v1.25.2 (frozen).
$ grep rev: .pre-commit-config.yaml
    rev: 0161422b4e09b47536ea13f49e786eb3616fe0d7  # frozen: v2.4.0
    rev: 34a269fd7650d264e4de7603157c10d0a9bb8211  # frozen: v1.25.2
```

You can check what the latest tag on the default branch of any repository is,
you can do the following (using the pre-commit-hooks repository as an example):

```console
$ git clone --quiet https://github.com/pre-commit/pre-commit-hooks
$ cd pre-commit-hooks
$ git describe --tags --abbrev=0
v2.4.0
```

_new in 2.18.0_: pre-commit will preferentially pick tags containing a `.` if
there are ties.

## pre-commit clean [options] #pre-commit-clean

Clean out cached pre-commit files.

Options: (no additional options)

## pre-commit gc [options] #pre-commit-gc

_new in 1.14.0_

Clean unused cached repos.

`pre-commit` keeps a cache of installed hook repositories which grows over
time.  This command can be run periodically to clean out unused repos from
the cache directory.

Options: (no additional options)

## pre-commit init-templatedir DIRECTORY [options] #pre-commit-init-templatedir

_new in 1.18.0_

Install hook script in a directory intended for use with
`git config init.templateDir`.

Options:

- `-t {pre-commit,pre-merge-commit,pre-push,prepare-commit-msg,commit-msg,post-checkout,post-commit,post-merge,post-rewrite}`,
  `--hook-type {pre-commit,pre-merge-commit,pre-push,prepare-commit-msg,commit-msg,post-checkout,post-commit,post-merge,post-rewrite}`:
  which hook type to install.

Some example useful invocations:

```bash
git config --global init.templateDir ~/.git-template
pre-commit init-templatedir ~/.git-template
```

For Windows cmd.exe use `%HOMEPATH%` instead of `~`:

```batch
pre-commit init-templatedir %HOMEPATH%\.git-template
```

For Windows PowerShell use `$HOME` instead of `~`:

```powershell
pre-commit init-templatedir $HOME\.git-template
```

Now whenever a repository is cloned or created, it will have the hooks set up
already!

## pre-commit install [options] #pre-commit-install

Install the pre-commit script.

Options:

- `-f`, `--overwrite`: Replace any existing git hooks with the pre-commit
  script.
- `--install-hooks`: Also install environments for all available hooks now
  (rather than when they are first executed). See [`pre-commit
  install-hooks`](#pre-commit-install-hooks).
- `-t {pre-commit,pre-merge-commit,pre-push,prepare-commit-msg,commit-msg,post-checkout,post-commit,post-merge,post-rewrite}`,
  `--hook-type {pre-commit,pre-merge-commit,pre-push,prepare-commit-msg,commit-msg,post-checkout,post-commit,post-merge,post-rewrite}`:
  Specify which hook type to install.
- `--allow-missing-config`: Hook scripts will permit a missing configuration
  file.

Some example useful invocations:

- `pre-commit install`: Default invocation. Installs the hook scripts
   alongside any existing git hooks.
- `pre-commit install --install-hooks --overwrite`: Idempotently replaces
   existing git hook scripts with pre-commit, and also installs hook
   environments.

_new in 2.18.0_: `pre-commit install` will now install hooks from
[`default_install_hook_types`](#top_level-default_language_version) if
`--hook-type` is not specified on the command line.

## pre-commit install-hooks [options] #pre-commit-install-hooks

Install all missing environments for the available hooks. Unless this command or
`install --install-hooks` is executed, each hook's environment is created the
first time the hook is called.

Each hook is initialized in a separate environment appropriate to the language
the hook is written in. See [supported languages](#supported-languages).

This command does not install the pre-commit script. To install the script along with
the hook environments in one command, use `pre-commit install --install-hooks`.

Options: (no additional options)

## pre-commit migrate-config [options] #pre-commit-migrate-config

_new in 1.0.0_

Migrate list configuration to the new map configuration format.

Options: (no additional options)

## pre-commit run [hook-id] [options] #pre-commit-run

Run hooks.

Options:

- `[hook-id]`: specify a single hook-id to run only that hook.
- `-a`, `--all-files`: run on all the files in the repo.
- `--files [FILES [FILES ...]]`: specific filenames to run hooks on.
- `--from-ref FROM_REF` + `--to-ref TO_REF`: run against the files changed
  between `FROM_REF...TO_REF` in git.
    - _new in 2.2.0_: prior to 2.2.0 the arguments were `--source` and
      `--origin`.
- `--hook-stage STAGE`: select a [`stage` to run](#confining-hooks-to-run-at-certain-stages).
- `--show-diff-on-failure`: when hooks fail, run `git diff` directly afterward.
- `-v`, `--verbose`: produce hook output independent of success.  Include hook
  ids in output.

Some example useful invocations:
- `pre-commit run`: this is what pre-commit runs by default when committing.
  This will run all hooks against currently staged files.
- `pre-commit run --all-files`: run all the hooks against all the files.  This
  is a useful invocation if you are using pre-commit in CI.
- `pre-commit run flake8`: run the `flake8` hook against all staged files.
- `git ls-files -- '*.py' | xargs pre-commit run --files`: run all hooks
  against all `*.py` files in the repository.
- `pre-commit run --from-ref HEAD^^^ --to-ref HEAD`: run against the files that
  have changed between `HEAD^^^` and `HEAD`.  This form is useful when
  leveraged in a pre-receive hook.

## pre-commit sample-config [options] #pre-commit-sample-config

Produce a sample `.pre-commit-config.yaml`.

Options: (no additional options)

## pre-commit try-repo REPO [options] #pre-commit-try-repo

_new in 1.3.0_

Try the hooks in a repository, useful for developing new hooks.
`try-repo` can also be used for testing out a repository before adding it to
your configuration.  `try-repo` prints a configuration it generates based on
the remote hook repository before running the hooks.

Options:

- `REPO`: required clonable hooks repository.  Can be a local path on
  disk.
- `--ref REF`: Manually select a ref to run against, otherwise the `HEAD`
  revision will be used.
- `pre-commit try-repo` also supports all available options for
  [`pre-commit run`](#pre-commit-run).

Some example useful invocations:
- `pre-commit try-repo https://github.com/pre-commit/pre-commit-hooks`: runs
  all the hooks in the latest revision of `pre-commit/pre-commit-hooks`.
- `pre-commit try-repo ../path/to/repo`: run all the hooks in a repository on
  disk.
- `pre-commit try-repo ../pre-commit-hooks flake8`: run only the `flake8` hook
  configured in a local `../pre-commit-hooks` repository.
- See [`pre-commit run`](#pre-commit-run) for more useful `run` invocations
  which are also supported by `pre-commit try-repo`.

## pre-commit uninstall [options] #pre-commit-uninstall

Uninstall the pre-commit script.

Options:

- `-t {pre-commit,pre-merge-commit,pre-push,prepare-commit-msg,commit-msg,post-checkout,post-commit,post-merge,post-rewrite}`,
  `--hook-type {pre-commit,pre-merge-commit,pre-push,prepare-commit-msg,commit-msg,post-checkout,post-commit,post-merge,post-rewrite}`:
  which hook type to uninstall.
