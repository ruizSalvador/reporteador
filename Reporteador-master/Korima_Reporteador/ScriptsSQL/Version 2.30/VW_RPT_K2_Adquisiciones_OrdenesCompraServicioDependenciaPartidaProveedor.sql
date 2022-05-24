/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompraServicioDependenciaPartidaProveedor]    Script Date: 10/24/2012 09:40:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompraServicioDependenciaPartidaProveedor]'))
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompraServicioDependenciaPartidaProveedor]
GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompraServicioDependenciaPartidaProveedor]    Script Date: 10/24/2012 09:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompraServicioDependenciaPartidaProveedor]
AS
SELECT     dbo.T_Pedidos.IdSolicitud , dbo.T_SellosPresupuestales.IdPartida AS IdOrden, 'OC '+CAST(dbo.T_Pedidos.Folio as varchar) as Folio,dbo.T_Solicitudes.Folio as FolioRequisicion,   
                      CASE T_Pedidos.Estatus WHEN 'R' THEN 'Recibido' WHEN 'P' THEN 'Pedido' WHEN 'C' THEN 'Cancelado' END AS Estatus, dbo.T_Pedidos.IdProveedor,
					  dbo.T_Pedidos.IdTipoCompra,
                      dbo.C_Proveedores.RazonSocial, dbo.T_SellosPresupuestales.Sello AS IdPartida, dbo.T_Pedidos.Observaciones, 
                      dbo.D_Pedidos.DescripcionAdicional AS DescripcionServicio, dbo.C_AreaResponsabilidad.Clave, dbo.C_PartidasPres.ClavePartida, 
                      dbo.C_AreaResponsabilidad.Nombre, dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS maskUnidadResponsable, 
                      dbo.C_AreaResponsabilidad.Clave AS UnidadResponsable_Clave, dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_mask_ClaveNombre, 
                      dbo.C_PartidasPres.ClavePartida AS PartPres_Clave, dbo.C_PartidasPres.DescripcionPartida AS PartPres_Nombre, 
                      dbo.C_PartidasPres.ClavePartida + ' ' + dbo.C_PartidasPres.DescripcionPartida AS PartPres_mask_ClaveNombre, 
                      dbo.C_Proveedores.IdProveedor AS Proveedores_ID, dbo.C_Proveedores.RazonSocial AS Proveedores_RazonSocial,
                      CAST(dbo.C_Proveedores.IdProveedor AS VARCHAR) + ' ' + dbo.C_Proveedores.RazonSocial AS Proveedores_mask_IdRazonSocial, 
                      dbo.T_Pedidos.Folio AS PedidosDetalle_OrdenCompra, dbo.T_Pedidos.Fecha AS PedidosDetalle_Fecha,dbo.T_Solicitudes.FechaSolicitud AS RequisicionDetalle_Fecha, dbo.D_Pedidos.Cantidad AS PedidosDetalle_Cantidad,   
                      dbo.D_Pedidos.CostoUnitario AS PedidosDetalle_CostoUnitario, dbo.D_Pedidos.Importe AS PedidosDetalle_Importe, 
					   D_Pedidos.CantidadRecibida,
					  ( D_Pedidos.Cantidad- D_Pedidos.CantidadRecibida) as CantidadXRecibir,
					  C_Maestro.CodigoCambs,
					  C_Maestro.IdCodigoProducto as Consecutivo,
                      C_Maestro.UnidadMedida,
                      C_UnidadPresentacion.NombrePresentacion,
                      case D_Pedidos.DescripcionAdicional when '' then dbo.C_Maestro.DescripcionGenerica else D_Pedidos.DescripcionAdicional end AS PedidosDetalle_Descripcion,
                      case T_Pedidos.AplicaIva when 0 then 0 else ((D_Pedidos.PorcIva/100) *dbo.D_Pedidos.Importe)end  as IVA,
                      case T_Pedidos.AplicaIva  when 0 then dbo.D_Pedidos.Importe else((D_Pedidos.PorcIva/100) *dbo.D_Pedidos.Importe)+dbo.D_Pedidos.Importe end as Total
                      --D_Pedidos.DescripcionAdicional end AS PedidosDetalle_Descripcion
FROM         dbo.T_SellosPresupuestales INNER JOIN
                      dbo.D_Pedidos ON dbo.T_SellosPresupuestales.IdSelloPresupuestal = dbo.D_Pedidos.IdSelloPresupuestal INNER JOIN
                      dbo.C_Maestro ON dbo.D_Pedidos.IdCodigoProducto = dbo.C_Maestro.IdCodigoProducto AND dbo.D_Pedidos.IdGrupo = dbo.C_Maestro.IdGrupo AND 
                      dbo.D_Pedidos.IdSubGrupo = dbo.C_Maestro.IdSubGrupo INNER JOIN
                      dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp INNER JOIN
                      dbo.C_PartidasPres ON dbo.T_SellosPresupuestales.IdPartida = dbo.C_PartidasPres.IdPartida RIGHT OUTER JOIN
                      dbo.T_Pedidos ON dbo.D_Pedidos.IdPedido = dbo.T_Pedidos.IdPedido LEFT OUTER JOIN
                      dbo.C_Proveedores ON dbo.C_Proveedores.IdProveedor = dbo.T_Pedidos.IdProveedor LEFT OUTER JOIN
					  dbo.T_Solicitudes on dbo.T_Solicitudes.IdSolicitud= dbo.T_Pedidos.IdSolicitud 
					  LEFT JOIN dbo.C_UnidadPresentacion ON C_Maestro.IdPresentacion = C_UnidadPresentacion.IdUPresentacion  
WHERE     (dbo.T_Pedidos.IdPedido IN
                          (SELECT     IdPedido
                            FROM          dbo.D_Pedidos AS D_Pedidos_1
                            WHERE      (IdSelloPresupuestal IN
                                                       (SELECT     IdSelloPresupuestal
                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) 
					 --                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) AND (dbo.T_Pedidos.Estatus <> 'C')
-----
UNION ALL
SELECT     dbo.T_OrdenServicio.IdSolicitud , dbo.T_SellosPresupuestales.IdPartida AS IdOrden, 'OS '+CAST(dbo.T_OrdenServicio.Folio as varchar)as Folio , dbo.T_Solicitudes.Folio as FolioRequisicion, 
                      CASE T_OrdenServicio.Estatus WHEN 'R' THEN 'Recibido' WHEN 'P' THEN 'Pedido' WHEN 'C' THEN 'Cancelado' END AS Estatus, dbo.T_OrdenServicio.IdProveedor, 
					  dbo.T_OrdenServicio.IdTipoCompra,
                      dbo.C_Proveedores.RazonSocial, dbo.T_SellosPresupuestales.Sello AS IdPartida, dbo.T_OrdenServicio.Observaciones, 
                      dbo.D_OrdenServicio.DescripcionServicio AS DescripcionServicio, dbo.C_AreaResponsabilidad.Clave, dbo.C_PartidasPres.ClavePartida, 
                      dbo.C_AreaResponsabilidad.Nombre, dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS maskUnidadResponsable, 
                      dbo.C_AreaResponsabilidad.Clave AS UnidadResponsable_Clave, dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_mask_ClaveNombre, 
                      dbo.C_PartidasPres.ClavePartida AS PartPres_Clave, dbo.C_PartidasPres.DescripcionPartida AS PartPres_Nombre, 
                      dbo.C_PartidasPres.ClavePartida + ' ' + dbo.C_PartidasPres.DescripcionPartida AS PartPres_mask_ClaveNombre, 
                      dbo.C_Proveedores.IdProveedor AS Proveedores_ID, dbo.C_Proveedores.RazonSocial AS Proveedores_RazonSocial, 
                      CAST(dbo.C_Proveedores.IdProveedor AS VARCHAR) + ' ' + dbo.C_Proveedores.RazonSocial AS Proveedores_mask_IdRazonSocial, 
                      dbo.T_OrdenServicio.Folio AS PedidosDetalle_OrdenCompra,dbo.T_OrdenServicio.Fecha AS PedidosDetalle_Fecha,dbo.T_Solicitudes.FechaSolicitud AS RequisicionDetalle_Fecha, dbo.D_OrdenServicio.Cantidad AS PedidosDetalle_Cantidad,   
                      dbo.D_OrdenServicio.CostoUnitario AS PedidosDetalle_CostoUnitario, dbo.D_OrdenServicio.Importe AS PedidosDetalle_Importe,
					  dbo.D_OrdenServicio.Cantidad as CantidadRecibida,
					  0 as CantidadXRecibir,
					  null as CodigoCambs,
					  null as Consecutivo,
                      null as UnidadMedida,
                      null as NombrePresentacion 
                      ,D_OrdenServicio.DescripcionServicio as PedidosDetalle_Descripcion
                      ,case
						When T_OrdenServicio.AplicaIVA = 0 then 0 
						When T_OrdenServicio.AplicaIVA = 1 and IVA_PORC > 0 then ((T_OrdenServicio.IVA_PORC/100) *dbo.D_OrdenServicio.Importe)
						WHEN T_OrdenServicio.APlicaIVA = 1 and IVA_PORC = 0 then D_OrdenServicio.IVA
						end  as IVA,
                      --case T_OrdenServicio.AplicaIVA  when 0 then dbo.D_OrdenServicio.Importe else((T_OrdenServicio.IVA_PORC/100) *dbo.D_OrdenServicio.Importe)+dbo.D_OrdenServicio.Importe end as Total
			           case
						When T_OrdenServicio.AplicaIVA = 0 then D_OrdenServicio.Importe
						When T_OrdenServicio.AplicaIVA = 1 and IVA_PORC > 0 then (((T_OrdenServicio.IVA_PORC/100) *dbo.D_OrdenServicio.Importe)+D_OrdenServicio.Importe)
						WHEN T_OrdenServicio.APlicaIVA = 1 and IVA_PORC = 0 then (dbo.D_OrdenServicio.IVA+ D_OrdenServicio.Importe) 
					  END as Total                                           
			          
			          
			          --  T_OrdenServicio.TotalGral as Total
                      --dbo.C_Maestro.DescripcionGenerica AS PedidosDetalle_Descripcion
FROM         dbo.T_SellosPresupuestales INNER JOIN
                      dbo.D_OrdenServicio ON dbo.T_SellosPresupuestales.IdSelloPresupuestal = dbo.D_OrdenServicio.IdSelloPresupuestal 
                      --INNER JOIN
                      --dbo.C_Maestro ON dbo.D_OrdenServicio.IdCodigoProducto = dbo.C_Maestro.IdCodigoProducto AND dbo.D_OrdenServicio.IdGrupo = dbo.C_Maestro.IdGrupo AND 
                      --dbo.D_OrdenServicio.IdSubGrupo = dbo.C_Maestro.IdSubGrupo 
                      INNER JOIN
                      dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp INNER JOIN
                      dbo.C_PartidasPres ON dbo.T_SellosPresupuestales.IdPartida = dbo.C_PartidasPres.IdPartida RIGHT OUTER JOIN
                      dbo.T_OrdenServicio ON dbo.D_OrdenServicio.IdOrden = dbo.T_OrdenServicio.IdOrden LEFT OUTER JOIN
                      dbo.C_Proveedores ON dbo.C_Proveedores.IdProveedor = dbo.T_OrdenServicio.IdProveedor LEFT OUTER JOIN
					  dbo.T_Solicitudes on dbo.T_Solicitudes.IdSolicitud= dbo.T_OrdenServicio.IdSolicitud
WHERE     (dbo.T_OrdenServicio.IdOrden IN
                          (SELECT     Idorden
                            FROM          dbo.D_OrdenServicio AS D_Pedidos_1
                            WHERE      (IdSelloPresupuestal IN
                                                       (SELECT     IdSelloPresupuestal
                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) 
		 --                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) AND (dbo.T_OrdenServicio.Estatus <> 'C')

GO


