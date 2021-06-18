
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia]    Script Date: 04/18/2013 17:09:26 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia]'))
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia]
GO


/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia]    Script Date: 04/18/2013 17:09:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia]
AS
SELECT     dbo.T_Pedidos.IdSolicitud, dbo.T_SellosPresupuestales.IdPartida AS IdOrden, dbo.T_Pedidos.Folio, 
                      CASE T_Pedidos.Estatus WHEN 'R' THEN 'Recibido' WHEN 'P' THEN 'Pedido' WHEN 'N' THEN 'Cancelado' END AS Estatus, dbo.T_Pedidos.IdProveedor, 
                      dbo.C_Proveedores.RazonSocial, dbo.T_SellosPresupuestales.Sello AS IdPartida, dbo.T_Pedidos.Observaciones, 
                      CASE dbo.D_Pedidos.DescripcionAdicional WHEN '' THEN dbo.C_Maestro.DescripcionGenerica ELSE dbo.D_Pedidos.DescripcionAdicional END AS DescripcionServicio,
                       dbo.C_AreaResponsabilidad.Clave, dbo.C_PartidasPres.ClavePartida, dbo.C_AreaResponsabilidad.Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS maskUnidadResponsable, 
                      dbo.C_AreaResponsabilidad.Clave AS UnidadResponsable_Clave, dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_mask_ClaveNombre, 
                      dbo.C_PartidasPres.ClavePartida AS PartPres_Clave, dbo.C_PartidasPres.DescripcionPartida AS PartPres_Nombre, 
                      dbo.C_PartidasPres.ClavePartida + ' ' + dbo.C_PartidasPres.DescripcionPartida AS PartPres_mask_ClaveNombre, 
                      dbo.C_Proveedores.IdProveedor AS Proveedores_ID, dbo.C_Proveedores.RazonSocial AS Proveedores_RazonSocial, 
                      CAST(dbo.C_Proveedores.IdProveedor AS VARCHAR) + ' ' + dbo.C_Proveedores.RazonSocial AS Proveedores_mask_IdRazonSocial, 
                      dbo.T_Pedidos.Folio AS PedidosDetalle_OrdenCompra, dbo.T_Pedidos.Fecha AS PedidosDetalle_Fecha, dbo.D_Pedidos.Cantidad AS PedidosDetalle_Cantidad, 
                      dbo.D_Pedidos.CostoUnitario AS PedidosDetalle_CostoUnitario, dbo.D_Pedidos.Importe AS PedidosDetalle_Importe, 
                      dbo.C_Maestro.DescripcionGenerica AS PedidosDetalle_Descripcion, dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN5 AS Proyecto, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN4 AS ActividadInstitucional, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN3 AS Accion, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN2 AS Programa, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.Nombre AS Eje, dbo.T_SellosPresupuestales.IdProyecto, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.Clave AS ClaveN1, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN2, dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN3, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN4, dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN5, 
                      dbo.T_Solicitudes.Folio AS FolioRequisicion, 'OC' AS TIPOMOVIMIENTO, CASE dbo.T_Pedidos.AplicaIVA WHEN 1 THEN ROUND((dbo.D_Pedidos.PorcIVA/100) * ( dbo.D_Pedidos.Importe),3) else 0 END AS PedidosDetalle_IVA, 
                      CASE dbo.T_Pedidos.AplicaIVA WHEN 1 THEN ROUND((dbo.D_Pedidos.PorcIVA/100) * ( dbo.D_Pedidos.Importe),3) + dbo.D_Pedidos.Importe else dbo.D_Pedidos.Importe  END  Total
FROM         dbo.T_SellosPresupuestales INNER JOIN
                      dbo.D_Pedidos ON dbo.T_SellosPresupuestales.IdSelloPresupuestal = dbo.D_Pedidos.IdSelloPresupuestal INNER JOIN
                      dbo.C_Maestro ON dbo.D_Pedidos.IdCodigoProducto = dbo.C_Maestro.IdCodigoProducto AND dbo.D_Pedidos.IdGrupo = dbo.C_Maestro.IdGrupo AND 
                      dbo.D_Pedidos.IdSubGrupo = dbo.C_Maestro.IdSubGrupo INNER JOIN
                      dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp INNER JOIN
                      dbo.C_PartidasPres ON dbo.T_SellosPresupuestales.IdPartida = dbo.C_PartidasPres.IdPartida INNER JOIN
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree ON 
                      dbo.T_SellosPresupuestales.IdProyecto = dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.IdN5 RIGHT OUTER JOIN
                      dbo.T_Pedidos ON dbo.D_Pedidos.IdPedido = dbo.T_Pedidos.IdPedido LEFT OUTER JOIN
                      dbo.C_Proveedores ON dbo.C_Proveedores.IdProveedor = dbo.T_Pedidos.IdProveedor LEFT OUTER JOIN
                      dbo.T_Solicitudes ON dbo.T_Pedidos.IdSolicitud = dbo.T_Solicitudes.IdSolicitud
WHERE     (dbo.T_Pedidos.IdPedido IN
                          (SELECT     IdPedido
                            FROM          dbo.D_Pedidos AS D_Pedidos_1
                            WHERE      (IdSelloPresupuestal IN
                                                       (SELECT     IdSelloPresupuestal
                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) AND (dbo.T_Pedidos.Estatus <> 'C')
UNION
SELECT     dbo.T_OrdenServicio.IdSolicitud, dbo.T_SellosPresupuestales.IdPartida AS IdOrden, dbo.T_OrdenServicio.Folio, 
                      CASE T_OrdenServicio.Estatus WHEN 'R' THEN 'Recibido' WHEN 'P' THEN 'Pedido' WHEN 'N' THEN 'Cancelado' END AS Estatus, dbo.T_OrdenServicio.IdProveedor, 
                      dbo.C_Proveedores.RazonSocial, dbo.T_SellosPresupuestales.Sello AS IdPartida, dbo.T_OrdenServicio.Observaciones, dbo.D_OrdenServicio.DescripcionServicio, 
                      dbo.C_AreaResponsabilidad.Clave, dbo.C_PartidasPres.ClavePartida, dbo.C_AreaResponsabilidad.Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS maskUnidadResponsable, 
                      dbo.C_AreaResponsabilidad.Clave AS UnidadResponsable_Clave, dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_mask_ClaveNombre, 
                      dbo.C_PartidasPres.ClavePartida AS PartPres_Clave, dbo.C_PartidasPres.DescripcionPartida AS PartPres_Nombre, 
                      dbo.C_PartidasPres.ClavePartida + ' ' + dbo.C_PartidasPres.DescripcionPartida AS PartPres_mask_ClaveNombre, 
                      dbo.C_Proveedores.IdProveedor AS Proveedores_ID, dbo.C_Proveedores.RazonSocial AS Proveedores_RazonSocial, 
                      CAST(dbo.C_Proveedores.IdProveedor AS VARCHAR) + ' ' + dbo.C_Proveedores.RazonSocial AS Proveedores_mask_IdRazonSocial, 
                      dbo.T_OrdenServicio.Folio AS PedidosDetalle_OrdenCompra, dbo.T_OrdenServicio.Fecha AS PedidosDetalle_Fecha, 
                      dbo.D_OrdenServicio.Cantidad AS PedidosDetalle_Cantidad, dbo.D_OrdenServicio.CostoUnitario AS PedidosDetalle_CostoUnitario, 
                      dbo.D_OrdenServicio.Importe AS PedidosDetalle_Importe, dbo.D_OrdenServicio.DescripcionServicio AS Pedidos_Detalle_Descripcion, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN5 AS Proyecto, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN4 AS ActividadInstitucional, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN3 AS Accion, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN2 AS Programa, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.Nombre AS Eje, dbo.T_SellosPresupuestales.IdProyecto, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.Clave AS ClaveN1, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN2, dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN3, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN4, dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN5, 
                      dbo.T_Solicitudes.Folio AS FolioRequisicion, 'OS' AS TIPOMOVIMIENTO, 
                      case
						When T_OrdenServicio.AplicaIVA = 0 then 0 
						When T_OrdenServicio.AplicaIVA = 1 and IVA_PORC > 0 then ((T_OrdenServicio.IVA_PORC/100) *dbo.D_OrdenServicio.Importe)
						WHEN T_OrdenServicio.APlicaIVA = 1 and IVA_PORC = 0 then D_OrdenServicio.IVA
					  END as PedidosDetalle_IVA,
                      --dbo.D_OrdenServicio.Importe * .16 AS PedidosDetalle_IVA, 
                      case
						When T_OrdenServicio.AplicaIVA = 0 then D_OrdenServicio.Importe
						When T_OrdenServicio.AplicaIVA = 1 and IVA_PORC > 0 then (((T_OrdenServicio.IVA_PORC/100) *dbo.D_OrdenServicio.Importe)+D_OrdenServicio.Importe)
						WHEN T_OrdenServicio.APlicaIVA = 1 and IVA_PORC = 0 then (dbo.D_OrdenServicio.IVA+ D_OrdenServicio.Importe) 
					  END as Total                                           
                      --CASE dbo.T_OrdenServicio.AplicaIVA WHEN 1 THEN ROUND((dbo.T_OrdenServicio.IVA_PORC/100) * ( dbo.D_OrdenServicio.Importe),3)+ D_OrdenServicio.Importe else D_OrdenServicio.Importe end as Total
					  --T_OrdenServicio.TotalGral as Total
                      --dbo.D_OrdenServicio.Importe + dbo.D_OrdenServicio.Importe * .16 AS Total
FROM         dbo.T_SellosPresupuestales INNER JOIN
                      dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp INNER JOIN
                      dbo.C_PartidasPres ON dbo.T_SellosPresupuestales.IdPartida = dbo.C_PartidasPres.IdPartida INNER JOIN
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree ON 
                      dbo.T_SellosPresupuestales.IdProyecto = dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.IdN5 INNER JOIN
                      dbo.D_OrdenServicio ON dbo.T_SellosPresupuestales.IdSelloPresupuestal = dbo.D_OrdenServicio.IdSelloPresupuestal RIGHT OUTER JOIN
                      dbo.T_OrdenServicio ON dbo.D_OrdenServicio.IdOrden = dbo.T_OrdenServicio.IdOrden LEFT OUTER JOIN
                      dbo.C_Proveedores ON dbo.C_Proveedores.IdProveedor = dbo.T_OrdenServicio.IdProveedor LEFT OUTER JOIN
                      dbo.T_Solicitudes ON dbo.T_OrdenServicio.IdSolicitud = dbo.T_Solicitudes.IdSolicitud
WHERE     (dbo.T_OrdenServicio.IdOrden IN
                          (SELECT     IdOrden
                            FROM          dbo.D_OrdenServicio AS D_Pedidos_1
                            WHERE      (IdSelloPresupuestal IN
                                                       (SELECT     IdSelloPresupuestal
                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) AND (dbo.T_OrdenServicio.Estatus <> 'C')
