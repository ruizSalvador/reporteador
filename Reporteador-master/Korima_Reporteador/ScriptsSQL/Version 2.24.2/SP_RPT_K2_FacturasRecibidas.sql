/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_FacturasRecibidas]    Script Date: 10/23/2013 13:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_FacturasRecibidas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_FacturasRecibidas]
GO


/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_FacturasRecibidas]    Script Date: 10/23/2013 13:07:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RPT_K2_FacturasRecibidas '20160101','20161231','Agustin Perez Llamas'
CREATE PROCEDURE [dbo].[SP_RPT_K2_FacturasRecibidas]
@Fecha Datetime,
@FechaFin Datetime,
@Proveedor varchar(max)
as
DECLARE @Tabla TABLE (Fecha datetime,SubTotal decimal(15,2),IVA decimal(15,2),Total decimal(15,2),Folio Int,Observaciones varchar(max),RazonSocial varchar(max), RFC varchar(max), Factura varchar(max), Status varchar(15), Retenciones Decimal(18,2), FechaAplicacion Datetime)

IF @Proveedor <>'' begin
INSERT @Tabla
Select distinct T_RecepcionFacturas.Fecha as Fecha,T_RecepcionFacturas.SubTotal,T_RecepcionFacturas.IVA,T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
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
T_Cheques.FechaImpresion
from T_RecepcionFacturas
join C_Proveedores on C_Proveedores.IdProveedor = T_RecepcionFacturas.IdProveedor
left join T_SolicitudCheques on T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios
left join T_Cheques on T_Cheques.idSolicitudCheque = T_SolicitudCheques.IdSolicitudCheques 
Where (T_RecepcionFacturas.Fecha >= (@Fecha-1) and T_RecepcionFacturas.Fecha <= @FechaFin ) and C_Proveedores.RazonSocial =@Proveedor AND (T_RecepcionFacturas.Estatus <> 'N' and T_SolicitudCheques.Estatus <> 'N')
		--AND T_Cheques.Status <> 'L'
group by T_RecepcionFacturas.Fecha, T_RecepcionFacturas.SubTotal, T_RecepcionFacturas.IVA, T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
		C_Proveedores.RazonSocial, C_Proveedores.RFC, T_RecepcionFacturas.Factura, T_Cheques.Status, T_Cheques.Entregado, T_SolicitudCheques.Estatus, T_Cheques.IdChequesAgrupador, T_Cheques.FechaImpresion, T_Cheques.IdCheques


UNION
Select T_Viaticos.Fecha, SUM(isnull(D_Viaticos.Importe,0)) as SubTotal, SUM(isnull(D_Viaticos.IVA,0)) as IVA,SUM(isnull(D_Viaticos.Importe,0))+SUM(isnull(D_Viaticos.IVA,0))as Total,T_Viaticos.Folio ,T_Viaticos.Justificacion as Observaciones,
C_Proveedores.RazonSocial,'R.F.C. '+C_Proveedores.RFC as RFC,D_Viaticos.Referencia as Factura, 'Pagado' as Status, SUM(isnull(D_Viaticos.Retenciones,0)) as Retenciones, T_Viaticos.Fecha
FROM T_Viaticos
JOIN D_Viaticos ON T_Viaticos.IdViaticos=D_Viaticos.IdViatico
join C_Proveedores on C_Proveedores.IdProveedor = D_Viaticos.IdProveedor
Where (T_Viaticos.Fecha between (@Fecha-1) and @FechaFin ) and C_Proveedores.RazonSocial =@Proveedor 
group By T_Viaticos.IdViaticos,T_Viaticos.Fecha,T_Viaticos.Total,D_Viaticos.Referencia,T_Viaticos.Justificacion,C_Proveedores.RazonSocial,C_Proveedores.RFC,T_Viaticos.Folio, D_Viaticos.Retenciones, D_Viaticos.FechaFactura
END

IF @Proveedor ='' begin
INSERT @Tabla
Select T_RecepcionFacturas.Fecha as Fecha,T_RecepcionFacturas.SubTotal,T_RecepcionFacturas.IVA,T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
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
T_Cheques.FechaImpresion
from T_RecepcionFacturas
join C_Proveedores on C_Proveedores.IdProveedor = T_RecepcionFacturas.IdProveedor
left join T_SolicitudCheques on T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios
left join T_Cheques on T_Cheques.idSolicitudCheque = T_SolicitudCheques.IdSolicitudCheques 
--Where (T_RecepcionFacturas.FechaFactura between @Fecha and @FechaFin )
Where (T_RecepcionFacturas.Fecha >= (@Fecha-1) and T_RecepcionFacturas.Fecha <= @FechaFin ) AND (T_RecepcionFacturas.Estatus <> 'N' and T_SolicitudCheques.Estatus <> 'N')
	--AND T_Cheques.Status <> 'L'
group by T_RecepcionFacturas.Fecha, T_RecepcionFacturas.SubTotal, T_RecepcionFacturas.IVA, T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
		C_Proveedores.RazonSocial, C_Proveedores.RFC, T_RecepcionFacturas.Factura, T_Cheques.Status, T_Cheques.Entregado, T_SolicitudCheques.Estatus, T_Cheques.IdChequesAgrupador, T_Cheques.FechaImpresion, T_Cheques.IdCheques
UNION
Select T_Viaticos.Fecha, SUM(isnull(D_Viaticos.Importe,0)) as SubTotal, SUM(isnull(D_Viaticos.IVA,0)) as IVA,SUM(isnull(D_Viaticos.Importe,0))+SUM(isnull(D_Viaticos.IVA,0))as Total,T_Viaticos.Folio,T_Viaticos.Justificacion as Observaciones,
C_Proveedores.RazonSocial,'R.F.C. '+C_Proveedores.RFC as RFC,D_Viaticos.Referencia as Factura, 'Pagado' as Status, SUM(isnull(D_Viaticos.Retenciones,0)) as Retenciones, T_Viaticos.Fecha
FROM T_Viaticos
LEFT OUTER JOIN D_Viaticos ON T_Viaticos.IdViaticos=D_Viaticos.IdViatico
LEFT OUTER JOIN C_Proveedores on C_Proveedores.IdProveedor = D_Viaticos.IdProveedor
Where (T_Viaticos.Fecha between (@Fecha-1) and @FechaFin )
group By T_Viaticos.IdViaticos,T_Viaticos.Fecha,T_Viaticos.Total,D_Viaticos.Referencia,T_Viaticos.Justificacion,C_Proveedores.RazonSocial,C_Proveedores.RFC,T_Viaticos.Folio, D_Viaticos.Retenciones, D_Viaticos.FechaFactura
END

select * from @Tabla order by RazonSocial,Fecha 

GO

EXEC SP_FirmasReporte 'Facturas Recibidas'
GO

Exec SP_CFG_LogScripts 'SP_RPT_K2_FacturasRecibidas'
GO



