
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_ComprasYServicios_Dependencia_Partida]    Script Date: 04/18/2013 17:09:26 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_ComprasYServicios_Dependencia_Partida]'))
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_ComprasYServicios_Dependencia_Partida]
GO


/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_ComprasYServicios_Dependencia_Partida]    Script Date: 04/18/2013 17:09:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_ComprasYServicios_Dependencia_Partida]
AS
SELECT     TOP (100) PERCENT maskUnidadResponsable, PartPres_mask_ClaveNombre, SUM(Total) AS Total, ClavePartida, UnidadResponsable_Clave, PedidosDetalle_Fecha, 
                      UnidadResponsable_Nombre, PartPres_Nombre
FROM         dbo.VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia
GROUP BY maskUnidadResponsable, PartPres_mask_ClaveNombre, ClavePartida, UnidadResponsable_Clave, PedidosDetalle_Fecha, UnidadResponsable_Nombre, 
                      PartPres_Nombre
ORDER BY maskUnidadResponsable, PartPres_mask_ClaveNombre

