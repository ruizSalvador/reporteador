/****** Object:  StoredProcedure [dbo].[SP_RPT_RequisicionesDeServicios]    Script Date: 17/04/2017 14:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_RequisicionesDeServicios]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_RequisicionesDeServicios]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_RequisicionesDeServicios]    Script Date: 17/04/2017 14:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_RequisicionesDeServicios 2017,87
CREATE PROCEDURE [dbo].[SP_RPT_RequisicionesDeServicios] 

@Año int,
@Folio int

AS
BEGIN
Select CD.NombreDepartamento,   
(Select CE.Nombres + ' ' + CE.ApellidoPaterno + ' ' + CE.ApellidoMaterno) as Nombre,
(Select CE2.Nombres + ' ' + CE2.ApellidoPaterno + ' ' + CE2.ApellidoMaterno) as Capturo,
(Select CAST(CA.Clave as varchar(10)) + ' ' + CAST(CA.Nombre as varchar(200))) as Area,
(Select CAST(Periodo as varchar(4)) + '-' +  CAST(Folio as varchar(20))) as Folio, FechaSolicitud, 
CASE TS.Estatus
        WHEN 'S' THEN  'SOLICITADO'
        WHEN 'R' THEN  'RECIBIDO'
        WHEN 'P' THEN  'PEDIDO'
        WHEN 'C' THEN  'CANCELADO'
        WHEN 'L' THEN  'LICITADO'
        WHEN 'U' THEN  'SURTIDO'
        WHEN 'A' THEN  'AUTORIZADO'
        WHEN 'Z' THEN  'REVISADO'
        WHEN 'T' THEN  'CAPTURADO'
        WHEN 'I' THEN  'PARCIAL'
        ELSE 'OTROS' END as Estatus,
 CPP.ClavePartida as Partida, CTS.DescripcionTipoServicio as TipoServicio, CU.NombreUnidad as Unidad,      
CES.Nombre, DS.Cantidad, DS.CostoUnitario,
TSP.Sello, DS.Descripcion, CES.Responsable, Justificacion, TS.MontoEstimado

FROM T_Solicitudes TS
LEFT JOIN D_Solicitud DS ON TS.IdSolicitud = DS.IdSolicitud 
LEFT JOIN T_SellosPresupuestales TSP ON TSP.IdSelloPresupuestal = DS.IdSelloPresupuestal
LEFT JOIN C_EstatusSolicitudes CES ON TS.Estatus = CES.Estatus
LEFT JOIN C_Departamentos CD ON TS.IdDepartamento = CD.IdDepartamento
LEFT JOIN C_Empleados CE ON TS.NumeroEmpleado = CE.NumeroEmpleado
LEFT JOIN C_TipoServicios CTS ON CTS.IdTipoServicio = DS.IdTipoServicio
LEFT JOIN C_Unidades CU ON DS.ClaveUnidad = CU.IdUnidadMedida
LEFT JOIN C_PartidasPres CPP ON CPP.IdPartida = DS.IdPartida
LEFT JOIN C_AreaResponsabilidad CA ON CA.IdAreaResp = TS.IdAreaResp
LEFT JOIN C_Usuarios CUS ON CUS.IdUsuario = TS.IdUsuario 
LEFT JOIN C_Empleados CE2 ON CE2.NumeroEmpleado = CUS.NumeroEmpleado

Where Periodo = @Año and Folio = @Folio
order by Folio

END
GO

EXEC SP_FirmasReporte 'Reporte Requisiciones de Servicios'
GO

Exec SP_CFG_LogScripts 'SP_RPT_RequisicionesDeServicios'
GO