/****** Object:  StoredProcedure [dbo].[SP_RPT_OrdenCompra]    Script Date: 09/08/2016 15:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_OrdenCompra]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_OrdenCompra]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_OrdenCompra]    Script Date: 09/08/2016 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec SP_RPT_OrdenCompra  '20200101','20200909','',2
CREATE PROCEDURE [dbo].[SP_RPT_OrdenCompra] 

@Fecha1  Datetime,
@Fecha2  Datetime,  
@Proveedor int,
@TipoAd int,
@Estatus varchar (100)

AS
BEGIN

IF @Estatus = 'V'
BEGIN
Select Folio, Fecha, CP.RazonSocial, 
	  CTP.Descripcion as TipoAdquisicion, 
	  CASE T_Pedidos.Estatus
	  WHEN 'P' THEN 'Pedido'
	  WHEN 'R' THEN 'Recibido'
	  WHEN 'I' THEN 'Parcial'
	  WHEN 'C' THEN 'Cancelado'
	  ELSE 'Otro'
	  END as Estatus,
	  Total, IVA, TotalGral 

From T_Pedidos
LEFT JOIN C_Proveedores CP
ON CP.IdProveedor = T_Pedidos.IdProveedor
LEFT JOIN C_TiposCompra CTP
ON CTP.IdTipoCompra = T_Pedidos.IdTipoCompra
 Where (Fecha >= @Fecha1 and Fecha <= @Fecha2)
 AND T_Pedidos.IdProveedor = CASE WHEN @Proveedor = '' THEN T_Pedidos.IdProveedor ELSE @Proveedor END
  AND T_Pedidos.IdTipoCompra = CASE WHEN @TipoAd = '' THEN T_Pedidos.IdTipoCompra ELSE @TipoAd END
  AND  (T_Pedidos.Estatus = 'R' OR T_Pedidos.Estatus = 'P')

  Order by RazonSocial
END
	ELSE
BEGIN
Select Folio, Fecha, CP.RazonSocial, 
	  CTP.Descripcion as TipoAdquisicion, 
	  CASE T_Pedidos.Estatus
	  WHEN 'P' THEN 'Pedido'
	  WHEN 'R' THEN 'Recibido'
	  WHEN 'I' THEN 'Parcial'
	  WHEN 'C' THEN 'Cancelado'
	  ELSE 'Otro'
	  END as Estatus,
	  Total, IVA, TotalGral 

From T_Pedidos
LEFT JOIN C_Proveedores CP
ON CP.IdProveedor = T_Pedidos.IdProveedor
LEFT JOIN C_TiposCompra CTP
ON CTP.IdTipoCompra = T_Pedidos.IdTipoCompra
 Where (Fecha >= @Fecha1 and Fecha <= @Fecha2)
 AND T_Pedidos.IdProveedor = CASE WHEN @Proveedor = '' THEN T_Pedidos.IdProveedor ELSE @Proveedor END
  AND T_Pedidos.IdTipoCompra = CASE WHEN @TipoAd = '' THEN T_Pedidos.IdTipoCompra ELSE @TipoAd END
  AND  T_Pedidos.Estatus = CASE WHEN @Estatus = '' THEN T_Pedidos.Estatus ELSE @Estatus END

  Order by RazonSocial

END
END
GO

EXEC SP_FirmasReporte 'Reporte Orden Compra'
GO