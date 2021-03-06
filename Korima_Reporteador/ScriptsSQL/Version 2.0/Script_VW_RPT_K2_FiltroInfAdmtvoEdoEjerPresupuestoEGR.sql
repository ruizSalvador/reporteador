/****** Object:  View [dbo].[VW_RPT_K2_FiltroInfAdmtvoEdoEjerPresupuestoEGR]    Script Date: 11/26/2012 16:14:58 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_FiltroInfAdmtvoEdoEjerPresupuestoEGR]'))
DROP VIEW [dbo].[VW_RPT_K2_FiltroInfAdmtvoEdoEjerPresupuestoEGR]
GO
/****** Object:  View [dbo].[VW_RPT_K2_FiltroInfAdmtvoEdoEjerPresupuestoEGR]    Script Date: 11/26/2012 16:14:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[VW_RPT_K2_FiltroInfAdmtvoEdoEjerPresupuestoEGR] as


SELECT tablaID.Id, tablaID.Ejercicio, tablaEje.Clave as Eje, tablaProg.Clave as Prog,  tablaAccion.Clave as Accion,
tablaAI.Clave as AI, tablaID.Clave as Proy, tablaAI.nombre as NombreAI, tablaID.nombre as Proyecto
FROM
(select * from C_EP_Ramo where Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id
inner join
(select * from C_EP_Ramo where Nivel = 3) tablaAccion
ON tablaAI.IdPadre = tablaAccion.Id
inner join
(select * from C_EP_Ramo where Nivel = 2) tablaProg
ON tablaAccion.IdPadre = tablaProg.Id
inner join
(select * from C_EP_Ramo where Nivel = 1) tablaEje
ON tablaProg.IdPadre = tablaEje.Id


GO


