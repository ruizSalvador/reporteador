
/****** Object:  View [dbo].[VW_BI_EgresosFacturas]    Script Date: 10/24/2012 09:40:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BI_EgresosFacturas]'))
DROP VIEW [dbo].[VW_BI_EgresosFacturas]
GO
/****** Object:  View [dbo].[VW_BI_EgresosFacturas]    Script Date: 10/24/2012 09:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_BI_EgresosFacturas]
AS

Select distinct  
C_Proveedores.RFC as CveProveedor, 
C_Proveedores.RazonSocial as NombreProveedor,
T_RecepcionFacturas.Fecha as Fecha,
T_RecepcionFacturas.Factura, 
T_RecepcionFacturas.Observaciones as Descripcion,
ROUND(T_RecepcionFacturas.Total,2) as Facturado,
ISNULL((Select SUM(ImporteCheque) from T_Cheques Where IdSolicitudCheque in (Select IdSolicitudCheques from T_SolicitudCheques where IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios) and (Status in ('I','D') and IdCheques not in (Select IdChequesAgrupador from T_Cheques) or (Status = 'L') )),0) as Pagado,
ROUND(T_RecepcionFacturas.Total,2) - ISNULL((Select SUM(ImporteCheque) from T_Cheques Where IdSolicitudCheque in (Select IdSolicitudCheques from T_SolicitudCheques where IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios) and (Status in ('I','D') and IdCheques not in (Select IdChequesAgrupador from T_Cheques) or (Status = 'L') )),0) as Pendiente,
(Select MAX(Fecha) from T_Cheques Where IdSolicitudCheque in (Select IdSolicitudCheques from T_SolicitudCheques where IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios)) as FechaUltimoPago,
CASE 
WHEN (Select SUM(Importe) from D_RecepcionFacturas Where IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios) = 0 THEN 'PAGO SOLICITADO'
WHEN (ROUND(T_RecepcionFacturas.Total,2) - ISNULL((Select SUM(ImporteCheque) from T_Cheques Where IdSolicitudCheque in (Select IdSolicitudCheques from T_SolicitudCheques where IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios) and (Status in ('I','D') and IdCheques not in (Select IdChequesAgrupador from T_Cheques) or (Status = 'L') )),0)) <> 0 THEN 'PAGADA PARCIALMENTE'
WHEN (ROUND(T_RecepcionFacturas.Total,2) - ISNULL((Select SUM(ImporteCheque) from T_Cheques Where IdSolicitudCheque in (Select IdSolicitudCheques from T_SolicitudCheques where IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios) and (Status in ('I','D') and IdCheques not in (Select IdChequesAgrupador from T_Cheques) or (Status = 'L') )),0)) = 0 THEN 'PAGADA TOTALMENTE'
END AS Estatus,
CASE T_RecepcionFacturas.Tipo
WHEN 1 THEN 'Material y Consumibles'
WHEN 2 THEN 'Activos Fijos'
WHEN 3 THEN 'Servicios'
WHEN 4 THEN 'Honorarios'
WHEN 5 THEN 'Obra'
WHEN 6 THEN 'Deuda'
WHEN 7 THEN 'Subsidios'
WHEN 8 THEN 'Inversiones'
END as TipoFactura,
T_RecepcionFacturas.Estatus as EstatusFactura
from T_RecepcionFacturas
left join C_Proveedores on C_Proveedores.IdProveedor = T_RecepcionFacturas.IdProveedor

--Where  
-- (T_RecepcionFacturas.Estatus <> 'N')
Group By T_RecepcionFacturas.Folio, C_Proveedores.RFC, C_Proveedores.RazonSocial, T_RecepcionFacturas.Fecha, T_RecepcionFacturas.Factura, T_RecepcionFacturas.Observaciones,
T_RecepcionFacturas.Total, T_RecepcionFacturas.IdRecepcionServicios, T_RecepcionFacturas.Tipo, T_RecepcionFacturas.Estatus

UNION ALL


Select 
C_Proveedores.RFC as CveProveedor, 
C_Proveedores.RazonSocial as NombreProveedor, 
T_Viaticos.Fecha,
D_Viaticos.Referencia as Factura, 
T_Viaticos.Justificacion as Descripcion,
T_Viaticos.Total as Facturado,
T_Viaticos.Pagado as Pagado,
T_Viaticos.Total-T_Viaticos.Pagado as Pendiente,
T_Viaticos.Fecha as FechaUltimoPago,
CASE 
WHEN T_Viaticos.Pagado = 0 THEN 'PAGO SOLICITADO'
WHEN (T_Viaticos.Total - T_Viaticos.Pagado) <> 0 THEN 'PAGADA PARCIALMENTE'
WHEN (T_Viaticos.Total - T_Viaticos.Pagado) = 0 THEN 'PAGADA TOTALMENTE'
END AS Estatus, 
'Gastos por Comprobar' as TipoFactura,
T_Viaticos.Estatus as EstatusFactura
FROM T_Viaticos
JOIN D_Viaticos ON T_Viaticos.IdViaticos=D_Viaticos.IdViatico
join C_Proveedores on C_Proveedores.IdProveedor = D_Viaticos.IdProveedor
Left join T_sellospresupuestales on D_Viaticos.idsellopresupuestal=T_Sellospresupuestales.idsellopresupuestal
left join dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp 
left join C_PartidasPres on T_sellospresupuestales.IdPartida = C_PartidasPres.IdPartida

group By T_Viaticos.Folio, C_Proveedores.RFC, C_Proveedores.RazonSocial,T_Viaticos.Fecha,
D_Viaticos.Referencia, T_Viaticos.Justificacion, T_Viaticos.Total, C_AreaResponsabilidad.Clave, C_AreaResponsabilidad.Nombre,
T_sellospresupuestales.IdPartida, T_Viaticos.Pagado, T_Viaticos.Estatus

GO