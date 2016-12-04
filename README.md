# Installation

``` sh
 $ npm install sqlpatch -g
```


# Usage

``` sh
 $ sqlpatch [--dialect=postgres] db/alters/*.sql > db/release.sql
```

> Note, `postgres` and `sqlserver` only are dialects available at the moment;
> `postgres` is the default dialect.


# What's this?

SQLPatch is a very simple tool that will allow you to manage patches for an SQL
database. Simple create a set of SQL files that define your database schema. Use
comments to specify dependencies between the scripts. Now SQLPatch can generate
a script that will execute all new SQL files in the right order.

You may specify a dependency using the following syntax:

``` sql
 -- @require dependency
```

Where dependency is a file name, without the extension or directory.

SQLPatch will first sort these SQL files based on their dependencies. Then it
will wrap some SQL code around it so that you can just dump the generated SQL
in your database and be sure that every statement is execute in the right order.

To give the dependency a different name, regardless of the file name:

``` sql
 -- @name custom_dependency_name
```

Then require the dependency using its new name:

``` sql
 -- @require custom_dependency_name
```

[Check out the examples!](./examples)
