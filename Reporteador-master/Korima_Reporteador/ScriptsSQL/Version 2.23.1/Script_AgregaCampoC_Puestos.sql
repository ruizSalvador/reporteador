---Agregar Campo en C_Puestos

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'C_Puestos'
and SC.name = 'NivelPuesto')

ALTER TABLE C_Puestos ADD NivelPuesto varchar(20)
GO