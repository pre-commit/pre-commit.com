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
            <div class="page-header">${md('# Introduction')}</div>
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
        </div>
        <div id="install">
            <div class="page-header">${md('# Installation')}</div>
${md('''
Before you can run hooks, you need to have the pre-commit package manager
installed.

Using pip:

```bash
pip install pre-commit
```

Non-administrative installation:

- _to upgrade: run again, to uninstall: pass `uninstall` to python_
- _does not work on platforms without symlink support (windows)_


```bash
curl https://pre-commit.com/install-local.py | python -
```

In a python project, add the following to your requirements.txt (or
requirements-dev.txt):

```
pre-commit
```

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

### 2. Add a pre-commit configuration to your project

- create a file named `.pre-commit-config.yaml` in the root level of your project
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
    rev: 19.3b0
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

''')}
        </div>

        <div id="plugins">
            <div class="page-header">${md('# Adding pre-commit plugins to your project')}</div>
${md('''
Once you have pre-commit installed, adding pre-commit plugins to your project
is done with the `.pre-commit-config.yaml` configuration file.

Add a file called `.pre-commit-config.yaml` to the root of your project. The
pre-commit config file describes what repositories and hooks are installed.

## .pre-commit-config.yaml - top level

_new in 1.0.0_: The default configuration file top-level was changed from a
list to a map.  If you're using an old version of pre-commit, the top-level
list is the same as the value of [`repos`](#pre-commit-configyaml---repos).
If you'd like to migrate to the new configuration format, run
[`pre-commit migrate-config`](#pre-commit-migrate-config) to automatically
migrate your configuration.

```table
=r=
    =c= [`repos`](_#top_level-repos)
    =c= A list of [repository mappings](#pre-commit-configyaml---repos).
=r=
    =c= [`default_language_version`](_#top_level-default_language_version)
    =c= (optional: default `{}`) a mapping from language to the default
        [`language_version`](#config-language_version) that should be used for that language.  This will
        only override individual hooks that do not set [`language_version`](#config-language_version).

        For example to use `python3.7` for `language: python` hooks:

        ```yaml
        default_language_version:
            python: python3.7
        ```

        _new in 1.14.0_
=r=
    =c= [`default_stages`](_#top_level-default_stages)
    =c= (optional: default (all stages)) a configuration-wide default for
        the [`stages`](#config-stages) property of hooks.  This will only override individual
        hooks that do not set [`stages`](#config-stages).

        For example:

        ```yaml
        default_stages: [commit, push]
        ```

        _new in 1.14.0_
=r=
    =c= [`files`](_#top_level-files)
    =c= (optional: default `''`) global file include pattern.  _new in 1.21.0_.
=r=
    =c= [`exclude`](_#top_level-exclude)
    =c= (optional: default `^$`) global file exclude pattern.  _new in 1.1.0_.
=r=
    =c= [`fail_fast`](_#top_level-fail_fast)
    =c= (optional: default `false`) set to `true` to have pre-commit stop
        running hooks after the first failure.  _new in 1.1.0_.
=r=
    =c= [`minimum_pre_commit_version`](_#top_level-minimum_pre_commit_version)
    =c= (optional: default `'0'`) require a minimum version of pre-commit.
        _new in 1.15.0_.
```

A sample top-level:

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
    =c= [`repo`](_#repos-repo)
    =c= the repository url to `git clone` from
=r=
    =c= [`rev`](_#repos-rev)
    =c= the revision or tag to clone at.  _new in 1.7.0_: previously `sha`
=r=
    =c= [`hooks`](_#repos-hooks)
    =c= A list of [hook mappings](#pre-commit-configyaml---hooks).
```

A sample repository:

```yaml
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v1.2.3
    hooks:
    -   ...
```

## .pre-commit-config.yaml - hooks

The hook mapping configures which hook from the repository is used and allows
for customization.  All optional keys will receive their default from the
repository's configuration.

```table
=r=
    =c= [`id`](_#config-id)
    =c= which hook from the repository to use.
=r=
    =c= [`alias`](_#config-alias)
    =c= (optional) allows the hook to be referenced using an additional id when
        using `pre-commit run <hookid>`.
        _new in 1.14.0_.
=r=
    =c= [`name`](_#config-name)
    =c= (optional) override the name of the hook - shown during hook execution.
=r=
    =c= [`language_version`](_#config-language_version)
    =c= (optional) override the language version for the
        hook.  See [Overriding Language Version](#overriding-language-version).
=r=
    =c= [`files`](_#config-files)
    =c= (optional) override the default pattern for files to run on.
=r=
    =c= [`exclude`](_#config-exclude)
    =c= (optional) file exclude pattern.
=r=
    =c= [`types`](_#config-types)
    =c= (optional) override the default file types to run on.  See
        [Filtering files with types](#filtering-files-with-types).
=r=
    =c= [`exclude_types`](_#config-exclude_types)
    =c= (optional) file types to exclude.
=r=
    =c= [`args`](_#config-args)
    =c= (optional) list of additional parameters to pass to the hook.
=r=
    =c= [`stages`](_#config-stages)
    =c= (optional) confines the hook to the `commit`, `merge-commit`, `push`,
        `prepare-commit-msg`, `commit-msg`, `post-checkout`, `post-commit`, or
        `manual` stage.  See
        [Confining hooks to run at certain stages](#confining-hooks-to-run-at-certain-stages).
=r=
    =c= [`additional_dependencies`](_#config-additional_dependencies)
    =c= (optional) a list of dependencies that will be installed in the
        environment where this hook gets run.  One useful application is to
        install plugins for hooks such as `eslint`.
=r=
    =c= [`always_run`](_#config-always_run)
    =c= (optional) if `true`, this hook will run even if there are no matching
        files.
=r=
    =c= [`verbose`](_#config-verbose)
    =c= (optional) if `true`, forces the output of the hook to be printed even when
        the hook passes.  _new in 1.6.0_.
=r=
    =c= [`log_file`](_#config-log_file)
    =c= (optional) if present, the hook output will additionally be written
        to a file.
```

One example of a complete configuration:

```yaml
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v1.2.3
    hooks:
    -   id: trailing-whitespace
```

This configuration says to download the pre-commit-hooks project and run its
trailing-whitespace hook.

## Updating hooks automatically

You can update your hooks to the latest version automatically by running
[`pre-commit autoupdate`](#pre-commit-autoupdate).  By default, this will
bring the hooks to the latest tag on the default branch.
''')}
        </div>

        <div id="usage">
            <div class="page-header">${md('# Usage')}</div>
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

```pre-commit
$ pre-commit install
pre-commit installed at /home/asottile/workspace/pytest/.git/hooks/pre-commit
$ git commit -m "Add super awesome feature"
black....................................................................Passed
blacken-docs.........................................(no files to check)Skipped
Trim Trailing Whitespace.................................................Passed
Fix End of Files.........................................................Passed
Check Yaml...........................................(no files to check)Skipped
Debug Statements (Python)................................................Passed
Flake8...................................................................Passed
Reorder python imports...................................................Passed
pyupgrade................................................................Passed
rst ``code`` is two backticks........................(no files to check)Skipped
rst..................................................(no files to check)Skipped
changelog filenames..................................(no files to check)Skipped
[master 146c6c2c] Add super awesome feature
 1 file changed, 1 insertion(+)
```
''')}
        </div>

        <div id="new-hooks">
            <div class="page-header">${md('# Creating new hooks')}</div>
${md('''
pre-commit currently supports hooks written in
[many languages](#supported-languages). As long as your git repo is an
installable package (gem, npm, pypi, etc.) or exposes an executable, it can be
used with pre-commit. Each git repo can support as many languages/hooks as you
want.

The hook must exit nonzero on failure or modify files.

A git repo containing pre-commit plugins must contain a .pre-commit-hooks.yaml
file that tells pre-commit:

```table
=r=
    =c= [`id`](_#hooks-id)
    =c= the id of the hook - used in pre-commit-config.yaml.
=r=
    =c= [`name`](_#hooks-name)
    =c= the name of the hook - shown during hook execution.
=r=
    =c= [`entry`](_#hooks-entry)
    =c= the entry point - the executable to run.  `entry` can also contain
        arguments that will not be overridden such as `entry: autopep8 -i`.
=r=
    =c= [`language`](_#hooks-language)
    =c= the language of the hook - tells pre-commit how to install the hook.
=r=
    =c= [`files`](_#hooks-files)
    =c= (optional: default `''`) the pattern of files to run on.
=r=
    =c= [`exclude`](_#hooks-exclude)
    =c= (optional: default `^$`)  exclude files that were matched by [`files`](#hooks-files).
=r=
    =c= [`types`](_#hooks-types)
    =c= (optional: default `[file]`)  list of file types to run on.  See
        [Filtering files with types](#filtering-files-with-types).
=r=
    =c= [`exclude_types`](_#hooks-exclude_types)
    =c= (optional: default `[]`)  exclude files that were matched by [`types`](#hooks-types).
=r=
    =c= [`always_run`](_#hooks-always_run)
    =c= (optional: default `false`) if `true` this hook will run even if there
        are no matching files.
=r=
    =c= [`verbose`](_#hooks-verbose)
    =c= (optional) if `true`, forces the output of the hook to be printed even when
        the hook passes.  _new in 1.6.0_.
=r=
    =c= [`pass_filenames`](_#hooks-pass_filenames)
    =c= (optional: default `true`) if `false` no arguments will be passed to
        the hook.
=r=
    =c= [`require_serial`](_#hooks-require_serial)
    =c= (optional: default `false`) if `true` this hook will execute using a
        single process instead of in parallel. _new in 1.13.0_.
=r=
    =c= [`description`](_#hooks-description)
    =c= (optional: default `''`) description of the hook.  used for metadata
        purposes only.
=r=
    =c= [`language_version`](_#hooks-language_version)
    =c= (optional: default `default`) see
        [Overriding language version](#overriding-language-version).
=r=
    =c= [`minimum_pre_commit_version`](_#hooks-minimum_pre_commit_version)
    =c= (optional: default `'0'`) allows one to indicate a minimum
        compatible pre-commit version.
=r=
    =c= [`args`](_#hooks-args)
    =c= (optional: default `[]`) list of additional parameters to pass to the hook.
=r=
    =c= [`stages`](_#hooks-stages)
    =c= (optional: default (all stages)) confines the hook to the `commit`, `merge-commit`,
        `push`, `prepare-commit-msg`, `commit-msg`, `post-checkout`, `post-commit`, or
        `manual` stage.  See
        [Confining hooks to run at certain stages](#confining-hooks-to-run-at-certain-stages).

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

## Developing hooks interactively

Since the [`repo`](#repos-repo) property of `.pre-commit-config.yaml` can refer to anything
that `git clone ...` understands, it's often useful to point it at a local
directory while developing hooks.

[`pre-commit try-repo`](#pre-commit-try-repo) streamlines this process by
enabling a quick way to try out a repository.  Here's how one might work
interactively:

_note_: you may need to provide `--commit-msg-filename` when using this
command with hook types `prepare-commit-msg` and `commit-msg`.

_new in 1.14.0_: a commit is no longer necessary to `try-repo` on a local
directory. `pre-commit` will clone any tracked uncommitted changes.

```pre-commit
~/work/hook-repo $ git checkout origin/master -b feature

# ... make some changes

# new in 1.14.0: a commit is no longer necessary for `try-repo`

# In another terminal or tab

~/work/other-repo $ pre-commit try-repo ../hook-repo foo --verbose --all-files
===============================================================================
Using config:
===============================================================================
repos:
-   repo: ../hook-repo
    rev: 84f01ac09fcd8610824f9626a590b83cfae9bcbd
    hooks:
    -   id: foo
===============================================================================
[INFO] Initializing environment for ../hook-repo.
Foo......................................................................Passed
- hook id: foo
- duration: 0.02s

Hello from foo hook!

```

## Supported languages

- [conda](#conda)
- [docker](#docker)
- [docker_image](#docker_image)
- [fail](#fail)
- [golang](#golang)
- [node](#node)
- [perl](#perl)
- [python](#python)
- [python_venv](#python_venv)
- [ruby](#ruby)
- [rust](#rust)
- [swift](#swift)
- [pygrep](#pygrep)
- [script](#script)
- [system](#system)

### conda

_new in 1.21.0_

The hook repository must contain an `environment.yml` file which will be used
via `conda env create --file environment.yml ...` to create the environment.

The `conda` language also supports [`additional_dependencies`](#config-additional_dependencies)
and will pass any of the values directly into `conda install`.  This language can therefore be
used with [local](#repository-local-hooks) hooks.

__Support:__ `conda` hooks work as long as there is a system-installed `conda`
binary (such as [`miniconda`](https://docs.conda.io/en/latest/miniconda.html)).
It has been tested on linux, macOS, and windows.

### docker

The hook repository must have a `Dockerfile`.  It will be installed via
`docker build .`.

Running Docker hooks requires a running Docker engine on your host.  For
configuring Docker hooks, your [`entry`](#hooks-entry) should correspond to an executable
inside the Docker container, and will be used to override the default container
entrypoint. Your Docker `CMD` will not run when pre-commit passes a file list
as arguments to the run container command. Docker allows you to use any
language that's not supported by pre-commit as a builtin.

pre-commit will automatically mount the repository source as a volume using
`-v $PWD:/src:rw,Z` and set the working directory using `--workdir /src`.

__Support:__ docker hooks are known to work on any system which has a working
`docker` executable.  It has been tested on linux and macOS.  Hooks that are
run via `boot2docker` are known to be unable to make modifications to files.

See [this repository](https://github.com/pre-commit/pre-commit-docker-flake8)
for an example Docker-based hook.

### docker_image

A more lightweight approach to `docker` hooks.  The `docker_image`
"language" uses existing docker images to provide hook executables.

`docker_image` hooks can be conveniently configured as [local](#repository-local-hooks)
hooks.

The [`entry`](#hooks-entry) specifies the docker tag to use.  If an image has an
`ENTRYPOINT` defined, nothing special is needed to hook up the executable.
If the container does not specify an `ENTRYPOINT` or you want to change the
entrypoint you can specify it as well in your [`entry`](#hooks-entry).

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

### fail

_new in 1.11.0_

A lightweight [`language`](#hooks-language) to forbid files by filename.  The `fail` language is
especially useful for [local](#repository-local-hooks) hooks.

The [`entry`](#hooks-entry) will be printed when the hook fails.  It is suggested to provide
a brief description for [`name`](#hooks-name) and more verbose fix instructions in [`entry`](#hooks-entry).

Here's an example which prevents any file except those ending with `.rst` from
being added to the `changelog` directory:

```yaml
-   repo: local
    hooks:
    -   id: changelogs-rst
        name: changelogs must be rst
        entry: changelog filenames must end in .rst
        language: fail
        files: 'changelog/.*(?<!\.rst)$'
```

### golang

The hook repository must contain go source code.  It will be installed via
`go get ./...`.  pre-commit will create an isolated `GOPATH` for each hook and
the [`entry`](#hooks-entry) should match an executable which will get installed into the
`GOPATH`'s `bin` directory.

__Support:__ golang hooks are known to work on any system which has go
installed.  It has been tested on linux, macOS, and windows.

### node

The hook repository must have a `package.json`.  It will be installed via
`npm install .`.  The installed package will provide an executable that will
match the [`entry`](#hooks-entry) – usually through `bin` in package.json.

__Support:__ node hooks work without any system-level dependencies.  It has
been tested on linux and macOS and _may_ work under cygwin.

_new in 1.5.0_: windows is now supported for node hooks.  Currently python3
only due to [a bug in cpython](https://bugs.python.org/issue32539).

### perl

_new in 2.1.0_

Perl hooks are installed using the system installation of
[cpan](https://perldoc.perl.org/5.30.0/cpan.html), the CPAN package installer
that comes with Perl.

Hook repositories must have something that `cpan` supports, typically
`Makefile.PL` or `Build.PL`, which it uses to install an executable to
use in the [`entry`](#hooks-entry) definition for your hook. The repository will be installed
via `cpan -T .` (with the installed files stored in your pre-commit cache,
not polluting other Perl installations).

When specifying [`additional_dependencies`](#config-additional_dependencies) for Perl, you can use any of the
[install argument formats understood by `cpan`](https://perldoc.perl.org/5.30.0/CPAN.html#get%2c-make%2c-test%2c-install%2c-clean-modules-or-distributions).

__Support:__ Perl hooks currently require a pre-existing Perl installation,
including the `cpan` tool in `PATH`.  It has been tested on linux, macOS, and
Windows.

### python

The hook repository must be installable via `pip install .` (usually by either
`setup.py` or `pyproject.toml`).  The installed package will provide an
executable that will match the [`entry`](#hooks-entry) – usually through `console_scripts` or
`scripts` in setup.py.

__Support:__ python hooks work without any system-level dependencies.  It
has been tested on linux, macOS, windows, and cygwin.

### python_venv

_new in 1.9.0_

_new in 2.4.0_: The `python_venv` language is now an alias to `python` since
`virtualenv>=20` creates equivalently structured environments.  Previously,
this [`language`](#hooks-language) created environments using the [venv] module.

This [`language`](#hooks-language) will be removed eventually so it is suggested to use `python`
instead.

[venv]: https://docs.python.org/3/library/venv.html

__Support:__ python hooks work without any system-level dependencies.  It
has been tested on linux, macOS, windows, and cygwin.

### ruby

The hook repository must have a `*.gemspec`.  It will be installed via
`gem build *.gemspec && gem install *.gem`.  The installed package will
produce an executable that will match the [`entry`](#hooks-entry) – usually through
`executables` in your gemspec.

__Support:__ ruby hooks work without any system-level dependencies.  It has
been tested on linux and macOS and _may_ work under cygwin.

### rust

_new in 1.10.0_

Rust hooks are installed using the system installation of
[Cargo](https://github.com/rust-lang/cargo), Rust's official package manager.

Hook repositories must have a `Cargo.toml` file which produces at least one
binary ([example](https://github.com/chriskuehl/example-rust-pre-commit-hook)),
whose name should match the [`entry`](#hooks-entry) definition for your hook. The repo will be
installed via `cargo install --bins` (with the binaries stored in your
pre-commit cache, not polluting your user-level Cargo installations).

When specifying [`additional_dependencies`](#config-additional_dependencies) for Rust, you can use the syntax
`{package_name}:{package_version}` to specify a new library dependency (used to
build _your_ hook repo), or the special syntax
`cli:{package_name}:{package_version}` for a CLI dependency (built separately,
with binaries made available for use by hooks).

__Support:__ Rust hooks currently require a pre-existing Rust installation.  It
has been tested on linux, Windows, and macOS.

### swift

The hook repository must have a `Package.swift`.  It will be installed via
`swift build -c release`.  The [`entry`](#hooks-entry) should match an executable created by
building the repository.

__Support:__ swift hooks are known to work on any system which has swift
installed.  It has been tested on linux and macOS.

### pygrep

_new in 1.2.0_

A cross-platform python implementation of `grep` – pygrep hooks are a quick
way to write a simple hook which prevents commits by file matching.  Specify
the regex as the [`entry`](#hooks-entry).  The [`entry`](#hooks-entry) may be any python
[regular expression](#regular-expressions).  For case insensitive regexes you
can apply the `(?i)` flag as the start of your entry, or use `args: [-i]`.

_new in 1.8.0_: For multiline matches, use `args: [--multiline]`.

__Support:__ pygrep hooks are supported on all platforms which pre-commit runs
on.

### script

Script hooks provide a way to write simple scripts which validate files. The
[`entry`](#hooks-entry) should be a path relative to the root of the hook repository.

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
''')}
        </div>

        <div id="cli">
            <div class="page-header">${md('# Command line interface')}</div>

${md('''
All pre-commit commands take the following options:

- `--color {auto,always,never}`: whether to use color in output.
  Defaults to `auto`.  _new in 1.18.0_: can be overridden by using
  `PRE_COMMIT_COLOR={auto,always,never}` or disabled using `TERM=dumb`.
- `-c CONFIG`, `--config CONFIG`: path to alternate config file
- `-h`, `--help`: show help and available options.

## pre-commit autoupdate [options] [](#pre-commit-autoupdate)

Auto-update pre-commit config to the latest repos' versions.

Options:

- `--bleeding-edge`: update to the bleeding edge of the default branch instead
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

## pre-commit clean [options] [](#pre-commit-clean)

Clean out cached pre-commit files.

Options: (no additional options)

## pre-commit gc [options] [](#pre-commit-gc)

_new in 1.14.0_

Clean unused cached repos.

`pre-commit` keeps a cache of installed hook repositories which grows over
time.  This command can be run periodically to clean out unused repos from
the cache directory.

Options: (no additional options)

## pre-commit init-templatedir DIRECTORY [options] [](#pre-commit-init-templatedir)

_new in 1.18.0_

Install hook script in a directory intended for use with
`git config init.templateDir`.

Options:

- `-t {pre-commit,pre-merge-commit,pre-push,prepare-commit-msg,commit-msg,post-checkout,post-commit}`,
  `--hook-type {pre-commit,pre-merge-commit,pre-push,prepare-commit-msg,commit-msg,post-checkout,post-commit}`:
  which hook type to install.

Some example useful invocations:

```bash
git config --global init.templateDir ~/.git-template
pre-commit init-templatedir ~/.git-template
```

Now whenever a repository is cloned or created, it will have the hooks set up
already!

## pre-commit install [options] [](#pre-commit-install)

Install the pre-commit script.

Options:

- `-f`, `--overwrite`: Replace any existing git hooks with the pre-commit
  script.
- `--install-hooks`: Also install environments for all available hooks now
  (rather than when they are first executed). See [`pre-commit
  install-hooks`](#pre-commit-install-hooks).
- `-t {pre-commit,pre-merge-commit,pre-push,prepare-commit-msg,commit-msg,post-checkout,post-commit}`,
  `--hook-type {pre-commit,pre-merge-commit,pre-push,prepare-commit-msg,commit-msg,post-checkout,post-commit}`:
  Specify which hook type to install.
- `--allow-missing-config`: Hook scripts will permit a missing configuration
  file.

Some example useful invocations:

- `pre-commit install`: Default invocation. Installs the pre-commit script
   alongside any existing git hooks.
- `pre-commit install --install-hooks --overwrite`: Idempotently replaces
   existing git hook scripts with pre-commit, and also installs hook
   environments.

## pre-commit install-hooks [options] [](#pre-commit-install-hooks)

Install all missing environments for the available hooks. Unless this command or
`install --install-hooks` is executed, each hook's environment is created the
first time the hook is called.

Each hook is initialized in a separate environment appropriate to the language
the hook is written in. See [supported languages](#supported-languages).

This command does not install the pre-commit script. To install the script along with
the hook environments in one command, use `pre-commit install --install-hooks`.

Options: (no additional options)

## pre-commit migrate-config [options] [](#pre-commit-migrate-config)

_new in 1.0.0_

Migrate list configuration to the new map configuration format.

Options: (no additional options)

## pre-commit run [hook-id] [options] [](#pre-commit-run)

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

## pre-commit sample-config [options] [](#pre-commit-sample-config)

Produce a sample `.pre-commit-config.yaml`.

Options: (no additional options)

## pre-commit try-repo REPO [options] [](#pre-commit-try-repo)

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

## pre-commit uninstall [options] [](#pre-commit-uninstall)

Uninstall the pre-commit script.

Options:

- `-t {pre-commit,pre-merge-commit,pre-push,prepare-commit-msg,commit-msg}`,
  `--hook-type {pre-commit,pre-merge-commit,pre-push,prepare-commit-msg,commit-msg}`: which hook
  type to uninstall.
''')}
        </div>

        <div id="advanced">
            <div class="page-header">${md('# Advanced features')}</div>

${md('''
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

During a push, pre-commit will export the following environment variables:
- `PRE_COMMIT_FROM_REF`: the remote revision that is being pushed to.
    - _new in 2.2.0_ prior to 2.2.0 the variable was `PRE_COMMIT_SOURCE`.
- `PRE_COMMIT_TO_REF`: the local revision that is being pushed to the remote.
    - _new in 2.2.0_ prior to 2.2.0 the variable was `PRE_COMMIT_ORIGIN`.
- `PRE_COMMIT_REMOTE_NAME`: _new in 2.0.0_ which remote is being pushed to
  (for example `origin`)
- `PRE_COMMIT_REMOTE_URL`: _new in 2.0.0_ the url of the remote that is being
  pushed to (for example `git@github.com:pre-commit/pre-commit`.

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

## Confining hooks to run at certain stages

Since the [`default_stages`](#top_level-default_stages) top level configuration property of the
`.pre-commit-config.yaml` file is set to all stages by default, when installing
hooks using the `-t`/`--hook-type` option (see [pre-commit
install [options]](#pre-commit-install)), all hooks will be installed by default
to run at the stage defined through that option. For instance,
`pre-commit install --hook-type pre-push` will install by default all hooks
to run at the `push` stage.

Hooks can however be confined to a stage by setting the [`stages`](#config-stages)
property in your `.pre-commit-config.yaml`.  The [`stages`](#config-stages) property
is an array and can contain any of `commit`, `merge-commit`, `push`, `prepare-commit-msg`,
`commit-msg` and `manual`.

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
-   repo: https://gitlab.com/PyCQA/flake8
    rev: 3.8.3
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
[master (root-commit) d1b39c1] Initial commit
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
- [tags by extension / naming convention](https://github.com/pre-commit/identify/blob/master/identify/extensions.py)
- [tags by shebang (`#!`)](https://github.com/pre-commit/identify/blob/master/identify/interpreters.py)

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

`types` and `files` are evaluated with `AND` when filtering.  Tags within
`types` are also evaluated using `AND`.

For example:

```yaml
    files: ^foo/
    types: [file, python]
```

will match a file `foo/1.py` but will not match `setup.py`.

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

If you'd like to use `types` with compatibility for older versions
[here is a guide to ensuring compatibility](https://github.com/pre-commit/pre-commit/pull/551#issuecomment-312535540).

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

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

- Markdown:

  ```md#copyable
  [![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
  ```

- HTML:

  ```html#copyable
  <a href="https://github.com/pre-commit/pre-commit"><img src="https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white" alt="pre-commit" style="max-width:100%;"></a>
  ```

- reStructuredText:

  ```rst#copyable
  .. image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
     :target: https://github.com/pre-commit/pre-commit
     :alt: pre-commit
  ```

- AsciiDoc:

  ```#copyable
  image:https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white[pre-commit, link=https://github.com/pre-commit/pre-commit]
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

### travis-ci example

```yaml
cache:
  directories:
  - $HOME/.cache/pre-commit
```

### appveyor example

```yaml
cache:
- '%USERPROFILE%\.cache\pre-commit'
```

### azure pipelines example

note: azure pipelines uses immutable caches so the python version and
`.pre-commit-config.yaml` hash must be included in the cache key.  for a
repository template, see [asottile@job--pre-commit.yml].

[asottile@job--pre-commit.yml]: https://github.com/asottile/azure-pipeline-templates/blob/master/job--pre-commit.yml

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

### github actions example

**see the [official pre-commit github action]**

[official pre-commit github action]: https://github.com/pre-commit/action

like [azure pipelines](#azure-pipelines-example), github actions also uses
immutable caches:

```yaml
    - name: set PY
      run: echo "::set-env name=PY::$(python -VV | sha256sum | cut -d' ' -f1)"
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

### circleci example

like [azure pipelines](#azure-pipelines-example), circleci also uses
immutable caches:

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
''')}
        </div>

        <div id="contributing">
            <div class="page-header">${md('# Contributing')}</div>

${md('''
We’re looking to grow the project and get more contributors especially to
support more languages/versions. We’d also like to get the
.pre-commit-hooks.yaml files added to popular linters without maintaining
forks / mirrors.

Feel free to submit bug reports, pull requests, and feature requests.

## Getting help

There are several ways to get help for pre-commit:

- Ask a question on [stackoverflow tagged `<kbd>pre-commit.com</kbd>`]
- Create an issue on [pre-commit/pre-commit]
- Ask in the #pre-commit channel in [asottile's twitch discord]

[stackoverflow tagged `<kbd>pre-commit.com</kbd>`]: https://stackoverflow.com/questions/tagged/pre-commit.com
[pre-commit/pre-commit]: https://github.com/pre-commit/pre-commit/issues/
[asottile's twitch discord]: https://discord.gg/xDKGPaW


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
