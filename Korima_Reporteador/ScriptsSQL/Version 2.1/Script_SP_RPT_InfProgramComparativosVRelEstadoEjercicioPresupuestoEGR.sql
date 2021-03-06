/****** Object:  StoredProcedure [dbo].[SP_RPT_InfProgramComparativosVRelEstadoEjercicioPresupuestoEGR]    Script Date: 01/22/2013 11:08:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_InfProgramComparativosVRelEstadoEjercicioPresupuestoEGR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_InfProgramComparativosVRelEstadoEjercicioPresupuestoEGR]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_InfProgramComparativosVRelEstadoEjercicioPresupuestoEGR]    Script Date: 01/22/2013 11:08:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_RPT_InfProgramComparativosVRelEstadoEjercicioPresupuestoEGR] 

@Mes  as int,   
@Mes2  as int,
@Ejercicio as int,
@Clave as varchar(8),
@Clave2 as varchar(8),
@ClaveUR as varchar(8),
@IdEP as varchar(8),
@Tipo as int


AS
BEGIN


--**************************************************************************************************************
--//////*************************************VALORES RELATIVOS**************************/////////////////////


If @Tipo = 10
BEGIN

-- Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional
-- Valores Relativos

DECLARE @resultadoFinalR as table (Clave1 varchar(8),
Descripcion varchar(150) ,
Clave2 varchar(8) ,
Descripcion2 varchar(150) ,
Clave3 varchar(8) ,
Id varchar(8), 
Descripcion3 varchar(150), 
Clave4 varchar(8), 
NombreAI varchar(150), 
Autorizado decimal(15,2), 
TransferenciaAmp decimal(15,2), 
TransferenciaRed decimal(15,2), 
Modificado decimal(15,2), 
PreComprometido decimal(15,2), 
PresVigSinPreComp decimal(15,2),
Comprometido decimal(15,2), 
PreCompSinComp decimal(15,2), 
PresDispComp decimal(15,2), 
Devengado decimal(15,2), 
CompSinDev decimal(15,2),
PresSinDev decimal(15,2),
Ejercido decimal(15,2), 
DevSinEjer decimal(15,2), 
Pagado decimal(15,2), 
EjerSinPagar decimal(15,2),
Deuda decimal(15,2),
PorcAprobAnual decimal(15,2),
PorcAprobadocAnt decimal(15,2),
NomAprobado decimal(15,2),
PorcPVigenteAnual decimal(15,2),
PorcPVigenteAnt decimal(15,2),
NomPVigente decimal(15,2),
PorcCompvsVigente decimal(15,2),
NomCompvsVigente decimal(15,2),
PorcDevvsVigente decimal(15,2),
NomDevvsVigente decimal(15,2),
PorcCompAcvsVigenteAc decimal(15,2),
NomCompAcvsVigenteAc decimal(15,2),
PorcDevAcvsVigenteAc decimal(15,2),
NomDevAcvsVigenteAc decimal(15,2),
PorcEjerAcvsVigenteAc decimal(15,2),
NomEjerAcvsVigenteAc decimal(15,2),
PorcPagAcvsVigenteAc decimal(15,2),
NomPagAcvsVigenteAc decimal(15,2),
PorcCompAcvsVigenteAn decimal(15,2),
NomCompAcvsVigenteAn decimal(15,2),
PorcDevAcvsVigenteAn decimal(15,2),
NomDevAcvsVigenteAn decimal(15,2),
PorcEjerAcvsVigenteAn decimal(15,2),
NomEjerAcvsVigenteAn decimal(15,2),
PorcPagAcvsVigenteAn decimal(15,2),
NomPagAcvsVigenteAn decimal(15,2))

--///-- Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional
-- Valores Relativos
DECLARE @nombreRAI varchar(255)
DECLARE @ClaveRAI varchar(255)

SET @nombreRAI = (SELECT  tablaID.nombre 
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @ClaveRAI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id

INSERT INTO @resultadoFinalR (Clave1 ,Descripcion ,Clave2 ,Descripcion2 ,Clave3 ,Id , Descripcion3 , Clave4 , NombreAI , Autorizado , TransferenciaAmp , 
TransferenciaRed , Modificado , PreComprometido , PresVigSinPreComp ,Comprometido , PreCompSinComp , PresDispComp , Devengado , CompSinDev ,PresSinDev ,
Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda,PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente,PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,
PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)

Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion,
C_Funciones.Clave as Clave2,  C_Funciones.Nombre as Descripcion2, 
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Id, C_EP_Ramo.Nombre as Descripcion3,  @ClaveRAI as Clave4, @nombreRAI as NombreAI,
 
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0) ) AS PreComprometido,
       	
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
 sum(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
 sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) - (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  , 
 0,0,0,0,0,0,0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) as NomCompvsVigente,
0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0)) as NomDevvsVigente,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     
     
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal
ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo
ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones 
ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion  

WHERE  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= @Clave  and C_RamoPresupuestal.CLAVE <= @Clave2) AND C_EP_Ramo.Id =@IdEP 

GROUP BY C_RamoPresupuestal.CLAVE ,C_RamoPresupuestal.DESCRIPCION , C_EP_Ramo.Clave, C_EP_Ramo.ID, C_EP_Ramo.Nombre, C_Funciones.Clave, C_Funciones.Nombre 
Order By C_RamoPresupuestal.CLAVE,C_Funciones.Clave


--Columna 18
DECLARE @DIVR decimal(15,2)
SELECT @DIVR = isnull((Select  sum(isnull(TP.Autorizado,0))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal
ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo
ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones 
ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion  
LEFT JOIN @resultadoFinalR
ON Clave1 = C_RamoPresupuestal.CLAVE and Clave2 = C_Funciones.Clave 

where  Mes = 0 AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= @Clave and C_RamoPresupuestal.CLAVE <= @Clave2) AND C_EP_Ramo.Id =@IdEP
GROUP BY  C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id ),0)

IF @DIVR > 0 
begin
update  @resultadoFinalR set PorcAprobAnual =
((Select  (sum(isnull(tp.Autorizado,0)))* 100/ @DIVR

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal
ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo
ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones 
ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = C_RamoPresupuestal.CLAVE and Clave2 = C_Funciones.Clave 

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= @Clave and C_RamoPresupuestal.CLAVE <= @Clave2) AND C_EP_Ramo.Id =@IdEP
GROUP BY   C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id)
)/100
end
else if @DIVR = 0 
begin
update  @resultadoFinalR set PorcAprobAnual = 0
end
-------


--Columna 19
DECLARE @DIV2R decimal(15,2)
SELECT @DIV2R =isnull((Select  sum(isnull(tp.Autorizado,0))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY   cr.CLAVE, cepr.Id ) ,0)

If @DIV2R <> 0
begin

update  @resultadoFinalR set PorcAprobadocAnt =
(isnull((Select sum(isnull(tp.Autorizado,0))* 100/@DIV2R

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY   cr.CLAVE, cepr.Id),0))/100
end
else if @DIV2R = 0
begin
update  @resultadoFinalR set PorcAprobadocAnt =0
end


--Columna 20 y 21
update  @resultadoFinalR set NomAprobado =
isnull((Select (sum(isnull(tp.Autorizado,0)))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
GROUP BY  cr.CLAVE, cepr.Id),0) - isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
GROUP BY   cr.CLAVE, cepr.Id ),0) 



--Columna 22
DECLARE @DIV3R decimal(15,2)
SELECT @DIV3R = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
GROUP BY   cr.CLAVE, cepr.Id),0)

If @DIV3R > 0
begin

update  @resultadoFinalR set PorcPVigenteAnual =
(Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV3R

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
GROUP BY   cr.CLAVE, cepr.Id)/100
end
else if @DIV3R = 0
begin
update  @resultadoFinalR set PorcPVigenteAnual = 0
end

--Columna 23
DECLARE @DIV4R decimal(15,2)
SELECT @DIV4R =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY   cr.CLAVE, cepr.Id) ,0)


If @DIV4R <> 0
begin
update  @resultadoFinalR set PorcPVigenteAnt =
isnull((Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV4R

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
GROUP BY   cr.CLAVE, cepr.Id)/100,0)
end
else if @DIV4R = 0 
begin
update  @resultadoFinalR set PorcPVigenteAnt =0
end

--Columna 24 y 25
update  @resultadoFinalR set NomPVigente =
isnull((Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
GROUP BY   cr.CLAVE, cepr.Id),0) - ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY   cr.CLAVE, cepr.Id),0) 


------------
DECLARE @DIV1m decimal(15,2)
SELECT @DIV1m = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)
If @DIV1m > 0
begin
update  @resultadoFinalR set PorcCompvsVigente =
(Select sum(isnull(TP.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if  @DIV1m = 0
begin
update  @resultadoFinalR set PorcCompvsVigente = 0
end

------------------
DECLARE @DIV1n decimal(15,2)
SELECT @DIV1n = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)
If @DIV1n > 0
begin
update  @resultadoFinalR set PorcDevvsVigente =
(Select sum(isnull(TP.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if  @DIV1n = 0
begin
update  @resultadoFinalR set PorcDevvsVigente = 0
end 
 
---------------------------
DECLARE @DIV1a decimal(15,2)
SELECT @DIV1a =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)

If @DIV1a > 0
begin
update  @resultadoFinalR set PorcCompAcvsVigenteAc =
(Select sum(isnull(tp.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end 
else if @DIV1a = 0
begin
update  @resultadoFinalR set PorcCompAcvsVigenteAc = 0
end

-----------------------
update  @resultadoFinalR set NomCompAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
),0)

------------------------
DECLARE @DIV1b decimal(15,2)
SELECT @DIV1b =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
),0)
If @DIV1b > 0
begin
update  @resultadoFinalR set PorcDevAcvsVigenteAc =
(Select sum(isnull(tp.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if @DIV1b = 0
begin
update  @resultadoFinalR set PorcDevAcvsVigenteAc = 0
end

--------------------------------------
update  @resultadoFinalR set NomDevAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id 
),0)

-------------------
DECLARE @DIV1c decimal(15,2)
SELECT @DIV1c =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
),0)
If @DIV1c > 0
begin
update  @resultadoFinalR set PorcEjerAcvsVigenteAc =
(Select sum(isnull(tp.Ejercido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if @DIV1c = 0
begin
update  @resultadoFinalR set PorcEjerAcvsVigenteAc = 0
end

-----------------------------
update  @resultadoFinalR set NomEjerAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
),0)

-----------------
DECLARE @DIV1d decimal(15,2)
SELECT @DIV1d = ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY cr.CLAVE, cepr.Id
),0)
If @DIV1d > 0
begin
update  @resultadoFinalR set PorcPagAcvsVigenteAc =
(Select sum(isnull(tp.Pagado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY cr.CLAVE, cepr.Id
)/100
end
else if @DIV1d = 0
begin
update  @resultadoFinalR set PorcPagAcvsVigenteAc = 0
end

--------------
update  @resultadoFinalR set NomPagAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
),0)

-----------------
DECLARE @DIV1e decimal(15,2)
SELECT @DIV1e = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)
If @DIV1e > 0
begin
update  @resultadoFinalR set PorcCompAcvsVigenteAn =
(Select  (sum(isnull(tp.Comprometido,0)) * 100)/ @DIV1e

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if @DIV1e = 0
begin
update  @resultadoFinalR set PorcCompAcvsVigenteAn = 0
end

------------
update  @resultadoFinalR set NomCompAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY cr.CLAVE, cepr.Id
) - (Select  (sum(isnull(tp.Comprometido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)
),0)

-----------------
DECLARE @DIV1f decimal(15,2)
SELECT @DIV1f =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)
If @DIV1f > 0
begin
update  @resultadoFinalR set PorcDevAcvsVigenteAn =
(Select  (sum(isnull(tp.Devengado,0)) * 100)/ @DIV1f

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if @DIV1f = 0
begin
update  @resultadoFinalR set PorcDevAcvsVigenteAn = 0
end

--------------
update  @resultadoFinalR set NomDevAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) - (Select  (sum(isnull(tp.Devengado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY cr.CLAVE, cepr.Id
 )
),0)

----------------
DECLARE @DIV1g decimal(15,2)
SELECT @DIV1g = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)
If @DIV1g > 0
begin
update  @resultadoFinalR set PorcEjerAcvsVigenteAn =
(Select  (sum(isnull(tp.Ejercido,0)) * 100)/ @DIV1g

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if @DIV1g = 0
begin
update  @resultadoFinalR set PorcEjerAcvsVigenteAn = 0
end

----------------
update  @resultadoFinalR set NomEjerAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) - (Select  (sum(isnull(tp.Ejercido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)
),0)

-----------------------
DECLARE @DIV1h decimal(15,2)
SELECT @DIV1h = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)
If @DIV1h > 0
begin
update  @resultadoFinalR set PorcPagAcvsVigenteAn =
(Select  (sum(isnull(tp.Pagado,0)) * 100)/@DIV1h

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if @DIV1h = 0
begin
update  @resultadoFinalR set PorcPagAcvsVigenteAn = 0
end

---------------------------
update  @resultadoFinalR set NomPagAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id) - (Select  (sum(isnull(tp.Pagado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto  
LEFT JOIN C_SubFunciones 
ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
LEFT JOIN C_Funciones CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion 
LEFT JOIN @resultadoFinalR
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)
),0)

Select * from @resultadoFinalR
end


If @Tipo = 11 
BEGIN
-- Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo
-- Valores Relativos

DECLARE @resultadoFinal2R as table (
Clave1 varchar(8),
Descripcion varchar(150) ,
Clave2 varchar(8) ,
Descripcion2 varchar(150) ,
Clave3 varchar(8) ,
Descripcion3 varchar(150), 
Clave3a varchar(8),
Descripcion3a varchar(150),
Clave4 varchar(8), 
Id varchar(8), 
Descripcion4 varchar(150) , 
Clave5 varchar(8),
NombreAI varchar(150), 
Autorizado decimal(15,2), 
TransferenciaAmp decimal(15,2), 
TransferenciaRed decimal(15,2), 
Modificado decimal(15,2), 
PreComprometido decimal(15,2), 
PresVigSinPreComp decimal(15,2),
Comprometido decimal(15,2), 
PreCompSinComp decimal(15,2), 
PresDispComp decimal(15,2), 
Devengado decimal(15,2), 
CompSinDev decimal(15,2),
PresSinDev decimal(15,2),
Ejercido decimal(15,2), 
DevSinEjer decimal(15,2), 
Pagado decimal(15,2), 
EjerSinPagar decimal(15,2),
Deuda decimal(15,2),
PorcAprobAnual decimal(15,2),
PorcAprobadocAnt decimal(15,2),
NomAprobado decimal(15,2),
PorcPVigenteAnual decimal(15,2),
PorcPVigenteAnt decimal(15,2),
NomPVigente decimal(15,2),
PorcCompvsVigente decimal(15,2),
NomCompvsVigente decimal(15,2),
PorcDevvsVigente decimal(15,2),
NomDevvsVigente decimal(15,2),
PorcCompAcvsVigenteAc decimal(15,2),
NomCompAcvsVigenteAc decimal(15,2),
PorcDevAcvsVigenteAc decimal(15,2),
NomDevAcvsVigenteAc decimal(15,2),
PorcEjerAcvsVigenteAc decimal(15,2),
NomEjerAcvsVigenteAc decimal(15,2),
PorcPagAcvsVigenteAc decimal(15,2),
NomPagAcvsVigenteAc decimal(15,2),
PorcCompAcvsVigenteAn decimal(15,2),
NomCompAcvsVigenteAn decimal(15,2),
PorcDevAcvsVigenteAn decimal(15,2),
NomDevAcvsVigenteAn decimal(15,2),
PorcEjerAcvsVigenteAn decimal(15,2),
NomEjerAcvsVigenteAn decimal(15,2),
PorcPagAcvsVigenteAn decimal(15,2),
NomPagAcvsVigenteAn decimal(15,2))


DECLARE @nombre0RAI varchar(255)
DECLARE @clave0RAI varchar(255)

SET @nombre0RAI = (SELECT  tablaID.nombre 
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @clave0RAI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id

INSERT INTO @resultadoFinal2R (Clave1 ,
Descripcion ,
Clave2 ,
Descripcion2 ,
Clave3 ,
Descripcion3 , 
Clave3a,
Descripcion3a,
Clave4 , 
Id,
Descripcion4 , 
Clave5,
NombreAI,Autorizado , TransferenciaAmp , TransferenciaRed , Modificado , PreComprometido , PresVigSinPreComp ,Comprometido , PreCompSinComp , PresDispComp , Devengado , CompSinDev ,
PresSinDev ,Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda,PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente,PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,
PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)

Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
C_AreaResponsabilidad.Clave  as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2,
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3, 
@clave0RAI as Clave3a, C_CapitulosNEP.Descripcion as Descripcion3a,
C_CapitulosNEP.IdCapitulo as Clave4, C_EP_Ramo.Id, 
C_ConceptosNEP.Descripcion as Descripcion4,  C_ConceptosNEP.IdConcepto  as Clave5, @nombre0RAI as NombreAI,


 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0) ) AS PreComprometido,
       	
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
 sum(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
 sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) - (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  , 
 0,0,0,0,0,0,0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) as NomCompvsVigente,
0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0)) as NomDevvsVigente,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  	
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal
ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo
ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_AreaResponsabilidad 
ON (C_AreaResponsabilidad.IdAreaResp = T_SellosPresupuestales.IdAreaResp) AND (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP 
ON  C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo 

WHERE (Mes BETWEEN @Mes  and @Mes2 ) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= @Clave and C_RamoPresupuestal.CLAVE <= @Clave2) AND C_AreaResponsabilidad.Clave = @ClaveUR AND C_EP_Ramo.Id =@IdEP
	 
Group by  C_CapitulosNEP.IdCapitulo, C_CapitulosNEP.Descripcion, C_ConceptosNEP.IdConcepto, C_ConceptosNEP.Descripcion, C_ConceptosNEP.IdCapitulo,C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre,C_EP_Ramo.Clave,C_EP_Ramo.Id, C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE,C_RamoPresupuestal.DESCRIPCION 
Order by  C_AreaResponsabilidad.Clave  ,C_CapitulosNEP.IdCapitulo 


--Columna 18
DECLARE @DIV2Rb decimal(15,2)
SELECT @DIV2Rb = ISNULL((Select  sum(isnull(TP.Autorizado,0))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ),0) 

IF @DIV2Rb > 0 
begin

update  @resultadoFinal2R set PorcAprobAnual =
(Select (sum(isnull(tp.Autorizado,0))) * 100/ @DIV2Rb
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)/100
end
else if @DIV2Rb = 0 
begin
update  @resultadoFinal2R set PorcAprobAnual = 0
end


--Columna 19
DECLARE @DIV2Rd decimal(15,2)
SELECT @DIV2Rd =isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)   
If @DIV2Rd > 0
begin
update  @resultadoFinal2R set PorcAprobadocAnt =
isnull((Select (sum(isnull(tp.Autorizado,0)))* 100 /@DIV2Rd
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0) 
end 
else if @DIV2Rd = 0
begin
update  @resultadoFinal2R set PorcAprobadocAnt = 0
end


--Columna 20 y 21
update  @resultadoFinal2R set NomAprobado =
isnull((Select  (sum(isnull(tp.Autorizado,0)))

FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0) - isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ),0) 



--Columna 22
DECLARE @DIV2Rc decimal(15,2)
SELECT @DIV2Rc = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)


If @DIV2Rc > 0
begin
update  @resultadoFinal2R set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV2Rc

FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )/100
end 
else if @DIV2Rc = 0
begin
update  @resultadoFinal2R set PorcPVigenteAnual = 0
end



--Columna 23
DECLARE @DIV2Re decimal(15,2)
SELECT @DIV2Re =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)

If @DIV2Re > 0
begin
update  @resultadoFinal2R set PorcPVigenteAnt =
ISNULL((Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV2Re
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)/100,0)
end
else if @DIV2Re = 0
begin
update  @resultadoFinal2R set PorcPVigenteAnt = 0
end


--Columna 24 y 25
update  @resultadoFinal2R set NomPVigente =
ISNULL((Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0) - ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0) 


--------------------------
DECLARE @DIV2m decimal(15,2)
SELECT @DIV2m = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave,cepr.Id
) ,0)
If @DIV2m > 0
begin
update  @resultadoFinal2R set PorcCompvsVigente =
(Select sum(isnull(TP.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave,cepr.Id
)/100
end
else if  @DIV2m = 0
begin
update  @resultadoFinal2R set PorcCompvsVigente = 0
end

------------------
DECLARE @DIV2n decimal(15,2)
SELECT @DIV2n = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN @Mes and @Mes2 )  AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave,cepr.Id
) ,0)
If @DIV2n > 0
begin
update  @resultadoFinal2R set PorcDevvsVigente =
(Select sum(isnull(TP.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN @Mes and @Mes2 ) AND  LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave,cepr.Id
)/100
end
else if  @DIV2n = 0
begin
update  @resultadoFinal2R set PorcDevvsVigente = 0
end

-----------------------------------
DECLARE @DIV2a decimal(15,2)
SELECT @DIV2a =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave,cepr.Id
),0)
If @DIV2a > 0
begin
update  @resultadoFinal2R set PorcCompAcvsVigenteAc =
(Select sum(isnull(tp.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100 
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave,cepr.Id
)
end
else if @DIV2a = 0
begin
update  @resultadoFinal2R set PorcCompAcvsVigenteAc = 0
end

----------------
update  @resultadoFinal2R set NomCompAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave,cepr.Id
),0)

-----------------------
DECLARE @DIV2f decimal(15,2)
SELECT @DIV2f = ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)
if @DIV2f > 0
begin
update  @resultadoFinal2R set PorcDevAcvsVigenteAc =
(Select sum(isnull(tp.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )
end
else if @DIV2f = 0
begin
update  @resultadoFinal2R set PorcDevAcvsVigenteAc = 0
end

-------------------------
update  @resultadoFinal2R set NomDevAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ),0)


--------------------------
DECLARE @DIV2g decimal(15,2)
SELECT @DIV2g =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ),0)
If @DIV2g > 0
begin
update  @resultadoFinal2R set PorcEjerAcvsVigenteAc =
(Select sum(isnull(tp.Ejercido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )
end
else if @DIV2g = 0
begin
update  @resultadoFinal2R set PorcEjerAcvsVigenteAc =  0
end

-----------------
update  @resultadoFinal2R set NomEjerAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ),0)

-----------------------
DECLARE @DIV2h decimal(15,2)
SELECT @DIV2h = ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ),0)
If @DIV2h > 0
begin
update  @resultadoFinal2R set PorcPagAcvsVigenteAc =
(Select sum(isnull(tp.Pagado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )
end
else if @DIV2h = 0
begin
update  @resultadoFinal2R set PorcPagAcvsVigenteAc = 0
end

----------------------
update  @resultadoFinal2R set NomPagAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave 
),0)

--------------------------
DECLARE @DIV2i decimal(15,2)
SELECT @DIV2i = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave   ),0)
If @DIV2i > 0
begin
update  @resultadoFinal2R set PorcCompAcvsVigenteAn =
(Select  (sum(isnull(tp.Comprometido,0)) * 100)/ @DIV2i
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave 
)/100
end
else if @DIV2i = 0
begin
update  @resultadoFinal2R set PorcCompAcvsVigenteAn = 0
end

-------------------------------
update  @resultadoFinal2R set NomCompAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ) - (Select  (sum(isnull(tp.Comprometido,0)))

FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave 
 )
),0)

------------------------
DECLARE @DIV2j decimal(15,2)
SELECT @DIV2j = ISNULL( (Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)
If @DIV2j > 0
begin
update  @resultadoFinal2R set PorcDevAcvsVigenteAn =
(Select  (sum(isnull(tp.Devengado,0)) * 100)/ @DIV2j
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV2j = 0
begin
update  @resultadoFinal2R set PorcDevAcvsVigenteAn = 0
end

-------------------------------
update  @resultadoFinal2R set NomDevAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) - (Select  (sum(isnull(tp.Devengado,0)))

FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)
),0)

----------------------------------
DECLARE @DIV2k decimal(15,2)
SELECT @DIV2k = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0) 
If @DIV2k > 0
begin
update  @resultadoFinal2R set PorcEjerAcvsVigenteAn =
(Select  (sum(isnull(tp.Ejercido,0)) * 100)/ @DIV2k
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave 
)/100
end
else if @DIV2k = 0
begin
update  @resultadoFinal2R set PorcEjerAcvsVigenteAn = 0
end

----------------------------------
update  @resultadoFinal2R set NomEjerAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) - (Select  (sum(isnull(tp.Ejercido,0)))

FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)
),0)

---------------------------------
DECLARE @DIV2l decimal(15,2)
SELECT @DIV2l = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave) ,0)
If @DIV2l > 0
begin
update  @resultadoFinal2R set PorcPagAcvsVigenteAn =
(Select  (sum(isnull(tp.Pagado,0)) * 100)/ @DIV2l
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave 
)/100
end
else if @DIV2l = 0
begin
update  @resultadoFinal2R set PorcPagAcvsVigenteAn = 0
end

------------------------------------
update  @resultadoFinal2R set NomPagAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ),0) - isnull((Select  (sum(isnull(tp.Pagado,0)))

FROM T_SellosPresupuestales TS
INNER JOIN T_PRESUPUESTONW TP
ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = TS.IdProyecto 
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = TS.IdPartida 
INNER JOIN C_AreaResponsabilidad  CA
ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ConceptosNEP cn
ON  cn.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP cpn
ON cpn.IdCapitulo = cpn.IdCapitulo 
left join @resultadoFinal2R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)


Select * from @resultadoFinal2R
END



If @Tipo = 12 
BEGIN
--Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica
-- Valores Relativos

DECLARE @resultadoFinal3R as table (
Clave1 varchar(8),
Descripcion varchar(150) ,
Clave2 varchar(8) ,
Descripcion2 varchar(150) ,
Clave3 varchar(8) ,
NombreAI varchar(150), 
Clave3a varchar(8),
Descripcion3a varchar(150),
Clave4 varchar(8),
Descripcion4 varchar(150) , 
Id varchar(8), 
Clave5 varchar(8),
Descripcion3 varchar(150), 
Autorizado decimal(15,2), 
TransferenciaAmp decimal(15,2), 
TransferenciaRed decimal(15,2), 
Modificado decimal(15,2), 
PreComprometido decimal(15,2), 
PresVigSinPreComp decimal(15,2),
Comprometido decimal(15,2), 
PreCompSinComp decimal(15,2), 
PresDispComp decimal(15,2), 
Devengado decimal(15,2), 
CompSinDev decimal(15,2),
PresSinDev decimal(15,2),
Ejercido decimal(15,2), 
DevSinEjer decimal(15,2), 
Pagado decimal(15,2), 
EjerSinPagar decimal(15,2),
Deuda decimal(15,2),
PorcAprobAnual decimal(15,2),
PorcAprobadocAnt decimal(15,2),
NomAprobado decimal(15,2),
PorcPVigenteAnual decimal(15,2),
PorcPVigenteAnt decimal(15,2),
NomPVigente decimal(15,2),
PorcCompvsVigente decimal(15,2),
NomCompvsVigente decimal(15,2),
PorcDevvsVigente decimal(15,2),
NomDevvsVigente decimal(15,2),
PorcCompAcvsVigenteAc decimal(15,2),
NomCompAcvsVigenteAc decimal(15,2),
PorcDevAcvsVigenteAc decimal(15,2),
NomDevAcvsVigenteAc decimal(15,2),
PorcEjerAcvsVigenteAc decimal(15,2),
NomEjerAcvsVigenteAc decimal(15,2),
PorcPagAcvsVigenteAc decimal(15,2),
NomPagAcvsVigenteAc decimal(15,2),
PorcCompAcvsVigenteAn decimal(15,2),
NomCompAcvsVigenteAn decimal(15,2),
PorcDevAcvsVigenteAn decimal(15,2),
NomDevAcvsVigenteAn decimal(15,2),
PorcEjerAcvsVigenteAn decimal(15,2),
NomEjerAcvsVigenteAn decimal(15,2),
PorcPagAcvsVigenteAn decimal(15,2),
NomPagAcvsVigenteAn decimal(15,2))

DECLARE @nombre1RAI varchar(255)
DECLARE @clave1RAI varchar(255)

SET @nombre1RAI = (SELECT  tablaID.nombre 
FROM
(select * from C_EP_Ramo where id= @IdEP  and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @clave1RAI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id


INSERT INTO @resultadoFinal3R (Clave1 ,
Descripcion ,
Clave2 ,
Descripcion2 ,
Clave3 ,
NombreAI,
Clave3a,
Descripcion3a,
Clave4 , 
Descripcion4 , 
Id,
Clave5, 
Descripcion3 , Autorizado , TransferenciaAmp , TransferenciaRed , Modificado , PreComprometido , PresVigSinPreComp ,Comprometido , PreCompSinComp , PresDispComp , 
Devengado , CompSinDev ,PresSinDev ,Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda, PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente, PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,
PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)

Select   C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion,
C_EP_Ramo.Clave AS Clave2, C_EP_Ramo.Nombre as Descripcion2,
@clave1RAI as Clave3, @nombre1RAI as NombreAI, 
C_CapitulosNEP.IdCapitulo as Clave3a, C_CapitulosNEP.Descripcion as Descripcion3a, 
C_ConceptosNEP.IdConcepto  as Clave4,  C_ConceptosNEP.Descripcion as Descripcion4, 
C_EP_Ramo.Id, 
C_TipoGasto.Clave as Clave5, C_TipoGasto.NOMBRE as Descripcion3, 
  
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0) ) AS PreComprometido,
       	
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
 sum(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
 sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) - (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  ,
 0,0,0,0,0,0,0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) as NomCompvsVigente,
0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0)) as NomDevvsVigente,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal
ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP 
ON  C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo
INNER JOIN C_EP_Ramo 
ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto 

 
where  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= @Clave  and C_RamoPresupuestal.CLAVE <= @Clave2)  AND C_EP_Ramo.Id =@IdEP 

Group by C_CapitulosNEP.IdCapitulo, C_CapitulosNEP.Descripcion, C_TipoGasto.Clave ,C_TipoGasto.NOMBRE,C_EP_Ramo.Clave,C_EP_Ramo.Id,C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE ,C_RamoPresupuestal.DESCRIPCION ,
C_ConceptosNEP.IdConcepto, C_ConceptosNEP.Descripcion 
Order by C_TipoGasto.Clave, C_CapitulosNEP.IdCapitulo ,C_RamoPresupuestal.CLAVE



 
--Columna 1
DECLARE @DIV3Ra decimal(15,2)
SELECT @DIV3Ra = ISNULL((Select  sum(isnull(TP.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE, cepr.Id) ,0)

If @DIV3Ra > 0
begin
update  @resultadoFinal3R set PorcAprobAnual =
(Select  (sum(isnull(tp.Autorizado,0)) * 100)/ @DIV3Ra

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE, cepr.Id )/100
end
else if @DIV3Ra = 0
begin
update  @resultadoFinal3R set PorcAprobAnual = 0
end

--Columna 2
DECLARE @DIV3Rc decimal(15,2)
SELECT @DIV3Rc = isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ) ,0) 
If @DIV3Rc > 0
begin
update  @resultadoFinal3R set PorcAprobadocAnt =
isnull((Select (sum(isnull(tp.Autorizado,0)) * 100)/@DIV3Rc
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id )/100,0)
end
else if @DIV3Rc = 0
begin
update  @resultadoFinal3R set PorcAprobadocAnt = 0
end


--Columna 3 y 4
update  @resultadoFinal3R set NomAprobado =
isnull((Select  (sum(isnull(tp.Autorizado,0)))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id),0) - isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0) 



--Columna 5
DECLARE @DIV3Rb decimal(15,2)
SELECT @DIV3Rb = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0)

If @DIV3Rb > 0
begin
update  @resultadoFinal3R set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV3Rb

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE,  cepr.Id )/100
end
else if @DIV3Rb = 0
begin
update  @resultadoFinal3R set PorcPVigenteAnual = 0
end


--Columna 6
DECLARE @DIV3Rd decimal(15,2)
SELECT @DIV3Rd =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Id ) ,0)
If @DIV3Rd > 0
begin
update  @resultadoFinal3R set PorcPVigenteAnt =
isnull((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV3Rd

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id )/100,0)
end
else if @DIV3Rd = 0
begin
update  @resultadoFinal3R set PorcPVigenteAnt = 0
end


--Columna 7 y 8
update  @resultadoFinal3R set NomPVigente =
isnull((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0) - ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE, cepr.Id ) ,0)

-----------------------------
DECLARE @DIV3m decimal(15,2)
SELECT @DIV3m = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
) ,0)
If @DIV3m > 0
begin
update  @resultadoFinal3R set PorcCompvsVigente =
(Select sum(isnull(TP.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
)/100
end
else if  @DIV3m = 0
begin
update  @resultadoFinal3R set PorcCompvsVigente = 0
end

------------------
DECLARE @DIV3n decimal(15,2)
SELECT @DIV3n = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
) ,0)
If @DIV3n > 0
begin
update  @resultadoFinal3R set PorcDevvsVigente =
(Select sum(isnull(TP.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
)/100
end
else if  @DIV3n = 0
begin
update  @resultadoFinal3R set PorcDevvsVigente = 0
end

--------------------------------------
DECLARE @DIV3e decimal(15,2)
SELECT @DIV3e =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
),0)
If @DIV3e > 0
begin
update  @resultadoFinal3R set PorcCompAcvsVigenteAc =
(Select sum(isnull(tp.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
)/100
end
else if @DIV3e = 0
begin
update  @resultadoFinal3R set PorcCompAcvsVigenteAc = 0
end

----------------------------------
update  @resultadoFinal3R set NomCompAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
),0)

----------------------------------
DECLARE @DIV3f decimal(15,2)
SELECT @DIV3f =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0)
If @DIV3f > 0
begin
update  @resultadoFinal3R set PorcDevAcvsVigenteAc =
(Select sum(isnull(tp.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id  )/100
end
else if @DIV3f  = 0
begin
update  @resultadoFinal3R set PorcDevAcvsVigenteAc = 0
end

--------------------------
update  @resultadoFinal3R set NomDevAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0)

-------------------------
DECLARE @DIV3g decimal(15,2)
SELECT @DIV3g =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0)
If @DIV3g > 0
begin
update  @resultadoFinal3R set PorcEjerAcvsVigenteAc =
(Select sum(isnull(tp.Ejercido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id )/100
end
else if @DIV3g = 0
begin
update  @resultadoFinal3R set PorcEjerAcvsVigenteAc = 0
end

------------------------------
update  @resultadoFinal3R set NomEjerAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0)

------------------------------
DECLARE @DIV3h decimal(15,2)
SELECT @DIV3h = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0)
If @DIV3h > 0
begin
update  @resultadoFinal3R set PorcPagAcvsVigenteAc =
(Select sum(isnull(tp.Pagado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id )/100
end
else if @DIV3h = 0
begin
update  @resultadoFinal3R set PorcPagAcvsVigenteAc = 0
end

--------------------------------
update  @resultadoFinal3R set NomPagAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
),0)

-----------------------------------
DECLARE @DIV3i decimal(15,2)
SELECT @DIV3i = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ) ,0)
If @DIV3i > 0
begin
update  @resultadoFinal3R set PorcCompAcvsVigenteAn =
(Select  (sum(isnull(tp.Comprometido,0)) * 100)/ @DIV3i
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
)/100
end
else if @DIV3i = 0
begin
update  @resultadoFinal3R set PorcCompAcvsVigenteAn = 0
end

-----------------------------
update  @resultadoFinal3R set NomCompAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ) - (Select  (sum(isnull(tp.Comprometido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
 )
),0)

----------------------------------
DECLARE @DIV3j decimal(15,2)
SELECT @DIV3j = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ) ,0)
If @DIV3j > 0
begin
update  @resultadoFinal3R set PorcDevAcvsVigenteAn =
(Select  (sum(isnull(tp.Devengado,0)) * 100)/ @DIV3j
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id 
)/100
end
else if @DIV3j = 0
begin
update  @resultadoFinal3R set PorcDevAcvsVigenteAn = 0
end

-----------------------------------
update  @resultadoFinal3R set NomDevAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id  ) - (Select  (sum(isnull(tp.Devengado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
)
),0)

-----------------------------------
DECLARE @DIV3k decimal(15,2)
SELECT @DIV3k = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id  ),0) 
If @DIV3k > 0
begin 
update  @resultadoFinal3R set PorcEjerAcvsVigenteAn =
(Select  (sum(isnull(tp.Ejercido,0)) * 100)/ @DIV3k
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
)/100
end
else if @DIV3k = 0
begin
update  @resultadoFinal3R set PorcEjerAcvsVigenteAn = 0
end

-----------------------------------
update  @resultadoFinal3R set NomEjerAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id) - (Select  (sum(isnull(tp.Ejercido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id )
),0)

------------------------------
DECLARE @DIV3l decimal(15,2)
SELECT @DIV3l =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id),0)
If @DIV3l > 0
begin
update  @resultadoFinal3R set PorcPagAcvsVigenteAn =
(Select  (sum(isnull(tp.Pagado,0)) * 100)/ @DIV3l
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
)/100
end
else if @DIV3l = 0
begin
update  @resultadoFinal3R set PorcPagAcvsVigenteAn = 0
end

---------------------------------
update  @resultadoFinal3R set NomPagAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ) - (Select  (sum(isnull(tp.Pagado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
INNER JOIN C_TipoGasto
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_ConceptosNEP CN
ON  CN.IdConcepto = C_PartidasPres.IdConcepto
INNER JOIN C_CapitulosNEP CPN
ON CPN.IdCapitulo = CN.IdCapitulo
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
left join @resultadoFinal3R
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id)
),0)


Select * from @resultadoFinal3R
END



If @Tipo = 13
BEGIN
--Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento
-- Valores Relativos

DECLARE @resultadoFinal4R as table (
Clave1 varchar(8),
Descripcion varchar(150) ,
Clave2 varchar(8) ,
Descripcion2 varchar(150) ,
Clave3 varchar(8) ,
Descripcion3 varchar(150), 
Clave4 varchar(8), 
Id varchar(8),
NombreAI varchar(150), 
Clave5 varchar(8),
Descripcion4 varchar(150) , 
Clave6 varchar(8),
Descripcion5 varchar(150) , 
Autorizado decimal(15,2), 
TransferenciaAmp decimal(15,2), 
TransferenciaRed decimal(15,2), 
Modificado decimal(15,2), 
PreComprometido decimal(15,2), 
PresVigSinPreComp decimal(15,2),
Comprometido decimal(15,2), 
PreCompSinComp decimal(15,2), 
PresDispComp decimal(15,2), 
Devengado decimal(15,2), 
CompSinDev decimal(15,2),
PresSinDev decimal(15,2),
Ejercido decimal(15,2), 
DevSinEjer decimal(15,2), 
Pagado decimal(15,2), 
EjerSinPagar decimal(15,2),
Deuda decimal(15,2),
PorcAprobAnual decimal(15,2),
PorcAprobadocAnt decimal(15,2),
NomAprobado decimal(15,2),
PorcPVigenteAnual decimal(15,2),
PorcPVigenteAnt decimal(15,2),
NomPVigente decimal(15,2),
PorcCompvsVigente decimal(15,2),
NomCompvsVigente decimal(15,2),
PorcDevvsVigente decimal(15,2),
NomDevvsVigente decimal(15,2),
PorcCompAcvsVigenteAc decimal(15,2),
NomCompAcvsVigenteAc decimal(15,2),
PorcDevAcvsVigenteAc decimal(15,2),
NomDevAcvsVigenteAc decimal(15,2),
PorcEjerAcvsVigenteAc decimal(15,2),
NomEjerAcvsVigenteAc decimal(15,2),
PorcPagAcvsVigenteAc decimal(15,2),
NomPagAcvsVigenteAc decimal(15,2),
PorcCompAcvsVigenteAn decimal(15,2),
NomCompAcvsVigenteAn decimal(15,2),
PorcDevAcvsVigenteAn decimal(15,2),
NomDevAcvsVigenteAn decimal(15,2),
PorcEjerAcvsVigenteAn decimal(15,2),
NomEjerAcvsVigenteAn decimal(15,2),
PorcPagAcvsVigenteAn decimal(15,2),
NomPagAcvsVigenteAn decimal(15,2))


DECLARE @nombre2RAI varchar(255)
DECLARE @clave2RAI varchar(255)

SET @nombre2RAI = (SELECT  tablaID.nombre 
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @clave2RAI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id

INSERT INTO @resultadoFinal4R (Clave1 ,
Descripcion ,
Clave2 ,
Descripcion2 ,
Clave3 ,
Descripcion3 , 
Clave4,
Id,
NombreAI,
Clave5 , 
Descripcion4,
Clave6,
Descripcion5 , Autorizado , TransferenciaAmp , TransferenciaRed , Modificado , PreComprometido , PresVigSinPreComp ,Comprometido , PreCompSinComp , PresDispComp , Devengado , CompSinDev ,
PresSinDev ,Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda,PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente,PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,
PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)

Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
C_AreaResponsabilidad.Clave as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2 , 
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3, @clave2RAI as Clave4,C_EP_Ramo.Id,  @nombre2RAI as NombreAI,
C_PartidasGenericasPres.IdPartidaGenerica as Clave5 , C_PartidasGenericasPres.DescripcionPartida  as Descripcion4, 
C_FuenteFinanciamiento.CLAVE AS Clave6, C_FuenteFinanciamiento.DESCRIPCION AS Descripcion5,
 
 
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0) ) AS PreComprometido,
       	
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
 sum(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
 sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) - (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  ,
 0,0,0,0,0,0,0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) as NomCompvsVigente,
0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0)) as NomDevvsVigente,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 
 
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal
ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad 
ON C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo 
ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  

	where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= @Clave and C_RamoPresupuestal.CLAVE <= @Clave2 ) and C_AreaResponsabilidad.Clave  = @ClaveUR AND C_EP_Ramo.Id =@IdEP 
 	
	group by C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida , C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre, C_RamoPresupuestal.CLAVE , C_RamoPresupuestal.DESCRIPCION , C_FuenteFinanciamiento.CLAVE, C_FuenteFinanciamiento.DESCRIPCION , C_EP_Ramo.Clave, C_EP_Ramo.Nombre, C_EP_Ramo.Id  
	Order By C_AreaResponsabilidad.Clave ,C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida,C_RamoPresupuestal.CLAVE 


--Columna 1
DECLARE @DIV4Ra decimal(15,2)
SELECT @DIV4Ra = isnull((Select  sum(isnull(TP.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0) 


If @DIV4Ra > 0
begin
update  @resultadoFinal4R set PorcAprobAnual =
(Select (sum(isnull(tp.Autorizado,0)) * 100)/ @DIV4Ra

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )/100
end
else if @DIV4Ra = 0
begin
update  @resultadoFinal4R set PorcAprobAnual = 0
end


--Columna 2
DECLARE @DIV4Rc decimal(15,2)
SELECT @DIV4Rc = isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)   
If @DIV4Rc > 0
begin
update  @resultadoFinal4R set PorcAprobadocAnt =
isnull((Select  (sum(isnull(tp.Autorizado,0)) * 100)/@DIV4Rc

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100,0)
end
else if @DIV4Rc = 0
begin
update  @resultadoFinal4R set PorcAprobadocAnt = 0
end

--Columna 3 y 4
update  @resultadoFinal4R set NomAprobado =
isnull((Select (sum(isnull(tp.Autorizado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0) - isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0) 


--Columna 5
DECLARE @DIV4Rb decimal(15,2)
SELECT @DIV4Rb = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)

If @DIV4Rb > 0
begin
update  @resultadoFinal4R set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV4Rb

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV4Rb = 0
begin
update  @resultadoFinal4R set PorcPVigenteAnual = 0
end



--Columna 6
DECLARE @DIV4Rd decimal(15,2)
SELECT @DIV4Rd =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)
If @DIV4Rd > 0
begin
update  @resultadoFinal4R set PorcPVigenteAnt =
isnull((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV4Rd

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100,0)
end
else if @DIV4Rd = 0
begin
update  @resultadoFinal4R set PorcPVigenteAnt = 0
end



--Columna 7 y 8
update  @resultadoFinal4R set NomPVigente =
ISNULL((Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0) - ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)


-----------------------------
DECLARE @DIV4m decimal(15,2)
SELECT @DIV4m = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
) ,0)
If @DIV4m > 0
begin
update  @resultadoFinal4R set PorcCompvsVigente =
(Select sum(isnull(TP.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if  @DIV4m = 0
begin
update  @resultadoFinal4R set PorcCompvsVigente = 0
end

------------------
DECLARE @DIV4n decimal(15,2)
SELECT @DIV4n = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
) ,0)
If @DIV4n > 0
begin
update  @resultadoFinal4R set PorcDevvsVigente =
(Select sum(isnull(TP.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if  @DIV4n = 0
begin
update  @resultadoFinal4R set PorcDevvsVigente = 0
end

------------------------------------
DECLARE @DIV4e decimal(15,2)
SELECT @DIV4e =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)
If @DIV4e > 0
begin
update  @resultadoFinal4R set PorcCompAcvsVigenteAc =
(Select sum(isnull(tp.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100 as PorcCompAcvsVigenteAc
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)
end
else if @DIV4e = 0
begin
update  @resultadoFinal4R set PorcCompAcvsVigenteAc = 0
end

------------------------------------------
update  @resultadoFinal4R set NomCompAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)

------------------------------
DECLARE @DIV4f decimal(15,2)
SELECT @DIV4f =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)
If @DIV4f > 0
begin
update  @resultadoFinal4R set PorcDevAcvsVigenteAc =
(Select sum(isnull(tp.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)
end
else if @DIV4f = 0
begin
update  @resultadoFinal4R set PorcDevAcvsVigenteAc = 0
end

----------------------------
update  @resultadoFinal4R set NomDevAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)

--------------------------
DECLARE @DIV4g decimal(15,2)
SELECT @DIV4g =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)
If @DIV4g > 0
begin
update  @resultadoFinal4R set PorcEjerAcvsVigenteAc =
(Select sum(isnull(tp.Ejercido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )
end
else if @DIV4g = 0
begin
update  @resultadoFinal4R set PorcEjerAcvsVigenteAc = 0
end

----------------------------
update  @resultadoFinal4R set NomEjerAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)


-----------------------
DECLARE @DIV4h decimal(15,2)
SELECT @DIV4h =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)
If @DIV4h > 0
begin
update  @resultadoFinal4R set PorcPagAcvsVigenteAc =
(Select sum(isnull(tp.Pagado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)
end
else if @DIV4h  = 0
begin
update  @resultadoFinal4R set PorcPagAcvsVigenteAc = 0
end

------------------------------------
update  @resultadoFinal4R set NomPagAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)

----------------------------
DECLARE @DIV4i decimal(15,2)
SELECT @DIV4i =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)
If @DIV4i > 0
begin
update  @resultadoFinal4R set PorcCompAcvsVigenteAn =
(Select  (sum(isnull(tp.Comprometido,0)) * 100)/ @DIV4i
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV4i  = 0
begin
update  @resultadoFinal4R set PorcCompAcvsVigenteAn = 0
end

-------------------------------------
update  @resultadoFinal4R set NomCompAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) - (Select  (sum(isnull(tp.Comprometido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
 )
),0)

------------------------
DECLARE @DIV4j decimal(15,2)
SELECT @DIV4j =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0) 
If @DIV4j > 0
begin
update  @resultadoFinal4R set PorcDevAcvsVigenteAn =
(Select  (sum(isnull(tp.Devengado,0)) * 100)/ @DIV4j
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave 
)/100
end
else if @DIV4j = 0
begin
update  @resultadoFinal4R set PorcDevAcvsVigenteAn = 0
end

------------------------------
update  @resultadoFinal4R set NomDevAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) - (Select  (sum(isnull(tp.Devengado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)
),0)

----------------------
DECLARE @DIV4k decimal(15,2)
SELECT @DIV4k =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0) 
If @DIV4k > 0
begin
update  @resultadoFinal4R set PorcEjerAcvsVigenteAn =
(Select  (sum(isnull(tp.Ejercido,0)) * 100)/ @DIV4k
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV4k = 0
begin
update  @resultadoFinal4R set PorcEjerAcvsVigenteAn = 0
end

------------------------
update  @resultadoFinal4R set NomEjerAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) - (Select  (sum(isnull(tp.Ejercido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)
),0)

----------------------
DECLARE @DIV4l decimal(15,2)
SELECT @DIV4l =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave) ,0)
If @DIV4l > 0
begin
update  @resultadoFinal4R set PorcPagAcvsVigenteAn =
(Select  (sum(isnull(tp.Pagado,0)) * 100)/ @DIV4l
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV4l = 0
begin
update  @resultadoFinal4R set PorcPagAcvsVigenteAn = 0
end

------------------------
update  @resultadoFinal4R set NomPagAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave) - (Select  (sum(isnull(tp.Pagado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento cff
ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
left join  @resultadoFinal4R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)
),0)

Select * from @resultadoFinal4R
END




If @Tipo = 14 
BEGIN	
--Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Distribución Geográfica
-- Valores Relativos

DECLARE @resultadoFinal5R as table (
Clave1 varchar(8),
Descripcion varchar(150) ,
Clave2 varchar(8) ,
Descripcion2 varchar(150) ,
Clave3 varchar(8) ,
Descripcion3 varchar(150), 
Clave4 varchar(8), 
Id varchar(8),
NombreAI varchar(150),
Clave5 varchar(8),
Descripcion4 varchar(150) , 
Clave6 varchar(8),
Descripcion5 varchar(150) , 
Autorizado decimal(15,2), 
TransferenciaAmp decimal(15,2), 
TransferenciaRed decimal(15,2), 
Modificado decimal(15,2), 
PreComprometido decimal(15,2), 
PresVigSinPreComp decimal(15,2),
Comprometido decimal(15,2), 
PreCompSinComp decimal(15,2), 
PresDispComp decimal(15,2), 
Devengado decimal(15,2), 
CompSinDev decimal(15,2),
PresSinDev decimal(15,2),
Ejercido decimal(15,2), 
DevSinEjer decimal(15,2), 
Pagado decimal(15,2), 
EjerSinPagar decimal(15,2),
Deuda decimal(15,2),
PorcAprobAnual decimal(15,2),
PorcAprobadocAnt decimal(15,2),
NomAprobado decimal(15,2),
PorcPVigenteAnual decimal(15,2),
PorcPVigenteAnt decimal(15,2),
NomPVigente decimal(15,2),
PorcCompvsVigente decimal(15,2),
NomCompvsVigente decimal(15,2),
PorcDevvsVigente decimal(15,2),
NomDevvsVigente decimal(15,2),
PorcCompAcvsVigenteAc decimal(15,2),
NomCompAcvsVigenteAc decimal(15,2),
PorcDevAcvsVigenteAc decimal(15,2),
NomDevAcvsVigenteAc decimal(15,2),
PorcEjerAcvsVigenteAc decimal(15,2),
NomEjerAcvsVigenteAc decimal(15,2),
PorcPagAcvsVigenteAc decimal(15,2),
NomPagAcvsVigenteAc decimal(15,2),
PorcCompAcvsVigenteAn decimal(15,2),
NomCompAcvsVigenteAn decimal(15,2),
PorcDevAcvsVigenteAn decimal(15,2),
NomDevAcvsVigenteAn decimal(15,2),
PorcEjerAcvsVigenteAn decimal(15,2),
NomEjerAcvsVigenteAn decimal(15,2),
PorcPagAcvsVigenteAn decimal(15,2),
NomPagAcvsVigenteAn decimal(15,2))


DECLARE @nombre3RAI varchar(255)
DECLARE @clave3RAI varchar(255)

SET @nombre3RAI = (SELECT  tablaID.nombre 
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @clave3RAI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id


INSERT INTO @resultadoFinal5R (Clave1 ,
Descripcion ,
Clave2 ,
Descripcion2 ,
Clave3 ,
Descripcion3 , 
Clave4,
Id,
NombreAI,
Clave5 , 
Descripcion4,
Clave6,
Descripcion5 ,Autorizado , TransferenciaAmp , TransferenciaRed , Modificado , PreComprometido , PresVigSinPreComp ,Comprometido , PreCompSinComp , PresDispComp , 
Devengado , CompSinDev ,PresSinDev ,Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda,PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente,PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,
PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)

Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
C_AreaResponsabilidad.Clave as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2 , 
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3,@clave3RAI as Clave4, C_EP_Ramo.Id,  @nombre3RAI as NombreAI,
C_PartidasGenericasPres.IdPartidaGenerica as Clave5 , C_PartidasGenericasPres.DescripcionPartida  as Descripcion4, 
C_ClasificadorGeograficoPresupuestal.Clave AS Clave6, C_ClasificadorGeograficoPresupuestal.Descripcion as Descripcion5,
 
 
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0) ) AS PreComprometido,
       	
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
 sum(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
 sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) - (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  ,
 0,0,0,0,0,0,0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) as NomCompvsVigente,
0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0)) as NomDevvsVigente,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal
ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad 
ON (C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal 
ON C_ClasificadorGeograficoPresupuestal.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo 
ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  

where  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= @Clave and C_RamoPresupuestal.CLAVE <= @Clave2) AND C_AreaResponsabilidad.Clave  = @ClaveUR  AND C_EP_Ramo.Id =@IdEP    

group by C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida , C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre, C_RamoPresupuestal.CLAVE , C_RamoPresupuestal.DESCRIPCION ,  C_EP_Ramo.Clave, C_EP_Ramo.Nombre, C_EP_Ramo.Id, C_ClasificadorGeograficoPresupuestal.Clave , C_ClasificadorGeograficoPresupuestal.Descripcion  
Order By C_AreaResponsabilidad.Clave ,C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida,C_RamoPresupuestal.CLAVE 


--Columna 1
DECLARE @DIV5Ra decimal(15,2)
SELECT @DIV5Ra = ISNULL((Select  sum(isnull(TP.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)

If @DIV5Ra > 0
begin
update  @resultadoFinal5R set PorcAprobAnual =
(Select  (sum(isnull(tp.Autorizado,0)) * 100)/  @DIV5Ra

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR 
group by cr.CLAVE, ca.Clave
)/100

end
if @DIV5Ra = 0
begin
update  @resultadoFinal5R set PorcAprobAnual = 0
end


--Columna 2
DECLARE @DIV5Rc decimal(15,2)
SELECT @DIV5Rc = isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave) ,0) 
If @DIV5Rc > 0
begin
update  @resultadoFinal5R set PorcAprobadocAnt =
ISNULL((Select (sum(isnull(tp.Autorizado,0)) * 100)/@DIV5Rc

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100,0)
end
else if @DIV5Rc = 0
begin
update  @resultadoFinal5R set PorcAprobadocAnt = 0
end

--Columna 3 y 4
update  @resultadoFinal5R set NomAprobado =
isnull((Select (sum(isnull(tp.Autorizado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0) - isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0) 


--Columna 5
DECLARE @DIV5Rb decimal(15,2)
SELECT @DIV5Rb = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave) ,0)

If @DIV5Rb > 0
begin
update  @resultadoFinal5R set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV5Rb
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV5Rb = 0
begin
update  @resultadoFinal5R set PorcPVigenteAnual = 0
end


--Columna 6
DECLARE @DIV5Rd decimal(15,2)
SELECT @DIV5Rd =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0) 

If @DIV5Rd > 0
begin
update  @resultadoFinal5R set PorcPVigenteAnt =
isnull((Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV5Rd
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100,0)
end
else if @DIV5Rd = 0
begin
update  @resultadoFinal5R set PorcPVigenteAnt = 0
end

--Columna 7 y 8
update  @resultadoFinal5R set NomPVigente =
ISNULL((Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0) - ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)


-----------------------------
DECLARE @DIV5m decimal(15,2)
SELECT @DIV5m = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
) ,0)
If @DIV5m > 0
begin
update  @resultadoFinal5R set PorcCompvsVigente =
(Select sum(isnull(TP.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if  @DIV5m = 0
begin
update  @resultadoFinal5R set PorcCompvsVigente = 0
end

------------------
DECLARE @DIV5n decimal(15,2)
SELECT @DIV5n = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
) ,0)
If @DIV5n > 0
begin
update  @resultadoFinal5R set PorcDevvsVigente =
(Select sum(isnull(TP.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if  @DIV5n = 0
begin
update  @resultadoFinal5R set PorcDevvsVigente = 0
end

-------------------------------------
DECLARE @DIV5e decimal(15,2)
SELECT @DIV5e =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)
If @DIV5e > 0
begin
update  @resultadoFinal5R set PorcCompAcvsVigenteAc =
(Select sum(isnull(tp.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100 as PorcCompAcvsVigenteAc
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)
end
else if @DIV5e = 0
begin
update  @resultadoFinal5R set PorcCompAcvsVigenteAc = 0
end

------------------------------------
update  @resultadoFinal5R set NomCompAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)

--------------------------
DECLARE @DIV5f decimal(15,2)
SELECT @DIV5f = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)
If @DIV5f > 0
begin
update  @resultadoFinal5R set PorcDevAcvsVigenteAc =
(Select sum(isnull(tp.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)
end
else if @DIV5f = 0
begin
update  @resultadoFinal5R set PorcDevAcvsVigenteAc = 0
end

-----------------------------------------
update  @resultadoFinal5R set NomDevAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)

-----------------------------
DECLARE @DIV5g decimal(15,2)
SELECT @DIV5g =ISNULL( (Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)
If @DIV5g > 0
begin
update  @resultadoFinal5R set PorcEjerAcvsVigenteAc =
(Select sum(isnull(tp.Ejercido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )
end
else if @DIV5g = 0
begin
update  @resultadoFinal5R set PorcEjerAcvsVigenteAc = 0
end

----------------------------------
update  @resultadoFinal5R set NomEjerAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)

--------------------
DECLARE @DIV5h decimal(15,2)
SELECT @DIV5h =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)
If @DIV5h > 0
begin
update  @resultadoFinal5R set PorcPagAcvsVigenteAc =
(Select sum(isnull(tp.Pagado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)
end
else if @DIV5h = 0
begin
update  @resultadoFinal5R set PorcPagAcvsVigenteAc = 0
end

------------------------------
update  @resultadoFinal5R set NomPagAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)

----------------------------
DECLARE @DIV5i decimal(15,2)
SELECT @DIV5i =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0) 
If @DIV5i > 0
begin
update  @resultadoFinal5R set PorcCompAcvsVigenteAn =
(Select  (sum(isnull(tp.Comprometido,0)) * 100)/ @DIV5i
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV5i = 0
begin
update  @resultadoFinal5R set PorcCompAcvsVigenteAn = 0
end

---------------------------
update  @resultadoFinal5R set NomCompAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) - (Select  (sum(isnull(tp.Comprometido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
 )
),0)

---------------------------------
DECLARE @DIV5j decimal(15,2)
SELECT @DIV5j =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ),0) 
If @DIV5j > 0
begin
update  @resultadoFinal5R set PorcDevAcvsVigenteAn =
(Select  (sum(isnull(tp.Devengado,0)) * 100)/ @DIV5j
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV5j = 0
begin
update  @resultadoFinal5R set PorcDevAcvsVigenteAn = 0
end

--------------------------------
update  @resultadoFinal5R set NomDevAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ) - (Select  (sum(isnull(tp.Devengado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)
),0)

--------------------------------------
DECLARE @DIV5k decimal(15,2)
SELECT @DIV5k =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ) ,0)
If @DIV5k > 0
begin
update  @resultadoFinal5R set PorcEjerAcvsVigenteAn =
(Select  (sum(isnull(tp.Ejercido,0)) * 100)/@DIV5k 
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV5k = 0
begin
update  @resultadoFinal5R set PorcEjerAcvsVigenteAn = 0
end

-------------------------------
update  @resultadoFinal5R set NomEjerAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ) - (Select  (sum(isnull(tp.Ejercido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )
),0)

------------------------
DECLARE @DIV5l decimal(15,2)
SELECT @DIV5l =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0) 
If @DIV5l > 0
begin
update  @resultadoFinal5R set PorcPagAcvsVigenteAn =
(Select  (sum(isnull(tp.Pagado,0)) * 100)/ @DIV5l
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV5l = 0
begin
update  @resultadoFinal5R set PorcPagAcvsVigenteAn = 0
end

----------------------------
update  @resultadoFinal5R set NomPagAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) - (Select  (sum(isnull(tp.Pagado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres  CPG
ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
INNER JOIN C_ClasificadorGeograficoPresupuestal cg
ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
INNER JOIN C_EP_Ramo  cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
left join  @resultadoFinal5R
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)
),0)

Select * from @resultadoFinal5R
END



If @Tipo = 15 
BEGIN
--Ramo o Dependencia / Función / Programas y Proyectos de Inversión
-- Valores Relativos

DECLARE @resultadoFinal6R as table (
Clave1 varchar(8),
Descripcion varchar(150) ,
Clave2 varchar(8) ,
Descripcion2 varchar(150) ,
Clave3 varchar(8) ,
Id varchar(8),
Descripcion3 varchar(150), 
Clave4 varchar(8), 
Descripcion4 varchar(150) ,  
Autorizado decimal(15,2), 
TransferenciaAmp decimal(15,2), 
TransferenciaRed decimal(15,2), 
Modificado decimal(15,2), 
PreComprometido decimal(15,2), 
PresVigSinPreComp decimal(15,2),
Comprometido decimal(15,2), 
PreCompSinComp decimal(15,2), 
PresDispComp decimal(15,2), 
Devengado decimal(15,2), 
CompSinDev decimal(15,2),
PresSinDev decimal(15,2),
Ejercido decimal(15,2), 
DevSinEjer decimal(15,2), 
Pagado decimal(15,2), 
EjerSinPagar decimal(15,2),
Deuda decimal(15,2),
PorcAprobAnual decimal(15,2),
PorcAprobadocAnt decimal(15,2),
NomAprobado decimal(15,2),
PorcPVigenteAnual decimal(15,2),
PorcPVigenteAnt decimal(15,2),
NomPVigente decimal(15,2),
PorcCompvsVigente decimal(15,2),
NomCompvsVigente decimal(15,2),
PorcDevvsVigente decimal(15,2),
NomDevvsVigente decimal(15,2),
PorcCompAcvsVigenteAc decimal(15,2),
NomCompAcvsVigenteAc decimal(15,2),
PorcDevAcvsVigenteAc decimal(15,2),
NomDevAcvsVigenteAc decimal(15,2),
PorcEjerAcvsVigenteAc decimal(15,2),
NomEjerAcvsVigenteAc decimal(15,2),
PorcPagAcvsVigenteAc decimal(15,2),
NomPagAcvsVigenteAc decimal(15,2),
PorcCompAcvsVigenteAn decimal(15,2),
NomCompAcvsVigenteAn decimal(15,2),
PorcDevAcvsVigenteAn decimal(15,2),
NomDevAcvsVigenteAn decimal(15,2),
PorcEjerAcvsVigenteAn decimal(15,2),
NomEjerAcvsVigenteAn decimal(15,2),
PorcPagAcvsVigenteAn decimal(15,2),
NomPagAcvsVigenteAn decimal(15,2))

INSERT INTO @resultadoFinal6R (Clave1 ,
Descripcion ,
Clave2 ,
Descripcion2 ,
Clave3 ,
Id,
Descripcion3 , 
Clave4,
Descripcion4,Autorizado , TransferenciaAmp , 
TransferenciaRed , Modificado , PreComprometido , PresVigSinPreComp ,Comprometido , PreCompSinComp , PresDispComp , Devengado , CompSinDev ,PresSinDev ,
Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda,PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente ,PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,
PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn )

Select C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion,
 C_funciones.Clave as Clave2,  C_funciones.Nombre as Descripcion2, 
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Id, C_EP_Ramo.Nombre as Descripcion3, 
C_ProyectosInversion.CLAVE as Clave4, C_ProyectosInversion.NOMBRE as Descripcion4,

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0) ) AS PreComprometido,
       	
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
 sum(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
 sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) - (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  ,
 0,0,0,0,0,0,0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) as NomCompvsVigente,
0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0)) as NomDevvsVigente,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal
ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo 
ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  
ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion  

where   (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= @Clave and C_RamoPresupuestal.CLAVE <= @Clave2) AND C_EP_Ramo.Id =@IdEP

group by C_funciones.Clave, C_funciones.Nombre,  C_funciones.IdFuncion ,C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE ,C_RamoPresupuestal.DESCRIPCION,C_EP_Ramo.Clave,C_EP_Ramo.Id,T_SellosPresupuestales.IdProyecto ,C_ProyectosInversion.CLAVE,C_ProyectosInversion.NOMBRE 
Order By C_RamoPresupuestal.CLAVE,C_funciones.Clave

update  @resultadoFinal6R set PorcCompAcvsVigenteAc =
(Select sum(isnull(tp.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100 as PorcCompAcvsVigenteAc
FROM T_PRESUPUESTONW tp,T_SellosPresupuestales TS, C_RamoPresupuestal CR, C_EP_Ramo CEPR,C_SubFunciones CSF, C_Funciones CF,C_ProyectosInversion CPI
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal and cr.IDRAMOPRESUPUESTAL = ts.IdRamoPresupuestal  and cepr.Id = ts.IdProyecto and csf.IdSubFuncion = ts.IdSubFuncion and cf.IdFuncion = csf.IdFuncion 
and ts.Proyecto = cPI.PROYECTO and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
group by cr.CLAVE, cf.Clave
)


--Columna 1
DECLARE @DIV6Ra decimal(15,2)
SELECT @DIV6Ra = ISNULL((Select  sum(isnull(TP.Autorizado,0))
 
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ),0) 

If @DIV6Ra > 0
begin
update  @resultadoFinal6R set PorcAprobAnual =
(Select  (sum(isnull(tp.Autorizado,0)) * 100)/ @DIV6Ra

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100
end
else if @DIV6Ra = 0
begin
update  @resultadoFinal6R set PorcAprobAnual = 0
end



--Columna 2
DECLARE @DIV6Rc decimal(15,2)
SELECT @DIV6Rc =isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ),0)    
If @DIV6Rc > 0
begin
update  @resultadoFinal6R set PorcAprobadocAnt =
ISNULL((Select  (sum(isnull(tp.Autorizado,0)) * 100)/@DIV6Rc

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100,0)
end
else if @DIV6Rc = 0
begin
update  @resultadoFinal6R set PorcAprobadocAnt = 0
end



--Columna 3 y 4
update  @resultadoFinal6R set NomAprobado =
isnull((Select  (sum(isnull(tp.Autorizado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
),0) - isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ) ,0) 

--Columna 5
DECLARE @DIV6Rb decimal(15,2)
SELECT @DIV6Rb = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ),0) 


If @DIV6Rb > 0
begin
update  @resultadoFinal6R set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV6Rb
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100
end
else if @DIV6Rb = 0
begin
update  @resultadoFinal6R set PorcPVigenteAnual = 0
end




--Columna 6
DECLARE @DIV6Rd decimal(15,2)
SELECT @DIV6Rd =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ),0)

If @DIV6Rd > 0
begin
update  @resultadoFinal6R set PorcPVigenteAnt =
ISNULL((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV6Rd

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100,0)
end
else if @DIV6Rd = 0
begin
update  @resultadoFinal6R set PorcPVigenteAnt = 0
end

--Columna 7 y 8
update  @resultadoFinal6R set NomPVigente =
ISNULL((Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
),0) - ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ),0)


-----------------------------
DECLARE @DIV6m decimal(15,2)
SELECT @DIV6m = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
) ,0)
If @DIV6m > 0
begin
update  @resultadoFinal6R set PorcCompvsVigente =
(Select sum(isnull(TP.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100
end
else if  @DIV6m = 0
begin
update  @resultadoFinal6R set PorcCompvsVigente = 0
end

------------------
DECLARE @DIV6n decimal(15,2)
SELECT @DIV6n = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
) ,0)
If @DIV6n > 0
begin
update  @resultadoFinal6R set PorcDevvsVigente =
(Select sum(isnull(TP.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100
end
else if  @DIV6n = 0
begin
update  @resultadoFinal6R set PorcDevvsVigente = 0
end


------------------------------------
DECLARE @DIV6e decimal(15,2)
SELECT @DIV6e =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
),0)
If @DIV6e > 0
begin
update  @resultadoFinal6R set PorcCompAcvsVigenteAc =
(Select sum(isnull(tp.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100 
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)
end
else if @DIV6e = 0
begin
update  @resultadoFinal6R set PorcCompAcvsVigenteAc = 0
end

--------------------------------
update  @resultadoFinal6R set NomCompAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
),0)

------------------------------------
DECLARE @DIV6f decimal(15,2)
SELECT @DIV6f =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave),0)
If @DIV6f > 0
begin
update  @resultadoFinal6R set PorcDevAcvsVigenteAc =
(Select sum(isnull(tp.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave)
end
else if @DIV6f  = 0
begin
update  @resultadoFinal6R set PorcDevAcvsVigenteAc = 0
end

------------------------------------
update  @resultadoFinal6R set NomDevAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave),0)

---------------------------------
DECLARE @DIV6g decimal(15,2)
SELECT @DIV6g =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave),0)
If @DIV6g >  0
begin
update  @resultadoFinal6R set PorcEjerAcvsVigenteAc =
(Select sum(isnull(tp.Ejercido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave)
end
else if @DIV6g = 0
begin
update  @resultadoFinal6R set PorcEjerAcvsVigenteAc = 0
end

----------------------------------
update  @resultadoFinal6R set NomEjerAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ),0)

--------------------
DECLARE @DIV6h decimal(15,2)
SELECT @DIV6h =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave),0)
If @DIV6h > 0
begin
update  @resultadoFinal6R set PorcPagAcvsVigenteAc =
(Select sum(isnull(tp.Pagado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave)
end
else if @DIV6h = 0
begin
update  @resultadoFinal6R set PorcPagAcvsVigenteAc = 0
end

----------------------------
update  @resultadoFinal6R set NomPagAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave 
),0)

---------------------------------
DECLARE @DIV6i decimal(15,2)
SELECT @DIV6i =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave  ),0) 
If @DIV6i > 0
begin
update  @resultadoFinal6R set PorcCompAcvsVigenteAn =
(Select  (sum(isnull(tp.Comprometido,0)) * 100)/ @DIV6i
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave 
)/100
end
else if @DIV6i = 0
begin
update  @resultadoFinal6R set PorcCompAcvsVigenteAn = 0
end

---------------------------------
update  @resultadoFinal6R set NomCompAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ) - (Select  (sum(isnull(tp.Comprometido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave 
 )
),0)

-------------------------------
DECLARE @DIV6j decimal(15,2)
SELECT @DIV6j =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave   ),0) 
If @DIV6j > 0
begin
update  @resultadoFinal6R set PorcDevAcvsVigenteAn =
(Select  (sum(isnull(tp.Devengado,0)) * 100)/ @DIV6j
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave 
)/100
end
else if @DIV6j = 0
begin
update  @resultadoFinal6R set PorcDevAcvsVigenteAn = 0
end

------------------------------------
update  @resultadoFinal6R set NomDevAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave  ) - (Select  (sum(isnull(tp.Devengado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave 
)
),0)

-------------------------
DECLARE @DIV6k decimal(15,2)
SELECT @DIV6k =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ) ,0)
If @DIV6k > 0
begin
update  @resultadoFinal6R set PorcEjerAcvsVigenteAn =
(Select  (sum(isnull(tp.Ejercido,0)) * 100)/ @DIV6k
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave 
)/100
end
else if @DIV6k = 0
begin
update  @resultadoFinal6R set PorcEjerAcvsVigenteAn = 0
end

----------------------------
update  @resultadoFinal6R set NomEjerAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave  ) - (Select  (sum(isnull(tp.Ejercido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave )
),0)

------------------------------
DECLARE @DIV6l decimal(15,2)
SELECT @DIV6l =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave) ,0)
If @DIV6l > 0
begin
update  @resultadoFinal6R set PorcPagAcvsVigenteAn =
(Select  (sum(isnull(tp.Pagado,0)) * 100)/ @DIV6l
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100
end
else if @DIV6l = 0
begin
update  @resultadoFinal6R set PorcPagAcvsVigenteAn = 0
end

-------------------------------
update  @resultadoFinal6R set NomPagAcvsVigenteAn =
ISNULL(((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ) - (Select  (sum(isnull(tp.Pagado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo  CEPR
ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_SubFunciones  
ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
left JOIN C_Funciones  CF
ON CF.IdFuncion = C_SubFunciones.IdFuncion  
left JOIN @resultadoFinal6R  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave)
),0)



Select * from @resultadoFinal6R
END



If @Tipo = 16
BEGIN
--Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasificación Económica
-- Valores Relativos

DECLARE @resultadoFinal7R as table (
Clave1 varchar(8),
Descripcion varchar(150) ,
Clave2 varchar(8) ,
Descripcion2 varchar(150) ,
Clave3 varchar(8) ,
Descripcion3 varchar(150), 
Id varchar(8),  
Clave4 varchar(8), 
Descripcion4 varchar(150) ,
Clave4a varchar(8), 
Descripcion4a varchar(150) ,
Clave5 varchar(8),
Descripcion5 varchar(150) ,
Clave6 varchar(8),
Descripcion6 varchar(150) ,
Autorizado decimal(15,2), 
TransferenciaAmp decimal(15,2), 
TransferenciaRed decimal(15,2), 
Modificado decimal(15,2), 
PreComprometido decimal(15,2), 
PresVigSinPreComp decimal(15,2),
Comprometido decimal(15,2), 
PreCompSinComp decimal(15,2), 
PresDispComp decimal(15,2), 
Devengado decimal(15,2), 
CompSinDev decimal(15,2),
PresSinDev decimal(15,2),
Ejercido decimal(15,2), 
DevSinEjer decimal(15,2), 
Pagado decimal(15,2), 
EjerSinPagar decimal(15,2),
Deuda decimal(15,2),
PorcAprobAnual decimal(15,2),
PorcAprobadocAnt decimal(15,2),
NomAprobado decimal(15,2),
PorcPVigenteAnual decimal(15,2),
PorcPVigenteAnt decimal(15,2),
NomPVigente decimal(15,2),
PorcCompvsVigente decimal(15,2),
NomCompvsVigente decimal(15,2),
PorcDevvsVigente decimal(15,2),
NomDevvsVigente decimal(15,2),
PorcCompAcvsVigenteAc decimal(15,2),
NomCompAcvsVigenteAc decimal(15,2),
PorcDevAcvsVigenteAc decimal(15,2),
NomDevAcvsVigenteAc decimal(15,2),
PorcEjerAcvsVigenteAc decimal(15,2),
NomEjerAcvsVigenteAc decimal(15,2),
PorcPagAcvsVigenteAc decimal(15,2),
NomPagAcvsVigenteAc decimal(15,2),
PorcCompAcvsVigenteAn decimal(15,2),
NomCompAcvsVigenteAn decimal(15,2),
PorcDevAcvsVigenteAn decimal(15,2),
NomDevAcvsVigenteAn decimal(15,2),
PorcEjerAcvsVigenteAn decimal(15,2),
NomEjerAcvsVigenteAn decimal(15,2),
PorcPagAcvsVigenteAn decimal(15,2),
NomPagAcvsVigenteAn decimal(15,2))

INSERT INTO @resultadoFinal7R (Clave1,
Descripcion ,
Clave2 ,
Descripcion2  ,
Clave3  ,
Descripcion3 , 
Id ,  
Clave4 , 
Descripcion4  ,
Clave4a , 
Descripcion4a  ,
Clave5 ,
Descripcion5  ,
Clave6 ,
Descripcion6 ,Autorizado , TransferenciaAmp , TransferenciaRed , Modificado , PreComprometido , PresVigSinPreComp ,Comprometido , PreCompSinComp , 
PresDispComp , Devengado , CompSinDev ,PresSinDev ,Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda, PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente,PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,
PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn )


Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
C_AreaResponsabilidad.Clave  as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2 ,
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3,  C_EP_Ramo.Id,
C_ProyectosInversion.CLAVE AS Clave4, C_ProyectosInversion.NOMBRE as Descripcion4,
C_CapitulosNEP.IdCapitulo as Clave4a, C_CapitulosNEP.Descripcion as Descripcion4a, 
C_ConceptosNEP.IdConcepto  as Clave5, C_ConceptosNEP.Descripcion as Descripcion5, 
C_TipoGasto.Clave as Clave6, C_TipoGasto.NOMBRE as Descripcion6, 


 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0) ) AS PreComprometido,
       	
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
 sum(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
 sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) - (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  ,
 0,0,0,0,0,0,0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) as NomCompvsVigente,
0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0)) as NomDevvsVigente,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal
ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo 
ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad 
ON (C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (C_AreaResponsabilidad.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto 
ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo   	
	
WHERE  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= @Clave and C_RamoPresupuestal.CLAVE <= @Clave2) AND C_AreaResponsabilidad.Clave = @ClaveUR  AND C_EP_Ramo.Id =@IdEP

Group by  C_CapitulosNEP.IdCapitulo, C_CapitulosNEP.Descripcion, C_ConceptosNEP.IdConcepto, C_ConceptosNEP.Descripcion, C_ConceptosNEP.IdCapitulo,C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre,C_EP_Ramo.Clave,C_EP_Ramo.Id, C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE,C_RamoPresupuestal.DESCRIPCION,C_TipoGasto.Clave, C_TipoGasto.nombre, C_ProyectosInversion.CLAVE, C_ProyectosInversion.NOMBRE   
Order by  C_AreaResponsabilidad.Clave  ,C_CapitulosNEP.IdCapitulo 



--Columna 1
DECLARE @DIV7Ra decimal(15,2)
SELECT @DIV7Ra =isnull((Select  sum(isnull(TP.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ) ,0)

If @DIV7Ra > 0
begin
update  @resultadoFinal7R set PorcAprobAnual =
(Select  (sum(isnull(tp.Autorizado,0)) * 100)/ @DIV7Ra

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  )/100
end
else if @DIV7Ra = 0
begin
update  @resultadoFinal7R set PorcAprobAnual = 0
end


--Columna 2
DECLARE @DIV7Rc decimal(15,2)
SELECT @DIV7Rc =isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)

If @DIV7Rc > 0
begin
update  @resultadoFinal7R set PorcAprobadocAnt =
isnull((Select (sum(isnull(tp.Autorizado,0)) * 100)/@DIV7Rc

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  )/100,0)
end
else if @DIV7Rc = 0
begin
update  @resultadoFinal7R set PorcAprobadocAnt = 0
end


--Columna 3 y 4
update  @resultadoFinal7R set NomAprobado =
isnull((Select  (sum(isnull(tp.Autorizado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0) - isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0)  


--Columna 5
DECLARE @DIV7Rb decimal(15,2)
SELECT @DIV7Rb =isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0) 


If @DIV7Rb > 0 
begin
update  @resultadoFinal7R set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV7Rb
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave )/100
end
else if @DIV7Rb = 0
begin
update  @resultadoFinal7R set PorcPVigenteAnual = 0
end

--Columna 6
DECLARE @DIV7Rd decimal(15,2)
SELECT @DIV7Rd =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0)

If @DIV7Rd > 0
begin
update  @resultadoFinal7R set PorcPVigenteAnt =
ISNULL((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV7Rd
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  )/100,0)
end
else if @DIV7Rd = 0
begin
update  @resultadoFinal7R set PorcPVigenteAnt = 0
end

--Columna 7 y 8
update  @resultadoFinal7R set NomPVigente =
ISNULL((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0) - ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ) ,0)


-----------------------------
DECLARE @DIV7m decimal(15,2)
SELECT @DIV7m = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave
) ,0)
If @DIV7m > 0
begin
update  @resultadoFinal7R set PorcCompvsVigente =
(Select sum(isnull(TP.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if  @DIV7m = 0
begin
update  @resultadoFinal7R set PorcCompvsVigente = 0
end

------------------
DECLARE @DIV7n decimal(15,2)
SELECT @DIV7n = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave
) ,0)
If @DIV7n > 0
begin
update  @resultadoFinal7R set PorcDevvsVigente =
(Select sum(isnull(TP.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if  @DIV7n = 0
begin
update  @resultadoFinal7R set PorcDevvsVigente = 0
end


------------------------------------------
DECLARE @DIV7e decimal(15,2)
SELECT @DIV7e = ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave
),0)
If @DIV7e > 0
begin
update  @resultadoFinal7R set PorcCompAcvsVigenteAc =
(Select sum(isnull(tp.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100 as PorcCompAcvsVigenteAc
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)
end
else if @DIV7e = 0
begin
update  @resultadoFinal7R set PorcCompAcvsVigenteAc = 0
end

-----------------------------------------
update  @resultadoFinal7R set NomCompAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
),0)

------------------------
DECLARE @DIV7f decimal(15,2)
SELECT @DIV7f = ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave),0)
If @DIV7f > 0
begin
update  @resultadoFinal7R set PorcDevAcvsVigenteAc =
(Select sum(isnull(tp.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave)
end
else if @DIV7f = 0
begin
update  @resultadoFinal7R set PorcDevAcvsVigenteAc = 0
end

-----------------------------------
update  @resultadoFinal7R set NomDevAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)

---------------------------
DECLARE @DIV7g decimal(15,2)
SELECT @DIV7g = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)
If @DIV7g > 0
begin
update  @resultadoFinal7R set PorcEjerAcvsVigenteAc =
(Select sum(isnull(tp.Ejercido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave )
end
else if @DIV7g = 0
begin
update  @resultadoFinal7R set PorcEjerAcvsVigenteAc = 0
end

----------------------------------
update  @resultadoFinal7R set NomEjerAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)

-----------------------------
DECLARE @DIV7h decimal(15,2)
SELECT @DIV7h = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)
If @DIV7h > 0
begin
update  @resultadoFinal7R set PorcPagAcvsVigenteAc =
(Select sum(isnull(tp.Pagado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave )
end
else if @DIV7h = 0
begin
update  @resultadoFinal7R set PorcPagAcvsVigenteAc = 0
end

---------------------------------
update  @resultadoFinal7R set NomPagAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  
),0)

---------------------------------
DECLARE @DIV7i decimal(15,2)
SELECT @DIV7i = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0) 
If @DIV7i > 0
begin
update  @resultadoFinal7R set PorcCompAcvsVigenteAn =
(Select  (sum(isnull(tp.Comprometido,0)) * 100)/ @DIV7i
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV7i = 0
begin
update  @resultadoFinal7R set PorcCompAcvsVigenteAn = 0
end

---------------------------------
update  @resultadoFinal7R set NomCompAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0) - isnull((Select  (sum(isnull(tp.Comprometido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
 ),0)


-------------------------------
DECLARE @DIV7j decimal(15,2)
SELECT @DIV7j = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0) 
If @DIV7j > 0
begin
update  @resultadoFinal7R set PorcDevAcvsVigenteAn =
(Select  (sum(isnull(tp.Devengado,0)) * 100)/ @DIV7j
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV7j = 0
begin
update  @resultadoFinal7R set PorcDevAcvsVigenteAn = 0
end

---------------------------------
update  @resultadoFinal7R set NomDevAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0) - isnull((Select  (sum(isnull(tp.Devengado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
),0)


------------------------------------
DECLARE @DIV7k decimal(15,2)
SELECT @DIV7k = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0) 
If @DIV7k > 0
begin
update  @resultadoFinal7R set PorcEjerAcvsVigenteAn =
(Select  (sum(isnull(tp.Ejercido,0)) * 100)/ @DIV7k
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV7k = 0
begin
update  @resultadoFinal7R set PorcEjerAcvsVigenteAn = 0
end

--------------------------------------
update  @resultadoFinal7R set NomEjerAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0) - isnull((Select  (sum(isnull(tp.Ejercido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)



-------------------------------------
DECLARE @DIV7l decimal(15,2)
SELECT @DIV7l = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0) 
If @DIV7l > 0
begin
update  @resultadoFinal7R set PorcPagAcvsVigenteAn =
(Select  (sum(isnull(tp.Pagado,0)) * 100)/ @DIV7l
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV7l = 0
begin
update  @resultadoFinal7R set PorcPagAcvsVigenteAn = 0
end

-------------------------------------
update  @resultadoFinal7R set NomPagAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0) - ISNULL((Select  (sum(isnull(tp.Pagado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_TipoGasto ctg
ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
INNER JOIN C_PartidasPres 
ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
INNER JOIN C_CapitulosNEP 
ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
LEFT JOIN @resultadoFinal7R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)


Select * from @resultadoFinal7R
END



If @Tipo = 17 
BEGIN
--Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento
-- Valores Relativos

DECLARE @resultadoFinal8R as table (
Clave1 varchar(8),
Descripcion varchar(150) ,
Clave2 varchar(8) ,
Descripcion2 varchar(150) ,
Clave3 varchar(8) ,
Descripcion3 varchar(150), 
Clave4 varchar(8), 
Descripcion4 varchar(150) ,
Clave5 varchar(8),
Id varchar(8),  
Descripcion5 varchar(150) ,
Clave6 varchar(8),
Descripcion6 varchar(150) ,
Autorizado decimal(15,2), 
TransferenciaAmp decimal(15,2), 
TransferenciaRed decimal(15,2), 
Modificado decimal(15,2), 
PreComprometido decimal(15,2), 
PresVigSinPreComp decimal(15,2),
Comprometido decimal(15,2), 
PreCompSinComp decimal(15,2), 
PresDispComp decimal(15,2), 
Devengado decimal(15,2), 
CompSinDev decimal(15,2),
PresSinDev decimal(15,2),
Ejercido decimal(15,2), 
DevSinEjer decimal(15,2), 
Pagado decimal(15,2), 
EjerSinPagar decimal(15,2),
Deuda decimal(15,2),
PorcAprobAnual decimal(15,2),
PorcAprobadocAnt decimal(15,2),
NomAprobado decimal(15,2),
PorcPVigenteAnual decimal(15,2),
PorcPVigenteAnt decimal(15,2),
NomPVigente decimal(15,2),
PorcCompvsVigente decimal(15,2),
NomCompvsVigente decimal(15,2),
PorcDevvsVigente decimal(15,2),
NomDevvsVigente decimal(15,2),
PorcCompAcvsVigenteAc decimal(15,2),
NomCompAcvsVigenteAc decimal(15,2),
PorcDevAcvsVigenteAc decimal(15,2),
NomDevAcvsVigenteAc decimal(15,2),
PorcEjerAcvsVigenteAc decimal(15,2),
NomEjerAcvsVigenteAc decimal(15,2),
PorcPagAcvsVigenteAc decimal(15,2),
NomPagAcvsVigenteAc decimal(15,2),
PorcCompAcvsVigenteAn decimal(15,2),
NomCompAcvsVigenteAn decimal(15,2),
PorcDevAcvsVigenteAn decimal(15,2),
NomDevAcvsVigenteAn decimal(15,2),
PorcEjerAcvsVigenteAn decimal(15,2),
NomEjerAcvsVigenteAn decimal(15,2),
PorcPagAcvsVigenteAn decimal(15,2),
NomPagAcvsVigenteAn decimal(15,2))

INSERT INTO @resultadoFinal8R (Clave1,
Descripcion ,
Clave2 ,
Descripcion2  ,
Clave3  ,
Descripcion3 , 
Clave4 , 
Descripcion4  ,
Clave5 ,
Id ,  
Descripcion5  ,
Clave6 ,
Descripcion6 ,Autorizado , TransferenciaAmp , TransferenciaRed , Modificado , PreComprometido , PresVigSinPreComp ,Comprometido , PreCompSinComp , PresDispComp , 
Devengado , CompSinDev ,PresSinDev ,Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda, PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente,PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,
PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)


Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
C_AreaResponsabilidad.Clave as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2 , 
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3,
C_ProyectosInversion.CLAVE as Clave4, C_ProyectosInversion.NOMBRE  as Descripcion4,
C_PartidasGenericasPres.IdPartidaGenerica as Clave5 ,C_EP_Ramo.Id,  C_PartidasGenericasPres.DescripcionPartida  as Descripcion5, 
C_FuenteFinanciamiento.CLAVE as Clave6, C_FuenteFinanciamiento.DESCRIPCION as Descripcion6,
 
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0) ) AS PreComprometido,
       	
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
 sum(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
 sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) - (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  ,
 0,0,0,0,0,0,0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) as NomCompvsVigente,
0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0)) as NomDevvsVigente,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 
 
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal
ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad 
ON (C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo 
ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto    

	
where  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= @Clave and C_RamoPresupuestal.CLAVE <= @Clave2) and C_AreaResponsabilidad.Clave = @ClaveUR AND C_EP_Ramo.Id =@IdEP
	
group by C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida , C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre, C_RamoPresupuestal.CLAVE , C_RamoPresupuestal.DESCRIPCION ,  C_EP_Ramo.Clave, C_EP_Ramo.Nombre, C_EP_Ramo.Id, C_FuenteFinanciamiento.CLAVE, C_FuenteFinanciamiento.DESCRIPCION ,C_ProyectosInversion.nombre, C_ProyectosInversion.CLAVE  
Order By C_AreaResponsabilidad.Clave ,C_PartidasGenericasPres.IdPartidaGenerica , C_RamoPresupuestal.CLAVE 


--Columna 1
DECLARE @DIV8Ra decimal(15,2)
SELECT @DIV8Ra =isnull((Select  sum(isnull(TP.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ) ,0) 


If  @DIV8Ra > 0
begin
update  @resultadoFinal8R set PorcAprobAnual =
(Select  (sum(isnull(tp.Autorizado,0)) * 100)/ @DIV8Ra
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave
)/100
end
else if @DIV8Ra = 0
begin
update  @resultadoFinal8R set PorcAprobAnual = 0
end

--Columna 2
DECLARE @DIV8Rc decimal(15,2)
SELECT @DIV8Rc =isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)  

If @DIV8Rc > 0
begin
update  @resultadoFinal8R set PorcAprobadocAnt =
ISNULL((Select (sum(isnull(tp.Autorizado,0)) * 100)/@DIV8Rc
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100,0)
end
else if @DIV8Rc =0
begin
update  @resultadoFinal8R set PorcAprobadocAnt = 0
end

--Columna 3 y 4
update  @resultadoFinal8R set NomAprobado =
ISNULL((Select  (sum(isnull(tp.Autorizado,0)))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
),0) - isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave),0)


--Columna 5
DECLARE @DIV8Rb decimal(15,2)
SELECT @DIV8Rb =isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ) ,0)


If @DIV8Rb > 0
begin
update  @resultadoFinal8R set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV8Rb
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV8Rb = 0
begin
update  @resultadoFinal8R set PorcPVigenteAnual = 0
end

--Columna 6
DECLARE @DIV8Rd decimal(15,2)
SELECT @DIV8Rd =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave),0)

If @DIV8Rd > 0
begin
update  @resultadoFinal8R set PorcPVigenteAnt =
ISNULL((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV8Rd
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave
)/100,0)
end
else if @DIV8Rd = 0
begin
update  @resultadoFinal8R set PorcPVigenteAnt = 0
end

--Columna 7 y 8
update  @resultadoFinal8R set NomPVigente =
ISNULL((Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
),0) - ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)

-----------------------------
DECLARE @DIV8m decimal(15,2)
SELECT @DIV8m = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
) ,0)
If @DIV8m > 0
begin
update  @resultadoFinal8R set PorcCompvsVigente =
(Select sum(isnull(TP.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if  @DIV8m = 0
begin
update  @resultadoFinal8R set PorcCompvsVigente = 0
end

------------------
DECLARE @DIV8n decimal(15,2)
SELECT @DIV8n = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
) ,0)
If @DIV8n > 0
begin
update  @resultadoFinal8R set PorcDevvsVigente =
(Select sum(isnull(TP.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if  @DIV8n = 0
begin
update  @resultadoFinal8R set PorcDevvsVigente = 0
end


-------------------------------------------
DECLARE @DIV8e decimal(15,2)
SELECT @DIV8e =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
),0)
If @DIV8e > 0
begin
update  @resultadoFinal8R set PorcCompAcvsVigenteAc =
(Select sum(isnull(tp.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100 
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)
end
else if @DIV8e = 0
begin
update  @resultadoFinal8R set PorcCompAcvsVigenteAc = 0
end

-----------------------------
update  @resultadoFinal8R set NomCompAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
),0)

------------------------------------------
DECLARE @DIV8f decimal(15,2)
SELECT @DIV8f =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)
If @DIV8f > 0
begin
update  @resultadoFinal8R set PorcDevAcvsVigenteAc =
(Select sum(isnull(tp.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave )
end 
else if @DIV8f = 0
begin
update  @resultadoFinal8R set PorcDevAcvsVigenteAc = 0
end

--------------------------
update  @resultadoFinal8R set NomDevAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)

--------------------------------
DECLARE @DIV8g decimal(15,2)
SELECT @DIV8g =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)
If @DIV8g > 0
begin
update  @resultadoFinal8R set PorcEjerAcvsVigenteAc =
(Select sum(isnull(tp.Ejercido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave )
end
else if @DIV8g = 0
begin
update  @resultadoFinal8R set PorcEjerAcvsVigenteAc = 0
end

---------------------------------
update  @resultadoFinal8R set NomEjerAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0)

-------------------------------------
DECLARE @DIV8h decimal(15,2)
SELECT @DIV8h =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)
If @DIV8h > 0
begin
update  @resultadoFinal8R set PorcPagAcvsVigenteAc =
(Select sum(isnull(tp.Pagado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave )
end 
else if @DIV8h = 0
begin
update  @resultadoFinal8R set PorcPagAcvsVigenteAc = 0
end

--------------------------------
update  @resultadoFinal8R set NomPagAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
),0)

---------------------------------------
DECLARE @DIV8i decimal(15,2)
SELECT @DIV8i =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave   ) ,0)
If @DIV8i > 0
begin
update  @resultadoFinal8R set PorcCompAcvsVigenteAn =
(Select  (sum(isnull(tp.Comprometido,0)) * 100)/ @DIV8i
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV8i = 0
begin
update  @resultadoFinal8R set PorcCompAcvsVigenteAn = 0
end

---------------------------------------
update  @resultadoFinal8R set NomCompAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0) - isnull((Select  (sum(isnull(tp.Comprometido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
 ),0)


------------------------------------
DECLARE @DIV8j decimal(15,2)
SELECT @DIV8j =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0) 
If @DIV8j > 0
begin
update  @resultadoFinal8R set PorcDevAcvsVigenteAn =
(Select  (sum(isnull(tp.Devengado,0)) * 100)/ @DIV8j
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV8j = 0
begin
update  @resultadoFinal8R set PorcDevAcvsVigenteAn = 0
end

-------------------------------------
update  @resultadoFinal8R set NomDevAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0) - isnull((Select  (sum(isnull(tp.Devengado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
),0)


----------------------------------
DECLARE @DIV8k decimal(15,2)
SELECT @DIV8k = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0)
If @DIV8k > 0
begin
update  @resultadoFinal8R set PorcEjerAcvsVigenteAn =
(Select  (sum(isnull(tp.Ejercido,0)) * 100)/ @DIV8k
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV8k = 0
begin
update  @resultadoFinal8R set PorcEjerAcvsVigenteAn = 0
end

-----------------------------------
update  @resultadoFinal8R set NomEjerAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0) - isnull((Select  (sum(isnull(tp.Ejercido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)


------------------------------------
DECLARE @DIV8l decimal(15,2)
SELECT @DIV8l = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ) ,0)
If @DIV8l > 0
begin
update  @resultadoFinal8R set PorcPagAcvsVigenteAn =
(Select  (sum(isnull(tp.Pagado,0)) * 100)/ @DIV8l
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV8l = 0
begin
update  @resultadoFinal8R set PorcPagAcvsVigenteAn = 0
end

-------------------------------------
update  @resultadoFinal8R set NomPagAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0) - ISNULL((Select  (sum(isnull(tp.Pagado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres cpg
ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad CA
ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
INNER JOIN C_FuenteFinanciamiento  cff
ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
LEFT JOIN @resultadoFinal8R
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)

Select * from @resultadoFinal8R
END




If @Tipo = 18
BEGIN
--Ramo o Dependencia / Distribución Geográfica / Programas y Proyectos de Inversión
-- Valores Relativos

DECLARE @resultadoFinal9R as table (
Clave1 varchar(8),
Descripcion varchar(150) ,
Clave2 varchar(8) ,
Descripcion2 varchar(150) ,
Clave3 varchar(8) ,
Id varchar(8), 
Descripcion3 varchar(150), 
Clave4 varchar(8), 
Descripcion4 varchar(150) ,
Autorizado decimal(15,2), 
TransferenciaAmp decimal(15,2), 
TransferenciaRed decimal(15,2), 
Modificado decimal(15,2), 
PreComprometido decimal(15,2), 
PresVigSinPreComp decimal(15,2),
Comprometido decimal(15,2), 
PreCompSinComp decimal(15,2), 
PresDispComp decimal(15,2), 
Devengado decimal(15,2), 
CompSinDev decimal(15,2),
PresSinDev decimal(15,2),
Ejercido decimal(15,2), 
DevSinEjer decimal(15,2), 
Pagado decimal(15,2), 
EjerSinPagar decimal(15,2),
Deuda decimal(15,2),
PorcAprobAnual decimal(15,2),
PorcAprobadocAnt decimal(15,2),
NomAprobado decimal(15,2),
PorcPVigenteAnual decimal(15,2),
PorcPVigenteAnt decimal(15,2),
NomPVigente decimal(15,2),
PorcCompvsVigente decimal(15,2),
NomCompvsVigente decimal(15,2),
PorcDevvsVigente decimal(15,2),
NomDevvsVigente decimal(15,2),
PorcCompAcvsVigenteAc decimal(15,2),
NomCompAcvsVigenteAc decimal(15,2),
PorcDevAcvsVigenteAc decimal(15,2),
NomDevAcvsVigenteAc decimal(15,2),
PorcEjerAcvsVigenteAc decimal(15,2),
NomEjerAcvsVigenteAc decimal(15,2),
PorcPagAcvsVigenteAc decimal(15,2),
NomPagAcvsVigenteAc decimal(15,2),
PorcCompAcvsVigenteAn decimal(15,2),
NomCompAcvsVigenteAn decimal(15,2),
PorcDevAcvsVigenteAn decimal(15,2),
NomDevAcvsVigenteAn decimal(15,2),
PorcEjerAcvsVigenteAn decimal(15,2),
NomEjerAcvsVigenteAn decimal(15,2),
PorcPagAcvsVigenteAn decimal(15,2),
NomPagAcvsVigenteAn decimal(15,2))

INSERT INTO @resultadoFinal9R (Clave1,
Descripcion ,
Clave2 ,
Descripcion2  ,
Clave3  ,
Id ,  
Descripcion3 , 
Clave4 , 
Descripcion4  ,Autorizado , TransferenciaAmp , 
TransferenciaRed , Modificado , PreComprometido , PresVigSinPreComp ,Comprometido , PreCompSinComp , PresDispComp , Devengado , CompSinDev ,PresSinDev ,Ejercido , 
DevSinEjer , Pagado , EjerSinPagar ,Deuda,PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente,PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,
PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)


Select C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION as Descripcion, 
C_ClasificadorGeograficoPresupuestal.Clave  as Clave2, C_ClasificadorGeograficoPresupuestal.Descripcion as Descripcion2,
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Id, C_EP_Ramo.Nombre as Descripcion3, 
C_ProyectosInversion.CLAVE  as Clave4, C_ProyectosInversion.NOMBRE as Descripcion4,

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0) ) AS PreComprometido,
       	
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
 sum(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
 sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) - (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  ,
 0,0,0,0,0,0,0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) as NomCompvsVigente,
0,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0)) as NomDevvsVigente,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal
ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo 
ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion 
ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal  
ON C_ClasificadorGeograficoPresupuestal.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  

where  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= @Clave and C_RamoPresupuestal.CLAVE <= @Clave2) AND C_EP_Ramo.Id =@IdEP

group by C_ClasificadorGeograficoPresupuestal.Clave,C_ClasificadorGeograficoPresupuestal.Descripcion, C_RamoPresupuestal.CLAVE, C_RamoPresupuestal.DESCRIPCION ,C_EP_Ramo.Clave , C_EP_Ramo.Nombre, C_EP_Ramo.Id ,T_SellosPresupuestales.IdProyecto, C_ProyectosInversion.CLAVE ,C_ProyectosInversion.nombre 
Order By C_ClasificadorGeograficoPresupuestal.Clave


--Columna 1
DECLARE @DIV9Ra decimal(15,2)
SELECT @DIV9Ra = isnull((Select  sum(isnull(TP.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cpi.clave),0)   

If @DIV9Ra > 0
begin
update  @resultadoFinal9R set PorcAprobAnual =
(Select  (sum(isnull(tp.Autorizado,0)) * 100)/ @DIV9Ra

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave ,cpi.clave)/100
end
else if @DIV9Ra = 0
begin
update  @resultadoFinal9R set PorcAprobAnual = 0
end

--Columna 2
DECLARE @DIV9Rc decimal(15,2)
SELECT @DIV9Rc =isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0)    
If @DIV9Rc > 0
begin
update  @resultadoFinal9R set PorcAprobadocAnt =
ISNULL((Select  (sum(isnull(tp.Autorizado,0)) * 100)/@DIV9Rc

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave)/100,0)
end
else if @DIV9Rc = 0
begin
update  @resultadoFinal9R set PorcAprobadocAnt = 0
end

--Columna 3 y 4
update  @resultadoFinal9R set NomAprobado =
ISNULL((Select  (sum(isnull(tp.Autorizado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE,  cepr.Clave , cpi.clave),0) - isnull((Select  sum(isnull(tp.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE,  cepr.Clave , cpi.clave),0) 

--Columna 5
DECLARE @DIV9Rb decimal(15,2)
SELECT @DIV9Rb = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE,  cepr.Clave , cpi.clave),0)

If @DIV9Rb > 0
begin
update  @resultadoFinal9R set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV9Rb
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE,  cepr.Clave , cpi.clave)/100
end
else if @DIV9Rb = 0
begin
update  @resultadoFinal9R set PorcPVigenteAnual = 0
end



--Columna 6
DECLARE @DIV9Rd decimal(15,2)
SELECT @DIV9Rd =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE,  cepr.Clave , cpi.clave ) ,0)

If @DIV9Rd < 0
begin
update  @resultadoFinal9R set PorcPVigenteAnt =
ISNULL((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV9Rd
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave)/100,0)
end
else if @DIV9Rd = 0
begin
update  @resultadoFinal9R set PorcPVigenteAnt = 0
end


--Columna 7 y 8
update  @resultadoFinal9R set NomPVigente =
ISNULL((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0) - ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE,  cepr.Clave , cpi.clave),0)



-----------------------------
DECLARE @DIV9m decimal(15,2)
SELECT @DIV9m =ISNULL( (Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
),0) 
If @DIV9m > 0
begin
update  @resultadoFinal9R set PorcCompvsVigente =
(Select sum(isnull(TP.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)/100
end
else if  @DIV9m = 0
begin
update  @resultadoFinal9R set PorcCompvsVigente = 0
end

------------------
DECLARE @DIV9n decimal(15,2)
SELECT @DIV9n = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
) ,0)
If @DIV9n > 0
begin
update  @resultadoFinal9R set PorcDevvsVigente =
(Select sum(isnull(TP.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)/100
end
else if  @DIV9n = 0
begin
update  @resultadoFinal9R set PorcDevvsVigente = 0
end


------------------------------------------
DECLARE @DIV9e decimal(15,2)
SELECT @DIV9e =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100 as PorcCompAcvsVigenteAc
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
),0)
If @DIV9e > 0
begin
update  @resultadoFinal9R set PorcCompAcvsVigenteAc =
(Select sum(isnull(tp.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100 
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)
end
else if @DIV9e = 0
begin
update  @resultadoFinal9R set PorcCompAcvsVigenteAc = 0
end

--------------------
update  @resultadoFinal9R set NomCompAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
),0)

--------------------------
DECLARE @DIV9f decimal(15,2)
SELECT @DIV9f =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0)
If @DIV9f > 0
begin
update  @resultadoFinal9R set PorcDevAcvsVigenteAc =
(Select sum(isnull(tp.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave)
end
else if @DIV9f = 0
begin
update  @resultadoFinal9R set PorcDevAcvsVigenteAc = 0
end

-----------------------------
update  @resultadoFinal9R set NomDevAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0)

------------------------------
DECLARE @DIV9g decimal(15,2)
SELECT @DIV9g =ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0)
If @DIV9g > 0
begin
update  @resultadoFinal9R set PorcEjerAcvsVigenteAc =
(Select sum(isnull(tp.Ejercido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave)
end
else if @DIV9g = 0
begin
update  @resultadoFinal9R set PorcEjerAcvsVigenteAc = 0
end

-----------------------------------
update  @resultadoFinal9R set NomEjerAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave ),0)

----------------------
DECLARE @DIV9h decimal(15,2)
SELECT @DIV9h = ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0)
If @DIV9h > 0
begin
update  @resultadoFinal9R set PorcPagAcvsVigenteAc =
(Select sum(isnull(tp.Pagado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave)
end
else if @DIV9h = 0
begin
update  @resultadoFinal9R set PorcPagAcvsVigenteAc = 0
end

---------------------------------
update  @resultadoFinal9R set NomPagAcvsVigenteAc =
ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
),0)

---------------------------------
DECLARE @DIV9i decimal(15,2)
SELECT @DIV9i = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave  ),0) 
If @DIV9i > 0
begin
update  @resultadoFinal9R set PorcCompAcvsVigenteAn =
(Select  (sum(isnull(tp.Comprometido,0)) * 100)/ @DIV9i
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)/100
end
else if @DIV9i = 0
begin
update  @resultadoFinal9R set PorcCompAcvsVigenteAn = 0
end

------------------------------------
update  @resultadoFinal9R set NomCompAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave ),0) - isnull((Select  (sum(isnull(tp.Comprometido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
 ),0)


--------------------------------------
DECLARE @DIV9j decimal(15,2)
SELECT @DIV9j = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave ),0)
If @DIV9j > 0
begin
update  @resultadoFinal9R set PorcDevAcvsVigenteAn =
(Select  (sum(isnull(tp.Devengado,0)) * 100)/ @DIV9j
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)/100
end
else if @DIV9j = 0
begin
update  @resultadoFinal9R set PorcDevAcvsVigenteAn = 0
end

--------------------------------
update  @resultadoFinal9R set NomDevAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave ),0) - ISNULL((Select  (sum(isnull(tp.Devengado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
),0)


----------------------------------------
DECLARE @DIV9k decimal(15,2)
SELECT @DIV9k = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave ),0) 
If @DIV9k > 0
begin
update  @resultadoFinal9R set PorcEjerAcvsVigenteAn =
(Select  (sum(isnull(tp.Ejercido,0)) * 100)/ @DIV9k
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)/100
end
else if @DIV9k = 0
begin
update  @resultadoFinal9R set PorcEjerAcvsVigenteAn = 0
end

------------------------------
update  @resultadoFinal9R set NomEjerAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave ),0) - ISNULL((Select  (sum(isnull(tp.Ejercido,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0)


-----------------------------------------
DECLARE @DIV9l decimal(15,2)
SELECT @DIV9l =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0) 
If @DIV9l > 0
begin
update  @resultadoFinal9R set PorcPagAcvsVigenteAn =
(Select  (sum(isnull(tp.Pagado,0)) * 100)/ @DIV9l
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)/100
end
else if @DIV9l = 0
begin
update  @resultadoFinal9R set PorcPagAcvsVigenteAn = 0
end

-------------------------------------
update  @resultadoFinal9R set NomPagAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0) - ISNULL((Select  (sum(isnull(tp.Pagado,0)))

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal  CR
ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_EP_Ramo cepr
ON cepr.Id    = T_SellosPresupuestales.IdProyecto 
INNER JOIN C_ProyectosInversion cpi
ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
left JOIN C_PartidasPres  
ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
left JOIN C_ClasificadorGeograficoPresupuestal cgp 
ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
LEFT JOIN @resultadoFinal9R
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0)



Select * from @resultadoFinal9R
END


END


GO



