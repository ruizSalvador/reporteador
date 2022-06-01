---Agregar Campos e Índices para C_EP_Ramo


IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'C_EP_Ramo'
and SC.name = 'IdProgPres')

ALTER TABLE C_EP_Ramo ADD IdProgPres int
GO

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'C_EP_Ramo'
and SC.name = 'IdSubProgPres')

ALTER TABLE C_EP_Ramo ADD IdSubProgPres int
GO

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, sysindexes SC
WHERE SO.id = SC.id
and SO.name = 'C_EP_Ramo'
and SC.name = 'Fk_ClasificadorProg')

CREATE INDEX Fk_ClasificadorProg
ON C_EP_Ramo (IdProgPres )
GO

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, sysindexes SC
WHERE SO.id = SC.id
and SO.name = 'C_EP_Ramo'
and SC.name = 'Fk_ClasificadorSubProg')

CREATE INDEX Fk_ClasificadorSubProg
ON C_EP_Ramo (IdSubProgPres )
GO