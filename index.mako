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
pre-commit config file describes:
''')}
            <table class="table table-bordered">
                <tbody>
                    <tr>
                        <td>${md('`repo`, `sha`')}</td>
                        <td>where to get plugins (git repos).  <code>sha</code> can also be a tag.</td>
                    </tr>
                    <tr>
                        <td><code>id</code></td>
                        <td>What plugins from the repo you want to use.</td>
                    </tr>
                    <tr>
                        <td><code>language_version</code></td>
                        <td>(optional) Override the default language version for the hook. See <a href="#overriding-language-version">Advanced Features: "Overriding Language Version"</a>.</td>
                    </tr>
                    <tr>
                        <td><code>files</code></td>
                        <td>(optional) Override the default pattern for files to run on.</td>
                    </tr>
                    <tr>
                        <td><code>exclude</code></td>
                        <td>(optional) File exclude pattern.</td>
                    </tr>
                    <tr>
                        <td><code>types</code></td>
                        <td>(optional) Override the default file types to run on.  See <a href="#filtering-files-with-types">Filtering files with types</a>.  <em>new in 0.15.0</em></td>
                    </tr>
                    <tr>
                        <td><code>exclude_types</code></td>
                        <td>(optional) File types exclude.  <em>new in 0.15.0</em></td>
                    </tr>
                    <tr>
                        <td><code>args</code></td>
                        <td>(optional) additional parameters to pass to the hook.</td>
                    </tr>
                    <tr>
                        <td><code>stages</code></td>
                        <td>(optional) Confines the hook to the <code>commit</code>, <code>push</code>, or <code>commit-msg</code> stage. See <a href="#confining-hooks-to-run-at-certain-stages">Advanced Features: "Confining Hooks To Run At A Certain Stage"</a>.</td>
                    </tr>
                    <tr>
                        <td><code>additional_dependencies</code></td>
                        <td>(optional) A list of dependencies that will be installed in the environment where this hook gets run. One useful application is to install plugins for hooks such as eslint.  <em>new in 0.6.6</em></td>
                    </tr>
                    <tr>
                        <td><code>always_run</code></td>
                        <td>(optional) Default <code>false</code>.  If <code>true</code> this hook will run even if there are no matching files.  <em>new in 0.7.2</em></td>
                    </tr>
                </tbody>
            </table>
${md('''
For example:

```yaml
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
''')}
            <table class="table table-bordered">
                <tbody>
                    <tr>
                        <td><code>id</code></td>
                        <td>The id of the hook - used in pre-commit-config.yaml</td>
                    </tr>
                    <tr>
                        <td><code>name</code></td>
                        <td>The name of the hook - shown during hook execution</td>
                    </tr>
                    <tr>
                        <td><code>entry</code></td>
                        <td>The entry point - The executable to run</td>
                    </tr>
                    <tr>
                        <td><code>language</code></td>
                        <td>The language of the hook - tells pre-commit how to install the hook.</td>
                    </tr>
                    <tr>
                        <td><code>files</code></td>
                        <td>(optional) Default <code>''</code>.  The pattern of files to run on.  <em>new in 0.15.0: now optional</em></td>
                    </tr>
                    <tr>
                        <td><code>exclude</code></td>
                        <td>(optional) Default <code>^$</code>.  Exclude files that were matched by <code>files</code>.</td>
                    <tr>
                        <td><code>types</code></td>
                        <td>(optional) Default <code>[file]</code>.  List of file types to run on.  See <a href="#filtering-files-with-types">Filtering files with types</a>.  <em>new in 0.15.0</em></td>
                    </tr>
                    <tr>
                        <td><code>exclude_types</code></td>
                        <td>(optional) Default <code>[]</code>.  Exclude files that were matched by <code>types</code>.  <em>new in 0.15.0</em></td>
                    </tr>
                    <tr>
                        <td><code>always_run</code></td>
                        <td>(optional) Default <code>false</code>.  If <code>true</code> this hook will run even if there are no matching files. <em>new in 0.7.2</em></td>
                    </tr>
                    <tr>
                        <td><code>pass_filenames</code></td>
                        <td>(optional) Default <code>true</code>.  If <code>true</code> this hook must take filenames as positional arguments. <em>new in 0.14.0</em></td>
                    </tr>
                    <tr>
                        <td><code>description</code></td>
                        <td>(optional) The description of the hook.</td>
                    </tr>
                    <tr>
                        <td><code>language_version</code></td>
                        <td>(optional) See <a href="#overriding-language-version">Advanced Features: "Overriding Language Version"</a>.</td>
                    </tr>
                    <tr>
                        <td><code>minimum_pre_commit_version</code></td>
                        <td>
                            (optional) Allows one to indicate a minimum
                            compatible pre-commit version. <em>new in 0.6.7</em>
                        </td>
                    </tr>
                </tbody>
            </table>

${md('''
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

"Perl Compatible Regular Expressions" – pcre hooks are a quick way to write a
simple hook which prevents commits by file matching.  Specify the regex as the
`entry`.

macos does not ship with a functioning `grep -P` so you'll need
`brew install grep` for pcre hooks to function.

__Support:__ pcre hooks work on any system which has a functioning
`grep -P` (or in the case of macOS: `ggrep -P`).  It has been tested on linux,
macOS, windows, and cygwin.

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

Since the `repo` property of .pre-commit-config.yaml can take anything that
`git clone ...` understands, it's often useful to point it at a local
directory on your machine while developing hooks and using
`pre-commit autoupdate` to synchronize changes.

```yaml
-   repo: /home/asottile/workspace/pre-commit-hooks
    sha: v0.9.1
    hooks:
    -   id: trailing-whitespace
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

## pre-commit for commit messsages

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
`additional_dependencies` or `pcre` / `script` / `system` / `docker_image`.
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
