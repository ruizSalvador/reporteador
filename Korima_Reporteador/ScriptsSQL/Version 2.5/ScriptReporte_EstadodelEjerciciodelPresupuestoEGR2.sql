/****** Object:  StoredProcedure [dbo].[SP_RPT_EstadoEjercicioPresupuestoEGR]    Script Date: 11/26/2012 15:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_EstadoEjercicioPresupuestoEGR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_EstadoEjercicioPresupuestoEGR]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_EstadoEjercicioPresupuestoEGR]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_RPT_EstadoEjercicioPresupuestoEGR] 

@Mes  as int, 
@Mes2 as int,  
@Tipo as int,
@Ejercicio as int,
@ClaveFF as varchar(6)



AS
BEGIN


If @Tipo=1 
BEGIN
--VALORES ABSOLUTOS
--Consulta para Reporte General Estado del Ejercicio del Presupuesto 
Select TP.IdSelloPresupuestal , TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado,


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) +  (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio  


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS 
where  (Mes BETWEEN @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
END


Else if @Tipo=2 
BEGIN
--VALORES ABSOLUTOS
--Consulta para Reporte Ramo o Dependencia Estado del Ejercicio del Presupuesto
Select CR.CLAVE, CR.DESCRIPCION,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_RamoPresupuestal As CR
where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal
group by CR.CLAVE, CR.DESCRIPCION 
Order By CR.CLAVE
END

    
Else if @Tipo=3 
BEGIN
--VALORES ABSOLUTOS
--Consulta para Fuente Financiamiento Estado del Ejercicio del Presupuesto
	Select CF.CLAVE,CF.DESCRIPCION,
	
sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio  


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	group by CF.CLAVE,CF.DESCRIPCION
	Order By CF.CLAVE 
END

Else if @Tipo=4 
BEGIN
--VALORES ABSOLUTOS
--Consulta para Clasificación Económica Estado del Ejercicio del Presupuesto
Select CE.CLAVE,CE.NOMBRE as DESCRIPCION,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE
where (Mes BETWEEN  @Mes AND @Mes2)  AND LYear=@Ejercicio  AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto
group by CE.CLAVE, CE.NOMBRE
Order By CE.CLAVE 
END

Else if @Tipo=5 
BEGIN
--VALORES ABSOLUTOS
--Consulta para Clasificación Geográfica del Ejercicio del Presupuesto
Select  CC.Clave, CC.Descripcion,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ClasificadorGeograficoPresupuestal As CC
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CC.IdClasificadorGeografico = TS.IdClasificadorGeografico
group by CC.Clave,CC.Descripcion
Order By CC.Clave
END

Else if @Tipo=6
BEGIN 
--VALORES ABSOLUTOS
--Consulta para Capítulo del Gasto del Ejercicio del Presupuesto **
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo

Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo
END


Else if @Tipo=7 
BEGIN
--VALORES ABSOLUTOS 
--Consulta para Clasificación Funcional del Ejercicio del Presupuesto  **
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes BETWEEN  @Mes AND @Mes2)	 AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad 
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad 
END
 
Else if @Tipo=8  
BEGIN
--VALORES ABSOLUTOS
--Consulta para Clasificación Funcional y SubFunción del Ejercicio del Presupuesto **
Select CFS.IdFinalidad as IdClave, CFS.Nombre as Descripcion, CF.Clave as IdClave2,  CF.Nombre as Descripcion2, CF.IdFinalidad as IdComp2, cf.IdFuncion as IdComp2a, CS.Clave as IdClave3, CS.Nombre  as Descripcion3, cs.IdFuncion as IdComp3,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes BETWEEN  @Mes AND @Mes2)  AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CS.IdSubFuncion = TS.IdSubFuncion 
AND CF.IdFinalidad = CFS.IdFinalidad AND CF.IdFuncion = CS.IdFuncion 
group by CFS.IdFinalidad, CFS.Nombre, CF.Clave, CF.Nombre, CF.IdFinalidad , CS.Clave, CS.Nombre, cs.IdFuncion, cf.IdFuncion 
Order By CF.Clave, CS.Clave,CFS.IdFinalidad
END


Else if @Tipo=9 
BEGIN 
--VALORES ABSOLUTOS 
--Consulta para Clasificación Económica y Capítulo del Gasto del Ejercicio del Presupuesto **
Select  CE.Clave, CG.IdCapitulo, CG.Descripcion,   

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE, C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto  AND CP.IdPartida = TS.IdPartida 
AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo

Group by CG.IdCapitulo, CG.Descripcion, CE.Clave 
Order by CE.Clave, CG.IdCapitulo  
END

Else if @Tipo=10 
BEGIN
--VALORES ABSOLUTOS
--Consulta para Partida Genérica y Fuente del Gasto del Ejercicio del Presupuesto
If @ClaveFF <> '' 
begin
Select CPG.IdPartidaGenerica as ClavePartida , CPG.DescripcionPartida , CF.DESCRIPCION,
	
sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto 
	group by CPG.IdPartidaGenerica  , CPG.DescripcionPartida , CF.DESCRIPCION
	Order By  CPG.IdPartidaGenerica  , CPG.DescripcionPartida ,cf.DESCRIPCION
end
else if @ClaveFF = 0
begin
Select CPG.IdPartidaGenerica as ClavePartida , CPG.DescripcionPartida , CF.DESCRIPCION,
	
sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto 
	group by CPG.IdPartidaGenerica  , CPG.DescripcionPartida , CF.DESCRIPCION
	Order By  CPG.IdPartidaGenerica  , CPG.DescripcionPartida ,cf.DESCRIPCION
end	
END



--***********************************--VALORES RELATIVOS--*******************************--

If @Tipo=11 
BEGIN
--VALORES RELATIVOS
--Consulta para Reporte General Estado del Ejercicio del Presupuesto 
Select TP.IdSelloPresupuestal, TS.Sello, 


sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0))) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS 
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
END

Else if @Tipo=12
BEGIN
--VALORES RELATIVOS
--Consulta para Reporte Ramo o Dependencia Estado del Ejercicio del Presupuesto
Select CR.CLAVE, CR.DESCRIPCION,

 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_RamoPresupuestal As CR
where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal
group by CR.CLAVE, CR.DESCRIPCION 
Order By CR.CLAVE
END

Else if @Tipo=13
BEGIN
--VALORES RELATIVOS
--Consulta para Fuente Financiamiento Estado del Ejercicio del Presupuesto
	Select CF.CLAVE,CF.DESCRIPCION,
	

 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	group by CF.CLAVE,CF.DESCRIPCION
	Order By CF.CLAVE 
END	
	
Else if @Tipo=14 
BEGIN
--VALORES RELATIVOS
--Consulta para Clasificación Económica Estado del Ejercicio del Presupuesto
Select CE.CLAVE,CE.NOMBRE as DESCRIPCION,


 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto
group by CE.CLAVE, CE.NOMBRE
Order By CE.CLAVE 	
END

Else if @Tipo=15 
BEGIN
--VALORES RELATIVOS
--Consulta para Clasificación Geográfica del Ejercicio del Presupuesto
Select  CC.Clave, CC.Descripcion,


 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ClasificadorGeograficoPresupuestal As CC
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio  AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CC.IdClasificadorGeografico = TS.IdClasificadorGeografico
group by CC.Clave,CC.Descripcion
Order By CC.Clave
END

Else if @Tipo=16 
BEGIN
--VALORES RELATIVOS
--Consulta para Capítulo del Gasto del Ejercicio del Presupuesto **
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,


 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo

Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo
END
	
	
Else if @Tipo=17 
BEGIN
--VALORES RELATIVOS 
--Consulta para Clasificación Funcional del Ejercicio del Presupuesto  **
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 


 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad 
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad 
END

Else if @Tipo=18 
BEGIN
--VALORES RELATIVOS
--Consulta para Clasificación Funcional y SubFunción del Ejercicio del Presupuesto **
Select CFS.IdFinalidad as IdClave, CFS.Nombre as Descripcion, CF.Clave as IdClave2,  CF.Nombre as Descripcion2, CF.IdFinalidad as IdComp2, cf.IdFuncion as IdComp2a, CS.Clave as IdClave3, CS.Nombre  as Descripcion3, cs.IdFuncion as IdComp3,


 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CS.IdSubFuncion = TS.IdSubFuncion 
AND CF.IdFinalidad = CFS.IdFinalidad AND CF.IdFuncion = CS.IdFuncion 
group by CFS.IdFinalidad, CFS.Nombre, CF.Clave, CF.Nombre, CF.IdFinalidad , CS.Clave, CS.Nombre, cs.IdFuncion, cf.IdFuncion 
Order By CF.Clave, CS.Clave, CF.IdFinalidad
END

Else if @Tipo=19 
BEGIN
--VALORES RELATIVOS 
--Consulta para Clasificación Económica y Capitulo del Gasto del Ejercicio del Presupuesto **
Select  CE.Clave, CG.IdCapitulo, CG.Descripcion,   


 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE, C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto  AND CP.IdPartida = TS.IdPartida 
AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo

Group by CG.IdCapitulo, CG.Descripcion, CE.Clave 
Order by CE.Clave, CG.IdCapitulo  
END

Else if @Tipo=20
BEGIN
--VALORES RELATIVOS
--Consulta para Partida Genérica y Fuente del Gasto del Ejercicio del Presupuesto
if @ClaveFF <> ''
begin
Select CPG.IdPartidaGenerica as ClavePartida  , CPG.DescripcionPartida , CF.DESCRIPCION,
	

 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  cf.CLAVE = @ClaveFF and TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto 
	group by CPG.IdPartidaGenerica  , CPG.DescripcionPartida , CF.DESCRIPCION
	Order By CPG.IdPartidaGenerica  , CPG.DescripcionPartida
end
else if @ClaveFF = 0
begin
Select CPG.IdPartidaGenerica as ClavePartida  , CPG.DescripcionPartida , CF.DESCRIPCION,
	

 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto 
	group by CPG.IdPartidaGenerica  , CPG.DescripcionPartida , CF.DESCRIPCION
	Order By CPG.IdPartidaGenerica  , CPG.DescripcionPartida
end

END
 
END

GO




Exec SP_FirmasReporte 'Ejercicio del Presupuesto Clasificación General'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Ramo o Dependencia'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Fuente Financiamiento'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Clasificación Económica'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Clasificación Geográfica'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Capítulo del Gasto'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Clasificación Funcional'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Clasificación Funcional-Subfunción'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Clasificación Económica y Capítulo de Gasto'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Partida Genérica y Fuente de Financiamiento'
GO