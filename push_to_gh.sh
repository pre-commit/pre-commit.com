#!/bin/bash

[ $TRAVIS_BRANCH == real_master ] || exit

git clone "https://${GH_TOKEN}@${GH_REF}" out >& /dev/null
cd out
git checkout master
git config user.name "Travis-CI"
git config user.email "kstruys@yelp.com"
# Repo
cp ../CNAME ../.travis.yml .
# Website
cp -R ../build ../bower_components ../*.html ../*.png .
# Metadata
cp ../all-hooks.json ../install-local.py .
git add .
git commit -m "Deployed ${TRAVIS_BUILD_NUMBER} to Github Pages"
git push -q origin HEAD >& /dev/null
