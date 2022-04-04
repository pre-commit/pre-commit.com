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
    =c= [`default_install_hook_types`](_#top_level-default_install_hook_types)
    =c= (optional: default `[pre-commit]`) a list of `--hook-type`s which will
        be used by default when running
        [`pre-commit install`](#pre-commit-install).

        _new in 2.18.0_
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
    =c= (optional) override the default file types to run on (AND).  See
        [Filtering files with types](#filtering-files-with-types).
=r=
    =c= [`types_or`](_#config-types_or)
    =c= (optional) override the default file types to run on (OR).  See
        [Filtering files with types](#filtering-files-with-types).
        _new in 2.9.0_.
=r=
    =c= [`exclude_types`](_#config-exclude_types)
    =c= (optional) file types to exclude.
=r=
    =c= [`args`](_#config-args)
    =c= (optional) list of additional parameters to pass to the hook.
=r=
    =c= [`stages`](_#config-stages)
    =c= (optional) confines the hook to the `commit`, `merge-commit`, `push`,
        `prepare-commit-msg`, `commit-msg`, `post-checkout`, `post-commit`,
        `post-merge`, `post-rewrite`, or `manual` stage.  See
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
    =c= (optional) if present, the hook output will additionally be written to
        a file when the hook fails or [verbose](#config-verbose) is `true`.
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
