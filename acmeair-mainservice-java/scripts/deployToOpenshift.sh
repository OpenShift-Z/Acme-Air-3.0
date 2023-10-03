#!/bin/bash
set -x
# Copyright (c) 2018 IBM Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-----------------------------------------------
#This script builds acmeair application on openshift.
MANIFESTS=${MANIFESTS:-manifests-openshift}
#Use default route name unless route name is specified at input
if [ $# -eq 0 ]
  then
    echo "Using default route name defaultacmeair.com"
    ROUTENAME=defaultacmeair.com
else
    echo "Using route name $1 "
    ROUTENAME=$1
fi
cd "$(dirname "$0")"
cd ..
oc delete -f ${MANIFESTS} 2>/dev/null || true
sed -i'' -e "s/defaultacmeair.com/${ROUTENAME}/g" $MANIFESTS/acmeair-mainservice-route.yaml
oc apply -f ${MANIFESTS} --validate=false
sed -i'' -e "s/${ROUTENAME}/defaultacmeair.com/g" $MANIFESTS/acmeair-mainservice-route.yaml
cd ../acmeair-authservice-java
oc delete -f ${MANIFESTS} 2>/dev/null || true
sed -i'' -e "s/defaultacmeair.com/${ROUTENAME}/g" $MANIFESTS/acmeair-authservice-route.yaml
oc apply -f ${MANIFESTS} --validate=false
sed -i'' -e "s/${ROUTENAME}/defaultacmeair.com/g" $MANIFESTS/acmeair-authservice-route.yaml
cd ../acmeair-bookingservice-java
oc delete -f ${MANIFESTS} 2>/dev/null || true
sed -i'' -e "s/defaultacmeair.com/${ROUTENAME}/g" $MANIFESTS/acmeair-bookingservice-route.yaml
oc apply -f ${MANIFESTS} --validate=false
sed -i'' -e "s/${ROUTENAME}/defaultacmeair.com/g" $MANIFESTS/acmeair-bookingservice-route.yaml
cd ../acmeair-customerservice-java
oc delete -f ${MANIFESTS} 2>/dev/null || true
sed -i'' -e "s/defaultacmeair.com/${ROUTENAME}/g" $MANIFESTS/acmeair-customerservice-route.yaml
oc apply -f ${MANIFESTS} --validate=false
sed -i'' -e "s/${ROUTENAME}/defaultacmeair.com/g" $MANIFESTS/acmeair-customerservice-route.yaml
cd ../acmeair-flightservice-java
oc delete -f ${MANIFESTS} 2>/dev/null || true
sed -i'' -e "s/defaultacmeair.com/${ROUTENAME}/g" $MANIFESTS/acmeair-flightservice-route.yaml
oc apply -f ${MANIFESTS} --validate=false
sed -i'' -e "s/${ROUTENAME}/defaultacmeair.com/g" $MANIFESTS/acmeair-flightservice-route.yaml
cd ../acmeair-cardservice-java
oc delete -f ${MANIFESTS} 2>/dev/null || true
sed -i'' -e "s/defaultacmeair.com/${ROUTENAME}/g" $MANIFESTS/acmeair-cardservice-route.yaml
oc apply -f ${MANIFESTS} --validate=false
sed -i'' -e "s/${ROUTENAME}/defaultacmeair.com/g" $MANIFESTS/acmeair-cardservice-route.yaml
