from __future__ import annotations

import html
import os
import re
import shlex
import subprocess
import sys

import markdown_code_blocks
import markupsafe


ID_RE = re.compile(r' #([a-z0-9-]+)$')
SPECIAL_CHARS_RE = re.compile('[^a-z0-9 _-]')


ROW = '=r='
COL = '    =c= '
INDENT = ' ' * 8


def _render_table(code: str) -> str:
    """Renders our custom "table" type

    ```table
    =r=
        =c= col1
        =c= col2
    =r=
        =c= col3
        =c= col4
    ```

    renders to

    <table class="table table-bordered">
        <tbody>
            <tr><td>col1</td><td>col2</td></tr>
            <tr><td>col3</td><td>col4</td></tr>
        </tbody>
    </table>
    """
    output = ['<table class="table table-bordered"><tbody>']
    in_row = False
    col_buffer = None

    def _maybe_end_col() -> None:
        nonlocal col_buffer
        if col_buffer is not None:
            output.append(f'<td>{md(col_buffer)}</td>')
            col_buffer = None

    def _maybe_end_row() -> None:
        nonlocal in_row
        if in_row:
            output.append('</tr>')
            in_row = False

    for line in code.splitlines(True):
        if line.startswith(ROW):
            _maybe_end_col()
            _maybe_end_row()
            in_row = True
            output.append('<tr>')
        elif line.startswith(COL):
            _maybe_end_col()
            col_buffer = line.removeprefix(COL)
        elif col_buffer is not None:
            if line == '\n':
                col_buffer += line
            else:
                assert line.startswith(INDENT), line
                col_buffer += line.removeprefix(INDENT)
        else:
            raise AssertionError(line)

    _maybe_end_col()
    _maybe_end_row()
    output.append('</tbody></table>')
    return ''.join(output)


def _render_cmd(code: str) -> str:
    cmdstr = code.strip()
    path = f'{os.path.dirname(sys.executable)}{os.pathsep}{os.environ["PATH"]}'
    env = {**os.environ, 'PATH': path}
    output = subprocess.check_output(shlex.split(cmdstr), env=env).decode()
    return str(md(f'```pre-commit\n$ {cmdstr}\n{output}```'))


class Renderer(markdown_code_blocks.CodeRenderer):
    def link(
        self, link: str, text: str | None, title: str | None,
    ) -> str:
        if link.startswith('_#'):
            a_id = link.removeprefix('_#')
            return f'<a id="{a_id}" href="#{a_id}">{text}</a>'
        elif link.startswith('__#'):
            return f'<a name="{link.removeprefix("__#")}"></a>'
        else:
            return super().link(link, text, title)

    def heading(self, text: str, level: int) -> str:
        match = ID_RE.search(text)
        text = ID_RE.sub('', text)
        if match:
            h_id = match[1]
        else:
            h_id = SPECIAL_CHARS_RE.sub('', text.lower()).replace(' ', '-')
        return (
            f'<h{level} id="{h_id}">'
            f'    {text} <small><a href="#{h_id}" class="text-decoration-none">¶</a></small>'  # noqa: E501
            f'</h{level}> '
        )

    def codespan(self, text: str) -> str:
        if text.startswith('<kbd>'):
            # we trust this content
            return text
        else:
            return super().codespan(text)

    def image(
            self,
            src: str,
            alt: str = '',
            title: str | None = None,
    ) -> str:
        return (
            f'<img '
            f'    src="{html.escape(src)}"'
            f'    alt="{html.escape(alt)}"'
            f'    class="img-fluid img-thumbnail"'
            f'>'
        )

    def block_code(self, code: str, info: str | None = None) -> str:
        copyable = False
        if info is not None:
            copyable_s = '#copyable'
            copyable = info.endswith(copyable_s)
            info, _, _ = info.partition(copyable_s)
        if info == 'table':
            ret = _render_table(code)
        elif info == 'cmd':
            ret = _render_cmd(code)
        else:
            ret = super().block_code(code, info)
        if copyable:
            return f'<div class="copyable">{ret}</div>'
        else:
            return ret


def md(s: str) -> str:
    html = markdown_code_blocks.highlight(s, Renderer=Renderer)
    # manually bless the highlighted output.
    return markupsafe.Markup(html)
