all: \
	dist/out.sql \


clean: \

	@rm -rf dist


smoke: \
	dist/out.sql \
	../../cli \

	@createdb sqlpatch-test-quote
	@psql -d sqlpatch-test-quote < $<
	@dropdb --if-exists sqlpatch-test-quote


dist/out.sql: \
	src/*.sql \

	@mkdir -p $(@D)

	node ../../cli --dialect=sqlserver $^ > $@


.PHONY: \
	all \
	clean \
	smoke \


