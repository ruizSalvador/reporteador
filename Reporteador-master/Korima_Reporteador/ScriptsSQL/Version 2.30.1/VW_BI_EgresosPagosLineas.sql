/****** Object:  View [dbo].[VW_BI_EgresosPagosLineas]    Script Date: 10/24/2012 09:40:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BI_EgresosPagosLineas]'))
DROP VIEW [dbo].[VW_BI_EgresosPagosLineas]
GO
/****** Object:  View [dbo].[VW_BI_EgresosPagosLineas]    Script Date: 02/12/2012 09:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_BI_EgresosPagosLineas]
AS

Select distinct  
T_SolicitudCheques.FolioPorTipo as NoSolPago,
T_RecepcionFacturas.Factura,
T_RecepcionFacturas.Fecha,
ROUND(T_RecepcionFacturas.Total,2) as TotalFactura,

ISNULL((Select SUM(ImporteCheque) from T_Cheques Where IdSolicitudCheque in (Select IdSolicitudCheques from T_SolicitudCheques where IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios) and (Status in ('I','D') and IdCheques not in (Select IdChequesAgrupador from T_Cheques) or (Status = 'L') )),0) as PagadoFactura,
(ROUND(T_RecepcionFacturas.Total,2) - ISNULL((Select SUM(ImporteCheque) from T_Cheques Where IdSolicitudCheque in (Select IdSolicitudCheques from T_SolicitudCheques where IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios) and (Status in ('I','D') and IdCheques not in (Select IdChequesAgrupador from T_Cheques) or (Status = 'L') )),0)) as PendienteFactura,
ISNULL((Select SUM(ImporteCheque) from T_Cheques Where IdSolicitudCheque in (Select IdSolicitudCheques from T_SolicitudCheques where IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios) and (Status in ('I','D') and IdCheques not in (Select IdChequesAgrupador from T_Cheques) or (Status = 'L') )),0) as Abono,
T_RecepcionFacturas.Estatus

FROM T_RecepcionFacturas
 JOIN T_SolicitudCheques on T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios

GO

