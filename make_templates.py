from __future__ import absolute_import
from __future__ import unicode_literals

import io
import os.path

import mako.lookup
import ordereddict
import simplejson


template_lookup = mako.lookup.TemplateLookup(
    directories=['.'],
    default_filters=['html_escape'],
    imports=['from mako.filters import html_escape'],
)


ALL_TEMPLATES = [
    filename for filename in os.listdir('.')
    if filename.endswith('.mako') and filename != 'base.mako'
]


def get_env():
    all_hooks = simplejson.loads(
        io.open('all-hooks.json').read(),
        object_pairs_hook=ordereddict.OrderedDict,
    )

    return {'all_hooks': all_hooks}


def main():
    env = get_env()
    for template in ALL_TEMPLATES:
        template_name, _ = os.path.splitext(template)
        env['template_name'] = template_name
        with io.open('{0}.html'.format(template_name), 'w') as html_file:
            template_obj = template_lookup.get_template(template)
            html_file.write(template_obj.render(**env))


if __name__ == '__main__':
    exit(main())
