export = sqlpatch;

interface SqlPatchOptions{
    dialect: string;
    schema: string;
    table: string;
}

declare function sqlpatch(fileList: string[], options: SqlPatchOptions):string;
