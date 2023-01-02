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

## pre-commit during commits

Running hooks on unstaged changes can lead to both false-positives and
false-negatives during committing.  pre-commit only runs on the staged
contents of files by temporarily saving the contents of your files at commit
time and stashing the unstaged changes while running hooks.

_new in 2.4.0_: pre-commit can be used to manage [post-commit] hooks.

To use `post-commit` hooks with pre-commit, run:

```console
$ pre-commit install --hook-type post-commit
pre-commit installed at .git/hooks/post-commit
```

`post-commit` hooks fire after the commit succeeds and cannot be used to
prevent the commit from happening (use `pre-commit` instead).  Since
`post-commit` does not operate on files, any hooks must set `always_run`:

```yaml
-   repo: local
    hooks:
    -   id: post-commit-local
        name: post commit
        always_run: true
        stages: [post-commit]
        # ...
```

[post-commit]: https://git-scm.com/docs/githooks#_post_commit

## pre-commit during merges

The biggest gripe we’ve had in the past with pre-commit hooks was during merge
conflict resolution.  When working on very large projects a merge often
results in hundreds of committed files. I shouldn’t need to run hooks on all
of these files that I didn’t even touch!  This often led to running commit
with `--no-verify` and allowed introduction of real bugs that hooks could have
caught.

pre-commit solves this by only running hooks on files that conflict or were
manually edited during conflict resolution.  This also includes files which
were automatically merged by git.  Git isn't perfect and this can often catch
implicit conflicts (such as with removed python imports).

_new in 2.11.0_ pre-commit can be used to manage [post-merge] hooks.

To use `post-merge` hooks with pre-commit, run:

```console
$ pre-commit install --hook-type post-merge
pre-commit installed at .git/hooks/post-merge
```

The hook fires after a successful `git merge`.

Environment variables:
- `PRE_COMMIT_IS_SQUASH_MERGE`: whether it is a squash merge.

[post-merge]: https://git-scm.com/docs/githooks#_post_merge

## pre-commit during clean merges

_new in 1.21.0_ pre-commit can be used to manage [pre-merge-commit] hooks.

To use `pre-merge-commit` hooks with pre-commit, run:

```console
$ pre-commit install --hook-type pre-merge-commit
pre-commit installed at .git/hooks/pre-merge-commit
```

The hook fires after a merge succeeds but before the merge commit is created.

Note that you need to be using at least git 2.24 which added support for the
pre-merge-commit hook.

[pre-merge-commit]: https://git-scm.com/docs/githooks#_pre_merge_commit

## pre-commit during push

To use `pre-push` hooks with pre-commit, run:

```console
$ pre-commit install --hook-type pre-push
pre-commit installed at .git/hooks/pre-push
```

Environment variables:
- `PRE_COMMIT_FROM_REF`: the remote revision that is being pushed to.
    - _new in 2.2.0_ prior to 2.2.0 the variable was `PRE_COMMIT_SOURCE`.
- `PRE_COMMIT_TO_REF`: the local revision that is being pushed to the remote.
    - _new in 2.2.0_ prior to 2.2.0 the variable was `PRE_COMMIT_ORIGIN`.
- `PRE_COMMIT_REMOTE_NAME`: _new in 2.0.0_ which remote is being pushed to
  (for example `origin`)
- `PRE_COMMIT_REMOTE_URL`: _new in 2.0.0_ the url of the remote that is being
  pushed to (for example `git@github.com:pre-commit/pre-commit`).
- `PRE_COMMIT_REMOTE_BRANCH`: _new in 2.10.0_ the name of the remote branch to
  which we are pushing (for example `refs/heads/target-branch`)
- `PRE_COMMIT_LOCAL_BRANCH`: _new in 2.14.0_ the name of the local branch that
  is being pushed to the remote (for example `HEAD`)

[pre-push]: https://git-scm.com/docs/githooks#_pre_push

## pre-commit for commit messages

pre-commit can be used to manage [commit-msg] hooks.

To use `commit-msg` hooks with pre-commit, run:

```console
$ pre-commit install --hook-type commit-msg
pre-commit installed at .git/hooks/commit-msg
```

`commit-msg` hooks can be configured by setting `stages: [commit-msg]`.
`commit-msg` hooks will be passed a single filename -- this file contains the
current contents of the commit message which can be validated.  If a hook
exits nonzero, the commit will be aborted.

_new in 1.16.0_: pre-commit can be used to manage [prepare-commit-msg] hooks.

To use `prepare-commit-msg` hooks with pre-commit, run:

```console
$ pre-commit install --hook-type prepare-commit-msg
pre-commit installed at .git/hooks/prepare-commit-msg
```

`prepare-commit-msg` hooks can be used to create dynamic templates for commit
messages. `prepare-commit-msg` hooks can be configured by setting
`stages: [prepare-commit-msg]`. `prepare-commit-msg` hooks will be passed a
single filename -- this file contains any initial commit message (e.g. from
`git commit -m "..."` or a template) and can be modified by the hook before
the editor is shown. A hook may want to check for `GIT_EDITOR=:` as this
indicates that no editor will be launched. If a hook exits nonzero,
the commit will be aborted.

[commit-msg]: https://git-scm.com/docs/githooks#_commit_msg
[prepare-commit-msg]: https://git-scm.com/docs/githooks#_prepare_commit_msg


## pre-commit for switching branches
_new in 2.2.0_: pre-commit can be used to manage [post-checkout] hooks.

To use `post-checkout` hooks with pre-commit, run:

```console
$ pre-commit install --hook-type post-checkout
pre-commit installed at .git/hooks/post-checkout
```

`post-checkout` hooks can be used to perform repository validity checks,
auto-display differences from the previous HEAD if different,
or set working dir metadata properties. Since `post-checkout` doesn't operate
on files, any hooks must set `always_run`:

```yaml
-   repo: local
    hooks:
    -   id: post-checkout-local
        name: Post checkout
        always_run: true
        stages: [post-checkout]
        # ...
```

`post-checkout` hooks have three environment variables they can check to
do their work: `$PRE_COMMIT_FROM_REF`, `$PRE_COMMIT_TO_REF`,
and `$PRE_COMMIT_CHECKOUT_TYPE`. These correspond to the first, second,
and third arguments (respectively) that are normally passed to a regular
post-checkout hook from Git.

[post-checkout]: https://git-scm.com/docs/githooks#_post_checkout

## pre-commit for rewriting

_new in 2.15.0_: pre-commit can be used to manage [post-rewrite] hooks.

To use `post-rewrite` hooks with pre-commit, run:

```console
$ pre-commit install --hook-type post-rewrite
pre-commit installed at .git/hooks/post-rewrite
```

`post-rewrite` is triggered after git commands which modify history such as
`git commit --amend` and `git rebase`.

since `post-rewrite` does not operate on any files, you must set
[`always_run: true`](#hooks-always_run).

`git` tells the `post-rewrite` hook which command triggered the rewrite.
`pre-commit` exposes this as `$PRE_COMMIT_REWRITE_COMMAND`.

[post-rewrite]: https://git-scm.com/docs/githooks#_post_rewrite

## Confining hooks to run at certain stages

Since the [`default_stages`](#top_level-default_stages) top level configuration property of the
`.pre-commit-config.yaml` file is set to all stages by default, when installing
hooks using the `-t`/`--hook-type` option (see [pre-commit
install [options]](#pre-commit-install)), all hooks will be installed by default
to run at the stage defined through that option. For instance,
`pre-commit install --hook-type pre-push` will install by default all hooks
to run at the `push` stage.

Hooks can however be confined to a stage by setting the [`stages`](#config-stages)
property in your `.pre-commit-config.yaml`, and the corresponding [`stages`](#hook-stages)
property in the hook's `.pre-commit-hooks.yaml` definition.  The `stages` properties
are arrays and can contain any of `commit`, `merge-commit`, `push`, `prepare-commit-msg`,
`commit-msg`, `post-checkout`, `post-commit`, `post-merge`, `post-rewrite`, and `manual`.
It is useful to provide an appropriate set of stages out of the box in
`.pre-commit-hooks.yaml` hook definitions to avoid unnecessary runs of hooks in
stages where they do not and can not do anything useful.  For example, a
reasonable setting for code formatter and the like hooks would be
`stages: [commit, merge-commit, push, manual]`, and one for hooks that operate
on commit messages could be `stages: [commit-msg, manual]`.

If you do not want to have hooks installed by default on the stage passed
during a `pre-commit install --hook-type ...`, please set the [`default_stages`](#top_level-default_stages)
top level configuration property to the desired stages, also as an array.

_new in 1.8.0_: An additional `manual` stage is available for one off execution
that won't run in any hook context.  This special stage is useful for taking
advantage of `pre-commit`'s cross-platform / cross-language package management
without running it on every commit.  Hooks confined to `stages: [manual]` can
be executed by running `pre-commit run --hook-stage manual [hookid]`.

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
        files: ^requirements.*.txt$
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

_new in 1.4.0_

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
        _new in 1.4.0_.
=r=
    =c= [`check-useless-excludes`](_#meta-check_useless_excludes)
    =c= ensures that `exclude` directives apply to _any_ file in the
        repository.
        _new in 1.4.0_.
=r=
    =c= [`identity`](_#meta-identity)
    =c= a simple hook which prints all arguments passed to it, useful for
        debugging.
        _new in 1.14.0_.
```

## automatically enabling pre-commit on repositories

_new in 1.18.0_

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
    - _new in 1.4.3_: on windows the
      [pep394](https://www.python.org/dev/peps/pep-0394/) name will be
      translated into a py launcher call for portability.  So continue to use
      names like `python3` (`py -3`) or `python3.6` (`py -3.6`) even on
      windows.
- node: See [nodeenv](https://github.com/ekalinin/nodeenv#advanced).
- ruby: See [ruby-build](https://github.com/sstephenson/ruby-build/tree/master/share/ruby-build).
- _new in 2.21.0_ rust: `language_version` is passed to `rustup`

_new in 1.14.0_: you can now set [`default_language_version`](#top_level-default_language_version)
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
    - uses: actions/cache@v1
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
