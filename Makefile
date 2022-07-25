
.DEFAULT_GOAL := help

## publish tag=<tag>:	        build docker images and push to registry
publish:
	@test -n "$(tag)" || ( echo "tag must be set" && return 1 )
	./scripts/publish.sh $(tag)

## help:                        show this help
help:
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)
