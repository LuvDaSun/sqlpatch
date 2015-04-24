-- require Projects


CREATE TABLE [dbo].[InspectionSeries] (
    [ProjectKey]                 SMALLINT       NOT NULL,
    [InspectionSerieKey]         TINYINT        NOT NULL,
    [InspectionSerieName]        NVARCHAR (100) NOT NULL,
    [InspectionSerieDescription] NVARCHAR (MAX) NULL,
    [InspectionSeriePosition]    FLOAT (53)     NOT NULL,
    [CreatedUTC]                 SMALLDATETIME  NOT NULL,
    [ModifiedUTC]                SMALLDATETIME  NOT NULL,
    [InspectionCount]            SMALLINT       CONSTRAINT [DF_InspectionSeries_InspectionCount] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_InspectionSeries] PRIMARY KEY NONCLUSTERED ([ProjectKey] ASC, [InspectionSerieKey] ASC),
    CONSTRAINT [CK_InspectionSeries_InspectionCount] CHECK ([InspectionCount]>=(0)),
    CONSTRAINT [CK_InspectionSeries_InspectionSerieKey] CHECK ([InspectionSerieKey]>(0)),
    CONSTRAINT [CK_InspectionSeries_InspectionSerieName] CHECK (ltrim(rtrim([InspectionSerieName]))=[InspectionSerieName] AND [InspectionSerieName]<>''),
    CONSTRAINT [FK_InspectionSeries_Project] FOREIGN KEY ([ProjectKey]) REFERENCES [dbo].[Projects] ([ProjectKey]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_InspectionSeries_InspectionSerieName] UNIQUE NONCLUSTERED ([ProjectKey] ASC, [InspectionSerieName] ASC),
    CONSTRAINT [UQ_InspectionSeries_InspectionSeriePosition] UNIQUE CLUSTERED ([ProjectKey] ASC, [InspectionSeriePosition] ASC)
);


GO

CREATE TRIGGER dbo.TRG_Projects_InspectionSerieCount
ON dbo.InspectionSeries
AFTER INSERT, UPDATE, DELETE
as

SET NOCOUNT ON

UPDATE Projects
set InspectionSerieCount = InspectionSerieCount + Count
from Projects
inner join (
	select ProjectKey, Count(*) as Count
	from inserted
	group by ProjectKey
	) as t1
	on Projects.ProjectKey = t1.ProjectKey

UPDATE Projects
set InspectionSerieCount = InspectionSerieCount - Count
from Projects
inner join (
	select ProjectKey, Count(*) as Count
	from deleted
	group by ProjectKey
	) as t1
	on Projects.ProjectKey = t1.ProjectKey
