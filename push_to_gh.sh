#!/bin/bash

[ $TRAVIS_BRANCH == real_master ] || exit

git clone "https://${GH_TOKEN}@${GH_REF}" out >& /dev/null
cd out
git checkout master
git config user.name "Travis-CI"
git config user.email "kstruys@yelp.com"
cp ../.travis.yml .
cp ../index.html .
cp ../install-local.py .
cp -R ../build .
cp -R ../bower_components .
git add .
git commit -m "Deployed ${TRAVIS_BUILD_NUMBER} to Github Pages"
git push -q origin HEAD >& /dev/null
