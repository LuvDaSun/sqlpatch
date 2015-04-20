# Installation

    npm install sqlpatch -g


# Usage

    sqlpatch sqlfile1.sql sqlfile2.sql > output.sql


# What's this?

SQLPatch is a very simple tool that will allow you to manage patches for an SQL
database. Simple create a set of SQL files that define your database schema. Use
comments to specify dependencies between the scripts. Now SQLPatch can generate
a script that will execute all new SQL files in the right order.

You may specify a dependency using the following syntax:

    -- require src/dependency.sql

SQLPatch will first sort these SQL files based on their dependencies. Then it
will wrap some SQL code around it so that you can just dump the generated SQL
in your database and be sure that every statement is execute in the right order.

[Check out the examples!](./examples)


