interface SqlPatchOptions{
    dialect: string;
    schema: string;
    table: string;
}

export function sqlpatch(fileList: string[], options: SqlPatchOptions):string;
