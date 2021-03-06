/****** Object:  StoredProcedure [dbo].[SP_RPT_InfProgramComparativosEstadoEjercicioPresupuestoEGR]    Script Date: 01/22/2013 11:06:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_InfProgramComparativosEstadoEjercicioPresupuestoEGR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_InfProgramComparativosEstadoEjercicioPresupuestoEGR]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_InfProgramComparativosEstadoEjercicioPresupuestoEGR]    Script Date: 01/22/2013 11:06:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_RPT_InfProgramComparativosEstadoEjercicioPresupuestoEGR] 


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
--//////*************************************VALORES ABSOLUTOS**************************/////////////////////

If @Tipo = 1 
BEGIN

-- Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional
-- Valores Absolutos

DECLARE @resultadoFinal as table (Clave1 varchar(8),
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
-- Valores Absolutos
DECLARE @nombreAI varchar(255)
DECLARE @ClaveAI varchar(255)


SET @nombreAI = (SELECT  tablaID.nombre 
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @ClaveAI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id


INSERT INTO @resultadoFinal (Clave1 ,Descripcion ,Clave2 ,Descripcion2 ,Clave3 ,Id , Descripcion3 , Clave4 , NombreAI , Autorizado , TransferenciaAmp , 
TransferenciaRed , Modificado , PreComprometido , PresVigSinPreComp ,Comprometido , PreCompSinComp , PresDispComp , Devengado , CompSinDev ,PresSinDev ,
Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda, PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente,PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,
PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)

Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion,
C_Funciones.Clave as Clave2,  C_Funciones.Nombre as Descripcion2, 
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Id, C_EP_Ramo.Nombre as Descripcion3,  @ClaveAI as Clave4, @nombreAI as NombreAI,
 
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0)) AS PreComprometido,
      
 (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0)) as Comprometido, 
 sum(isnull(TP.Precomprometido,0))- sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
 sum(isnull(TP.Devengado,0)) as Devengado, 
 sum(isnull(TP.Comprometido,0)) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) as Ejercido,
 sum(isnull(TP.Devengado,0))- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
 sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
 sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda,
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
DECLARE @DIV decimal(15,2)
SELECT @DIV = isnull((Select  sum(isnull(TP.Autorizado,0))

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
LEFT JOIN @resultadoFinal
ON Clave1 = C_RamoPresupuestal.CLAVE and Clave2 = C_Funciones.Clave 

where  Mes = 0 AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= @Clave and C_RamoPresupuestal.CLAVE <= @Clave2) AND C_EP_Ramo.Id =@IdEP
GROUP BY  C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id ),0)

IF @DIV > 0 
begin
update  @resultadoFinal set PorcAprobAnual =
((Select  (sum(isnull(tp.Autorizado,0)))* 100/ @DIV

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
LEFT JOIN @resultadoFinal
ON Clave1 = C_RamoPresupuestal.CLAVE and Clave2 = C_Funciones.Clave 

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= @Clave and C_RamoPresupuestal.CLAVE <= @Clave2) AND C_EP_Ramo.Id =@IdEP
GROUP BY   C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id)
)/100
end
else if @DIV = 0 
begin
update  @resultadoFinal set PorcAprobAnual = 0
end


--Columna 19
DECLARE @DIV2 decimal(15,2)
SELECT @DIV2 =isnull((Select  sum(isnull(tp.Autorizado,0))

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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY   cr.CLAVE, cepr.Id ) ,0)

If @DIV2 <> 0
begin

update  @resultadoFinal set PorcAprobadocAnt =
(isnull((Select sum(isnull(tp.Autorizado,0))* 100/@DIV2

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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY   cr.CLAVE, cepr.Id),0))/100
end
else if @DIV2 = 0
begin
update  @resultadoFinal set PorcAprobadocAnt =0
end

--Columna 20 y 21
update  @resultadoFinal set NomAprobado =
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
GROUP BY   cr.CLAVE, cepr.Id ),0) 


--Columna 22
DECLARE @DIV3 decimal(15,2)
SELECT @DIV3 =ISNULL( (Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
GROUP BY   cr.CLAVE, cepr.Id),0)

If @DIV3 > 0
begin

update  @resultadoFinal set PorcPVigenteAnual =
(Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV3

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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
GROUP BY   cr.CLAVE, cepr.Id)/100
end
else if @DIV3 = 0
begin
update  @resultadoFinal set PorcPVigenteAnual = 0
end

--Columna 23
DECLARE @DIV4 decimal(15,2)
SELECT @DIV4 =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY   cr.CLAVE, cepr.Id) ,0)


If @DIV4 <> 0
begin
update  @resultadoFinal set PorcPVigenteAnt =
isnull((Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV4

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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
GROUP BY   cr.CLAVE, cepr.Id)/100,0)
end
else if @DIV4 = 0 
begin
update  @resultadoFinal set PorcPVigenteAnt =0
end


--Columna 24 y 25
update  @resultadoFinal set NomPVigente =
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)
If @DIV1m > 0
begin
update  @resultadoFinal set PorcCompvsVigente =
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if  @DIV1m = 0
begin
update  @resultadoFinal set PorcCompvsVigente = 0
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)
If @DIV1n > 0
begin
update  @resultadoFinal set PorcDevvsVigente =
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if  @DIV1n = 0
begin
update  @resultadoFinal set PorcDevvsVigente = 0
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)

If @DIV1a > 0
begin
update  @resultadoFinal set PorcCompAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end 
else if @DIV1a = 0
begin
update  @resultadoFinal set PorcCompAcvsVigenteAc = 0
end

-----------------------
update  @resultadoFinal set NomCompAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
),0)
If @DIV1b > 0
begin
update  @resultadoFinal set PorcDevAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if @DIV1b = 0
begin
update  @resultadoFinal set PorcDevAcvsVigenteAc = 0
end

--------------------------------------
update  @resultadoFinal set NomDevAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
),0)
If @DIV1c > 0
begin
update  @resultadoFinal set PorcEjerAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if @DIV1c = 0
begin
update  @resultadoFinal set PorcEjerAcvsVigenteAc = 0
end

-----------------------------
update  @resultadoFinal set NomEjerAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY cr.CLAVE, cepr.Id
),0)
If @DIV1d > 0
begin
update  @resultadoFinal set PorcPagAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY cr.CLAVE, cepr.Id
)/100
end
else if @DIV1d = 0
begin
update  @resultadoFinal set PorcPagAcvsVigenteAc = 0
end

--------------
update  @resultadoFinal set NomPagAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)
If @DIV1e > 0
begin
update  @resultadoFinal set PorcCompAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if @DIV1e = 0
begin
update  @resultadoFinal set PorcCompAcvsVigenteAn = 0
end

------------
update  @resultadoFinal set NomCompAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)
If @DIV1f > 0
begin
update  @resultadoFinal set PorcDevAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if @DIV1f = 0
begin
update  @resultadoFinal set PorcDevAcvsVigenteAn = 0
end

--------------
update  @resultadoFinal set NomDevAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)
If @DIV1g > 0
begin
update  @resultadoFinal set PorcEjerAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if @DIV1g = 0
begin
update  @resultadoFinal set PorcEjerAcvsVigenteAn = 0
end

----------------
update  @resultadoFinal set NomEjerAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
) ,0)
If @DIV1h > 0
begin
update  @resultadoFinal set PorcPagAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)/100
end
else if @DIV1h = 0
begin
update  @resultadoFinal set PorcPagAcvsVigenteAn = 0
end

---------------------------
update  @resultadoFinal set NomPagAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal
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
LEFT JOIN @resultadoFinal
ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
GROUP BY  cr.CLAVE, cepr.Id
)
),0)

Select * from @resultadoFinal
end




If @Tipo = 2 
BEGIN
-- Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo
-- Valores Absolutos

DECLARE @resultadoFinal2 as table (
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


DECLARE @nombre0AI varchar(255)
DECLARE @clave0AI varchar(255)

SET @nombre0AI = (SELECT  tablaID.nombre 
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @clave0AI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id



INSERT INTO @resultadoFinal2 (Clave1 ,
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
PresSinDev ,Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda, PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente, PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,
PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)

Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
C_AreaResponsabilidad.Clave  as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2,
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3, 
@clave0AI as Clave3a, C_CapitulosNEP.Descripcion as Descripcion3a,
C_CapitulosNEP.IdCapitulo as Clave4, C_EP_Ramo.Id, 
C_ConceptosNEP.Descripcion as Descripcion4,  C_ConceptosNEP.IdConcepto  as Clave5, @nombre0AI as NombreAI,

 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0)) AS PreComprometido,
      
 (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0)) as Comprometido, 
 sum(isnull(TP.Precomprometido,0))- sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
 sum(isnull(TP.Devengado,0)) as Devengado, 
 sum(isnull(TP.Comprometido,0)) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) as Ejercido,
 sum(isnull(TP.Devengado,0))- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
 sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
 sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda,
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
DECLARE @DIV2b decimal(15,2)
SELECT @DIV2b = isnull((Select  sum(isnull(TP.Autorizado,0))
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ),0) 

IF @DIV2b > 0 
begin

update  @resultadoFinal2 set PorcAprobAnual =
(Select (sum(isnull(tp.Autorizado,0))) * 100/ @DIV2b
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)/100
end
else if @DIV2b = 0 
begin
update  @resultadoFinal2 set PorcAprobAnual = 0
end


--Columna 19
DECLARE @DIV2d decimal(15,2)
SELECT @DIV2d =isnull((Select  sum(isnull(tp.Autorizado,0))
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)   
If @DIV2d > 0
begin
update  @resultadoFinal2 set PorcAprobadocAnt =
isnull((Select (sum(isnull(tp.Autorizado,0)))* 100 /@DIV2d
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0) 
end 
else if @DIV2d = 0
begin
update  @resultadoFinal2 set PorcAprobadocAnt = 0
end

--Columna 20 y 21
update  @resultadoFinal2 set NomAprobado =
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
left join @resultadoFinal2
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ),0)


--Columna 22
DECLARE @DIV2c decimal(15,2)
SELECT @DIV2c = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)


If @DIV2c > 0
begin
update  @resultadoFinal2 set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV2c

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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )/100
end 
else if @DIV2c = 0
begin
update  @resultadoFinal2 set PorcPVigenteAnual = 0
end



--Columna 23
DECLARE @DIV2e decimal(15,2)
SELECT @DIV2e =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)

If @DIV2e > 0
begin
update  @resultadoFinal2 set PorcPVigenteAnt =
ISNULL((Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV2e
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)/100,0)
end
else if @DIV2e = 0
begin
update  @resultadoFinal2 set PorcPVigenteAnt = 0
end



--Columna 24 y 25
update  @resultadoFinal2 set NomPVigente =
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
left join @resultadoFinal2
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)  



------------
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave,cepr.Id
) ,0)
If @DIV2m > 0
begin
update  @resultadoFinal2 set PorcCompvsVigente =
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave,cepr.Id
)/100
end
else if  @DIV2m = 0
begin
update  @resultadoFinal2 set PorcCompvsVigente = 0
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN @Mes and @Mes2 )  AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave,cepr.Id
) ,0)
If @DIV2n > 0
begin
update  @resultadoFinal2 set PorcDevvsVigente =
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN @Mes and @Mes2 ) AND  LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave,cepr.Id
)/100
end
else if  @DIV2n = 0
begin
update  @resultadoFinal2 set PorcDevvsVigente = 0
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave,cepr.Id
),0)
If @DIV2a > 0
begin
update  @resultadoFinal2 set PorcCompAcvsVigenteAc =
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave,cepr.Id
)
end
else if @DIV2a = 0
begin
update  @resultadoFinal2 set PorcCompAcvsVigenteAc = 0
end

----------------
update  @resultadoFinal2 set NomCompAcvsVigenteAc =
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
left join @resultadoFinal2
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)
if @DIV2f > 0
begin
update  @resultadoFinal2 set PorcDevAcvsVigenteAc =
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )
end
else if @DIV2f = 0
begin
update  @resultadoFinal2 set PorcDevAcvsVigenteAc = 0
end

-------------------------
update  @resultadoFinal2 set NomDevAcvsVigenteAc =
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
left join @resultadoFinal2
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ),0)
If @DIV2g > 0
begin
update  @resultadoFinal2 set PorcEjerAcvsVigenteAc =
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )
end
else if @DIV2g = 0
begin
update  @resultadoFinal2 set PorcEjerAcvsVigenteAc =  0
end

-----------------
update  @resultadoFinal2 set NomEjerAcvsVigenteAc =
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
left join @resultadoFinal2
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ),0)
If @DIV2h > 0
begin
update  @resultadoFinal2 set PorcPagAcvsVigenteAc =
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )
end
else if @DIV2h = 0
begin
update  @resultadoFinal2 set PorcPagAcvsVigenteAc = 0
end

----------------------
update  @resultadoFinal2 set NomPagAcvsVigenteAc =
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave 
),0)

--------------------------
DECLARE @DIV2i decimal(15,2)
SELECT @DIV2i =ISNULL( (Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave   ),0) 
If @DIV2i > 0
begin
update  @resultadoFinal2 set PorcCompAcvsVigenteAn =
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave 
)/100
end
else if @DIV2i = 0
begin
update  @resultadoFinal2 set PorcCompAcvsVigenteAn = 0
end

-------------------------------
update  @resultadoFinal2 set NomCompAcvsVigenteAn =
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
left join @resultadoFinal2
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
left join @resultadoFinal2
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0) 
If @DIV2j > 0
begin
update  @resultadoFinal2 set PorcDevAcvsVigenteAn =
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV2j = 0
begin
update  @resultadoFinal2 set PorcDevAcvsVigenteAn = 0
end

-------------------------------
update  @resultadoFinal2 set NomDevAcvsVigenteAn =
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
left join @resultadoFinal2
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)
),0)

----------------------------------
DECLARE @DIV2k decimal(15,2)
SELECT @DIV2k =ISNULL( (Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)
If @DIV2k > 0
begin
update  @resultadoFinal2 set PorcEjerAcvsVigenteAn =
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave 
)/100
end
else if @DIV2k = 0
begin
update  @resultadoFinal2 set PorcEjerAcvsVigenteAn = 0
end

----------------------------------
update  @resultadoFinal2 set NomEjerAcvsVigenteAn =
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
left join @resultadoFinal2
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
left join @resultadoFinal2
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave) ,0)
If @DIV2l > 0
begin
update  @resultadoFinal2 set PorcPagAcvsVigenteAn =
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave 
)/100
end
else if @DIV2l = 0
begin
update  @resultadoFinal2 set PorcPagAcvsVigenteAn = 0
end

------------------------------------
update  @resultadoFinal2 set NomPagAcvsVigenteAn =
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
left join @resultadoFinal2
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
left join @resultadoFinal2
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)


Select * from @resultadoFinal2
END



If @Tipo = 3 
BEGIN
--Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica
--Valores Absolutos

DECLARE @resultadoFinal3 as table (
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

DECLARE @nombre1AI varchar(255)
DECLARE @clave1AI varchar(255)

SET @nombre1AI = (SELECT  tablaID.nombre 
FROM
(select * from C_EP_Ramo where id= @IdEP  and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @clave1AI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id


INSERT INTO @resultadoFinal3 (Clave1 ,
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
Devengado , CompSinDev ,PresSinDev ,Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda,PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente,PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,
PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)

Select   C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion,
C_EP_Ramo.Clave AS Clave2, C_EP_Ramo.Nombre as Descripcion2,
@clave1AI as Clave3, @nombre1AI as NombreAI, 
C_CapitulosNEP.IdCapitulo as Clave3a, C_CapitulosNEP.Descripcion as Descripcion3a, 
C_ConceptosNEP.IdConcepto  as Clave4,  C_ConceptosNEP.Descripcion as Descripcion4, 
C_EP_Ramo.Id, 
C_TipoGasto.Clave as Clave5, C_TipoGasto.NOMBRE as Descripcion3, 
  
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0)) AS PreComprometido,
      
 (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0)) as Comprometido, 
 sum(isnull(TP.Precomprometido,0))- sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
 sum(isnull(TP.Devengado,0)) as Devengado, 
 sum(isnull(TP.Comprometido,0)) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) as Ejercido,
 sum(isnull(TP.Devengado,0))- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
 sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
 sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda,
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
DECLARE @DIV3a decimal(15,2)
SELECT @DIV3a = isnull((Select  sum(isnull(TP.Autorizado,0))
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
left join @resultadoFinal3
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE, cepr.Id) ,0)

If @DIV3a > 0
begin
update  @resultadoFinal3 set PorcAprobAnual =
(Select  (sum(isnull(tp.Autorizado,0)) * 100)/ @DIV3a

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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE, cepr.Id )/100
end
else if @DIV3a = 0
begin
update  @resultadoFinal3 set PorcAprobAnual = 0
end

--Columna 2
DECLARE @DIV3c decimal(15,2)
SELECT @DIV3c = isnull((Select  sum(isnull(tp.Autorizado,0))
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id )  ,0)
If @DIV3c > 0
begin
update  @resultadoFinal3 set PorcAprobadocAnt =
isnull((Select (sum(isnull(tp.Autorizado,0)) * 100)/@DIV3c
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id )/100,0)
end
else if @DIV3c = 0
begin
update  @resultadoFinal3 set PorcAprobadocAnt = 0
end


--Columna 3 y 4
update  @resultadoFinal3 set NomAprobado =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0)



--Columna 5
DECLARE @DIV3b decimal(15,2)
SELECT @DIV3b = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0)

If @DIV3b > 0
begin
update  @resultadoFinal3 set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV3b

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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE,  cepr.Id )/100
end
else if @DIV3b = 0
begin
update  @resultadoFinal3 set PorcPVigenteAnual = 0
end

--Columna 6
DECLARE @DIV3d decimal(15,2)
SELECT @DIV3d =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Id ) ,0)
If @DIV3d > 0
begin
update  @resultadoFinal3 set PorcPVigenteAnt =
isnull((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV3d

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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id )/100,0)
end
else if @DIV3d = 0
begin
update  @resultadoFinal3 set PorcPVigenteAnt = 0
end

--Columna 7 y 8
update  @resultadoFinal3 set NomPVigente =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE, cepr.Id ),0)

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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
) ,0)
If @DIV3m > 0
begin
update  @resultadoFinal3 set PorcCompvsVigente =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
)/100
end
else if  @DIV3m = 0
begin
update  @resultadoFinal3 set PorcCompvsVigente = 0
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
) ,0)
If @DIV3n > 0
begin
update  @resultadoFinal3 set PorcDevvsVigente =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
)/100
end
else if  @DIV3n = 0
begin
update  @resultadoFinal3 set PorcDevvsVigente = 0
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
),0)
If @DIV3e > 0
begin
update  @resultadoFinal3 set PorcCompAcvsVigenteAc =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
)/100
end
else if @DIV3e = 0
begin
update  @resultadoFinal3 set PorcCompAcvsVigenteAc = 0
end

----------------------------------
update  @resultadoFinal3 set NomCompAcvsVigenteAc =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0)
If @DIV3f > 0
begin
update  @resultadoFinal3 set PorcDevAcvsVigenteAc =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id  )/100
end
else if @DIV3f  = 0
begin
update  @resultadoFinal3 set PorcDevAcvsVigenteAc = 0
end

--------------------------
update  @resultadoFinal3 set NomDevAcvsVigenteAc =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0)
If @DIV3g > 0
begin
update  @resultadoFinal3 set PorcEjerAcvsVigenteAc =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id )/100
end
else if @DIV3g = 0
begin
update  @resultadoFinal3 set PorcEjerAcvsVigenteAc = 0
end

------------------------------
update  @resultadoFinal3 set NomEjerAcvsVigenteAc =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0)
If @DIV3h > 0
begin
update  @resultadoFinal3 set PorcPagAcvsVigenteAc =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id )/100
end
else if @DIV3h = 0
begin
update  @resultadoFinal3 set PorcPagAcvsVigenteAc = 0
end

--------------------------------
update  @resultadoFinal3 set NomPagAcvsVigenteAc =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ) ,0)
If @DIV3i > 0
begin
update  @resultadoFinal3 set PorcCompAcvsVigenteAn =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
)/100
end
else if @DIV3i = 0
begin
update  @resultadoFinal3 set PorcCompAcvsVigenteAn = 0
end

-----------------------------
update  @resultadoFinal3 set NomCompAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0) - ISNULL((Select  (sum(isnull(tp.Comprometido,0)))

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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ) ,0)
If @DIV3j > 0
begin
update  @resultadoFinal3 set PorcDevAcvsVigenteAn =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id 
)/100
end
else if @DIV3j = 0
begin
update  @resultadoFinal3 set PorcDevAcvsVigenteAn = 0
end

-----------------------------------
update  @resultadoFinal3 set NomDevAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id  ) ,0)- isnull((Select  (sum(isnull(tp.Devengado,0)))

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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id  ),0) 
If @DIV3k > 0
begin 
update  @resultadoFinal3 set PorcEjerAcvsVigenteAn =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
)/100
end
else if @DIV3k = 0
begin
update  @resultadoFinal3 set PorcEjerAcvsVigenteAn = 0
end

-----------------------------------
update  @resultadoFinal3 set NomEjerAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id),0) - isnull((Select  (sum(isnull(tp.Ejercido,0)))

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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id )
,0)

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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id) ,0)
If @DIV3l > 0
begin
update  @resultadoFinal3 set PorcPagAcvsVigenteAn =
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id
)/100
end
else if @DIV3l = 0
begin
update  @resultadoFinal3 set PorcPagAcvsVigenteAn = 0
end

---------------------------------
update  @resultadoFinal3 set NomPagAcvsVigenteAn =
ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id ),0) - isnull((Select  (sum(isnull(tp.Pagado,0)))

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
left join @resultadoFinal3
ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP 
group by cr.CLAVE,  cepr.Id)
,0)


Select * from @resultadoFinal3
END


If @Tipo = 4 
BEGIN
--Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento
--Valores Absolutos

DECLARE @resultadoFinal4 as table (
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


DECLARE @nombre2AI varchar(255)
DECLARE @clave2AI varchar(255)

SET @nombre2AI = (SELECT  tablaID.nombre 
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @clave2AI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id

INSERT INTO @resultadoFinal4 (Clave1 ,
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
NomPVigente, PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,
PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)

Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
C_AreaResponsabilidad.Clave as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2 , 
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3, @clave2AI as Clave4,C_EP_Ramo.Id,  @nombre2AI as NombreAI,
C_PartidasGenericasPres.IdPartidaGenerica as Clave5 , C_PartidasGenericasPres.DescripcionPartida  as Descripcion4, 
C_FuenteFinanciamiento.CLAVE AS Clave6, C_FuenteFinanciamiento.DESCRIPCION AS Descripcion5,
 
 
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0)) AS PreComprometido,
      
 (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0)) as Comprometido, 
 sum(isnull(TP.Precomprometido,0))- sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
 sum(isnull(TP.Devengado,0)) as Devengado, 
 sum(isnull(TP.Comprometido,0)) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) as Ejercido,
 sum(isnull(TP.Devengado,0))- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
 sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
 sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda,
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
DECLARE @DIV4a decimal(15,2)
SELECT @DIV4a = isnull((Select  sum(isnull(TP.Autorizado,0))
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ) ,0)

If @DIV4a > 0
begin
update  @resultadoFinal4 set PorcAprobAnual =
isnull((Select (sum(isnull(tp.Autorizado,0)) * 100)/ @DIV4a

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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)/100
end
else if @DIV4a = 0
begin
update  @resultadoFinal4 set PorcAprobAnual = 0
end


--Columna 2
DECLARE @DIV4c decimal(15,2)
SELECT @DIV4c = isnull((Select  sum(isnull(tp.Autorizado,0))
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave) ,0)  

If @DIV4c > 0
begin
update  @resultadoFinal4 set PorcAprobadocAnt =
isnull((Select  (sum(isnull(tp.Autorizado,0)) * 100)/@DIV4c

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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)/100
end
else if @DIV4c = 0
begin
update  @resultadoFinal4 set PorcAprobadocAnt = 0
end

--Columna 3 y 4
update  @resultadoFinal4 set NomAprobado =
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)


--Columna 5
DECLARE @DIV4b decimal(15,2)
SELECT @DIV4b = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)

If @DIV4b > 0
begin
update  @resultadoFinal4 set PorcPVigenteAnual =
ISNULL((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV4b

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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)/100
end
else if @DIV4b = 0
begin
update  @resultadoFinal4 set PorcPVigenteAnual = 0
end


--Columna 6
DECLARE @DIV4d decimal(15,2)
SELECT @DIV4d =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)
If @DIV4d > 0
begin
update  @resultadoFinal4 set PorcPVigenteAnt =
isnull((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV4d

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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)/100
end
else if @DIV4d = 0
begin
update  @resultadoFinal4 set PorcPVigenteAnt = 0
end


--Columna 7 y 8
update  @resultadoFinal4 set NomPVigente =
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
left join  @resultadoFinal4
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
left join  @resultadoFinal4
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
) ,0)
If @DIV4m > 0
begin
update  @resultadoFinal4 set PorcCompvsVigente =
isnull((Select sum(isnull(TP.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)/100
end
else if  @DIV4m = 0
begin
update  @resultadoFinal4 set PorcCompvsVigente = 0
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
) ,0)
If @DIV4n > 0
begin
update  @resultadoFinal4 set PorcDevvsVigente =
ISNULL((Select sum(isnull(TP.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)/100
end
else if  @DIV4n = 0
begin
update  @resultadoFinal4 set PorcDevvsVigente = 0
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)
If @DIV4e > 0
begin
update  @resultadoFinal4 set PorcCompAcvsVigenteAc =
ISNULL((Select sum(isnull(tp.Comprometido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100 as PorcCompAcvsVigenteAc
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)
end
else if @DIV4e = 0
begin
update  @resultadoFinal4 set PorcCompAcvsVigenteAc = 0
end

------------------------------------------
update  @resultadoFinal4 set NomCompAcvsVigenteAc =
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
left join  @resultadoFinal4
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)
If @DIV4f > 0
begin
update  @resultadoFinal4 set PorcDevAcvsVigenteAc =
ISNULL((Select sum(isnull(tp.Devengado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)
end
else if @DIV4f = 0
begin
update  @resultadoFinal4 set PorcDevAcvsVigenteAc = 0
end

----------------------------
update  @resultadoFinal4 set NomDevAcvsVigenteAc =
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
left join  @resultadoFinal4
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)
If @DIV4g > 0
begin
update  @resultadoFinal4 set PorcEjerAcvsVigenteAc =
ISNULL((Select sum(isnull(tp.Ejercido,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)
end
else if @DIV4g = 0
begin
update  @resultadoFinal4 set PorcEjerAcvsVigenteAc = 0
end

----------------------------
update  @resultadoFinal4 set NomEjerAcvsVigenteAc =
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
left join  @resultadoFinal4
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)
If @DIV4h > 0
begin
update  @resultadoFinal4 set PorcPagAcvsVigenteAc =
isnull((Select sum(isnull(tp.Pagado,0)) * 100 / (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))/100
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)
end
else if @DIV4h  = 0
begin
update  @resultadoFinal4 set PorcPagAcvsVigenteAc = 0
end

------------------------------------
update  @resultadoFinal4 set NomPagAcvsVigenteAc =
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
left join  @resultadoFinal4
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)
If @DIV4i > 0
begin
update  @resultadoFinal4 set PorcCompAcvsVigenteAn =
ISNULL((Select  (sum(isnull(tp.Comprometido,0)) * 100)/ @DIV4i
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)/100
end
else if @DIV4i  = 0
begin
update  @resultadoFinal4 set PorcCompAcvsVigenteAn = 0
end

-------------------------------------
update  @resultadoFinal4 set NomCompAcvsVigenteAn =
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
left join  @resultadoFinal4
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
left join  @resultadoFinal4
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave) ,0)
If @DIV4j > 0
begin
update  @resultadoFinal4 set PorcDevAcvsVigenteAn =
ISNULL((Select  (sum(isnull(tp.Devengado,0)) * 100)/ @DIV4j
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave 
),0)/100
end
else if @DIV4j = 0
begin
update  @resultadoFinal4 set PorcDevAcvsVigenteAn = 0
end

------------------------------
update  @resultadoFinal4 set NomDevAcvsVigenteAn =
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
left join  @resultadoFinal4
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
left join  @resultadoFinal4
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)
If @DIV4k > 0
begin
update  @resultadoFinal4 set PorcEjerAcvsVigenteAn =
ISNULL((Select  (sum(isnull(tp.Ejercido,0)) * 100)/ @DIV4k
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)/100
end
else if @DIV4k = 0
begin
update  @resultadoFinal4 set PorcEjerAcvsVigenteAn = 0
end

------------------------
update  @resultadoFinal4 set NomEjerAcvsVigenteAn =
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
left join  @resultadoFinal4
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
left join  @resultadoFinal4
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0) 
If @DIV4l > 0
begin
update  @resultadoFinal4 set PorcPagAcvsVigenteAn =
ISNULL((Select  (sum(isnull(tp.Pagado,0)) * 100)/ @DIV4l
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)/100
end
else if @DIV4l = 0
begin
update  @resultadoFinal4 set PorcPagAcvsVigenteAn = 0
end

------------------------
update  @resultadoFinal4 set NomPagAcvsVigenteAn =
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
left join  @resultadoFinal4
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
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave  and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)
),0)


Select * from @resultadoFinal4
END



If @Tipo = 5 
BEGIN	
--Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Distribución Geográfica
--Valores Absolutos

DECLARE @resultadoFinal5 as table (
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


DECLARE @nombre3AI varchar(255)
DECLARE @clave3AI varchar(255)

SET @nombre3AI = (SELECT  tablaID.nombre 
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @clave3AI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id


INSERT INTO @resultadoFinal5 (Clave1 ,
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
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3,@clave3AI as Clave4, C_EP_Ramo.Id,  @nombre3AI as NombreAI,
C_PartidasGenericasPres.IdPartidaGenerica as Clave5 , C_PartidasGenericasPres.DescripcionPartida  as Descripcion4, 
C_ClasificadorGeograficoPresupuestal.Clave AS Clave6, C_ClasificadorGeograficoPresupuestal.Descripcion as Descripcion5,
 
 sum(isnull(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
 sum(isnull(TP.Precomprometido,0)) AS PreComprometido,
      
 (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0)) as Comprometido, 
 sum(isnull(TP.Precomprometido,0))- sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
 sum(isnull(TP.Devengado,0)) as Devengado, 
 sum(isnull(TP.Comprometido,0)) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) as Ejercido,
 sum(isnull(TP.Devengado,0))- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
 sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
 sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda,
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
DECLARE @DIV5a decimal(15,2)
SELECT @DIV5a = isnull((Select  sum(isnull(TP.Autorizado,0))
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)

If @DIV5a > 0
begin
update  @resultadoFinal5 set PorcAprobAnual =
(Select  (sum(isnull(tp.Autorizado,0)) * 100)/  @DIV5a

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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR 
group by cr.CLAVE, ca.Clave
)/100

end
if @DIV5a = 0
begin
update  @resultadoFinal5 set PorcAprobAnual = 0
end


--Columna 2
DECLARE @DIV5c decimal(15,2)
SELECT @DIV5c = isnull((Select  sum(isnull(tp.Autorizado,0))
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)
If @DIV5c > 0
begin
update  @resultadoFinal5 set PorcAprobadocAnt =
ISNULL((Select (sum(isnull(tp.Autorizado,0)) * 100)/@DIV5c

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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100,0)
end
else if @DIV5c = 0
begin
update  @resultadoFinal5 set PorcAprobadocAnt = 0
end


--Columna 3 y 4
update  @resultadoFinal5 set NomAprobado =
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
left join  @resultadoFinal5
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0) 

--Columna 5
DECLARE @DIV5b decimal(15,2)
SELECT @DIV5b = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave) ,0)

If @DIV5b > 0
begin
update  @resultadoFinal5 set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV5b
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV5b = 0
begin
update  @resultadoFinal5 set PorcPVigenteAnual = 0
end


--Columna 6
DECLARE @DIV5d decimal(15,2)
SELECT @DIV5d =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)

If @DIV5d > 0
begin
update  @resultadoFinal5 set PorcPVigenteAnt =
isnull((Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV5d
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100,0)
end
else if @DIV5d = 0
begin
update  @resultadoFinal5 set PorcPVigenteAnt = 0
end


--Columna 7 y 8
update  @resultadoFinal5 set NomPVigente =
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
left join  @resultadoFinal5
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
left join  @resultadoFinal5
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
) ,0)
If @DIV5m > 0
begin
update  @resultadoFinal5 set PorcCompvsVigente =
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if  @DIV5m = 0
begin
update  @resultadoFinal5 set PorcCompvsVigente = 0
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
) ,0)
If @DIV5n > 0
begin
update  @resultadoFinal5 set PorcDevvsVigente =
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if  @DIV5n = 0
begin
update  @resultadoFinal5 set PorcDevvsVigente = 0
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
),0)
If @DIV5e > 0
begin
update  @resultadoFinal5 set PorcCompAcvsVigenteAc =
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)
end
else if @DIV5e = 0
begin
update  @resultadoFinal5 set PorcCompAcvsVigenteAc = 0
end

------------------------------------
update  @resultadoFinal5 set NomCompAcvsVigenteAc =
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
left join  @resultadoFinal5
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)
If @DIV5f > 0
begin
update  @resultadoFinal5 set PorcDevAcvsVigenteAc =
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)
end
else if @DIV5f = 0
begin
update  @resultadoFinal5 set PorcDevAcvsVigenteAc = 0
end

-----------------------------------------
update  @resultadoFinal5 set NomDevAcvsVigenteAc =
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)

-----------------------------
DECLARE @DIV5g decimal(15,2)
SELECT @DIV5g = ISNULL((Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)
If @DIV5g > 0
begin
update  @resultadoFinal5 set PorcEjerAcvsVigenteAc =
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )
end
else if @DIV5g = 0
begin
update  @resultadoFinal5 set PorcEjerAcvsVigenteAc = 0
end

----------------------------------
update  @resultadoFinal5 set NomEjerAcvsVigenteAc =
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
left join  @resultadoFinal5
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)
If @DIV5h > 0
begin
update  @resultadoFinal5 set PorcPagAcvsVigenteAc =
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)
end
else if @DIV5h = 0
begin
update  @resultadoFinal5 set PorcPagAcvsVigenteAc = 0
end

------------------------------
update  @resultadoFinal5 set NomPagAcvsVigenteAc =
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
left join  @resultadoFinal5
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ) ,0)
If @DIV5i > 0
begin
update  @resultadoFinal5 set PorcCompAcvsVigenteAn =
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV5i = 0
begin
update  @resultadoFinal5 set PorcCompAcvsVigenteAn = 0
end

---------------------------
update  @resultadoFinal5 set NomCompAcvsVigenteAn =
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
left join  @resultadoFinal5
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
left join  @resultadoFinal5
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ) ,0)
If @DIV5j > 0
begin
update  @resultadoFinal5 set PorcDevAcvsVigenteAn =
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV5j = 0
begin
update  @resultadoFinal5 set PorcDevAcvsVigenteAn = 0
end

--------------------------------
update  @resultadoFinal5 set NomDevAcvsVigenteAn =
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
left join  @resultadoFinal5
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
left join  @resultadoFinal5
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ) ,0)
If @DIV5k > 0
begin
update  @resultadoFinal5 set PorcEjerAcvsVigenteAn =
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV5k = 0
begin
update  @resultadoFinal5 set PorcEjerAcvsVigenteAn = 0
end

-------------------------------
update  @resultadoFinal5 set NomEjerAcvsVigenteAn =
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
left join  @resultadoFinal5
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
left join  @resultadoFinal5
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave) ,0)
If @DIV5l > 0
begin
update  @resultadoFinal5 set PorcPagAcvsVigenteAn =
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
end
else if @DIV5l = 0
begin
update  @resultadoFinal5 set PorcPagAcvsVigenteAn = 0
end

----------------------------
update  @resultadoFinal5 set NomPagAcvsVigenteAn =
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
left join  @resultadoFinal5
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
left join  @resultadoFinal5
on Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave)
),0)


Select * from @resultadoFinal5
END


If @Tipo = 6 
BEGIN
--Ramo o Dependencia / Función / Programas y Proyectos de Inversión
--Valores Absolutos

DECLARE @resultadoFinal6 as table (
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

INSERT INTO @resultadoFinal6 (Clave1 ,
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
NomPVigente,PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
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
 sum(isnull(TP.Precomprometido,0)) AS PreComprometido,
      
 (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0)) as Comprometido, 
 sum(isnull(TP.Precomprometido,0))- sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
 sum(isnull(TP.Devengado,0)) as Devengado, 
 sum(isnull(TP.Comprometido,0)) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) as Ejercido,
 sum(isnull(TP.Devengado,0))- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
 sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
 sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda,
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


 
--Columna 1
DECLARE @DIV6a decimal(15,2)
SELECT @DIV6a = isnull((Select  sum(isnull(TP.Autorizado,0))
 
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ) ,0)

If @DIV6a > 0
begin
update  @resultadoFinal6 set PorcAprobAnual =
(Select  (sum(isnull(tp.Autorizado,0)) * 100)/ @DIV6a

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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100
end
else if @DIV6a = 0
begin
update  @resultadoFinal6 set PorcAprobAnual = 0
end


--Columna 2
DECLARE @DIV6c decimal(15,2)
SELECT @DIV6c =isnull((Select  sum(isnull(tp.Autorizado,0))
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ),0)    
If @DIV6c > 0
begin
update  @resultadoFinal6 set PorcAprobadocAnt =
ISNULL((Select  (sum(isnull(tp.Autorizado,0)) * 100)/@DIV6c

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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100,0)
end
else if @DIV6c = 0
begin
update  @resultadoFinal6 set PorcAprobadocAnt = 0
end


--Columna 3 y 4
update  @resultadoFinal6 set NomAprobado =
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ),0)

--Columna 5
DECLARE @DIV6b decimal(15,2)
SELECT @DIV6b = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ) ,0)


If @DIV6b > 0
begin
update  @resultadoFinal6 set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV6b
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100
end
else if @DIV6b = 0
begin
update  @resultadoFinal6 set PorcPVigenteAnual = 0
end


--Columna 6
DECLARE @DIV6d decimal(15,2)
SELECT @DIV6d =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ),0)

If @DIV6d > 0
begin
update  @resultadoFinal6 set PorcPVigenteAnt =
ISNULL((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV6d

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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100,0)
end
else if @DIV6d = 0
begin
update  @resultadoFinal6 set PorcPVigenteAnt = 0
end


--Columna 7 y 8
update  @resultadoFinal6 set NomPVigente =
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
) ,0)
If @DIV6m > 0
begin
update  @resultadoFinal6 set PorcCompvsVigente =
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100
end
else if  @DIV6m = 0
begin
update  @resultadoFinal6 set PorcCompvsVigente = 0
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
) ,0)
If @DIV6n > 0
begin
update  @resultadoFinal6 set PorcDevvsVigente =
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100
end
else if  @DIV6n = 0
begin
update  @resultadoFinal6 set PorcDevvsVigente = 0
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
),0)
If @DIV6e > 0
begin
update  @resultadoFinal6 set PorcCompAcvsVigenteAc =
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)
end
else if @DIV6e = 0
begin
update  @resultadoFinal6 set PorcCompAcvsVigenteAc = 0
end

--------------------------------
update  @resultadoFinal6 set NomCompAcvsVigenteAc =
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave),0)
If @DIV6f > 0
begin
update  @resultadoFinal6 set PorcDevAcvsVigenteAc =
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave)
end
else if @DIV6f  = 0
begin
update  @resultadoFinal6 set PorcDevAcvsVigenteAc = 0
end

------------------------------------
update  @resultadoFinal6 set NomDevAcvsVigenteAc =
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave),0)
If @DIV6g >  0
begin
update  @resultadoFinal6 set PorcEjerAcvsVigenteAc =
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave)
end
else if @DIV6g = 0
begin
update  @resultadoFinal6 set PorcEjerAcvsVigenteAc = 0
end

----------------------------------
update  @resultadoFinal6 set NomEjerAcvsVigenteAc =
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave),0)
If @DIV6h > 0
begin
update  @resultadoFinal6 set PorcPagAcvsVigenteAc =
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave)
end
else if @DIV6h = 0
begin
update  @resultadoFinal6 set PorcPagAcvsVigenteAc = 0
end

----------------------------
update  @resultadoFinal6 set NomPagAcvsVigenteAc =
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave  ),0) 
If @DIV6i > 0
begin
update  @resultadoFinal6 set PorcCompAcvsVigenteAn =
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave 
)/100
end
else if @DIV6i = 0
begin
update  @resultadoFinal6 set PorcCompAcvsVigenteAn = 0
end

---------------------------------
update  @resultadoFinal6 set NomCompAcvsVigenteAn =
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave   ) ,0)
If @DIV6j > 0
begin
update  @resultadoFinal6 set PorcDevAcvsVigenteAn =
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave 
)/100
end
else if @DIV6j = 0
begin
update  @resultadoFinal6 set PorcDevAcvsVigenteAn = 0
end

------------------------------------
update  @resultadoFinal6 set NomDevAcvsVigenteAn =
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave ) ,0)
If @DIV6k > 0
begin
update  @resultadoFinal6 set PorcEjerAcvsVigenteAn =
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave 
)/100
end
else if @DIV6k = 0
begin
update  @resultadoFinal6 set PorcEjerAcvsVigenteAn = 0
end

----------------------------
update  @resultadoFinal6 set NomEjerAcvsVigenteAn =
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave) ,0)
If @DIV6l > 0
begin
update  @resultadoFinal6 set PorcPagAcvsVigenteAn =
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave
)/100
end
else if @DIV6l = 0
begin
update  @resultadoFinal6 set PorcPagAcvsVigenteAn = 0
end

-------------------------------
update  @resultadoFinal6 set NomPagAcvsVigenteAn =
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
left JOIN @resultadoFinal6  
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
left JOIN @resultadoFinal6  
ON Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cf.Clave)
),0)


Select * from @resultadoFinal6
END



If @Tipo = 7 
BEGIN
--Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasificación Económica
--Valores Absolutos

DECLARE @resultadoFinal7 as table (
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

INSERT INTO @resultadoFinal7 (Clave1,
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
 sum(isnull(TP.Precomprometido,0)) AS PreComprometido,
      
 (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0)) as Comprometido, 
 sum(isnull(TP.Precomprometido,0))- sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
 sum(isnull(TP.Devengado,0)) as Devengado, 
 sum(isnull(TP.Comprometido,0)) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) as Ejercido,
 sum(isnull(TP.Devengado,0))- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
 sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
 sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda,
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
DECLARE @DIV7a decimal(15,2)
SELECT @DIV7a =ISNULL((Select  sum(isnull(TP.Autorizado,0))
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ) ,0)

If @DIV7a > 0
begin
update  @resultadoFinal7 set PorcAprobAnual =
(Select  (sum(isnull(tp.Autorizado,0)) * 100)/ @DIV7a

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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  )/100
end
else if @DIV7a = 0
begin
update  @resultadoFinal7 set PorcAprobAnual = 0
end



--Columna 2
DECLARE @DIV7c decimal(15,2)
SELECT @DIV7c =isnull((Select  sum(isnull(tp.Autorizado,0))
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave )  ,0)

If @DIV7c > 0
begin
update  @resultadoFinal7 set PorcAprobadocAnt =
isnull((Select (sum(isnull(tp.Autorizado,0)) * 100)/@DIV7c

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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  )/100,0)
end
else if @DIV7c = 0
begin
update  @resultadoFinal7 set PorcAprobadocAnt = 0
end


--Columna 3 y 4
update  @resultadoFinal7 set NomAprobado =
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
LEFT JOIN @resultadoFinal7
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0) 


--Columna 5
DECLARE @DIV7b decimal(15,2)
SELECT @DIV7b =isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ) ,0)


If @DIV7b > 0 
begin
update  @resultadoFinal7 set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV7b
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave )/100
end
else if @DIV7b = 0
begin
update  @resultadoFinal7 set PorcPVigenteAnual = 0
end

--Columna 6
DECLARE @DIV7d decimal(15,2)
SELECT @DIV7d =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ) ,0)

If @DIV7d > 0
begin
update  @resultadoFinal7 set PorcPVigenteAnt =
ISNULL((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV7d
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0)/100
end
else if @DIV7d = 0
begin
update  @resultadoFinal7 set PorcPVigenteAnt = 0
end

--Columna 7 y 8
update  @resultadoFinal7 set NomPVigente =
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
LEFT JOIN @resultadoFinal7
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ),0)


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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave
) ,0)
If @DIV7m > 0
begin
update  @resultadoFinal7 set PorcCompvsVigente =
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if  @DIV7m = 0
begin
update  @resultadoFinal7 set PorcCompvsVigente = 0
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave
) ,0)
If @DIV7n > 0
begin
update  @resultadoFinal7 set PorcDevvsVigente =
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if  @DIV7n = 0
begin
update  @resultadoFinal7 set PorcDevvsVigente = 0
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave
),0)
If @DIV7e > 0
begin
update  @resultadoFinal7 set PorcCompAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)
end
else if @DIV7e = 0
begin
update  @resultadoFinal7 set PorcCompAcvsVigenteAc = 0
end

-----------------------------------------
update  @resultadoFinal7 set NomCompAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal7
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave),0)
If @DIV7f > 0
begin
update  @resultadoFinal7 set PorcDevAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave)
end
else if @DIV7f = 0
begin
update  @resultadoFinal7 set PorcDevAcvsVigenteAc = 0
end

-----------------------------------
update  @resultadoFinal7 set NomDevAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal7
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)
If @DIV7g > 0
begin
update  @resultadoFinal7 set PorcEjerAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave )
end
else if @DIV7g = 0
begin
update  @resultadoFinal7 set PorcEjerAcvsVigenteAc = 0
end

----------------------------------
update  @resultadoFinal7 set NomEjerAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal7
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)
If @DIV7h > 0
begin
update  @resultadoFinal7 set PorcPagAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave )
end
else if @DIV7h = 0
begin
update  @resultadoFinal7 set PorcPagAcvsVigenteAc = 0
end

---------------------------------
update  @resultadoFinal7 set NomPagAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal7
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ) ,0)
If @DIV7i > 0
begin
update  @resultadoFinal7 set PorcCompAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV7i = 0
begin
update  @resultadoFinal7 set PorcCompAcvsVigenteAn = 0
end

---------------------------------
update  @resultadoFinal7 set NomCompAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal7
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
LEFT JOIN @resultadoFinal7
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ) ,0)
If @DIV7j > 0
begin
update  @resultadoFinal7 set PorcDevAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV7j = 0
begin
update  @resultadoFinal7 set PorcDevAcvsVigenteAn = 0
end

---------------------------------
update  @resultadoFinal7 set NomDevAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal7
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
LEFT JOIN @resultadoFinal7
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ) ,0)
If @DIV7k > 0
begin
update  @resultadoFinal7 set PorcEjerAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV7k = 0
begin
update  @resultadoFinal7 set PorcEjerAcvsVigenteAn = 0
end

--------------------------------------
update  @resultadoFinal7 set NomEjerAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal7
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
LEFT JOIN @resultadoFinal7
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ) ,0)
If @DIV7l > 0
begin
update  @resultadoFinal7 set PorcPagAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV7l = 0
begin
update  @resultadoFinal7 set PorcPagAcvsVigenteAn = 0
end

-------------------------------------
update  @resultadoFinal7 set NomPagAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal7
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
LEFT JOIN @resultadoFinal7
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)



Select * from @resultadoFinal7
END


If @Tipo = 8 
BEGIN
--Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento
--Valores Absolutos

DECLARE @resultadoFinal8 as table (
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

INSERT INTO @resultadoFinal8 (Clave1,
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
NomPVigente, PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
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
 sum(isnull(TP.Precomprometido,0)) AS PreComprometido,
      
 (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0)) as Comprometido, 
 sum(isnull(TP.Precomprometido,0))- sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
 sum(isnull(TP.Devengado,0)) as Devengado, 
 sum(isnull(TP.Comprometido,0)) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) as Ejercido,
 sum(isnull(TP.Devengado,0))- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
 sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
 sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda,
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
DECLARE @DIV8a decimal(15,2)
SELECT @DIV8a =isnull((Select  sum(isnull(TP.Autorizado,0))
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)


If  @DIV8a > 0
begin
update  @resultadoFinal8 set PorcAprobAnual =
(Select  (sum(isnull(tp.Autorizado,0)) * 100)/ @DIV8a
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave
)/100
end
else if @DIV8a = 0
begin
update  @resultadoFinal8 set PorcAprobAnual = 0
end

--Columna 2
DECLARE @DIV8c decimal(15,2)
SELECT @DIV8c =isnull((Select  sum(isnull(tp.Autorizado,0))
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ) ,0) 

If @DIV8c > 0
begin
update  @resultadoFinal8 set PorcAprobadocAnt =
ISNULL((Select (sum(isnull(tp.Autorizado,0)) * 100)/@DIV8c
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100,0)
end
else if @DIV8c =0
begin
update  @resultadoFinal8 set PorcAprobadocAnt = 0
end


--Columna 3 y 4
update  @resultadoFinal8 set NomAprobado =
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave) ,0)

--Columna 5
DECLARE @DIV8b decimal(15,2)
SELECT @DIV8b =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ) ,0)


If @DIV8b > 0
begin
update  @resultadoFinal8 set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV8b
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV8b = 0
begin
update  @resultadoFinal8 set PorcPVigenteAnual = 0
end

--Columna 6
DECLARE @DIV8d decimal(15,2)
SELECT @DIV8d =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave),0)

If @DIV8d > 0
begin
update  @resultadoFinal8 set PorcPVigenteAnt =
ISNULL((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV8d
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave
)/100,0)
end
else if @DIV8d = 0
begin
update  @resultadoFinal8 set PorcPVigenteAnt = 0
end


--Columna 7 y 8
update  @resultadoFinal8 set NomPVigente =
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
) ,0)
If @DIV8m > 0
begin
update  @resultadoFinal8 set PorcCompvsVigente =
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if  @DIV8m = 0
begin
update  @resultadoFinal8 set PorcCompvsVigente = 0
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
) ,0)
If @DIV8n > 0
begin
update  @resultadoFinal8 set PorcDevvsVigente =
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if  @DIV8n = 0
begin
update  @resultadoFinal8 set PorcDevvsVigente = 0
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
),0)
If @DIV8e > 0
begin
update  @resultadoFinal8 set PorcCompAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)
end
else if @DIV8e = 0
begin
update  @resultadoFinal8 set PorcCompAcvsVigenteAc = 0
end

-----------------------------
update  @resultadoFinal8 set NomCompAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)
If @DIV8f > 0
begin
update  @resultadoFinal8 set PorcDevAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave )
end 
else if @DIV8f = 0
begin
update  @resultadoFinal8 set PorcDevAcvsVigenteAc = 0
end

--------------------------
update  @resultadoFinal8 set NomDevAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)
If @DIV8g > 0
begin
update  @resultadoFinal8 set PorcEjerAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave )
end
else if @DIV8g = 0
begin
update  @resultadoFinal8 set PorcEjerAcvsVigenteAc = 0
end

---------------------------------
update  @resultadoFinal8 set NomEjerAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)
If @DIV8h > 0
begin
update  @resultadoFinal8 set PorcPagAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave )
end 
else if @DIV8h = 0
begin
update  @resultadoFinal8 set PorcPagAcvsVigenteAc = 0
end

--------------------------------
update  @resultadoFinal8 set NomPagAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave   ) ,0)
If @DIV8i > 0
begin
update  @resultadoFinal8 set PorcCompAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV8i = 0
begin
update  @resultadoFinal8 set PorcCompAcvsVigenteAn = 0
end

---------------------------------------
update  @resultadoFinal8 set NomCompAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ) ,0)
If @DIV8j > 0
begin
update  @resultadoFinal8 set PorcDevAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV8j = 0
begin
update  @resultadoFinal8 set PorcDevAcvsVigenteAn = 0
end

-------------------------------------
update  @resultadoFinal8 set NomDevAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave  ) ,0)
If @DIV8k > 0
begin
update  @resultadoFinal8 set PorcEjerAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV8k = 0
begin
update  @resultadoFinal8 set PorcEjerAcvsVigenteAn = 0
end

-----------------------------------
update  @resultadoFinal8 set NomEjerAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ) ,0)
If @DIV8l > 0
begin
update  @resultadoFinal8 set PorcPagAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave 
)/100
end
else if @DIV8l = 0
begin
update  @resultadoFinal8 set PorcPagAcvsVigenteAn = 0
end

-------------------------------------
update  @resultadoFinal8 set NomPagAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal8
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
LEFT JOIN @resultadoFinal8
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE , ca.Clave ),0)


Select * from @resultadoFinal8
END



If @Tipo = 9
BEGIN
--Ramo o Dependencia / Distribución Geográfica / Programas y Proyectos de Inversión
--Valores Absolutos

DECLARE @resultadoFinal9 as table (
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

INSERT INTO @resultadoFinal9 (Clave1,
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
 sum(isnull(TP.Precomprometido,0)) AS PreComprometido,
      
 (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
 sum(isnull(TP.Comprometido,0)) as Comprometido, 
 sum(isnull(TP.Precomprometido,0))- sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
 sum(isnull(TP.Devengado,0)) as Devengado, 
 sum(isnull(TP.Comprometido,0)) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
 sum(isnull(TP.Ejercido,0)) as Ejercido,
 sum(isnull(TP.Devengado,0))- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
 sum(isnull(TP.Pagado,0)) as Pagado, 
 sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
 sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda,
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
DECLARE @DIV9a decimal(15,2)
SELECT @DIV9a = ISNULL((Select  sum(isnull(TP.Autorizado,0))
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cpi.clave) ,0)  

If @DIV9a > 0
begin
update  @resultadoFinal9 set PorcAprobAnual =
(Select  (sum(isnull(tp.Autorizado,0)) * 100)/ @DIV9a

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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave ,cpi.clave)/100
end
else if @DIV9a = 0
begin
update  @resultadoFinal9 set PorcAprobAnual = 0
end

--Columna 2
DECLARE @DIV9c decimal(15,2)
SELECT @DIV9c =isnull((Select  sum(isnull(tp.Autorizado,0))
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave) ,0)   
If @DIV9c > 0
begin
update  @resultadoFinal9 set PorcAprobadocAnt =
ISNULL((Select  (sum(isnull(tp.Autorizado,0)) * 100)/@DIV9c

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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave)/100,0)
end
else if @DIV9c = 0
begin
update  @resultadoFinal9 set PorcAprobadocAnt = 0
end


--Columna 3 y 4
update  @resultadoFinal9 set NomAprobado =
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
LEFT JOIN @resultadoFinal9
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE,  cepr.Clave , cpi.clave),0) 


--Columna 5
DECLARE @DIV9b decimal(15,2)
SELECT @DIV9b = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE,  cepr.Clave , cpi.clave),0)

If @DIV9b > 0
begin
update  @resultadoFinal9 set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV9b
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE,  cepr.Clave , cpi.clave)/100
end
else if @DIV9b = 0
begin
update  @resultadoFinal9 set PorcPVigenteAnual = 0
end


--Columna 6
DECLARE @DIV9d decimal(15,2)
SELECT @DIV9d =ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE,  cepr.Clave , cpi.clave ),0) 

If @DIV9d < 0
begin
update  @resultadoFinal9 set PorcPVigenteAnt =
ISNULL((Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/@DIV9d
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave)/100,0)
end
else if @DIV9d = 0
begin
update  @resultadoFinal9 set PorcPVigenteAnt = 0
end


--Columna 7 y 8
update  @resultadoFinal9 set NomPVigente =
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
LEFT JOIN @resultadoFinal9
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE,  cepr.Clave , cpi.clave),0)



-----------------------------
DECLARE @DIV9m decimal(15,2)
SELECT @DIV9m = ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
) ,0)
If @DIV9m > 0
begin
update  @resultadoFinal9 set PorcCompvsVigente =
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)/100
end
else if  @DIV9m = 0
begin
update  @resultadoFinal9 set PorcCompvsVigente = 0
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
) ,0)
If @DIV9n > 0
begin
update  @resultadoFinal9 set PorcDevvsVigente =
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)/100
end
else if  @DIV9n = 0
begin
update  @resultadoFinal9 set PorcDevvsVigente = 0
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
),0)
If @DIV9e > 0
begin
update  @resultadoFinal9 set PorcCompAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)
end
else if @DIV9e = 0
begin
update  @resultadoFinal9 set PorcCompAcvsVigenteAc = 0
end

--------------------
update  @resultadoFinal9 set NomCompAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal9
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0)
If @DIV9f > 0
begin
update  @resultadoFinal9 set PorcDevAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave)
end
else if @DIV9f = 0
begin
update  @resultadoFinal9 set PorcDevAcvsVigenteAc = 0
end

-----------------------------
update  @resultadoFinal9 set NomDevAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal9
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0)
If @DIV9g > 0
begin
update  @resultadoFinal9 set PorcEjerAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave)
end
else if @DIV9g = 0
begin
update  @resultadoFinal9 set PorcEjerAcvsVigenteAc = 0
end

-----------------------------------
update  @resultadoFinal9 set NomEjerAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal9
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0)
If @DIV9h > 0
begin
update  @resultadoFinal9 set PorcPagAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave)
end
else if @DIV9h = 0
begin
update  @resultadoFinal9 set PorcPagAcvsVigenteAc = 0
end

---------------------------------
update  @resultadoFinal9 set NomPagAcvsVigenteAc =
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
LEFT JOIN @resultadoFinal9
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave  ),0) 
If @DIV9i > 0
begin
update  @resultadoFinal9 set PorcCompAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)/100
end
else if @DIV9i = 0
begin
update  @resultadoFinal9 set PorcCompAcvsVigenteAn = 0
end

------------------------------------
update  @resultadoFinal9 set NomCompAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal9
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
LEFT JOIN @resultadoFinal9
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave ) ,0)
If @DIV9j > 0
begin
update  @resultadoFinal9 set PorcDevAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)/100
end
else if @DIV9j = 0
begin
update  @resultadoFinal9 set PorcDevAcvsVigenteAn = 0
end

--------------------------------
update  @resultadoFinal9 set NomDevAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal9
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
LEFT JOIN @resultadoFinal9
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave ) ,0)
If @DIV9k > 0
begin
update  @resultadoFinal9 set PorcEjerAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)/100
end
else if @DIV9k = 0
begin
update  @resultadoFinal9 set PorcEjerAcvsVigenteAn = 0
end

------------------------------
update  @resultadoFinal9 set NomEjerAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal9
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
LEFT JOIN @resultadoFinal9
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave) ,0)
If @DIV9l > 0
begin
update  @resultadoFinal9 set PorcPagAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave
)/100
end
else if @DIV9l = 0
begin
update  @resultadoFinal9 set PorcPagAcvsVigenteAn = 0
end

-------------------------------------
update  @resultadoFinal9 set NomPagAcvsVigenteAn =
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
LEFT JOIN @resultadoFinal9
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
LEFT JOIN @resultadoFinal9
ON Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP
group by cr.CLAVE, cepr.Clave , cpi.clave),0)



Select * from @resultadoFinal9
END

END



GO




UPDATE C_Menu set utilizar= 1 WHERE IdMenu IN(1190,1191,1192,1193,1194,1195,1196,1197,1198,1199)
GO

EXEC SP_FirmasReporte 'IPComp:Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional'
GO
EXEC SP_FirmasReporte 'IPComp:Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo'
GO
EXEC SP_FirmasReporte 'IPComp:Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica'
GO
EXEC SP_FirmasReporte 'IPComp:Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento'
GO
EXEC SP_FirmasReporte 'IPComp:Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Distribución Georgráfica'
GO
EXEC SP_FirmasReporte 'IPComp:Ramo o Dependencia / Función / Programas y Proyectos de Inversión'
GO
EXEC SP_FirmasReporte 'IPComp:Ramo o Dependencia / UR / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasificación Económica'
GO
EXEC SP_FirmasReporte 'IPComp:Ramo o Dependencia / UR / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento'
GO
EXEC SP_FirmasReporte 'IPComp:Ramo o Dependencia / Distribución Georgáfica / Programas y Proyectos de Inversión'
GO

