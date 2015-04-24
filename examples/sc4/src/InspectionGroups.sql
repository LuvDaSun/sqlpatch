-- @require Projects


CREATE TABLE [InspectionGroups] (
    [ProjectKey]                 SMALLINT       NOT NULL,
    [InspectionGroupKey]         TINYINT        NOT NULL,
    [InspectionGroupName]        NVARCHAR (100) NOT NULL,
    [InspectionGroupDescription] NVARCHAR (MAX) NULL,
    [InspectionGroupPosition]    FLOAT (53)     NOT NULL,
    [CreatedUTC]                 SMALLDATETIME  NOT NULL,
    [ModifiedUTC]                SMALLDATETIME  NOT NULL,
    [InspectionCount]            SMALLINT       CONSTRAINT [DF_InspectionGroups_InspectionCount] DEFAULT ((0)) NOT NULL,
    [InspectionGroupCode] VARCHAR(24) NULL,
    [Timestamp] TIMESTAMP NOT NULL,
    CONSTRAINT [PK_InspectionGroups] PRIMARY KEY NONCLUSTERED ([ProjectKey] ASC, [InspectionGroupKey] ASC),
    CONSTRAINT [CK_InspectionGroups_InspectionCount] CHECK ([InspectionCount]>=(0)),
    CONSTRAINT [CK_InspectionGroups_InspectionGroupKey] CHECK ([InspectionGroupKey]>(0)),
    CONSTRAINT [CK_InspectionGroups_InspectionGroupName] CHECK (ltrim(rtrim([InspectionGroupName]))=[InspectionGroupName] AND [InspectionGroupName]<>''),
    CONSTRAINT [FK_InspectionGroups_Projects] FOREIGN KEY ([ProjectKey]) REFERENCES [Projects] ([ProjectKey]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_InspectionGroups_InspectionGroupName] UNIQUE NONCLUSTERED ([ProjectKey] ASC, [InspectionGroupName] ASC),
    CONSTRAINT [UQ_InspectionGroups_InspectionGroupPosition] UNIQUE CLUSTERED ([ProjectKey] ASC, [InspectionGroupPosition] ASC)
);




EXECUTE('
CREATE TRIGGER TRG_Projects_InspectionGroupCount
ON InspectionGroups
AFTER INSERT, UPDATE, DELETE
as

SET NOCOUNT ON

UPDATE Projects
set InspectionGroupCount = InspectionGroupCount + Count
from Projects
inner join (
	select ProjectKey, Count(*) as Count
	from inserted
	group by ProjectKey
	) as t1
	on Projects.ProjectKey = t1.ProjectKey

UPDATE Projects
set InspectionGroupCount = InspectionGroupCount - Count
from Projects
inner join (
	select ProjectKey, Count(*) as Count
	from deleted
	group by ProjectKey
	) as t1
	on Projects.ProjectKey = t1.ProjectKey
');