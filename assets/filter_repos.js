'use strict';

(() => {
    const searchInput = document.getElementById('search-hook-id');
    const selectInput = document.getElementById('select-hook-type');

    const hooks = document.getElementById('hooks');
    const repos = hooks.getElementsByTagName('ul');

    const filterHooks = () => {
        const id = searchInput.value.toLowerCase();
        const type = selectInput.value;

        for (let i = 0; i < repos.length; i += 1) {
            const repo = repos[i];
            let hasVisibleHooks = false;
            const repoHooks = repo.getElementsByTagName('li');

            if (repoHooks) {
                for (let j = 0; j < repoHooks.length; j += 1) {
                    const repoHook = repoHooks[j];
                    const hookId = repoHook.dataset.id.toLowerCase();
                    const hookTypes = repoHook.dataset.types.split(', ');

                    if (
                        hookId.includes(id) &&
                        (type === '' || hookTypes.includes(type))
                    ) {
                        repoHook.hidden = false;
                        hasVisibleHooks = true;
                    } else {
                        repoHook.hidden = true;
                    }
                }
            }

            repo.hidden = !hasVisibleHooks;
            hooks.querySelector(`h3[data-repo="${repo.dataset.repo}"]`).hidden =
                !hasVisibleHooks;
        }
    };

    searchInput.addEventListener('input', filterHooks);
    selectInput.addEventListener('change', filterHooks);
})();
