## -*- coding: utf-8 -*-
<%!
from template_lib import md
%>
<%inherit file="base.mako" />
<div class="row">
    <div class="col-sm-3 hidden-xs pc-sidebar">
        <ul class="nav nav-pills nav-stacked pc-sidenav" data-spy="affix" data-offset-top="400">
            <li class="active"><a href="#intro">Introduction</a></li>
            <li><a href="#install">Installation</a></li>
            <li><a href="#plugins">Adding plugins</a></li>
            <li><a href="#usage">Usage</a></li>
            <li><a href="#new-hooks">Creating new hooks</a></li>
            <li><a href="#cli">Command line interface</a></li>
            <li><a href="#advanced">Advanced features</a></li>
            <li><a href="#contributing">Contributing</a></li>
        </ul>
    </div>
    <div class="col-sm-9">
        <div id="intro">
            <div class="page-header"><h1>Introduction</h1></div>
${md('''
Git hook scripts are useful for identifying simple issues before submission to
code review.  We run our hooks on every commit to automatically point out
issues in code such as missing semicolons, trailing whitespace, and debug
statements.  By pointing these issues out before code review, this allows a
code reviewer to focus on the architecture of a change while not wasting time
with trivial style nitpicks.

As we created more libraries and projects we recognized that sharing our
pre-commit hooks across projects is painful. We copied and pasted unwieldy
bash scripts from project to project and had to manually change the hooks to
work for different project structures.

We believe that you should always use the best industry standard linters.
Some of the best linters are written in languages that you do not use in your
project or have installed on your machine. For example scss-lint is a linter
for SCSS written in Ruby. If you’re writing a project in node you should be
able to use scss-lint as a pre-commit hook without adding a Gemfile to your
project or understanding how to get scss-lint installed.

We built pre-commit to solve our hook issues. It is a multi-language package
manager for pre-commit hooks. You specify a list of hooks you want and
pre-commit manages the installation and execution of any hook written in any
language before every commit. pre-commit is specifically designed to not
require root access. If one of your developers doesn’t have node installed
but modifies a JavaScript file, pre-commit automatically handles downloading
and building node to run eslint without root.
''')}

        <div id="install">
            <div class="page-header"><h1>Installation</h1></div>
${md('''
Before you can run hooks, you need to have the pre-commit package manager
installed.

Using pip:

```
pip install pre-commit
```

Non Administrative Installation:

- _to upgrade: run again, to uninstall: pass `uninstall` to python_
- _does not work on platforms without symlink support (windows)_


```
curl https://raw.githubusercontent.com/pre-commit/pre-commit.github.io/real_master/install-local.py | python
```

System Level Install:

```
curl https://bootstrap.pypa.io/get-pip.py | sudo python - pre-commit
```

In a python project, add the following to your requirements.txt (or
requirements-dev.txt):

```
pre-commit
```

Using [homebrew](http://brew.sh):

```
brew install pre-commit
```
''')}
        </div>

        <div id="plugins">
            <div class="page-header">
                <h1>Adding pre-commit plugins to your project</h1>
            </div>
${md('''
Once you have pre-commit installed, adding pre-commit plugins to your project
is done with the `.pre-commit-config.yaml` configuration file.

Add a file called `.pre-commit-config.yaml` to the root of your project. The
pre-commit config file describes what repositories and hooks are installed.

## .pre-commit-config.yaml - top level

_new in 1.0.0_ The default configuration file top-level was changed from a
list to a map.  If you're using an old version of pre-commit, the top-level
list is the same as the value of [`repos`](#pre-commit-configyaml---repos).
If you'd like to migrate to the new configuration format, run
[`pre-commit migrate-config`](#pre-commit-migrate-config) to automatically
migrate your configuration.

```table
=r=
    =c= `exclude`
    =c= (optional: default `^$`) global file exclude pattern.  _new in 1.1.0_.
=r=
    =c= `fail_fast`
    =c= (optional: default `false`) set to `true` to have pre-commit stop
        running hooks after the first failure.  _new in 1.1.0_.
=r=
    =c= `repos`
    =c= A list of [repository mappings](#pre-commit-configyaml---repos).
```

A sample top-level with all defaults present:

```yaml
exclude: '^$'
fail_fast: false
repos:
-   ...
```

## .pre-commit-config.yaml - repos

The repository mapping tells pre-commit where to get the code for the hook
from.

```table
=r=
    =c= `repo`
    =c= the repository url to `git clone` from
=r=
    =c= `sha`
    =c= the revision or tag to clone at
=r=
    =c= `hooks`
    =c= A list of [hook mappings](#pre-commit-configyaml---hooks).
```

A sample repository with all defaults present:

```yaml
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    sha: v0.9.4
    hooks:
    -   ...
```

## .pre-commit-config.yaml - hooks

The hook mapping configures which hook from the repository is used and allows
for customization.  All optional keys will receive their default from the
repository's configuration.

```table
=r=
    =c= `id`
    =c= which hook from the repository to use.
=r=
    =c= `language_version`
    =c= (optional) override the language version for the
        hook.  See [Overriding Language Version](#overriding-language-version).
=r=
    =c= `files`
    =c= (optional) override the default pattern for files to run on.
=r=
    =c= `exclude`
    =c= (optional) file exclude pattern.
=r=
    =c= `types`
    =c= (optional) override the default file types to run on.  See
        [Filtering files with types](#filtering-files-with-types).
        _new in 0.15.0_.
=r=
    =c= `exclude_types`
    =c= (optional) file types to exclude.  _new in 0.15.0_.
=r=
    =c= `args`
    =c= (optional) list of additional parameters to pass to the hook.
=r=
    =c= `stages`
    =c= (optional) configes the hook to the `commit`, `push`, or `commit-msg`
        stage.  See
        [Confining hooks to run at certain stages](#confining-hooks-to-run-at-certain-stages).
=r=
    =c= `additional_dependencies`
    =c= (optional) a list of dependencies that will be installed in the
        environment where this hook gets run.  One useful application is to
        install plugins for hooks such as `eslint`.  _new in 0.6.6_.
=r=
    =c= `always_run`
    =c= (optional) if `true`, this hook will run even if there are no matching
        files.  _new in 0.7.2_.
```

One example of a complete configuration:

```yaml
repos:
-   repo: git://github.com/pre-commit/pre-commit-hooks
    sha: v0.9.1
    hooks:
    -   id: trailing-whitespace
```

This configuration says to download the pre-commit-hooks project and run its
trailing-whitespace hook.

## Updating hooks automatically

You can update your hooks to the latest version automatically by running
`pre-commit autoupdate`.  This will bring the hooks to the latest sha on the
master branch.
''')}
        </div>

        <div id="usage">
            <div class="page-header"><h1>Usage</h1></div>
${md('''
Run `pre-commit install` to install pre-commit into your git hooks. pre-commit
will now run on every commit. Every time you clone a project using pre-commit
running `pre-commit install` should always be the first thing you do.

If you want to manually run all pre-commit hooks on a repository, run
`pre-commit run --all-files`. To run individual hooks use
`pre-commit run <hook_id>`.

The first time pre-commit runs on a file it will automatically download,
install, and run the hook. Note that running a hook for the first time may be
slow. For example: If the machine does not have node installed, pre-commit
will download and build a copy of node.
''')}
        </div>

        <div id="new-hooks">
            <div class="page-header"><h1>Creating new hooks</h1></div>
${md('''
pre-commit currently supports hooks written in
[many languages](#supported-languages). As long as your git repo is an
installable package (gem, npm, pypi, etc.) or exposes an executable, it can be
used with pre-commit. Each git repo can support as many languages/hooks as you
want.

The hook must exit nonzero on failure or modify files in the working directory
_(since 0.6.3)_.

A git repo containing pre-commit plugins must contain a .pre-commit-hooks.yaml
file that tells pre-commit:

```table
=r=
    =c= `id`
    =c= the id of the hook - used in pre-commit-config.yaml.
=r=
    =c= `name`
    =c= the name of the hook - shown during hook execution.
=r=
    =c= `entry`
    =c= the entry point - the executable to run.  `entry` can also contain
        arguments that will not be overridden such as `entry: autopep8 -i`.
=r=
    =c= `language`
    =c= the language of the hook - tells pre-commit how to install the hook.
=r=
    =c= `files`
    =c= (optional: default `''`) the pattern of files to run on.
        _new in 0.15.0_: now optional.
=r=
    =c= `exclude`
    =c= (optional: default `^$`)  exclude files that were matched by `files`.
=r=
    =c= `types`
    =c= (optional: default `[file]`)  list of file types to run on.  See
        [Filtering files with types](#filtering-files-with-types).
        _new in 0.15.0_.
=r=
    =c= `exclude_types`
    =c= (optional: default `[]`)  exclude files that were matched by `types`.
        _new in 0.15.0_.
=r=
    =c= `always_run`
    =c= (optional: default `false`) if `true` this hook will run even if there
        are no matching files. _new in 0.7.2_.
=r=
    =c= `pass_filenames`
    =c= (optional: default `true`) if `true` this hook must take filenames as
        positional arguments. _new in 0.14.0_.
=r=
    =c= `description`
    =c= (optional: default `''`) description of the hook.  used for metadata
        purposes only.
=r=
    =c= `language_version`
    =c= (optional: default `default`) see
        [Overriding language version](#overriding-language-version).
=r=
    =c= `minimum_pre_commit_version`
    =c= (optional: default `0.0.0`) allows one to indicate a minimum
        compatible pre-commit version. _new in 0.6.7_.
```

For example:

```yaml
-   id: trailing-whitespace
    name: Trim Trailing Whitespace
    description: This hook trims trailing whitespace.
    entry: trailing-whitespace-fixer
    language: python
    types: [text]
```

_new in 0.12.0_ Prior to 0.12.0 the file was `hooks.yaml`
(now `.pre-commit-hooks.yaml`).  For backwards compatibility it is suggested
to provide both files or suggest users use `pre-commit>=0.12.0`.

## Supported languages

- [docker](#docker)
- [docker_image](#docker_image)
- [golang](#golang)
- [node](#node)
- [python](#python)
- [ruby](#ruby)
- [swift](#swift)
- [pcre](#pcre)
- [pygrep](#pygrep)
- [script](#script)
- [system](#system)

### docker

_new in 0.10.0_

The hook repository must have a `Dockerfile`.  It will be installed via
`docker build .`.

Running Docker hooks requires a running Docker engine on your host.  For
configuring Docker hooks, your `entry` should correspond to an executable
inside the Docker container, and will be used to override the default container
entrypoint. Your Docker `CMD` will not run when pre-commit passes a file list
as arguments to the run container  command. Docker allows you to use any
language that's not supported by pre-commit as a builtin.

__Support:__ docker hooks are known to work on any system which has a working
`docker` executable.  It has been tested on linux and macOS.  Hooks that are
run via `boot2docker` are known to be unable to make modifications to files.

See [this repository](https://github.com/pre-commit/pre-commit-docker-flake8)
for an example Docker-based hook.

### docker_image

_new in 0.18.0_

A more lightweight approach to `docker` hooks.  The `docker_image`
"language" uses existing docker images to provide hook executables.

`docker_image` hooks can be conviently configured as [local](#repository-local)
hooks.

The `entry` specifies the docker tag to use.  If an image has an
`ENTRYPOINT` defined, nothing special is needed to hook up the executable.
If the container does not specify an `ENTRYPOINT` or you want to change the
entrypoint you can specify it as well in your `entry`.

For example:

```yaml
-   id: dockerfile-provides-entrypoint
    name: ...
    language: docker_image
    entry: my.registry.example.com/docker-image-1:latest
-   id: dockerfile-no-entrypoint-1
    name: ...
    language: docker_image
    entry: --entrypoint my-exe my.registry.example.com/docker-image-2:latest
# Alternative equivalent solution
-   id: dockerfile-no-entrypoint-2
    name: ...
    language: docker_image
    entry: my.registry.example.com/docker-image-3:latest my-exe
```

### golang

_new in 0.12.0_

The hook repository must contain go source code.  It will be installed via
`go get ./...`.  pre-commit will create an isolated `GOPATH` for each hook and
the `entry` should match an executable which will get installed into the
`GOPATH`'s `bin` directory.

__Support:__ golang hooks are known to work on any system which has go
installed.  It has been tested on linux, macOS, and windows.

### node

The hook repository must have a `package.json`.  It will be installed via
`npm install .`.  The installed package will provide an executable that will
match the `entry` – usually through `bin` in package.json.

__Support:__ node hooks work without any system-level dependencies.  It has
been tested on linux and macOS and _may_ work under cygwin.

### python

The hook repository must have a `setup.py`.  It will be installed via
`pip install .`.  The installed package will provide an executable that will
match the `entry` – usually through `console_scripts` or `scripts` in setup.py.

__Support:__ python hooks work without any system-level depedendencies.  It
has been tested on linux, macOS, windows, and cygwin.

### ruby

The hook repository must have a `*.gemspec`.  It will be installed via
`gem build *.gemspec && gem install *.gem`.  The installed package will
produce an executable that will match the `entry` – usually through
`exectuables` in your gemspec.

__Support:__ ruby hooks work without any system-level dependencies.  It has
been tested on linux and macOS and _may_ work under cygwin.

### swift

_new in 0.11.0_

The hook repository must have a `Package.swift`.  It will be installed via
`swift build -c release`.  The `entry` should match an executable created by
building the repository.

__Support:__ swift hooks are known to work on any system which has swift
installed.  It has been tested on linux and macOS.

### pcre

_**deprecated**_: the pcre language will be removed in a later version.  Use
[pygrep](#pygrep) hooks instead (usually a drop-in replacement).

"Perl Compatible Regular Expressions" – pcre hooks are a quick way to write a
simple hook which prevents commits by file matching.  Specify the regex as the
`entry`.

macos does not ship with a functioning `grep -P` so you'll need
`brew install grep` for pcre hooks to function.

__Support:__ pcre hooks work on any system which has a functioning
`grep -P` (or in the case of macOS: `ggrep -P`).  It has been tested on linux,
macOS, windows, and cygwin.

### pygrep

_new in 1.2.0_

A cross-platform python implementation of `grep` – pygrep hooks are a quick
way to write a simple hook which prevents commits by file matching.  Specify
the regex as the `entry`.  The `entry` may be any python
[regular expression](#regular-expressions).  For case insensitive regexes you
can apply the `(?i)` flag as the start of your entry, or use `args: [-i]`.

__Support:__ pygrep hooks are supported on all platforms which pre-commit runs
on.

### script

Script hooks provide a way to write simple scripts which validate files. The
`entry` should be a path relative to the root of the hook repository.

This hook type will not be given a virtual environment to work with – if it
needs additional dependencies the consumer must install them manually.

__Support:__ the support of script hooks depend on the scripts themselves.

### system

System hooks provide a way to write hooks for system-level executables which
don't have a supported language above (or have special environment
requirements that don't allow them to run in isolation such as pylint).

This hook type will not be given a virtual environment to work with – if it
needs additional dependencies the consumer must install them manually.

__Support:__ the support of system hooks depend on the executables.

## Developing hooks interactively

Since the `repo` property of `.pre-commit-config.yaml` can refer to anything
that `git clone ...` understands, it's often useful to point it at a local
directory while developing hooks.

[`pre-commit try-repo`](#pre-commit-try-repo) streamlines this process by
enabling a quick way to try out a repository.  Here's how one might work
interactively:

```console
~/work/hook-repo $ git checkout origin/master -b feature

# ... make some changes

~/work/hook-repo $ # A commit is needed so `pre-commit` can clone
~/work/hook-repo $ git commit -m "Add new hook: foo"

# In another terminal or tab

~/work/other-repo $ pre-commit try-repo ../hook-repo foo --verbose --all-files
===============================================================================
Using config:
===============================================================================
repos:
-   repo: ../hook-repo
    sha: 84f01ac09fcd8610824f9626a590b83cfae9bcbd
    hooks:
    -   id: foo
===============================================================================
[INFO] Initializing environment for ../hook-repo.
[foo] Foo................................................................Passed
hookid: foo

Hello from foo hook!

```
''')}
        </div>

        <div id="cli">
            <div class="page-header"><h1>Command line interface</h1></div>

${md('''
All pre-commit commands take the following options:

- `--color {auto,always,never}`: whether to use color in output.
  Defaults to `auto`.
- `-c CONFIG`, `--config CONFIG`: path to alternate config file
- `-h`, `--help`: show help and available options.

## pre-commit autoupdate [options] [](#pre-commit-autoupdate)

Auto-update pre-commit config to the latest repos' versions.

Options:

- `--bleeding-edge`: update to the bleeding edge of `master` instead of the
  latest tagged version (the default behaviour).
- `--repo REPO`: _new in 1.4.1_ Only update this repository.

## pre-commit clean [options] [](#pre-commit-clean)

Clean out cached pre-commit files.

Options: (no additional options)

## pre-commit install [options] [](#pre-commit-install)

Install the pre-commit script.

Options:

- `-f`, `--overwrite`: overwrite existing hooks / remove migration mode.
- `--install-hooks`: also install hook environments for all available hooks.
- `-t {pre-commit,pre-push,commit-msg}`,
  `--hook-type {pre-commit,pre-push,commit-msg}`: which hook type to install.
- `--allow-missing-config`: whether to allow the installed hook scripts to
  permit a missing configuration file.

Some example useful invocations:

- `pre-commit install`: default install invocation will run existing hook
  scripts alongside pre-commit.
- `pre-commit install -f --install-hooks`: idempotently replace git hook
  scripts with pre-commit and also install hooks.

## pre-commit install-hooks [options] [](#pre-commit-install-hooks)

Install hook environments for all environments in the config file.  You may
find `pre-commit install --install-hooks` more useful.

Options: (no additional options)

## pre-commit migrate-config [options] [](#pre-commit-migrate-config)

_new in 1.0.0_ Migrate list configuration to the new map configuration format.

Options: (no additional options)

## pre-commit run [hook-id] [options] [](#pre-commit-run)

Run hooks.

Options:

- `[hook-id]`: specify a single hook-id to run only that hook.
- `-a`, `--all-files`: run on all the files in the repo.
- `--files [FILES [FILES ...]]`: specific filenames to run hooks on.
- `--source SOURCE` + `--origin ORIGIN`: run against the files changed between
  `SOURCE...ORIGIN` in git.
- `--show-diff-on-failure`: _new in 0.13.4_ when hooks fail, run `git diff`
  directly afterward.
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
- `pre-commit run --source HEAD^^^ --origin HEAD`: run against the files that
  have changed between `HEAD^^^` and `HEAD`.  This form is useful when
  leveraged in a pre-receive hook.

## pre-commit sample-config [options] [](#pre-commit-sample-config)

Produce a sample `.pre-commit-config.yaml`.

Options: (no additional options)

## pre-commit try-repo REPO [options] [](#pre-commit-try-repo)

_new in 1.3.0_ Try the hooks in a repository, useful for developing new hooks.
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
- `pre-commit try-repo git://github.com/pre-commit/pre-commit-hooks`: runs all
  the hooks in the latest revision of `pre-commit/pre-commit-hooks`.
- `pre-commit try-repo ../path/to/repo`: run all the hooks in a repository on
  disk.
- `pre-commit try-repo ../pre-commit-hooks flake8`: run only the `flake8` hook
  configured in a local `../pre-commit-hooks` repository.
- See [`pre-commit run`](#pre-commit-run) for more useful `run` invocations
  which are also supported by `pre-commit try-repo`.

## pre-commit uninstall [options] [](#pre-commit-uninstall)

Uninstall the pre-commit script.

Options:

- `-t {pre-commit,pre-push,commit-msg}`,
  `--hook-type {pre-commit,pre-push,commit-msg}`: which hook type to uninstall.
''')}
        </div>

        <div id="advanced">
            <div class="page-header"><h1>Advanced features</h1></div>

${md('''
## Running in migration mode

By default, if you have existing hooks `pre-commit install` will install in a
migration mode which runs both your existing hooks and hooks for pre-commit.
To disable this behavior, simply pass `-f` / `--overwrite` to the `install`
command. If you decide not to use pre-commit, `pre-commit uninstall` will
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

## pre-commit during merges

The biggest gripe we’ve had in the past with pre-commit  hooks was during
merge conflict resolution.  When working on very large projects a merge often
results in hundreds of committed files. I shouldn’t need to run hooks on all
of these files that I didn’t even touch!  This often led to running commit
with `--no-verify` and allowed introduction of real bugs that hooks could have
caught.

pre-commit solves this by only running hooks on files that conflict or were
manually edited during conflict resolution.  This also includes files which
were automatically merged by git.  Git isn't perfect and this can often catch
implicit conflicts (such as with removed python imports).

## pre-commit during push

_new in 0.3.5_ pre-commit can be used to manage `pre-push` hooks.  Simply
`pre-commit install --hook-type pre-push`.

## pre-commit for commit messages

_new in 0.15.4_ pre-commit can be used to manage `commit-msg` hooks.  Simply
`pre-commit install --hook-type commit-msg`.

`commit-msg` hooks can be configured by setting `stages: [commit-msg]`.
`commit-msg` hooks will be passed a single filename -- this file contains the
current contents of the commit message which can be validated.  If a hook
exits nonzero, the commit will be aborted.

## Confining hooks to run at certain stages

If pre-commit during push has been installed, then all hooks (by default) will
be run during the `push` stage.  Hooks can however be confined to a stage by
setting the `stages` property in your `.pre-commit-config.yaml`.  The
`stages` property is an array and can contain any of `commit`, `push`, and
`commit-msg`.

## Passing arguments to hooks

Sometimes hooks require arguments to run correctly. You can pass static
arguments by specifying the `args` property in your `.pre-commit-config.yaml`
as follows:

```yaml
-   repo: git://github.com/pre-commit/pre-commit-hooks
    sha: v0.9.1
    hooks:
    -   id: flake8
        args: [--max-line-length=131]
```

This will pass `--max-line-length=131` to `flake8`.

### Arguments pattern in hooks

If you are writing your own custom hook, your hook should expect to receive
the `args` value and then a list of staged files.

For example, assuming a `.pre-commit-config.yaml`:

```yaml
-   repo: git://github.com/path/to/your/hook/repo
    sha: badf00ddeadbeef
    hooks:
    -   id: my-hook-script-id
        args: [--myarg1=1, --myarg1=2]
```

When you next run `pre-commit`, your script will be called:

```
path/to/script-or-system-exe --myarg1=1 --myarg1=2 dir/file1 dir/file2 file3
```

If the `args` property is empty or not defined, your script will be called:

```
path/to/script-or-system-exe dir/file1 dir/file2 file3
```

## Repository local hooks

Repository-local hooks are useful when:

- The scripts are tightly coupled to the repository and it makes sense to
  distribute the hook scripts with the repository.
- Hooks require state that is only present in a built artifact of your
  repository (such as your app's virtualenv for pylint).
- The official repository for a linter doesn't have the pre-commit metadata.

You can configure repository-local hooks by specifying the `repo` as the
sentinel `local`.

_new in 0.13.0_ repository hooks can use any language which supports
`additional_dependencies` or `docker_image` / `pcre` / `pygrep` / `script` /
`system`.
This enables you to install things which previously would require a trivial
mirror repository.

A `local` hook must define `id`, `name`, `language`, `entry`, and `files` /
`types` as specified under [Creating new hooks](#new-hooks).

Here's an example configuration with a few `local` hooks:

```yaml
-   repo: local
    hooks:
    -   id: pylint
        name: pylint
        entry: python -m pylint.__main__
        language: system
        types: [python]
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

## Filtering files with types

_new in 0.15.0_


Filtering with `types` provides several advantages over traditional filtering
with `files`.

- no error-prone regular expressions
- files can be matched by their shebang (even when extensionless)
- symlinks / submodules can be easily ignored

`types` is specified per hook as an array of tags.  The tags are discovered
through a set of heuristics by the
[identify](https://github.com/chriskuehl/identify) library.  `identify` was
chosen as it is a small portable pure python library.

Some of the common tags you'll find from identify:

- `file`
- `symlink`
- `directory` - in the context of pre-commit this will be a submodule
- `executable` - whether the file has the executable bit set
- `text` - whether the file looks like a text file
- `binary` - whether the file looks like a binary file
- [tags by extension / naming convention](https://github.com/chriskuehl/identify/blob/master/identify/extensions.py)
- [tags by shebang (`#!`)](https://github.com/chriskuehl/identify/blob/master/identify/interpreters.py)

To discovery the type of any file on disk, you can use `identify`'s cli:

```console
$ identify-cli setup.py
["file", "non-executable", "python", "text"]
$ identify-cli some-random-file
["file", "non-executable", "text"]
$ identify-cli --filename-only some-random-file; echo $?
1
```

If a file extension you use is not supported, please
[submit a pull request](https://github.com/chriskuehl/identify)!

`types` and `files` are evaluated with `AND` when filtering.  Tags within
`types` are also evaluated using `AND`.

For example:

```yaml
    files: ^foo/
    types: [file, python]
```

will match a file `foo/1.py` but will not match `setup.py`.

Files can also be matched by shebang.  With `types: python`, an `exe` starting
with `#!/usr/bin/env python3` will also be matched.

As with `files` and `exclude`, you can also exclude types if necessary using
`exclude_types`.

If you'd like to use `types` with compatibility for older versions
[here is a guide to ensuring compatibility](https://github.com/pre-commit/pre-commit/pull/551#issuecomment-312535540).

## Regular expressions

The patterns for `files` and `exclude` are python
[regular expressions](https://docs.python.org/3/library/re.html#regular-expression-syntax).

As such, you can use any of the features that python regexes support.

If you find that your regular expression is becoming unwieldy due to a long
list of excluded / included things, you may find a
[verbose](https://docs.python.org/3/library/re.html#re.VERBOSE) regular
expression useful.  One can enable this with yaml's  multiline literals and
the `(?x)` regex flag.

```yaml
# ...
    -   id: my-hook
        exclude: >
            (?x)^(
                path/to/file1.py|
                path/to/file2.py|
                path/to/file3.py
            )$
```

## Overriding language version

Sometimes you only want to run the hooks on a specific version of the
language. For each language, they default to using the system installed
language (So for example if I’m running `python2.7` and a hook specifies
`python`, pre-commit will run the hook using `python2.7`). Sometimes you
don’t want the default system installed version so you can override this on a
per-hook basis by setting the `language_version`.

```yaml
-   repo: git://github.com/pre-commit/mirrors-scss-lint
    sha: v0.54.0
    hooks:
    -   id: scss-lint
        language_version: 2.1.5
```

This tells pre-commit to use ruby `2.1.5` to run the `scss-lint` hook.

Valid values for specific languages are listed below:
- python: Whatever system installed python interpreters you have. The value of
  this argument is passed as the `-p` to `virtualenv`.
- node: See [nodeenv](https://github.com/ekalinin/nodeenv#advanced).
- ruby: See [ruby-build](https://github.com/sstephenson/ruby-build/tree/master/share/ruby-build).

## Usage in continuous integration

pre-commit can also be used as a tool for continuous integration.  For
instance, adding `pre-commit run --all-files` as a CI step will ensure
everything stays in tip-top shape.  To check only files which have changed,
which may be faster, use something like
`git diff-tree --no-commit-id --name-only -r $REVISION | xargs pre-commit run --files`.

## Usage with tox

[tox](http://tox.readthedocs.io/) is useful for configuring test / CI tools
such as pre-commit.  One feature of `tox>=2` is it will clear environment
variables such that tests are more reproducible.  Under some conditions,
pre-commit requires a few environment variables and so they must be
whitelisted.

When cloning repos over ssh (`repo: git@github.com:...`), `git` requires the
`SSH_AUTH_SOCK` variable and will otherwise fail:

```
[INFO] Initializing environment for git@github.com:pre-commit/pre-commit-hooks.
An unexpected error has occurred: CalledProcessError: Command: ('/usr/bin/git', 'clone', '--no-checkout', 'git@github.com:pre-commit/pre-commit-hooks', '/home/asottile/.cache/pre-commit/repofdkwkq_v')
Return code: 128
Expected return code: 0
Output: (none)
Errors:
    Cloning into '/home/asottile/.cache/pre-commit/repofdkwkq_v'...
    Permission denied (publickey).
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

pre-commit uses `os.path.expanduser` to create the cache directory, on windows
this requires the `HOMEPATH` environment variable:

```ini
[testenv]
passenv = HOMEPATH
```

Or with both:

```ini
[testenv]
passenv = HOMEPATH SSH_AUTH_SOCK
```

## Using the latest sha for a repository

`pre-commit` configuration aims to give a repeatable and fast experience and
therefore intentionally doesn't provide facilities for "unpinned latest
version" for hook repositories.

Instead, `pre-commit` provides tools to make it easy to upgrade to the
latest versions with [`pre-commit autoupdate`](#pre-commit-autoupdate).  If
you need the absolute latest version of a hook (instead of the latest tagged
version), pass the `--bleeding-edge` parameter to `autoupdate`.

`pre-commit` assumes that the value of `sha` is an immutable ref (such as a
tag or SHA) and will cache based on that.  Using a branch name (or `HEAD`) for
the value of `sha` is not supported and will only represent the state of
that mutable ref at the time of hook installation (and will *NOT* update
automatically).
''')}
        </div>

        <div id="contributing">
            <div class="page-header"><h1>Contributing</h1></div>

${md('''
We’re looking to grow the project and get more contributors especially to
support more languages/versions. We’d also like to get the
.pre-commit-hooks.yaml files added to popular linters without maintaining
forks / mirrors.

Feel free to submit Bug Reports, Pull Requests, and Feature Requests.

## Contributors

- website by [Molly Finkle](https://github.com/mfnkl)
- created by [Anthony Sottile](https://github.com/asottile)
- core developers: [Ken Struys](https://github.com/struys),
  [Chris Kuehl](https://github.com/chriskuehl)
- [framework contributors](https://github.com/pre-commit/pre-commit/graphs/contributors)
- [core hook contributors](https://github.com/pre-commit/pre-commit-hooks/graphs/contributors)
- and users like you!
''')}
        </div>
    </div>
</div>
