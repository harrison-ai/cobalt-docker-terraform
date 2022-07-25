
.DEFAULT_GOAL := help

## publish version=<version>:   build docker images and push to registry
publish:
	@test -n "$(version)" || ( echo "version must be set" && return 1 )
	./scripts/publish.sh $(version)

## help:                        show this help
help:
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)
