/****** Object:  StoredProcedure [dbo].[SP_RPT_OrdenServicio]    Script Date: 09/08/2016 15:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_OrdenServicio]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_OrdenServicio]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_OrdenServicio]    Script Date: 09/08/2016 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec SP_RPT_OrdenServicio  '20160101','20160909','',2
CREATE PROCEDURE [dbo].[SP_RPT_OrdenServicio] 

@Fecha1  Datetime,
@Fecha2  Datetime,  
@Proveedor int,
@TipoAd int

AS
BEGIN
Select Folio, Fecha, CP.RazonSocial, 
	  CTP.Descripcion as TipoAdquisicion, 
	  CASE T_OrdenServicio.Estatus
	  WHEN 'P' THEN 'Pedido'
	  WHEN 'R' THEN 'Recibido'
	  WHEN 'I' THEN 'Parcial'
	  WHEN 'C' THEN 'Cancelado'
	  ELSE 'Otro'
	  END as Estatus,
	  Total, IVA, TotalGral,
	  SUM(isnull(RR.Importe,0)) as Retenciones 

From T_OrdenServicio
LEFT JOIN C_Proveedores CP
ON CP.IdProveedor = T_OrdenServicio.IdProveedor
LEFT JOIN C_TiposCompra CTP
ON CTP.IdTipoCompra = T_OrdenServicio.IdTipoCompra
LEFT JOIN R_RetencionesOrden RR
ON RR.IdOrden = T_OrdenServicio.IdOrden
 Where (T_OrdenServicio.Fecha >= @Fecha1 and T_OrdenServicio.Fecha <= @Fecha2)
 AND T_OrdenServicio.IdProveedor = CASE WHEN @Proveedor = '' THEN T_OrdenServicio.IdProveedor ELSE @Proveedor END
  AND T_OrdenServicio.IdTipoCompra = CASE WHEN @TipoAd = '' THEN T_OrdenServicio.IdTipoCompra ELSE @TipoAd END
  Group by T_OrdenServicio.Folio,T_OrdenServicio.Fecha, CP.RazonSocial, CTP.Descripcion, T_OrdenServicio.Estatus,
  T_OrdenServicio.Total, T_OrdenServicio.IVA, T_OrdenServicio.TotalGral
  Order by RazonSocial

END
GO

EXEC SP_FirmasReporte 'Reporte Orden Servicio'
GO