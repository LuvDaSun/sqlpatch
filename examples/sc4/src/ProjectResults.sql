-- require Projects


CREATE TABLE [dbo].[ProjectResults] (
    [ProjectKey]       SMALLINT         NOT NULL,
    [ProjectResultKey] SMALLINT         NOT NULL,
    [ProjectResultID]  UNIQUEIDENTIFIER CONSTRAINT [DF_ProjectResults_ProjectResultID] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [CreatedUTC]       SMALLDATETIME    NOT NULL,
    [ModifiedUTC]      SMALLDATETIME    NOT NULL,
    [InspectionCount]  SMALLINT         CONSTRAINT [DF_ProjectResults_InspectionCount] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ProjectResults] PRIMARY KEY NONCLUSTERED ([ProjectKey] ASC, [ProjectResultKey] ASC),
    CONSTRAINT [CK_ProjectResults_InspectionCount] CHECK ([InspectionCount]>=(0)),
    CONSTRAINT [CK_ProjectResults_ProjectResultKey] CHECK ([ProjectResultKey]>(0)),
    CONSTRAINT [FK_ProjectResults_Projects] FOREIGN KEY ([ProjectKey]) REFERENCES [dbo].[Projects] ([ProjectKey]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_ProjectResults_ProjectResultID] UNIQUE NONCLUSTERED ([ProjectResultID] ASC)
);


GO

CREATE TRIGGER dbo.TRG_Projects_ProjectResultCount
ON dbo.ProjectResults
AFTER INSERT, UPDATE, DELETE
as

SET NOCOUNT ON

UPDATE Projects
set ProjectResultCount = ProjectResultCount + Count
from Projects
inner join (
	select ProjectKey, Count(*) as Count
	from inserted
	group by ProjectKey
	) as t1
	on Projects.ProjectKey = t1.ProjectKey

UPDATE Projects
set ProjectResultCount = ProjectResultCount - Count
from Projects
inner join (
	select ProjectKey, Count(*) as Count
	from deleted
	group by ProjectKey
	) as t1
	on Projects.ProjectKey = t1.ProjectKey
