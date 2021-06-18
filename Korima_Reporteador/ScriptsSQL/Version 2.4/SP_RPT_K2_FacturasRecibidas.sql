/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_FacturasRecibidas]    Script Date: 10/23/2013 13:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_FacturasRecibidas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_FacturasRecibidas]
GO


/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_FacturasRecibidas]    Script Date: 10/23/2013 13:07:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_FacturasRecibidas]
@Fecha Datetime,
@FechaFin Datetime,
@Proveedor varchar(max)
as
DECLARE @Tabla TABLE (Fecha datetime,SubTotal decimal(15,2),IVA decimal(15,2),Total decimal(15,2),Folio Int,Observaciones varchar(max),RazonSocial varchar(max), RFC varchar(max), Factura varchar(max))

IF @Proveedor <>'' begin
INSERT @Tabla
Select T_RecepcionFacturas.FechaFactura as Fecha,T_RecepcionFacturas.SubTotal,T_RecepcionFacturas.IVA,T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
C_Proveedores.RazonSocial,'R.F.C. '+C_Proveedores.RFC as RFC, T_RecepcionFacturas.Factura 
from T_RecepcionFacturas
join C_Proveedores on C_Proveedores.IdProveedor = T_RecepcionFacturas.IdProveedor 
Where (T_RecepcionFacturas.FechaFactura between @Fecha and @FechaFin ) and C_Proveedores.RazonSocial =@Proveedor 
UNION
Select T_Viaticos.Fecha, SUM(isnull(D_Viaticos.Importe,0)) as SubTotal, SUM(isnull(D_Viaticos.IVA,0)) as IVA,SUM(isnull(D_Viaticos.Importe,0))+SUM(isnull(D_Viaticos.IVA,0))as Total,T_Viaticos.Folio ,T_Viaticos.Justificacion as Observaciones,
C_Proveedores.RazonSocial,'R.F.C. '+C_Proveedores.RFC as RFC,D_Viaticos.Referencia as Factura
FROM T_Viaticos
JOIN D_Viaticos ON T_Viaticos.IdViaticos=D_Viaticos.IdViatico
join C_Proveedores on C_Proveedores.IdProveedor = D_Viaticos.IdProveedor
Where (T_Viaticos.Fecha between @Fecha and @FechaFin ) and C_Proveedores.RazonSocial =@Proveedor 
group By T_Viaticos.IdViaticos,T_Viaticos.Fecha,T_Viaticos.Total,D_Viaticos.Referencia,T_Viaticos.Justificacion,C_Proveedores.RazonSocial,C_Proveedores.RFC,T_Viaticos.Folio
END

IF @Proveedor ='' begin
INSERT @Tabla
Select T_RecepcionFacturas.FechaFactura as Fecha,T_RecepcionFacturas.SubTotal,T_RecepcionFacturas.IVA,T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.Observaciones,
C_Proveedores.RazonSocial,'R.F.C. '+C_Proveedores.RFC as RFC, T_RecepcionFacturas.Factura 
from T_RecepcionFacturas
join C_Proveedores on C_Proveedores.IdProveedor = T_RecepcionFacturas.IdProveedor 
Where (T_RecepcionFacturas.FechaFactura between @Fecha and @FechaFin )
UNION
Select T_Viaticos.Fecha, SUM(isnull(D_Viaticos.Importe,0)) as SubTotal, SUM(isnull(D_Viaticos.IVA,0)) as IVA,SUM(isnull(D_Viaticos.Importe,0))+SUM(isnull(D_Viaticos.IVA,0))as Total,T_Viaticos.Folio,T_Viaticos.Justificacion as Observaciones,
C_Proveedores.RazonSocial,'R.F.C. '+C_Proveedores.RFC as RFC,D_Viaticos.Referencia as Factura
FROM T_Viaticos
LEFT OUTER JOIN D_Viaticos ON T_Viaticos.IdViaticos=D_Viaticos.IdViatico
LEFT OUTER JOIN C_Proveedores on C_Proveedores.IdProveedor = D_Viaticos.IdProveedor
Where (T_Viaticos.Fecha between @Fecha and @FechaFin )
group By T_Viaticos.IdViaticos,T_Viaticos.Fecha,T_Viaticos.Total,D_Viaticos.Referencia,T_Viaticos.Justificacion,C_Proveedores.RazonSocial,C_Proveedores.RFC,T_Viaticos.Folio
END

select * from @Tabla order by RazonSocial,Fecha 

GO

EXEC SP_FirmasReporte 'Facturas Recibidas'
GO


