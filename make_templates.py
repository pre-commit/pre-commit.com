from __future__ import absolute_import
from __future__ import unicode_literals

import io
import mako.lookup
import ordereddict
import simplejson


template_lookup = mako.lookup.TemplateLookup(
    directories=['.'],
)


ALL_TEMPLATES = ('index', 'hooks')


def get_env():
    all_hooks = simplejson.loads(
        io.open('all-hooks.json').read(),
        object_pairs_hook=ordereddict.OrderedDict,
    )

    return {'all_hooks': all_hooks}


def main():
    env = get_env()
    for template in ALL_TEMPLATES:
        env['template_name'] = template
        with io.open('{0}.html'.format(template), 'w') as html_file:
            template_obj = template_lookup.get_template(
                '{0}.mako'.format(template),
            )
            html_file.write(template_obj.render(**env))


if __name__ == '__main__':
    exit(main())
