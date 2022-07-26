
.DEFAULT_GOAL := help

## publish:          	        build docker images and push to registry
publish:
	@test -n "${TAG}" || ( echo "TAG environment variable must be set" && return 1 )
	./scripts/publish.sh ${TAG}

## help:                        show this help
help:
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)
