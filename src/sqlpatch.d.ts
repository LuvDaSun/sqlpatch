export interface SqlPatchOptions{
    dialect: string;
    schema: string;
    table: string;
}
export default function sqlpatch(fileList: string[], options: SqlPatchOptions);
