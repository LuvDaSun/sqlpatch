-- @require Projects


CREATE TABLE [InspectionCategories] (
    [ProjectKey]                    SMALLINT       NOT NULL,
    [InspectionCategoryKey]         TINYINT        NOT NULL,
    [InspectionCategoryName]        NVARCHAR (100) NOT NULL,
    [InspectionCategoryDescription] NVARCHAR (MAX) NULL,
    [InspectionCategoryPosition]    FLOAT (53)     NOT NULL,
    [CreatedUTC]                    SMALLDATETIME  NOT NULL,
    [ModifiedUTC]                   SMALLDATETIME  NOT NULL,
    [InspectionCount]               SMALLINT       CONSTRAINT [DF_InspectionCategories_InspectionCount] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_InspectionCategories] PRIMARY KEY NONCLUSTERED ([ProjectKey] ASC, [InspectionCategoryKey] ASC),
    CONSTRAINT [CK_InspectionCategories_InspectionCategoryKey] CHECK ([InspectionCategoryKey]>(0)),
    CONSTRAINT [CK_InspectionCategories_InspectionCategoryName] CHECK (ltrim(rtrim([InspectionCategoryName]))=[InspectionCategoryName] AND [InspectionCategoryName]<>''),
    CONSTRAINT [CK_InspectionCategories_InspectionCount] CHECK ([InspectionCount]>=(0)),
    CONSTRAINT [FK_InspectionCategories_Projects] FOREIGN KEY ([ProjectKey]) REFERENCES [Projects] ([ProjectKey]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_InspectionCategories_InspectionCategoryName] UNIQUE NONCLUSTERED ([ProjectKey] ASC, [InspectionCategoryName] ASC),
    CONSTRAINT [UQ_InspectionCategories_InspectionCategoryPosition] UNIQUE CLUSTERED ([ProjectKey] ASC, [InspectionCategoryPosition] ASC)
);



EXECUTE('
CREATE TRIGGER TRG_Projects_InspectionCategoryCount
ON InspectionCategories
AFTER INSERT, UPDATE, DELETE
as

SET NOCOUNT ON

UPDATE Projects
set InspectionCategoryCount = InspectionCategoryCount + Count
from Projects
inner join (
	select ProjectKey, Count(*) as Count
	from inserted
	group by ProjectKey
	) as t1
	on Projects.ProjectKey = t1.ProjectKey

UPDATE Projects
set InspectionCategoryCount = InspectionCategoryCount - Count
from Projects
inner join (
	select ProjectKey, Count(*) as Count
	from deleted
	group by ProjectKey
	) as t1
	on Projects.ProjectKey = t1.ProjectKey
');

