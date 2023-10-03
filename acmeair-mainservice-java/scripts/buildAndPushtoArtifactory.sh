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

#!/bin/bash
if [[ "$TRAVIS_BRANCH" == "master" ]] && [[ "$TRAVIS_PULL_REQUEST" == "false" ]]; then

set -exo pipefail

NAMESPACE="acmeair"
DOCKERFILE=Dockerfile
CLUSTER=${DOCKER_REGISTRY}


cd "$(dirname "$0")"
cd ..
mvn clean package

docker build --pull -t ${CLUSTER}/${NAMESPACE}/acmeair-mainservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID} -f ${DOCKERFILE} .
docker tag ${CLUSTER}/${NAMESPACE}/acmeair-mainservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID} ${CLUSTER}/${NAMESPACE}/acmeair-mainservice-java-${DOCKER_ARCH}:latest
docker push ${CLUSTER}/${NAMESPACE}/acmeair-mainservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID}
docker push ${CLUSTER}/${NAMESPACE}/acmeair-mainservice-java-${DOCKER_ARCH}:latest
cd ../acmeair-authservice-java
mvn clean package
docker build --pull -t ${CLUSTER}/${NAMESPACE}/acmeair-authservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID} -f ${DOCKERFILE} .
docker tag ${CLUSTER}/${NAMESPACE}/acmeair-authservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID} ${CLUSTER}/${NAMESPACE}/acmeair-authservice-java-${DOCKER_ARCH}:latest
docker push ${CLUSTER}/${NAMESPACE}/acmeair-authservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID}
docker push ${CLUSTER}/${NAMESPACE}/acmeair-authservice-java-${DOCKER_ARCH}:latest

cd ../acmeair-bookingservice-java
mvn clean package
docker build --pull -t ${CLUSTER}/${NAMESPACE}/acmeair-bookingservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID} -f ${DOCKERFILE} .
docker tag ${CLUSTER}/${NAMESPACE}/acmeair-bookingservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID} ${CLUSTER}/${NAMESPACE}/acmeair-bookingservice-java-${DOCKER_ARCH}:latest
docker push ${CLUSTER}/${NAMESPACE}/acmeair-bookingservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID}
docker push ${CLUSTER}/${NAMESPACE}/acmeair-bookingservice-java-${DOCKER_ARCH}:latest

cd ../acmeair-customerservice-java
mvn clean package
docker build --pull -t ${CLUSTER}/${NAMESPACE}/acmeair-customerservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID} -f ${DOCKERFILE} .
docker tag ${CLUSTER}/${NAMESPACE}/acmeair-customerservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID} ${CLUSTER}/${NAMESPACE}/acmeair-customerservice-java-${DOCKER_ARCH}:latest
docker push ${CLUSTER}/${NAMESPACE}/acmeair-customerservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID}
docker push ${CLUSTER}/${NAMESPACE}/acmeair-customerservice-java-${DOCKER_ARCH}:latest

cd ../acmeair-flightservice-java
mvn clean package
docker build --pull -t ${CLUSTER}/${NAMESPACE}/acmeair-flightservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID} -f ${DOCKERFILE} .
docker tag ${CLUSTER}/${NAMESPACE}/acmeair-flightservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID} ${CLUSTER}/${NAMESPACE}/acmeair-flightservice-java-${DOCKER_ARCH}:latest
docker push ${CLUSTER}/${NAMESPACE}/acmeair-flightservice-java-${DOCKER_ARCH}:${TRAVIS_BUILD_ID}
docker push ${CLUSTER}/${NAMESPACE}/acmeair-flightservice-java-${DOCKER_ARCH}:latest
fi
