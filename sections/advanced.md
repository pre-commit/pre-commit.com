## Running in migration mode

By default, if you have existing hooks `pre-commit install` will install in a
migration mode which runs both your existing hooks and hooks for pre-commit.
To disable this behavior, pass `-f` / `--overwrite` to the `install` command.
If you decide not to use pre-commit, `pre-commit uninstall` will
restore your hooks to the state prior to installation.

## Temporarily disabling hooks

Not all hooks are perfect so sometimes you may need to skip execution of one
or more hooks. pre-commit solves this by querying a `SKIP` environment
variable. The `SKIP` environment variable is a comma separated list of hook
ids. This allows you to skip a single hook instead of `--no-verify`ing the
entire commit.

```console
$ SKIP=flake8 git commit -m "foo"
```

## Confining hooks to run at certain stages

pre-commit supports many different types of `git` hooks (not just
`pre-commit`!).

Providers of hooks can select which git hooks they run on by setting the
[`stages`](#hooks-stages) property in `.pre-commit-hooks.yaml` -- this can
also be overridden by setting [`stages`](#config-stages) in
`.pre-commit-config.yaml`.  If `stages` is not set in either of those places
the default value will be pulled from the top-level
[`default_stages`](#top_level-default_stages) option (which defaults to _all_
stages).  By default, tools are enabled for [every hook type](#supported-git-hooks)
that pre-commit supports.

_new in 3.2.0_: The values of `stages` match the hook names.  Previously,
`commit`, `push`, and `merge-commit` matched `pre-commit`, `pre-push`, and
`pre-merge-commit` respectively.

The `manual` stage (via `stages: [manual]`) is a special stage which will not
be automatically triggered by any `git` hook -- this is useful if you want to
add a tool which is not automatically run, but is run on demand using
`pre-commit run --hook-stage manual [hookid]`.

If you are authoring a tool, it is usually a good idea to provide an appropriate
`stages` property.  For example a reasonable setting for a linter or code
formatter would be `stages: [pre-commit, pre-merge-commit, pre-push, manual]`.

To install `pre-commit` for particular git hooks, pass `--hook-type` to
`pre-commit install`.  This can be specified multiple times such as:

```console
$ pre-commit install --hook-type pre-commit --hook-type pre-push
pre-commit installed at .git/hooks/pre-commit
pre-commit installed at .git/hooks/pre-push
```

Additionally, one can specify a default set of git hook types to be installed
for by setting the top-level [`default_install_hook_types`](#top_level-default_install_hook_types).

For example:

```yaml
default_install_hook_types: [pre-commit, pre-push, commit-msg]
```

```console
$ pre-commit  install
pre-commit installed at .git/hooks/pre-commit
pre-commit installed at .git/hooks/pre-push
pre-commit installed at .git/hooks/commit-msg
```

[anchor](__#pre-commit-during-commits)
[anchor](__#pre-commit-during-merges)
[anchor](__#pre-commit-during-clean-merges)
[anchor](__#pre-commit-during-push)
[anchor](__#pre-commit-for-commit-messages)
[anchor](__#pre-commit-for-switching-branches)
[anchor](__#pre-commit-for-rewriting)

## Supported git hooks

- [commit-msg](#commit-msg)
- [post-checkout](#post-checkout)
- [post-commit](#post-commit)
- [post-merge](#post-merge)
- [post-rewrite](#post-rewrite)
- [pre-commit](#pre-commit)
- [pre-merge-commit](#pre-merge-commit)
- [pre-push](#pre-push)
- [pre-rebase](#pre-rebase)
- [prepare-commit-msg](#prepare-commit-msg)

### commit-msg

[git commit-msg docs](https://git-scm.com/docs/githooks#_commit_msg)

`commit-msg` hooks will be passed a single filename -- this file contains the
current contents of the commit message to be validated.  The commit will be
aborted if there is a nonzero exit code.

### post-checkout

_new in 2.2.0_

[git post-checkout docs](https://git-scm.com/docs/githooks#_post_checkout)

post-checkout hooks run *after* a `checkout` has occurred and can be used to
set up or manage state in the repository.

`post-checkout` hooks do not operate on files so they must be set as
`always_run: true` or they will always be skipped.

environment variables:
- `PRE_COMMIT_FROM_REF`: the first argument to the `post-checkout` git hook
- `PRE_COMMIT_TO_REF`:  the second argument to the `post-checkout` git hook
- `PRE_COMMIT_CHECKOUT_TYPE`: the third argument to the `post-checkout` git hook

### post-commit

_new in 2.4.0_

[git post-commit docs](https://git-scm.com/docs/githooks#_post_commit)

`post-commit` runs after the commit has already succeeded so it cannot be used
to prevent the commit from happening.

`post-commit` hooks do not operate on files so they must be set as
`always_run: true` or they will always be skipped.

### post-merge

_new in 2.11.0_

[git post-merge docs](https://git-scm.com/docs/githooks#_post_merge)

`post-merge` runs after a successful `git merge`.

environment variables:
- `PRE_COMMIT_IS_SQUASH_MERGE`: the first argument to the `post-merge` git hook.

### post-rewrite

_new in 2.15.0_

[git post-rewrite docs](https://git-scm.com/docs/githooks#_post_rewrite)

`post-rewrite` runs after a git command which modifies history such as
`git commit --amend` or `git rebase`.

`post-rewrite` hooks do not operate on files so they must be set as
`always_run: true` or they will always be skipped.

environment variables:
- `PRE_COMMIT_REWRITE_COMMAND`: the first argument to the `post-rewrite` git hook.

### pre-commit

[git pre-commit docs](https://git-scm.com/docs/githooks#_pre_commit)

`pre-commit` is triggered before the commit is finalized to allow checks on the
code being committed.  Running hooks on unstaged changes can lead to both
false-positives and false-negatives during committing.  pre-commit only runs
on the staged contents of files by temporarily stashing the unstaged changes
while running hooks.

### pre-merge-commit

[git pre-merge-commit docs](https://git-scm.com/docs/githooks#_pre_merge_commit)

`pre-merge-commit` fires after a merge succeeds but before the merge commit is
created.  This hook runs on all staged files from the merge.

Note that you need to be using at least git 2.24 for this hook.

### pre-push

[git pre-push docs](https://git-scm.com/docs/githooks#_pre_push)

`pre-push` is triggered on `git push`.

environment variables:
- `PRE_COMMIT_FROM_REF`: the revision that is being pushed to.
- `PRE_COMMIT_TO_REF`: the local revision that is being pushed to the remote.
- `PRE_COMMIT_REMOTE_NAME`: which remote is being pushed to (for example `origin`)
- `PRE_COMMIT_REMOTE_URL`: the url of the remote that is being pushed to (for
  example `git@github.com:pre-commit/pre-commit`)
- `PRE_COMMIT_REMOTE_BRANCH`: the name of the remote branch to which we are
   pushing (for example `refs/heads/target-branch`)
- `PRE_COMMIT_LOCAL_BRANCH`: the name of the local branch that is being pushed
  to the remote (for example `HEAD`)

### pre-rebase

_new in 3.2.0_

[git pre-rebase docs](https://git-scm.com/docs/githooks#_pre_rebase)

`pre-rebase` is triggered before a rebase occurs.  A hook failure can cancel a
rebase from occurring.

`pre-rebase` hooks do not operate on files so they must be set as
`always_run: true` or they will always be skipped.

environment variables:
- `PRE_COMMIT_PRE_REBASE_UPSTREAM`: the first argument to the `pre-rebase` git hook
- `PRE_COMMIT_PRE_REBASE_BRANCH`: the second argument to the `pre-rebase` git hook.

### prepare-commit-msg

[git prepare-commit-msg docs](https://git-scm.com/docs/githooks#_prepare_commit_msg)

`prepare-commit-msg` hooks will be passed a single filename -- this file may
be empty or it could contain the commit message from `-m` or from other
templates.  `prepare-commit-msg` hooks can modify the contents of this file to
change what will be committed.  A hook may want to check for `GIT_EDITOR=:` as
this indicates that no editor will be launched.  If a hook exits nonzero, the
commit will be aborted.

environment variables:
- `PRE_COMMIT_COMMIT_MSG_SOURCE`: the second argument to the
  `prepare-commit-msg` git hook
- `PRE_COMMIT_COMMIT_OBJECT_NAME`: the third argument to the
  `prepare-commit-msg` git hook

## Passing arguments to hooks

Sometimes hooks require arguments to run correctly. You can pass static
arguments by specifying the [`args`](#config-args) property in your `.pre-commit-config.yaml`
as follows:

```yaml
-   repo: https://github.com/PyCQA/flake8
    rev: 4.0.1
    hooks:
    -   id: flake8
        args: [--max-line-length=131]
```

This will pass `--max-line-length=131` to `flake8`.

### Arguments pattern in hooks

If you are writing your own custom hook, your hook should expect to receive
the [`args`](#config-args) value and then a list of staged files.

For example, assuming a `.pre-commit-config.yaml`:

```yaml
-   repo: https://github.com/path/to/your/hook/repo
    rev: badf00ddeadbeef
    hooks:
    -   id: my-hook-script-id
        args: [--myarg1=1, --myarg1=2]
```

When you next run `pre-commit`, your script will be called:

```
path/to/script-or-system-exe --myarg1=1 --myarg1=2 dir/file1 dir/file2 file3
```

If the [`args`](#config-args) property is empty or not defined, your script will be called:

```
path/to/script-or-system-exe dir/file1 dir/file2 file3
```

When creating local hooks, there's no reason to put command arguments
into [`args`](#config-args) as there is nothing which can override them --
instead put your arguments directly in the hook [`entry`](#hooks-entry).

For example:

```yaml
-   repo: local
    hooks:
    -   id: check-requirements
        name: check requirements files
        language: system
        entry: python -m scripts.check_requirements --compare
        files: ^requirements.*\.txt$
```

## Repository local hooks

Repository-local hooks are useful when:

- The scripts are tightly coupled to the repository and it makes sense to
  distribute the hook scripts with the repository.
- Hooks require state that is only present in a built artifact of your
  repository (such as your app's virtualenv for pylint).
- The official repository for a linter doesn't have the pre-commit metadata.

You can configure repository-local hooks by specifying the [`repo`](#repos-repo) as the
sentinel `local`.

local hooks can use any language which supports [`additional_dependencies`](#config-additional_dependencies)
or `docker_image` / `fail` / `pygrep` / `script` / `system`.
This enables you to install things which previously would require a trivial
mirror repository.

A `local` hook must define [`id`](#hooks-id), [`name`](#hooks-name), [`language`](#hooks-language),
[`entry`](#hooks-entry), and [`files`](#hooks-files) / [`types`](#hooks-types)
as specified under [Creating new hooks](#new-hooks).

Here's an example configuration with a few `local` hooks:

```yaml
-   repo: local
    hooks:
    -   id: pylint
        name: pylint
        entry: pylint
        language: system
        types: [python]
        require_serial: true
    -   id: check-x
        name: Check X
        entry: ./bin/check-x.sh
        language: script
        files: \.x$
    -   id: scss-lint
        name: scss-lint
        entry: scss-lint
        language: ruby
        language_version: 2.1.5
        types: [scss]
        additional_dependencies: ['scss_lint:0.52.0']
```

## meta hooks

`pre-commit` provides several hooks which are useful for checking the
pre-commit configuration itself.  These can be enabled using `repo: meta`.

```yaml
-   repo: meta
    hooks:
    -   id: ...
```

The currently available `meta` hooks:

```table
=r=
    =c= [`check-hooks-apply`](_#meta-check_hooks_apply)
    =c= ensures that the configured hooks apply to at least one file in the
        repository.
=r=
    =c= [`check-useless-excludes`](_#meta-check_useless_excludes)
    =c= ensures that `exclude` directives apply to _any_ file in the
        repository.
=r=
    =c= [`identity`](_#meta-identity)
    =c= a simple hook which prints all arguments passed to it, useful for
        debugging.
```

## automatically enabling pre-commit on repositories

`pre-commit init-templatedir` can be used to set up a skeleton for `git`'s
`init.templateDir` option.  This means that any newly cloned repository will
automatically have the hooks set up without the need to run
`pre-commit install`.

To configure, first set `git`'s `init.templateDir` -- in this example I'm
using `~/.git-template` as my template directory.

```console
$ git config --global init.templateDir ~/.git-template
$ pre-commit init-templatedir ~/.git-template
pre-commit installed at /home/asottile/.git-template/hooks/pre-commit
```

Now whenever you clone a pre-commit enabled repo, the hooks will already be
set up!

```pre-commit
$ git clone -q git@github.com:asottile/pyupgrade
$ cd pyupgrade
$ git commit --allow-empty -m 'Hello world!'
Check docstring is first.............................(no files to check)Skipped
Check Yaml...........................................(no files to check)Skipped
Debug Statements (Python)............................(no files to check)Skipped
...
```

`init-templatedir` uses the `--allow-missing-config` option from
`pre-commit install` so repos without a config will be skipped:

```console
$ git init sample
Initialized empty Git repository in /tmp/sample/.git/
$ cd sample
$ git commit --allow-empty -m 'Initial commit'
`.pre-commit-config.yaml` config file not found. Skipping `pre-commit`.
[main (root-commit) d1b39c1] Initial commit
```

To still require opt-in, but prompt the user to set up pre-commit use a
template hook as follows (for example in `~/.git-template/hooks/pre-commit`).

```bash
#!/usr/bin/env bash
if [ -f .pre-commit-config.yaml ]; then
    echo 'pre-commit configuration detected, but `pre-commit install` was never run' 1>&2
    exit 1
fi
```

With this, a forgotten `pre-commit install` produces an error on commit:

```console
$ git clone -q https://github.com/asottile/pyupgrade
$ cd pyupgrade/
$ git commit -m 'foo'
pre-commit configuration detected, but `pre-commit install` was never run
```

## Filtering files with types

Filtering with `types` provides several advantages over traditional filtering
with `files`.

- no error-prone regular expressions
- files can be matched by their shebang (even when extensionless)
- symlinks / submodules can be easily ignored

`types` is specified per hook as an array of tags.  The tags are discovered
through a set of heuristics by the
[identify](https://github.com/pre-commit/identify) library.  `identify` was
chosen as it is a small portable pure python library.

Some of the common tags you'll find from identify:

- `file`
- `symlink`
- `directory` - in the context of pre-commit this will be a submodule
- `executable` - whether the file has the executable bit set
- `text` - whether the file looks like a text file
- `binary` - whether the file looks like a binary file
- [tags by extension / naming convention](https://github.com/pre-commit/identify/blob/main/identify/extensions.py)
- [tags by shebang (`#!`)](https://github.com/pre-commit/identify/blob/main/identify/interpreters.py)

To discover the type of any file on disk, you can use `identify`'s cli:

```console
$ identify-cli setup.py
["file", "non-executable", "python", "text"]
$ identify-cli some-random-file
["file", "non-executable", "text"]
$ identify-cli --filename-only some-random-file; echo $?
1
```

If a file extension you use is not supported, please
[submit a pull request](https://github.com/pre-commit/identify)!

`types`, `types_or`, and `files` are evaluated together with `AND` when
filtering.  Tags within `types` are also evaluated using `AND`.

_new in 2.9.0_: Tags within `types_or` are evaluated using `OR`.

For example:

```yaml
    files: ^foo/
    types: [file, python]
```

will match a file `foo/1.py` but will not match `setup.py`.

Another example:

```yaml
    files: ^foo/
    types_or: [javascript, jsx, ts, tsx]
```

will match any of `foo/bar.js` / `foo/bar.jsx` / `foo/bar.ts` / `foo/bar.tsx`
but not `baz.js`.

If you want to match a file path that isn't included in a `type` when using an
existing hook you'll need to revert back to `files` only matching by overriding
the `types` setting.  Here's an example of using `check-json` against non-json
files:

```yaml
    -   id: check-json
        types: [file]  # override `types: [json]`
        files: \.(json|myext)$
```

Files can also be matched by shebang.  With `types: python`, an `exe` starting
with `#!/usr/bin/env python3` will also be matched.

As with `files` and `exclude`, you can also exclude types if necessary using
`exclude_types`.

## Regular expressions

The patterns for `files` and `exclude` are python
[regular expressions](https://docs.python.org/3/library/re.html#regular-expression-syntax)
and are matched with [`re.search`](https://docs.python.org/3/library/re.html#re.search).

As such, you can use any of the features that python regexes support.

If you find that your regular expression is becoming unwieldy due to a long
list of excluded / included things, you may find a
[verbose](https://docs.python.org/3/library/re.html#re.VERBOSE) regular
expression useful.  One can enable this with yaml's multiline literals and
the `(?x)` regex flag.

```yaml
# ...
    -   id: my-hook
        exclude: |
            (?x)^(
                path/to/file1.py|
                path/to/file2.py|
                path/to/file3.py
            )$
```

## Overriding language version

Sometimes you only want to run the hooks on a specific version of the
language. For each language, they default to using the system installed
language (So for example if I’m running `python3.7` and a hook specifies
`python`, pre-commit will run the hook using `python3.7`). Sometimes you
don’t want the default system installed version so you can override this on a
per-hook basis by setting the [`language_version`](#config-language_version).

```yaml
-   repo: https://github.com/pre-commit/mirrors-scss-lint
    rev: v0.54.0
    hooks:
    -   id: scss-lint
        language_version: 2.1.5
```

This tells pre-commit to use ruby `2.1.5` to run the `scss-lint` hook.

Valid values for specific languages are listed below:
- python: Whatever system installed python interpreters you have. The value of
  this argument is passed as the `-p` to `virtualenv`.
    - on windows the
      [pep394](https://www.python.org/dev/peps/pep-0394/) name will be
      translated into a py launcher call for portability.  So continue to use
      names like `python3` (`py -3`) or `python3.6` (`py -3.6`) even on
      windows.
- node: See [nodeenv](https://github.com/ekalinin/nodeenv#advanced).
- ruby: See [ruby-build](https://github.com/sstephenson/ruby-build/tree/master/share/ruby-build).
- _new in 2.21.0_ rust: `language_version` is passed to `rustup`
- _new in 3.0.0_ golang: use the versions on [go.dev/dl](https://go.dev/dl/) such as `1.19.5`

you can set [`default_language_version`](#top_level-default_language_version)
at the [top level](#pre-commit-configyaml---top-level) in your configuration to
control the default versions across all hooks of a language.

```yaml
default_language_version:
    # force all unspecified python hooks to run python3
    python: python3
    # force all unspecified ruby hooks to run ruby 2.1.5
    ruby: 2.1.5
```

## badging your repository

you can add a badge to your repository to show your contributors / users that
you use pre-commit!

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)

- Markdown:

  ```md#copyable
  [![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
  ```

- HTML:

  ```html#copyable
  <a href="https://github.com/pre-commit/pre-commit"><img src="https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit" alt="pre-commit" style="max-width:100%;"></a>
  ```

- reStructuredText:

  ```rst#copyable
  .. image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit
     :target: https://github.com/pre-commit/pre-commit
     :alt: pre-commit
  ```

- AsciiDoc:

  ```#copyable
  image:https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit[pre-commit, link=https://github.com/pre-commit/pre-commit]
  ```

## Usage in continuous integration

pre-commit can also be used as a tool for continuous integration.  For
instance, adding `pre-commit run --all-files` as a CI step will ensure
everything stays in tip-top shape.  To check only files which have changed,
which may be faster, use something like
`pre-commit run --from-ref origin/HEAD --to-ref HEAD`

## Managing CI Caches

`pre-commit` by default places its repository store in `~/.cache/pre-commit`
-- this can be configured in two ways:

- `PRE_COMMIT_HOME`: if set, pre-commit will use that location instead.
- `XDG_CACHE_HOME`: if set, pre-commit will use `$XDG_CACHE_HOME/pre-commit`
  following the [XDG Base Directory Specification].

[XDG Base Directory Specification]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

### pre-commit.ci example

no additional configuration is needed to run in [pre-commit.ci]!

pre-commit.ci also has the following benefits:

- it's faster than other free CI solutions
- it will autofix pull requests
- it will periodically autoupdate your configuration

[![pre-commit.ci speed comparison](https://raw.githubusercontent.com/pre-commit-ci-demo/demo/main/img/2020-12-15_noop.svg)](https://github.com/pre-commit-ci-demo/demo#results)

[pre-commit.ci]: https://pre-commit.ci

### appveyor example

```yaml
cache:
- '%USERPROFILE%\.cache\pre-commit'
```

### azure pipelines example

note: azure pipelines uses immutable caches so the python version and
`.pre-commit-config.yaml` hash must be included in the cache key.  for a
repository template, see [asottile@job--pre-commit.yml].

[asottile@job--pre-commit.yml]: https://github.com/asottile/azure-pipeline-templates/blob/main/job--pre-commit.yml

```yaml
jobs:
- job: precommit

  # ...

  variables:
    PRE_COMMIT_HOME: $(Pipeline.Workspace)/pre-commit-cache

  steps:

  # ...

  - script: echo "##vso[task.setvariable variable=PY]$(python -VV)"
  - task: CacheBeta@0
    inputs:
      key: pre-commit | .pre-commit-config.yaml | "$(PY)"
      path: $(PRE_COMMIT_HOME)
```

### circleci example

like [azure pipelines](#azure-pipelines-example), circleci also uses immutable
caches:

```yaml
  steps:
  - run:
    command: |
      cp .pre-commit-config.yaml pre-commit-cache-key.txt
      python --version --version >> pre-commit-cache-key.txt
  - restore_cache:
    keys:
    - v1-pc-cache-{{ checksum "pre-commit-cache-key.txt" }}

  # ...

  - save_cache:
    key: v1-pc-cache-{{ checksum "pre-commit-cache-key.txt" }}
    paths:
      - ~/.cache/pre-commit
```

(source: [@chriselion])

[@chriselion]: https://github.com/Unity-Technologies/ml-agents/pull/3094/files#diff-1d37e48f9ceff6d8030570cd36286a61

### github actions example

**see the [official pre-commit github action]**

[official pre-commit github action]: https://github.com/pre-commit/action

like [azure pipelines](#azure-pipelines-example), github actions also uses
immutable caches:

```yaml
    - name: set PY
      run: echo "PY=$(python -VV | sha256sum | cut -d' ' -f1)" >> $GITHUB_ENV
    - uses: actions/cache@v3
      with:
        path: ~/.cache/pre-commit
        key: pre-commit|${{ env.PY }}|${{ hashFiles('.pre-commit-config.yaml') }}
```

### gitlab CI example

See the [Gitlab caching best practices](https://docs.gitlab.com/ee/ci/caching/#good-caching-practices) to fine tune the cache scope.

```yaml
my_job:
  variables:
    PRE_COMMIT_HOME: ${CI_PROJECT_DIR}/.cache/pre-commit
  cache:
    paths:
      - ${PRE_COMMIT_HOME}
```

pre-commit's cache requires to be served from a constant location between the different builds. This isn't the default when using k8s runners
on GitLab. In case you face the error `InvalidManifestError`, set `builds_dir` to something static e.g `builds_dir = "/builds"` in your `[[runner]]` config

### travis-ci example

```yaml
cache:
  directories:
  - $HOME/.cache/pre-commit
```

## Usage with tox

[tox](https://tox.readthedocs.io/) is useful for configuring test / CI tools
such as pre-commit.  One feature of `tox>=2` is it will clear environment
variables such that tests are more reproducible.  Under some conditions,
pre-commit requires a few environment variables and so they must be
allowed to be passed through.

When cloning repos over ssh (`repo: git@github.com:...`), `git` requires the
`SSH_AUTH_SOCK` variable and will otherwise fail:

```pre-commit
[INFO] Initializing environment for git@github.com:pre-commit/pre-commit-hooks.
An unexpected error has occurred: CalledProcessError: command: ('/usr/bin/git', 'fetch', 'origin', '--tags')
return code: 128
expected return code: 0
stdout: (none)
stderr:
    git@github.com: Permission denied (publickey).
    fatal: Could not read from remote repository.

    Please make sure you have the correct access rights
    and the repository exists.

Check the log at /home/asottile/.cache/pre-commit/pre-commit.log
```

Add the following to your tox testenv:

```ini
[testenv]
passenv = SSH_AUTH_SOCK
```

Likewise, when cloning repos over http / https
(`repo: https://github.com:...`), you might be working behind a corporate
http(s) proxy server, in which case `git` requires the `http_proxy`,
`https_proxy` and `no_proxy` variables to be set, or the clone may fail:

```ini
[testenv]
passenv = http_proxy https_proxy no_proxy
```

## Using the latest version for a repository

`pre-commit` configuration aims to give a repeatable and fast experience and
therefore intentionally doesn't provide facilities for "unpinned latest
version" for hook repositories.

Instead, `pre-commit` provides tools to make it easy to upgrade to the
latest versions with [`pre-commit autoupdate`](#pre-commit-autoupdate).  If
you need the absolute latest version of a hook (instead of the latest tagged
version), pass the `--bleeding-edge` parameter to `autoupdate`.

`pre-commit` assumes that the value of [`rev`](#repos-rev) is an immutable ref (such as a
tag or SHA) and will cache based on that.  Using a branch name (or `HEAD`) for
the value of [`rev`](#repos-rev) is not supported and will only represent the state of
that mutable ref at the time of hook installation (and will *NOT* update
automatically).
