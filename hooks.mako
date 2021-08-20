## -*- coding: utf-8 -*-
<%inherit file="base.mako" />

<div class="page-header"><h1>Supported hooks</h1></div>

<div class="row mb-4">
    <div class="col">
        <label for="search-hook-id" class="mb-2">Filter hook id:</label>
        <input id="search-hook-id" type="text" placeholder="filter hook id" class="form-control form-control-sm"></input>
    </div>
    <div class="col">
        <label for="search-hook-id" class="mb-2">Filter hook type:</label>
        <select id="select-hook-type" class="form-select form-select-sm">
            <option value="">--</option>
            % for hook_type in sorted(all_types, key=str.lower):
                <option value="${hook_type}">${hook_type}</option>
            % endfor
        </select>
    </div>
</div>

<p>
To add your own hooks to this list, fork <a href="https://github.com/pre-commit/pre-commit.com">this repository</a>.
The name of your repository should not suggest that it is affiliated with the
`pre-commit` project. Avoid names such as `pre-commit-XXX` for example.
</p>

<p>
Also available in <a href="/all-hooks.json">json</a>.
</p>

<div id="hooks">
% for repository, hooks in all_hooks.items():
    <h3 data-repo="${repository}">
        <a href="${repository}" target="_blank">
            ${repository.replace('https://', '')}
        </a>
    </h3>
    <ul data-repo="${repository}">
        % for hook_dict in hooks:
            <li data-id="${hook_dict['id']}" data-types="${', '.join(hook_dict.get('types', []) + hook_dict.get('types_or', []))}">
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
</div>

<script src="assets/filter_repos.js"></script>
