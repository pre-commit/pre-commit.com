Introduction
------------

At Yelp we rely heavily on pre commit hooks to find and fix common
issues before changes are submitted to Code Review. We run our hooks before
every commit to automatically point out issues like missing semicolons,
whitespace problems and debug statements in code. Automatically fixing these
issues before posting code reviews allow our code reviewer to pay attention to
architecture of a change and not worry about trivial errors.

As we created more libraries and projects we recognized that sharing our pre
commit hooks across projects is painful. We copied and pasted bash scripts from
project to project. We also had to manually change the hooks to work for
different project structures.

We also believe that you should always use the best industry standard linters.
Some of the best linters are written in languages that you do not use in your
project or have installed on your machine. For example scss-lint is a linter
for SASS written in ruby. If you're writing a project in node you should be able
to use scss-lint as a pre commit hook without adding a Gemfile to your project
or understanding how to get scss-lint installed.

We built pre-commit to solve our hook issues. pre-commit is a multi-language
package manager for pre commit hooks. You specify a list of hooks you want
and pre-commit manages the installation and execution of any hook written in any
language on before every commit. pre-commit is specifically designed to not
require root access; if one of your developers doesn't have node installed but
modifies a javascript file, pre-commit automatically handles downloading and
building node to run jshint without root access.

Installation
------------

Before you can run hooks, you need to have the pre-commit package manager
installed.

Non Administrative Installation

curl https://pre-commit.github.io/install.sh && ./install.sh

System Level Install (requires root)

curl https://pre-commit.github.io/root_install.sh && sudo ./root_install.sh

In a Python Project

Add the following to your requirements.txt:

git+git://github.com/pre-commit/pre-commit#egg=pre-commit


Adding pre-commit Plugins To Your Project
------------

Once you have pre-commit installed, adding pre-commit plugins to your project is
done with the .pre-commit-config.yaml configuration file.

Add a file called .pre-commit-config.yaml to the root of your project. The
pre-commit config file describes:
- where to get plugins (git repos)
- what plugins from the repo you want to use (pre-commit id)
- what files you want to run the plugin on

For example:

-   repo: git@github.com:pre-commit/pre-commit-hooks
    sha: 82344a4055f4e103afdc31e98a46de679fe55385
    hooks:
    -   id: trailing-whitespace
        files: \.(py|js|css)$

This configuration says to download the pre-commit-hooks project and run it's
trailing whitespace fixer on all python, JavaScript and CSS files.

Usage
------------

run `pre-commit install` to install pre-commit into your git hooks. pre-commit
will now run on every commit.

If you want to manually run all pre-commit hooks on a repository, run
`pre-commit run --all-files`. To run individual hooks use
`pre-commit run <hook_id>`

The first time pre-commit runs on a file it will automatically download, install
and run the hook. Note that running a hook for the first time may be slow. If
the machine does not have node installed, pre-commit will download and build a
copy of node.



Creating New pre-commit Hooks
------------

pre-commit currently supports hooks written in JavaScript (node), Python, Ruby
and Bash. As long as your git repo is an installable package (gem, npm, pypi,
etc) or exposes a executable, it can be used with pre-commit. Each git repo can
support as many languages/hooks as you want.

A git repo containing pre-commit plugins must contain a hooks.yaml file that
tells pre-commit:
- The id of the hook - used in pre-commit-config.yaml
- The name of the hook - shown during hook execution
- The description of the hook
- The entry point - The executable to run
- The language of the hook - tells pre-commit how to install the hook

For example:

-   id: trailing-whitespace
    name: Trim Trailing Whitespace
    description: This hook trims trailing whitespace.
    entry: trailing-whitespace-fixer
    language: python


Popular Plugins
------------

JSHint

-   repo: git@github.com:pre-commit/jshint
    sha: 191734354d1191e3771c004c3e905a94728d0349
    hooks:
    - id: jshint
    - files: \.js

SCSS-Lint

-   repo: git@github.com:pre-commit/scss-lint
    sha: 425536b1b77d9e836068edde4fb3101bea6e7dd8
    hooks:
    - id: jshint
    - files: \.js

Whitespace Fixers

-   repo: git@github.com:pre-commit/pre-commit-hooks
    sha: ca93f6834f2afc8a8f7de46c0e02076419077c7a
    hooks:
    -   id: trailing-whitespace
        files: \.(py|js|scss|css|sh|yaml)$
    -   id: end-of-file-fixer
        files: \.(py|js|scss|css|sh|yaml)$

flake8

-   repo: git@github.com:pre-commit/pre-commit-hooks
    sha: ca93f6834f2afc8a8f7de46c0e02076419077c7a
    hooks:
    -   id: flake8
        files: \.py$
        args: [--max-line-length=131]

Contributing
------------

We're definitely looking to grow the project and get more contributors especially
for more languages/versions. We'd like like to get the hooks.yaml files added to
popular linters.

Feel free to submit Bug Reports, Pull Requests and Feature Requests.

Contributors
------------

Anthony Sottile
Ken Struys
