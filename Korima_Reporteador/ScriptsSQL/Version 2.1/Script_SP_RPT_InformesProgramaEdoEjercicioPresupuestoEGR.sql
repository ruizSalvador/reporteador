/****** Object:  StoredProcedure [dbo].[SP_RPT_InformeProgramaEstadoEjercicioPresupuestoEGR]    Script Date: 12/27/2012 15:47:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_InformeProgramaEstadoEjercicioPresupuestoEGR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_InformeProgramaEstadoEjercicioPresupuestoEGR]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_InformeProgramaEstadoEjercicioPresupuestoEGR]    Script Date: 12/27/2012 15:47:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_RPT_InformeProgramaEstadoEjercicioPresupuestoEGR] 

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
--Informes Programáticos del Estado del Estado del Ejercicio del Presupuesto de Egresos



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
NomPVigente decimal(15,2))

--///-- Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional
-- Valores Absolutos
DECLARE @nombreAI varchar(255)
DECLARE @claveAI varchar(255)

SET @nombreAI = (SELECT  tablaID.nombre 
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @claveAI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id

INSERT INTO @resultadoFinal (Clave1 ,
Descripcion ,
Clave2 ,
Descripcion2 ,
Clave3 ,
Id , 
Descripcion3 , 
Clave4 , 
NombreAI , 
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )

Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion,
C_Funciones.Clave as Clave2,  C_Funciones.Nombre as Descripcion2, 
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Id, C_EP_Ramo.Nombre as Descripcion3,  @claveAI as Clave4, @nombreAI as NombreAI,
 
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
 0,0,0,0,0,0
 

     
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

WHERE  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= @Clave and C_RamoPresupuestal.CLAVE <= @Clave2) AND C_EP_Ramo.Id =@IdEP

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
-------
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
GROUP BY   cr.CLAVE, cepr.Id ),0) 

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
GROUP BY  cr.CLAVE, cepr.Id),0)- isnull((Select  sum(isnull(tp.Autorizado,0))
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
GROUP BY   cr.CLAVE, cepr.Id ) ,0)


-------
--Columna 22
DECLARE @DIV3 decimal(15,2)
SELECT @DIV3 = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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

------------
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
GROUP BY   cr.CLAVE, cepr.Id) ,0)


Select * from @resultadoFinal

END




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
NomPVigente decimal(15,2))

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
NombreAI,
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )




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
 0,0,0,0,0,0
  	
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
SELECT @DIV2b = ISNULL((Select  sum(isnull(TP.Autorizado,0))
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
group by cr.CLAVE, ca.Clave  ) ,0)

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
inner join @resultadoFinal2
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
inner join @resultadoFinal2
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
group by cr.CLAVE, ca.Clave ) ,0) 


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
NomPVigente decimal(15,2))

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
Descripcion3 , 
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )

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
 0,0,0,0,0,0
 
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
SELECT @DIV3a = ISNULL((Select  sum(isnull(TP.Autorizado,0))
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
ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4

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
group by cr.CLAVE,  cepr.Id ),0)  
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
group by cr.CLAVE,  cepr.Id ) ,0)


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
group by cr.CLAVE, cepr.Id ),0) 
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
group by cr.CLAVE, cepr.Id ) ,0)


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
NomPVigente decimal(15,2))


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

INSERT INTO @resultadoFinal4 (
Clave1 ,
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
Descripcion5 , 
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )

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
 0,0,0,0,0,0
 
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
SELECT @DIV4a = ISNULL((Select  sum(isnull(TP.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ) ,0)

If @DIV4a > 0
begin
update  @resultadoFinal4 set PorcAprobAnual =
(Select (sum(isnull(tp.Autorizado,0)) * 100)/ @DIV4a

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
left join  @resultadoFinal4
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave )/100
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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4
ON Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100,0)
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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0)
 

--Columna 5
DECLARE @DIV4b decimal(15,2)
SELECT @DIV4b = isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
left join  @resultadoFinal4
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave ),0) 

If @DIV4b > 0
begin
update  @resultadoFinal4 set PorcPVigenteAnual =
(Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) * 100)/ @DIV4b

FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
left join  @resultadoFinal4
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100
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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave
)/100,0)
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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave),0)


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
NomPVigente decimal(15,2))


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


INSERT INTO @resultadoFinal5 (
Clave1 ,
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
Descripcion5 ,
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )

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
 0,0,0,0,0,0
 
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
SELECT @DIV5a = ISNULL((Select  sum(isnull(TP.Autorizado,0))
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
group by cr.CLAVE, ca.Clave) ,0) 
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
group by cr.CLAVE, ca.Clave ) ,0)

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
group by cr.CLAVE, ca.Clave ),0) 

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
group by cr.CLAVE, ca.Clave) ,0)

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
NomPVigente decimal(15,2))

INSERT INTO @resultadoFinal6 (
Clave1 ,
Descripcion ,
Clave2 ,
Descripcion2 ,
Clave3 ,
Id,
Descripcion3 , 
Clave4,
Descripcion4,
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )

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
 0,0,0,0,0,0
 
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
SELECT @DIV6a = ISNULL((Select  sum(isnull(TP.Autorizado,0))
 
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
group by cr.CLAVE, cf.Clave ),0) 

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
group by cr.CLAVE, cf.Clave ) ,0)   
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
group by cr.CLAVE, cf.Clave ) ,0)

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
NomPVigente decimal(15,2))

INSERT INTO @resultadoFinal7 (
Clave1,
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
Descripcion6 ,
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )


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
 0,0,0,0,0,0
 

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
group by cr.CLAVE , ca.Clave ),0)  

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
group by cr.CLAVE , ca.Clave  )/100,0)
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
group by cr.CLAVE , ca.Clave  ) ,0)

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
NomPVigente decimal(15,2))

INSERT INTO @resultadoFinal8 (
Clave1,
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
Descripcion6 ,
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )


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
 0,0,0,0,0,0
 
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
SELECT @DIV8a =ISNULL((Select  sum(isnull(TP.Autorizado,0))
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
group by cr.CLAVE , ca.Clave),0)

--Columna 5
DECLARE @DIV8b decimal(15,2)
SELECT @DIV8b =isnull((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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
group by cr.CLAVE , ca.Clave ) ,0)

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
NomPVigente decimal(15,2))

INSERT INTO @resultadoFinal9 (
Clave1,
Descripcion ,
Clave2 ,
Descripcion2  ,
Clave3  ,
Id ,  
Descripcion3 , 
Clave4 , 
Descripcion4  ,
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )


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
 0,0,0,0,0,0


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
group by cr.CLAVE, cpi.clave),0)   

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
group by cr.CLAVE,  cepr.Clave , cpi.clave) ,0)



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
group by cr.CLAVE,  cepr.Clave , cpi.clave ) ,0)

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
group by cr.CLAVE,  cepr.Clave , cpi.clave) ,0)



Select * from @resultadoFinal9
END



--////////******************************VALORES RELATIVOS*************************************//////////////


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
NomPVigente decimal(15,2))

--///-- Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional
-- Valores Relativos
DECLARE @nombreRAI varchar(255)
DECLARE @claveRAI varchar(255)

SET @nombreRAI = (SELECT  tablaID.nombre 
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id);

SELECT @claveRAI =  tablaID.Clave  
FROM
(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id

INSERT INTO @resultadoFinalR (Clave1 ,
Descripcion ,
Clave2 ,
Descripcion2 ,
Clave3 ,
Id , 
Descripcion3 , 
Clave4 , 
NombreAI , 
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )

Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion,
C_Funciones.Clave as Clave2,  C_Funciones.Nombre as Descripcion2, 
C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Id, C_EP_Ramo.Nombre as Descripcion3,  @claveRAI as Clave4, @nombreRAI as NombreAI,
 
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
 0,0,0,0,0,0
 
     
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

WHERE  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= @Clave and C_RamoPresupuestal.CLAVE <= @Clave2) AND C_EP_Ramo.Id =@IdEP

GROUP BY C_RamoPresupuestal.CLAVE ,C_RamoPresupuestal.DESCRIPCION , C_EP_Ramo.Clave, C_EP_Ramo.ID, C_EP_Ramo.Nombre, C_Funciones.Clave, C_Funciones.Nombre 
Order By C_RamoPresupuestal.CLAVE,C_Funciones.Clave


--Columna 18
DECLARE @DIVR decimal(15,2)
SELECT @DIVR = ISNULL((Select  sum(isnull(TP.Autorizado,0))

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

-------
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


Select * from @resultadoFinalR

END




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
NomPVigente decimal(15,2))

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
NombreAI,
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )


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
 0,0,0,0,0,0

  	
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
group by cr.CLAVE, ca.Clave  ) ,0)

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
group by cr.CLAVE, ca.Clave  ) ,0)



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
group by cr.CLAVE, ca.Clave ),0) 

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
group by cr.CLAVE, ca.Clave),0) -ISNULL((Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))
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


Select * from @resultadoFinal2R

END



If @Tipo = 12 
BEGIN
--Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica
--Valores Relativos

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
NomPVigente decimal(15,2))

DECLARE @nombre1RAI varchar(255)
DECLARE @clave1RAI varchar(255)

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
Descripcion3 , 
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )

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
 0,0,0,0,0,0

 
 
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
group by cr.CLAVE, cepr.Id),0) 

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


Select * from @resultadoFinal3R

END


If @Tipo = 13 
BEGIN
--Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento
--Valores Relativos

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
NomPVigente decimal(15,2))


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

INSERT INTO @resultadoFinal4R (
Clave1 ,
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
Descripcion5 , 
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )

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
 0,0,0,0,0,0

 
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
SELECT @DIV4Ra = ISNULL((Select  sum(isnull(TP.Autorizado,0))
FROM T_SellosPresupuestales 
INNER JOIN T_PRESUPUESTONW TP
ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal cr
ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
INNER JOIN C_PartidasPres 
ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4R
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave  ),0) 

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
left join  @resultadoFinal4R
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4R
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave) ,0)  
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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4R
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4R
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4R
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
left join  @resultadoFinal4R
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
left join  @resultadoFinal4R
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4R
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4R
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4R
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

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
INNER JOIN C_PartidasGenericasPres 
ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
INNER JOIN C_AreaResponsabilidad ca
ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
INNER JOIN C_FuenteFinanciamiento 
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
INNER JOIN C_EP_Ramo cepr 
ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
INNER JOIN C_ConceptosNEP 
ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
left join  @resultadoFinal4R
ON  Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6

where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= @Clave and cr.CLAVE <= @Clave2) AND cepr.Id =@IdEP and CA.Clave = @ClaveUR
group by cr.CLAVE, ca.Clave) ,0)



Select * from @resultadoFinal4R

END


	
If @Tipo = 14
BEGIN	
--Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Distribución Geográfica
--Valores Relativos

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
NomPVigente decimal(15,2))


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


INSERT INTO @resultadoFinal5R (
Clave1 ,
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
Descripcion5 ,
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )

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
 0,0,0,0,0,0

 
 
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
group by cr.CLAVE, ca.Clave ),0) 

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
group by cr.CLAVE, ca.Clave),0)  
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
group by cr.CLAVE, ca.Clave ) ,0)

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



Select * from @resultadoFinal5R

END

	
If @Tipo = 15
BEGIN
--Ramo o Dependencia / Función / Programas y Proyectos de Inversión
--Valores Relativos

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
NomPVigente decimal(15,2))

INSERT INTO @resultadoFinal6R (
Clave1 ,
Descripcion ,
Clave2 ,
Descripcion2 ,
Clave3 ,
Id,
Descripcion3 , 
Clave4,
Descripcion4,
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )

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
 0,0,0,0,0,0

 
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
group by cr.CLAVE, cf.Clave ) ,0)   
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
group by cr.CLAVE, cf.Clave ),0)


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
group by cr.CLAVE, cf.Clave ) ,0)


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
group by cr.CLAVE, cf.Clave ) ,0)


Select * from @resultadoFinal6R

END



If @Tipo = 16
BEGIN
--Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasificación Económica
--Valores Relativos

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
NomPVigente decimal(15,2))

INSERT INTO @resultadoFinal7R (
Clave1,
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
Descripcion6 ,
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )


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
 0,0,0,0,0,0

 

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
SELECT @DIV7Ra =ISNULL((Select  sum(isnull(TP.Autorizado,0))
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
group by cr.CLAVE , ca.Clave ) ,0) 

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
group by cr.CLAVE , ca.Clave  ) ,0) 

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
group by cr.CLAVE , ca.Clave  ) ,0)

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



Select * from @resultadoFinal7R

END


If @Tipo = 17
BEGIN
--Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento
--Valores Relativos

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
NomPVigente decimal(15,2))

INSERT INTO @resultadoFinal8R (
Clave1,
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
Descripcion6 ,
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )


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
 0,0,0,0,0,0

 
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
SELECT @DIV8Ra =ISNULL((Select  sum(isnull(TP.Autorizado,0))
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
group by cr.CLAVE , ca.Clave ),0)  


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
group by cr.CLAVE , ca.Clave ) ,0) 

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
group by cr.CLAVE , ca.Clave) ,0) 


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
group by cr.CLAVE , ca.Clave ),0) 


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



Select * from @resultadoFinal8R

END


If @Tipo = 18
BEGIN
--Ramo o Dependencia / Distribución Geográfica / Programas y Proyectos de Inversión
--Valores Relativos

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
NomPVigente decimal(15,2))

INSERT INTO @resultadoFinal9R (
Clave1,
Descripcion ,
Clave2 ,
Descripcion2  ,
Clave3  ,
Id ,  
Descripcion3 , 
Clave4 , 
Descripcion4  ,
Autorizado , 
TransferenciaAmp , 
TransferenciaRed , 
Modificado , 
PreComprometido , 
PresVigSinPreComp ,
Comprometido , 
PreCompSinComp , 
PresDispComp , 
Devengado , 
CompSinDev ,
PresSinDev ,
Ejercido , 
DevSinEjer , 
Pagado , 
EjerSinPagar ,
Deuda,
PorcAprobAnual,
PorcAprobadocAnt,
NomAprobado,
PorcPVigenteAnual, 
PorcPVigenteAnt ,
NomPVigente )


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
 0,0,0,0,0,0

 

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
SELECT @DIV9Ra = ISNULL((Select  sum(isnull(TP.Autorizado,0))
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
group by cr.CLAVE,  cepr.Clave , cpi.clave) ,0)

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
group by cr.CLAVE,  cepr.Clave , cpi.clave ),0) 

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



Select * from @resultadoFinal9R

END

end



GO





EXEC SP_FirmasReporte 'Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional'
GO
EXEC SP_FirmasReporte 'Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo'
GO
EXEC SP_FirmasReporte 'Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica'
GO
EXEC SP_FirmasReporte 'Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento'
GO
EXEC SP_FirmasReporte 'Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Distribución Georgráfica'
GO
EXEC SP_FirmasReporte 'Ramo o Dependencia / Función / Programas y Proyectos de Inversión'
GO
EXEC SP_FirmasReporte 'Ramo o Dependencia / UR / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasificación Económica'
GO
EXEC SP_FirmasReporte 'Ramo o Dependencia / UR / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento'
GO
EXEC SP_FirmasReporte 'Ramo o Dependencia / Distribución Georgáfica / Programas y Proyectos de Inversión'
GO


UPDATE C_Menu set utilizar= 1 WHERE IdMenu IN(1152, 1153,1154,1155,1156,1157,1158,1159,1160,1161)
GO











