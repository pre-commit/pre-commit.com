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

_(To upgrade: run again, to uninstall: pass `uninstall` to python)_

```
curl https://raw.githubusercontent.com/pre-commit/pre-commit.github.io/real_master/install-local.py | python
```

System Level Install:

```
curl https://bootstrap.pypa.io/get-pip.py | sudo python - pre-commit
```

In a Python Project, add the following to your requirements.txt (or
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
''')}

            <h2 id="updating-hooks-automatically">Updating hooks automatically</h2>

${md('''
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
''')}
            <h2 id="supported-languages">Supported languages</h2>

${md('''
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
''')}

            <h3 id="docker">docker</h3>
${md('''
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
''')}

            <h3 id="docker_image">docker_image</h3>
${md('''
_new in 0.18.0_

A more lightweight approach to <code>docker</code> hooks.  The `docker_image`
"language" uses existing docker images to provide hook executables.

`docker_image` hooks can be conviently configured as [local](#repository-local)
hooks.

The `entry` specifies the docker tag to use.  If an image has an
`ENTRYPOINT` defined, nothing special is needed to hook up the executable.
If the container does not specify an <code>ENTRYPOINT</code> or you want to
change the entrypoint you can specify it as well in your `entry`.

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
''')}

            <h3 id="golang">golang</h3>
${md('''
_new in 0.12.0_

The hook repository must contain go source code.  It will be installed via
`go get ./...`.  pre-commit will create an isolated `GOPATH` for each hook and
the `entry` should match an executable which will get installed into the
`GOPATH`'s `bin` directory.

__Support:__ golang hooks are known to work on any system which has go
installed.  It has been tested on linux, macOS, and windows.
''')}

            <h3 id="node">node</h3>
${md('''
The hook repository must have a `package.json`.  It will be installed via
`npm install .`.  The installed package will provide an executable that will
match the `entry` – usually through `bin` in package.json.

__Support:__ node hooks work without any system-level dependencies.  It has
been tested on linux and macOS and _may_ work under cygwin.
''')}

            <h3 id="python">python</h3>
${md('''
The hook repository must have a `setup.py`.  It will be installed via
`pip install .`.  The installed package will provide an executable that will
match the `entry` – usually through `console_scripts` or `scripts` in setup.py.

__Support:__ python hooks work without any system-level depedendencies.  It
has been tested on linux, macOS, windows, and cygwin.
''')}

            <h3 id="ruby">ruby</h3>
${md('''
The hook repository must have a `*.gemspec`.  It will be installed via
`gem build *.gemspec && gem install *.gem`.  The installed package will
produce an executable that will match the `entry` – usually through
`exectuables` in your gemspec.

__Support:__ ruby hooks work without any system-level dependencies.  It has
been tested on linux and macOS and _may_ work under cygwin.
''')}

            <h3 id="swift">swift</h3>
${md('''
_new in 0.11.0_

The hook repository must have a `Package.swift`.  It will be installed via
`swift build -c release`.  The `entry` should match an executable created by
building the repository.

__Support:__ swift hooks are known to work on any system which has swift
installed.  It has been tested on linux and macOS.
''')}

            <h3 id="pcre">pcre</h3>
${md('''
"Perl Compatible Regular Expressions" – pcre hooks are a quick way to write a
simple hook which prevents commits by file matching.  Specify the regex as the
`entry`.

macos does not ship with a functioning `grep -P` so you'll need
`brew install grep` for pcre hooks to function.

__Support:__ pcre hooks work on any system which has a functioning
`grep -P` (or in the case of macOS: `ggrep -P`).  It has been tested on linux,
macOS, windows, and cygwin.
''')}

            <h3 id="script">script</h3>
${md('''
Script hooks provide a way to write simple scripts which validate files. The
`entry` should be a path relative to the root of the hook repository.

This hook type will not be given a virtual environment to work with – if it
needs additional dependencies the consumer must install them manually.

__Support:__ the support of script hooks depend on the scripts themselves.
''')}

            <h3 id="system">system</h3>
${md('''
System hooks provide a way to write hooks for system-level executables which
don't have a supported language above (or have special environment
requirements that don't allow them to run in isolation such as pylint).

This hook type will not be given a virtual environment to work with – if it
needs additional dependencies the consumer must install them manually.

__Support:__ the support of system hooks depend on the executables.
''')}

            <h2 id="developing-hooks-interactively">Developing hooks interactively</h2>

            <p>
                Since the <code>repo</code> property of .pre-commit-config.yaml
                can take anything that <code>git clone ...</code> understands,
                it's often useful to point it at a local directory on your
                machine while developing hooks and using
                <code>pre-commit autoupdate</code> to synchronize changes.
<pre>
-   repo: /home/asottile/workspace/pre-commit-hooks
    sha: v0.9.1
    hooks:
    -   id: trailing-whitespace
</pre>
            </p>
        </div>

        <div id="cli">
            <div class="page-header"><h1>Command line interface</h1></div>

            <p>All pre-commit commands take the following options:</p>
            <ul>
                <li>
                    <code>--color {auto,always,never}</code>: whether to use
                    color in output.  Defaults to `auto`.
                </li>
                <li>
                    <code>-c CONFIG</code>, <code>--config CONFIG</code>:
                    path to alternate config file
                </li>
                <li>
                    <code>-h</code>, <code>--help</code>: show help and
                    available options.
                </li>
            </ul>

            <h2 id="pre-commit-autoupdate">pre-commit autoupdate [options]</h2>
            <p>Auto-update pre-commit config to the latest repos' versions.</p>
            <p>Options:</p>
            <p>
                <ul>
                    <li>
                        <code>--bleeding-edge</code>: update to the bleeding
                        edge of `master` instead of the latest tagged version
                        (the default behaviour).
                    </li>
                </ul>
            </p>

            <h2 id="pre-commit-clean">pre-commit clean [options]</h2>
            <p>Clean out cached pre-commit files.</p>
            <p>Options: (no additional options)</p>

            <h2 id="pre-commit-install">pre-commit install [options]</h2>
            <p>Install the pre-commit script.</p>
            <p>Options:</p>
            <p>
                <ul>
                    <li>
                        <code>-f</code>, <code>--overwrite</code>: overwrite
                        existing hooks / remove migration mode.
                    </li>
                    <li>
                        <code>--install-hooks</code>: also install hook
                        environments for all available hooks.
                    </li>
                    <li>
                        <code>-t {pre-commit,pre-push,commit-msg}</code>,
                        <code>--hook-type {pre-commit,pre-push,commit-msg}</code>:
                        which hook type to install.
                    </li>
                    <li>
                        <code>--allow-missing-config</code>: whether to allow
                        the installed hook scripts to permit a missing
                        configuration file.
                    </li>
                </ul>
            </p>
            <p>Some example useful invocations:</p>
            <p>
                <ul>
                    <li>
                        <code>pre-commit install</code>: default install
                        invocation will run existing hook scripts alongside
                        pre-commit.
                    </li>
                    <li>
                        <code>pre-commit install -f --install-hooks</code>:
                        idempotently replace git hook scripts with pre-commit
                        and also install hooks.
                    </li>
                </ul>
            </p>

            <h2 id="pre-commit-install-hooks">pre-commit install-hooks [options]</h2>
            <p>
                Install hook environments for all environments in the config
                file.  You may find
                <code>pre-commit install --install-hooks</code> more useful.
            </p>
            <p>Options: (no additional options)</p>

            <h2 id="pre-commit-migrate-config">pre-commit migrate-config [options]</h2>
            <p>
                <em>new in 1.0.0</em> Migrate list configuration to the new
                map configuration format.
            </p>
            <p>Options: (no additional options)</p>

            <h2 id="pre-commit-run">pre-commit run [hook-id] [options]</h2>
            <p>Run hooks.</p>
            <p>Options:</p>
            <p>
                <ul>
                    <li>
                        <code>[hook-id]</code>: specify a single hook-id to run
                        only that hook.
                    </li>
                    <li>
                        <code>-a</code>, <code>--all-files</code>: run on all
                        the files in the repo.
                    </li>
                    <li>
                        <code>--files [FILES [FILES ...]]</code>: specific
                        filenames to run hooks on.
                    </li>
                    <li>
                        <code>--source SOURCE</code> +
                        <code>--origin ORIGIN</code>: run against the files
                        changed between <code>SOURCE...ORIGIN</code> in git.
                    </li>
                    <li>
                        <code>--show-diff-on-failure</code>:
                        <em>new in 0.13.4</em> when hooks fail, run
                        <code>git diff</code> directly afterward.
                    </li>
                    <li>
                        <code>-v</code>, <code>--verbose</code>: produce hook
                        output independent of success.  Include hook ids in
                        output.
                    </li>
                </ul>
            </p>

            <p>Some example useful invocations:</p>
            <p>
                <ul>
                    <li>
                        <code>pre-commit run</code>: this is what pre-commit
                        runs by default when committing.  This will run all
                        hooks against currently staged files.
                    </li>
                    <li>
                        <code>pre-commit run --all-files</code>: run all the
                        hooks against all the files.  This is a useful
                        invocation if you are using pre-commit in CI.
                    </li>
                    <li>
                        <code>pre-commit run flake8</code>: run the `flake8`
                        hook against all staged files.
                    </li>
                    <li>
                        <code>
                            git ls-files -- '*.py' |
                            xargs pre-commit run --files
                        </code>: run all hooks against all '*.py' files in the
                        repository.
                    </li>
                    <li>
                        <code>
                            pre-commit run --source HEAD^^^
                            --origin HEAD
                        </code>: run against the files that have changed
                        between HEAD^^^ and HEAD.  This form is useful when
                        leveraged in a pre-receive hook.
                    </li>
                </ul>
            </p>

            <h2 id="pre-commit-sample-config">pre-commit sample-config [options]</h2>
            <p>Produce a sample <code>.pre-commit-config.yaml</code>.</p>
            <p>Options: (no additional options)</p>

            <h2 id="pre-commit-uninstall">pre-commit uninstall</h2>
            <p>Uninstall the pre-commit script.</p>
            <p>Options:</p>
            <p>
                <ul>
                    <li>
                        <code>-t {pre-commit,pre-push,commit-msg}</code>,
                        <code>--hook-type {pre-commit,pre-push,commit-msg}</code>:
                        which hook type to uninstall.
                    </li>
                </ul>
            </p>
        </div>

        <div id="advanced">
            <div class="page-header">
                <h1>Advanced features</h1>
            </div>

            <h2 id="running-in-migration-mode">Running in migration mode</h2>
            <p>By default, if you have existing hooks <code>pre-commit install</code> will install in a migration mode which runs both your existing hooks and hooks for pre-commit. To disable this behavior, simply pass <code>-f</code> / <code>--overwrite</code> to the <code>install</code> command. If you decide not to use pre-commit, <code>pre-commit uninstall</code> will restore your hooks to the state prior to installation.</p>

            <h2 id="temporarily-disabling-hooks">Temporarily disabling hooks</h2>
            <p>Not all hooks are perfect so sometimes you may need to skip execution of one or more hooks. pre-commit solves this by querying a <code>SKIP</code> environment variable. The <code>SKIP</code> environment variable is a comma separated list of hook ids. This allows you to skip a single hook instead of <code>--no-verify</code>ing the entire commit.</p>
            <pre>$ SKIP=flake8 git commit -m "foo"</pre>

            <h2 id="pre-commit-during-commits">pre-commit during commits</h2>
            <p>Running hooks on unstaged changes can lead to both false-positives and false-negatives during committing. pre-commit only runs on the staged contents of files by temporarily saving the contents of your files at commit time and stashing the unstaged changes while running hooks.</p>

            <h2 id="pre-commit-during-merges">pre-commit during merges</h2>
            <p>
                The biggest gripe we&rsquo;ve had in the past with pre-commit
                hooks was during merge conflict resolution.
                When working on very large projects a merge often results in
                hundreds of committed files. I shouldn&rsquo;t need to run
                hooks on all of these files that I didn&rsquo;t even touch!
                This often led to running commit with <code>--no-verify</code>
                and allowed introduction of real bugs that hooks could have
                caught.
            </p>
            <p>
                pre-commit solves this by only running hooks on files that
                conflict or were manually edited during conflict resolution.
                This also includes files which were automatically merged by
                git.  Git isn't perfect and this can often catch implicit
                conflicts (such as with removed python imports).
            </p>

            <h2 id="pre-commit-during-push">pre-commit during push</h2>
            <p>As of version 0.3.5, pre-commit can be used to manage <code>pre-push</code> hooks.  Simply <code>pre-commit install --hook-type pre-push</code>.</p>

            <h2 id="pre-commit-for-commit-messages">pre-commit for commit messages</h2>
            <p>
                <em>new in 0.15.4</em> pre-commit can be used to manage
                <code>commit-msg</code> hooks.  Simply <code>pre-commit install --hook-type commit-msg</code>.
            </p>
            <p>
                <code>commit-msg</code> hooks can be configured by setting
                <code>stages: [commit-msg]</code>.  <code>commit-msg</code>
                hooks will be passed a single filename -- this file contains
                the current contents of the commit message which can be
                validated.  If a hook exits nonzero, the commit will be
                aborted.
            </p>

            <h2 id="confining-hooks-to-run-at-certain-stages">Confining hooks to run at certain stages</h2>
            <p>If pre-commit during push has been installed, then all hooks (by default) will be run during the <code>push</code> stage. Hooks can however be confined to a stage by setting the <code>stages</code> property in your <code>.pre-commit-config.yaml</code>. The <code>stages</code> property is an array and can contain any of <code>commit</code>, <code>push</code>, and <code>commit-msg</code>.</p>

            <h2 id="passing-arguments-to-hooks">Passing arguments to hooks</h2>
            <p>Sometimes hooks require arguments to run correctly. You can pass static arguments by specifying the <code>args</code> property in your <code>.pre-commit-config.yaml</code> as follows:</p>
<pre>
-   repo: git://github.com/pre-commit/pre-commit-hooks
    sha: v0.9.1
    hooks:
    -   id: flake8
        args: [--max-line-length=131]
</pre>
            <p>This will pass <code>--max-line-length=131</code> to <code>flake8</code>.</p>

            <h3 id="arguments-pattern-in-hooks">Arguments Pattern in hooks</h3>
            <p>If you are writing your own custom hook as a <code>script</code>-type or even a <code>system</code> hook, your hook should expect to receive the <code>args</code> value and then a list of staged files.</p>

            <p>For example, assuming a <code>.pre-commit-config.yaml</code>:</p>
<pre>
-   repo: git://github.com/path/to/your/hook/repo
    sha: badf00ddeadbeef
    hooks:
    -   id: my-hook-script-id
        args: [--myarg1=1, --myarg1=2]
</pre>

            <p>When you next run <code>pre-commit</code>, your script will be called:</p>
            <pre>path/to/script-or-system-exe --myarg1=1 --myarg1=2 dir/file1 dir/file2 file3</pre>

            <p>If the <code>args</code> property is empty or not defined, your script will be called:</p>
            <pre>path/to/script-or-system-exe dir/file1 dir/file2 file3</pre>

            <h2 id="repository-local-hooks">Repository Local Hooks</h2>
            <p>Repository-local hooks are useful when:</p>
            <ul>
                <li>The scripts are tightly coupled to the repository and it makes sense to distribute the hook scripts with the repository.</li>
                <li>Hooks require state that is only present in a built artifact of your repository (such as your app's virtualenv for pylint)</li>
                <li>The official repository for a linter doesn't have the pre-commit metadata.</li>
            </ul>
            <p>You can configure repository-local hooks by specifying the <code>repo</code> as the sentinel <code>local</code>.</p>
            <p>
                <em>new in 0.13.0</em> repository hooks can use any language
                which supports <code>additional_dependencies</code> or
                <code>pcre</code> / <code>script</code> / <code>system</code> /
                <code>docker_image</code>.
                This enables you to install things which previously would
                require a trivial mirror repository.
            </p>
            <p>
                A <code>local</code> hook must define <code>id</code>,
                <code>name</code>, <code>language</code>, <code>entry</code>,
                and <code>files</code> / <code>types</code> as specified under
                <a href="#new-hooks">Creating new hooks</a>
            </p>
            <p>Here's an example configuration with a few <code>local</code> hooks:</p>
<pre>
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
</pre>

            <h2 id="filtering-files-with-types">Filtering files with types</h2>

            <p><em>new in 0.15.0</em></p>

            <p>
                Filtering with <code>types</code> provides several benefits
                over traditional filtering with <code>files</code>.

                <ul>
                    <li>no error-prone regular expressions</li>
                    <li>files can be matched by their shebang (even when extensionless)</li>
                    <li>symlinks / submodules can be easily ignored</li>
                </ul>
            </p>

            <p>
                <code>types</code> is specified per hook as an array of tags.
                The tags are discovered through a set of heuristics by the
                <a href="https://github.com/chriskuehl/identify">identify</a>
                library.  <code>identify</code> was chosen as it is a small
                portable pure python library.
            </p>

            <p>
                Some of the common tags you'll find from identify:

                <ul>
                    <li><code>file</code></li>
                    <li><code>symlink</code></li>
                    <li><code>directory</code> - in the context of pre-commit this will be a submodule</li>
                    <li><code>executable</code> - whether the file has the executable bit set</li>
                    <li><code>text</code> - whether the file looks like a text file</li>
                    <li><code>binary</code> - whether the file looks like a binary file</li>
                    <li><a href="https://github.com/chriskuehl/identify/blob/master/identify/extensions.py">tags by extension / naming convention</a></li>
                    <li><a href="https://github.com/chriskuehl/identify/blob/master/identify/interpreters.py">tags by shebang (<code>#!</code>)</a></li>
                </ul>
            </p>

            <p>
                To discovery the type of any file on disk, you can use
                <code>identify</code>'s cli:

<pre>
$ identify-cli setup.py
["file", "non-executable", "python", "text"]
$ identify-cli some-random-file
["file", "non-executable", "text"]
$ identify-cli --filename-only some-random-file; echo $?
1
</pre>
            </p>

            <p>
                If a file extension you use is not supported, please
                <a href="https://github.com/chriskuehl/identify">submit a pull request</a>!
            </p>

            <p>
                <code>types</code> and <code>files</code> are evaluated with
                <code>AND</code> when filtering.  Tags within
                <code>types</code> are also evaluated using <code>AND</code>.
            </p>

            <p>
                For example:

<pre>
    files: ^foo/
    types: [file, python]
</pre>

                will match a file <code>foo/1.py</code> but will not match
                <code>setup.py</code>.
            </p>

            <p>
                Files can also be matched by shebang.  With
                <code>types: python</code>, <code>exe</code> starting with
                <code>#!/usr/bin/env python3</code> will also be matched.
            </p>

            <p>
                As with <code>files</code> and <code>exclude</code>, you can
                also exclude types if necessary using
                <code>exclude_types</code>.
            </p>

            <p>
                If you'd like to use <code>types</code> with compatibility for
                older versions
                <a href="https://github.com/pre-commit/pre-commit/pull/551#issuecomment-312535540">here is a guide to ensuring compatibility</a>.
            </p>

            <h2 id="regular-expressions">Regular expressions</h2>

            <p>
                The patterns for <code>files</code> and <code>exclude</code>
                are python
                <a href="https://docs.python.org/3/library/re.html#regular-expression-syntax">regular expressions</a>.
            </p>

            <p>
                As such, you can use any of the features that python regexes
                support.
            </p>

            <p>
                If you find that your regular expression is becoming unwieldy
                due to a long list of excluded / included things, you may find
                a
                <a href="https://docs.python.org/3/library/re.html#re.VERBOSE">verbose</a>
                regular expression useful.  One can enable this with yaml's
                multiline literals and the <code>(?x)</code> regex flag.

<pre>
# ...
    -   id: my-hook
        exclude: >
            (?x)^(
                path/to/file1.py|
                path/to/file2.py|
                path/to/file3.py
            )$
</pre>
            </p>

            <h2 id="overriding-language-version">Overriding Language Version</h2>
            <p>Sometimes you only want to run the hooks on a specific version of the language. For each language, they default to using the system installed language (So for example if I&rsquo;m running <code>python2.6</code> and a hook specifies <code>python</code>, pre-commit will run the hook using <code>python2.6</code>). Sometimes you don&rsquo;t want the default system installed version so you can override this on a per-hook basis by setting the <code>language_version</code>.</p>
<pre>
-   repo: git://github.com/pre-commit/mirrors-scss-lint
    sha: v0.54.0
    hooks:
    -   id: scss-lint
        language_version: 2.1.5
</pre>
            <p>This tells pre-commit to use ruby <code>2.1.5</code> to run the <code>scss-lint</code> hook.</p>
            <p>Valid values for specific languages are listed below:</p>
            <ul>
                <li>
                    python: Whatever system installed python interpreters you have. The value of this argument is passed as the <code>-p</code> to <code>virtualenv</code>.
                </li>
                <li>
                    node: See <a href="https://github.com/ekalinin/nodeenv#advanced">nodeenv</a>.
                </li>
                <li>
                    ruby: See <a href="https://github.com/sstephenson/ruby-build/tree/master/share/ruby-build">ruby-build</a>
                </li>
            </ul>

            <h2 id="usage-in-continuous-integration">Usage in Continuous Integration</h2>
            <p>
                pre-commit can also be used as a tool for continuous
                integration.  For instance, adding
                <code>pre-commit run --all-files</code> as a CI step will
                ensure everything stays in tip-top shape.
                To check only files which have changed, which may be faster, use something like
                <code>git diff-tree --no-commit-id --name-only -r $REVISION | xargs pre-commit run --files</code>.
            </p>
        </div>

        <div id="contributing">
            <div class="page-header">
                <h1>Contributing</h1>
            </div>
            <p>
                We&rsquo;re looking to grow the project and get more contributors especially to support more languages/versions. We&rsquo;d also like to get the .pre-commit-hooks.yaml files added to popular linters without maintaining forks / mirrors.
            </p>
            <p>Feel free to submit Bug Reports, Pull Requests, and Feature Requests.</p>
            <P>When submitting a pull request, please enable travis-ci for your fork.</p>

            <div class="page-header">
                <h1>Contributors</h1>
            </div>
            <ul>
                <li><a href="https://github.com/asottile">Anthony Sottile</a></li>
                <li><a href="https://github.com/struys">Ken Struys</a></li>
                <li><a href="https://github.com/mfnkl">Molly Finkle</a></li>
                <li><a href="https://github.com/guykisel">Guy Kisel</a></li>
                <li><a href="https://github.com/dupuy">Alexander Dupuy</a></li>
                <li><a href="https://github.com/Lucas-C">Lucas Cimon</a></li>
                <li><a href="https://github.com/caffodian">Alex Tsai</a></li>
                <li><a href="https://github.com/arahayrabedian">Ara Hayrabedian</a></li>
                <li><a href="https://github.com/meunierd">Devon Meunier</a></li>
                <li><a href="https://github.com/barrysteyn">Barry Steyn</a></li>
                <li><a href="https://github.com/blarghmatey">Tobias Macey</a></li>
                <li><a href="https://github.com/laurentsigal">Laurent Sigal</a></li>
                <li><a href="https://github.com/bpicolo">Ben Picolo</a></li>
            </ul>
        </div>
    </div>
</div>
