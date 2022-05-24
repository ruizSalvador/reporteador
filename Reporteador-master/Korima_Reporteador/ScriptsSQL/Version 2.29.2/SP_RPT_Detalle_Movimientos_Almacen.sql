/****** Object:  StoredProcedure [dbo].[SP_RPT_Detalle_Movimientos_Almacen]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Detalle_Movimientos_Almacen]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Detalle_Movimientos_Almacen]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_Detalle_Movimientos_Almacen]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_Detalle_Movimientos_Almacen '20200420','20200421',1,'A',0,0
CREATE PROCEDURE [dbo].[SP_RPT_Detalle_Movimientos_Almacen] 
  
@FechaIni Datetime,
@FechaFin Datetime,
@IdAlmacen int,
@TipoMov varchar(1),
@Folio1 int,
@Folio2 int
--@IdPartida int

AS
BEGIN

 Declare @tabla as table (
	  Folio int
	  ,IdEmpleado int
	  ,TipoMov varchar(10)
	  ,SerieFactura varchar(200)
	  ,FolioFactura varchar(200)
	  ,Observaciones varchar(max)
      ,IdAlmacen int
	  ,IdGrupo int
      ,IdSubgrupo int
	  ,IdProducto int
	  ,Cantidad int
	  ,Costo Decimal(20,2)
	  ,Fecha  Datetime
 )

 If @TipoMov = 'E'
 BEGIN
	 Insert into @tabla
	  Select --DM.IdMovimiento,
		TM.Folio,
		TM.NumeroEmpleadoRecibe,
		TM.TipoMov as Tipo,
		TR.Serie,
		TM.Factura,
		'',
		DM.IdAlmacen, 
		DM.IdGrupo, 
		DM.IdSubgrupo, 
		DM.IdProducto,
		DM.Cantidad, 
		DM.Costo as CostoUnitario, DM.Fecha
	From D_MovimientosAlmacen DM 
	LEFT JOIN T_MovimientosAlmacen TM ON TM.IdMovimiento = DM.IdMovimiento AND TipoMov = 'E'
	LEFT JOIN T_RecepcionFacturas TR ON TM.IdFactura = TR.IdRecepcionServicios
	Where (DM.Fecha >= @FechaIni and DM.Fecha <= @FechaFin)
	AND DM.IdAlmacen = ISNULL(@IdAlmacen,DM.IdAlmacen)
	AND (TM.Folio >= CASE WHEN @Folio1 = 0 THEN TM.Folio ELSE @Folio1 END and TM.Folio <= CASE WHEN @Folio2 = 0 THEN TM.Folio ELSE @Folio2 END)
	--order by DM.IdProducto 
END
ELSE
BEGIN
	Insert into @tabla
	  Select --DM.IdMovimiento,
		TM.Folio,
		TM.NumeroEmpleadoRecibe,
		TM.TipoMov as Tipo,
		'',
		'',
		DM.Observaciones,
		DM.IdAlmacen, 
		DM.IdGrupo, 
		DM.IdSubgrupo, 
		DM.IdProducto,
		DM.Cantidad, 
		DM.Costo as CostoUnitario, DM.Fecha
	From D_MovimientosAlmacen DM 
	LEFT JOIN T_MovimientosAlmacen TM on TM.IdMovimiento = DM.IdMovimiento AND TipoMov = @TipoMov
	Where (DM.Fecha >= @FechaIni and DM.Fecha <= @FechaFin)
		AND DM.IdAlmacen = ISNULL(@IdAlmacen,DM.IdAlmacen)
		and (TM.Folio >= CASE WHEN @Folio1 = 0 THEN TM.Folio ELSE @Folio1 END and TM.Folio <= CASE WHEN @Folio2 = 0 THEN TM.Folio ELSE @Folio2 END)
	--order by DM.IdProducto

END
 

 Select 
	--IdMovimiento
	Folio
	,IdEmpleado 
    ,IdAlmacen 
	,IdProducto
	,SerieFactura
	,FolioFactura
	,CM.CodigoCambs
	,Observaciones
	,CM.DescripcionGenerica 
	--,Renglon 
	, CASE TipoMov
		 WHEN 'S' THEN 'Salida'
		 WHEN 'E' THEN 'Entrada'
		 When 'A' THEN 'Ajuste al costo'
		ELSE 'Otro'
	  END as TipoMov 
	  ,Fecha
	  ,Cantidad 
	  ,Costo as CostoUnitario
	  ,(Cantidad * Costo) as CostoTotal
FROM @tabla t
INNER JOIN C_Maestro CM
ON t.IdProducto = CM.IdCodigoProducto
AND t.IdGrupo = CM.IdGrupo
AND t.IdSubGrupo = CM.IdSubGrupo
order by CM.DescripcionGenerica ASC

END

EXEC SP_FirmasReporte 'Detalle de Movimientos de Almacén'
GO