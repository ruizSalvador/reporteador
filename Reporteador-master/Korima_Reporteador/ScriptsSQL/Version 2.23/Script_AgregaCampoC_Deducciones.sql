-- Agrega campos en C_Deducciones

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'C_Deducciones'
and SC.name = 'IvaRet')

ALTER TABLE C_Deducciones ADD IvaRet bit
GO

