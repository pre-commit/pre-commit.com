#!/bin/bash

[ "$TRAVIS_BRANCH" == "real_master" -a "$TRAVIS_PULL_REQUEST" == "false" ] || exit

git clone "https://${GH_TOKEN}@$github.com/${TRAVIS_REPO_SLUG}" out >& /dev/null
cd out
git checkout master
git config user.name "Travis-CI"
git config user.email "user@example.com"
# Repo
cp ../CNAME ../.travis.yml .
# Website
cp -R ../build ../bower_components ../*.html ../*.png ../favicon.ico .
# Metadata
cp ../all-hooks.json ../install-local.py .
git add .
git commit -m "Deployed ${TRAVIS_BUILD_NUMBER} to Github Pages"
git push -q origin HEAD >& /dev/null
