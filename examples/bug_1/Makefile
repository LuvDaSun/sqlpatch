all: \
	dist/out.sql \


clean: \

	@rm -rf dist


smoke: \
	dist/out.sql \
	../../cli \

	@createdb sqlpatch-test-bug_1
	@psql -d sqlpatch-test-bug_1 < $<
	@dropdb sqlpatch-test-bug_1


dist/out.sql: \
	src/*.sql \

	@mkdir -p $(@D)

	node ../../cli $^ > $@


.PHONY: \
	all \
	clean \
	smoke \


