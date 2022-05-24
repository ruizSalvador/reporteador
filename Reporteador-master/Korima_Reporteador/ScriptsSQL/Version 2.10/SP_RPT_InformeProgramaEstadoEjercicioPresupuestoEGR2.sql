
/****** Object:  StoredProcedure [dbo].[SP_RPT_InformeProgramaEstadoEjercicioPresupuestoEGR]    Script Date: 25/Jul/2014 13:40 ******/
/****** Ing. Alvirde. Modificacion para aceptar unidad responsable y programa sin especificar. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_InformeProgramaEstadoEjercicioPresupuestoEGR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_InformeProgramaEstadoEjercicioPresupuestoEGR]
GO
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

	If @Tipo = 3 
	BEGIN
		--Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica
		--Valores Absolutos

		DECLARE @TResultadoFinal_3 as table (
		Clave1 varchar(8), 
		Descripcion varchar(150), 
		Clave2 varchar(8), 
		Descripcion2 varchar(150),
		Clave3 varchar(8), 
		NombreAI varchar(150), 
		Clave3a varchar(8), 
		Descripcion3a varchar(150), 
		Clave4 varchar(8), 
		Descripcion4 varchar(150),
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
	                
		INSERT INTO @TResultadoFinal_3 (Clave1,	Descripcion, Clave2, Descripcion2, Clave3, NombreAI, Clave3a, Descripcion3a, Clave4, Descripcion4, Id,
		Clave5, Descripcion3, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido,
		PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual,
		PorcAprobadocAnt, NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente) 

		Select   C_RamoPresupuestal.CLAVE as Clave1, 
		C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
		C_EP_Ramo.Clave AS Clave2, 
		C_EP_Ramo.Nombre as Descripcion2,
		-- 
		(SELECT tablaID.Clave FROM
		(select * from C_EP_Ramo as T1 where id = C_EP_Ramo.id and Nivel = 5) tablaID
		inner join (select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as Clave3,
		-- 	
		(SELECT tablaID.nombre 	FROM
		(select * from C_EP_Ramo as T1 where T1.id = C_EP_Ramo.id and Nivel = 5) tablaID
		inner join 	(select * from C_EP_Ramo as T2 where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as NombreAI,
		-- 
		C_CapitulosNEP.IdCapitulo as Clave3a, 
		C_CapitulosNEP.Descripcion as Descripcion3a, 
		C_ConceptosNEP.IdConcepto  as Clave4,  
		C_ConceptosNEP.Descripcion as Descripcion4, 
		C_EP_Ramo.Id, C_TipoGasto.Clave as Clave5, 
		C_TipoGasto.NOMBRE as Descripcion3, 
		sum(isnull(TP.Autorizado,0)) as Autorizado,  
		(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
		(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
		(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
		 0,--sum(isnull(TP.Precomprometido,0)) AS PreComprometido,	      
		 0,--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0)) as PresVigSinPreComp,
		 0,--sum(isnull(TP.Comprometido,0)) as Comprometido, 
		 0,--sum(isnull(TP.Precomprometido,0))- sum(isnull(TP.Comprometido,0)) as PreCompSinComp,
		0,--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As PresDispComp,
		 sum(isnull(TP.Devengado,0)) as Devengado, 
		 0,--sum(isnull(TP.Comprometido,0)) - sum(isnull(TP.Devengado ,0)) As CompSinDev,
		0,--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Devengado,0))  AS PresSinDev,
		 0,--sum(isnull(TP.Ejercido,0)) as Ejercido,
		 0,--sum(isnull(TP.Devengado,0))- sum(isnull(TP.Ejercido,0) )  AS DevSinEjer,
		 sum(isnull(TP.Pagado,0)) as Pagado, 
		 0,--sum(isnull(TP.Ejercido,0))- sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
		 0,--sum(isnull(TP.Devengado,0)) -  sum(isnull(TP.Pagado,0) ) AS Deuda,
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
		where  (Mes BETWEEN @Mes and @Mes2) 
		AND LYear=@Ejercicio 
		and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE 
			else @Clave end  and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE 
			else @Clave2 end )  
		AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end 
		Group by C_CapitulosNEP.IdCapitulo, C_CapitulosNEP.Descripcion, C_TipoGasto.Clave ,C_TipoGasto.NOMBRE,C_EP_Ramo.Clave,C_EP_Ramo.Id,
		C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE ,C_RamoPresupuestal.DESCRIPCION, C_ConceptosNEP.IdConcepto, C_ConceptosNEP.Descripcion 
		Order by C_TipoGasto.Clave, C_CapitulosNEP.IdCapitulo ,C_RamoPresupuestal.CLAVE
		 
		--Columna 1 PorcAprobAnual
		declare @TPorcAprobAnual_3_1 as Table(PAutorizado1 decimal(15,2), Clave int, ID Int)
		--insert into @TPorcAprobAnual_3_1
		--Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		----left join @resultadoFinal3 ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		--and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE, cepr.Id
		
		declare @TPorcAprobAnual_3_2 as Table(PAutorizado2 decimal(15,2), Clave int, ID Int)	
		--insert into @TPorcAprobAnual_3_2
		--Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		----left join @resultadoFinal3 	ON  Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		--and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE, cepr.Id  
		
		--Columna2 PorcAprobadocAnt
		declare @TPorcAprobadocAnt_3_1 as Table(PorcAprobadocAnt1 decimal(15,2), Clave int, ID Int)
		--insert Into @TPorcAprobadocAnt_3_1
		--Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE,  cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		----left join @resultadoFinal3 ON Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		--and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE,  cepr.Id   
		
		declare @TPorcAprobadocAnt_3_2 as Table(PorcAprobadocAnt2 decimal(15,2), Clave int, ID Int)
		--insert Into @TPorcAprobadocAnt_3_2
		--Select sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2,  cr.CLAVE,  cepr.Id 
		--FROM T_SellosPresupuestales 
		--INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
		--INNER JOIN C_TipoGasto ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		----left join @resultadoFinal3 ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE,  cepr.Id 
		
		--Columna 3 y 4 NomAprobado
		declare @TNomAprobado_3_1 as Table(NomAprobado1 decimal(15,2), Clave int, ID Int)
		--insert Into @TNomAprobado_3_1
		--Select sum(isnull(tp.Autorizado,0)) as NomAprobado1, cr.CLAVE,  cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		----left join @resultadoFinal3 	ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		--and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE,  cepr.Id
		
		declare @TNomAprobado_3_2 as Table(NomAprobado2 decimal(15,2), Clave int, ID Int)
		--insert Into @TNomAprobado_3_2
		--Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE,  cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
		--INNER JOIN C_TipoGasto ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		----left join @resultadoFinal3 	ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE,  cepr.Id  
		
		
		--Columna 5 PorcPVigenteAnual
		declare @TPorcPVigenteAnual_3_1 as Table(PorcPVigenteAnual1 decimal(15,2), Clave int, ID Int)
	--	insert Into @TPorcPVigenteAnual_3_1
	--	Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
	--	+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE,  cepr.Id 
	--	FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
	--	INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_TipoGasto
	--	ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
	--	INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo
	--	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
	----	left join @resultadoFinal3 ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
	--	where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
	--	group by cr.CLAVE,  cepr.Id 

		declare @TPorcPVigenteAnual_3_2 as Table(PorcPVigenteAnual2 decimal(15,2), Clave int, ID Int)
		--insert Into @TPorcPVigenteAnual_3_2
		--Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		--+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE,  cepr.Id 
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres  
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		----left join @resultadoFinal3 ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		--group by cr.CLAVE,  cepr.Id  
		 
		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_3_1 as Table(PorcPVigenteAnt1 decimal(15,2), Clave Int, ID Int)
		--insert into @TPorcPVigenteAnt_3_1
		--Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		--+ sum(ISNULL(TP.TransferenciaRed,0)))) PorcPVigenteAnt1,  cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
		--INNER JOIN C_TipoGasto 	ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr 	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		----left join @resultadoFinal3 	ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		--group by cr.CLAVE, cepr.Id 
		
		Declare @TPorcPVigenteAnt_3_2 as Table(PorcPVigenteAnt2 decimal(15,2), Clave Int, ID Int)
		--insert into @TPorcPVigenteAnt_3_2
		--Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		--+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		----left join @resultadoFinal3 	ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE,  cepr.Id  
		
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_3_1 as Table(NomPVigente1 decimal(15,2), Clave Int, ID Int)
		--insert into @TNomPVigente_3_1
		--Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		--+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE,  cepr.Id 
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		----left join @resultadoFinal3	ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE,  cepr.Id
		
		Declare @TNomPVigente_3_2 as Table(NomPVigente2 decimal(15,2), Clave Int, ID Int)
		--insert into @TNomPVigente_3_2
		--Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		--+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE,  cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		----left join @resultadoFinal3 	ON   Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE, cepr.Id 
		
		Select 
		Clave1,	
		Descripcion, 
		Clave2, 
		Descripcion2, 
		Clave3, 
		Clave3a, 
		Descripcion3a, 
		Clave4, 
		Descripcion4, 
		Clave5, 
		Descripcion3, 
		Sum(Autorizado)Autorizado, 
		sum(TransferenciaAmp)-abs(sum(TransferenciaRed))TransferenciaAmp, 
		sum(TransferenciaRed)TransferenciaRed, 
		Sum(Autorizado)+(sum(TransferenciaAmp)-abs(sum(TransferenciaRed))) Modificado, --Sum(Modificado)Modificado, 
		Sum(PreComprometido)PreComprometido, 
		sum(PresVigSinPreComp)PresVigSinPreComp, 
		sum(Comprometido)Comprometido, 
		SUM(PreCompSinComp)PreCompSinComp, 
		sum(PresDispComp)PresDispComp, 
		sum(Devengado)Devengado, 
		sum(CompSinDev)CompSinDev, 
		sum(PresSinDev)PresSinDev, 
		sum(Ejercido)Ejercido, 
		Sum(DevSinEjer)DevSinEjer, 
		sum(Pagado)Pagado, 
		(Sum(Autorizado)+(sum(TransferenciaAmp)-abs(sum(TransferenciaRed))))- (sum(Devengado))EjerSinPagar, --sum(EjerSinPagar)EjerSinPagar, 
		sum(Deuda)Deuda,
		sum(cast(CASE WHEN isnull(PAutorizado1,0) = 0 THEN 0 ELSE PAutorizado2/ PAutorizado1 END as Decimal(15,2))) PorcAprobAnual,
		avg(cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2))) PorcAprobadocAnt,
		sum(cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2))) as NomAprobado,
		avg(cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2))) PorcPVigenteAnual,
		avg(cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2))) PorcPVigenteAnt,
		sum(cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2))) NomPVigente 
		from @TResultadoFinal_3 as TResultadoFinal 
		left outer join @TPorcAprobAnual_3_1 as TPorcAprobAnual1 
		on TResultadoFinal.id = TPorcAprobAnual1.ID 
		left outer join @TPorcAprobAnual_3_2 as TPorcAprobAnual2 
		on TPorcAprobAnual2.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_3_1 as TPorcAprobadocAnt1 
		on TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_3_2 as TPorcAprobadocAnt2 
		on TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_3_1 as TNomAprobado1 
		on TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_3_2 as TNomAprobado2 
		on TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_3_1 as TPorcPVigenteAnual1 
		on TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_3_2 as TPorcPVigenteAnual2 
		on TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_3_1 as TPorcPVigenteAnt1 
		on TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_3_2 as TPorcPVigenteAnt2 
		on TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_3_1 as TNomPVigente1 
		on TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_3_2 as TNomPVigente2 
		on TNomPVigente2.ID = TResultadoFinal.id
		group by Clave1,	Descripcion, Clave2, Descripcion2, Clave3, Clave3a, Descripcion3a, Clave4, Descripcion4, Clave5, Descripcion3
		order by cast(clave2 as int),cast(clave4 as int)
		
	END

	If @Tipo = 12 
	BEGIN
		--Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica
		--Valores Relativos

		DECLARE @TResultadoFinalR_12 as table (Clave1 varchar(8), Descripcion varchar(150), Clave2 varchar(8),	Descripcion2 varchar(150), Clave3 varchar(8),
		NombreAI varchar(150), Clave3a varchar(8), Descripcion3a varchar(150), Clave4 varchar(8), Descripcion4 varchar(150), Id varchar(8), Clave5 varchar(8),
		Descripcion3 varchar(150), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), Modificado decimal(15,2), 
		PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2),	Comprometido decimal(15,2), PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), 
		Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2), Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), 
		EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2), PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2),
		PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))
		
		INSERT INTO @TResultadoFinalR_12 (Clave1, Descripcion,	Clave2,	Descripcion2, Clave3, NombreAI,	Clave3a, Descripcion3a,	Clave4, Descripcion4, Id,
		Clave5, Descripcion3, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, 
		PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual,	PorcAprobadocAnt,
		NomAprobado, PorcPVigenteAnual,	PorcPVigenteAnt, NomPVigente)

		Select   C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, C_EP_Ramo.Clave AS Clave2, C_EP_Ramo.Nombre as Descripcion2,
		(SELECT tablaID.Clave  FROM
		(select top 1 * from C_EP_Ramo as T12 where T12.Id = C_EP_Ramo.ID and Nivel = 5) tablaID
		inner join	(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as Clave3, 
		(SELECT top 1 tablaID.nombre FROM
		(select * from C_EP_Ramo as T12 where T12.Id = C_EP_Ramo.ID and Nivel = 5) tablaID
		inner join 	(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as NombreAI, 
		C_CapitulosNEP.IdCapitulo as Clave3a, C_CapitulosNEP.Descripcion as Descripcion3a, 
		C_ConceptosNEP.IdConcepto  as Clave4,  C_ConceptosNEP.Descripcion as Descripcion4, 
		C_EP_Ramo.Id, C_TipoGasto.Clave as Clave5, C_TipoGasto.NOMBRE as Descripcion3, 
		sum(isnull(TP.Autorizado,0)) as Autorizado,  
		(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
		(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
		(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,
		 0,--sum(isnull(TP.Precomprometido,0) ) AS PreComprometido,      	
		0,--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Precomprometido,0))as PresVigSinPreComp,
		 0,--sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0)) as Comprometido, 	
		 0,--sum(isnull(TP.Precomprometido,0)) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado,0) )) As PreCompSinComp,
		0,--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) As PresDispComp,	
		 0,--sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0)) as Devengado, 	
		0,--(sum(isnull(TP.Comprometido,0))- sum(isnull(TP.Devengado ,0))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) As CompSinDev,
		0,--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) ))  AS PresSinDev,
		 0,--sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ) as Ejercido,
		0,--(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido,0) )) - (sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) ))  AS DevSinEjer,
		 sum(isnull(TP.Pagado,0)) as Pagado, 
		0,--(sum(isnull(TP.Ejercido,0)) - sum (isnull(TP.Pagado,0) )) - sum(isnull(TP.Pagado,0))  AS EjerSinPagar,
		0,--(sum(isnull(TP.Devengado,0)) - sum(isnull(TP.Ejercido ,0))) -  sum(isnull(TP.Pagado,0)) AS Deuda  , 
		 0,0,0,0,0,0
		 FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP ON  C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo	INNER JOIN C_EP_Ramo 
		ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto 
		where  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end  and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end )  AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end 
		Group by C_CapitulosNEP.IdCapitulo, C_CapitulosNEP.Descripcion, C_TipoGasto.Clave ,C_TipoGasto.NOMBRE,C_EP_Ramo.Clave,C_EP_Ramo.Id,C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE ,C_RamoPresupuestal.DESCRIPCION ,
		C_ConceptosNEP.IdConcepto, C_ConceptosNEP.Descripcion 
		Order by C_TipoGasto.Clave, C_CapitulosNEP.IdCapitulo ,C_RamoPresupuestal.CLAVE
		
		--Columna 1 PorcAprobAnual
		declare @TPorcAprobAnual_12_1 as Table(PorcAprobAnual1 decimal(15,2), Clave int, ID Int)
		--insert into @TPorcAprobAnual_12_1
		--Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		--left join @TResultadoFinalR_12 as T12 ON t12.ID = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= 
		--case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE, cepr.Id 

		declare @TPorcAprobAnual_12_2 as Table(PorcAprobAnual2 decimal(15,2), Clave int, ID Int)
		--insert into @TPorcAprobAnual_12_2
		--Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		--left join @TResultadoFinalR_12 as T12 ON t12.ID = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= 
		--case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE, cepr.Id
		
		--Columna 2 PorcAprobadocAnt
		declare @TPorcAprobadocAnt_12_1 as Table(PorcAprobadocAnt1 decimal(15,2), Clave int, ID Int)
		--insert into @TPorcAprobadocAnt_12_1
		--Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		--left join @TResultadoFinalR_12 as T12 ON t12.ID = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE,  cepr.Id  
		
		declare @TPorcAprobadocAnt_12_2 as Table(PorcAprobadocAnt2 decimal(15,2), Clave int, ID Int)
		--insert into @TPorcAprobadocAnt_12_2
		--Select sum(isnull(tp.Autorizado,0))  as PorcAprobadocAnt2, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		--left join @TResultadoFinalR_12 as T12 ON t12.ID = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE,  cepr.Id 
		
		--Columna 3 y 4 NomAprobado
		declare @TNomAprobado_12_1 as Table(NomAprobado1 decimal(15,2), Clave int, ID Int)
		--insert into @TNomAprobado_12_1
		--Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		--left join @TResultadoFinalR_12 as T12 ON t12.ID = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE,  cepr.Id
		
		declare @TNomAprobado_12_2 as Table(NomAprobado2 decimal(15,2), Clave int, ID Int)
		--insert into @TNomAprobado_12_2
		--Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		--left join @TResultadoFinalR_12 as T12 ON t12.ID = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE,  cepr.Id 
		
		--Columna 5 PorcPVigenteAnual
		declare @TPorcPVigenteAnual_12_1 as Table(PorcPVigenteAnual1 decimal(15,2), Clave int, ID Int)
		--insert into @TPorcPVigenteAnual_12_1
		--Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		--+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnual1, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		--left join @TResultadoFinalR_12 as T12 ON t12.ID = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= 
		--case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE,  cepr.Id 

		declare @TPorcPVigenteAnual_12_2 as Table(PorcPVigenteAnual2 decimal(15,2), Clave int, ID Int)
		--insert into @TPorcPVigenteAnual_12_2
		--Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		--+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		--left join @TResultadoFinalR_12 as T12 ON t12.ID = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		--and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		--group by cr.CLAVE,  cepr.Id 
		
		--Columna 6 PorcPVigenteAnt
		declare @TPorcPVigenteAnt_12_1 as Table(PorcPVigenteAnt1 decimal(15,2), Clave int, ID Int)
		--insert into @TPorcPVigenteAnt_12_1
		--Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) 
		--- (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		--left join @TResultadoFinalR_12 as T12 ON t12.ID = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		--and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		--group by cr.CLAVE, cepr.Id
		
		declare @TPorcPVigenteAnt_12_2 as Table(PorcPVigenteAnt2 decimal(15,2), Clave int, ID Int)
		--insert into @TPorcPVigenteAnt_12_2
		--Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		--+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto   INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		--left join @TResultadoFinalR_12 as T12 ON t12.ID = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		--and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE,  cepr.Id 
		
		--Columna 7 y 8 NomPVigente
		declare @TNomPVigente_12_1 as Table(NomPVigente1 decimal(15,2), Clave int, ID Int)
		--insert into @TNomPVigente_12_1
		--Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		--+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		--left join @TResultadoFinalR_12 as T12 ON t12.ID = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE,  cepr.Id 
		
		declare @TNomPVigente_12_2 as Table(NomPVigente2 decimal(15,2), Clave int, ID Int)
		--insert into @TNomPVigente_12_2
		--Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		--+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, cepr.Id
		--FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		--INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		--ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto INNER JOIN C_PartidasPres 
		--ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		--INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		--left join @TResultadoFinalR_12 as T12 ON t12.ID = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		--where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		--and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		--group by cr.CLAVE, cepr.Id 
		
		Select Clave1,	Descripcion, Clave2, Clave3, Clave3a, Descripcion3a, Clave4, Descripcion4, Clave5, Descripcion3, 
		Sum(Autorizado)Autorizado, sum(TransferenciaAmp)- abs(sum(TransferenciaRed))TransferenciaAmp, sum(TransferenciaRed)TransferenciaRed, Sum(Autorizado)+( sum(TransferenciaAmp)- abs(sum(TransferenciaRed))) Modificado, --Sum(Modificado)Modificado, 
		Sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, sum(Comprometido)Comprometido, SUM(PreCompSinComp)PreCompSinComp, 
		sum(PresDispComp)PresDispComp, sum(Devengado)Devengado, sum(CompSinDev)CompSinDev, sum(PresSinDev)PresSinDev, sum(Ejercido)Ejercido, 
		Sum(DevSinEjer)DevSinEjer, sum(Pagado)Pagado, --sum(EjerSinPagar)EjerSinPagar, 
		(Sum(Autorizado)+( sum(TransferenciaAmp)- abs(sum(TransferenciaRed))))-(sum(Devengado))EjerSinPagar,
		sum(Deuda)Deuda,
		sum(cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2))) PorcAprobAnual,
		avg(cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2))) PorcAprobadocAnt,
		sum(cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2))) as NomAprobado,
		avg(cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2))) PorcPVigenteAnual,
		avg(cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2))) PorcPVigenteAnt,
		sum(cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2))) NomPVigente 
		from @TResultadoFinalR_12 as TResultadoFinal 
		left outer join @TPorcAprobAnual_12_1 as TPorcAprobAnual1 on TResultadoFinal.id = TPorcAprobAnual1.ID 
		left outer join @TPorcAprobAnual_12_2 as TPorcAprobAnual2 on TPorcAprobAnual2.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_12_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_12_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_12_1 as TNomAprobado1 on TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_12_2 as TNomAprobado2 on TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_12_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_12_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_12_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_12_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_12_1 as TNomPVigente1 on TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_12_2 as TNomPVigente2 on TNomPVigente2.ID = TResultadoFinal.id
		group by Clave1,	Descripcion, Clave2, Clave3, Clave3a, Descripcion3a, Clave4, Descripcion4, Clave5, Descripcion3
		
	END
End


GO


