IF NOT EXISTS (SELECT SC.name,SO.name FROM sysobjects SO, syscolumns SC 
WHERE SO.id = SC.id and SO.name = 'C_Proveedores' and SC.name = 'CURP')
BEGIN
ALTER TABLE C_Proveedores ADD CURP varchar(99) NULL
END