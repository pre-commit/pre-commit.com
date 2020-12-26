## -*- coding: utf-8 -*-
<%inherit file="base.mako" />

<div class="page-header"><h1>Supported hooks</h1></div>

<div class="form-row">
    <div class="col form-group">
        <label for="search-hook-id">Filter hook id:</label>
        <input id="search-hook-id" type="text" placeholder="filter hook id" class="form-control form-control-sm"></input>
    </div>
    <div class="col form-group">
        <label for="search-hook-id">Filter hook type:</label>
        <select id="select-hook-type" class="form-control form-control-sm">
            <option value="">--</option>
            % for hook_type in sorted(all_types, key=str.lower):
                <option value="${hook_type}">${hook_type}</option>
            % endfor
        </select>
    </div>
</div>

<p>
To add to this list, fork <a href="https://github.com/pre-commit/pre-commit.com">this repository</a>.
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
