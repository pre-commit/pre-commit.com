## -*- coding: utf-8 -*-
<%inherit file="base.mako" />

<div class="page-header"><h1>Supported hooks</h1></div>

<p>
To add to this list, fork <a href="https://github.com/pre-commit/pre-commit.github.io">this repository</a>.
</p>

<p>
Also available in <a href="/all-hooks.json">json</a>.
</p>

% for repository, hooks in all_hooks.items():
    <h3>
        <a href="${repository}" target="_blank">
            ${repository.replace('https://', '')}
        </a>
    </h3>
    <ul>
        % for hook_dict in hooks:
            <li>
                <code>${hook_dict['id']}</code>
                % if 'description' in hook_dict:
                    - ${hook_dict['description']}
                % elif hook_dict['name'].lower() != hook_dict['id'].lower():
                    - ${hook_dict['name']}
                % endif
            </li>
        % endfor
    </ul>
% endfor
