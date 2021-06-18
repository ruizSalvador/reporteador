/****** Object:  StoredProcedure [dbo].[SP_RPT_Transferencias_Asignaciones_Ayudas]    Script Date: 03/03/2017 10:26:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Transferencias_Asignaciones_Ayudas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Transferencias_Asignaciones_Ayudas]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_Transferencias_Asignaciones_Ayudas]    Script Date: 03/03/2017 10:26:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_Transferencias_Asignaciones_Ayudas 1,12,2020
Create Procedure [dbo].[SP_RPT_Transferencias_Asignaciones_Ayudas]
@MesInicio as int, 
@MesFin as int,
@Ejercicio int

AS

Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2, 
 CP.IdPartida, CP.DescripcionPartida,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes BETWEEN  @MesInicio AND @MesFin) AND LYear=@Ejercicio AND Year=@Ejercicio 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
AND CG.IdCapitulo like '4%'
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo, CP.IdPartida, CP.DescripcionPartida
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo

GO


Exec SP_CFG_LogScripts 'SP_RPT_Transferencias_Asignaciones_Ayudas','2.30'
GO