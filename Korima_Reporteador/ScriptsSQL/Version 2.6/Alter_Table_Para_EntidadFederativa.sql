IF NOT EXISTS (SELECT SC.name,SO.name FROM sysobjects SO, syscolumns SC 
WHERE SO.id = SC.id and SO.name = 'RPT_CFG_DatosEntes' and (SC.name ='EntidadFederativa'))
BEGIN
alter table RPT_CFG_DatosEntes add EntidadFederativa varchar(max)
END

