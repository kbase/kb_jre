#!/bin/bash
# 
# This script is intended to be run in the deploy stage of a travis build
# It checks to make sure that this is a not a PR, and that we have the secure
# environment variables available and then checks if this is either the master
# or develop branch, otherwise we don't push anything
#
# sychan@lbl.gov
# 8/31/2017

REPO=kbase/kb_auth2
TAG=`if [ "$TRAVIS_BRANCH" == "master" ]; then echo "latest"; else echo $TRAVIS_BRANCH ; fi`

if ( [ "$TRAVIS_SECURE_ENV_VARS" == "true" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ] ); then
    # $TAG was set from TRAVIS_BRANCH, which is a little wonky on pull requests,
    # but it should be okay since we should never get here on a PR
    if  ( [ "$TAG" == "latest" ] || [ "$TAG" == "develop" ] ) ; then
        echo "Building dockerimage"
        ant dockerimage
        echo "Logging into Dockerhub as $DOCKER_USER"
        docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS && \
        docker tag $REPO:$TRAVIS_COMMIT $REPO:$TAG && \
        echo "Pushing $REPO:TAG" && \
        docker push $REPO:$TAG || \
        echo "Failed to login and push tagged image" && exit 0
    else
        echo "Not building image for branch $TAG"
    fi
else
    echo "Not building image for pull requests or if secure variables unavailable"
fi
