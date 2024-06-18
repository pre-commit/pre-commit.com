from __future__ import annotations

import os.path

import mako.lookup
import markupsafe

from template_lib import md

SECTIONS = (
    ('Introduction', 'sections/intro.md'),
    ('Installation', 'sections/install.md'),
    ('Adding pre-commit plugins to your project', 'sections/plugins.md'),
    ('Usage', 'sections/usage.md'),
    ('Creating new hooks', 'sections/new-hooks.md'),
    ('Command line interface', 'sections/cli.md'),
    ('Advanced features', 'sections/advanced.md'),
    ('Contributing', 'sections/contributing.md'),
)


template_lookup = mako.lookup.TemplateLookup(
    directories=['.'],
    default_filters=['html_escape'],
    imports=['from mako.filters import html_escape'],
)


def index_body() -> markupsafe.Markup:
    body_parts = []
    for title, filename in SECTIONS:
        div_id, _ = os.path.splitext(os.path.basename(filename))
        title_rendered = md(f'# {title}')
        with open(filename) as f:
            rendered = md(f.read())
        body_parts.append(
            markupsafe.Markup(
                f'<div id="{div_id}">\n'
                f'    <div class="page-header">{title_rendered}</div>\n'
                f'    {rendered}\n'
                f'</div>\n',
            ),
        )
    return markupsafe.Markup().join(body_parts)


def hooks_body() -> markupsafe.Markup:
    with open('sections/hooks.md') as f:
        return md(f.read())


def main() -> int:
    with open('index.html', 'w') as f:
        tmpl = template_lookup.get_template('index.mako')
        f.write(tmpl.render(body=index_body(), template_name='index'))

    with open('hooks.html', 'w') as f:
        tmpl = template_lookup.get_template('hooks.mako')
        f.write(tmpl.render(body=hooks_body(), template_name='hooks'))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
