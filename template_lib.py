import re

import markdown_code_blocks
import markupsafe


ID_RE = re.compile(r'\[\]\(#([a-z0-9-]+)\)')
SPECIAL_CHARS_RE = re.compile('[^a-z0-9 _-]')


class Renderer(markdown_code_blocks.CodeRenderer):
    def header(self, text, level, raw=None):
        match = ID_RE.search(raw)
        if match:
            h_id = match.group(1)
        else:
            h_id = SPECIAL_CHARS_RE.sub('', raw.lower()).replace(' ', '-')
        return (
            f'<h{level} id="{h_id}">'
            f'    {text} <small><a href="#{h_id}">¶</a></small>'
            f'</h{level}> '
        )


def md(s):
    html = markdown_code_blocks.highlight(s, Renderer=Renderer)
    # manually bless the highlighted output.
    return markupsafe.Markup(html)
