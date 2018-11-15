# Copyright 2018 Erik Maciejewski
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

TOP_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

BUILD_DIR_NAME=.build
BUILD_DIR=$(TOP_DIR)$(BUILD_DIR_NAME)

TF_SERVING_VERSION=1.12.0

DOCKER_NS=emacski
DOCKER_REPO=tensorflow-serving
DOCKER_TAG?=latest

.PHONY: devel pre arm32v7_vfpv3 arm32v7 arm64v8 all push-arm32v7_vfpv3 push-arm32v7 push-arm64v8 push _validate-release release

default: all

$(BUILD_DIR):
	mkdir -p $@

devel:
	docker build --pull \
	--build-arg TF_SERVING_VERSION=$(TF_SERVING_VERSION) \
	-f Dockerfile.devel \
	-t $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-devel .

pre: | $(BUILD_DIR)

arm32v7_vfpv3: pre
	docker run --rm \
	-v $(BUILD_DIR):/build \
	$(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-devel \
	/bin/bash -c "sed -i 's/define CURL_SIZEOF_LONG 8/define CURL_SIZEOF_LONG 4/g' /usr/include/curl/curlbuild.h && \
	sed -i 's/define CURL_SIZEOF_CURL_OFF_T 8/define CURL_SIZEOF_CURL_OFF_T 4/g' /usr/include/curl/curlbuild.h && \
	bazel build --verbose_failures \
	--config=armv7-a --copt=-mfpu=neon \
	tensorflow_serving/model_servers:tensorflow_model_server && \
	cp bazel-bin/tensorflow_serving/model_servers/tensorflow_model_server /build/tensorflow_model_server-$(TF_SERVING_VERSION)-linux_armhf_vfpv3"
	docker build --pull \
	--build-arg BIN_NAME=tensorflow_model_server-$(TF_SERVING_VERSION)-linux_armhf_vfpv3 \
	-t $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm32v7_vfpv3 -f Dockerfile.arm32v7 .

arm32v7: pre
	docker run --rm \
	-v $(BUILD_DIR):/build \
	$(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-devel \
	/bin/bash -c "sed -i 's/define CURL_SIZEOF_LONG 8/define CURL_SIZEOF_LONG 4/g' /usr/include/curl/curlbuild.h && \
	sed -i 's/define CURL_SIZEOF_CURL_OFF_T 8/define CURL_SIZEOF_CURL_OFF_T 4/g' /usr/include/curl/curlbuild.h && \
	bazel build --verbose_failures \
	--config=armv7-a --copt=-mfpu=neon-vfpv4 \
	tensorflow_serving/model_servers:tensorflow_model_server && \
	cp bazel-bin/tensorflow_serving/model_servers/tensorflow_model_server /build/tensorflow_model_server-$(TF_SERVING_VERSION)-linux_armhf"
	docker build --pull \
	--build-arg BIN_NAME=tensorflow_model_server-$(TF_SERVING_VERSION)-linux_armhf \
	-t $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm32v7 -f Dockerfile.arm32v7 .

arm64v8: pre
	docker run --rm \
	-v $(BUILD_DIR):/build \
	$(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-devel \
	/bin/bash -c "bazel build --verbose_failures \
	--config=armv8-a \
	tensorflow_serving/model_servers:tensorflow_model_server && \
	cp bazel-bin/tensorflow_serving/model_servers/tensorflow_model_server /build/tensorflow_model_server-$(TF_SERVING_VERSION)-linux_aarch64"
	docker build --pull \
	--build-arg BIN_NAME=tensorflow_model_server-$(TF_SERVING_VERSION)-linux_aarch64 \
	-t $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm64v8 -f Dockerfile.arm64v8 .

all: arm32v7_vfpv3 arm32v7 arm64v8

push-arm32v7_vfpv3:
	docker push $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm32v7_vfpv3

push-arm32v7:
	docker push $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm32v7

push-arm64v8:
	docker push $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm64v8

push: push-arm32v7_vfpv3 push-arm32v7 push-arm64v8

_validate-release:
ifeq ($(DOCKER_TAG),latest)
	$(error DOCKER_TAG must be specified for release and must not be 'latest')
endif

release: _validate-release all push
	# set latest tag to current release
	docker tag $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm32v7_vfpv3 $(DOCKER_NS)/$(DOCKER_REPO):latest-arm32v7_vfpv3
	docker tag $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm32v7 $(DOCKER_NS)/$(DOCKER_REPO):latest-arm32v7
	docker tag $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm64v8 $(DOCKER_NS)/$(DOCKER_REPO):latest-arm64v8
	docker push $(DOCKER_NS)/$(DOCKER_REPO):latest-arm32v7_vfpv3
	docker push $(DOCKER_NS)/$(DOCKER_REPO):latest-arm32v7
	docker push $(DOCKER_NS)/$(DOCKER_REPO):latest-arm64v8
