/****** Object:  StoredProcedure [dbo].[SP_RPT_InformeAdmtvoEstadoEjercicioPresupuestoEGR]    Script Date: 16/Jul/2014 12:10 ******/
/****** Ing. Alvirde. Modificacion para aceptar unidad responsable y programa sin especificar. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_InformeAdmtvoEstadoEjercicioPresupuestoEGR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_InformeAdmtvoEstadoEjercicioPresupuestoEGR]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
--Exec SP_RPT_InformeAdmtvoEstadoEjercicioPresupuestoEGR 1,12,7,2019,'','','',0,0,0,'',0
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
@ClaveFF varchar(10),
@AmpAnual as bit  


AS
BEGIN

If @Tipo = 1 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO--Unidad Responsable
--Valores Absolutos

declare @rptt1 as table(CveRamo varchar(200), DescripcionRamo varchar(250),CLAVE varchar(100), DESCRIPCION varchar(max),
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
Deuda  decimal(18,4)
)

declare @Anual1 as table(CveRamo varchar(200), DescripcionRamo varchar(250), CLAVE varchar(100), DESCRIPCION varchar(max),
Autorizado decimal(18,4))
---------------------------------------------------------------------------------------------
Insert into @Anual1
Select CR.CLAVE as CveRamo , CR.DESCRIPCION as DescripcionRamo, CA.Clave as Clave , CA.Nombre  as Descripcion,
 
sum(isnull(TP.Autorizado,0)) as Autorizado  
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal CR
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 

where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND  Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
group by CR.CLAVE, CR.DESCRIPCION ,CA.Clave  , CA.Nombre
Order By CR.CLAVE
---------------------------------------------------------------------------------------------

Insert into @rptt1
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

If @AmpAnual = 1
	Begin
		update r set r.Autorizado = a.Autorizado FROM @Anual1 a, @rptt1 r Where a.CveRamo = r.CveRamo and a.Clave = r.Clave
	End

	select * from @rptt1
END



Else if @Tipo=2
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO--Ramo - Clasificador Económico
--Valores Absolutos
declare @rptt2 as table(CLAVE varchar(100), DESCRIPCION varchar(max),
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
Deuda  decimal(18,4)
)

declare @Anual2 as table(CLAVE varchar(100), DESCRIPCION varchar(max),
Autorizado decimal(18,4))
------------------------------------------------------------------------------------
Insert into @Anual2
Select CE.Clave as Clave,CE.NOMBRE as Descripcion,

sum(isnull(TP.Autorizado,0)) as Autorizado 

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_TipoGasto CE
on CE.IDTIPOGASTO = TS.IdTipoGasto 
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 

where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
group by CE.Clave,CE.NOMBRE 
Order By CE.Clave

------------------------------------------------------------------------------------
Insert into @rptt2
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

If @AmpAnual = 1
	Begin
		update r set r.Autorizado = a.Autorizado FROM @Anual2 a, @rptt2 r Where a.Clave = r.Clave
	End

	select * from @rptt2


END



Else if @Tipo=3 
BEGIN 
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO--Clasificación Económica - Capítulo del Gasto
--Valores Absolutos

declare @rptt3 as table(CLAVE varchar(100),IdCapitulo int, DESCRIPCION varchar(max),
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
Deuda  decimal(18,4)
)

declare @Anual3 as table(CLAVE varchar(100),IdCapitulo int, DESCRIPCION varchar(max),
Autorizado decimal(18,4))

----------------------------------------------------------------------------------------------
Insert into @Anual3
Select  CE.Clave, CG.IdCapitulo, CG.Descripcion, 
sum(isnull(TP.Autorizado,0)) as Autorizado  

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

where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
Group by CG.IdCapitulo, CG.Descripcion, CE.Clave 
Order by CE.Clave, CG.IdCapitulo  
----------------------------------------------------------------------------------------------

Insert into @rptt3
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

If @AmpAnual = 1
	Begin
		update r set r.Autorizado = a.Autorizado FROM @Anual3 a, @rptt3 r Where a.Clave = r.Clave and a.IdCapitulo = r.IdCapitulo
	End

	select * from @rptt3

END



Else if @Tipo=4 
BEGIN 
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Capítulo del Gasto
--Valores Absolutos
declare @rptt4 as table(IdClave int, Descripcion varchar(max), Clave int, Descripcion2 varchar(200), IdClave2 int, IdPartida int, Descripcion3 varchar(max),
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
Deuda  decimal(18,4)
)

declare @Anual4 as table(IdClave int, Descripcion varchar(max), Clave int, Descripcion2 varchar(200), IdClave2 int, IdPartida int, Descripcion3 varchar(max),
Autorizado decimal(18,4))
------------------------------------------------------------------------------------------------
Insert into @Anual4
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2, 
   CP.IdPartida, CP.DescripcionPartida as Descripcion3,
sum(isnull(TP.Autorizado,0)) as Autorizado
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

where  (Mes = 0) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo, CP.IdPartida, CP.DescripcionPartida
Order by  CG.IdCapitulo 
------------------------------------------------------------------------------------------------

Insert into @rptt4
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

If @AmpAnual = 1
	Begin

	Insert into @Anual4
	Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2, 
    CP.IdPartida, CP.DescripcionPartida as Descripcion3,
	sum(isnull(TP.Autorizado,0)) as Autorizado
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

	where  (Mes = 0) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
	Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo, CP.IdPartida, CP.DescripcionPartida
	Order by  CG.IdCapitulo 

		update r set r.Autorizado = a.Autorizado FROM @Anual4 a, @rptt4 r Where a.IdPartida = r.IdPartida
	End

	select * from @rptt4

END



Else if @Tipo=5  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Clasificación Funcional - Subfunción
--Valores Absolutos
declare @rptt5 as table(IdClave int, Descripcion varchar(max), IdClave2 int, Descripcion2 varchar(200), IdComp2 int, IdCpmp2a int, IdClave3 int, Descripcion3 varchar(max), IdComp3 int,
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
Deuda  decimal(18,4)
)

declare @Anual5 as table(IdClave int, Descripcion varchar(max), IdClave2 int, Descripcion2 varchar(200), IdComp2 int, IdCpmp2a int, IdClave3 int, Descripcion3 varchar(max), IdComp3 int,
Autorizado decimal(18,4))


Insert into @rptt5
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

If @AmpAnual = 1
	Begin

	Insert into @Anual5
	Select CFS.IdFinalidad as IdClave, CFS.Nombre as Descripcion, CF.Clave as IdClave2,  CF.Nombre as Descripcion2, CF.IdFinalidad as IdComp2, cf.IdFuncion as IdComp2a, CS.Clave as IdClave3, CS.Nombre  as Descripcion3, cs.IdFuncion as IdComp3,

	sum(isnull(TP.Autorizado,0)) as Autorizado
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

	where   (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
	group by CFS.IdFinalidad, CFS.Nombre, CF.Clave, CF.Nombre, CF.IdFinalidad , CS.Clave, CS.Nombre, cs.IdFuncion, cf.IdFuncion 
	Order By CF.Clave, CS.Clave

		update r set r.Autorizado = a.Autorizado FROM @Anual5 a, @rptt5 r Where a.IdClave3 = r.IdClave3
	End

	select * from @rptt5
END



Else if @Tipo=6  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Capítulo del Gasto -Unidad Responsable
--Valores Absolutos

declare @rptt6 as table(ClaveUR int, Nombre varchar(max), IdClave int, Descripcion varchar(200), Clave int,  Descripcion2 varchar(200), IdClave2 int, IdPartida int, Descripcion3 varchar(200),
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
Deuda  decimal(18,4)
)

declare @Anual6 as table(ClaveUR int, Nombre varchar(max), IdClave int, Descripcion varchar(200), Clave int,  Descripcion2 varchar(200), IdClave2 int, IdPartida int, Descripcion3 varchar(200),
Autorizado decimal(18,4)) 

Insert into @rptt6
Select CA.Clave  as ClaveUR , CA.Nombre,
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

If @AmpAnual = 1
	Begin

		Insert into @Anual6
		Select CA.Clave  as ClaveUR , CA.Nombre,
		CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  
		CP.IdPartida, CP.DescripcionPartida as Descripcion3,
		sum(isnull(TP.Autorizado,0)) as Autorizado 

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

		where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE =CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END 
		Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,CA.Clave  , CA.Nombre, CP.IdPartida, CP.DescripcionPartida
		Order by  CA.Clave  ,CG.IdCapitulo
		
		update r set r.Autorizado = a.Autorizado FROM @Anual6 a, @rptt6 r Where a.Clave = r.Clave and a.IdClave2 = r.IdClave2 and a.IdPartida = r.IdPartida
	End

	Select * from @rptt6
END



Else if @Tipo=7  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa
--Valores Absolutos
declare @rptt7 as table(Clave varchar(250), Descripcion varchar(250), 
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
Deuda  decimal(18,4)
)

declare @Anual7 as table(Clave varchar(250), Descripcion varchar(250), 
Autorizado decimal(18,4))

	IF @ClaveUR ='' AND @ClaveURHasta='' AND @IdPartida =''AND @IdPartidaHasta ='' BEGIN
	Insert into @rptt7
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

	Insert into @Anual7
	SELECT    CEPR.Clave, CEPR.Nombre as Descripcion, 
	sum(isnull(TP.Autorizado,0)) as Autorizado 
	               
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
	Where   (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end  
	AND CEPR.Nivel = '5' 
	GROUP BY CEPR.Clave, CEPR.Nombre
	ORDER BY CEPR.Clave

	END
	Else if @ClaveUR ='' AND @ClaveURHasta='' AND @IdPartida <>''AND @IdPartidaHasta <>''  
	BEGIN
	Insert into @rptt7
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

	Insert into @Anual7
	SELECT    CEPR.Clave, CEPR.Nombre as Descripcion, 
	sum(isnull(TP.Autorizado,0)) as Autorizado
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
	Where   (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end  
	AND CEPR.Nivel = '5' 
	And CP.IdPartida BETWEEN  @IdPartida AND @IdPartidaHasta
	GROUP BY CEPR.Clave, CEPR.Nombre
	ORDER BY CEPR.Clave
	END
	Else if @ClaveUR <>'' AND @ClaveURHasta<>'' AND @IdPartida =''AND @IdPartidaHasta ='' 
	BEGIN
	Insert into @rptt7
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

	Insert into @Anual7
	SELECT    CEPR.Clave, CEPR.Nombre as Descripcion, 
	sum(isnull(TP.Autorizado,0)) as Autorizado 
	                
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
	Where   (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end  
	AND CEPR.Nivel = '5' 
	AND CA.Clave BETWEEN  @ClaveUR AND @ClaveURHasta  
	GROUP BY CEPR.Clave, CEPR.Nombre
	ORDER BY CEPR.Clave

	END
	ELSE if @ClaveUR <>'' AND @ClaveURHasta<>'' AND @IdPartida <>''AND @IdPartidaHasta <>''
	BEGIN
	Insert into @rptt7
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

	Insert into @Anual7
	SELECT    CEPR.Clave, CEPR.Nombre as Descripcion, 
	sum(isnull(TP.Autorizado,0)) as Autorizado  
	                 
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
	Where   (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end  
	AND CEPR.Nivel = '5' 
	AND CA.Clave BETWEEN  @ClaveUR AND @ClaveURHasta  
	And CP.IdPartida BETWEEN  @IdPartida AND @IdPartidaHasta
	GROUP BY CEPR.Clave, CEPR.Nombre
	ORDER BY CEPR.Clave

	END
		If @AmpAnual = 1
		Begin
			update r set r.Autorizado = a.Autorizado FROM @Anual7 a, @rptt7 r Where a.Clave = r.Clave
		End

		select * from @rptt7
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
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Clasificación Geográfica
--Valores Absolutos
declare @rptt9 as table(Clave varchar(200), Descripcion varchar(max), 
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
Deuda  decimal(18,4)
)

declare @Anual9 as table(Clave varchar(200), Descripcion varchar(max), 
Autorizado decimal(18,4))

Insert into @rptt9
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

If @AmpAnual = 1
	Begin
	Insert into @Anual9
	Select  CC.Clave, CC.Descripcion,
	sum(isnull(TP.Autorizado,0)) as Autorizado

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

	where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio and Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
	AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END 
	AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
	AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END  

	group by CC.Clave,CC.Descripcion
	Order By CC.Clave

		update r set r.Autorizado = a.Autorizado FROM @Anual9 a, @rptt9 r Where a.Clave = r.Clave 
	End

	select * from @rptt9
END



Else if @Tipo=10 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Clasificación Geográfica - Económica
--Valores Absolutos
declare @rptt10 as table(IdClave varchar(200), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(200),
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
Deuda  decimal(18,4)
)

declare @Anual10 as table(IdClave varchar(200), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(200),
Autorizado decimal(18,4))

Insert into @rptt10
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

If @AmpAnual = 1
	Begin
	Insert into @Anual10
	Select CE.CLAVE as IdClave, CE.NOMBRE as Descripcion ,CC.Clave as Clave, CC.Descripcion as Descripcion2, 

	sum(isnull(TP.Autorizado,0)) as Autorizado  
	From T_PresupuestoNW  TP
	inner join T_SellosPresupuestales TS 
	on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
	inner join C_RamoPresupuestal  CR 
	on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
	left join  C_ClasificadorGeograficoPresupuestal CC
	on CC.IdClasificadorGeografico = TS.IdClasificadorGeografico
	left join  C_TipoGasto CE
	on CE.IDTIPOGASTO = TS.IdTipoGasto

	where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
	group by CC.Clave,CC.Descripcion,CE.CLAVE, CE.NOMBRE
	Order By CC.Clave

		update r set r.Autorizado = a.Autorizado FROM @Anual10 a, @rptt10 r Where a.IdClave = r.IdClave and a.Clave = r.Clave 
	End

	select * from @rptt10
END



Else if @Tipo=11
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Genérica 
--Valores Absolutos
declare @rptt11 as table(ClaveUR varchar(200), Nombre varchar(250), Clave int, Descripcion varchar(max),
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
Deuda  decimal(18,4)
)

declare @Anual11 as table(ClaveUR varchar(200), Nombre varchar(250), Clave int, Descripcion varchar(max),
Autorizado decimal(18,4))

Insert into @rptt11
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

If @AmpAnual = 1
	Begin
	Insert into @Anual11
	Select  CA.Clave as ClaveUR , CA.Nombre , CPG.IdPartidaGenerica as Clave , CPG.DescripcionPartida  as Descripcion, 
sum(isnull(TP.Autorizado,0)) as Autorizado

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

	where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end and CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
	group by CPG.IdPartidaGenerica , CPG.DescripcionPartida , CA.Clave  , CA.Nombre 
	Order By CA.Clave ,CPG.IdPartidaGenerica , CPG.DescripcionPartida

		update r set r.Autorizado = a.Autorizado FROM @Anual11 a, @rptt11 r Where a.ClaveUR = r.ClaveUR and a.Clave = r.Clave 
	End

	select * from @rptt11
END



Else if @Tipo=12
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Especifica 
--Valores Absolutos
declare @rptt12 as table(ClaveUR varchar(200), Nombre varchar(250), Clave int, Descripcion varchar(max),
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
Deuda  decimal(18,4)
)

declare @Anual12 as table(ClaveUR varchar(200), Nombre varchar(250), Clave int, Descripcion varchar(max),
Autorizado decimal(18,4))

Insert into @rptt12
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

If @AmpAnual = 1
	Begin
	Insert into @Anual12
	Select  CA.Clave as ClaveUR , CA.Nombre , CP.ClavePartida as Clave , CP.DescripcionPartida as Descripcion, 

sum(isnull(TP.Autorizado,0)) as Autorizado

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 
left join C_PartidasPres  CP 
on TS.IdPartida  = CP.IdPartida 

where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end and CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
group by CP.ClavePartida, CP.DescripcionPartida , CA.Clave  , CA.Nombre 
Order By CA.Clave ,CP.ClavePartida

		update r set r.Autorizado = a.Autorizado FROM @Anual12 a, @rptt12 r Where a.ClaveUR = r.ClaveUR and a.Clave = r.Clave  
	End

	select * from @rptt12
END


--Else if @Tipo=13  
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Capítulo del Gasto
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
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Capítulo del Gasto -Actividad Institucinal -UR
--Valores Absolutos

DECLARE @nombreAI varchar(255)
DECLARE @claveAI varchar(255)
declare @rptt13 as table(ClaveUR varchar(200), Nombre varchar(200), ClaveProy varchar(200), Proyecto varchar(250), idClave varchar(100), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(200), idClave2 varchar(100),
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
NombreAI varchar(150),
ClaveAI int
)

declare @Anual13 as table(ClaveUR varchar(200), Nombre varchar(200), ClaveProy varchar(200), Proyecto varchar(250), idClave varchar(100), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(200), idClave2 varchar(100),
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

If @AmpAnual = 1
	Begin
	Insert into @Anual13
	Select T1.ClaveUR, T1.Nombre, min(T1.ClaveProy)ClaveProy, Min(T1.Proyecto)Proyecto, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2, sum(T1.Autorizado)Autorizado 

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
	group by  T1.ClaveUR, T1.Nombre, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2
		update r set r.Autorizado = a.Autorizado FROM @Anual13 a, @rptt13 r Where a.ClaveUR = r.ClaveUR and a.ClaveProy = r.ClaveProy and a.Clave = r.Clave and a.idClave = r.idClave and a.idClave2 = r.idClave2
	End

	select * from @rptt13
END

Else if @Tipo=29
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Especifica 
--Valores Absolutos

--CA.Clave as ClaveUR , CA.Nombre ,
declare @rptt29 as table(Clave varchar(200), Descripcion varchar(max), 
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
Deuda  decimal(18,4)
)

declare @Anual29 as table(Clave varchar(200), Descripcion varchar(max), 
Autorizado decimal(18,4))

Insert into @rptt29
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

If @AmpAnual = 1
	Begin
		
	Insert into @Anual29
	Select  CP.ClavePartida as Clave , CP.DescripcionPartida as Descripcion, 

	sum(isnull(TP.Autorizado,0)) as Autorizado

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

	where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio and Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
	and CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END 
	AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
	AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END  
	group by CP.ClavePartida, CP.DescripcionPartida--, CA.Clave , CA.Nombre 
	Order By CP.ClavePartida

	update r set r.Autorizado = a.Autorizado FROM @Anual29 a, @rptt29 r Where a.Clave = r.Clave
	End

	select * from @rptt29
END

Else if @Tipo=31
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Genérica 
--Valores Absolutos

--CA.Clave as ClaveUR , CA.Nombre ,
declare @rptt31 as table(Clave int, Descripcion varchar(max),
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
Deuda  decimal(18,4)
) 

declare @Anual31 as table(Clave int, Descripcion varchar(max),
Autorizado decimal(18,4))

Insert into @rptt31
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

If @AmpAnual = 1
	Begin
	Insert into @Anual31
	Select  CPG.IdPartidaGenerica as Clave , CPG.DescripcionPartida  as Descripcion, 

sum(isnull(TP.Autorizado,0)) as Autorizado

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

	where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio and Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
	AND CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END 
	AND CPG.ClavePartida = CASE WHEN @IdPartida = 0 THEN CPG.ClavePartida else @IdPartida end   
	AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END   
	group by CPG.IdPartidaGenerica , CPG.DescripcionPartida --, CA.Clave  , CA.Nombre 
	Order By CPG.IdPartidaGenerica , CPG.DescripcionPartida

		update r set r.Autorizado = a.Autorizado FROM @Anual31 a, @rptt31 r Where a.Clave = r.Clave 
	End

	select * from @rptt31
END

-- ******************************** VALORES RELATIVOS ************************** --

Else if @Tipo=14
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO--Unidad Responsable
--Valores Relativos
declare @rptt14 as table(CveRamo varchar(200), DescripcionRamo varchar(250),CLAVE varchar(100), DESCRIPCION varchar(max),
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
Deuda  decimal(18,4)
)

declare @Anual14 as table(CveRamo varchar(200), DescripcionRamo varchar(250), CLAVE varchar(100), DESCRIPCION varchar(max),
Autorizado decimal(18,4))
------------------------------------------------------------------------------------------------
Insert into @Anual14
Select   CR.CLAVE as CveRamo , CR.DESCRIPCION as DescripcionRamo , CA.Clave as Clave , CA.Nombre  as Descripcion,

 sum(isnull(TP.Autorizado,0)) as Autorizado
 From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal CR
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 

where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
group by CR.CLAVE, CR.DESCRIPCION ,CA.Clave  , CA.Nombre
Order By CR.CLAVE
------------------------------------------------------------------------------------------------
Insert into @rptt14
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

If @AmpAnual = 1
	Begin
		update r set r.Autorizado = a.Autorizado FROM @Anual14 a, @rptt14 r Where a.CveRamo = r.CveRamo and a.Clave = r.Clave
	End

	select * from @rptt14

END



Else if @Tipo=15
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO--Ramo - Clasificador Económico
--Valores Relativos
declare @rptt15 as table(CLAVE varchar(100), DESCRIPCION varchar(max),
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
Deuda  decimal(18,4)
)

declare @Anual15 as table(CLAVE varchar(100), DESCRIPCION varchar(max),
Autorizado decimal(18,4))
------------------------------------------------------------------------------------------
Insert into @Anual15
Select CE.Clave,CE.NOMBRE as DESCRIPCION,
sum(isnull(TP.Autorizado,0)) as Autorizado

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_TipoGasto CE
on CE.IDTIPOGASTO = TS.IdTipoGasto 
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 

where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
group by CE.Clave,CE.NOMBRE 
Order By CE.Clave

------------------------------------------------------------------------------------------
Insert into @rptt15
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

If @AmpAnual = 1
	Begin
		update r set r.Autorizado = a.Autorizado FROM @Anual15 a, @rptt15 r Where a.Clave = r.Clave
	End

	select * from @rptt15
END



Else if @Tipo=16
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO--Clasificación Económica - Capítulo del Gasto
--Valores Relativos
declare @rptt16 as table(CLAVE varchar(100),IdCapitulo int, DESCRIPCION varchar(max),
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
Deuda  decimal(18,4)
)

declare @Anual16 as table(CLAVE varchar(100),IdCapitulo int, DESCRIPCION varchar(max),
Autorizado decimal(18,4))

------------------------------------------------------------------------------------------
Insert into @Anual16
Select  CE.Clave, CG.IdCapitulo, CG.Descripcion, 
 sum(isnull(TP.Autorizado,0)) as Autorizado  

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

where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
Group by CG.IdCapitulo, CG.Descripcion, CE.Clave 
Order by CE.Clave, CG.IdCapitulo 
------------------------------------------------------------------------------------------

Insert into @rptt16
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

	If @AmpAnual = 1
	Begin
		update r set r.Autorizado = a.Autorizado FROM @Anual16 a, @rptt16 r Where a.Clave = r.Clave and a.IdCapitulo = r.IdCapitulo
	End

	select * from @rptt16
END



Else if @Tipo=17 
BEGIN 
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Capítulo del Gasto
--Valores Relativos
declare @rptt17 as table(IdClave int, Descripcion varchar(max), Clave int, Descripcion2 varchar(200), IdClave2 int, IdPartida int, Descripcion3 varchar(max),
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
Deuda  decimal(18,4)
)

declare @Anual17 as table(IdClave int, Descripcion varchar(max), Clave int, Descripcion2 varchar(200), IdClave2 int, IdPartida int, Descripcion3 varchar(max),
Autorizado decimal(18,4))


Insert into @rptt17
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

If @AmpAnual = 1
	Begin
	Insert into @Anual17
	Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  
    CP.IdPartida, CP.DescripcionPartida as Descripcion3,
	sum(isnull(TP.Autorizado,0)) as Autorizado

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

	where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
	Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo, CP.IdPartida, CP.DescripcionPartida
	Order by  CG.IdCapitulo 
		update r set r.Autorizado = a.Autorizado FROM @Anual17 a, @rptt17 r Where a.Clave = r.Clave and a.IdPartida = r.IdPartida
	End

	select * from @rptt17
END



Else if @Tipo=18  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Clasificación Funcional - Subfunción
--Valores Relativos

declare @rptt18 as table(IdClave int, Descripcion varchar(max), IdClave2 int, Descripcion2 varchar(200), IdComp2 int, IdCpmp2a int, IdClave3 int, Descripcion3 varchar(max), IdComp3 int,
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
Deuda  decimal(18,4)
)

declare @Anual18 as table(IdClave int, Descripcion varchar(max), IdClave2 int, Descripcion2 varchar(200), IdComp2 int, IdCpmp2a int, IdClave3 int, Descripcion3 varchar(max), IdComp3 int,
Autorizado decimal(18,4))

Insert into @rptt18
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

If @AmpAnual = 1
	Begin
		
	Insert into @Anual18
	Select CFS.IdFinalidad as IdClave, CFS.Nombre as Descripcion, CF.Clave as IdClave2,  CF.Nombre as Descripcion2, CF.IdFinalidad as IdComp2, cf.IdFuncion as IdComp2a, CS.Clave as IdClave3, CS.Nombre  as Descripcion3, cs.IdFuncion as IdComp3,

	 sum(isnull(TP.Autorizado,0)) as Autorizado
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

	where   (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
	group by CFS.IdFinalidad, CFS.Nombre, CF.Clave, CF.Nombre, CF.IdFinalidad , CS.Clave, CS.Nombre, cs.IdFuncion, cf.IdFuncion 
	Order By CF.Clave, CS.Clave

	update r set r.Autorizado = a.Autorizado FROM @Anual18 a, @rptt18 r Where a.IdClave3 = r.IdClave3
	End

	select * from @rptt18
END



Else if @Tipo=19 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Capítulo del Gasto -Unidad Responsable
--Valores Relativos
declare @rptt19 as table(ClaveUR int, Nombre varchar(max),IdClave int, Descripcion varchar(max), Clave int, Descripcion2 varchar(200), IdClave2 int, IdPartida int, Descripcion3 varchar(max),
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
Deuda  decimal(18,4)
)

declare @Anual19 as table(ClaveUR int, Nombre varchar(max),IdClave int, Descripcion varchar(max), Clave int, Descripcion2 varchar(200), IdClave2 int, IdPartida int, Descripcion3 varchar(max),
Autorizado decimal(18,4))

Insert into @rptt19
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

If @AmpAnual = 1
	Begin
		
	Insert into @Anual19
	Select CA.Clave  as ClaveUR , CA.Nombre ,
	CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  
	CP.IdPartida, CP.DescripcionPartida as Descripcion3,
    
	sum(isnull(TP.Autorizado,0)) as Autorizado

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

	where  (Mes BETWEEN 1 AND 12) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE =CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END    
	Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,CA.Clave, CA.Nombre, CP.IdPartida, CP.DescripcionPartida
	Order by  CA.Clave  ,CG.IdCapitulo 

	update r set r.Autorizado = a.Autorizado FROM @Anual19 a, @rptt19 r Where a.IdPartida = r.IdPartida
	End

	select * from @rptt19
END



Else if @Tipo=20
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa
--Valores Relativos
declare @rptt20 as table(Clave varchar(200), Descripcion varchar(200), 
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
Deuda  decimal(18,4)
)

declare @Anual20 as table(Clave varchar(200), Descripcion varchar(200), 
Autorizado decimal(18,4))

Insert into @rptt20
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

If @AmpAnual = 1
	Begin
		
	Insert into @Anual20
	 SELECT    CEPR.Clave, CEPR.Nombre as Descripcion, 

	sum(isnull(TP.Autorizado,0)) as Autorizado

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

	Where   (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio  AND Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end  AND CEPR.Nivel = '5' 
	GROUP BY CEPR.Clave, CEPR.Nombre
	ORDER BY CEPR.Clave

	update r set r.Autorizado = a.Autorizado FROM @Anual20 a, @rptt20 r Where a.Clave = r.Clave
	End

	select * from @rptt20
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
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Clasificación Geográfica
--Valores Relativos
declare @rptt22 as table(Clave varchar(200), Descripcion varchar(max), 
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
Deuda  decimal(18,4)
)

declare @Anual22 as table(Clave varchar(200), Descripcion varchar(max), 
Autorizado decimal(18,4))

Insert into @rptt22
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

If @AmpAnual = 1
	Begin
	Insert into @Anual22
		Select  CC.Clave, CC.Descripcion,

		 sum(isnull(TP.Autorizado,0)) as Autorizado 

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

		where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio  and Year=@Ejercicio 
		AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
		AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END 
		AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
		AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END
 
		group by CC.Clave,CC.Descripcion
		Order By CC.Clave

		update r set r.Autorizado = a.Autorizado FROM @Anual22 a, @rptt22 r Where a.Clave = r.Clave 
	End

	select * from @rptt22
END



Else if @Tipo=23 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Clasificación Geográfica - Económica
--Valores Relativos
declare @rptt23 as table(IdClave varchar(200), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(200),
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
Deuda  decimal(18,4)
)

declare @Anual23 as table(IdClave varchar(200), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(200),
Autorizado decimal(18,4))

Insert into @rptt23
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

If @AmpAnual = 1
	Begin
	Insert into @Anual23
	Select  CE.CLAVE as IdClave, CE.NOMBRE as Descripcion ,CC.Clave, CC.Descripcion as Descripcion2, 

 sum(isnull(TP.Autorizado,0)) as Autorizado 

	From T_PresupuestoNW  TP
	inner join T_SellosPresupuestales TS 
	on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
	inner join C_RamoPresupuestal  CR 
	on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
	left join  C_ClasificadorGeograficoPresupuestal CC
	on CC.IdClasificadorGeografico = TS.IdClasificadorGeografico
	left join  C_TipoGasto CE
	on CE.IDTIPOGASTO = TS.IdTipoGasto

	where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
	group by CC.Clave,CC.Descripcion,CE.CLAVE, CE.NOMBRE
	Order By CC.Clave

		update r set r.Autorizado = a.Autorizado FROM @Anual23 a, @rptt23 r Where a.IdClave = r.IdClave and a.Clave = r.Clave 
	End

	select * from @rptt23
END



Else if @Tipo=24 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Genérica 
--Valores Relativos
declare @rptt24 as table(ClaveUR varchar(200), Nombre varchar(250), Clave int, Descripcion varchar(max),
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
Deuda  decimal(18,4)
)

declare @Anual24 as table(ClaveUR varchar(200), Nombre varchar(250), Clave int, Descripcion varchar(max),
Autorizado decimal(18,4))

Insert into @rptt24
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

If @AmpAnual = 1
	Begin
	Insert into @Anual24
	Select  CA.Clave as ClaveUR  , CA.Nombre , CPG.IdPartidaGenerica  as Clave , CPG.DescripcionPartida as Descripcion , 

 sum(isnull(TP.Autorizado,0)) as Autorizado

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

	where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end and CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
	group by CPG.IdPartidaGenerica , CPG.DescripcionPartida , CA.Clave  , CA.Nombre 
	Order By CA.Clave ,CPG.IdPartidaGenerica , CPG.DescripcionPartida

		update r set r.Autorizado = a.Autorizado FROM @Anual24 a, @rptt24 r Where a.ClaveUR = r.ClaveUR and a.Clave = r.Clave 
	End

	select * from @rptt24
END



Else if @Tipo=25
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Especifica 
--Valores Relativos
declare @rptt25 as table(ClaveUR varchar(200), Nombre varchar(250), Clave int, Descripcion varchar(max),
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
Deuda  decimal(18,4)
)

declare @Anual25 as table(ClaveUR varchar(200), Nombre varchar(250), Clave int, Descripcion varchar(max),
Autorizado decimal(18,4))

Insert into @rptt25
Select  CA.Clave as ClaveUR , CA.Nombre , CP.ClavePartida as Clave , CP.DescripcionPartida as Descripcion, 

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

If @AmpAnual = 1
	Begin
	Insert into @Anual25
	Select  CA.Clave as ClaveUR , CA.Nombre , CP.ClavePartida as Clave , CP.DescripcionPartida as Descripcion, 

 sum(isnull(TP.Autorizado,0)) as Autorizado  


From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join  C_AreaResponsabilidad CA
on TS.IdAreaResp = CA.IdAreaResp and CR.IDRAMOPRESUPUESTAL = CA.IdRamoPresupuestal 
left join C_PartidasPres  CP 
on TS.IdPartida  = CP.IdPartida 

where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio  and Year=@Ejercicio AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end and CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
group by CP.ClavePartida, CP.DescripcionPartida , CA.Clave  , CA.Nombre 
Order By CA.Clave ,CP.ClavePartida

		update r set r.Autorizado = a.Autorizado FROM @Anual25 a, @rptt25 r Where a.ClaveUR = r.ClaveUR and a.Clave = r.Clave 
	End

	select * from @rptt25

END


--Else if @Tipo=23  
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Capítulo del Gasto -UR
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
declare @rptt26 as table(ClaveUR varchar(200), Nombre varchar(200), ClaveProy varchar(200), Proyecto varchar(250), idClave varchar(100), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(200), idClave2 varchar(100),
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
NombreAI varchar(150),
ClaveAI int
)

declare @Anual26 as table(ClaveUR varchar(200), Nombre varchar(200), ClaveProy varchar(200), Proyecto varchar(250), idClave varchar(100), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(200), idClave2 varchar(100),
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

Else if @Tipo=27 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Capítulo del Gasto -Actividad Institucinal -UR
--Valores Absolutos

declare @rptt27 as table(ClaveUR varchar(200), Nombre varchar(200), ClaveProy varchar(200), Proyecto varchar(250), idClave varchar(100), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(200), idClave2 varchar(100),
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
NombreAI varchar(150),
ClaveAI varchar(200)
)

declare @Anual27 as table(ClaveUR varchar(200), Nombre varchar(200), ClaveProy varchar(200), Proyecto varchar(250), idClave varchar(100), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(200), idClave2 varchar(100),
Autorizado decimal(18,4))

Insert into @rptt27
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

If @AmpAnual = 1
	Begin
	Insert into @Anual27
	Select T1.ClaveUR, T1.Nombre, min(T1.ClaveProy)ClaveProy, Min(T1.Proyecto)Proyecto, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2, sum(T1.Autorizado)Autorizado 
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
	group by T1.ClaveAI, T1.NombreAI, T1.ClaveUR, T1.Nombre, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2

		update r set r.Autorizado = a.Autorizado FROM @Anual27 a, @rptt27 r Where a.ClaveUR = r.ClaveUR and a.ClaveProy = r.ClaveProy and a.Clave = r.Clave and a.idClave = r.idClave and a.idClave2 = r.idClave2 
	End

	select * from @rptt27
END

Else if @Tipo=28  
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Programa -Capítulo del Gasto -Actividad Institucinal -UR
--Valores Relativos

declare @rptt28 as table(ClaveUR varchar(200), Nombre varchar(200), ClaveProy varchar(200), Proyecto varchar(250), idClave varchar(100), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(200), idClave2 varchar(100),
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
NombreAI varchar(150),
ClaveAI varchar(200)
)

declare @Anual28 as table(ClaveUR varchar(200), Nombre varchar(200), ClaveProy varchar(200), Proyecto varchar(250), idClave varchar(100), Descripcion varchar(max), Clave varchar(200), Descripcion2 varchar(200), idClave2 varchar(100),
Autorizado decimal(18,4))

Insert into @rptt28
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

If @AmpAnual = 1
	Begin
	Insert into @Anual28
	Select T1.ClaveUR, T1.Nombre, min(T1.ClaveProy)ClaveProy, Min(T1.Proyecto)Proyecto, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2, sum(T1.Autorizado)Autorizado 
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

	where  (Mes BETWEEN  1 AND 12) AND LYear=2018 and Year=2018 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
	AND CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END   
	AND CEPR.Id = CASE WHEN @IdEP = '' THEN CEPR.ID ELSE @IdEP END  AND CEPR.Nivel = '5' 
	AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
	AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END

	Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,CA.Clave , CA.Nombre,CEPR.Clave, CEPR.Nombre, CEPR.Id
	Order by  CEPR.Clave, CA.Clave ,CG.IdCapitulo) as T1
	group by  T1.NombreAI, T1.ClaveAI, T1.ClaveUR, T1.Nombre, T1.idClave, T1.Descripcion, T1.Clave, T1.Descripcion2, T1.idClave2

		update r set r.Autorizado = a.Autorizado FROM @Anual28 a, @rptt28 r Where a.ClaveUR = r.ClaveUR and a.ClaveProy = r.ClaveProy and a.Clave = r.Clave and a.idClave = r.idClave and a.idClave2 = r.idClave2
	End

	select * from @rptt28

END

Else if @Tipo=30
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Especifica 
--Valores Relativos
--CA.Clave as ClaveUR , CA.Nombre ,

declare @rptt30 as table(Clave varchar(200), Descripcion varchar(max), 
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
Deuda  decimal(18,4)
)

declare @Anual30 as table(Clave varchar(200), Descripcion varchar(max), 
Autorizado decimal(18,4))

Insert into @rptt30
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

If @AmpAnual = 1
	Begin
	Insert into @Anual30
	Select CP.ClavePartida as Clave , CP.DescripcionPartida as Descripcion , 

 sum(isnull(TP.Autorizado,0)) as Autorizado 

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

	where  (Mes BETWEEN 1 AND 12) AND LYear=@Ejercicio  and Year=@Ejercicio 
	AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
	and CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
	AND CP.IdPartida = CASE WHEN @IdPartida = 0 THEN CP.IdPartida ELSE @IdPartida END
	AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END   
	group by CP.ClavePartida, CP.DescripcionPartida-- , CA.Clave  , CA.Nombre 
	Order By CP.ClavePartida

		update r set r.Autorizado = a.Autorizado FROM @Anual30 a, @rptt30 r Where a.Clave = r.Clave 
	End

	select * from @rptt30
END


Else if @Tipo=32 
BEGIN
--Consulta para INFORME ADMINISTRATIVO SOBRE EL ESTADO DEL EJERCICIO DEL PRESUPUESTO --Unidad Responsable - Partida Genérica 
--Valores Relativos

--CA.Clave as ClaveUR  , CA.Nombre ,
declare @rptt32 as table(Clave varchar(200), Descripcion varchar(max),
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
Deuda  decimal(18,4)
) 

declare @Anual32 as table(Clave varchar(200), Descripcion varchar(max),
Autorizado decimal(18,4))

Insert into @rptt32
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

If @AmpAnual = 1
	Begin
	Insert into @Anual32
	Select  CPG.IdPartidaGenerica  as Clave , CPG.DescripcionPartida as Descripcion, 
 sum(isnull(TP.Autorizado,0)) as Autorizado

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

where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio  and Year=@Ejercicio 
AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end 
AND CA.Clave  = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
AND CPG.ClavePartida = CASE WHEN @IdPartida = 0 THEN CPG.ClavePartida else @IdPartida end   
AND CFF.CLAVE = CASE WHEN @ClaveFF = '' THEN CFF.CLAVE ELSE @ClaveFF END   
group by CPG.IdPartidaGenerica , CPG.DescripcionPartida-- , CA.Clave  , CA.Nombre 
Order By CPG.IdPartidaGenerica , CPG.DescripcionPartida

		update r set r.Autorizado = a.Autorizado FROM @Anual32 a, @rptt32 r Where a.Clave = r.Clave 
	End

	select * from @rptt32
END
End 



GO

