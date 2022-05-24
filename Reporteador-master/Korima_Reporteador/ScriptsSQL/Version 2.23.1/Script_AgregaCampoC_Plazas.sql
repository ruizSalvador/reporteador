-- Agrega campos en C_Plazas

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'C_Plazas'
and SC.name = 'Idcct')

ALTER TABLE C_Plazas ADD Idcct int
GO


IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'C_Plazas'
and SC.name = 'IdclasPlazas')

ALTER TABLE C_Plazas ADD IdclasPlazas int
GO