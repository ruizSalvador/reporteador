
/****** Object:  View [dbo].[VW_BI_EgresosFacturasLineas]    Script Date: 10/24/2012 09:40:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BI_EgresosFacturasLineas]'))
DROP VIEW [dbo].[VW_BI_EgresosFacturasLineas]
GO
/****** Object:  View [dbo].[VW_BI_EgresosFacturasLineas]    Script Date: 10/24/2012 09:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_BI_EgresosFacturasLineas]
AS

Select distinct 

C_Proveedores.RFC as CveProveedor, 
T_RecepcionFacturas.Factura,
D_RecepcionFacturas.Importe as ImporteLinea,

T_sellospresupuestales.IdPartida as CveGasto,
C_PartidasPres.DescripcionPartida as DescCveGasto,
C_AreaResponsabilidad.Clave as CC
from T_RecepcionFacturas
join C_Proveedores on C_Proveedores.IdProveedor = T_RecepcionFacturas.IdProveedor
Left Join D_RecepcionFacturas on T_RecepcionFacturas.idRecepcionservicios=D_recepcionfacturas.idrecepcionservicios
Left join T_sellospresupuestales on D_recepcionFacturas.idsellopresupuestal=T_Sellospresupuestales.idsellopresupuestal
left join dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp 
left join C_PartidasPres on T_sellospresupuestales.IdPartida = C_PartidasPres.IdPartida

Where 
D_RecepcionFacturas.Cantidad > 0

UNION ALL

Select distinct 

C_Proveedores.RFC as CveProveedor, 
D_Viaticos.Referencia,
D_Viaticos.Importe as ImporteLinea,

T_sellospresupuestales.IdPartida as CveGasto,
C_PartidasPres.DescripcionPartida as DescCveGasto,
C_AreaResponsabilidad.Clave as CC
from D_Viaticos
join C_Proveedores on C_Proveedores.IdProveedor = D_Viaticos.IdProveedor
Left join T_sellospresupuestales on D_Viaticos.Idsellopresupuestal=T_Sellospresupuestales.idsellopresupuestal
left join dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp 
left join C_PartidasPres on T_sellospresupuestales.IdPartida = C_PartidasPres.IdPartida



GO
