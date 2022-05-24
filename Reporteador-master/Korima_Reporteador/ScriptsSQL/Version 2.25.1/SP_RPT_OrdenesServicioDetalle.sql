/****** Object:  StoredProcedure [dbo].[SP_RPT_OrdenesServicioDetalle]    Script Date: 24/04/2017 10:48:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_OrdenesServicioDetalle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_OrdenesServicioDetalle]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_OrdenesServicioDetalle]    Script Date: 24/04/2017 10:48:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_OrdenesServicioDetalle  2017,8
CREATE PROCEDURE [dbo].[SP_RPT_OrdenesServicioDetalle] 

@Año int,
@Folio int

AS
BEGIN
Select (Select CAST(TOS.Periodo as varchar(4)) + '-' +  CAST(TOS.Folio as varchar(20))) as Folio,
		CASE WHEN TOS.IdSolicitud > 0 THEN (Select CAST(TSOL.Periodo as varchar(4)) + '-' +  CAST(TSOL.Folio as varchar(20)))
	  ELSE (Select CAST(TCON.Periodo as varchar(4)) + '-' +  CAST(TCON.IdConsolidacion as varchar(20))) END as Solicitud,
	  TOS.Fecha,
	  TC.Codigo, 
	  TSOL.Justificacion,
	  CP.RazonSocial, 
	  CP.RFC,
	  CP.CURP,
	  CP.Domicilio,
	  CP.Colonia,
	  CP.CP,
	  (Select  CE.ApellidoPaterno + ' ' + CE.ApellidoMaterno + ' ' + CE.Nombres) as Comprador, 
	  CASE TOS.Estatus
	  WHEN 'P' THEN 'Pedido'
	  WHEN 'R' THEN 'Recibido'
	  WHEN 'I' THEN 'Parcial'
	  WHEN 'C' THEN 'Cancelado'
	  ELSE ''
	  END as Estatus,
	  CTP.Descripcion as TipoCompra,
	  CCC.Descripcion as Condicion,
	  TOS.Total, 
	  TOS.IVA, 
	  ISNULL(RR.Importe,0) as Retenciones,
	  ISNULL(((TOS.Total * TOS.Descuento) / 100),0) as Descuento,
	  TOS.TotalGral, 
	  CAR.Nombre as Area, 
	  DOS.DescripcionServicio,
	  DOS.Cantidad,
	  DOS.CostoUnitario,
	  DOS.Importe,
	  TS.Sello,
	  CPP.DescripcionPartida,
	  (Select Numero FROM C_TelefonosClientesProveedores where Tipo = 'email' and IdProveedor = TOS.IdProveedor) as Email,
	  (Select Numero FROM C_TelefonosClientesProveedores where Tipo = 'Movil' and IdProveedor = TOS.IdProveedor) as Movil,
	  (Select top 1 Nombre from RPT_CFG_DatosEntes) as NombreEnte,
	  (Select top 1 RFC from RPT_CFG_DatosEntes) as RFCente,
	  (Select top 1 Domicilio from RPT_CFG_DatosEntes) as DomicilioEnte, 
	  (Select top 1 Ciudad from RPT_CFG_DatosEntes) as CiudadEnte,
	  (Select top 1 Telefonos from RPT_CFG_DatosEntes) as TelefonoEnte

From T_OrdenServicio TOS
LEFT JOIN D_OrdenServicio DOS ON TOS.IdOrden = DOS.IdOrden 
LEFT JOIN C_Proveedores CP ON CP.IdProveedor = TOS.IdProveedor
LEFT JOIN C_TiposCompra CTP ON CTP.IdTipoCompra = TOS.IdTipoCompra
LEFT JOIN R_RetencionesOrden RR ON RR.IdOrden = TOS.IdOrden
LEFT JOIN T_SellosPresupuestales TS ON TS.IdSelloPresupuestal = DOS.IdSelloPresupuestal
LEFT JOIN C_AreaResponsabilidad CAR ON CAR.IdAreaResp = TS.IdAreaResp
LEFT JOIN C_PartidasPres CPP ON CPP.IdPartida = TS.IdPartida
LEFT JOIN T_Contratos TC ON TC.Contrato = TOS.IdContrato
LEFT JOIN C_CondicionesCompra CCC ON CCC.IdCondicionCompra = TOS.IdCondicionCompraPago
LEFT JOIN T_Solicitudes TSOL ON TSOL.IdSolicitud = TOS.IdSolicitud
LEFT JOIN C_Empleados CE ON CE.NumeroEmpleado = TSOL.NumeroEmpleado
LEFT JOIN T_Consolidacion TCON ON TCON.IdConsolidacion = TOS.IdConsolidacion

 Where TOS.Periodo = @Año and TOS.Folio = @Folio


END
GO

EXEC SP_FirmasReporte 'Órdenes de Servicio Detalle'
GO

Exec SP_CFG_LogScripts 'SP_RPT_OrdenesServicioDetalle'
GO