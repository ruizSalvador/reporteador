/****** Object:  StoredProcedure [dbo].[SP_RPT_InformeAdmtvoEstadoEjercicioPresupuestoEGR]    Script Date: 16/Jul/2014 12:10 ******/
/****** Ing. Alvirde. Modificacion para aceptar unidad responsable y programa sin especificar. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_InformeAdmtvoEstadoEjercicioPresupuestoEGR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_InformeAdmtvoEstadoEjercicioPresupuestoEGR]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
--Exec SP_RPT_InformeAdmtvoEstadoEjercicioPresupuestoEGR 1,12,9,2017,'','',0,0,''
Create PROCEDURE [dbo].[SP_RPT_InformeAdmtvoEstadoEjercicioPresupuestoEGR] 

@Mes  as int,     
@Mes2  as int,  
@Tipo as int,  
@Ejercicio as int,  
@Clave as varchar(15),  
@ClaveUR as varchar(15),  
@ClaveURHasta as varchar(15), 
@IdEP as int,  
@IdPartida as int,  
@IdPartidaHasta as int, 
@ClaveFF varchar(10) 


AS
BEGIN

If @Tipo = 1 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO--Unidad Responsable
--Valores Absolutos
Select CR.CLAVE as CveRamo , CR.DESCRIPCION as DescripcionRamo, CA.Clave as Clave , CA.Nombre  as Descripcion,
 
sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
   
   
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda
	

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal CR
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND  Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
group by CR.CLAVE, CR.DESCRIPCION ,CA.Clave  , CA.Nombre
Order By CR.CLAVE
END



Else if @Tipo=2
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO--Ramo - Clasificador Econ�mico
--Valores Absolutos
Select CE.Clave as Clave,CE.NOMBRE as Descripcion,

sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
   
   
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0)) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0))- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda


From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_TipoGasto CE
on CE.IDTIPOGASTO = TS.IdTipoGasto 
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
group by CE.Clave,CE.NOMBRE 
Order By CE.Clave

END



Else if @Tipo=3 
BEGIN 
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO--Clasificaci�n Econ�mica - Cap�tulo del Gasto
--Valores Absolutos
Select  CE.Clave, CG.IdCapitulo, CG.Descripcion, 
  
sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
   
   
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda


From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_TipoGasto CE
on CE.IDTIPOGASTO = TS.IdTipoGasto 
inner join  C_PartidasPres  CP
on CP.IdPartida = TS.IdPartida 
left join  C_ConceptosNEP CN
on  CN.IdConcepto = CP.IdConcepto
left join C_CapitulosNEP CG
on CG.IdCapitulo = CN.IdCapitulo

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
Group by CG.IdCapitulo, CG.Descripcion, CE.Clave 
Order by CE.Clave, CG.IdCapitulo  
END



Else if @Tipo=4 
BEGIN 
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Cap�tulo del Gasto
--Valores Absolutos
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2, 
   CP.IdPartida, CP.DescripcionPartida as Descripcion3,
sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
   
   
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda


From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_PartidasPres CP
on CP.IdPartida = TS.IdPartida
left join C_ConceptosNEP CN
on CN.IdConcepto = CP.IdConcepto
left join C_CapitulosNEP CG
on CG.IdCapitulo = CN.IdCapitulo

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo, CP.IdPartida, CP.DescripcionPartida
Order by  CG.IdCapitulo 
END



Else if @Tipo=5  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Clasificaci�n Funcional - Subfunci�n
--Valores Absolutos
Select CFS.IdFinalidad as IdClave, CFS.Nombre as Descripcion, CF.Clave as IdClave2,  CF.Nombre as Descripcion2, CF.IdFinalidad as IdComp2, cf.IdFuncion as IdComp2a, CS.Clave as IdClave3, CS.Nombre  as Descripcion3, cs.IdFuncion as IdComp3,

sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
   
   
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda


From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_Subfunciones CS
on CS.IdSubFuncion = TS.IdSubFuncion 
inner join  C_funciones  CF
on  CF.IdFuncion = CS.IdFuncion  
left join  C_Finalidades  CFS
on CF.IdFinalidad = CFS.IdFinalidad 

where   (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
group by CFS.IdFinalidad, CFS.Nombre, CF.Clave, CF.Nombre, CF.IdFinalidad , CS.Clave, CS.Nombre, cs.IdFuncion, cf.IdFuncion 
Order By CF.Clave, CS.Clave
END



Else if @Tipo=6  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Cap�tulo del Gasto -Unidad Responsable
--Valores Absolutos
Select CA.Clave  as ClaveUR , CA.Nombre ,
CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  
	CP.IdPartida, CP.DescripcionPartida as Descripcion3,
sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
   
   
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda
	
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_AreaResponsabilidad  CA 
on  TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal  
inner join C_PartidasPres  CP
on  CP.IdPartida = TS.IdPartida 
left join C_ConceptosNEP  CN
on  CN.IdConcepto = CP.IdConcepto
left join  C_CapitulosNEP  CG
on CG.IdCapitulo = CN.IdCapitulo

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE =CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END 
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,CA.Clave  , CA.Nombre, CP.IdPartida, CP.DescripcionPartida
Order by  CA.Clave  ,CG.IdCapitulo 
END



Else if @Tipo=7  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa
--Valores Absolutos
	IF @ClaveUR ='' AND @ClaveURHasta='' AND @IdPartida =''AND @IdPartidaHasta ='' BEGIN
	SELECT    CEPR.Clave, CEPR.Nombre as Descripcion, 
	sum(isnull(TP.Autorizado,0)) as Autorizado,  
	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,  
	SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
	sum(isnull(TP.Comprometido,0)) as Comprometido, 
	SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
	sum(isnull(TP.Devengado,0)) as Devengado, 
	sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
	sum(isnull(TP.Ejercido,0)) as Ejercido,
	sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
	sum(isnull(TP.Pagado,0)) as Pagado, 
	sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
	sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda                  
	From T_PresupuestoNW  TP
	inner join T_SellosPresupuestales TS 
	on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
	inner join C_RamoPresupuestal  CR 
	on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
	inner join   C_EP_Ramo  CEPR 
	on CEPR.Id = TS.IdProyecto 
	inner join  C_PartidasPres  CP
	on TS.IdPartida = CP.IdPartida
	left join  C_ConceptosNEP  CCN 
	on CCN.IdConcepto = CP.IdConcepto   
	Where   (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end  
	AND CEPR.Nivel = '5' 
	GROUP BY CEPR.Clave, CEPR.Nombre
	ORDER BY CEPR.Clave
	END
	Else if @ClaveUR ='' AND @ClaveURHasta='' AND @IdPartida <>''AND @IdPartidaHasta <>''  
	BEGIN
	SELECT    CEPR.Clave, CEPR.Nombre as Descripcion, 
	sum(isnull(TP.Autorizado,0)) as Autorizado,  
	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,  
	SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
	sum(isnull(TP.Comprometido,0)) as Comprometido, 
	SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
	sum(isnull(TP.Devengado,0)) as Devengado, 
	sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
	sum(isnull(TP.Ejercido,0)) as Ejercido,
	sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
	sum(isnull(TP.Pagado,0)) as Pagado, 
	sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
	sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda                  
	From T_PresupuestoNW  TP
	inner join T_SellosPresupuestales TS 
	on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
	inner join C_RamoPresupuestal  CR 
	on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
	inner join   C_EP_Ramo  CEPR 
	on CEPR.Id = TS.IdProyecto 
	inner join  C_PartidasPres  CP
	on TS.IdPartida = CP.IdPartida
	left join  C_ConceptosNEP  CCN 
	on CCN.IdConcepto = CP.IdConcepto   
	Where   (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end  
	AND CEPR.Nivel = '5' 
	And CP.IdPartida BETWEEN  @IdPartida AND @IdPartidaHasta
	GROUP BY CEPR.Clave, CEPR.Nombre
	ORDER BY CEPR.Clave
	END
	Else if @ClaveUR <>'' AND @ClaveURHasta<>'' AND @IdPartida =''AND @IdPartidaHasta ='' 
	BEGIN
	SELECT    CEPR.Clave, CEPR.Nombre as Descripcion, 
	sum(isnull(TP.Autorizado,0)) as Autorizado,  
	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,  
	SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
	sum(isnull(TP.Comprometido,0)) as Comprometido, 
	SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
	sum(isnull(TP.Devengado,0)) as Devengado, 
	sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
	sum(isnull(TP.Ejercido,0)) as Ejercido,
	sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
	sum(isnull(TP.Pagado,0)) as Pagado, 
	sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
	sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda                  
	From T_PresupuestoNW  TP
	inner join T_SellosPresupuestales TS 
	on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
	inner join C_RamoPresupuestal  CR 
	on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
	inner join   C_EP_Ramo  CEPR 
	on CEPR.Id = TS.IdProyecto 
	inner join  C_PartidasPres  CP
	on TS.IdPartida = CP.IdPartida
	left join  C_ConceptosNEP  CCN 
	on CCN.IdConcepto = CP.IdConcepto   
	inner join  C_AreaResponsabilidad  CA
	on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal
	Where   (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end  
	AND CEPR.Nivel = '5' 
	AND CA.Clave BETWEEN  @ClaveUR AND @ClaveURHasta  
	GROUP BY CEPR.Clave, CEPR.Nombre
	ORDER BY CEPR.Clave
	END
	ELSE if @ClaveUR <>'' AND @ClaveURHasta<>'' AND @IdPartida <>''AND @IdPartidaHasta <>''
	BEGIN
	SELECT    CEPR.Clave, CEPR.Nombre as Descripcion, 
	sum(isnull(TP.Autorizado,0)) as Autorizado,  
	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,  
	SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
	sum(isnull(TP.Comprometido,0)) as Comprometido, 
	SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
	sum(isnull(TP.Devengado,0)) as Devengado, 
	sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
	sum(isnull(TP.Ejercido,0)) as Ejercido,
	sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
	sum(isnull(TP.Pagado,0)) as Pagado, 
	sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
	sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda                  
	From T_PresupuestoNW  TP
	inner join T_SellosPresupuestales TS 
	on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
	inner join C_RamoPresupuestal  CR 
	on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
	inner join   C_EP_Ramo  CEPR 
	on CEPR.Id = TS.IdProyecto 
	inner join  C_PartidasPres  CP
	on TS.IdPartida = CP.IdPartida
	left join  C_ConceptosNEP  CCN 
	on CCN.IdConcepto = CP.IdConcepto   
	inner join  C_AreaResponsabilidad  CA
	on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal
	Where   (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end  
	AND CEPR.Nivel = '5' 
	AND CA.Clave BETWEEN  @ClaveUR AND @ClaveURHasta  
	And CP.IdPartida BETWEEN  @IdPartida AND @IdPartidaHasta
	GROUP BY CEPR.Clave, CEPR.Nombre
	ORDER BY CEPR.Clave
	END
	END

Else if @Tipo=8  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Unidad Responsable
--Valores Absolutos
SELECT   CA.Clave, CA.Nombre , CEPR.Clave as Clave2, CEPR.Nombre as Descripcion ,

sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
   
   
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda
	
	
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join   C_EP_Ramo  CEPR 
on CEPR.Id = TS.IdProyecto 
inner join  C_AreaResponsabilidad  CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal
inner join  C_PartidasPres  CP
on TS.IdPartida = CP.IdPartida
left join  C_ConceptosNEP  CCN 
on CCN.IdConcepto = CP.IdConcepto
left join C_FuenteFinanciamiento CFF
on CFF.IDFUENTEFINANCIAMIENTO =  TS.IdFuenteFinanciamiento    

Where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio 
AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   AND CEPR.Nivel = '5'
AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END  
GROUP BY CEPR.Clave, CEPR.Nombre, CA.Clave , CA.Nombre
ORDER BY CEPR.Clave, CA.Clave 
END



Else if @Tipo=9  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Clasificaci�n Geogr�fica
--Valores Absolutos
Select  CC.Clave, CC.Descripcion,

sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
   
   
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda


From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_ClasificadorGeograficoPresupuestal CC
on CC.IdClasificadorGeografico = TS.IdClasificadorGeografico
inner join  C_PartidasPres  CP
on TS.IdPartida = CP.IdPartida
inner join  C_AreaResponsabilidad  CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal
left join C_FuenteFinanciamiento CFF
on CFF.IDFUENTEFINANCIAMIENTO =  TS.IdFuenteFinanciamiento

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio 
AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END 
AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END  

group by CC.Clave,CC.Descripcion
Order By CC.Clave
END



Else if @Tipo=10 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Clasificaci�n Geogr�fica - Econ�mica
--Valores Absolutos
Select CE.CLAVE as IdClave, CE.NOMBRE as Descripcion ,CC.Clave as Clave, CC.Descripcion as Descripcion2, 

sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
   
   
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda


From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
left join  C_ClasificadorGeograficoPresupuestal CC
on CC.IdClasificadorGeografico = TS.IdClasificadorGeografico
left join  C_TipoGasto CE
on CE.IDTIPOGASTO = TS.IdTipoGasto

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
group by CC.Clave,CC.Descripcion,CE.CLAVE, CE.NOMBRE
Order By CC.Clave
END



Else if @Tipo=11
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Gen�rica 
--Valores Absolutos
Select  CA.Clave as ClaveUR , CA.Nombre , CPG.IdPartidaGenerica as Clave , CPG.DescripcionPartida  as Descripcion, 

sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
   
   
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and  CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 
inner join C_PartidasPres  CP
on CP.IdPartida  = TS.IdPartida
left join C_PartidasGenericasPres  CPG
on CP.IdPartidaGenerica = CPG.IdPartidaGenerica 
left join  C_ConceptosNEP CN
on CN.IdConcepto = CPG.IdConcepto

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end and CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
group by CPG.IdPartidaGenerica , CPG.DescripcionPartida , CA.Clave  , CA.Nombre 
Order By CA.Clave ,CPG.IdPartidaGenerica , CPG.DescripcionPartida
END



Else if @Tipo=12
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Especifica 
--Valores Absolutos
Select  CA.Clave as ClaveUR , CA.Nombre , CP.ClavePartida as Clave , CP.DescripcionPartida as Descripcion , 


sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
   
   
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda


From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 
left join C_PartidasPres  CP 
on TS.IdPartida  = CP.IdPartida 

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end and CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
group by CP.ClavePartida, CP.DescripcionPartida , CA.Clave  , CA.Nombre 
Order By CA.Clave ,CP.ClavePartida

END


--Else if @Tipo=13  
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Cap�tulo del Gasto
--Valores Absolutos
--Select CA.Clave as ClaveUR , CA.Nombre ,CEPR.Clave , CEPR.Nombre as Proyecto,
--CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  

    
    --sum(TP.Autorizado) as Autorizado,  SUM(TP.TransferenciaAmp) AS Ampliaciones, SUM(TP.TransferenciaRed) as Reducciones, sum(TP.Modificado) as Modificado,
	--sum(TP.Comprometido) as Comprometido, 
	--sum(TP.Comprometido) - sum(TP.Modificado) As PresDispComp,
	--sum(TP.Devengado) as Devengado, 
	--sum(TP.Comprometido ) - sum(TP.Devengado ) As CompSinDev,
	--sum(TP.Modificado)- sum(TP.Devengado)  AS PresSinDev,
	--sum(TP.Ejercido) as Ejercido,
	--sum(TP.Devengado )- sum(TP.Ejercido )  AS DevSinEjer,
	--sum(TP.Pagado) as Pagado, 
	--sum(TP.Ejercido)- sum(TP.Pagado)  AS EjerSinPagar,
	--sum(TP.Devengado) -  sum(TP.Pagado ) AS Deuda
	
--From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG,  C_RamoPresupuestal As CR, C_AreaResponsabilidad as CA,  C_EP_Ramo As CEPR  
--where Mes=@Mes AND Year=@Ejercicio and CR.CLAVE = @Clave  AND CA.Clave = @ClaveUR  AND CEPR.Id =@IdEP  and TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida 
--AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
--AND  TS.IdAreaResp = CA.IdAreaResp AND CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal AND TS.IdRamoPresupuestal = CA.IdRamoPresupuestal  AND CEPR.Id = TS.IdProyecto

--Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,CA.Clave  , CA.Nombre,CEPR.Clave, CEPR.Nombre
--Order by  CEPR.Clave, CA.Clave  ,CG.IdCapitulo 



Else if @Tipo=13 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Cap�tulo del Gasto -Actividad Institucinal -UR
--Valores Absolutos

DECLARE @nombreAI varchar(255)
DECLARE @claveAI varchar(255)
/*
SET @nombreAI = (SELECT TOP 1 tablaID.nombre 
FROM
(select * from C_EP_Ramo where id = CASE WHEN @IdEP = '' THEN ID ELSE @IdEP END and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @claveAI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id=  CASE WHEN @IdEP = '' THEN ID ELSE @IdEP END and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id
*/
Select T1.ClaveUR, T1.Nombre, min(T1.ClaveProy)ClaveProy, Min(T1.Proyecto)Proyecto, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2, sum(T1.Autorizado)Autorizado, sum(T1.Ampliaciones)Ampliaciones, 
sum(T1.Reducciones)Reducciones, sum(T1.Modificado)Modificado, sum(T1.PreComprometido)PreComprometido, sum(T1.PresVigSinPreComp)PresVigSinPreComp, sum(T1.Comprometido)Comprometido, sum(T1.PreCompSinComp)PreCompSinComp, 
sum(T1.PresDispComp)PresDispComp, sum(T1.Devengado)Devengado, sum(T1.CompSinDev)CompSinDev, sum(T1.PresSinDev)PresSinDev, Sum(T1.Ejercido)Ejercido, sum(T1.DevSinEjer)DevSinEjer,sum(T1.Pagado)Pagado, sum(T1.EjerSinPAgar)EjerSinPAgar, sum(T1.Deuda)Deuda, 
/*(SELECT tablaID.nombre FROM
(select * from C_EP_Ramo where id = T1.Id and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id)*/''As NombreAI, 
/*(SELECT tablaID.Clave  
FROM
(select * from C_EP_Ramo where id=   T1.Id  and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id)*/ 1 As ClaveAI 
from (
Select top 100 PErcent CEPR.ID, CA.Clave as ClaveUR , CA.Nombre ,CEPR.Clave as ClaveProy , CEPR.Nombre as Proyecto,  
CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  
    
sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal AND TS.IdRamoPresupuestal = CA.IdRamoPresupuestal 
inner join  C_EP_Ramo  CEPR 
on TS.IdProyecto = CEPR.Id 
left join C_PartidasPres  CP 
on TS.IdPartida  = CP.IdPartida 
left join C_ConceptosNEP  CN
on  CN.IdConcepto = CP.IdConcepto
left join C_CapitulosNEP  CG 
on CG.IdCapitulo = CN.IdCapitulo
left join C_FuenteFinanciamiento CFF
on CFF.IDFUENTEFINANCIAMIENTO =  TS.IdFuenteFinanciamiento 

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio 
AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
AND CEPR.Id = CASE WHEN @IdEP = '' THEN CEPR.ID ELSE @IdEP END  AND CEPR.Nivel = '5'
AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END  

Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,CA.Clave , CA.Nombre,CEPR.Clave, CEPR.Nombre, CEPR.Id
Order by  CEPR.Clave, CA.Clave ,CG.IdCapitulo) as T1
group by  T1.ClaveUR, T1.Nombre, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2

END

Else if @Tipo=29
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Especifica 
--Valores Absolutos

--CA.Clave as ClaveUR , CA.Nombre ,
Select  CP.ClavePartida as Clave , CP.DescripcionPartida as Descripcion , 

sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
     
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 
left join C_PartidasPres  CP 
on TS.IdPartida  = CP.IdPartida
left join C_FuenteFinanciamiento CFF
on CFF.IDFUENTEFINANCIAMIENTO =  TS.IdFuenteFinanciamiento 

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio 
AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
and CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END 
AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END  
group by CP.ClavePartida, CP.DescripcionPartida--, CA.Clave , CA.Nombre 
Order By CP.ClavePartida 

END

Else if @Tipo=31
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Gen�rica 
--Valores Absolutos

--CA.Clave as ClaveUR , CA.Nombre , 
Select  CPG.IdPartidaGenerica as Clave , CPG.DescripcionPartida  as Descripcion, 

sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
   
   
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and  CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 
inner join C_PartidasPres  CP
on CP.IdPartida  = TS.IdPartida
left join C_PartidasGenericasPres  CPG
on CP.IdPartidaGenerica = CPG.IdPartidaGenerica 
left join  C_ConceptosNEP CN
on CN.IdConcepto = CPG.IdConcepto
left join C_FuenteFinanciamiento CFF
on CFF.IDFUENTEFINANCIAMIENTO =  TS.IdFuenteFinanciamiento

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio 
AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
AND CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END 
AND CPG.ClavePartida = CASE WHEN @IdPartida = 0 THEN CPG.ClavePartida else @IdPartida end   
AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END   
group by CPG.IdPartidaGenerica , CPG.DescripcionPartida --, CA.Clave  , CA.Nombre 
Order By CPG.IdPartidaGenerica , CPG.DescripcionPartida
END

-- ******************************** VALORES RELATIVOS ************************** --

Else if @Tipo=14
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO--Unidad Responsable
--Valores Relativos
Select   CR.CLAVE as CveRamo , CR.DESCRIPCION as DescripcionRamo , CA.Clave as Clave , CA.Nombre  as Descripcion,

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  


From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal CR
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
group by CR.CLAVE, CR.DESCRIPCION ,CA.Clave  , CA.Nombre
Order By CR.CLAVE

END



Else if @Tipo=15
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO--Ramo - Clasificador Econ�mico
--Valores Relativos
Select CE.Clave,CE.NOMBRE as DESCRIPCION,

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  
	
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_TipoGasto CE
on CE.IDTIPOGASTO = TS.IdTipoGasto 
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
group by CE.Clave,CE.NOMBRE 
Order By CE.Clave
END



Else if @Tipo=16
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO--Clasificaci�n Econ�mica - Cap�tulo del Gasto
--Valores Relativos
Select  CE.Clave, CG.IdCapitulo, CG.Descripcion, 
  
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_TipoGasto CE
on CE.IDTIPOGASTO = TS.IdTipoGasto 
inner join  C_PartidasPres  CP
on CP.IdPartida = TS.IdPartida 
left join  C_ConceptosNEP CN
on  CN.IdConcepto = CP.IdConcepto
left join C_CapitulosNEP CG
on CG.IdCapitulo = CN.IdCapitulo

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
Group by CG.IdCapitulo, CG.Descripcion, CE.Clave 
Order by CE.Clave, CG.IdCapitulo 
END



Else if @Tipo=17 
BEGIN 
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Cap�tulo del Gasto
--Valores Relativos
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  
    CP.IdPartida, CP.DescripcionPartida as Descripcion3,
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  
	
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_PartidasPres CP
on CP.IdPartida = TS.IdPartida
left join C_ConceptosNEP CN
on CN.IdConcepto = CP.IdConcepto
left join C_CapitulosNEP CG
on CG.IdCapitulo = CN.IdCapitulo

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo, CP.IdPartida, CP.DescripcionPartida
Order by  CG.IdCapitulo 
END



Else if @Tipo=18  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Clasificaci�n Funcional - Subfunci�n
--Valores Relativos
Select CFS.IdFinalidad as IdClave, CFS.Nombre as Descripcion, CF.Clave as IdClave2,  CF.Nombre as Descripcion2, CF.IdFinalidad as IdComp2, cf.IdFuncion as IdComp2a, CS.Clave as IdClave3, CS.Nombre  as Descripcion3, cs.IdFuncion as IdComp3,

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_Subfunciones CS
on CS.IdSubFuncion = TS.IdSubFuncion 
inner join  C_funciones  CF
on  CF.IdFuncion = CS.IdFuncion  
left join  C_Finalidades  CFS
on CF.IdFinalidad = CFS.IdFinalidad 

where   (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
group by CFS.IdFinalidad, CFS.Nombre, CF.Clave, CF.Nombre, CF.IdFinalidad , CS.Clave, CS.Nombre, cs.IdFuncion, cf.IdFuncion 
Order By CF.Clave, CS.Clave
END



Else if @Tipo=19 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Cap�tulo del Gasto -Unidad Responsable
--Valores Relativos
Select CA.Clave  as ClaveUR , CA.Nombre ,
CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  
	CP.IdPartida, CP.DescripcionPartida as Descripcion3,
    
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  
	
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_AreaResponsabilidad  CA 
on  TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal  
inner join C_PartidasPres  CP
on  CP.IdPartida = TS.IdPartida 
left join C_ConceptosNEP  CN
on  CN.IdConcepto = CP.IdConcepto
left join  C_CapitulosNEP  CG
on CG.IdCapitulo = CN.IdCapitulo

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE =CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END    
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,CA.Clave, CA.Nombre, CP.IdPartida, CP.DescripcionPartida
Order by  CA.Clave  ,CG.IdCapitulo 
END



Else if @Tipo=20
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa
--Valores Relativos
SELECT    CEPR.Clave, CEPR.Nombre as Descripcion, 

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  
                      
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join   C_EP_Ramo  CEPR 
on CEPR.Id = TS.IdProyecto 
inner join  C_PartidasPres  CP
on TS.IdPartida = CP.IdPartida
left join  C_ConceptosNEP  CCN 
on CCN.IdConcepto = CP.IdConcepto   

Where   (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio  AND Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end  AND CEPR.Nivel = '5' 
GROUP BY CEPR.Clave, CEPR.Nombre
ORDER BY CEPR.Clave
END



Else if @Tipo=21  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Unidad Responsable
--Valores Relativos
SELECT   CA.Clave as Clave, CA.Nombre , CEPR.Clave as Clave2, CEPR.Nombre as Descripcion,

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  
                      
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join   C_EP_Ramo  CEPR 
on CEPR.Id = TS.IdProyecto 
inner join  C_AreaResponsabilidad  CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal
inner join  C_PartidasPres  CP
on TS.IdPartida = CP.IdPartida
left join  C_ConceptosNEP  CCN 
on CCN.IdConcepto = CP.IdConcepto
left join C_FuenteFinanciamiento CFF
on CFF.IDFUENTEFINANCIAMIENTO =  TS.IdFuenteFinanciamiento    

Where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio  AND Year=@Ejercicio 
AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   AND CEPR.Nivel = '5' 
AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END    
GROUP BY CEPR.Clave, CEPR.Nombre, CA.Clave , CA.Nombre
ORDER BY CEPR.Clave, CA.Clave 
END



Else if @Tipo=22  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Clasificaci�n Geogr�fica
--Valores Relativos
Select  CC.Clave, CC.Descripcion,

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
left join  C_ClasificadorGeograficoPresupuestal CC
on CC.IdClasificadorGeografico = TS.IdClasificadorGeografico
inner join  C_PartidasPres  CP
on TS.IdPartida = CP.IdPartida
inner join  C_AreaResponsabilidad  CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal
left join C_FuenteFinanciamiento CFF
on CFF.IDFUENTEFINANCIAMIENTO =  TS.IdFuenteFinanciamiento

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio  and Year=@Ejercicio 
AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END 
AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END
 
group by CC.Clave,CC.Descripcion
Order By CC.Clave
END



Else if @Tipo=23 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Clasificaci�n Geogr�fica - Econ�mica
--Valores Relativos
Select  CE.CLAVE as IdClave, CE.NOMBRE as Descripcion ,CC.Clave, CC.Descripcion as Descripcion2, 

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
left join  C_ClasificadorGeograficoPresupuestal CC
on CC.IdClasificadorGeografico = TS.IdClasificadorGeografico
left join  C_TipoGasto CE
on CE.IDTIPOGASTO = TS.IdTipoGasto

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
group by CC.Clave,CC.Descripcion,CE.CLAVE, CE.NOMBRE
Order By CC.Clave
END



Else if @Tipo=24 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Gen�rica 
--Valores Relativos
Select  CA.Clave as ClaveUR  , CA.Nombre , CPG.IdPartidaGenerica  as Clave , CPG.DescripcionPartida as Descripcion , 

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and  CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 
inner join C_PartidasPres  CP
on CP.IdPartida  = TS.IdPartida
left join C_PartidasGenericasPres  CPG
on CP.IdPartidaGenerica = CPG.IdPartidaGenerica 
left join  C_ConceptosNEP CN
on CN.IdConcepto = CPG.IdConcepto

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end and CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
group by CPG.IdPartidaGenerica , CPG.DescripcionPartida , CA.Clave  , CA.Nombre 
Order By CA.Clave ,CPG.IdPartidaGenerica , CPG.DescripcionPartida
END



Else if @Tipo=25
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Especifica 
--Valores Relativos
Select  CA.Clave as ClaveUR , CA.Nombre , CP.ClavePartida as Clave , CP.DescripcionPartida as Descripcion , 

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 
left join C_PartidasPres  CP 
on TS.IdPartida  = CP.IdPartida 

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end and CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
group by CP.ClavePartida, CP.DescripcionPartida , CA.Clave  , CA.Nombre 
Order By CA.Clave ,CP.ClavePartida
END


--Else if @Tipo=23  
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Cap�tulo del Gasto -UR
--Valores Relativos
--Select CA.Clave  , CA.Nombre ,CEPR.Clave, CEPR.Nombre,
--CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  

    
   -- sum(TP.Autorizado) as Autorizado,  sum(TP.TransferenciaAmp ) AS Ampliaciones, SUM(TP.TransferenciaRed ) as Reducciones, sum(TP.Modificado) as Modificado,
	--sum(TP.Comprometido)- sum(TP.Devengado ) as Comprometido, 
	--sum(TP.Comprometido) - sum(TP.Modificado) As PresDispComp,
	--sum(TP.Devengado) - sum(TP.Ejercido ) as Devengado, 
	--sum(TP.Comprometido ) - sum(TP.Devengado ) As CompSinDev,
	--sum(TP.Modificado)- sum(TP.Devengado)  AS PresSinDev,
	--sum(TP.Ejercido) - sum (TP.Pagado ) as Ejercido,
	--sum(TP.Devengado )- sum(TP.Ejercido )  AS DevSinEjer,
	--sum(TP.Pagado) as Pagado, 
	--sum(TP.Ejercido)- sum(TP.Pagado)  AS EjerSinPagar,
	--sum(TP.Devengado) -  sum(TP.Pagado ) AS Deuda  
	
--From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG,  C_RamoPresupuestal As CR, C_AreaResponsabilidad as CA,  C_EP_Ramo As CEPR  
--where Mes=0 and (CR.CLAVE = 200 OR CR.DESCRIPCION = '')  AND (CA.IdAreaResp = 240 OR CA.Nombre = '') AND CEPR.Clave =1  AND CEPR.Nivel = ''''''''''''''''5'''''''''''''''' AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida 
--AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo AND  TS.IdAreaResp = CA.IdAreaResp AND CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal AND TS.IdRamoPresupuestal = CA.IdRamoPresupuestal  AND CEPR.Id = TS.IdProyecto

--Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,CA.Clave  , CA.Nombre,CEPR.Clave, CEPR.Nombre
--Order by  CEPR.Clave, CA.Clave  ,CG.IdCapitulo 



Else if @Tipo=26  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Cap�tulo del Gasto -Actividad Institucinal -UR
--Valores Relativos
/*
SET @nombreAI = (SELECT  tablaID.nombre 
FROM
(select * from C_EP_Ramo where id=  CASE WHEN @IdEP = '' THEN ID ELSE @IdEP END and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @claveAI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id=  CASE WHEN @IdEP = '' THEN ID ELSE @IdEP END and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id
*/
Select T1.ClaveUR, T1.Nombre, min(T1.ClaveProy)ClaveProy, Min(T1.Proyecto)Proyecto, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2, sum(T1.Autorizado)Autorizado, sum(T1.Ampliaciones)Ampliaciones, 
sum(T1.Reducciones)Reducciones, sum(T1.Modificado)Modificado, sum(T1.PreComprometido)PreComprometido, sum(T1.PresVigSinPreComp)PresVigSinPreComp, sum(T1.Comprometido)Comprometido, sum(T1.PreCompSinComp)PreCompSinComp, 
sum(T1.PresDispComp)PresDispComp, sum(T1.Devengado)Devengado, sum(T1.CompSinDev)CompSinDev, sum(T1.PresSinDev)PresSinDev, Sum(T1.Ejercido)Ejercido, sum(T1.DevSinEjer)DevSinEjer,sum(T1.Pagado)Pagado, sum(T1.EjerSinPAgar)EjerSinPAgar, sum(T1.Deuda)Deuda, 
/*(SELECT tablaID.nombre FROM
(select * from C_EP_Ramo where id = T1.Id and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id)*/''As NombreAI, 
/*(SELECT tablaID.Clave  
FROM
(select * from C_EP_Ramo where id=   T1.Id  and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id)*/ 1 As ClaveAI 
 from (
Select top 100 percent CA.Clave as ClaveUR , CA.Nombre ,CEPR.Clave as ClaveProy , CEPR.Nombre as Proyecto, 
CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  
    
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda, CEPR.Id
	
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal AND TS.IdRamoPresupuestal = CA.IdRamoPresupuestal 
inner join  C_EP_Ramo  CEPR 
on TS.IdProyecto = CEPR.Id 
left join C_PartidasPres  CP 
on TS.IdPartida  = CP.IdPartida 
left join C_ConceptosNEP  CN
on  CN.IdConcepto = CP.IdConcepto
left join C_CapitulosNEP  CG 
on CG.IdCapitulo = CN.IdCapitulo
left join C_FuenteFinanciamiento CFF
on CFF.IDFUENTEFINANCIAMIENTO =  TS.IdFuenteFinanciamiento 

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio 
AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
AND CEPR.Id = CASE WHEN @IdEP = '' THEN CEPR.ID ELSE @IdEP END  AND CEPR.Nivel = '5' 
AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END 

Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,CA.Clave , CA.Nombre,CEPR.Clave, CEPR.Nombre, CEPR.Id
Order by  CEPR.Clave, CA.Clave ,CG.IdCapitulo) as T1
group by  T1.ClaveUR, T1.Nombre, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2
END

Else if @Tipo=27 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Cap�tulo del Gasto -Actividad Institucinal -UR
--Valores Absolutos
Select T1.ClaveUR, T1.Nombre, min(T1.ClaveProy)ClaveProy, Min(T1.Proyecto)Proyecto, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2, sum(T1.Autorizado)Autorizado, sum(T1.Ampliaciones)Ampliaciones, 
sum(T1.Reducciones)Reducciones, sum(T1.Modificado)Modificado, sum(T1.PreComprometido)PreComprometido, sum(T1.PresVigSinPreComp)PresVigSinPreComp, sum(T1.Comprometido)Comprometido, sum(T1.PreCompSinComp)PreCompSinComp, 
sum(T1.PresDispComp)PresDispComp, sum(T1.Devengado)Devengado, sum(T1.CompSinDev)CompSinDev, sum(T1.PresSinDev)PresSinDev, Sum(T1.Ejercido)Ejercido, sum(T1.DevSinEjer)DevSinEjer,sum(T1.Pagado)Pagado, sum(T1.EjerSinPAgar)EjerSinPAgar, sum(T1.Deuda)Deuda, 
NombreAI, ClaveAI 
 from (
Select top 100 percent (SELECT tablaID.nombre FROM
(select * from C_EP_Ramo where id = CEPR.Id and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id)As NombreAI, 
(SELECT tablaID.Clave  
FROM
(select * from C_EP_Ramo where id=   CEPR.Id  and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id) As ClaveAI, CEPR.ID, CA.Clave as ClaveUR , CA.Nombre ,CEPR.Clave as ClaveProy , CEPR.Nombre as Proyecto,  
CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  
sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
SUM(isnull(TP.Precomprometido,0)) AS PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
SUM(isnull(TP.Precomprometido,0)) - sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Comprometido,0) ) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Devengado,0) )- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal AND TS.IdRamoPresupuestal = CA.IdRamoPresupuestal 
inner join  C_EP_Ramo  CEPR 
on TS.IdProyecto = CEPR.Id 
left join C_PartidasPres  CP 
on TS.IdPartida  = CP.IdPartida 
left join C_ConceptosNEP  CN
on  CN.IdConcepto = CP.IdConcepto
left join C_CapitulosNEP  CG 
on CG.IdCapitulo = CN.IdCapitulo
left join C_FuenteFinanciamiento CFF
on CFF.IDFUENTEFINANCIAMIENTO =  TS.IdFuenteFinanciamiento

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio 
AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
AND CEPR.Id = CASE WHEN @IdEP = '' THEN CEPR.ID ELSE @IdEP END  AND CEPR.Nivel = '5' 
AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END

Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,CA.Clave , CA.Nombre,CEPR.Clave, CEPR.Nombre, CEPR.Id
Order by  CEPR.Clave, CA.Clave ,CG.IdCapitulo) as T1
group by T1.ClaveAI, T1.NombreAI, T1.ClaveUR, T1.Nombre, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2
END

Else if @Tipo=28  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Cap�tulo del Gasto -Actividad Institucinal -UR
--Valores Relativos
Select T1.ClaveUR, T1.Nombre, min(T1.ClaveProy)ClaveProy, Min(T1.Proyecto)Proyecto, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2, sum(T1.Autorizado)Autorizado, sum(T1.Ampliaciones)Ampliaciones, 
sum(T1.Reducciones)Reducciones, sum(T1.Modificado)Modificado, sum(T1.PreComprometido)PreComprometido, sum(T1.PresVigSinPreComp)PresVigSinPreComp, sum(T1.Comprometido)Comprometido, sum(T1.PreCompSinComp)PreCompSinComp, 
sum(T1.PresDispComp)PresDispComp, sum(T1.Devengado)Devengado, sum(T1.CompSinDev)CompSinDev, sum(T1.PresSinDev)PresSinDev, Sum(T1.Ejercido)Ejercido, sum(T1.DevSinEjer)DevSinEjer,sum(T1.Pagado)Pagado, sum(T1.EjerSinPAgar)EjerSinPAgar, sum(T1.Deuda)Deuda, 
NombreAI, ClaveAI 
 from (
Select top 100 percent (SELECT tablaID.nombre FROM
(select * from C_EP_Ramo where id = CEPR.Id and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id)As NombreAI, 
(SELECT tablaID.Clave  
FROM
(select * from C_EP_Ramo where id=   CEPR.Id  and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id) As ClaveAI, 
CA.Clave as ClaveUR , CA.Nombre ,CEPR.Clave as ClaveProy , CEPR.Nombre as Proyecto, 
CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  
    
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda, CEPR.Id
	
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal AND TS.IdRamoPresupuestal = CA.IdRamoPresupuestal 
inner join  C_EP_Ramo  CEPR 
on TS.IdProyecto = CEPR.Id 
left join C_PartidasPres  CP 
on TS.IdPartida  = CP.IdPartida 
left join C_ConceptosNEP  CN
on  CN.IdConcepto = CP.IdConcepto
left join C_CapitulosNEP  CG 
on CG.IdCapitulo = CN.IdCapitulo
left join C_FuenteFinanciamiento CFF
on CFF.IDFUENTEFINANCIAMIENTO =  TS.IdFuenteFinanciamiento

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio and Year=@Ejercicio 
AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
AND CEPR.Id = CASE WHEN @IdEP = '' THEN CEPR.ID ELSE @IdEP END  AND CEPR.Nivel = '5' 
AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END

Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,CA.Clave , CA.Nombre,CEPR.Clave, CEPR.Nombre, CEPR.Id
Order by  CEPR.Clave, CA.Clave ,CG.IdCapitulo) as T1
group by  T1.NombreAI, T1.ClaveAI, T1.ClaveUR, T1.Nombre, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2
END

Else if @Tipo=30
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Especifica 
--Valores Relativos
--CA.Clave as ClaveUR , CA.Nombre ,
 Select CP.ClavePartida as Clave , CP.DescripcionPartida as Descripcion , 

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 
left join C_PartidasPres  CP 
on TS.IdPartida  = CP.IdPartida 
left join C_FuenteFinanciamiento CFF
on CFF.IDFUENTEFINANCIAMIENTO =  TS.IdFuenteFinanciamiento

where  (Mes BETWEEN @Mes AND @Mes2) AND LYear=@Ejercicio  and Year=@Ejercicio 
AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
and CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END   
group by CP.ClavePartida, CP.DescripcionPartida-- , CA.Clave  , CA.Nombre 
Order By CP.ClavePartida 
END


Else if @Tipo=32 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Gen�rica 
--Valores Relativos

--CA.Clave as ClaveUR  , CA.Nombre ,
Select  CPG.IdPartidaGenerica  as Clave , CPG.DescripcionPartida as Descripcion , 

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
    
SUM(isnull(TP.Precomprometido,0)) as PreComprometido,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - SUM(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
SUM(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))- (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and  CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 
inner join C_PartidasPres  CP
on CP.IdPartida  = TS.IdPartida
left join C_PartidasGenericasPres  CPG
on CP.IdPartidaGenerica = CPG.IdPartidaGenerica 
left join  C_ConceptosNEP CN
on CN.IdConcepto = CPG.IdConcepto
left join C_FuenteFinanciamiento CFF
on CFF.IDFUENTEFINANCIAMIENTO =  TS.IdFuenteFinanciamiento

where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio  and Year=@Ejercicio 
AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
AND CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
AND CPG.ClavePartida = CASE WHEN @IdPartida = 0 THEN CPG.ClavePartida else @IdPartida end   
AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END   
group by CPG.IdPartidaGenerica , CPG.DescripcionPartida-- , CA.Clave  , CA.Nombre 
Order By CPG.IdPartidaGenerica , CPG.DescripcionPartida
END
End 



GO

