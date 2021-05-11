## -*- coding: utf-8 -*-
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <link rel="shortcut icon" type="image/x-icon" href="favicon.ico">

        <link rel="stylesheet" href="build/main_bs5.css">

        <title>pre-commit</title>
    </head>
    <body data-bs-spy="scroll" data-bs-target="#content-navigation">
        <nav class="navbar navbar-expand-md navbar-dark bg-primary">
            <div class="container-md">
                <a class="navbar-brand" href="/">
                    <img src="logo.svg" width="55" height="55" alt="" loading="lazy">
                </a>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbar" aria-controls="navbar" aria-expanded="false" >
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbar">
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a class="nav-link${' active' if template_name == 'index' else ''}" href="index.html">Documentation</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link${' active' if template_name == 'hooks' else ''}" href="hooks.html">Supported hooks</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="https://github.com/pre-commit/demo-repo#readme">Demo</a>
                        </li>
                    </ul>

                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a href="https://github.com/pre-commit/pre-commit" role="button" class="btn btn-outline-info my-2 my-sm-0">Download on GitHub</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        % if template_name == 'index':
        <header class="bg-light">
            <div class="container-md py-4 py-lg-0">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="display-5 pb-3 text-secondary fw-bold">pre-commit</h1>
                        <p class="lead text-white">
                            A framework for managing and maintaining multi-language <span class="text-nowrap">pre-commit</span> hooks.
                        </p>
                        <div class="mb-3">
                            <a href="https://dev.azure.com/asottile/asottile/_build/latest?definitionId=21&branchName=master">
                                <img src="https://dev.azure.com/asottile/asottile/_apis/build/status/pre-commit.pre-commit?branchName=master" alt="Build Status" style="max-width:100%;">
                            </a>
                            <a href="https://dev.azure.com/asottile/asottile/_build/latest?definitionId=21&branchName=master">
                                <img src="https://img.shields.io/azure-devops/coverage/asottile/asottile/21/master.svg" alt="Azure DevOps Coverage" style="max-width:100%;">
                            </a>
                            <a href="https://results.pre-commit.ci/latest/github/pre-commit/pre-commit/master">
                                <img src="https://results.pre-commit.ci/badge/github/pre-commit/pre-commit/master.svg" alt="pre-commit.ci status" style="max-width:100%;">
                            </a>
                        </div>
                        <div>
                            ## https://buttons.github.io/
                            <a class="github-button" href="https://github.com/pre-commit/pre-commit" data-show-count="true" aria-label="Star pre-commit/pre-commit on GitHub">Star</a>
                            <script async defer src="https://buttons.github.io/buttons.js"></script>

                            ## https://developer.twitter.com/en/docs/twitter-for-websites/tweet-button/overview
                            <a href="https://twitter.com/share" class="twitter-share-button" data-url="https://pre-commit.com" data-text="pre-commit - A framework for managing and maintaining multi-language pre-commit hooks.">Tweet</a>
                            <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
                        </div>
                    </div>
                    <img src="logo-top-shelf.png" alt="pre-commit logo" class="d-none d-lg-block"></img>
                </div>
            </div>
        </header>
        % endif

        <main class="container-md my-4">
            ${self.body()}
        </main>

        <footer class="navbar navbar-expand navbar-dark bg-primary">
            <div class="container-md">&nbsp;</div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-p34f1UUtsS3wqzfto5wAAmdvj+osOnFyQFpp4Ua3gs/ZVWx6oOypYoCJhGGScy+8" crossorigin="anonymous"></script>
        <script>
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
            ga('create', 'UA-104682927-1', 'auto');
            ga('send', 'pageview');
        </script>
        <script src="assets/copyable.js"></script>
    </body>
</html>
