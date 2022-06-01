/****** Object:  StoredProcedure [dbo].[SP_RPT_Ramo_Programa_Objeto_Gasto_Capitulo]    Script Date: 16/Jul/2014 12:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Ramo_Programa_Objeto_Gasto_Capitulo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Ramo_Programa_Objeto_Gasto_Capitulo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
--Exec SP_RPT_Ramo_Programa_Objeto_Gasto_Capitulo 4,8,26,2020,'','','',0,0,0,'',0
Create PROCEDURE [dbo].[SP_RPT_Ramo_Programa_Objeto_Gasto_Capitulo] 

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
@ClaveFF varchar(10),
@AmpAnual as bit  


AS
BEGIN

IF @Tipo=13 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Capítulo del Gasto -Actividad Institucinal -UR
--Valores Absolutos

DECLARE @nombreAI varchar(255)
DECLARE @claveAI varchar(255)
declare @rptt13 as table(--ClaveUR varchar(200), Nombre varchar(200), 
ClaveProy varchar(200), Proyecto varchar(max), idClave varchar(100), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(max), idClave2 varchar(100),
Autorizado decimal(18,4), 
Ampliaciones  decimal(18,4),
Reducciones  decimal(18,4),
Modificado  decimal(18,4),
PreComprometido decimal(18,4),
PresVigSinPreComp decimal(18,4),
Comprometido  decimal(18,4),
PreCompSinComp decimal(18,4),
PresDispComp decimal(18,4),
Devengado  decimal(18,4),
CompSinDev decimal(18,4),
PresSinDev decimal(18,4),
Ejercido  decimal(18,4),
DevSinEjer decimal(18,4),
Pagado  decimal(18,4),
EjerSinPagar  decimal(18,4),
Deuda  decimal(18,4),
NombreAI varchar(max),
ClaveAI int
)

declare @Anual13 as table(--ClaveUR varchar(200), Nombre varchar(200), 
ClaveProy varchar(200), Proyecto varchar(max), idClave varchar(100), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(max), idClave2 varchar(100),
Autorizado decimal(18,4))
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
Insert into @rptt13
Select --T1.ClaveUR, T1.Nombre, 
min(T1.ClaveProy)ClaveProy, Min(T1.Proyecto)Proyecto, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2, sum(T1.Autorizado)Autorizado, sum(T1.Ampliaciones)Ampliaciones, 
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
Select top 100 PErcent CEPR.ID, --CA.Clave as ClaveUR , 
CA.Nombre ,CEPR.Clave as ClaveProy , CEPR.Nombre as Proyecto,  
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
group by  T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2
--group by  T1.ClaveUR, T1.Nombre, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2

If @AmpAnual = 1
	Begin
	Insert into @Anual13
	Select --T1.ClaveUR, T1.Nombre, 
	min(T1.ClaveProy)ClaveProy, Min(T1.Proyecto)Proyecto, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2, sum(T1.Autorizado)Autorizado 

    from (
	Select top 100 PErcent CEPR.ID, CA.Clave as ClaveUR , CA.Nombre ,CEPR.Clave as ClaveProy , CEPR.Nombre as Proyecto,  
	CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  
    
	sum(isnull(TP.Autorizado,0)) as Autorizado 

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

	where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio and Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
	AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
	AND CEPR.Id = CASE WHEN @IdEP = '' THEN CEPR.ID ELSE @IdEP END  AND CEPR.Nivel = '5'
	AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
	AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END  

	Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,CA.Clave , CA.Nombre,CEPR.Clave, CEPR.Nombre, CEPR.Id
	Order by  CEPR.Clave, CA.Clave ,CG.IdCapitulo) as T1
	group by  T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2
	--group by  T1.ClaveUR, T1.Nombre, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2
		--update r set r.Autorizado = a.Autorizado FROM @Anual13 a, @rptt13 r Where a.ClaveUR = r.ClaveUR and a.ClaveProy = r.ClaveProy and a.Clave = r.Clave and a.idClave = r.idClave and a.idClave2 = r.idClave2
		update r set r.Autorizado = a.Autorizado FROM @Anual13 a, @rptt13 r Where a.ClaveProy = r.ClaveProy and a.Clave = r.Clave and a.idClave = r.idClave and a.idClave2 = r.idClave2
	End

	select * from @rptt13
END


-- ******************************** VALORES RELATIVOS ************************** --

Else if @Tipo=26  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Capítulo del Gasto -Actividad Institucinal -UR
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
declare @rptt26 as table(ClaveUR varchar(max), Nombre varchar(max), ClaveProy varchar(max), Proyecto varchar(max), idClave varchar(100), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(max), idClave2 varchar(100),
Autorizado decimal(18,4), 
Ampliaciones  decimal(18,4),
Reducciones  decimal(18,4),
Modificado  decimal(18,4),
PreComprometido decimal(18,4),
PresVigSinPreComp decimal(18,4),
Comprometido  decimal(18,4),
PreCompSinComp decimal(18,4),
PresDispComp decimal(18,4),
Devengado  decimal(18,4),
CompSinDev decimal(18,4),
PresSinDev decimal(18,4),
Ejercido  decimal(18,4),
DevSinEjer decimal(18,4),
Pagado  decimal(18,4),
EjerSinPagar  decimal(18,4),
Deuda  decimal(18,4),
NombreAI varchar(max),
ClaveAI int
)

declare @Anual26 as table(ClaveUR varchar(max), Nombre varchar(max), ClaveProy varchar(max), Proyecto varchar(max), idClave varchar(100), Descripcion varchar(max), Clave varchar(max), Descripcion2 varchar(max), idClave2 varchar(100),
Autorizado decimal(18,4))

Insert into @rptt26
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

If @AmpAnual = 1
	Begin
	Insert into @Anual26
	Select T1.ClaveUR, T1.Nombre, min(T1.ClaveProy)ClaveProy, Min(T1.Proyecto)Proyecto, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2, 
	sum(T1.Autorizado)Autorizado 
 
	from (
	Select top 100 percent CA.Clave as ClaveUR , CA.Nombre ,CEPR.Clave as ClaveProy , CEPR.Nombre as Proyecto, 
	CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  
    
	 sum(isnull(TP.Autorizado,0)) as Autorizado  
	
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

	where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio and Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
	AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
	AND CEPR.Id = CASE WHEN @IdEP = '' THEN CEPR.ID ELSE @IdEP END  AND CEPR.Nivel = '5' 
	AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
	AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END 

	Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,CA.Clave , CA.Nombre,CEPR.Clave, CEPR.Nombre, CEPR.Id
	Order by  CEPR.Clave, CA.Clave ,CG.IdCapitulo) as T1
	group by  T1.ClaveUR, T1.Nombre, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2

		update r set r.Autorizado = a.Autorizado FROM @Anual26 a, @rptt26 r Where a.ClaveUR = r.ClaveUR and a.ClaveProy = r.ClaveProy and a.Clave = r.Clave and a.idClave = r.idClave and a.idClave2 = r.idClave2 
	End

	select * from @rptt26
END

End 

GO

Exec SP_CFG_LogScripts 'SP_RPT_Ramo_Programa_Objeto_Gasto_Capitulo','2.30'
GO
