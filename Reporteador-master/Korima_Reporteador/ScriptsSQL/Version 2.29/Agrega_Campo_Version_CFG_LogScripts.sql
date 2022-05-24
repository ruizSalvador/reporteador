-- Agrega campo en CFG_LogScripts

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'CFG_LogScripts'
and SC.name = 'Version')

ALTER TABLE CFG_LogScripts ADD [Version] varchar(10)
GO

Exec SP_CFG_LogScripts 'Agrega_Campo_Version_CFG_LogScripts','2.29'
GO
