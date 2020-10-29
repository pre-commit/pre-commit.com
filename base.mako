## -*- coding: utf-8 -*-
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link href="//fonts.googleapis.com/css?family=Source+Sans+Pro:400,700" rel="stylesheet" type="text/css">
        <link rel="stylesheet" type="text/css" href="build/main.css">
        <link rel="icon" href="favicon.ico">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>pre-commit</title>
    </head>
    <body class="page-${template_name}" data-spy="scroll" data-target=".pc-sidebar">
        <header class="navbar navbar-default pc-nav" role="banner">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".pc-navbar-collapse">
                        <span class="sr-only">Toggle navigtaion</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a href="/" class="navbar-brand pc-navbar-brand">
                        <i class="logo"></i>
                    </a>
                </div>
                <nav class="navbar-collapse pc-navbar pc-navbar-collapse collapse" role="navigation">
                    <ul class="nav navbar-nav">
                        <li><a href="/">Documentation</a></li>
                        <li><a href="hooks.html">Supported hooks</a></li>
                        <li><a href="https://github.com/pre-commit/demo-repo#readme">Demo</a></li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="https://github.com/pre-commit/pre-commit" class="btn btn-default">Download on GitHub</a></li>
                    </ul>
                </nav>
            </div>
        </header>
        <div class="top-shelf">
            <div class="container">
                <img class="pc-logo-top-shelf hidden-xs hidden-sm" src="logo-top-shelf.png">
                <h1>
                    <a href="https://github.com/pre-commit/pre-commit">
                        pre-commit
                    </a>
                </h1>
                <p>A framework for managing and maintaining multi-language <span class="nowrap">pre-commit</span> hooks.</p>
           <p><a href="https://dev.azure.com/asottile/asottile/_build/latest?definitionId=21&branchName=master"><img src="https://dev.azure.com/asottile/asottile/_apis/build/status/pre-commit.pre-commit?branchName=master" alt="Build Status" style="max-width:100%;"></a>
<a href="https://dev.azure.com/asottile/asottile/_build/latest?definitionId=21&branchName=master"><img src="https://img.shields.io/azure-devops/coverage/asottile/asottile/21/master.svg" alt="Azure DevOps Coverage" style="max-width:100%;"></a>
<a href="https://results.pre-commit.ci/latest/github/pre-commit/pre-commit/master"><img src="https://results.pre-commit.ci/badge/github/pre-commit/pre-commit/master.svg" alt="pre-commit.ci status" style="max-width:100%;"></a></p>
            <p><iframe src="https://ghbtns.com/github-btn.html?user=pre-commit&amp;repo=pre-commit&amp;type=watch&amp;count=true"
  allowtransparency="true" frameborder="0" scrolling="0" width="104px" height="20"></iframe>
<a href="https://twitter.com/share" class="twitter-share-button" data-url="https://pre-commit.com" data-text="pre-commit - A framework for managing and maintaining multi-language pre-commit hooks.">Tweet</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script></p>
        </div>
        </div>
        <div class="container pc-main-content">
            ${self.body()}
        </div>
        <footer class="pc-footer"><div class="container"></div></footer>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="node_modules/bootstrap-sass/assets/javascripts/bootstrap.min.js"></script>
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
