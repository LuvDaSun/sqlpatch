
CREATE TABLE [ObjectTypes] (
    [ObjectTypeKey]         SMALLINT         IDENTITY (1, 1) NOT NULL,
    [ObjectTypeID]          UNIQUEIDENTIFIER CONSTRAINT [DF_ObjectTypes_ObjectTypeID] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [ObjectTypeName]        NVARCHAR (100)   NOT NULL,
    [ObjectTypeDescription] NVARCHAR (MAX)   NULL,
    [ObjectTypePosition]    FLOAT (53)       NOT NULL,
    [CreatedUTC]            SMALLDATETIME    NOT NULL,
    [ModifiedUTC]           SMALLDATETIME    NOT NULL,
    [ObjectTypeChildCount]  SMALLINT         CONSTRAINT [DF_ObjectTypes_ObjectTypeChildCount] DEFAULT ((0)) NOT NULL,
    [PropertyTypeCount]     SMALLINT         CONSTRAINT [DF_ObjectTypes_PropertyTypeCount] DEFAULT ((0)) NOT NULL,
    [ProjectObjectCount]    BIGINT           DEFAULT ((0)) NOT NULL,
    [InspectionObjectCount] BIGINT           DEFAULT ((0)) NOT NULL,
    [ObjectTypeCode] VARCHAR(24) NULL,
    CONSTRAINT [PK_ObjectTypes] PRIMARY KEY NONCLUSTERED ([ObjectTypeKey] ASC),
    CONSTRAINT [CK_ObjectTypes_ObjectTypeChildCount] CHECK ([ObjectTypeChildCount]>=(0)),
    CONSTRAINT [CK_ObjectTypes_ObjectTypeKey] CHECK ([ObjectTypeKey]>(0)),
    CONSTRAINT [CK_ObjectTypes_ObjectTypeName] CHECK (ltrim(rtrim([ObjectTypeName]))=[ObjectTypeName] AND [ObjectTypeName]<>''),
    CONSTRAINT [CK_ObjectTypes_PropertyTypeCount] CHECK ([PropertyTypeCount]>=(0)),
    CONSTRAINT [UQ_ObjectTypes_ObjectTypeID] UNIQUE NONCLUSTERED ([ObjectTypeID] ASC),
    CONSTRAINT [UQ_ObjectTypes_ObjectTypeName] UNIQUE NONCLUSTERED ([ObjectTypeName] ASC),
    CONSTRAINT [UQ_ObjectTypes_ObjectTypePosition] UNIQUE CLUSTERED ([ObjectTypePosition] ASC)
);

