## -*- coding: utf-8 -*-
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link href="//fonts.googleapis.com/css?family=Source+Sans+Pro:400,700" rel="stylesheet" type="text/css">
        <link rel="stylesheet" type="text/css" href="build/main.css">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>pre-commit by Yelp</title>
    </head>
    <body data-spy="scroll" data-target=".pc-sidebar">
        <header class="navbar navbar-default pc-nav" role="banner">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".pc-navbar-collapse">
                        <span class="sr-only">Toggle navigtaion</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a href="index.html" class="navbar-brand pc-navbar-brand">
                        <i class="logo"></i>
                    </a>
                </div>
                <nav class="navbar-collapse pc-navbar pc-navbar-collapse collapse" role="navigation">
                    <ul class="nav navbar-nav">
                        <li><a href="index.html">Documentation</a></li>
                        <li><a href="hooks.html">Supported hooks</a></li>
                        <li><a href="https://github.com/pre-commit/demo-repo#readme">Demo</a></li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="https://github.com/pre-commit/pre-commit" class="btn btn-default">Download on Github</a></li>
                    </ul>
                </nav>
            </div>
        </header>
        <div class="top-shelf">
            <div class="container">
                <img class="pc-darwin hidden-xs" src="pre-commit-darwin.png">
                <h1>
                    <a href="http://github.com/pre-commit/pre-commit">
                        pre-commit
                        <span class="nowrap">by Yelp</span>
                    </a>
                </h1>
                <p>A framework for managing and maintaining multi-language <span class="nowrap">pre-commit</span> hooks.</p>
           <p><a href="https://travis-ci.org/pre-commit/pre-commit"><img src="https://camo.githubusercontent.com/ea0ef9a42d3a39bf0a55b3f5d7d7a6fa5254bd01/68747470733a2f2f7472617669732d63692e6f72672f7072652d636f6d6d69742f7072652d636f6d6d69742e7376673f6272616e63683d6d6173746572" alt="Build Status" data-canonical-src="https://travis-ci.org/pre-commit/pre-commit.svg?branch=master" style="max-width:100%;"></a>
<a href="https://coveralls.io/r/pre-commit/pre-commit"><img src="https://camo.githubusercontent.com/aabc8c9324e9f816adc399bc2b29ca98e781a71e/68747470733a2f2f696d672e736869656c64732e696f2f636f766572616c6c732f7072652d636f6d6d69742f7072652d636f6d6d69742e7376673f6272616e63683d6d6173746572" alt="Coverage Status" data-canonical-src="https://img.shields.io/coveralls/pre-commit/pre-commit.svg?branch=master" style="max-width:100%;"></a></p>
           </div>
        </div>
        <div class="container pc-main-content">
            <div class="row">${self.body()}</div>
        </div>
        <footer class="pc-footer">
            <div class="container">
                Brought to you by <a href="http://www.yelp.com">Yelp</a>.
            </div>
        </footer>
        <script src="bower_components/jquery/jquery.min.js"></script>
        <script src="bower_components/bootstrap-sass/dist/js/bootstrap.min.js"></script>
        <script>
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

            ga('create', 'UA-53969031-1', 'auto');
            ga('send', 'pageview');
        </script>
    </body>
</html>
