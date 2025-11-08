## featured hooks

here are a few hand-picked repositories which provide pre-commit integrations.

these are fairly popular and are generally known to work well in most setups!

_this list is not intended to be exhaustive_

provided by the pre-commit team:
- [pre-commit/pre-commit-hooks]: a handful of language-agnostic hooks which
  are universally useful!
- [pre-commit/pygrep-hooks]: a few quick regex-based hooks for a handful of
  quick syntax checks
- [pre-commit/sync-pre-commit-deps]: sync pre-commit hook dependencies based
  on other installed hooks
- [pre-commit/mirrors-*]: pre-commit mirrors of a handful of popular tools

[pre-commit/pre-commit-hooks]: https://github.com/pre-commit/pre-commit-hooks
[pre-commit/pygrep-hooks]: https://github.com/pre-commit/pygrep-hooks
[pre-commit/sync-pre-commit-deps]: https://github.com/pre-commit/sync-pre-commit-deps
[pre-commit/mirrors-*]: https://github.com/orgs/pre-commit/repositories?language=&q=%22mirrors-%22+archived%3AFalse&sort=

for python projects:
- [asottile/pyupgrade]: automatically upgrade syntax for newer versions of the
  language
- [asottile/(others)]: a few other repos by the pre-commit creator
- [psf/black]: The uncompromising Python code formatter
- [hhatto/autopep8]: automatically fixes PEP8 violations
- [astral-sh/ruff-pre-commit]: the ruff linter and formatter for python
- [google/yapf]: a highly configurable python formatter
- [PyCQA/flake8]: a linter framework for python
- [PyCQA/isort]: an import sorter for python
- [PyCQA/(others)]: a few other python code quality tools
- [adamchainz/django-upgrade]: automatically upgrade your Django project code

[asottile/pyupgrade]: https://github.com/asottile/pyupgrade
[asottile/(others)]: https://sourcegraph.com/search?q=context:global+file:%5E%5C.pre-commit-hooks%5C.yaml%24+repo:%5Egithub.com/asottile/
[psf/black]: https://github.com/psf/black
[hhatto/autopep8]: https://github.com/hhatto/autopep8
[astral-sh/ruff-pre-commit]: https://github.com/astral-sh/ruff-pre-commit
[google/yapf]: https://github.com/google/yapf
[PyCQA/flake8]: https://github.com/PyCQA/flake8
[PyCQA/isort]: https://github.com/PyCQA/isort
[PyCQA/(others)]: https://sourcegraph.com/search?q=context:global+file:%5E%5C.pre-commit-hooks%5C.yaml%24+repo:%5Egithub.com/PyCQA/
[adamchainz/django-upgrade]: https://github.com/adamchainz/django-upgrade

for shell scripts:
- [shellcheck-py/shellcheck-py]: runs shellcheck on your scripts
- [openstack/bashate]: code style enforcement for bash programs

[shellcheck-py/shellcheck-py]: https://github.com/shellcheck-py/shellcheck-py
[openstack/bashate]: https://github.com/openstack/bashate

for the web:
- [biomejs/pre-commit]: a fast formatter / fixer written in rust
- [standard/standard]: linter / fixer
- [shssoichiro/oxipng]: optimize png files

[biomejs/pre-commit]: https://github.com/biomejs/pre-commit
[standard/standard]: https://github.com/standard/standard
[shssoichiro/oxipng]: https://github.com/shssoichiro/oxipng

for configuration files:
- [python-jsonschema/check-jsonschema]: check many common configurations with jsonschema
- [rhysd/actionlint]: lint your GitHub Actions workflow files
- [google/yamlfmt]: a formatter for yaml files
- [adrienverge/yamllint]: a linter for YAML files

[python-jsonschema/check-jsonschema]: https://github.com/python-jsonschema/check-jsonschema
[rhysd/actionlint]: https://github.com/rhysd/actionlint
[google/yamlfmt]: https://github.com/google/yamlfmt
[adrienverge/yamllint]: https://github.com/adrienverge/yamllint

for text / docs / prose:
- [crate-ci/typos]: find and fix common typographical errors
- [thlorenz/doctoc]: generate a table-of-contents in markdown files
- [amperser/proselint]: A linter for prose.
- [markdownlint/markdownlint]: a Markdown lint tool in Ruby
- [DavidAnson/markdownlint-cli2]: a Markdown lint tool in Node
- [codespell-project/codespell]: check code for common misspellings

[crate-ci/typos]: https://github.com/crate-ci/typos
[thlorenz/doctoc]: https://github.com/thlorenz/doctoc
[amperser/proselint]: https://github.com/amperser/proselint
[markdownlint/markdownlint]: https://github.com/markdownlint/markdownlint
[DavidAnson/markdownlint-cli2]: https://github.com/DavidAnson/markdownlint-cli2
[codespell-project/codespell]: https://github.com/codespell-project/codespell

for linting commit messages:
- [jorisroovers/gitlint]
- [commitizen-tools/commitizen]

[jorisroovers/gitlint]: https://github.com/jorisroovers/gitlint
[commitizen-tools/commitizen]: https://github.com/commitizen-tools/commitizen

for secret scanning / security:
- [gitleaks/gitleaks]
- [trufflesecurity/truffleHog]
- [thoughtworks/talisman]

[gitleaks/gitleaks]: https://github.com/gitleaks/gitleaks
[trufflesecurity/truffleHog]: https://github.com/trufflesecurity/truffleHog
[thoughtworks/talisman]: https://github.com/thoughtworks/talisman

for other programming languages:
- [realm/SwiftLint]: enforce Swift style and conventions
- [nicklockwood/SwiftFormat]: a formatter for Swift
- [AleksaC/terraform-py]: format and validate terraform syntax
- [rubocop/rubocop]: static analysis and formatting for Ruby
- [bufbuild/buf]: tooling for Protocol Buffers
- [sqlfluff/sqlfluff]: a modular linter and auto formatter for SQL
- [aws-cloudformation/cfn-lint]: aws CloudFormation linter
- [google/go-jsonnet]: linter / formatter for jsonnet
- [JohnnyMorganz/StyLua]: an opinionated Lua code formatter
- [Koihik/LuaFormatter]: a formatter for Lua code
- [mrtazz/checkmake]: linter for Makefile syntax
- [nbqa-dev/nbqa]: run common linters on Jupyter Notebooks

[realm/SwiftLint]: https://github.com/realm/SwiftLint
[nicklockwood/SwiftFormat]: https://github.com/nicklockwood/SwiftFormat
[AleksaC/terraform-py]: https://github.com/AleksaC/terraform-py
[rubocop/rubocop]: https://github.com/rubocop/rubocop
[bufbuild/buf]: https://github.com/bufbuild/buf
[sqlfluff/sqlfluff]: https://github.com/sqlfluff/sqlfluff
[aws-cloudformation/cfn-lint]: https://github.com/aws-cloudformation/cfn-lint
[google/go-jsonnet]: https://github.com/google/go-jsonnet
[JohnnyMorganz/StyLua]: https://github.com/JohnnyMorganz/StyLua
[Koihik/LuaFormatter]: https://github.com/Koihik/LuaFormatter
[mrtazz/checkmake]: https://github.com/mrtazz/checkmake
[nbqa-dev/nbqa]: https://github.com/nbQA-dev/nbQA

## finding hooks

it's recommended to use your favorite searching tool to find existing hooks to
use in your project.

for example, here's some searches you may find useful using [sourcegraph]:

- hooks which run on python files: [`file:^\.pre-commit-hooks\.yaml$ "types: [python]"`](https://sourcegraph.com/search?q=context:global+file:^\.pre-commit-hooks\.yaml%24+%22types:+[python]%22)
- hooks which run on shell files: [`file:^\.pre-commit-hooks\.yaml$ "types: [shell]"`](https://sourcegraph.com/search?q=context:global+file:^\.pre-commit-hooks\.yaml%24+"types:+[shell]")
- pre-commit configurations in popular projects: [`file:^\.pre-commit-config\.yaml$`](https://sourcegraph.com/search?q=context:global+file:^\.pre-commit-hooks\.yaml)

[sourcegraph]: https://sourcegraph.com/search

you may also find [github's search] useful as well, though its querying and
sorting capabilities are quite limited plus it requires a login:

- repositories providing hooks: [`path:.pre-commit-hooks.yaml language:YAML`](https://github.com/search?q=path%3A.pre-commit-hooks.yaml+language%3AYAML&type=code&l=YAML)

[github's search]: https://github.com/search


## adding to this page

the previous iteration of this page was a laundry list of hooks and maintaining
quality of the listed tools was cumbersome.

**this page is not intended to be exhaustive**

you may send [a pull request] to expand this list however there are a few
requirements you *must* follow or your PR will be closed without comment:

- the tool must already be fairly popular (>500 stars)
- the tool must use a managed language (no `unsupported` / `unsupported_script` / `docker` hooks)
- the tool must operate on files

[a pull request]: https://github.com/pre-commit/pre-commit.com/blob/main/sections/hooks.md
