REPO_ROOT                                      := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: docker-images
docker-images:
	@$(REPO_ROOT)/hack/docker-images.sh

.PHONY: component
component:
	@$(REPO_ROOT)/hack/create-cd.sh

.PHONY: generate-installation
generate-installation:
	@$(REPO_ROOT)/hack/generate-installation.sh

.PHONY: publish
publish: docker-images component
