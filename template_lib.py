import markdown_code_blocks
import markupsafe


def md(s):
    # manually bless the highlighted output.
    return markupsafe.Markup(markdown_code_blocks.highlight(s))
