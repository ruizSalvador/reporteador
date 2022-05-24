-- Agrega campo en RPT_CFG_DatosEntes

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'RPT_CFG_DatosEntes'
and SC.name = 'LogoEnteSecundario')

ALTER TABLE RPT_CFG_DatosEntes ADD LogoEnteSecundario [image] NULL 
GO
