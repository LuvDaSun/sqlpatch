-- @require ObjectTypes


CREATE TABLE [ObjectTypeChildren] (
    [ObjectTypeKey]      SMALLINT      NOT NULL,
    [ChildObjectTypeKey] SMALLINT      NOT NULL,
    [CreatedUTC]         SMALLDATETIME NOT NULL,
    [ModifiedUTC]        SMALLDATETIME NOT NULL,
    CONSTRAINT [PK_ObjectTypeChildren] PRIMARY KEY CLUSTERED ([ObjectTypeKey] ASC, [ChildObjectTypeKey] ASC),
    CONSTRAINT [FK_ObjectTypeChildren_ObjectTypes] FOREIGN KEY ([ObjectTypeKey]) REFERENCES [ObjectTypes] ([ObjectTypeKey]) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT [FK_ObjectTypeChildren_ObjectTypes_Children] FOREIGN KEY ([ChildObjectTypeKey]) REFERENCES [ObjectTypes] ([ObjectTypeKey]) ON DELETE CASCADE ON UPDATE CASCADE
);




EXECUTE('
CREATE TRIGGER TRG_ObjectTypes_ObjectTypeChildCount
ON ObjectTypeChildren
AFTER INSERT, UPDATE, DELETE
as

SET NOCOUNT ON

UPDATE ObjectTypes
set ObjectTypeChildCount = ObjectTypeChildCount + Count
from ObjectTypes
inner join (
	select ObjectTypeKey, Count(*) as Count
	from inserted
	group by ObjectTypeKey
	) as t1
	on ObjectTypes.ObjectTypeKey = t1.ObjectTypeKey

UPDATE ObjectTypes
set ObjectTypeChildCount = ObjectTypeChildCount - Count
from ObjectTypes
inner join (
	select ObjectTypeKey, Count(*) as Count
	from deleted
	group by ObjectTypeKey
	) as t1
	on ObjectTypes.ObjectTypeKey = t1.ObjectTypeKey
');