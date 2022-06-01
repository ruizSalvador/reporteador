-- Agrega campos en D_OrdenServicio

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'D_OrdenServicio'
and SC.name = 'TipoIva')

ALTER TABLE D_OrdenServicio ADD TipoIva int
GO

-- Agrega campos en D_Pedidos

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'D_Pedidos'
and SC.name = 'TipoIva')

ALTER TABLE D_Pedidos ADD TipoIva int
GO

-- Agrega campos en D_Cotizaciones

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'D_Cotizaciones'
and SC.name = 'TipoIva')

ALTER TABLE D_Cotizaciones ADD TipoIva int
GO

-- Agrega campos en D_CotizacionesServicios

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'D_CotizacionesServicios'
and SC.name = 'TipoIva')

ALTER TABLE D_CotizacionesServicios ADD TipoIva int
GO