pre-commit currently supports hooks written in
[many "languages"](#supported-languages).  In the context of pre-commit the term
"language" refers to the package manager and environment isolation tools that pre-commit will use to
install the hook.  As long as your git repo is an
installable package (gem, npm, pypi, etc.) or exposes an executable, it can be
used with pre-commit. Each git repo can support as many languages/hooks as you
want.

The hook must exit nonzero on failure or modify files.

A git repo containing pre-commit plugins must contain a `.pre-commit-hooks.yaml`
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
    =c= the package manager and environment isolation tools used to install the hook
=r=
    =c= [`files`](_#hooks-files)
    =c= (optional: default `''`) the pattern of files to run on.
=r=
    =c= [`exclude`](_#hooks-exclude)
    =c= (optional: default `^$`)  exclude files that were matched by [`files`](#hooks-files).
=r=
    =c= [`types`](_#hooks-types)
    =c= (optional: default `[file]`)  list of file types to run on (AND).  See
        [Filtering files with types](#filtering-files-with-types).
=r=
    =c= [`types_or`](_#hooks-types_or)
    =c= (optional: default `[]`)  list of file types to run on (OR).  See
        [Filtering files with types](#filtering-files-with-types).
        _new in 2.9.0_.
=r=
    =c= [`exclude_types`](_#hooks-exclude_types)
    =c= (optional: default `[]`)  the pattern of files to exclude.
=r=
    =c= [`always_run`](_#hooks-always_run)
    =c= (optional: default `false`) if `true` this hook will run even if there
        are no matching files.
=r=
    =c= [`fail_fast`](_#hooks-fail_fast)
    =c= (optional: default `false`) if `true` pre-commit will stop running
        hooks if this hook fails.  _new in 2.16.0_.
=r=
    =c= [`verbose`](_#hooks-verbose)
    =c= (optional: default `false`) if `true`, forces the output of the hook to be printed even when
        the hook passes.
=r=
    =c= [`pass_filenames`](_#hooks-pass_filenames)
    =c= (optional: default `true`) if `false` no filenames will be passed to
        the hook.
=r=
    =c= [`require_serial`](_#hooks-require_serial)
    =c= (optional: default `false`) if `true` this hook will execute using a
        single process instead of in parallel.
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
    =c= (optional: default (all stages)) selects which git hook(s) to run for.
        See [Confining hooks to run at certain stages](#confining-hooks-to-run-at-certain-stages).

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

a commit is not necessary to `try-repo` on a local
directory. `pre-commit` will clone any tracked uncommitted changes.

```pre-commit
~/work/hook-repo $ git checkout origin/main -b feature

# ... make some changes

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
- [coursier](#coursier)
- [dart](#dart)
- [docker](#docker)
- [docker_image](#docker_image)
- [dotnet](#dotnet)
- [fail](#fail)
- [golang](#golang)
- [haskell](#haskell)
- [lua](#lua)
- [node](#node)
- [perl](#perl)
- [python](#python)
- [python_venv](#python_venv)
- [r](#r)
- [ruby](#ruby)
- [rust](#rust)
- [swift](#swift)
- [pygrep](#pygrep)
- [script](#script)
- [system](#system)

### conda

The hook repository must contain an `environment.yml` file which will be used
via `conda env create --file environment.yml ...` to create the environment.

The `conda` language also supports [`additional_dependencies`](#config-additional_dependencies)
and will pass any of the values directly into `conda install`.  This language can therefore be
used with [local](#repository-local-hooks) hooks.

_new in 2.17.0_: `mamba` or `micromamba` can be used to install instead via the
`PRE_COMMIT_USE_MAMBA=1` or `PRE_COMMIT_USE_MICROMAMBA=1` environment
variables.

__Support:__ `conda` hooks work as long as there is a system-installed `conda`
binary (such as [`miniconda`](https://docs.conda.io/en/latest/miniconda.html)).
It has been tested on linux, macOS, and windows.

### coursier

_new in 2.8.0_

The hook repository must have a `.pre-commit-channel` folder and that folder
must contain the coursier
[application descriptors](https://get-coursier.io/docs/2.0.0-RC6-10/cli-install.html#application-descriptor-reference)
for the hook to install. For configuring coursier hooks, your
[`entry`](#hooks-entry) should correspond to an executable installed from the
repository's `.pre-commit-channel` folder.

__Support:__ `coursier` hooks are known to work on any system which has the
`cs` or `coursier` package manager installed. The specific coursier
applications you install may depend on various versions of the JVM, consult
the hooks' documentation for clarification.  It has been tested on linux.

_new in 2.18.0_: pre-commit now supports the `coursier` naming of the package
manager executable.

_new in 3.0.0_: `language: coursier` hooks now support `repo: local` and
`additional_dependencies`.

### dart

_new in 2.15.0_

The hook repository must have a `pubspec.yaml` -- this must contain an
`executables` section which will list the binaries that will be available
after installation.  Match the [`entry`](#hooks-entry) to an executable.

`pre-commit` will build each executable using `dart compile exe bin/{executable}.dart`.

`language: dart` also supports [`additional_dependencies`](#config-additional_dependencies).
to specify a version for a dependency, separate the package name by a `:`:

```yaml
        additional_dependencies: ['hello_world_dart:1.0.0']
```

__Support:__ `dart` hooks are known to work on any system which has the `dart`
sdk installed.  It has been tested on linux, macOS, and windows.

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

### dotnet

_new in 2.8.0_

dotnet hooks are installed using the system installation of the dotnet CLI.

Hook repositories must contain a dotnet CLI tool which can be `pack`ed and
`install`ed as per [this](https://docs.microsoft.com/en-us/dotnet/core/tools/global-tools-how-to-create)
example. The `entry` should match an executable created by building the
repository. Additional dependencies are not currently supported.

__Support:__ dotnet hooks are known to work on any system which has the dotnet
CLI installed.  It has been tested on linux and windows.

### fail

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
`go install ./...`.  pre-commit will create an isolated `GOPATH` for each hook
and the [`entry`](#hooks-entry) should match an executable which will get installed into the
`GOPATH`'s `bin` directory.

This language supports `additional_dependencies` and will pass any of the values directly to `go
install`. It can be used as a `repo: local` hook.

_changed in 2.17.0_: previously `go get ./...` was used

_new in 3.0.0_: pre-commit will bootstrap `go` if it is not present. `language: golang`
also now supports `language_version`

__Support:__ golang hooks are known to work on any system which has go
installed.  It has been tested on linux, macOS, and windows.

### haskell

_new in 3.4.0_

The hook repository must have one or more `*.cabal` files.  Once installed
the `executable`s from these packages will be available to use with `entry`.

This language supports `additional_dependencies` so it can be used as a
`repo: local` hook.

__Support:__ haskell hooks are known to work on any system which has `cabal`
installed.  It has been tested on linux, macOS, and windows.

### lua

_new in 2.17.0_

Lua hooks are installed with the version of Lua that is used by Luarocks.

__Support:__ Lua hooks are known to work on any system which has Luarocks
installed.  It has been tested on linux and macOS and _may_ work on windows.

### node

The hook repository must have a `package.json`.  It will be installed via
`npm install .`.  The installed package will provide an executable that will
match the [`entry`](#hooks-entry) – usually through `bin` in package.json.

__Support:__ node hooks work without any system-level dependencies.  It has
been tested on linux, windows, and macOS and _may_ work under cygwin.

### perl

_new in 2.1.0_

Perl hooks are installed using the system installation of
[cpan](https://perldoc.perl.org/cpan), the CPAN package installer
that comes with Perl.

Hook repositories must have something that `cpan` supports, typically
`Makefile.PL` or `Build.PL`, which it uses to install an executable to
use in the [`entry`](#hooks-entry) definition for your hook. The repository will be installed
via `cpan -T .` (with the installed files stored in your pre-commit cache,
not polluting other Perl installations).

When specifying [`additional_dependencies`](#config-additional_dependencies) for Perl, you can use any of the
[install argument formats understood by `cpan`](https://perldoc.perl.org/CPAN#get%2c-make%2c-test%2c-install%2c-clean-modules-or-distributions).

__Support:__ Perl hooks currently require a pre-existing Perl installation,
including the `cpan` tool in `PATH`.  It has been tested on linux, macOS, and
Windows.

### python

Use [virtualenv] and pip to create the enivronment to install the hook.

The hook repository must be installable via `pip install .` (usually by either
`setup.py` or `pyproject.toml`).  The installed package will provide an
executable that will match the [`entry`](#hooks-entry) – usually through `console_scripts` or
`scripts` in setup.py.

This language also supports `additional_dependencies`
so it can be used with [local](#repository-local-hooks) hooks.
The specified dependencies will be appended to the `pip install` command.

__Support:__ python hooks work without any system-level dependencies.  It
has been tested on linux, macOS, windows, and cygwin.

[virtualenv]: https://virtualenv.pypa.io/en/latest/

### python_venv

_new in 2.4.0_: The `python_venv` language is now an alias to `python` since
`virtualenv>=20` creates equivalently structured environments.  Previously,
this [`language`](#hooks-language) created environments using the [venv] module.

This [`language`](#hooks-language) will be removed eventually so it is suggested to use `python`
instead.

[venv]: https://docs.python.org/3/library/venv.html

__Support:__ python hooks work without any system-level dependencies.  It
has been tested on linux, macOS, windows, and cygwin.

### r

_new in 2.11.0_

This hook repository must have a `renv.lock` file that will be restored with
[`renv::restore()`](https://rstudio.github.io/renv/reference/restore.html) on
hook installation. If the repository is an R package (i.e. has `Type: Package`
in `DESCRIPTION`), it is installed. The supported syntax in [`entry`](#hooks-entry) is
`Rscript -e {expression}` or `Rscript path/relative/to/hook/root`. The
R Startup process is skipped (emulating `--vanilla`), as all configuration
should be exposed via [`args`](#hooks-args) for maximal transparency and portability.

When specifying [`additional_dependencies`](#config-additional_dependencies)
for R, you can use any of the install argument formats understood by
[`renv::install()`](https://rstudio.github.io/renv/reference/install.html#examples).

__Support:__ `r` hooks work as long as [`R`](https://www.r-project.org) is
installed and on `PATH`. It has been tested on linux, macOS, and windows.


### ruby

The hook repository must have a `*.gemspec`.  It will be installed via
`gem build *.gemspec && gem install *.gem`.  The installed package will
produce an executable that will match the [`entry`](#hooks-entry) – usually through
`executables` in your gemspec.

__Support:__ ruby hooks work without any system-level dependencies.  It has
been tested on linux and macOS and _may_ work under cygwin.

### rust

Rust hooks are installed using [Cargo](https://github.com/rust-lang/cargo),
Rust's official package manager.

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

_new in 2.21.0_: pre-commit will bootstrap `rust` if it is not present.
`language: rust` also now supports `language_version`

__Support:__ It has been tested on linux, Windows, and macOS.

### swift

The hook repository must have a `Package.swift`.  It will be installed via
`swift build -c release`.  The [`entry`](#hooks-entry) should match an executable created by
building the repository.

__Support:__ swift hooks are known to work on any system which has swift
installed.  It has been tested on linux and macOS.

### pygrep

A cross-platform python implementation of `grep` – pygrep hooks are a quick
way to write a simple hook which prevents commits by file matching.  Specify
the regex as the [`entry`](#hooks-entry).  The [`entry`](#hooks-entry) may be any python
[regular expression](#regular-expressions).  For case insensitive regexes you
can apply the `(?i)` flag as the start of your entry, or use `args: [-i]`.

For multiline matches, use `args: [--multiline]`.

_new in 2.8.0_: To require all files to match, use `args: [--negate]`.

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
