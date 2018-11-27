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
THIS_MAKE_FILE := $(lastword $(MAKEFILE_LIST))
TFS_VERSION=1.12.0

DOCKER_NS=emacski
DOCKER_REPO=tensorflow-serving
DOCKER_TAG?=master

bin_path=/usr/bin/tensorflow_model_server
bin_container=tfs

.PHONY: all devel arm64v8 arm32v7 arm32v7_vfpv3 push _validate-release release

default: all

all: devel arm64v8 arm32v7 arm32v7_vfpv3

devel:
	docker build --pull \
	--target devel \
	--build-arg TFS_VERSION=$(TFS_VERSION) \
	-f tensorflow_serving/tools/docker/Dockerfile.arm \
	-t $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-devel .

build: devel
	docker build --pull \
		--build-arg TFS_VERSION=$(TFS_VERSION) \
		--build-arg ARCH=$(arch) \
		--build-arg BUILD_OPTS=$(build_opts) \
		-f tensorflow_serving/tools/docker/Dockerfile.arm \
		-t $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-$(image_suffix) .
	-docker run --name $(bin_container) \
		--entrypoint /bin/true \
		$(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-$(image_suffix)
	docker cp \
		$$(docker ps -a -f "name=$(bin_container)" -f "status=exited" --format "{{.ID}}"):$(bin_path) \
		./tensorflow_model_server-$(TFS_VERSION)-linux_$(bin_suffix)
	docker rm $(bin_container)

arm64v8:
	$(MAKE) --warn-undefined-variable -f $(THIS_MAKE_FILE) TFS_VERSION=$(TFS_VERSION) \
		DOCKER_NS=$(DOCKER_NS) DOCKER_REPO=$(DOCKER_REPO) DOCKER_TAG=$(DOCKER_TAG) \
		arch="arm64v8" build_opts="" image_suffix="arm64v8" bin_suffix="aarch64" \
		build

arm32v7:
	$(MAKE) --warn-undefined-variable -f $(THIS_MAKE_FILE) TFS_VERSION=$(TFS_VERSION) \
		DOCKER_NS=$(DOCKER_NS) DOCKER_REPO=$(DOCKER_REPO) DOCKER_TAG=$(DOCKER_TAG) \
		arch="arm32v7" build_opts="--copt=-mfpu=neon-vfpv4" image_suffix="arm32v7" bin_suffix="armhf" \
		build

arm32v7_vfpv3:
	$(MAKE) --warn-undefined-variable -f $(THIS_MAKE_FILE) TFS_VERSION=$(TFS_VERSION) \
		DOCKER_NS=$(DOCKER_NS) DOCKER_REPO=$(DOCKER_REPO) DOCKER_TAG=$(DOCKER_TAG) \
		arch="arm32v7" build_opts="--copt=-mfpu=neon" image_suffix="arm32v7_vfpv3" bin_suffix="armhf_vfpv3" \
		build

push:
	docker push $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-devel
	docker push $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm64v8
	docker push $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm32v7
	docker push $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm32v7_vfpv3

_validate-release:
ifeq ($(DOCKER_TAG),master)
	$(error DOCKER_TAG must be specified for release and must not be 'master')
endif
ifeq ($(DOCKER_TAG),latest)
	$(error DOCKER_TAG must be specified for release and must not be 'latest')
endif

release: _validate-release all push
	# set latest tag to current release
	docker tag $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-devel $(DOCKER_NS)/$(DOCKER_REPO):latest-devel
	docker tag $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm64v8 $(DOCKER_NS)/$(DOCKER_REPO):latest-arm64v8
	docker tag $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm32v7 $(DOCKER_NS)/$(DOCKER_REPO):latest-arm32v7
	docker tag $(DOCKER_NS)/$(DOCKER_REPO):$(DOCKER_TAG)-arm32v7_vfpv3 $(DOCKER_NS)/$(DOCKER_REPO):latest-arm32v7_vfpv3
	docker push $(DOCKER_NS)/$(DOCKER_REPO):latest-devel
	docker push $(DOCKER_NS)/$(DOCKER_REPO):latest-arm64v8
	docker push $(DOCKER_NS)/$(DOCKER_REPO):latest-arm32v7
	docker push $(DOCKER_NS)/$(DOCKER_REPO):latest-arm32v7_vfpv3
