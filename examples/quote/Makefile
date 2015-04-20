all: \
	dist/out.sql \


clean: \

	rm -rf dist


dist/out.sql: \
	src/*.sql \

	@mkdir -p $(@D)

	@node ../../sqlpatch $^ > $@


.PHONY: \
	all \
	clean \


