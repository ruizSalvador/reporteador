--NUEVO CAMPO EN T_FACTURAS
IF NOT EXISTS (SELECT SC.name,SO.name FROM sysobjects SO, syscolumns SC WHERE SO.id = SC.id and SO.name = 'T_Facturas' and SC.name = 'IdPuntoIngreso')
	BEGIN
		ALTER TABLE T_Facturas ADD IdPuntoIngreso INT
	END
GO

--LLAVE FORANEA DE NUEVO CAMPO EN T_FACTURAS
CREATE NONCLUSTERED INDEX Fk_PuntoIngreso ON dbo.T_Facturas
	(IdPuntoIngreso
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

--ACTUALIZACION DE DATOS EXISTENTES EN T_FACTURAS
UPDATE T_Facturas SET T_Facturas.IdPuntoIngreso= C_PuntosIngreso.IdPunto FROM T_Facturas
	JOIN D_Ingresos ON D_Ingresos.Idfactura  = T_Facturas.Idfactura
	JOIN C_PuntosIngreso ON C_PuntosIngreso.Origen = D_Ingresos.Origen
	
GO
----------------------------------------------------------------	
--NUEVO CAMPO EN T_RECIBOS CAJA
IF NOT EXISTS (SELECT SC.name,SO.name FROM sysobjects SO, syscolumns SC WHERE SO.id = SC.id and SO.name = 'T_RecibosCaja' and SC.name = 'IdPuntoIngreso')
	BEGIN
		ALTER TABLE T_RecibosCaja ADD IdPuntoIngreso INT
	END
GO
--LLAVE FORANEA DE NUEVO CAMPO EN T_RECIBOSCAJA
CREATE NONCLUSTERED INDEX Fk_PuntoIngreso ON dbo.T_RecibosCaja
	(IdPuntoIngreso
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

--ACTUALIZACION DE DATOS EXISTENTES EN T_RECIBOS CAJA
UPDATE T_RecibosCaja SET T_RecibosCaja.IdPuntoIngreso= C_PuntosIngreso.IdPunto 
FROM T_RecibosCaja
	JOIN D_Ingresos ON D_Ingresos.Idfactura  = T_RecibosCaja.Idfactura
	JOIN C_PuntosIngreso ON C_PuntosIngreso.Origen = D_Ingresos.Origen
	
GO
------------------------------------------------------------------------------
--NUEVO CAMPO EN D_INGRESOS
IF NOT EXISTS (SELECT SC.name,SO.name FROM sysobjects SO, syscolumns SC WHERE SO.id = SC.id and SO.name = 'D_Ingresos' and SC.name = 'IdCliente')
	BEGIN
		ALTER TABLE D_Ingresos ADD IdCliente INT
	END
GO

--ACTUALIZACION DE DATOS EXISTENTES EN D_INGRESOS CAJA
UPDATE D_Ingresos SET D_Ingresos.IdCliente= T_Facturas.IdCliente
FROM D_Ingresos JOIN T_Facturas ON T_Facturas.Idfactura  = D_Ingresos.Idfactura
	
GO
