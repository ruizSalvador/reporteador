/****** Object:  StoredProcedure [dbo].[SP_RPT_ExistenciasConMinimosyMaximos]    Script Date: 12/04/2014 12:39:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ExistenciasConMinimosyMaximos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_ExistenciasConMinimosyMaximos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_ExistenciasConMinimosyMaximos]    Script Date: 12/04/2014 12:39:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Exec SP_RPT_ExistenciasConMinimosyMaximos 1,0
CREATE PROCEDURE [dbo].[SP_RPT_ExistenciasConMinimosyMaximos]
@IdAlmacen int,
@Reorden int

AS
BEGIN

Select CodigoCambs,DescripcionGenerica, T_ExistenciasAlmacen.IdSubGrupo,
		UnidadMedida, StockMinimo,
	   StockMaximo, T_ExistenciasAlmacen.Existencia, 
	   StockMaximo-T_ExistenciasAlmacen.Existencia as Pedir,
	   PuntodeReorder as Reorden
From C_Maestro 
INNER JOIN T_ExistenciasAlmacen on C_Maestro.IdCodigoProducto=T_ExistenciasAlmacen.IdCodigoProducto
and C_Maestro.IdSubGrupo=T_ExistenciasAlmacen.IdSubGrupo 
Where ResurtirStock=1 and T_ExistenciasAlmacen.Existencia<StockMaximo and IdAlmacen=@IdAlmacen 
AND PuntodeReorder = CASE WHEN @Reorden = 0 THEN PuntodeReorder ELSE @Reorden END
	  
 Order by DescripcionGenerica

 END
 GO

 Exec SP_FirmasReporte 'Existencias con M�nimos y M�ximos'
GO