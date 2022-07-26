
.DEFAULT_GOAL := help

## build:                       build docker images without tagging/pushing to registry
build:
	./scripts/build.sh

## publish:                     build docker images and push to registry with the given TAG
publish:
	@test -n "${TAG}" || ( echo "TAG environment variable must be set" && return 1 )
	./scripts/publish.sh ${TAG}

## help:                        show this help
help:
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)
