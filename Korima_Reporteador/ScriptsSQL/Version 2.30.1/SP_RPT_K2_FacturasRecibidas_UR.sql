/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_FacturasRecibidas_UR]    Script Date: 04/11/2013 16:31:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_FacturasRecibidas_UR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_FacturasRecibidas_UR]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_FacturasRecibidas_UR]    Script Date: 04/11/2013 16:31:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RPT_K2_FacturasRecibidas_UR '20210101','20210228',' ',0,'',0
CREATE PROCEDURE [dbo].[SP_RPT_K2_FacturasRecibidas_UR]
@Fecha Datetime,
@FechaFin Datetime,
@Proveedor varchar(max),
@IdUR INT,
@Estatus varchar(20),
@Partida INT 

AS
BEGIN

DECLARE @Tabla TABLE (Fecha datetime,SubTotal decimal(15,2),IVA decimal(15,2),Total decimal(15,2),Folio Int,Observaciones varchar(max),RazonSocial varchar(max), RFC varchar(max), Factura varchar(max), Status varchar(15), Retenciones Decimal(18,2), 
FechaAplicacion Datetime, Clave varchar(max), Nombre varchar(250), IdPartida Int, IdGrupo int, IdSubgrupo int, IdCodigoProducto int)


IF @Proveedor <>'' begin
INSERT @Tabla
Select distinct T_RecepcionFacturas.Fecha as Fecha,
D_RecepcionFacturas.Importe,
D_RecepcionFacturas.Importe * (D_Pedidos.PorcIva/100),
(D_RecepcionFacturas.Importe + (D_RecepcionFacturas.Importe * (D_Pedidos.PorcIva/100)))-SUM(isnull(T_RecepcionFacturas.Retencion,0)) as Total, 
T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
C_Proveedores.RazonSocial,'R.F.C. '+C_Proveedores.RFC as RFC, T_RecepcionFacturas.Factura,  
CASE
	WHEN T_Cheques.Status = 'I' AND T_Cheques.Entregado = 1 THEN 'Pagado' 
	WHEN T_Cheques.Status = 'D' THEN 'Pagado'
	WHEN T_Cheques.Status = 'G' THEN 'Pendiente'
	WHEN T_Cheques.Status = 'L' AND T_Cheques.IdChequesAgrupador <> 0 THEN 'Pagado'
	WHEN T_SolicitudCheques.Estatus = 'C' THEN 'Pendiente'
	ELSE 'Pendiente' 
END as Status,
SUM(isnull(T_RecepcionFacturas.Retencion,0)) as Retenciones,
T_Cheques.FechaImpresion,
C_AreaResponsabilidad.Clave , C_AreaResponsabilidad.Nombre, T_sellospresupuestales.IdPartida,
D_Pedidos.IdGrupo, D_Pedidos.IdSubgrupo, D_Pedidos.IdCodigoProducto
from T_RecepcionFacturas
join C_Proveedores on C_Proveedores.IdProveedor = T_RecepcionFacturas.IdProveedor
left join T_SolicitudCheques on T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios
left join T_Cheques on T_Cheques.idSolicitudCheque = T_SolicitudCheques.IdSolicitudCheques 
Left Join D_RecepcionFacturas on T_RecepcionFacturas.idRecepcionservicios=D_recepcionfacturas.idrecepcionservicios
Left join T_sellospresupuestales on D_recepcionFacturas.idsellopresupuestal=T_Sellospresupuestales.idsellopresupuestal
left join dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp 
left join C_PartidasPres on T_sellospresupuestales.IdPartida = C_PartidasPres.IdPartida
join D_Pedidos on D_RecepcionFacturas.IdRenglonPedido = D_Pedidos.IdRenglonPedido and D_RecepcionFacturas.IdRenglonPedido <> 0

Where (T_RecepcionFacturas.Fecha >= (@Fecha-1) and T_RecepcionFacturas.Fecha <= @FechaFin ) and C_Proveedores.RazonSocial =@Proveedor AND (T_RecepcionFacturas.Estatus <> 'N' and T_SolicitudCheques.Estatus <> 'N')
AND C_AreaResponsabilidad.IdAreaResp = CASE WHEN @IdUR = 0 THEN C_AreaResponsabilidad.IdAreaResp ELSE @IdUR END
AND C_PartidasPres.clavepartida =CASE WHEN @Partida = 0 THEN C_PartidasPres.clavepartida else @Partida end
		--AND T_Cheques.Status <> 'L'
AND D_RecepcionFacturas.Cantidad > 0
group by T_RecepcionFacturas.Fecha, T_RecepcionFacturas.SubTotal, T_RecepcionFacturas.IVA, T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
		C_Proveedores.RazonSocial, C_Proveedores.RFC, T_RecepcionFacturas.Factura, T_Cheques.Status, T_Cheques.Entregado, T_SolicitudCheques.Estatus, T_Cheques.IdChequesAgrupador, T_Cheques.FechaImpresion, T_Cheques.IdCheques,
		C_AreaResponsabilidad.Clave , C_AreaResponsabilidad.Nombre, T_sellospresupuestales.IdPartida, D_RecepcionFacturas.Importe, D_RecepcionFacturas.IdRenglonPedido,
		D_Pedidos.IdGrupo, D_Pedidos.IdSubgrupo, D_Pedidos.IdCodigoProducto, D_Pedidos.PorcIva

UNION ALL

Select distinct T_RecepcionFacturas.Fecha as Fecha,
D_RecepcionFacturas.Importe,
D_RecepcionFacturas.Importe * (D_OrdenServicio.PorcIva/100),
(D_RecepcionFacturas.Importe + (D_RecepcionFacturas.Importe * (D_OrdenServicio.PorcIva/100)))-SUM(isnull(T_RecepcionFacturas.Retencion,0)) as Total, 
T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
C_Proveedores.RazonSocial,'R.F.C. '+C_Proveedores.RFC as RFC, T_RecepcionFacturas.Factura,  
CASE
	WHEN T_Cheques.Status = 'I' AND T_Cheques.Entregado = 1 THEN 'Pagado' 
	WHEN T_Cheques.Status = 'D' THEN 'Pagado'
	WHEN T_Cheques.Status = 'G' THEN 'Pendiente'
	WHEN T_Cheques.Status = 'L' AND T_Cheques.IdChequesAgrupador <> 0 THEN 'Pagado'
	WHEN T_SolicitudCheques.Estatus = 'C' THEN 'Pendiente'
	ELSE 'Pendiente' 
END as Status,
SUM(isnull(T_RecepcionFacturas.Retencion,0)) as Retenciones,
T_Cheques.FechaImpresion,
C_AreaResponsabilidad.Clave , C_AreaResponsabilidad.Nombre, T_sellospresupuestales.IdPartida,
0, 0, 0
from T_RecepcionFacturas
join C_Proveedores on C_Proveedores.IdProveedor = T_RecepcionFacturas.IdProveedor
left join T_SolicitudCheques on T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios
left join T_Cheques on T_Cheques.idSolicitudCheque = T_SolicitudCheques.IdSolicitudCheques 
Left Join D_RecepcionFacturas on T_RecepcionFacturas.idRecepcionservicios=D_recepcionfacturas.idrecepcionservicios
Left join T_sellospresupuestales on D_recepcionFacturas.idsellopresupuestal=T_Sellospresupuestales.idsellopresupuestal
left join dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp 
left join C_PartidasPres on T_sellospresupuestales.IdPartida = C_PartidasPres.IdPartida
join D_OrdenServicio on D_RecepcionFacturas.IdRenglonOrden = D_OrdenServicio.IdRenglonOrden and D_RecepcionFacturas.IdRenglonOrden <> 0

Where (T_RecepcionFacturas.Fecha >= (@Fecha-1) and T_RecepcionFacturas.Fecha <= @FechaFin ) and C_Proveedores.RazonSocial =@Proveedor AND (T_RecepcionFacturas.Estatus <> 'N' and T_SolicitudCheques.Estatus <> 'N')
AND C_AreaResponsabilidad.IdAreaResp = CASE WHEN @IdUR = 0 THEN C_AreaResponsabilidad.IdAreaResp ELSE @IdUR END
AND C_PartidasPres.clavepartida =CASE WHEN @Partida = 0 THEN C_PartidasPres.clavepartida else @Partida end
		--AND T_Cheques.Status <> 'L'
AND D_RecepcionFacturas.Cantidad > 0
group by T_RecepcionFacturas.Fecha, T_RecepcionFacturas.SubTotal, T_RecepcionFacturas.IVA, T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
		C_Proveedores.RazonSocial, C_Proveedores.RFC, T_RecepcionFacturas.Factura, T_Cheques.Status, T_Cheques.Entregado, T_SolicitudCheques.Estatus, T_Cheques.IdChequesAgrupador, T_Cheques.FechaImpresion, T_Cheques.IdCheques,
		C_AreaResponsabilidad.Clave , C_AreaResponsabilidad.Nombre, T_sellospresupuestales.IdPartida, D_RecepcionFacturas.Importe, D_RecepcionFacturas.IdRenglonOrden,D_OrdenServicio.PorcIva

UNION ALL
Select T_Viaticos.Fecha, SUM(isnull(D_Viaticos.Importe,0)) as SubTotal, SUM(isnull(D_Viaticos.IVA,0)) as IVA,SUM(isnull(D_Viaticos.Importe,0))+SUM(isnull(D_Viaticos.IVA,0))as Total,T_Viaticos.Folio ,T_Viaticos.Justificacion as Observaciones,
C_Proveedores.RazonSocial,'R.F.C. '+C_Proveedores.RFC as RFC,D_Viaticos.Referencia as Factura, 'Pagado' as Status, SUM(isnull(D_Viaticos.Retenciones,0)) as Retenciones, T_Viaticos.Fecha,
C_AreaResponsabilidad.Clave , C_AreaResponsabilidad.Nombre,T_sellospresupuestales.IdPartida,
0,0,0
FROM T_Viaticos
JOIN D_Viaticos ON T_Viaticos.IdViaticos=D_Viaticos.IdViatico
join C_Proveedores on C_Proveedores.IdProveedor = D_Viaticos.IdProveedor
Left join T_sellospresupuestales on D_Viaticos.idsellopresupuestal=T_Sellospresupuestales.idsellopresupuestal
left join dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp 
left join C_PartidasPres on T_sellospresupuestales.IdPartida = C_PartidasPres.IdPartida

Where (T_Viaticos.Fecha between (@Fecha-1) and @FechaFin ) and C_Proveedores.RazonSocial =@Proveedor 
and C_AreaResponsabilidad.IdAreaResp = CASE WHEN @IdUR = 0 THEN C_AreaResponsabilidad.IdAreaResp ELSE @IdUR END
AND C_PartidasPres.clavepartida =CASE WHEN @Partida = 0 THEN C_PartidasPres.clavepartida else @Partida end

group By T_Viaticos.IdViaticos,T_Viaticos.Fecha,T_Viaticos.Total,D_Viaticos.Referencia,T_Viaticos.Justificacion,C_Proveedores.RazonSocial,C_Proveedores.RFC,T_Viaticos.Folio, D_Viaticos.Retenciones, D_Viaticos.FechaFactura,
C_AreaResponsabilidad.Clave , C_AreaResponsabilidad.Nombre, T_sellospresupuestales.IdPartida
END

IF @Proveedor ='' begin
INSERT @Tabla
Select T_RecepcionFacturas.Fecha as Fecha,
D_RecepcionFacturas.Importe,
D_RecepcionFacturas.Importe * (D_Pedidos.PorcIva/100),
(D_RecepcionFacturas.Importe + (D_RecepcionFacturas.Importe * (D_Pedidos.PorcIva/100)))-SUM(isnull(T_RecepcionFacturas.Retencion,0)) as Total,
T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
C_Proveedores.RazonSocial,'R.F.C. '+C_Proveedores.RFC as RFC, T_RecepcionFacturas.Factura, 
CASE
	WHEN T_Cheques.Status = 'I' AND T_Cheques.Entregado = 1 THEN 'Pagado' 
	WHEN T_Cheques.Status = 'D' THEN 'Pagado'
	WHEN T_Cheques.Status = 'G' THEN 'Pendiente'
	WHEN T_Cheques.Status = 'L' AND T_Cheques.IdChequesAgrupador <> 0 THEN 'Pagado'
	WHEN T_SolicitudCheques.Estatus = 'C' THEN 'Pendiente'
	ELSE 'Pendiente' 
END as Status,
SUM(isnull(T_RecepcionFacturas.Retencion,0)) as Retenciones,
T_Cheques.FechaImpresion,
C_AreaResponsabilidad.Clave , C_AreaResponsabilidad.Nombre,T_sellospresupuestales.IdPartida,
D_Pedidos.IdGrupo, D_Pedidos.IdSubgrupo, D_Pedidos.IdCodigoProducto
from T_RecepcionFacturas
join C_Proveedores on C_Proveedores.IdProveedor = T_RecepcionFacturas.IdProveedor
left join T_SolicitudCheques on T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios
left join T_Cheques on T_Cheques.idSolicitudCheque = T_SolicitudCheques.IdSolicitudCheques 
Left Join D_RecepcionFacturas on T_RecepcionFacturas.idRecepcionservicios=D_recepcionfacturas.idrecepcionservicios
left join T_sellospresupuestales on D_recepcionFacturas.idsellopresupuestal=T_Sellospresupuestales.idsellopresupuestal
left join dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp 
left join C_PartidasPres on T_sellospresupuestales.IdPartida = C_PartidasPres.IdPartida
join D_Pedidos on D_RecepcionFacturas.IdRenglonPedido = D_Pedidos.IdRenglonPedido and D_RecepcionFacturas.IdRenglonPedido <> 0


--Where (T_RecepcionFacturas.FechaFactura between @Fecha and @FechaFin )
Where (T_RecepcionFacturas.Fecha >= (@Fecha-1) and T_RecepcionFacturas.Fecha <= @FechaFin ) AND (T_RecepcionFacturas.Estatus <> 'N' and T_SolicitudCheques.Estatus <> 'N')
and C_AreaResponsabilidad.IdAreaResp = CASE WHEN @IdUR = 0 THEN C_AreaResponsabilidad.IdAreaResp ELSE @IdUR END	--AND T_Cheques.Status <> 'L'
AND C_PartidasPres.clavepartida =CASE WHEN @Partida = 0 THEN C_PartidasPres.clavepartida else @Partida end
AND D_RecepcionFacturas.Cantidad > 0

group by T_RecepcionFacturas.Fecha, T_RecepcionFacturas.SubTotal, T_RecepcionFacturas.IVA, T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
		C_Proveedores.RazonSocial, C_Proveedores.RFC, T_RecepcionFacturas.Factura, T_Cheques.Status, T_Cheques.Entregado, T_SolicitudCheques.Estatus, T_Cheques.IdChequesAgrupador, T_Cheques.FechaImpresion, T_Cheques.IdCheques,
		C_AreaResponsabilidad.Clave , C_AreaResponsabilidad.Nombre, T_sellospresupuestales.IdPartida, D_RecepcionFacturas.Importe, D_RecepcionFacturas.IdRenglonPedido,D_Pedidos.PorcIva,
		D_Pedidos.IdGrupo, D_Pedidos.IdSubgrupo, D_Pedidos.IdCodigoProducto
UNION ALL

Select T_RecepcionFacturas.Fecha as Fecha,
D_RecepcionFacturas.Importe,
D_RecepcionFacturas.Importe * (D_OrdenServicio.PorcIva/100),
(D_RecepcionFacturas.Importe + (D_RecepcionFacturas.Importe * (D_OrdenServicio.PorcIva/100)))-SUM(isnull(T_RecepcionFacturas.Retencion,0)) as Total,
T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
C_Proveedores.RazonSocial,'R.F.C. '+C_Proveedores.RFC as RFC, T_RecepcionFacturas.Factura, 
CASE
	WHEN T_Cheques.Status = 'I' AND T_Cheques.Entregado = 1 THEN 'Pagado' 
	WHEN T_Cheques.Status = 'D' THEN 'Pagado'
	WHEN T_Cheques.Status = 'G' THEN 'Pendiente'
	WHEN T_Cheques.Status = 'L' AND T_Cheques.IdChequesAgrupador <> 0 THEN 'Pagado'
	WHEN T_SolicitudCheques.Estatus = 'C' THEN 'Pendiente'
	ELSE 'Pendiente' 
END as Status,
SUM(isnull(T_RecepcionFacturas.Retencion,0)) as Retenciones,
T_Cheques.FechaImpresion,
C_AreaResponsabilidad.Clave , C_AreaResponsabilidad.Nombre,T_sellospresupuestales.IdPartida,
0,0,0
from T_RecepcionFacturas
join C_Proveedores on C_Proveedores.IdProveedor = T_RecepcionFacturas.IdProveedor
left join T_SolicitudCheques on T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios
left join T_Cheques on T_Cheques.idSolicitudCheque = T_SolicitudCheques.IdSolicitudCheques 
Left Join D_RecepcionFacturas on T_RecepcionFacturas.idRecepcionservicios=D_recepcionfacturas.idrecepcionservicios
left join T_sellospresupuestales on D_recepcionFacturas.idsellopresupuestal=T_Sellospresupuestales.idsellopresupuestal
left join dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp 
left join C_PartidasPres on T_sellospresupuestales.IdPartida = C_PartidasPres.IdPartida
join D_OrdenServicio on D_RecepcionFacturas.IdRenglonOrden = D_OrdenServicio.IdRenglonOrden and D_RecepcionFacturas.IdRenglonOrden <> 0


--Where (T_RecepcionFacturas.FechaFactura between @Fecha and @FechaFin )
Where (T_RecepcionFacturas.Fecha >= (@Fecha-1) and T_RecepcionFacturas.Fecha <= @FechaFin ) AND (T_RecepcionFacturas.Estatus <> 'N' and T_SolicitudCheques.Estatus <> 'N')
and C_AreaResponsabilidad.IdAreaResp = CASE WHEN @IdUR = 0 THEN C_AreaResponsabilidad.IdAreaResp ELSE @IdUR END	--AND T_Cheques.Status <> 'L'
AND C_PartidasPres.clavepartida =CASE WHEN @Partida = 0 THEN C_PartidasPres.clavepartida else @Partida end
AND D_RecepcionFacturas.Cantidad > 0

group by T_RecepcionFacturas.Fecha, T_RecepcionFacturas.SubTotal, T_RecepcionFacturas.IVA, T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
		C_Proveedores.RazonSocial, C_Proveedores.RFC, T_RecepcionFacturas.Factura, T_Cheques.Status, T_Cheques.Entregado, T_SolicitudCheques.Estatus, T_Cheques.IdChequesAgrupador, T_Cheques.FechaImpresion, T_Cheques.IdCheques,
		C_AreaResponsabilidad.Clave , C_AreaResponsabilidad.Nombre, T_sellospresupuestales.IdPartida, D_RecepcionFacturas.Importe, D_RecepcionFacturas.IdRenglonOrden,D_OrdenServicio.PorcIva

UNION ALL

Select T_Viaticos.Fecha, SUM(isnull(D_Viaticos.Importe,0)) as SubTotal, SUM(isnull(D_Viaticos.IVA,0)) as IVA,SUM(isnull(D_Viaticos.Importe,0))+SUM(isnull(D_Viaticos.IVA,0))as Total,T_Viaticos.Folio,T_Viaticos.Justificacion as Observaciones,
C_Proveedores.RazonSocial,'R.F.C. '+C_Proveedores.RFC as RFC,D_Viaticos.Referencia as Factura, 'Pagado' as Status, SUM(isnull(D_Viaticos.Retenciones,0)) as Retenciones, T_Viaticos.Fecha,
C_AreaResponsabilidad.Clave , C_AreaResponsabilidad.Nombre,T_sellospresupuestales.IdPartida,
0,0,0
FROM T_Viaticos
LEFT OUTER JOIN D_Viaticos ON T_Viaticos.IdViaticos=D_Viaticos.IdViatico
LEFT OUTER JOIN C_Proveedores on C_Proveedores.IdProveedor = D_Viaticos.IdProveedor
Left join T_sellospresupuestales on D_Viaticos.idsellopresupuestal=T_Sellospresupuestales.idsellopresupuestal
left join dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp 
left join C_PartidasPres on T_sellospresupuestales.IdPartida = C_PartidasPres.IdPartida

Where (T_Viaticos.Fecha between (@Fecha-1) and @FechaFin )
and C_AreaResponsabilidad.IdAreaResp = CASE WHEN @IdUR = 0 THEN C_AreaResponsabilidad.IdAreaResp ELSE @IdUR END 
AND C_PartidasPres.clavepartida =CASE WHEN @Partida = 0 THEN C_PartidasPres.clavepartida else @Partida end

group By T_Viaticos.IdViaticos,T_Viaticos.Fecha,T_Viaticos.Total,D_Viaticos.Referencia,T_Viaticos.Justificacion,C_Proveedores.RazonSocial,C_Proveedores.RFC,T_Viaticos.Folio, D_Viaticos.Retenciones, D_Viaticos.FechaFactura,
C_AreaResponsabilidad.Clave , C_AreaResponsabilidad.Nombre,T_sellospresupuestales.IdPartida
END


If @Estatus <> ''
	Begin
		Select * From @Tabla Where [Status] = @Estatus Order by RazonSocial,Fecha
	End 
	Else
	Begin
		Select * From @Tabla Order by RazonSocial,Fecha 
	End
	

END

Exec SP_CFG_LogScripts 'SP_RPT_K2_FacturasRecibidas_UR','2.30.1'
GO