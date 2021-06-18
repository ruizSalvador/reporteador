IF NOT EXISTS (SELECT SC.name,SO.name FROM sysobjects SO, syscolumns SC 
WHERE SO.id = SC.id and SO.name = 'T_Firmas' and (SC.name = 'Referencia' OR SC.name = 'NotasVersion'))
BEGIN
ALTER TABLE T_Firmas ADD Referencia varchar(99) NULL,NotasVersion varchar(99) NULL
END