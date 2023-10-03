#!/bin/bash
set -ex

build_env=$1

if [ $build_env == "disconnected" ] ; then
    mvn --settings /usr/share/maven/ref/settings.xml clean package
else 
    mvn clean package
fi
