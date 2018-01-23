CREATE SCHEMA IF NOT EXISTS "{{&options.schema}}";

CREATE TABLE IF NOT EXISTS "{{&options.schema}}"."{{&options.table}}"(
    name VARCHAR(100) PRIMARY KEY,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    checksum CHAR(40) NULL
);


{{#patches}}

-- {{&name}} - {{&file}}

DO $___patch_{{&number}}$
BEGIN

    IF EXISTS (SELECT 1 FROM "{{&options.schema}}"."{{&options.table}}" WHERE name = '{{&name}}') THEN
        RAISE NOTICE 'skip {{&name}}';
        RETURN;
    END IF;

    {{#dependencies}}
    IF NOT EXISTS (SELECT 1 FROM "{{&options.schema}}"."{{&options.table}}" WHERE name = '{{&name}}' AND (checksum = '{{&checksum}}' OR checksum IS NULL)) THEN
        RAISE EXCEPTION 'missing dependency or invalid checksum: {{&name}}';
    END IF;
    {{/dependencies}}

    RAISE NOTICE 'do {{&name}}';

{{&content}}

    INSERT INTO "{{&options.schema}}"."{{&options.table}}" (name, checksum) VALUES('{{&name}}', '{{&checksum}}');

    RAISE NOTICE 'done {{&name}}';

END
$___patch_{{&number}}$ LANGUAGE plpgsql;

{{/patches}}
