/****** Object:  StoredProcedure [dbo].[SP_RPT_EntradaSalidasAlmacen]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_EntradaSalidasAlmacen]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_EntradaSalidasAlmacen]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_EntradaSalidasAlmacen]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_EntradaSalidasAlmacen '20160201','20160430',1
CREATE PROCEDURE [dbo].[SP_RPT_EntradaSalidasAlmacen] 
  
@FechaIni Datetime,
@FechaFin Datetime,
@IdAlmacen int

AS
BEGIN

 Declare @tabla as table (
		--IdMovimiento Bigint
      IdAlmacen int
      ,IdGrupo int
      ,IdSubgrupo int
	  ,IdProducto int
	  ,Renglon int
	  ,TipoMov varchar(10)
	  ,Cantidad int
	  ,CostoUnitario Decimal(20,2)
	  ,Fecha  Datetime
 )

 Insert into @tabla
  Select --DM.IdMovimiento,
		 DM.IdAlmacen, DM.IdGrupo, DM.IdSubgrupo, DM.IdProducto, DM.Renglon, 	 
		(Select TipoMov from T_MovimientosAlmacen Where T_MovimientosAlmacen.IdMovimiento = DM.IdMovimiento) as Tipo,
		DM.Cantidad, DM.Costo as CostoUnitario, DM.Fecha
From D_MovimientosAlmacen DM
Where (DM.Fecha >= @FechaIni and DM.Fecha <= @FechaFin)
	AND DM.IdAlmacen = @IdAlmacen
order by DM.IdGrupo, DM.IdSubgrupo, DM.IdProducto 
 

 Select 
	--IdMovimiento 
      IdAlmacen 
      ,t.IdGrupo 
      ,t.IdSubgrupo 
	  ,CM.IdFamilia
	  ,CM.IdSubClase
	  ,IdProducto
	  ,CM.DescripcionGenerica 
	  ,Renglon 
	  , CASE TipoMov
		  WHEN 'S' THEN 'Salida'
		 WHEN 'E' THEN 'Entrada'
		 ELSE 'Otro'
	  END as TipoMov 
	  ,Fecha
	  ,Cantidad 
	  ,CostoUnitario   
	  ,(Cantidad * CostoUnitario) as Total
FROM @tabla t
INNER JOIN C_Maestro CM
ON t.IdProducto = CM.IdCodigoProducto
AND t.IdGrupo = CM.IdGrupo
AND t.IdSubGrupo = CM.IdSubGrupo
WHERE TipoMov in ('E','S')
order by IdGrupo, IdSubgrupo

END

EXEC SP_FirmasReporte 'Entradas Salidas de Almacén'
GO