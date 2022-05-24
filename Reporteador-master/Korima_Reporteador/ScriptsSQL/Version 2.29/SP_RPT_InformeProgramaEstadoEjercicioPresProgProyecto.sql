
/****** Object:  StoredProcedure [dbo].[SP_RPT_InformeProgramaEstadoEjercicioPresProgProyecto]    Script Date: 25/Jul/2014 13:40 ******/
/****** Ing. Alvirde. Modificacion para aceptar unidad responsable y programa sin especificar. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_InformeProgramaEstadoEjercicioPresProgProyecto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_InformeProgramaEstadoEjercicioPresProgProyecto]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec SP_RPT_InformeProgramaEstadoEjercicioPresProgProyecto 1,12,2017,'','',1,1
CREATE PROCEDURE [dbo].[SP_RPT_InformeProgramaEstadoEjercicioPresProgProyecto] 

@Mes  as int,   
@Mes2  as int,
@Ejercicio as int,
@Clave2 as varchar(max),
@IdEP as varchar(max),
@Tipo as int,
@AmpRedAnual as int


AS
BEGIN
	--Informes Programáticos del Estado del Estado del Ejercicio del Presupuesto de Egresos


	If @Tipo = 1 
	BEGIN
	Declare @Anual1 as Table (Clave1 varchar(50), Descripcion varchar(250), Clave2 varchar(50), Descripcion2 varchar(250), Clave3 varchar(50),
		Id varchar(50), Descripcion3 varchar(max), Clave4 varchar(max), Descripcion4 varchar(max), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2),Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2),	Deuda decimal(15,2), PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2),	PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))
	Insert into @Anual1
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_EP_Ramo ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto 
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion  
		where   (Mes BETWEEN 1 and 12) AND LYear=@Ejercicio and C_ProyectosInversion.CLAVE = case when @Clave2 = '' then C_ProyectosInversion.CLAVE else @Clave2 end  
		AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		group by C_funciones.Clave, C_funciones.Nombre,  C_funciones.IdFuncion ,C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE ,
		C_RamoPresupuestal.DESCRIPCION,C_EP_Ramo.Clave,C_EP_Ramo.Id,T_SellosPresupuestales.IdProyecto ,C_ProyectosInversion.CLAVE,C_ProyectosInversion.NOMBRE 
		Order By C_RamoPresupuestal.CLAVE,C_funciones.Clave
		--Programas y Proyectos de Inversión
		--Valores Absolutos

		DECLARE @TResultadoFinal_6 as table (Clave1 varchar(50), Descripcion varchar(250), Clave2 varchar(50), Descripcion2 varchar(250), Clave3 varchar(50),
		Id varchar(18), Descripcion3 varchar(max), Clave4 varchar(max), Descripcion4 varchar(max), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2),Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2),	Deuda decimal(15,2), PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2),	PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))

		INSERT INTO @TResultadoFinal_6 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Id, Descripcion3, Clave4, Descripcion4, Autorizado, TransferenciaAmp, 
		TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev,
		Ejercido, DevSinEjer, Pagado, EjerSinPagar,	Deuda, PorcAprobAnual, PorcAprobadocAnt, NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)

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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_EP_Ramo ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto 
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion  
		where   (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio and C_ProyectosInversion.CLAVE = case when @Clave2 = '' then C_ProyectosInversion.CLAVE else @Clave2 end  
		AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		group by C_funciones.Clave, C_funciones.Nombre,  C_funciones.IdFuncion ,C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE ,
		C_RamoPresupuestal.DESCRIPCION,C_EP_Ramo.Clave,C_EP_Ramo.Id,T_SellosPresupuestales.IdProyecto ,C_ProyectosInversion.CLAVE,C_ProyectosInversion.NOMBRE 
		Order By C_RamoPresupuestal.CLAVE,C_funciones.Clave
		
		--Columna 1 PorcAprobAnual
		Declare @TPorcAprobAnual_6_1 as table (PorcAprobAnual1 decimal(15,2), Clave int, Clave2 varchar(max), ID Int)
		insert into @TPorcAprobAnual_6_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  Mes = 0 AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end 
		AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id

		Declare @TPorcAprobAnual_6_2 as table (PorcAprobAnual2 decimal(15,2), Clave int, Clave2 varchar(max), ID Int)
		insert into @TPorcAprobAnual_6_2
		Select  sum(isnull(tp.Autorizado,0))  as PorcAprobAnual2, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_EP_Ramo  CEPR	ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi
		ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto left JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id
		
		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_6_1 as table (PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 varchar(max), ID Int)
		insert into @TPorcAprobadocAnt_6_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_EP_Ramo CEPR ON CEPR.Id = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi
		ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto left JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id  
		
		Declare @TPorcAprobadocAnt_6_2 as table (PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 varchar(max), ID Int)
		insert into @TPorcAprobadocAnt_6_2
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id
		
		--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_6_1 as table (NomAprobado1 decimal(15,2), Clave int, Clave2 varchar(max), ID Int)
		insert into @TNomAprobado_6_1
		Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id
		
		Declare @TNomAprobado_6_2 as table (NomAprobado2 decimal(15,2), Clave int, Clave2 varchar(max), ID Int)
		insert into @TNomAprobado_6_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi	ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id 
		
		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_6_1 as table (PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 varchar(max), ID Int)
		insert into @TPorcPVigenteAnual_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnual1, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes = 0) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id
		
		Declare @TPorcPVigenteAnual_6_2 as table (PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 varchar(max), ID Int)
		insert into @TPorcPVigenteAnual_6_2
		Select   (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnual2, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_EP_Ramo  CEPR	ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 	INNER JOIN C_ProyectosInversion cpi
		ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  CF	ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id 
		
		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_6_1 as table (PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 varchar(max), ID Int)
		insert into @TPorcPVigenteAnt_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales 	INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  	INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto 	INNER JOIN C_ProyectosInversion cpi	ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id

		Declare @TPorcPVigenteAnt_6_2 as table (PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 varchar(max), ID Int)
		insert into @TPorcPVigenteAnt_6_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, cf.Clave, cepr.Id  
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id
		
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_6_1 as table (NomPVigente1 decimal(15,2), Clave int, Clave2 varchar(max), ID Int)
		insert into @TNomPVigente_6_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, cf.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_EP_Ramo  CEPR ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi
		ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id
		
		Declare @TNomPVigente_6_2 as table (NomPVigente2 decimal(15,2), Clave int, Clave2 varchar(max), ID Int)
		insert into @TNomPVigente_6_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, cf.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id

		--Select * from @Anual1
		Select a.Clave1, a.Descripcion, a.Clave2, a.Descripcion2, a.Clave3, a.Descripcion3, a.Clave4, a.Id, a.Descripcion4,
		a.Autorizado, 
		CASE When @AmpRedAnual = 1 Then isnull(a.TransferenciaAmp,0) Else isnull(TResultadoFinal.TransferenciaAmp,0) End as TransferenciaAmp,	 
		CASE When @AmpRedAnual = 1 Then isnull(a.TransferenciaRed,0) Else isnull(TResultadoFinal.TransferenciaRed,0) End as TransferenciaRed, 
		--isnull((a.Autorizado + (TResultadoFinal.TransferenciaAmp - TResultadoFinal.TransferenciaRed)),0) as Modificado, 
		--isnull(a.Autorizado,0)+ (isnull(TResultadoFinal.TransferenciaAmp,0) - isnull(TResultadoFinal.TransferenciaRed,0)) as Modificado,
		CASE WHEN @AmpRedAnual = 1 Then
		isnull(a.Autorizado,0)+ (isnull(a.TransferenciaAmp,0) - isnull(a.TransferenciaRed,0)) 
		Else
		isnull(a.Autorizado,0)+ (isnull(TResultadoFinal.TransferenciaAmp,0) - isnull(TResultadoFinal.TransferenciaRed,0))
		End as Modificado, 
		isnull(TResultadoFinal.PreComprometido,0) as PreComprometido, isnull(TResultadoFinal.PresVigSinPreComp,0) as PresVigSinPreComp, isnull(TResultadoFinal.Comprometido,0) as Comprometido, 
		isnull(TResultadoFinal.PreCompSinComp,0) as PreCompSinComp, isnull(TResultadoFinal.PresDispComp,0) as PresDispComp, isnull(TResultadoFinal.Devengado,0) as Devengado, isnull(TResultadoFinal.CompSinDev,0) as CompSinDev, isnull(TResultadoFinal.PresSinDev,0) as PresSinDev, isnull(TResultadoFinal.Ejercido,0) as Ejercido, 
		isnull(TResultadoFinal.DevSinEjer,0) as DevSinEjer, isnull(TResultadoFinal.Pagado,0) as Pagado, isnull(TResultadoFinal.EjerSinPagar,0) as EjerSinPagar, isnull(TResultadoFinal.Deuda,0) as Deuda,
		cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2)) PorcAprobAnual,
		cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2)) PorcAprobadocAnt,
		cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2)) as NomAprobado,
		cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2)) PorcPVigenteAnual,
		cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2)) PorcPVigenteAnt,
		cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2)) NomPVigente 
		from @TResultadoFinal_6 as TResultadoFinal 
		left outer join @TPorcAprobAnual_6_1 as TPorcAprobAnual1 on TPorcAprobAnual1.clave2 = TResultadoFinal.clave2 and TPorcAprobAnual1.ID = TResultadoFinal.ID 
		left outer join @TPorcAprobAnual_6_2 as TPorcAprobAnual2 on TPorcAprobAnual2.Clave2 = TResultadoFinal.clave2 and TPorcAprobAnual2.ID = TResultadoFinal.ID
		left outer join @TPorcAprobadocAnt_6_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.Clave2 = TResultadoFinal.clave2 and TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_6_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.Clave2 = TResultadoFinal.clave2 and TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_6_1 as TNomAprobado1 on TNomAprobado1.clave2 = TResultadoFinal.clave2 and TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_6_2 as TNomAprobado2 on TNomAprobado2.clave2 = TResultadoFinal.clave2 and TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_6_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_6_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_6_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_6_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_6_1 as TNomPVigente1 on TNomPVigente1.clave2 = TResultadoFinal.clave2 and TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_6_2 as TNomPVigente2 on TNomPVigente2.clave2 = TResultadoFinal.clave2 and TNomPVigente2.ID = TResultadoFinal.id
		Right outer join @Anual1 as a on a.Id = TResultadoFinal.Id and a.Clave4 = TResultadoFinal.Clave4
		 --update r set r.Autorizado = a.Autorizado FROM @Anual1 a, @TResultadoFinal_6 r Where a.Clave = r.Id and a.
			 
	END


	---////////******************************VALORES RELATIVOS*************************************//////////////

	
	If @Tipo = 2
	BEGIN
	Declare @Anual2 as Table(Clave1 varchar(50), Descripcion varchar(250), Clave2 varchar(50), Descripcion2 varchar(250), Clave3 varchar(50),
		Id varchar(18), Descripcion3 varchar(max), Clave4 varchar(max), Descripcion4 varchar(max), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2),Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2),	Deuda decimal(15,2), PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2),	PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))
	Insert into @Anual2
	Select C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, C_funciones.Clave as Clave2,  
		C_funciones.Nombre as Descripcion2, C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Id, C_EP_Ramo.Nombre as Descripcion3, C_ProyectosInversion.CLAVE as Clave4, 
		C_ProyectosInversion.NOMBRE as Descripcion4,
		 sum(isnull(TP.Autorizado,0))  as Autorizado,  
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal 
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo 
		ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto  left JOIN C_SubFunciones  
		ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion  
		where   (Mes BETWEEN 1 and 12) AND LYear=@Ejercicio and C_ProyectosInversion.CLAVE = case when @Clave2 = '' then C_ProyectosInversion.CLAVE else @Clave2 end AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		group by C_funciones.Clave, C_funciones.Nombre,  C_funciones.IdFuncion ,C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE ,C_RamoPresupuestal.DESCRIPCION,C_EP_Ramo.Clave,C_EP_Ramo.Id,T_SellosPresupuestales.IdProyecto ,C_ProyectosInversion.CLAVE,C_ProyectosInversion.NOMBRE 
		Order By C_RamoPresupuestal.CLAVE,C_funciones.Clave
		--Programas y Proyectos de Inversión
		--Valores Relativos
				
		DECLARE @TResultadoFinalR_15 as table (Clave1 varchar(50), Descripcion varchar(max), Clave2 varchar(50), Descripcion2 varchar(max), Clave3 varchar(50),
		Id varchar(50), Descripcion3 varchar(max), Clave4 varchar(Max), Descripcion4 varchar(max), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))

		INSERT INTO @TResultadoFinalR_15 (Clave1, Descripcion,	Clave2, Descripcion2, Clave3, Id, Descripcion3, Clave4, Descripcion4, Autorizado, TransferenciaAmp, 
		TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev,
		Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual, PorcAprobadocAnt, NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)

		Select C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, C_funciones.Clave as Clave2,  
		C_funciones.Nombre as Descripcion2, C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Id, C_EP_Ramo.Nombre as Descripcion3, C_ProyectosInversion.CLAVE as Clave4, 
		C_ProyectosInversion.NOMBRE as Descripcion4,
		 sum(isnull(TP.Autorizado,0))  as Autorizado,  
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal 
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo 
		ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto  left JOIN C_SubFunciones  
		ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion  
		where   (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio and C_ProyectosInversion.CLAVE = case when @Clave2 = '' then C_ProyectosInversion.CLAVE else @Clave2 end AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		group by C_funciones.Clave, C_funciones.Nombre,  C_funciones.IdFuncion ,C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE ,C_RamoPresupuestal.DESCRIPCION,C_EP_Ramo.Clave,C_EP_Ramo.Id,T_SellosPresupuestales.IdProyecto ,C_ProyectosInversion.CLAVE,C_ProyectosInversion.NOMBRE 
		Order By C_RamoPresupuestal.CLAVE,C_funciones.Clave
		 
		--Columna 1 PorcAprobAnual
		Declare @TPorcAprobAnual_15_1 as table(PorcAprobAnual1 decimal(15,2), Clave Int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobAnual_15_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, cf.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinalR_15 as T15 ON T15.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  Mes = 0 AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 

		Declare @TPorcAprobAnual_15_2 as table(PorcAprobAnual2 decimal(15,2), Clave Int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobAnual_15_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, cf.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		left JOIN @TResultadoFinalR_15 as T15 ON T15.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id
		
		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_15_1 as table(PorcAprobadocAnt1 decimal(15,2), Clave Int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobadocAnt_15_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, cf.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal 
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinalR_15 as T15 ON T15.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.ID 
		
		Declare @TPorcAprobadocAnt_15_2 as table(PorcAprobadocAnt2 decimal(15,2), Clave Int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobadocAnt_15_2  
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAn2, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinalR_15 as T15 ON T15.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.ID
		
		--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_15_1 as table(NomAprobado1 decimal(15,2), Clave Int, Clave2 varchar(Max), ID Int)
		insert into @TNomAprobado_15_1  
		Select  (sum(isnull(tp.Autorizado,0)))  as NomAprobado1, cr.CLAVE, cf.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinalR_15 as T15 ON T15.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and cpi.CLAVE = case when @clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id
		
		Declare @TNomAprobado_15_2 as table(NomAprobado2 decimal(15,2), Clave Int, Clave2 varchar(Max), ID Int)
		insert into @TNomAprobado_15_2 
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, cf.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinalR_15 as T15 ON T15.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.ID
		
		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_15_1 as table(PorcPVigenteAnual1 decimal(15,2), Clave Int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnual_15_1 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, cf.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinalR_15 as T15 ON T15.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes = 0) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		Declare @TPorcPVigenteAnual_15_2 as table(PorcPVigenteAnual2 decimal(15,2), Clave Int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnual_15_2 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinalR_15 as T15 ON T15.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id 
		
		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_15_1 as table(PorcPVigenteAnt1 decimal(15,2), Clave Int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnt_15_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnt1, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinalR_15 as T15 ON T15.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		Declare @TPorcPVigenteAnt_15_2 as table(PorcPVigenteAnt2 decimal(15,2), Clave Int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnt_15_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnt2, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinalR_15 as T15 ON T15.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id
		
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_15_1 as table(NomPVigente1 decimal(15,2), Clave Int, Clave2 varchar(Max), ID Int)
		insert into @TNomPVigente_15_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))))  as NomPVigente1, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal 
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinalR_15 as T15 ON T15.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id
		
		Declare @TNomPVigente_15_2 as table(NomPVigente2 decimal(15,2), Clave Int, Clave2 varchar(Max), ID Int)
		insert into @TNomPVigente_15_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente1, cr.CLAVE, cf.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion  left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinalR_15 as T15 ON T15.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and cpi.CLAVE = case when @Clave2 = '' then cpi.CLAVE else @Clave2 end AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id 
			
		Select a.Clave1, a.Descripcion, a.Clave2, a.Descripcion2, a.Clave3, a.Descripcion3, a.Clave4, a.Id, a.Descripcion4,
		a.Autorizado, 
		CASE WHEN @AmpRedAnual = 1 Then isnull(a.TransferenciaAmp,0) Else isnull(TResultadoFinal.TransferenciaAmp,0) End as TransferenciaAmp, 
		CASE WHEN @AmpRedAnual = 1 Then isnull(a.TransferenciaRed,0) Else isnull(TResultadoFinal.TransferenciaRed,0) End as TransferenciaRed, 
		--isnull((a.Autorizado + (TResultadoFinal.TransferenciaAmp - TResultadoFinal.TransferenciaRed)),0) as Modificado, 
		CASE WHEN @AmpRedAnual = 1 Then
		isnull(a.Autorizado,0)+ (isnull(a.TransferenciaAmp,0) - isnull(a.TransferenciaRed,0)) 
		Else
		isnull(a.Autorizado,0)+ (isnull(TResultadoFinal.TransferenciaAmp,0) - isnull(TResultadoFinal.TransferenciaRed,0))
		End as Modificado, 
		isnull(TResultadoFinal.PreComprometido,0) as PreComprometido, isnull(TResultadoFinal.PresVigSinPreComp,0) as PresVigSinPreComp, isnull(TResultadoFinal.Comprometido,0) as Comprometido, 
		isnull(TResultadoFinal.PreCompSinComp,0) as PreCompSinComp, isnull(TResultadoFinal.PresDispComp,0) as PresDispComp, isnull(TResultadoFinal.Devengado,0) as Devengado, isnull(TResultadoFinal.CompSinDev,0) as CompSinDev, isnull(TResultadoFinal.PresSinDev,0) as PresSinDev, isnull(TResultadoFinal.Ejercido,0) as Ejercido, 
		isnull(TResultadoFinal.DevSinEjer,0) as DevSinEjer, isnull(TResultadoFinal.Pagado,0) as Pagado, isnull(TResultadoFinal.EjerSinPagar,0) as EjerSinPagar, isnull(TResultadoFinal.Deuda,0) as Deuda,
		cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2)) PorcAprobAnual,
		cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2)) PorcAprobadocAnt,
		cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2)) as NomAprobado,
		cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2)) PorcPVigenteAnual,
		cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2)) PorcPVigenteAnt,
		cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2)) NomPVigente 
		from @TResultadoFinalR_15 as TResultadoFinal 
		left outer join @TPorcAprobAnual_15_1 as TPorcAprobAnual1 on TPorcAprobAnual1.clave2 = TResultadoFinal.clave2 and TPorcAprobAnual1.ID = TResultadoFinal.ID 
		left outer join @TPorcAprobAnual_15_2 as TPorcAprobAnual2 on TPorcAprobAnual2.Clave2 = TResultadoFinal.clave2 and TPorcAprobAnual2.ID = TResultadoFinal.ID
		left outer join @TPorcAprobadocAnt_15_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_15_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_15_1 as TNomAprobado1 on TNomAprobado1.clave2 = TResultadoFinal.clave2 and TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_15_2 as TNomAprobado2 on TNomAprobado2.clave2 = TResultadoFinal.clave2 and TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_15_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_15_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_15_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_15_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_15_1 as TNomPVigente1 on TNomPVigente1.clave2 = TResultadoFinal.clave2 and TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_15_2 as TNomPVigente2 on TNomPVigente2.clave2 = TResultadoFinal.clave2 and TNomPVigente2.ID = TResultadoFinal.id
		Right outer join @Anual2 as a on a.Id = TResultadoFinal.Id and a.Clave4 = TResultadoFinal.Clave4

		--update r set r.Autorizado = a.Autorizado FROM @Anual2 a, @TResultadoFinalR_15 r Where a.Clave = r.Id
  
	END	
End

GO

Exec SP_CFG_LogScripts 'SP_RPT_InformeProgramaEstadoEjercicioPresProgProyecto','2.29'
GO


