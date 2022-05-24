---Agregar Campos para C_Usuarios

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'C_Usuarios'
and SC.name = 'FiltraReportesxUR')

ALTER TABLE C_Usuarios ADD FiltraReportesxUR bit
GO

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'C_Usuarios'
and SC.name = 'ModificarPol')

ALTER TABLE C_Usuarios ADD ModificarPol bit 
GO

Update C_Usuarios Set FiltraReportesxUR = 0
Update C_Usuarios Set ModificarPol = 1