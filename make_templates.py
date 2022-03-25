from __future__ import annotations

import collections
import json
import os.path
from typing import Any
from typing import Dict

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


ALL_TEMPLATES = [
    filename for filename in os.listdir('.')
    if filename.endswith('.mako') and filename != 'base.mako'
]


def get_env() -> dict[str, Any]:
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
    body = markupsafe.Markup().join(body_parts)

    all_hooks = json.loads(
        open('all-hooks.json').read(),
        object_pairs_hook=collections.OrderedDict,
    )
    all_types = {
        hook_type
        for properties in all_hooks.values()
        for hook_type in (
            properties[0].get('types', []) + properties[0].get('types_or', [])
        )
    }
    return {'all_hooks': all_hooks, 'all_types': all_types, 'body': body}


def main() -> int:
    env = get_env()
    for template in ALL_TEMPLATES:
        template_name, _ = os.path.splitext(template)
        env['template_name'] = template_name
        with open(f'{template_name}.html', 'w') as html_file:
            template_obj = template_lookup.get_template(template)
            html_file.write(template_obj.render(**env))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
