-- @require InspectionCategories
-- @require InspectionGroups
-- @require InspectionSeries
-- @require ProjectResults



CREATE TABLE [Inspections] (
    [ProjectKey]            SMALLINT         NOT NULL,
    [InspectionKey]         SMALLINT         NOT NULL,
    [InspectionID]          UNIQUEIDENTIFIER CONSTRAINT [DF_Inspections_InspectionID] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [ProjectResultKey]      SMALLINT         NOT NULL,
    [InspectionGroupKey]    TINYINT          NULL,
    [InspectionSerieKey]    TINYINT          NULL,
    [InspectionCategoryKey] TINYINT          NULL,
    [TimeZoneOffsetMinutes] SMALLINT         NOT NULL,
    [CreatedUTC]            SMALLDATETIME    NOT NULL,
    [ModifiedUTC]           SMALLDATETIME    NOT NULL,
    [InspectionObjectCount] SMALLINT         CONSTRAINT [DF_Inspections_InspectionObjectCount] DEFAULT ((0)) NOT NULL,
    [Timestamp] TIMESTAMP NOT NULL,
    CONSTRAINT [PK_Inspections] PRIMARY KEY CLUSTERED ([ProjectKey] ASC, [InspectionKey] ASC),
    CONSTRAINT [CK_Inspections_InspectionKey] CHECK ([InspectionKey]>(0)),
    CONSTRAINT [CK_Inspections_InspectionObjectCount] CHECK ([InspectionObjectCount]>=(0)),
    CONSTRAINT [FK_Inspections_InspectionCategories] FOREIGN KEY ([ProjectKey], [InspectionCategoryKey]) REFERENCES [InspectionCategories] ([ProjectKey], [InspectionCategoryKey]) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT [FK_Inspections_InspectionGroups] FOREIGN KEY ([ProjectKey], [InspectionGroupKey]) REFERENCES [InspectionGroups] ([ProjectKey], [InspectionGroupKey]) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT [FK_Inspections_InspectionSeries] FOREIGN KEY ([ProjectKey], [InspectionSerieKey]) REFERENCES [InspectionSeries] ([ProjectKey], [InspectionSerieKey]) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT [FK_Inspections_ProjectResults] FOREIGN KEY ([ProjectKey], [ProjectResultKey]) REFERENCES [ProjectResults] ([ProjectKey], [ProjectResultKey]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_Inspections_InspectionID] UNIQUE NONCLUSTERED ([InspectionID] ASC)
);




EXECUTE('
CREATE TRIGGER TRG_Projects_InspectionCount
ON Inspections
AFTER INSERT, UPDATE, DELETE
as

SET NOCOUNT ON

UPDATE Projects
set InspectionCount = InspectionCount + Count
from Projects
inner join (
	select ProjectKey, Count(*) as Count
	from inserted
	group by ProjectKey
	) as t1
	on Projects.ProjectKey = t1.ProjectKey

UPDATE Projects
set InspectionCount = InspectionCount - Count
from Projects
inner join (
	select ProjectKey, Count(*) as Count
	from deleted
	group by ProjectKey
	) as t1
	on Projects.ProjectKey = t1.ProjectKey
');


EXECUTE('
CREATE TRIGGER TRG_ProjectResults_InspectionCount
ON Inspections
AFTER INSERT, UPDATE, DELETE
as

SET NOCOUNT ON

UPDATE ProjectResults
set InspectionCount = InspectionCount + Count
from ProjectResults
inner join (
	select ProjectKey, ProjectResultKey, Count(*) as Count
	from inserted
	group by ProjectKey, ProjectResultKey
	) as t1
	on ProjectResults.ProjectKey = t1.ProjectKey
	and ProjectResults.ProjectResultKey = t1.ProjectResultKey

UPDATE ProjectResults
set InspectionCount = InspectionCount - Count
from ProjectResults
inner join (
	select ProjectKey, ProjectResultKey, Count(*) as Count
	from deleted
	group by ProjectKey, ProjectResultKey
	) as t1
	on ProjectResults.ProjectKey = t1.ProjectKey
	and ProjectResults.ProjectResultKey = t1.ProjectResultKey
');


EXECUTE('
CREATE TRIGGER TRG_InspectionGroups_InspectionCount
ON Inspections
AFTER INSERT, UPDATE, DELETE
as

SET NOCOUNT ON

UPDATE InspectionGroups
set InspectionCount = InspectionCount + Count
from InspectionGroups
inner join (
	select ProjectKey, InspectionGroupKey, Count(*) as Count
	from inserted
	group by ProjectKey, InspectionGroupKey
	) as t1
	on InspectionGroups.ProjectKey = t1.ProjectKey
	and InspectionGroups.InspectionGroupKey = t1.InspectionGroupKey

UPDATE InspectionGroups
set InspectionCount = InspectionCount - Count
from InspectionGroups
inner join (
	select ProjectKey, InspectionGroupKey, Count(*) as Count
	from deleted
	group by ProjectKey, InspectionGroupKey
	) as t1
	on InspectionGroups.ProjectKey = t1.ProjectKey
	and InspectionGroups.InspectionGroupKey = t1.InspectionGroupKey
');


EXECUTE('
CREATE TRIGGER TRG_InspectionSeries_InspectionCount
ON Inspections
AFTER INSERT, UPDATE, DELETE
as

SET NOCOUNT ON

UPDATE InspectionSeries
set InspectionCount = InspectionCount + Count
from InspectionSeries
inner join (
	select ProjectKey, InspectionSerieKey, Count(*) as Count
	from inserted
	group by ProjectKey, InspectionSerieKey
	) as t1
	on InspectionSeries.ProjectKey = t1.ProjectKey
	and InspectionSeries.InspectionSerieKey = t1.InspectionSerieKey

UPDATE InspectionSeries
set InspectionCount = InspectionCount - Count
from InspectionSeries
inner join (
	select ProjectKey, InspectionSerieKey, Count(*) as Count
	from deleted
	group by ProjectKey, InspectionSerieKey
	) as t1
	on InspectionSeries.ProjectKey = t1.ProjectKey
	and InspectionSeries.InspectionSerieKey = t1.InspectionSerieKey
');


EXECUTE('
CREATE TRIGGER TRG_InspectionCategories_InspectionCount
ON Inspections
AFTER INSERT, UPDATE, DELETE
as

SET NOCOUNT ON

UPDATE InspectionCategories
set InspectionCount = InspectionCount + Count
from InspectionCategories
inner join (
	select ProjectKey, InspectionCategoryKey, Count(*) as Count
	from inserted
	group by ProjectKey, InspectionCategoryKey
	) as t1
	on InspectionCategories.ProjectKey = t1.ProjectKey
	and InspectionCategories.InspectionCategoryKey = t1.InspectionCategoryKey

UPDATE InspectionCategories
set InspectionCount = InspectionCount - Count
from InspectionCategories
inner join (
	select ProjectKey, InspectionCategoryKey, Count(*) as Count
	from deleted
	group by ProjectKey, InspectionCategoryKey
	) as t1
	on InspectionCategories.ProjectKey = t1.ProjectKey
	and InspectionCategories.InspectionCategoryKey = t1.InspectionCategoryKey
');