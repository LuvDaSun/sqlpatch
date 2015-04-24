-- @require Projects
-- @require ObjectTypes


CREATE TABLE [Objects] (
    [ProjectKey]      SMALLINT         NOT NULL,
    [ObjectKey]       SMALLINT         NOT NULL,
    [ObjectID]        UNIQUEIDENTIFIER CONSTRAINT [DF_Objects_ObjectID] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [ObjectPosition]  FLOAT (53)       NOT NULL,
    [ParentObjectKey] SMALLINT         NULL,
    [ObjectTypeKey]   SMALLINT         NOT NULL,
    [Timestamp] TIMESTAMP NOT NULL,
    CONSTRAINT [PK_Objects] PRIMARY KEY NONCLUSTERED ([ProjectKey] ASC, [ObjectKey] ASC),
    CONSTRAINT [CK_Objects_ObjectKey] CHECK ([ObjectKey]>(0)),
    CONSTRAINT [CK_Objects_ParentObjectKey] CHECK ([ParentObjectKey]<[ObjectKey]),
    CONSTRAINT [FK_Objects_ObjectTypes] FOREIGN KEY ([ObjectTypeKey]) REFERENCES [ObjectTypes] ([ObjectTypeKey]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Objects_ParentObjects] FOREIGN KEY ([ProjectKey], [ParentObjectKey]) REFERENCES [Objects] ([ProjectKey], [ObjectKey]) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT [FK_Objects_Projects] FOREIGN KEY ([ProjectKey]) REFERENCES [Projects] ([ProjectKey]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_Objects_ObjectID] UNIQUE NONCLUSTERED ([ObjectID] ASC),
    CONSTRAINT [UQ_Objects_ObjectPosition] UNIQUE NONCLUSTERED ([ProjectKey] ASC, [ParentObjectKey] ASC, [ObjectPosition] ASC),
    CONSTRAINT [UQ_Objects_ObjectTypeKey] UNIQUE NONCLUSTERED ([ProjectKey] ASC, [ObjectTypeKey] ASC, [ObjectKey] ASC),
    CONSTRAINT [UQ_Objects_ParentObjectKey] UNIQUE CLUSTERED ([ProjectKey] ASC, [ParentObjectKey] ASC, [ObjectKey] ASC)
);




EXECUTE('
CREATE TRIGGER [TRG_Objects_Update]
    ON [Objects]
    FOR UPDATE
    AS
    BEGIN
        SET NoCount ON;

		update o
		set ObjectPosition = o.ObjectPosition
		from objects as o
		inner join inserted as po
			on o.ProjectKey = po.ProjectKey
			and o.ParentObjectKey = po.ObjectKey
		where po.Timestamp > o.Timestamp
		;

    END
');