export interface SqlPatchOptions{
    dialect: string;
    schema: string;
    table: string;
}
export declare function sqlpatch(fileList: string[], options: SqlPatchOptions);
