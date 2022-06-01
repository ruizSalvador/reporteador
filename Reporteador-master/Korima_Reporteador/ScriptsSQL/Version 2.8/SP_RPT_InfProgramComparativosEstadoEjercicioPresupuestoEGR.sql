
/****** Object:  StoredProcedure [dbo].[SP_RPT_InfProgramComparativosEstadoEjercicioPresupuestoEGR]    Script Date: 25/Jul/2014 13:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_InfProgramComparativosEstadoEjercicioPresupuestoEGR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_InfProgramComparativosEstadoEjercicioPresupuestoEGR]
GO
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

		DECLARE @TResultadoFinal_1 as table (Clave1 varchar(8), Descripcion varchar(150), Clave2 varchar(8), Descripcion2 varchar(150), Clave3 varchar(8),
		Id varchar(8), Descripcion3 varchar(150), Clave4 varchar(Max), NombreAI varchar(150), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2),	Deuda decimal(15,2), PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2),	PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2),
		PorcCompvsVigente decimal(15,2), NomCompvsVigente decimal(15,2), PorcDevvsVigente decimal(15,2), NomDevvsVigente decimal(15,2), 
		PorcCompAcvsVigenteAc decimal(15,2), NomCompAcvsVigenteAc decimal(15,2), PorcDevAcvsVigenteAc decimal(15,2), NomDevAcvsVigenteAc decimal(15,2),
		PorcEjerAcvsVigenteAc decimal(15,2), NomEjerAcvsVigenteAc decimal(15,2), PorcPagAcvsVigenteAc decimal(15,2), NomPagAcvsVigenteAc decimal(15,2),
		PorcCompAcvsVigenteAn decimal(15,2), NomCompAcvsVigenteAn decimal(15,2), PorcDevAcvsVigenteAn decimal(15,2), NomDevAcvsVigenteAn decimal(15,2),
		PorcEjerAcvsVigenteAn decimal(15,2), NomEjerAcvsVigenteAn decimal(15,2), PorcPagAcvsVigenteAn decimal(15,2), NomPagAcvsVigenteAn decimal(15,2))

		--///-- Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional
		-- Valores Absolutos
		--DECLARE @nombreAI varchar(255)
		--DECLARE @ClaveAI varchar(255)


		--SET @nombreAI = (SELECT  tablaID.nombre 
		--FROM
		--(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
		--inner join
		--(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		--ON tablaID.IdPadre = tablaAI.Id);

		--SELECT @ClaveAI =  tablaID.Clave  
		--FROM
		--(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
		--inner join
		--(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		--ON tablaID.IdPadre = tablaAI.Id

		INSERT INTO @TResultadoFinal_1 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Id, Descripcion3, Clave4, NombreAI, Autorizado, TransferenciaAmp, 
		TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev,
		Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual, PorcAprobadocAnt, NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt,
		NomPVigente, PorcCompvsVigente, NomCompvsVigente, PorcDevvsVigente, NomDevvsVigente, PorcCompAcvsVigenteAc, NomCompAcvsVigenteAc,
		PorcDevAcvsVigenteAc, NomDevAcvsVigenteAc, PorcEjerAcvsVigenteAc, NomEjerAcvsVigenteAc, PorcPagAcvsVigenteAc, NomPagAcvsVigenteAc,
		PorcCompAcvsVigenteAn, NomCompAcvsVigenteAn, PorcDevAcvsVigenteAn, NomDevAcvsVigenteAn, PorcEjerAcvsVigenteAn, NomEjerAcvsVigenteAn,
		PorcPagAcvsVigenteAn, NomPagAcvsVigenteAn)

		Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, C_Funciones.Clave as Clave2,  
		C_Funciones.Nombre as Descripcion2, C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Id, C_EP_Ramo.Nombre as Descripcion3,  
		(SELECT tablaID.Clave FROM (select * from C_EP_Ramo as T1 where T1.id = C_EP_Ramo.ID and Nivel = 5) tablaID
		inner join (select * from C_EP_Ramo where  Nivel = 4) tablaAI ON tablaID.IdPadre = tablaAI.Id) as Clave4, 
		'' as NombreAI,
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo
		ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion  
		WHERE  (Mes BETWEEN @Mes and @Mes2) AND Year=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.Clave else
		@Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.Clave else
		@Clave2 end) AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		GROUP BY C_RamoPresupuestal.CLAVE ,C_RamoPresupuestal.DESCRIPCION , C_EP_Ramo.Clave, C_EP_Ramo.ID, C_EP_Ramo.Nombre, C_Funciones.Clave, C_Funciones.Nombre 
		Order By C_RamoPresupuestal.CLAVE,C_Funciones.Clave
		
		--Columna 18 PorcAprobAnual
		declare @TPorcAprobAnual_1_1 as table (PorcAprobAnual1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcAprobAnual_1_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo
		ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = C_EP_Ramo.id and Clave1 = C_RamoPresupuestal.CLAVE and Clave2 = C_Funciones.Clave 
		where  Mes = 0 AND Year=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.Clave else @Clave end
		and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.Clave else @Clave2 end) AND C_EP_Ramo.Id = case when @IdEP = '' then
		C_EP_Ramo.ID else @IdEP end
		GROUP BY  C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id 

		declare @TPorcAprobAnual_1_2 as table (PorcAprobAnual2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcAprobAnual_1_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo
		ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = C_EP_Ramo.id and Clave1 = C_RamoPresupuestal.CLAVE and Clave2 = C_Funciones.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.Clave else @Clave end
		and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.Clave else @Clave2 end) AND C_EP_Ramo.Id = case when @IdEP = '' then
		C_EP_Ramo.ID else @IdEP end
		GROUP BY   C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id
		
		--Columna 19 PorcAprobadocAnt
		declare @TPorcAprobadocAnt_1_1 as table (PorcAprobadocAnt1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcAprobadocAnt_1_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave  end and 
		cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.ID else @IdEP end
		GROUP BY   cr.CLAVE, cepr.Id  

		declare @TPorcAprobadocAnt_1_2 as table (PorcAprobadocAnt2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcAprobadocAnt_1_2
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY   cr.CLAVE, cepr.Id
		
		--Columna 20 y 21 NomAprobado
		declare @TNomAprobado_1_1 as table (NomAprobado1 decimal(15,2), Clave int, ID int)
		insert Into @TNomAprobado_1_1
		Select (sum(isnull(tp.Autorizado,0)))  as NomAprobado1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY  cr.CLAVE, cepr.Id
		
		declare @TNomAprobado_1_2 as table (NomAprobado2 decimal(15,2), Clave int, ID int)
		insert Into @TNomAprobado_1_2		
		Select  sum(isnull(tp.Autorizado,0))  as NomAprobado2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY   cr.CLAVE, cepr.Id 	
		
		--Columna 22 PorcPVigenteAnual
		declare @TPorcPVigenteAnual_1_1 as table (PorcPVigenteAnual1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcPVigenteAnual_1_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes = 0) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY   cr.CLAVE, cepr.Id

		declare @TPorcPVigenteAnual_1_2 as table (PorcPVigenteAnual2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcPVigenteAnual_1_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY   cr.CLAVE, cepr.Id
		
		--Columna 23 PorcPVigenteAnt
		declare @TPorcPVigenteAnt_1_1 as table (PorcPVigenteAnt1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcPVigenteAnt_1_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY   cr.CLAVE, cepr.Id 

		declare @TPorcPVigenteAnt_1_2 as table (PorcPVigenteAnt2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcPVigenteAnt_1_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY   cr.CLAVE, cepr.Id 
		
		--Columna 24 y 25 NomPVigente
		declare @TNomPVigente_1_1 as table (NomPVigente1 decimal(15,2), Clave int, ID int)
		insert Into @TNomPVigente_1_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY   cr.CLAVE, cepr.Id
		
		declare @TNomPVigente_1_2 as table (NomPVigente2 decimal(15,2), Clave int, ID int)
		insert Into @TNomPVigente_1_2 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY   cr.CLAVE, cepr.Id
		
		----PorcCompvsVigente
		declare @TPorcCompvsVigente_1_1 as table (PorcCompvsVigente1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcCompvsVigente_1_1 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompvsVigente1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		declare @TPorcCompvsVigente_1_2 as table (PorcCompvsVigente2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcCompvsVigente_1_2 
		Select sum(isnull(TP.Comprometido,0)) as PorcCompvsVigente2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		------------------PorcDevvsVigente NomCompvsVigente
		declare @TPorcDevvsVigente_1_1 as table (PorcDevvsVigente1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcDevvsVigente_1_1 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevvsVigente1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		declare @TPorcDevvsVigente_1_2 as table (PorcDevvsVigente2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcDevvsVigente_1_2 
		Select sum(isnull(TP.Devengado,0))  as PorcDevvsVigente2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		--------------------------- PorcCompAcvsVigenteAc
		declare @TPorcCompAcvsVigenteAc_1_1 as table (PorcCompAcvsVigenteAc1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcCompAcvsVigenteAc_1_1 
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAc1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR 	ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones 	ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		declare @TPorcCompAcvsVigenteAc_1_2 as table (PorcCompAcvsVigenteAc2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcCompAcvsVigenteAc_1_2 
		Select sum(isnull(tp.Comprometido,0))  as PorcCompAcvsVigenteAc2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		-----------------------NomCompAcvsVigenteAc
		declare @TNomCompAcvsVigenteAc_1_1 as table (NomCompAcvsVigenteAc1 decimal(15,2), Clave int, ID int)
		insert Into @TNomCompAcvsVigenteAc_1_1 
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0))  as NomCompAcvsVigenteAc1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
	
		------------------------ PorcDevAcvsVigenteAc
		declare @TPorcDevAcvsVigenteAc_1_1 as table (PorcDevAcvsVigenteAc1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcDevAcvsVigenteAc_1_1 
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))   as PorcDevAcvsVigenteAc1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		declare @TPorcDevAcvsVigenteAc_1_2 as table (PorcDevAcvsVigenteAc2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcDevAcvsVigenteAc_1_2 
		Select sum(isnull(tp.Devengado,0))  as PorcDevAcvsVigenteAc2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		-------------NomDevAcvsVigenteAc
		declare @TNomDevAcvsVigenteAc_1_1 as table (NomDevAcvsVigenteAc1 decimal(15,2), Clave int, ID int)
		insert Into @TNomDevAcvsVigenteAc_1_1 
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0)) as NomDevAcvsVigenteAc1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id 
		
		------------------- PorcEjerAcvsVigenteAc
		declare @TPorcEjerAcvsVigenteAc_1_1 as table (PorcEjerAcvsVigenteAc1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcEjerAcvsVigenteAc_1_1 
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcEjerAcvsVigenteAc1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		declare @TPorcEjerAcvsVigenteAc_1_2 as table (PorcEjerAcvsVigenteAc2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcEjerAcvsVigenteAc_1_2 
		Select sum(isnull(tp.Ejercido,0)) as PorcEjerAcvsVigenteAc2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
				
		--------------NomEjerAcvsVigenteAc
		declare @TNomEjerAcvsVigenteAc_1_1 as table (NomEjerAcvsVigenteAc1 decimal(15,2), Clave int, ID int)
		insert Into @TNomEjerAcvsVigenteAc_1_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0)) as PorcEjerAcvsVigenteAc2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		-----------------PorcPagAcvsVigenteAc
		declare @TPorcPagAcvsVigenteAc_1_1 as table (PorcPagAcvsVigenteAc1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcPagAcvsVigenteAc_1_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPagAcvsVigenteAc1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY cr.CLAVE, cepr.Id
		
		declare @TPorcPagAcvsVigenteAc_1_2 as table (PorcPagAcvsVigenteAc2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcPagAcvsVigenteAc_1_2
		Select sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAc2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and  (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY cr.CLAVE, cepr.Id
				
		--------------NomPagAcvsVigenteAc
		declare @TNomPagAcvsVigenteAc_1_1 as table (NomPagAcvsVigenteAc1 decimal(15,2), Clave int, ID int)
		insert Into @TNomPagAcvsVigenteAc_1_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0)) as NomPagAcvsVigenteAc1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		-----------------PorcCompAcvsVigenteAn
		declare @TPorcCompAcvsVigenteAn_1_1 as table (PorcCompAcvsVigenteAn1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcCompAcvsVigenteAn_1_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAn1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		declare @TPorcCompAcvsVigenteAn_1_2 as table (PorcCompAcvsVigenteAn2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcCompAcvsVigenteAn_1_2
		Select  sum(isnull(tp.Comprometido,0)) as PorcCompAcvsVigenteAn2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		------------ NomCompAcvsVigenteAn
		declare @TNomCompAcvsVigenteAn_1_1 as table (NomCompAcvsVigenteAn1 decimal(15,2), Clave int, ID int)
		insert Into @TNomCompAcvsVigenteAn_1_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0))
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomCompAcvsVigenteAn1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY cr.CLAVE, cepr.Id
		
		declare @TNomCompAcvsVigenteAn_1_2 as table (NomCompAcvsVigenteAn2 decimal(15,2), Clave int, ID int)
		insert Into @TNomCompAcvsVigenteAn_1_2
		Select  (sum(isnull(tp.Comprometido,0)))as NomCompAcvsVigenteAn2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		----------------- PorcDevAcvsVigenteAn
		declare @TPorcDevAcvsVigenteAn_1_1 as table (PorcDevAcvsVigenteAn1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcDevAcvsVigenteAn_1_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevAcvsVigenteAn1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		declare @TPorcDevAcvsVigenteAn_1_2 as table (PorcDevAcvsVigenteAn2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcDevAcvsVigenteAn_1_2
		Select  sum(isnull(tp.Devengado,0))  as PorcDevAcvsVigenteAn2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF 	ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
	
		-------------- NomDevAcvsVigenteAn
		declare @TNomDevAcvsVigenteAn_1_1 as table (NomDevAcvsVigenteAn1 decimal(15,2), Clave int, ID int)
		insert Into @TNomDevAcvsVigenteAn_1_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomDevAcvsVigenteAn1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		declare @TNomDevAcvsVigenteAn_1_2 as table (NomDevAcvsVigenteAn2 decimal(15,2), Clave int, ID int)
		insert Into @TNomDevAcvsVigenteAn_1_2
		Select  (sum(isnull(tp.Devengado,0))) as NomDevAcvsVigenteAn2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY cr.CLAVE, cepr.Id
		
		----------------PorcEjerAcvsVigenteAn
		declare @TPorcEjerAcvsVigenteAn_1_1 as table (PorcEjerAcvsVigenteAn1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcEjerAcvsVigenteAn_1_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcEjerAcvsVigenteAn1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		declare @TPorcEjerAcvsVigenteAn_1_2 as table (PorcEjerAcvsVigenteAn2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcEjerAcvsVigenteAn_1_2
		Select sum(isnull(tp.Ejercido,0)) as PorcEjerAcvsVigenteAn2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		----------------NomEjerAcvsVigenteAn
		declare @TNomEjerAcvsVigenteAn_1_1 as table (NomEjerAcvsVigenteAn1 decimal(15,2), Clave int, ID int)
		insert Into @TNomEjerAcvsVigenteAn_1_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomEjerAcvsVigenteAn1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		declare @TNomEjerAcvsVigenteAn_1_2 as table (NomEjerAcvsVigenteAn2 decimal(15,2), Clave int, ID int)
		insert Into @TNomEjerAcvsVigenteAn_1_2
		Select  (sum(isnull(tp.Ejercido,0)))as NomEjerAcvsVigenteAn2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
	
		----------------------- PorcPagAcvsVigenteAn
		declare @TPorcPagAcvsVigenteAn_1_1 as table (PorcPagAcvsVigenteAn1 decimal(15,2), Clave int, ID int)
		insert Into @TPorcPagAcvsVigenteAn_1_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcPagAcvsVigenteAn1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		declare @TPorcPagAcvsVigenteAn_1_2 as table (PorcPagAcvsVigenteAn2 decimal(15,2), Clave int, ID int)
		insert Into @TPorcPagAcvsVigenteAn_1_2
		Select   sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAn2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
		INNER JOIN C_EP_Ramo cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones 
		ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  LEFT JOIN C_Funciones CF 	ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		--------------------------- NomPagAcvsVigenteAn
		declare @TNomPagAcvsVigenteAn_1_1 as table (NomPagAcvsVigenteAn1 decimal(15,2), Clave int, ID int)
		insert Into @TNomPagAcvsVigenteAn_1_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPagAcvsVigenteAn1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
		
		declare @TNomPagAcvsVigenteAn_1_2 as table (NomPagAcvsVigenteAn2 decimal(15,2), Clave int, ID int)
		insert Into @TNomPagAcvsVigenteAn_1_2
		Select  (sum(isnull(tp.Pagado,0))) as NomPagAcvsVigenteAn2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinal_1 as T1 ON T1.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY  cr.CLAVE, cepr.Id
	
		Select Clave1, Descripcion, Clave2, Descripcion2, Clave3, TR.Id, Descripcion3, Clave4, NombreAI, Autorizado, TransferenciaAmp, 
		TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev,
		Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, 
		cast(case when isnull(PorcAprobAnual1,0) = 0 then 0 else isnull(PorcAprobAnual2,0) / isnull(PorcAprobAnual1,0) end as decimal(15,2))PorcAprobAnual,
		cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else isnull(PorcAprobadocAnt2,0) / isnull(PorcAprobadocAnt1,0) end as decimal(15,2))PorcAprobadocAnt, 
		isnull(NomAprobado1,0) - isnull(NomAprobado2,0) NomAprobado,
		cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else isnull(PorcPVigenteAnual2,0) / isnull(PorcPVigenteAnual1,0) end as decimal(15,2))PorcPVigenteAnual,
		cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else isnull(PorcPVigenteAnt2,0) / isnull(PorcPVigenteAnt1,0) end as decimal(15,2))PorcPVigenteAnt,
		isnull(NomPVigente1,0) - isnull(NomPVigente2,0) NomPVigente,
		cast(case when isnull(PorcCompvsVigente1,0) = 0 then 0 else isnull(PorcCompvsVigente2,0) / isnull(PorcCompvsVigente1,0) end as decimal(15,2)) PorcCompvsVigente,
		NomCompvsVigente,
		cast(case when isnull(PorcDevvsVigente1,0) = 0 then 0 else isnull(PorcDevvsVigente2,0) / isnull(PorcDevvsVigente1,0) end as decimal(15,2))PorcDevvsVigente,
		NomDevvsVigente, 
		cast(case when isnull(PorcCompAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAc2,0) / isnull(PorcCompAcvsVigenteAc1,0) end as decimal(15,2))PorcCompAcvsVigenteAc,
		isnull(NomCompAcvsVigenteAc1,0)NomCompAcvsVigenteAc,
		cast(case when isnull(PorcDevAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAc2,0) / isnull(PorcDevAcvsVigenteAc1,0) end as decimal(15,2)) PorcDevAcvsVigenteAc,
		isnull(NomDevAcvsVigenteAc1,0)NomDevAcvsVigenteAc,
		cast(case when isnull(PorcEjerAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAc2,0) / isnull(PorcEjerAcvsVigenteAc1,0) end as decimal(15,2))PorcEjerAcvsVigenteAc,
		isnull(NomEjerAcvsVigenteAc1,0)NomEjerAcvsVigenteAc,
		cast(case when isnull(PorcPagAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAc2,0) / isnull(PorcPagAcvsVigenteAc1,0) end as decimal(15,2))PorcPagAcvsVigenteAc,
		isnull(NomPagAcvsVigenteAc1,0)NomPagAcvsVigenteAc,
		cast(case when isnull(PorcCompAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAn2,0) / isnull(PorcCompAcvsVigenteAn1,0) end as decimal(15,2))PorcCompAcvsVigenteAn,
		isnull(NomCompAcvsVigenteAn1,0) - isnull(NomCompAcvsVigenteAn2,0)NomCompAcvsVigenteAn,
		cast(case when isnull(PorcDevAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAn2,0) / isnull(PorcDevAcvsVigenteAn1,0) end as decimal(15,2))PorcDevAcvsVigenteAn,
		isnull(NomDevAcvsVigenteAn1,0)- isnull(NomDevAcvsVigenteAn2,0) NomDevAcvsVigenteAn,
		cast(case when isnull(PorcEjerAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAn2,0) / isnull(PorcEjerAcvsVigenteAn1,0) end as decimal(15,2))PorcEjerAcvsVigenteAn,
		isnull(NomEjerAcvsVigenteAn1,0) - isnull(NomEjerAcvsVigenteAn2,0)NomEjerAcvsVigenteAn,
		cast(case when isnull(PorcPagAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAn2,0) / isnull(PorcPagAcvsVigenteAn1,0) end as decimal(15,2))PorcPagAcvsVigenteAn,
		isnull(NomPagAcvsVigenteAn1,0) - isnull(NomPagAcvsVigenteAn,0) NomPagAcvsVigenteAn
		from @TResultadoFinal_1 as TR
		left outer join @TPorcAprobAnual_1_1 as T_1_1 on T_1_1.ID = TR.ID left outer join @TPorcAprobAnual_1_2 as T_1_2 on T_1_2.ID = TR.ID
		left outer join @TPorcAprobadocAnt_1_1 as T_2_1 on T_2_1.ID = TR.ID left outer join @TPorcAprobadocAnt_1_2 as T_2_2 on T_2_2.ID = TR.ID
		left outer join @TNomAprobado_1_1 as T_3_1 on T_3_1.ID = TR.ID left outer join @TNomAprobado_1_2 as T_3_2 on T_3_2.ID = TR.ID
		left outer join @TPorcPVigenteAnual_1_1 as T_4_1 on T_4_1.ID = TR.ID left outer join @TPorcPVigenteAnual_1_2 as T_4_2 on T_4_2.ID = TR.ID
		left outer join @TPorcPVigenteAnt_1_1 as T_5_1 on T_5_1.ID = TR.ID left outer join @TPorcPVigenteAnt_1_2 as T_5_2 on T_5_2.ID = TR.ID
		left outer join @TNomPVigente_1_1 as T_6_1 on T_6_1.ID = TR.ID left outer join @TNomPVigente_1_2 as T_6_2 on T_6_2.ID = TR.ID
		left outer join @TPorcCompvsVigente_1_1 as T_7_1 on T_7_1.ID = TR.ID left outer join @TPorcCompvsVigente_1_2 as T_7_2 on T_7_2.ID = TR.ID
		left outer join @TPorcDevvsVigente_1_1 as T_8_1 on T_8_1.ID = TR.ID left outer join @TPorcDevvsVigente_1_2 as T_8_2 on T_8_2.ID = TR.ID
		left outer join @TPorcCompAcvsVigenteAc_1_1 as T_9_1 on T_9_1.ID = TR.ID left outer join @TPorcCompAcvsVigenteAc_1_2 as T_9_2 on T_9_2.ID = TR.ID 
		left outer join @TNomCompAcvsVigenteAc_1_1 as T_10_1 on T_10_1.ID = TR.ID
		left outer join @TPorcDevAcvsVigenteAc_1_1 as T_11_1 on T_11_1.ID = TR.ID left outer join @TPorcDevAcvsVigenteAc_1_2 as T_11_2 on T_11_2.ID = TR.ID
		left outer join @TNomDevAcvsVigenteAc_1_1 as T_12_1 on T_12_1.ID = TR.ID 
		left outer join @TPorcEjerAcvsVigenteAc_1_1 as T_13_1 on T_13_1.ID = TR.ID left outer join @TPorcEjerAcvsVigenteAc_1_2 as T_13_2 on T_13_2.ID = TR.ID
		left outer join @TNomEjerAcvsVigenteAc_1_1 as T_14_1 on T_14_1.ID = TR.ID
		left outer join @TPorcPagAcvsVigenteAc_1_1 as T_15_1 on T_15_1.ID = TR.ID left outer join @TPorcPagAcvsVigenteAc_1_2 as T_15_2 on T_15_2.ID = TR.ID  
		left outer join @TNomPagAcvsVigenteAc_1_1 as T_16_1 on T_16_1.ID = TR.ID
		left outer join @TPorcCompAcvsVigenteAn_1_1 as T_17_1 on T_17_1.ID = TR.ID left outer join @TPorcCompAcvsVigenteAn_1_2 as T_17_2 on T_17_2.ID = TR.ID  
		left outer join @TNomCompAcvsVigenteAn_1_1 as T_18_1 on T_18_1.ID = TR.ID left outer join @TNomCompAcvsVigenteAn_1_2 as T_18_2 on T_18_2.ID = TR.ID  
		left outer join @TPorcDevAcvsVigenteAn_1_1 as T_19_1 on T_19_1.ID = TR.ID left outer join @TPorcDevAcvsVigenteAn_1_2 as T_19_2 on T_19_2.ID = TR.ID  
		left outer join @TNomDevAcvsVigenteAn_1_1 as T_20_1 on T_20_1.ID = TR.ID left outer join @TNomDevAcvsVigenteAn_1_2 as T_20_2 on T_20_2.ID = TR.ID  
		left outer join @TPorcEjerAcvsVigenteAn_1_1 as T_21_1 on T_21_1.ID = TR.ID left outer join @TPorcEjerAcvsVigenteAn_1_2 as T_21_2 on T_21_2.ID = TR.ID  
		left outer join @TNomEjerAcvsVigenteAn_1_1 as T_22_1 on T_22_1.ID = TR.ID left outer join @TNomEjerAcvsVigenteAn_1_2 as T_22_2 on T_22_2.ID = TR.ID  
		left outer join @TPorcPagAcvsVigenteAn_1_1 as T_23_1 on T_23_1.ID = TR.ID left outer join @TPorcPagAcvsVigenteAn_1_2 as T_23_2 on T_23_2.ID = TR.ID  
		left outer join @TNomPagAcvsVigenteAn_1_1 as T_24_1 on T_24_1.ID = TR.ID left outer join @TNomPagAcvsVigenteAn_1_2 as T_24_2 on T_24_2.ID = TR.ID  
	end

	If @Tipo = 2 
	BEGIN
		-- Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo
		-- Valores Absolutos

		DECLARE @TResultadoFinal_2 as table (Clave1 varchar(8), Descripcion varchar(150),	Clave2 varchar(8), Descripcion2 varchar(150), Clave3 varchar(8),
		Descripcion3 varchar(150), Clave3a varchar(8), Descripcion3a varchar(150), Clave4 varchar(MAx), Id varchar(8), Descripcion4 varchar(150), 
		Clave5 varchar(8), NombreAI varchar(150), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), 
		Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), PreCompSinComp decimal(15,2), 
		PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2), Ejercido decimal(15,2), 
		DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2),	PorcPVigenteAnt decimal(15,2),	NomPVigente decimal(15,2),
		PorcCompvsVigente decimal(15,2), NomCompvsVigente decimal(15,2), PorcDevvsVigente decimal(15,2), NomDevvsVigente decimal(15,2), 
		PorcCompAcvsVigenteAc decimal(15,2), NomCompAcvsVigenteAc decimal(15,2), PorcDevAcvsVigenteAc decimal(15,2), NomDevAcvsVigenteAc decimal(15,2),
		PorcEjerAcvsVigenteAc decimal(15,2), NomEjerAcvsVigenteAc decimal(15,2), PorcPagAcvsVigenteAc decimal(15,2), NomPagAcvsVigenteAc decimal(15,2), 
		PorcCompAcvsVigenteAn decimal(15,2), NomCompAcvsVigenteAn decimal(15,2), PorcDevAcvsVigenteAn decimal(15,2), NomDevAcvsVigenteAn decimal(15,2),
		PorcEjerAcvsVigenteAn decimal(15,2), NomEjerAcvsVigenteAn decimal(15,2), PorcPagAcvsVigenteAn decimal(15,2), NomPagAcvsVigenteAn decimal(15,2))

		DECLARE @nombre0AI varchar(255)
		DECLARE @clave0AI varchar(255)

		--SET @nombre0AI = (SELECT  tablaID.nombre 
		--FROM
		--(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
		--inner join
		--(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		--ON tablaID.IdPadre = tablaAI.Id);

		--SELECT @clave0AI =  tablaID.Clave  
		--FROM
		--(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
		--inner join
		--(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		--ON tablaID.IdPadre = tablaAI.Id

		INSERT INTO @TResultadoFinal_2 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Clave3a, Descripcion3a, Clave4, Id, Descripcion4, 
		Clave5,	NombreAI, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, 
		PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual, PorcAprobadocAnt, NomAprobado,
		PorcPVigenteAnual, PorcPVigenteAnt,	NomPVigente, PorcCompvsVigente, NomCompvsVigente, PorcDevvsVigente, NomDevvsVigente, PorcCompAcvsVigenteAc, 
		NomCompAcvsVigenteAc, PorcDevAcvsVigenteAc, NomDevAcvsVigenteAc, PorcEjerAcvsVigenteAc, NomEjerAcvsVigenteAc, PorcPagAcvsVigenteAc, 
		NomPagAcvsVigenteAc, PorcCompAcvsVigenteAn, NomCompAcvsVigenteAn, PorcDevAcvsVigenteAn, NomDevAcvsVigenteAn, PorcEjerAcvsVigenteAn, 
		NomEjerAcvsVigenteAn, PorcPagAcvsVigenteAn, NomPagAcvsVigenteAn)

		Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
		C_AreaResponsabilidad.Clave  as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2,
		C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3, 
		(SELECT tablaID.Clave FROM 	(select * from C_EP_Ramo as T2 where T2.id = C_EP_Ramo.ID and Nivel = 5) tablaID
		inner join (select * from C_EP_Ramo where  Nivel = 4) tablaAI ON tablaID.IdPadre = tablaAI.Id) as Clave3a, 
		C_CapitulosNEP.Descripcion as Descripcion3a, C_CapitulosNEP.IdCapitulo as Clave4, C_EP_Ramo.Id, 
		C_ConceptosNEP.Descripcion as Descripcion4,  C_ConceptosNEP.IdConcepto  as Clave5, '' as NombreAI,
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 	INNER JOIN C_EP_Ramo
		ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
		INNER JOIN C_AreaResponsabilidad ON (C_AreaResponsabilidad.IdAreaResp = T_SellosPresupuestales.IdAreaResp) 
		AND (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP 
		ON  C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo 
		WHERE (Mes BETWEEN @Mes  and @Mes2 ) AND Year=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.Clave else
		@Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.Clave else @Clave2 end) 
		AND C_AreaResponsabilidad.Clave = case when @ClaveUR = '' then c_AreaResponsabilidad.Clave else @ClaveUR end 
		AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.Id else @IdEP end 
		Group by  C_CapitulosNEP.IdCapitulo, C_CapitulosNEP.Descripcion, C_ConceptosNEP.IdConcepto, C_ConceptosNEP.Descripcion, C_ConceptosNEP.IdCapitulo,
		C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre,C_EP_Ramo.Clave,C_EP_Ramo.Id, C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE,
		C_RamoPresupuestal.DESCRIPCION 
		Order by  C_AreaResponsabilidad.Clave  ,C_CapitulosNEP.IdCapitulo 
		
		--Columna 18 PorcAprobAnual
		Declare @TPorcAprobAnual_2_1 as table (PorcAprobAnual1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcAprobAnual_2_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr 	ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcAprobAnual_2_2 as table (PorcAprobAnual2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcAprobAnual_2_2
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto 	INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL)  INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 19 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_2_1 as table (PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcAprobadocAnt_2_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcAprobadocAnt_2_2 as table (PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcAprobadocAnt_2_2
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 20 y 21 NomAprobado
		Declare @TNomAprobado_2_1 as table (NomAprobado1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomAprobado_2_1
		Select  (sum(isnull(tp.Autorizado,0))) as PorcAprobadocAnt2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto 
		INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn 
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TNomAprobado_2_2 as table (NomAprobado2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomAprobado_2_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn 
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 22 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_2_1 as table (PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcPVigenteAnual_2_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto 
		INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn 	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes = 0) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id 

		Declare @TPorcPVigenteAnual_2_2 as table (PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcPVigenteAnual_2_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.Id 
		
		--Columna 23 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_2_1 as table (PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcPVigenteAnt_2_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto 
		INNER JOIN C_PartidasPres  ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id  

		Declare @TPorcPVigenteAnt_2_2 as table (PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcPVigenteAnt_2_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnt2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 	INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.Id 
		
		--Columna 24 y 25 NomPVigente
		Declare @TNomPVigente_2_1 as table (NomPVigente1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomPVigente_2_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.Id
		
		Declare @TNomPVigente_2_2 as table (NomPVigente2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomPVigente_2_2		
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0))
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = TS.IdPartida 	INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id
		
		------------PorcCompvsVigente
		DECLARE @DIV2m decimal(15,2)
		Declare @TPorcCompvsVigente_2_1 as table (PorcCompvsVigente1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcCompvsVigente_2_1	
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0))
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompvsVigente1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto 	INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida  INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 	INNER JOIN C_ConceptosNEP cn 
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave,cepr.Id
		
		Declare @TPorcCompvsVigente_2_2 as table (PorcCompvsVigente2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcCompvsVigente_2_2
		Select sum(isnull(TP.Comprometido,0))  as PorcCompvsVigente2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave,cepr.Id
		
		------------------PorcDevvsVigente
		Declare @TPorcDevvsVigente_2_1 as table (PorcDevvsVigente1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcDevvsVigente_2_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevvsVigente1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 	INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN @Mes and @Mes2 )  AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave,cepr.Id
		
		Declare @TPorcDevvsVigente_2_2 as table (PorcDevvsVigente2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcDevvsVigente_2_2
		Select sum(isnull(TP.Devengado,0)) as PorcDevvsVigente2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn 
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN @Mes and @Mes2 ) AND  Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave,cepr.Id
		
		----------------PorcCompAcvsVigenteAc
		Declare @TPorcCompAcvsVigenteAc_2_1 as table (PorcCompAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcCompAcvsVigenteAc_2_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP 	ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal 
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr	ON cepr.Id  = TS.IdProyecto 
		INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave,cepr.Id
		
		Declare @TPorcCompAcvsVigenteAc_2_2 as table (PorcCompAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcCompAcvsVigenteAc_2_2
		Select sum(isnull(tp.Comprometido,0)) as PorcCompAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr	ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave,cepr.Id
		
		---------------- NomCompAcvsVigenteAc
		Declare @TNomCompAcvsVigenteAc_2_1 as table (NomCompAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomCompAcvsVigenteAc_2_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0)) as NomCompAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto 	INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn 
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave,cepr.Id
	
		-----------------------PorcDevAcvsVigenteAc
		Declare @TPorcDevAcvsVigenteAc_2_1 as table (PorcDevAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcDevAcvsVigenteAc_2_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcDevAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto 
		INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id 
		
		Declare @TPorcDevAcvsVigenteAc_2_2 as table (PorcDevAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcDevAcvsVigenteAc_2_2
		Select sum(isnull(tp.Devengado,0)) as PorcDevAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr	ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 	INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id
		
		-------------------------NomDevAcvsVigenteAc
		Declare @TNomDevAcvsVigenteAc_2_1 as table (NomDevAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomDevAcvsVigenteAc_2_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0))as NomDevAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id 
		
		-----------------PorcEjerAcvsVigenteAc
		Declare @TPorcEjerAcvsVigenteAc_2_1 as table (PorcEjerAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcEjerAcvsVigenteAc_2_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcEjerAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn 
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcEjerAcvsVigenteAc_2_2 as table (PorcEjerAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcEjerAcvsVigenteAc_2_2
		Select sum(isnull(tp.Ejercido,0)) as PorcEjerAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr	ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id 
		
		-----------------NomEjerAcvsVigenteAc
		Declare @TNomEjerAcvsVigenteAc_2_1 as table (NomEjerAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomEjerAcvsVigenteAc_2_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0)) as NomEjerAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id  
		
		-----------------------PorcPagAcvsVigenteAc
		Declare @TPorcPagAcvsVigenteAc_2_1 as table (PorcPagAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcPagAcvsVigenteAc_2_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcPagAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcPagAcvsVigenteAc_2_2 as table (PorcPagAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcPagAcvsVigenteAc_2_2
		Select sum(isnull(tp.Pagado,0))as PorcPagAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id
		
		----------------------NomPagAcvsVigenteAc
		Declare @TNomPagAcvsVigenteAc_2_1 as table (NomPagAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomPagAcvsVigenteAc_2_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo  
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id

		-------------------PorcCompAcvsVigenteAn
		Declare @TPorcCompAcvsVigenteAn_2_1 as table (PorcCompAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcCompAcvsVigenteAn_2_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcCompAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id 
		
		Declare @TPorcCompAcvsVigenteAn_2_2 as table (PorcCompAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcCompAcvsVigenteAn_2_2
		Select  sum(isnull(tp.Comprometido,0)) as PorcCompAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end 
		group by cr.CLAVE, ca.Clave, cepr.id 
		
		-----------------NomCompAcvsVigenteAn
		Declare @TNomCompAcvsVigenteAn_2_1 as table (NomCompAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomCompAcvsVigenteAn_2_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomCompAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr	ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TNomCompAcvsVigenteAn_2_2 as table (NomCompAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomCompAcvsVigenteAn_2_2
		Select  (sum(isnull(tp.Comprometido,0)))as NomCompAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		-----------------PorcDevAcvsVigenteAn
		Declare @TPorcDevAcvsVigenteAn_2_1 as table (PorcDevAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcDevAcvsVigenteAn_2_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal 
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr	ON cepr.Id  = TS.IdProyecto 
		INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcDevAcvsVigenteAn_2_2 as table (PorcDevAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcDevAcvsVigenteAn_2_2
		Select  sum(isnull(tp.Devengado,0)) as PorcDevAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr	ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		-------------------NomDevAcvsVigenteAn
		Declare @TNomDevAcvsVigenteAn_2_1 as table (NomDevAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomDevAcvsVigenteAn_2_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr	ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end		
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TNomDevAcvsVigenteAn_2_2 as table (NomDevAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomDevAcvsVigenteAn_2_2
		Select  (sum(isnull(tp.Devengado,0))) as NomDevAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
	
		------------------PorcEjerAcvsVigenteAn
		Declare @TPorcEjerAcvsVigenteAn_2_1 as table (PorcEjerAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcEjerAcvsVigenteAn_2_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomDevAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcEjerAcvsVigenteAn_2_2 as table (PorcEjerAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcEjerAcvsVigenteAn_2_2
		Select sum(isnull(tp.Ejercido,0)) as NomDevAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id 
		
		-------------------NomEjerAcvsVigenteAn
		Declare @TNomEjerAcvsVigenteAn_2_1 as table (NomEjerAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomEjerAcvsVigenteAn_2_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomEjerAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TNomEjerAcvsVigenteAn_2_2 as table (NomEjerAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomEjerAcvsVigenteAn_2_2
		Select  (sum(isnull(tp.Ejercido,0))) as NomEjerAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		-------------------PorcPagAcvsVigenteAn
		Declare @TPorcPagAcvsVigenteAn_2_1 as table (PorcPagAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcPagAcvsVigenteAn_2_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPagAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcPagAcvsVigenteAn_2_2 as table (PorcPagAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TPorcPagAcvsVigenteAn_2_2
		Select  sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr	ON cepr.Id  = TS.IdProyecto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn 
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		------------------NomPagAcvsVigenteAn
		Declare @TNomPagAcvsVigenteAn_2_1 as table (NomPagAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomPagAcvsVigenteAn_2_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPagAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.Id
		
		Declare @TNomPagAcvsVigenteAn_2_2 as table (NomPagAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), id Int)
		insert into @TNomPagAcvsVigenteAn_2_2
		Select  (sum(isnull(tp.Pagado,0)))  as NomPagAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr	ON cepr.Id  = TS.IdProyecto 
		INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Select Clave1, Descripcion, TR.Clave2, Descripcion2, Clave3, Descripcion3, Clave3a, Descripcion3a, Clave4, Descripcion4, Clave5, NombreAI, 
		Sum(Autorizado)Autorizado, sum(TransferenciaAmp)TransferenciaAmp, sum(TransferenciaRed)TransferenciaRed, sum(Modificado)Modificado, 
		Sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, sum(Comprometido)Comprometido, Sum(PreCompSinComp)PreCompSinComp, 
		SUM(PresDispComp)PresDispComp, sum(Devengado)Devengado, Sum(CompSinDev)CompSinDev, Sum(PresSinDev)PresSinDev, sum(Ejercido)Ejercido, 
		Sum(DevSinEjer)DevSinEjer, Sum(Pagado)Pagado, Sum(EjerSinPagar)EjerSinPagar, sum(Deuda)Deuda, 
		cast(sum(case when isnull(PorcAprobAnual1,0) = 0 then 0 else isnull(PorcAprobAnual2,0) / isnull(PorcAprobAnual1,0) end) as decimal(15,2))PorcAprobAnual,
		cast(sum(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else isnull(PorcAprobadocAnt2,0) / isnull(PorcAprobadocAnt1,0) end) as decimal(15,2))PorcAprobadocAnt,
		sum(isnull(NomAprobado1,0) - isnull(NomAprobado2,0)) NomAprobado,
		cast(Sum(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else isnull(PorcPVigenteAnual2,0) / isnull(PorcPVigenteAnual1,0) end) as decimal(15,2))PorcPVigenteAnual,
		cast(Sum(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else isnull(PorcPVigenteAnt2,0) / isnull(PorcPVigenteAnt1,0) end) as decimal(15,2))PorcPVigenteAnt,
		sum(isnull(NomPVigente1,0) - isnull(NomPVigente2,0)) NomPVigente,
		cast(Sum(case when isnull(PorcCompvsVigente1,0) = 0 then 0 else isnull(PorcCompvsVigente2,0) / isnull(PorcCompvsVigente1,0) end) as decimal(15,2)) PorcCompvsVigente,
		sum(NomCompvsVigente)NomCompvsVigente,
		cast(sum(case when isnull(PorcDevvsVigente1,0) = 0 then 0 else isnull(PorcDevvsVigente2,0) / isnull(PorcDevvsVigente1,0) end) as decimal(15,2))PorcDevvsVigente,
		Sum(NomDevvsVigente)NomDevvsVigente, 
		cast(Sum(case when isnull(PorcCompAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAc2,0) / isnull(PorcCompAcvsVigenteAc1,0) end) as decimal(15,2))PorcCompAcvsVigenteAc,
		sum(isnull(NomCompAcvsVigenteAc1,0))NomCompAcvsVigenteAc,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAc2,0) / isnull(PorcDevAcvsVigenteAc1,0) end) as decimal(15,2)) PorcDevAcvsVigenteAc,
		sum(isnull(NomDevAcvsVigenteAc1,0))NomDevAcvsVigenteAc,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAc2,0) / isnull(PorcEjerAcvsVigenteAc1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAc,
		sum(isnull(NomEjerAcvsVigenteAc1,0))NomEjerAcvsVigenteAc,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAc2,0) / isnull(PorcPagAcvsVigenteAc1,0) end) as decimal(15,2))PorcPagAcvsVigenteAc,
		sum(isnull(NomPagAcvsVigenteAc1,0))NomPagAcvsVigenteAc,
		cast(sum(case when isnull(PorcCompAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAn2,0) / isnull(PorcCompAcvsVigenteAn1,0) end) as decimal(15,2))PorcCompAcvsVigenteAn,
		sum(isnull(NomCompAcvsVigenteAn1,0) - isnull(NomCompAcvsVigenteAn2,0))NomCompAcvsVigenteAn,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAn2,0) / isnull(PorcDevAcvsVigenteAn1,0) end) as decimal(15,2))PorcDevAcvsVigenteAn,
		Sum(isnull(NomDevAcvsVigenteAn1,0)- isnull(NomDevAcvsVigenteAn2,0)) NomDevAcvsVigenteAn,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAn2,0) / isnull(PorcEjerAcvsVigenteAn1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAn,
		sum(isnull(NomEjerAcvsVigenteAn1,0) - isnull(NomEjerAcvsVigenteAn2,0))NomEjerAcvsVigenteAn,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAn2,0) / isnull(PorcPagAcvsVigenteAn1,0) end) as decimal(15,2))PorcPagAcvsVigenteAn,
		sum(isnull(NomPagAcvsVigenteAn1,0) - isnull(NomPagAcvsVigenteAn2,0)) NomPagAcvsVigenteAn
		from @TResultadoFinal_2 as TR
		left outer join @TPorcAprobAnual_2_1		as T_1_1  on T_1_1.ID  = TR.ID and t_1_1.clave2  = Tr.Clave2 
		left outer join @TPorcAprobAnual_2_2		as T_1_2  on T_1_2.ID  = TR.ID and t_1_2.clave2  = Tr.Clave2 
		left outer join @TPorcAprobadocAnt_2_1		as T_2_1  on T_2_1.ID  = TR.ID and T_2_1.clave2  = Tr.Clave2
		left outer join @TPorcAprobadocAnt_2_2		as T_2_2  on T_2_2.ID  = TR.ID and T_2_2.clave2  = Tr.Clave2
		left outer join @TNomAprobado_2_1			as T_3_1  on T_3_1.ID  = TR.ID and T_3_1.clave2  = Tr.Clave2
		left outer join @TNomAprobado_2_2			as T_3_2  on T_3_2.ID  = TR.ID and T_3_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_2_1		as T_4_1  on T_4_1.ID  = TR.ID and T_4_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_2_2		as T_4_2  on T_4_2.ID  = TR.ID and T_4_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_2_1		as T_5_1  on T_5_1.ID  = TR.ID and T_5_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_2_2		as T_5_2  on T_5_2.ID  = TR.ID and T_5_2.clave2  = Tr.Clave2
		left outer join @TNomPVigente_2_1			as T_6_1  on T_6_1.ID  = TR.ID and T_6_1.clave2  = Tr.Clave2
		left outer join @TNomPVigente_2_2			as T_6_2  on T_6_2.ID  = TR.ID and T_6_2.clave2  = Tr.Clave2
		left outer join @TPorcCompvsVigente_2_1		as T_7_1  on T_7_1.ID  = TR.ID and T_7_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompvsVigente_2_2		as T_7_2  on T_7_2.ID  = TR.ID and T_7_2.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_2_1		as T_8_1  on T_8_1.ID  = TR.ID and T_8_1.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_2_2		as T_8_2  on T_8_2.ID  = TR.ID and T_8_2.clave2  = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAc_2_1 as T_9_1  on T_9_1.ID  = TR.ID and T_9_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompAcvsVigenteAc_2_2 as T_9_2  on T_9_2.ID  = TR.ID and T_9_2.clave2  = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAc_2_1	as T_10_1 on T_10_1.ID = TR.ID and T_10_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_2_1	as T_11_1 on T_11_1.ID = TR.ID and T_11_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_2_2	as T_11_2 on T_11_2.ID = TR.ID and T_11_2.clave2 = Tr.Clave2
		left outer join @TNomDevAcvsVigenteAc_2_1	as T_12_1 on T_12_1.ID = TR.ID and T_12_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_2_1 as T_13_1 on T_13_1.ID = TR.ID and T_13_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_2_2 as T_13_2 on T_13_2.ID = TR.ID and T_13_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAc_2_1	as T_14_1 on T_14_1.ID = TR.ID and T_14_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_2_1	as T_15_1 on T_15_1.ID = TR.ID and T_15_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_2_2	as T_15_2 on T_15_2.ID = TR.ID and T_15_2.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAc_2_1	as T_16_1 on T_16_1.ID = TR.ID and T_16_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_2_1 as T_17_1 on T_17_1.ID = TR.ID and T_17_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_2_2 as T_17_2 on T_17_2.ID = TR.ID and T_17_2.clave2 = Tr.Clave2
		left outer join @TNomCompAcvsVigenteAn_2_1	as T_18_1 on T_18_1.ID = TR.ID and T_18_1.clave2 = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAn_2_2	as T_18_2 on T_18_2.ID = TR.ID and T_18_2.clave2 = Tr.Clave2 
		left outer join @TPorcDevAcvsVigenteAn_2_1	as T_19_1 on T_19_1.ID = TR.ID and T_19_1.clave2 = Tr.Clave2  
		left outer join @TPorcDevAcvsVigenteAn_2_2	as T_19_2 on T_19_2.ID = TR.ID and T_19_2.clave2 = Tr.Clave2   
		left outer join @TNomDevAcvsVigenteAn_2_1	as T_20_1 on T_20_1.ID = TR.ID and T_20_1.clave2 = Tr.Clave2  
		left outer join @TNomDevAcvsVigenteAn_2_2	as T_20_2 on T_20_2.ID = TR.ID and T_20_2.clave2 = Tr.Clave2  
		left outer join @TPorcEjerAcvsVigenteAn_2_1 as T_21_1 on T_21_1.ID = TR.ID and T_21_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAn_2_2 as T_21_2 on T_21_2.ID = TR.ID and T_21_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAn_2_1	as T_22_1 on T_22_1.ID = TR.ID and T_22_1.clave2 = Tr.Clave2 
		left outer join @TNomEjerAcvsVigenteAn_2_2	as T_22_2 on T_22_2.ID = TR.ID and T_22_2.clave2 = Tr.Clave2  
		left outer join @TPorcPagAcvsVigenteAn_2_1	as T_23_1 on T_23_1.ID = TR.ID and T_23_1.clave2 = Tr.Clave2 
		left outer join @TPorcPagAcvsVigenteAn_2_2	as T_23_2 on T_23_2.ID = TR.ID and T_23_2.clave2 = Tr.Clave2 
		left outer join @TNomPagAcvsVigenteAn_2_1	as T_24_1 on T_24_1.ID = TR.ID and T_24_1.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAn_2_2	as T_24_2 on T_24_2.ID = TR.ID and T_24_2.clave2 = Tr.Clave2
		group by Clave1, Descripcion, TR.Clave2, Descripcion2, Clave3, Descripcion3, Clave3a, Descripcion3a, Clave4, Descripcion4, Clave5, NombreAI
		order by Tr.Clave2, Clave5	
	END

	If @Tipo = 3 
	BEGIN
		--Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica
		--Valores Absolutos

		DECLARE @TResultadoFinal_3 as table (Clave1 varchar(8), Descripcion varchar(150),	Clave2 varchar(8), Descripcion2 varchar(150), Clave3 varchar(8),
		NombreAI varchar(150), Clave3a varchar(8), Descripcion3a varchar(150), Clave4 varchar(MAx), Descripcion4 varchar(150), Id varchar(8), 
		Clave5 varchar(8), Descripcion3 varchar(150), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), 
		Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), PreCompSinComp decimal(15,2), 
		PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2), Ejercido decimal(15,2), 
		DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2), 
		PorcAprobadocAnt decimal(15,2),	NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2),	PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2),
		PorcCompvsVigente decimal(15,2), NomCompvsVigente decimal(15,2), PorcDevvsVigente decimal(15,2), NomDevvsVigente decimal(15,2),
		PorcCompAcvsVigenteAc decimal(15,2), NomCompAcvsVigenteAc decimal(15,2), PorcDevAcvsVigenteAc decimal(15,2), NomDevAcvsVigenteAc decimal(15,2),
		PorcEjerAcvsVigenteAc decimal(15,2), NomEjerAcvsVigenteAc decimal(15,2), PorcPagAcvsVigenteAc decimal(15,2), NomPagAcvsVigenteAc decimal(15,2),
		PorcCompAcvsVigenteAn decimal(15,2), NomCompAcvsVigenteAn decimal(15,2), PorcDevAcvsVigenteAn decimal(15,2), NomDevAcvsVigenteAn decimal(15,2),
		PorcEjerAcvsVigenteAn decimal(15,2), NomEjerAcvsVigenteAn decimal(15,2), PorcPagAcvsVigenteAn decimal(15,2), NomPagAcvsVigenteAn decimal(15,2))

		--DECLARE @nombre1AI varchar(255)
		--DECLARE @clave1AI varchar(255)

		--SET @nombre1AI = (SELECT  tablaID.nombre 
		--FROM
		--(select * from C_EP_Ramo where id= @IdEP  and Nivel = 5) tablaID
		--inner join
		--(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		--ON tablaID.IdPadre = tablaAI.Id);
		--SELECT @clave1AI =  tablaID.Clave  
		--FROM
		--(select * from C_EP_Ramo where id= @IdEP and Nivel = 5) tablaID
		--inner join
		--(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		--ON tablaID.IdPadre = tablaAI.Id

		INSERT INTO @TResultadoFinal_3 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, NombreAI, Clave3a, Descripcion3a, Clave4, Descripcion4, Id,
		Clave5, Descripcion3, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp,Comprometido, PreCompSinComp, 
		PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual, PorcAprobadocAnt,
		NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente, PorcCompvsVigente, NomCompvsVigente, PorcDevvsVigente, NomDevvsVigente, 
		PorcCompAcvsVigenteAc, NomCompAcvsVigenteAc, PorcDevAcvsVigenteAc, NomDevAcvsVigenteAc, PorcEjerAcvsVigenteAc, NomEjerAcvsVigenteAc,
		PorcPagAcvsVigenteAc, NomPagAcvsVigenteAc, PorcCompAcvsVigenteAn, NomCompAcvsVigenteAn, PorcDevAcvsVigenteAn, NomDevAcvsVigenteAn,
		PorcEjerAcvsVigenteAn, NomEjerAcvsVigenteAn, PorcPagAcvsVigenteAn, NomPagAcvsVigenteAn)

		Select   C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
		C_EP_Ramo.Clave AS Clave2, C_EP_Ramo.Nombre as Descripcion2,
		(SELECT tablaID.Clave FROM (select * from C_EP_Ramo as T3 where T3.id = C_EP_Ramo.ID and Nivel = 5) tablaID
		inner join (select * from C_EP_Ramo where  Nivel = 4) tablaAI ON tablaID.IdPadre = tablaAI.Id) as Clave3, 
		'' as NombreAI, 
		C_CapitulosNEP.IdCapitulo as Clave3a, C_CapitulosNEP.Descripcion as Descripcion3a, C_ConceptosNEP.IdConcepto  as Clave4,  
		C_ConceptosNEP.Descripcion as Descripcion4, C_EP_Ramo.Id, C_TipoGasto.Clave as Clave5, C_TipoGasto.NOMBRE as Descripcion3, 
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP ON  C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo INNER JOIN C_EP_Ramo 
		ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto 		 
		where  (Mes BETWEEN @Mes and @Mes2) AND Year=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.Clave else
		@Clave end  and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end)  
		AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.Id else @IdEP end  
		Group by C_CapitulosNEP.IdCapitulo, C_CapitulosNEP.Descripcion, C_TipoGasto.Clave ,C_TipoGasto.NOMBRE,C_EP_Ramo.Clave,C_EP_Ramo.Id,C_EP_Ramo.Nombre,
		C_RamoPresupuestal.CLAVE ,C_RamoPresupuestal.DESCRIPCION, C_ConceptosNEP.IdConcepto, C_ConceptosNEP.Descripcion 
		Order by C_TipoGasto.Clave, C_CapitulosNEP.IdCapitulo ,C_RamoPresupuestal.CLAVE
		
		--Columna 1 PorcAprobAnual
		Declare @TPorcAprobAnual_3_1 as table (PorcAprobAnual1 decimal(15,2), Clave int, id Int)
		insert into @TPorcAprobAnual_3_1
		Select  sum(isnull(TP.Autorizado,0))  as PorcAprobAnual1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE, cepr.Id

		Declare @TPorcAprobAnual_3_2 as table (PorcAprobAnual2 decimal(15,2), Clave int, id Int)
		insert into @TPorcAprobAnual_3_2
		Select  sum(isnull(tp.Autorizado,0))  as PorcAprobAnual2, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE, cepr.Id
		
		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_3_1 as table (PorcAprobadocAnt1 decimal(15,2), Clave int, id Int)
		insert into @TPorcAprobadocAnt_3_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr 	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id 
		
		Declare @TPorcAprobadocAnt_3_2 as table (PorcAprobadocAnt2 decimal(15,2), Clave int, id Int)
		insert into @TPorcAprobadocAnt_3_2
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_3_1 as table (NomAprobado1 decimal(15,2), Clave int, id Int)
		insert into @TNomAprobado_3_1
		Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr 	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		Declare @TNomAprobado_3_2 as table (NomAprobado2 decimal(15,2), Clave int, id Int)
		insert into @TNomAprobado_3_2
		Select  sum(isnull(tp.Autorizado,0))as NomAprobado1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id 
		
		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_3_1 as table (PorcPVigenteAnual1 decimal(15,2), Clave int, id Int)
		insert into @TPorcPVigenteAnual_3_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes = 0) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		Declare @TPorcPVigenteAnual_3_2 as table (PorcPVigenteAnual2 decimal(15,2), Clave int, id Int)
		insert into @TPorcPVigenteAnual_3_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id 
		
		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_3_1 as table (PorcPVigenteAnt1 decimal(15,2), Clave int, id Int)
		insert into @TPorcPVigenteAnt_3_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE, cepr.Id 
		
		Declare @TPorcPVigenteAnt_3_2 as table (PorcPVigenteAnt2 decimal(15,2), Clave int, id Int)
		insert into @TPorcPVigenteAnt_3_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_3_1 as table (NomPVigente1 decimal(15,2), Clave int, id Int)
		insert into @TNomPVigente_3_1 
		Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr 	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		Declare @TNomPVigente_3_2 as table (NomPVigente2 decimal(15,2), Clave int, id Int)
		insert into @TNomPVigente_3_2 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr 	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE, cepr.Id 
		
		------------PorcCompvsVigente
		Declare @TPorcCompvsVigente_3_1 as table (PorcCompvsVigente1 decimal(15,2), Clave int, id Int)
		insert into @TPorcCompvsVigente_3_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcCompvsVigente1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr 	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id
		
		Declare @TPorcCompvsVigente_3_2 as table (PorcCompvsVigente2 decimal(15,2), Clave int, id Int)
		insert into @TPorcCompvsVigente_3_2
		Select sum(isnull(TP.Comprometido,0))as PorcCompvsVigente1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id
		
		-----------PorcDevvsVigente
		Declare @TPorcDevvsVigente_3_1 as table (PorcDevvsVigente1 decimal(15,2), Clave int, id Int)
		insert into @TPorcDevvsVigente_3_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcCompvsVigente1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id
		
		Declare @TPorcDevvsVigente_3_2 as table (PorcDevvsVigente2 decimal(15,2), Clave int, id Int)
		insert into @TPorcDevvsVigente_3_2
		Select sum(isnull(TP.Devengado,0))as PorcCompvsVigente2, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		--------------PorcCompAcvsVigenteAc
		Declare @TPorcCompAcvsVigenteAc_3_1 as table (PorcCompAcvsVigenteAc1 decimal(15,2), Clave int, id Int)
		insert into @TPorcCompAcvsVigenteAc_3_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAc1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		Declare @TPorcCompAcvsVigenteAc_3_2 as table (PorcCompAcvsVigenteAc2 decimal(15,2), Clave int, id Int)
		insert into @TPorcCompAcvsVigenteAc_3_2
		Select sum(isnull(tp.Comprometido,0))as PorcCompAcvsVigenteAc2, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		---------------NomCompAcvsVigenteAc
		Declare @TNomCompAcvsVigenteAc_3_1 as table (NomCompAcvsVigenteAc1 decimal(15,2), Clave int, id Int)
		insert into @TNomCompAcvsVigenteAc_3_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0))as NomCompAcvsVigenteAc1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		-------------PorcDevAcvsVigenteAc
		Declare @TPorcDevAcvsVigenteAc_3_1 as table (PorcDevAcvsVigenteAc1 decimal(15,2), Clave int, id Int)
		insert into @TPorcDevAcvsVigenteAc_3_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevAcvsVigenteAc1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto   INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id 
		
		Declare @TPorcDevAcvsVigenteAc_3_2 as table (PorcDevAcvsVigenteAc2 decimal(15,2), Clave int, id Int)
		insert into @TPorcDevAcvsVigenteAc_3_2
		Select sum(isnull(tp.Devengado,0)) as PorcDevAcvsVigenteAc2, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id  
		
		-----------------NomDevAcvsVigenteAc
		Declare @TNomDevAcvsVigenteAc_3_1 as table (NomDevAcvsVigenteAc1 decimal(15,2), Clave int, id Int)
		insert into @TNomDevAcvsVigenteAc_3_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0)) as NomDevAcvsVigenteAc1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id 	
		
		-------------PorcEjerAcvsVigenteAc
		Declare @TPorcEjerAcvsVigenteAc_3_1 as table (PorcEjerAcvsVigenteAc1 decimal(15,2), Clave int, id Int)
		insert into @TPorcEjerAcvsVigenteAc_3_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcEjerAcvsVigenteAc1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id 
				
		Declare @TPorcEjerAcvsVigenteAc_3_2 as table (PorcEjerAcvsVigenteAc2 decimal(15,2), Clave int, id Int)
		insert into @TPorcEjerAcvsVigenteAc_3_2
		Select sum(isnull(tp.Ejercido,0)) as PorcEjerAcvsVigenteAc2, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id
		
		----------------NomEjerAcvsVigenteAc
		Declare @TNomEjerAcvsVigenteAc_3_1 as table (NomEjerAcvsVigenteAc1 decimal(15,2), Clave int, id Int)
		insert into @TNomEjerAcvsVigenteAc_3_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0)) as NomEjerAcvsVigenteAc1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id 
		
		--------------PorcPagAcvsVigenteAc
		Declare @TPorcPagAcvsVigenteAc_3_1 as table (PorcPagAcvsVigenteAc1 decimal(15,2), Clave int, id Int)
		insert into @TPorcPagAcvsVigenteAc_3_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPagAcvsVigenteAc1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id 
		
		
		Declare @TPorcPagAcvsVigenteAc_3_2 as table (PorcPagAcvsVigenteAc2 decimal(15,2), Clave int, id Int)
		insert into @TPorcPagAcvsVigenteAc_3_2
		Select sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAc2, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id 
		
		--------------NomPagAcvsVigenteAc
		Declare @TNomPagAcvsVigenteAc_3_1 as table (NomPagAcvsVigenteAc1 decimal(15,2), Clave int, id Int)
		insert into @TNomPagAcvsVigenteAc_3_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAc2, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		----------------PorcCompAcvsVigenteAn
		Declare @TPorcCompAcvsVigenteAn_3_1 as table (PorcCompAcvsVigenteAn1 decimal(15,2), Clave int, id Int)
		insert into @TPorcCompAcvsVigenteAn_3_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAn1, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		Declare @TPorcCompAcvsVigenteAn_3_2 as table (PorcCompAcvsVigenteAn2 decimal(15,2), Clave int, id Int)
		insert into @TPorcCompAcvsVigenteAn_3_2
		Select  sum(isnull(tp.Comprometido,0)) as PorcCompAcvsVigenteAn2, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		--------------NomCompAcvsVigenteAn
		Declare @TNomCompAcvsVigenteAn_3_1 as table (NomCompAcvsVigenteAn1 decimal(15,2), Clave int, id Int)
		insert into @TNomCompAcvsVigenteAn_3_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAn2, cr.CLAVE, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr 	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id 
		
		Declare @TNomCompAcvsVigenteAn_3_2 as table (NomCompAcvsVigenteAn2 decimal(15,2), Clave int, id Int)
		insert into @TNomCompAcvsVigenteAn_3_2
		Select  (sum(isnull(tp.Comprometido,0)))as NomCompAcvsVigenteAn2, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		------------PorcDevAcvsVigenteAn
		Declare @TPorcDevAcvsVigenteAn_3_1 as table (PorcDevAcvsVigenteAn1 decimal(15,2), Clave int, id Int)
		insert into @TPorcDevAcvsVigenteAn_3_1 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcDevAcvsVigenteAn1, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id 
		
		Declare @TPorcDevAcvsVigenteAn_3_2 as table (PorcDevAcvsVigenteAn2 decimal(15,2), Clave int, id Int)
		insert into @TPorcDevAcvsVigenteAn_3_2
		Select   sum(isnull(tp.Devengado,0))as PorcDevAcvsVigenteAn2, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto   	INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id 

		-------------NomDevAcvsVigenteAn
		Declare @TNomDevAcvsVigenteAn_3_1 as table (NomDevAcvsVigenteAn1 decimal(15,2), Clave int, id Int)
		insert into @TNomDevAcvsVigenteAn_3_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomDevAcvsVigenteAn1, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id 
		
		Declare @TNomDevAcvsVigenteAn_3_2 as table (NomDevAcvsVigenteAn2 decimal(15,2), Clave int, id Int)
		insert into @TNomDevAcvsVigenteAn_3_2
		Select  (sum(isnull(tp.Devengado,0))) as NomDevAcvsVigenteAn2, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
				
		-------------PorcEjerAcvsVigenteAn
		Declare @TPorcEjerAcvsVigenteAn_3_1 as table (PorcEjerAcvsVigenteAn1 decimal(15,2), Clave int, id Int)
		insert into @TPorcEjerAcvsVigenteAn_3_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcEjerAcvsVigenteAn1, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id  
		
		Declare @TPorcEjerAcvsVigenteAn_3_2 as table (PorcEjerAcvsVigenteAn2 decimal(15,2), Clave int, id Int)
		insert into @TPorcEjerAcvsVigenteAn_3_2
		Select  sum(isnull(tp.Ejercido,0))  as PorcEjerAcvsVigenteAn2, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end
		group by cr.CLAVE,  cepr.Id
		
		------------NomEjerAcvsVigenteAn
		Declare @TNomEjerAcvsVigenteAn_3_1 as table (NomEjerAcvsVigenteAn1 decimal(15,2), Clave int, id Int)
		insert into @TNomEjerAcvsVigenteAn_3_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomEjerAcvsVigenteAn1, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id
		
		Declare @TNomEjerAcvsVigenteAn_3_2 as table (NomEjerAcvsVigenteAn2 decimal(15,2), Clave int, id Int)
		insert into @TNomEjerAcvsVigenteAn_3_2
		Select  (sum(isnull(tp.Ejercido,0))) as NomEjerAcvsVigenteAn1, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id 
				
		------------PorcPagAcvsVigenteAn
		Declare @TPorcPagAcvsVigenteAn_3_1 as table (PorcPagAcvsVigenteAn1 decimal(15,2), Clave int, id Int)
		insert into @TPorcPagAcvsVigenteAn_3_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcPagAcvsVigenteAn1, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id
		
		Declare @TPorcPagAcvsVigenteAn_3_2 as table (PorcPagAcvsVigenteAn2 decimal(15,2), Clave int, id Int)
		insert into @TPorcPagAcvsVigenteAn_3_2
		Select  sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAn1, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id
		
		----------------NomPagAcvsVigenteAn
		Declare @TNomPagAcvsVigenteAn_3_1 as table (NomPagAcvsVigenteAn1 decimal(15,2), Clave int, id Int)
		insert into @TNomPagAcvsVigenteAn_3_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcPagAcvsVigenteAn1, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr 	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id
		
		Declare @TNomPagAcvsVigenteAn_3_2 as table (NomPagAcvsVigenteAn2 decimal(15,2), Clave int, id Int)
		insert into @TNomPagAcvsVigenteAn_3_2
		Select  (sum(isnull(tp.Pagado,0))) as PorcPagAcvsVigenteAn2, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP CN ON  CN.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP CPN ON CPN.IdCapitulo = CN.IdCapitulo	INNER JOIN C_EP_Ramo  cepr	ON cepr.Id  = T_SellosPresupuestales.IdProyecto 
		left join @TResultadoFinal_3 as T3 ON t3.id = cepr.id and Clave1 = cr.CLAVE and Clave3a = cpn.IdCapitulo  and cn.IdConcepto = clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP  end 
		group by cr.CLAVE,  cepr.Id
		
		Select Clave1, Descripcion, TR.Clave2, Descripcion2, Clave3, NombreAI, Clave3a, Descripcion3a, Clave4, Descripcion4, Clave5, Descripcion3,
		Sum(Autorizado)Autorizado, sum(TransferenciaAmp)TransferenciaAmp, sum(TransferenciaRed)TransferenciaRed, sum(Modificado)Modificado, 
		Sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, sum(Comprometido)Comprometido, Sum(PreCompSinComp)PreCompSinComp, 
		SUM(PresDispComp)PresDispComp, sum(Devengado)Devengado, Sum(CompSinDev)CompSinDev, Sum(PresSinDev)PresSinDev, sum(Ejercido)Ejercido, 
		Sum(DevSinEjer)DevSinEjer, Sum(Pagado)Pagado, Sum(EjerSinPagar)EjerSinPagar, sum(Deuda)Deuda,
		cast(sum(case when isnull(PorcAprobAnual1,0) = 0 then 0 else isnull(PorcAprobAnual2,0) / isnull(PorcAprobAnual1,0) end) as decimal(15,2))PorcAprobAnual,
		cast(sum(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else isnull(PorcAprobadocAnt2,0) / isnull(PorcAprobadocAnt1,0) end) as decimal(15,2))PorcAprobadocAnt,
		sum(isnull(NomAprobado1,0) - isnull(NomAprobado2,0)) NomAprobado,
		cast(Sum(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else isnull(PorcPVigenteAnual2,0) / isnull(PorcPVigenteAnual1,0) end) as decimal(15,2))PorcPVigenteAnual,
		cast(Sum(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else isnull(PorcPVigenteAnt2,0) / isnull(PorcPVigenteAnt1,0) end) as decimal(15,2))PorcPVigenteAnt,
		sum(isnull(NomPVigente1,0) - isnull(NomPVigente2,0)) NomPVigente,
		cast(Sum(case when isnull(PorcCompvsVigente1,0) = 0 then 0 else isnull(PorcCompvsVigente2,0) / isnull(PorcCompvsVigente1,0) end) as decimal(15,2)) PorcCompvsVigente,
		sum(NomCompvsVigente)NomCompvsVigente,
		cast(sum(case when isnull(PorcDevvsVigente1,0) = 0 then 0 else isnull(PorcDevvsVigente2,0) / isnull(PorcDevvsVigente1,0) end) as decimal(15,2))PorcDevvsVigente,
		Sum(NomDevvsVigente)NomDevvsVigente,
		cast(Sum(case when isnull(PorcCompAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAc2,0) / isnull(PorcCompAcvsVigenteAc1,0) end) as decimal(15,2))PorcCompAcvsVigenteAc,
		sum(isnull(NomCompAcvsVigenteAc1,0))NomCompAcvsVigenteAc,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAc2,0) / isnull(PorcDevAcvsVigenteAc1,0) end) as decimal(15,2)) PorcDevAcvsVigenteAc,
		sum(isnull(NomDevAcvsVigenteAc1,0))NomDevAcvsVigenteAc,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAc2,0) / isnull(PorcEjerAcvsVigenteAc1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAc,
		sum(isnull(NomEjerAcvsVigenteAc1,0))NomEjerAcvsVigenteAc,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAc2,0) / isnull(PorcPagAcvsVigenteAc1,0) end) as decimal(15,2))PorcPagAcvsVigenteAc,
		sum(isnull(NomPagAcvsVigenteAc1,0))NomPagAcvsVigenteAc,
		cast(sum(case when isnull(PorcCompAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAn2,0) / isnull(PorcCompAcvsVigenteAn1,0) end) as decimal(15,2))PorcCompAcvsVigenteAn,
		sum(isnull(NomCompAcvsVigenteAn1,0) - isnull(NomCompAcvsVigenteAn2,0))NomCompAcvsVigenteAn,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAn2,0) / isnull(PorcDevAcvsVigenteAn1,0) end) as decimal(15,2))PorcDevAcvsVigenteAn,
		Sum(isnull(NomDevAcvsVigenteAn1,0)- isnull(NomDevAcvsVigenteAn2,0)) NomDevAcvsVigenteAn,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAn2,0) / isnull(PorcEjerAcvsVigenteAn1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAn,
		sum(isnull(NomEjerAcvsVigenteAn1,0) - isnull(NomEjerAcvsVigenteAn2,0))NomEjerAcvsVigenteAn,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAn2,0) / isnull(PorcPagAcvsVigenteAn1,0) end) as decimal(15,2))PorcPagAcvsVigenteAn,
		sum(isnull(NomPagAcvsVigenteAn1,0) - isnull(NomPagAcvsVigenteAn2,0)) NomPagAcvsVigenteAn
		from @TResultadoFinal_3 as TR
		left outer join @TPorcAprobAnual_3_1		as T_1_1  on T_1_1.ID  = TR.ID --and t_1_1.clave2  = Tr.Clave2 
		left outer join @TPorcAprobAnual_3_2		as T_1_2  on T_1_2.ID  = TR.ID --and t_1_2.clave2  = Tr.Clave2 
		left outer join @TPorcAprobadocAnt_3_1		as T_2_1  on T_2_1.ID  = TR.ID --and T_2_1.clave2  = Tr.Clave2
		left outer join @TPorcAprobadocAnt_3_2		as T_2_2  on T_2_2.ID  = TR.ID --and T_2_2.clave2  = Tr.Clave2
		left outer join @TNomAprobado_3_1			as T_3_1  on T_3_1.ID  = TR.ID --and T_3_1.clave2  = Tr.Clave2
		left outer join @TNomAprobado_3_2			as T_3_2  on T_3_2.ID  = TR.ID --and T_3_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_3_1		as T_4_1  on T_4_1.ID  = TR.ID --and T_4_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_3_2		as T_4_2  on T_4_2.ID  = TR.ID --and T_4_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_3_1		as T_5_1  on T_5_1.ID  = TR.ID --and T_5_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_3_2		as T_5_2  on T_5_2.ID  = TR.ID --and T_5_2.clave2  = Tr.Clave2
		left outer join @TNomPVigente_3_1			as T_6_1  on T_6_1.ID  = TR.ID --and T_6_1.clave2  = Tr.Clave2
		left outer join @TNomPVigente_3_2			as T_6_2  on T_6_2.ID  = TR.ID --and T_6_2.clave2  = Tr.Clave2
		left outer join @TPorcCompvsVigente_3_1		as T_7_1  on T_7_1.ID  = TR.ID --and T_7_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompvsVigente_3_2		as T_7_2  on T_7_2.ID  = TR.ID --and T_7_2.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_3_1		as T_8_1  on T_8_1.ID  = TR.ID --and T_8_1.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_3_2		as T_8_2  on T_8_2.ID  = TR.ID --and T_8_2.clave2  = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAc_3_1 as T_9_1  on T_9_1.ID  = TR.ID --and T_9_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompAcvsVigenteAc_3_2 as T_9_2  on T_9_2.ID  = TR.ID --and T_9_2.clave2  = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAc_3_1	as T_10_1 on T_10_1.ID = TR.ID --and T_10_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_3_1	as T_11_1 on T_11_1.ID = TR.ID --and T_11_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_3_2	as T_11_2 on T_11_2.ID = TR.ID --and T_11_2.clave2 = Tr.Clave2
		left outer join @TNomDevAcvsVigenteAc_3_1	as T_12_1 on T_12_1.ID = TR.ID --and T_12_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_3_1 as T_13_1 on T_13_1.ID = TR.ID --and T_13_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_3_2 as T_13_2 on T_13_2.ID = TR.ID --and T_13_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAc_3_1	as T_14_1 on T_14_1.ID = TR.ID --and T_14_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_3_1	as T_15_1 on T_15_1.ID = TR.ID --and T_15_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_3_2	as T_15_2 on T_15_2.ID = TR.ID --and T_15_2.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAc_3_1	as T_16_1 on T_16_1.ID = TR.ID --and T_16_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_3_1 as T_17_1 on T_17_1.ID = TR.ID --and T_17_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_3_2 as T_17_2 on T_17_2.ID = TR.ID --and T_17_2.clave2 = Tr.Clave2
		left outer join @TNomCompAcvsVigenteAn_3_1	as T_18_1 on T_18_1.ID = TR.ID --and T_18_1.clave2 = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAn_3_2	as T_18_2 on T_18_2.ID = TR.ID --and T_18_2.clave2 = Tr.Clave2 
		left outer join @TPorcDevAcvsVigenteAn_3_1	as T_19_1 on T_19_1.ID = TR.ID --and T_19_1.clave2 = Tr.Clave2  
		left outer join @TPorcDevAcvsVigenteAn_3_2	as T_19_2 on T_19_2.ID = TR.ID --and T_19_2.clave2 = Tr.Clave2   
		left outer join @TNomDevAcvsVigenteAn_3_1	as T_20_1 on T_20_1.ID = TR.ID --and T_20_1.clave2 = Tr.Clave2  
		left outer join @TNomDevAcvsVigenteAn_3_2	as T_20_2 on T_20_2.ID = TR.ID --and T_20_2.clave2 = Tr.Clave2  
		left outer join @TPorcEjerAcvsVigenteAn_3_1 as T_21_1 on T_21_1.ID = TR.ID --and T_21_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAn_3_2 as T_21_2 on T_21_2.ID = TR.ID --and T_21_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAn_3_1	as T_22_1 on T_22_1.ID = TR.ID --and T_22_1.clave2 = Tr.Clave2 
		left outer join @TNomEjerAcvsVigenteAn_3_2	as T_22_2 on T_22_2.ID = TR.ID --and T_22_2.clave2 = Tr.Clave2  
		left outer join @TPorcPagAcvsVigenteAn_3_1	as T_23_1 on T_23_1.ID = TR.ID --and T_23_1.clave2 = Tr.Clave2 
		left outer join @TPorcPagAcvsVigenteAn_3_2	as T_23_2 on T_23_2.ID = TR.ID --and T_23_2.clave2 = Tr.Clave2 
		left outer join @TNomPagAcvsVigenteAn_3_1	as T_24_1 on T_24_1.ID = TR.ID --and T_24_1.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAn_3_2	as T_24_2 on T_24_2.ID = TR.ID --and T_24_2.clave2 = Tr.Clave2
		group by Clave1, Descripcion, TR.Clave2, Descripcion2, Clave3, Descripcion3, Clave3a, Descripcion3a, Clave4, Descripcion4, Clave5, NombreAI
		order by Tr.Clave2, Clave5	
		 
	END

	If @Tipo = 4 
	BEGIN
		--Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento
		--Valores Absolutos

		DECLARE @TResultadoFinal_4 as table (Clave1 varchar(8), Descripcion varchar(150), Clave2 varchar(8), Descripcion2 varchar(150), Clave3 varchar(8),
		Descripcion3 varchar(150), Clave4 varchar(Max), Id varchar(8), NombreAI varchar(150), Clave5 varchar(8), Descripcion4 varchar(150), Clave6 varchar(8),
		Descripcion5 varchar(150), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), Modificado decimal(15,2), 
		PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2),	Comprometido decimal(15,2), PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), 
		Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2), Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), 
		EjerSinPagar decimal(15,2),	Deuda decimal(15,2), PorcAprobAnual decimal(15,2), PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2),
		PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2),	NomPVigente decimal(15,2), PorcCompvsVigente decimal(15,2),	NomCompvsVigente decimal(15,2),
		PorcDevvsVigente decimal(15,2),	NomDevvsVigente decimal(15,2), PorcCompAcvsVigenteAc decimal(15,2),	NomCompAcvsVigenteAc decimal(15,2),
		PorcDevAcvsVigenteAc decimal(15,2), NomDevAcvsVigenteAc decimal(15,2), PorcEjerAcvsVigenteAc decimal(15,2),	NomEjerAcvsVigenteAc decimal(15,2),
		PorcPagAcvsVigenteAc decimal(15,2), NomPagAcvsVigenteAc decimal(15,2), PorcCompAcvsVigenteAn decimal(15,2),	NomCompAcvsVigenteAn decimal(15,2),
		PorcDevAcvsVigenteAn decimal(15,2),	NomDevAcvsVigenteAn decimal(15,2), PorcEjerAcvsVigenteAn decimal(15,2),	NomEjerAcvsVigenteAn decimal(15,2),
		PorcPagAcvsVigenteAn decimal(15,2), NomPagAcvsVigenteAn decimal(15,2))

		INSERT INTO @TResultadoFinal_4 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Id, NombreAI, Clave5, Descripcion4, Clave6,
		Descripcion5, Autorizado , TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp,Comprometido, PreCompSinComp, 
		PresDispComp , Devengado , CompSinDev, PresSinDev,Ejercido, DevSinEjer, Pagado, EjerSinPagar,Deuda,PorcAprobAnual, PorcAprobadocAnt,
		NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente, PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, 
		PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc, PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,
		NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,	PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,
		NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)

		Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
		C_AreaResponsabilidad.Clave as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2 , 
		C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3, 
		(SELECT tablaID.Clave 	FROM (select * from C_EP_Ramo as T4 where T4.Id = C_EP_Ramo.ID and Nivel = 5) tablaID
		inner join	(select * from C_EP_Ramo where  Nivel = 4) tablaAI ON tablaID.IdPadre = tablaAI.Id) as Clave4,
		C_EP_Ramo.Id,  '' as NombreAI,
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad 
		ON C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave ='' then C_RamoPresupuestal.clave else
		@Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then c_ramoPresupuestal.Clave else @Clave2 end)
		and C_AreaResponsabilidad.Clave  = case when @ClaveUR = '' then C_AreaResponsabilidad.Clave else @ClaveUR end 
		AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.Id else @IdEP end 
		group by C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida , C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre, C_RamoPresupuestal.CLAVE , C_RamoPresupuestal.DESCRIPCION , C_FuenteFinanciamiento.CLAVE, C_FuenteFinanciamiento.DESCRIPCION , C_EP_Ramo.Clave, C_EP_Ramo.Nombre, C_EP_Ramo.Id  
		Order By C_AreaResponsabilidad.Clave ,C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida,C_RamoPresupuestal.CLAVE 

		--Columna 1 PorcAprobAnual
		Declare @TPorcAprobAnual_4_1 as Table (PorcAprobAnual1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcAprobAnual_4_1 
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, ca.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento cff ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.Id  
		
		Declare @TPorcAprobAnual_4_2 as Table (PorcAprobAnual2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcAprobAnual_4_2
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_4_1 as Table (PorcAprobadocAnt1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcAprobadocAnt_4_1
		Select  sum(isnull(tp.Autorizado,0))as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcAprobadocAnt_4_2 as Table (PorcAprobadocAnt2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcAprobadocAnt_4_2
		Select sum(isnull(tp.Autorizado,0))as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg 
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_4_1 as Table (NomAprobado1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomAprobado_4_1
		Select (sum(isnull(tp.Autorizado,0)))as NomAprobado1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and  (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TNomAprobado_4_2 as Table (NomAprobado2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomAprobado_4_2
		Select  sum(isnull(tp.Autorizado,0))as NomAprobado2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP  ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento cff ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_4_1 as Table (PorcPVigenteAnual1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcPVigenteAnual_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg	
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca 
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes = 0) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcPVigenteAnual_4_2 as Table (PorcPVigenteAnual2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcPVigenteAnual_4_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP 	ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_4_1 as Table (PorcPVigenteAnt1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcPVigenteAnt_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcPVigenteAnt_4_2 as Table (PorcPVigenteAnt2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcPVigenteAnt_4_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
			
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_4_1 as Table (NomPVigente1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomPVigente_4_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento cff ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TNomPVigente_4_2 as Table (NomPVigente2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomPVigente_4_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomPVigente2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca 
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		---------------PorcCompvsVigente
		Declare @TPorcCompvsVigente_4_1 as Table (PorcCompvsVigente1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcCompvsVigente_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompvsVigente1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcCompvsVigente_4_2 as Table (PorcCompvsVigente2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcCompvsVigente_4_2
		Select sum(isnull(TP.Comprometido,0))  as PorcCompvsVigente1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		------------------PorcDevvsVigente
		Declare @TPorcDevvsVigente_4_1 as Table (PorcDevvsVigente1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcDevvsVigente_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcCompvsVigente1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcDevvsVigente_4_2 as Table (PorcDevvsVigente2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcDevvsVigente_4_2
		Select sum(isnull(TP.Devengado,0)) as PorcDevvsVigente2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		---------------PorcCompAcvsVigenteAc
		Declare @TPorcCompAcvsVigenteAc_4_1 as Table (PorcCompAcvsVigenteAc1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcCompAcvsVigenteAc_4_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		
		Declare @TPorcCompAcvsVigenteAc_4_2 as Table (PorcCompAcvsVigenteAc2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcCompAcvsVigenteAc_4_2
		Select sum(isnull(tp.Comprometido,0)) as PorcCompAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		-----------------NomCompAcvsVigenteAc
		Declare @TNomCompAcvsVigenteAc_4_1 as Table (NomCompAcvsVigenteAc1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomCompAcvsVigenteAc_4_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0)) as PorcCompAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		---------------PorcDevAcvsVigenteAc
		Declare @TPorcDevAcvsVigenteAc_4_1 as Table (PorcDevAcvsVigenteAc1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcDevAcvsVigenteAc_4_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica  INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento cff ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcDevAcvsVigenteAc_4_2 as Table (PorcDevAcvsVigenteAc2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcDevAcvsVigenteAc_4_2
		Select sum(isnull(tp.Devengado,0)) as PorcDevAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.Id 
		
		------------NomDevAcvsVigenteAc
		Declare @TNomDevAcvsVigenteAc_4_1 as Table (NomDevAcvsVigenteAc1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomDevAcvsVigenteAc_4_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0)) as NomDevAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		----------------PorcEjerAcvsVigenteAc
		Declare @TPorcEjerAcvsVigenteAc_4_1 as Table (PorcEjerAcvsVigenteAc1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcEjerAcvsVigenteAc_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcEjerAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcEjerAcvsVigenteAc_4_2 as Table (PorcEjerAcvsVigenteAc2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcEjerAcvsVigenteAc_4_2
		Select sum(isnull(tp.Ejercido,0)) as PorcEjerAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		---------------NomEjerAcvsVigenteAc
		Declare @TNomEjerAcvsVigenteAc_4_1 as Table (NomEjerAcvsVigenteAc1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomEjerAcvsVigenteAc_4_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0)) as NomEjerAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		---------------PorcPagAcvsVigenteAc
		Declare @TPorcPagAcvsVigenteAc_4_1 as Table (PorcPagAcvsVigenteAc1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcPagAcvsVigenteAc_4_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcPagAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcPagAcvsVigenteAc_4_2 as Table (PorcPagAcvsVigenteAc2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcPagAcvsVigenteAc_4_2
		Select sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		-----------------NomPagAcvsVigenteAc
		Declare @TNomPagAcvsVigenteAc_4_1 as Table (NomPagAcvsVigenteAc1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomPagAcvsVigenteAc_4_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id		

		-------------PorcCompAcvsVigenteAn
		Declare @TPorcCompAcvsVigenteAn_4_1 as Table (PorcCompAcvsVigenteAn1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcCompAcvsVigenteAn_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcCompAcvsVigenteAn_4_2 as Table (PorcCompAcvsVigenteAn2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcCompAcvsVigenteAn_4_2
		Select  sum(isnull(tp.Comprometido,0))  as PorcCompAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id 

		------------NomCompAcvsVigenteAn
		Declare @TNomCompAcvsVigenteAn_4_1 as Table (NomCompAcvsVigenteAn1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomCompAcvsVigenteAn_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomCompAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TNomCompAcvsVigenteAn_4_2 as Table (NomCompAcvsVigenteAn2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomCompAcvsVigenteAn_4_2
		Select  (sum(isnull(tp.Comprometido,0))) as NomCompAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		----------------PorcDevAcvsVigenteAn
		Declare @TPorcDevAcvsVigenteAn_4_1 as Table (PorcDevAcvsVigenteAn1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcDevAcvsVigenteAn_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcDevAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg 
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcDevAcvsVigenteAn_4_2 as Table (PorcDevAcvsVigenteAn2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcDevAcvsVigenteAn_4_2
		Select  sum(isnull(tp.Devengado,0)) as PorcDevAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		---------------NomDevAcvsVigenteAn
		Declare @TNomDevAcvsVigenteAn_4_1 as Table (NomDevAcvsVigenteAn1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomDevAcvsVigenteAn_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomDevAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TNomDevAcvsVigenteAn_4_2 as Table (NomDevAcvsVigenteAn2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomDevAcvsVigenteAn_4_2
		Select  (sum(isnull(tp.Devengado,0))) as NomDevAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
	
		----------------PorcEjerAcvsVigenteAn
		Declare @TPorcEjerAcvsVigenteAn_4_1 as Table (PorcEjerAcvsVigenteAn1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcEjerAcvsVigenteAn_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcEjerAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcEjerAcvsVigenteAn_4_2 as Table (PorcEjerAcvsVigenteAn2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcEjerAcvsVigenteAn_4_2
		Select  sum(isnull(tp.Ejercido,0)) as PorcEjerAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.Id 
		
		------------NomEjerAcvsVigenteAn
		Declare @TNomEjerAcvsVigenteAn_4_1 as Table (NomEjerAcvsVigenteAn1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomEjerAcvsVigenteAn_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomEjerAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto 	INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.Id
		
		Declare @TNomEjerAcvsVigenteAn_4_2 as Table (NomEjerAcvsVigenteAn2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomEjerAcvsVigenteAn_4_2
		Select  (sum(isnull(tp.Ejercido,0))) as NomEjerAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento cff ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		-----------PorcPagAcvsVigenteAn
		Declare @TPorcPagAcvsVigenteAn_4_1 as Table (PorcPagAcvsVigenteAn1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcPagAcvsVigenteAn_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPagAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		 
		Declare @TPorcPagAcvsVigenteAn_4_2 as Table (PorcPagAcvsVigenteAn2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TPorcPagAcvsVigenteAn_4_2
		Select sum(isnull(tp.Pagado,0))as PorcPagAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
				
		----------------NomPagAcvsVigenteAn
		Declare @TNomPagAcvsVigenteAn_4_1 as Table (NomPagAcvsVigenteAn1 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomPagAcvsVigenteAn_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPagAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TNomPagAcvsVigenteAn_4_2 as Table (NomPagAcvsVigenteAn2 decimal(15,2), Clave Int, Clave2 varchar(8), ID Int)
		insert into @TNomPagAcvsVigenteAn_4_2
		Select  (sum(isnull(tp.Pagado,0)))  as NomPagAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento cff
		ON cff.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto 
		--left join  @TResultadoFinal_4 as T4 ON T4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and Clave6 = cff.clave and cpg.IdPartidaGenerica = Clave5
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP ='' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Select Clave1, Descripcion, TR.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, NombreAI, Clave5, Descripcion4, Clave6, Descripcion5,
		Sum(Autorizado)Autorizado, sum(TransferenciaAmp)TransferenciaAmp, sum(TransferenciaRed)TransferenciaRed, sum(Modificado)Modificado, 
		Sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, sum(Comprometido)Comprometido, Sum(PreCompSinComp)PreCompSinComp, 
		SUM(PresDispComp)PresDispComp, sum(Devengado)Devengado, Sum(CompSinDev)CompSinDev, Sum(PresSinDev)PresSinDev, sum(Ejercido)Ejercido, 
		Sum(DevSinEjer)DevSinEjer, Sum(Pagado)Pagado, Sum(EjerSinPagar)EjerSinPagar, sum(Deuda)Deuda,
		cast(sum(case when isnull(PorcAprobAnual1,0) = 0 then 0 else isnull(PorcAprobAnual2,0) / isnull(PorcAprobAnual1,0) end) as decimal(15,2))PorcAprobAnual,
		cast(sum(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else isnull(PorcAprobadocAnt2,0) / isnull(PorcAprobadocAnt1,0) end) as decimal(15,2))PorcAprobadocAnt,
		sum(isnull(NomAprobado1,0) - isnull(NomAprobado2,0)) NomAprobado,
		cast(Sum(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else isnull(PorcPVigenteAnual2,0) / isnull(PorcPVigenteAnual1,0) end) as decimal(15,2))PorcPVigenteAnual,
		cast(Sum(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else isnull(PorcPVigenteAnt2,0) / isnull(PorcPVigenteAnt1,0) end) as decimal(15,2))PorcPVigenteAnt,
		sum(isnull(NomPVigente1,0) - isnull(NomPVigente2,0)) NomPVigente,
		cast(Sum(case when isnull(PorcCompvsVigente1,0) = 0 then 0 else isnull(PorcCompvsVigente2,0) / isnull(PorcCompvsVigente1,0) end) as decimal(15,2)) PorcCompvsVigente,
		sum(NomCompvsVigente)NomCompvsVigente,
		cast(sum(case when isnull(PorcDevvsVigente1,0) = 0 then 0 else isnull(PorcDevvsVigente2,0) / isnull(PorcDevvsVigente1,0) end) as decimal(15,2))PorcDevvsVigente,
		Sum(NomDevvsVigente)NomDevvsVigente,
		cast(Sum(case when isnull(PorcCompAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAc2,0) / isnull(PorcCompAcvsVigenteAc1,0) end) as decimal(15,2))PorcCompAcvsVigenteAc,
		sum(isnull(NomCompAcvsVigenteAc1,0))NomCompAcvsVigenteAc,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAc2,0) / isnull(PorcDevAcvsVigenteAc1,0) end) as decimal(15,2)) PorcDevAcvsVigenteAc,
		sum(isnull(NomDevAcvsVigenteAc1,0))NomDevAcvsVigenteAc,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAc2,0) / isnull(PorcEjerAcvsVigenteAc1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAc,
		sum(isnull(NomEjerAcvsVigenteAc1,0))NomEjerAcvsVigenteAc,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAc2,0) / isnull(PorcPagAcvsVigenteAc1,0) end) as decimal(15,2))PorcPagAcvsVigenteAc,
		sum(isnull(NomPagAcvsVigenteAc1,0))NomPagAcvsVigenteAc,
		cast(sum(case when isnull(PorcCompAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAn2,0) / isnull(PorcCompAcvsVigenteAn1,0) end) as decimal(15,2))PorcCompAcvsVigenteAn,
		sum(isnull(NomCompAcvsVigenteAn1,0) - isnull(NomCompAcvsVigenteAn2,0))NomCompAcvsVigenteAn,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAn2,0) / isnull(PorcDevAcvsVigenteAn1,0) end) as decimal(15,2))PorcDevAcvsVigenteAn,
		Sum(isnull(NomDevAcvsVigenteAn1,0)- isnull(NomDevAcvsVigenteAn2,0)) NomDevAcvsVigenteAn,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAn2,0) / isnull(PorcEjerAcvsVigenteAn1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAn,
		sum(isnull(NomEjerAcvsVigenteAn1,0) - isnull(NomEjerAcvsVigenteAn2,0))NomEjerAcvsVigenteAn,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAn2,0) / isnull(PorcPagAcvsVigenteAn1,0) end) as decimal(15,2))PorcPagAcvsVigenteAn,
		sum(isnull(NomPagAcvsVigenteAn1,0) - isnull(NomPagAcvsVigenteAn2,0)) NomPagAcvsVigenteAn
		from @TResultadoFinal_4 as TR
		left outer join @TPorcAprobAnual_4_1		as T_1_1  on T_1_1.ID  = TR.ID and t_1_1.clave2  = Tr.Clave2 
		left outer join @TPorcAprobAnual_4_2		as T_1_2  on T_1_2.ID  = TR.ID and t_1_2.clave2  = Tr.Clave2 
		left outer join @TPorcAprobadocAnt_4_1		as T_2_1  on T_2_1.ID  = TR.ID and T_2_1.clave2  = Tr.Clave2
		left outer join @TPorcAprobadocAnt_4_2		as T_2_2  on T_2_2.ID  = TR.ID and T_2_2.clave2  = Tr.Clave2
		left outer join @TNomAprobado_4_1			as T_3_1  on T_3_1.ID  = TR.ID and T_3_1.clave2  = Tr.Clave2
		left outer join @TNomAprobado_4_2			as T_3_2  on T_3_2.ID  = TR.ID and T_3_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_4_1		as T_4_1  on T_4_1.ID  = TR.ID and T_4_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_4_2		as T_4_2  on T_4_2.ID  = TR.ID and T_4_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_4_1		as T_5_1  on T_5_1.ID  = TR.ID and T_5_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_4_2		as T_5_2  on T_5_2.ID  = TR.ID and T_5_2.clave2  = Tr.Clave2
		left outer join @TNomPVigente_4_1			as T_6_1  on T_6_1.ID  = TR.ID and T_6_1.clave2  = Tr.Clave2
		left outer join @TNomPVigente_4_2			as T_6_2  on T_6_2.ID  = TR.ID and T_6_2.clave2  = Tr.Clave2
		left outer join @TPorcCompvsVigente_4_1		as T_7_1  on T_7_1.ID  = TR.ID and T_7_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompvsVigente_4_2		as T_7_2  on T_7_2.ID  = TR.ID and T_7_2.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_4_1		as T_8_1  on T_8_1.ID  = TR.ID and T_8_1.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_4_2		as T_8_2  on T_8_2.ID  = TR.ID and T_8_2.clave2  = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAc_4_1 as T_9_1  on T_9_1.ID  = TR.ID and T_9_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompAcvsVigenteAc_4_2 as T_9_2  on T_9_2.ID  = TR.ID and T_9_2.clave2  = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAc_4_1	as T_10_1 on T_10_1.ID = TR.ID and T_10_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_4_1	as T_11_1 on T_11_1.ID = TR.ID and T_11_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_4_2	as T_11_2 on T_11_2.ID = TR.ID and T_11_2.clave2 = Tr.Clave2
		left outer join @TNomDevAcvsVigenteAc_4_1	as T_12_1 on T_12_1.ID = TR.ID and T_12_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_4_1 as T_13_1 on T_13_1.ID = TR.ID and T_13_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_4_2 as T_13_2 on T_13_2.ID = TR.ID and T_13_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAc_4_1	as T_14_1 on T_14_1.ID = TR.ID and T_14_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_4_1	as T_15_1 on T_15_1.ID = TR.ID and T_15_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_4_2	as T_15_2 on T_15_2.ID = TR.ID and T_15_2.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAc_4_1	as T_16_1 on T_16_1.ID = TR.ID and T_16_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_4_1 as T_17_1 on T_17_1.ID = TR.ID and T_17_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_4_2 as T_17_2 on T_17_2.ID = TR.ID and T_17_2.clave2 = Tr.Clave2
		left outer join @TNomCompAcvsVigenteAn_4_1	as T_18_1 on T_18_1.ID = TR.ID and T_18_1.clave2 = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAn_4_2	as T_18_2 on T_18_2.ID = TR.ID and T_18_2.clave2 = Tr.Clave2 
		left outer join @TPorcDevAcvsVigenteAn_4_1	as T_19_1 on T_19_1.ID = TR.ID and T_19_1.clave2 = Tr.Clave2  
		left outer join @TPorcDevAcvsVigenteAn_4_2	as T_19_2 on T_19_2.ID = TR.ID and T_19_2.clave2 = Tr.Clave2   
		left outer join @TNomDevAcvsVigenteAn_4_1	as T_20_1 on T_20_1.ID = TR.ID and T_20_1.clave2 = Tr.Clave2  
		left outer join @TNomDevAcvsVigenteAn_4_2	as T_20_2 on T_20_2.ID = TR.ID and T_20_2.clave2 = Tr.Clave2  
		left outer join @TPorcEjerAcvsVigenteAn_4_1 as T_21_1 on T_21_1.ID = TR.ID and T_21_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAn_4_2 as T_21_2 on T_21_2.ID = TR.ID and T_21_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAn_4_1	as T_22_1 on T_22_1.ID = TR.ID and T_22_1.clave2 = Tr.Clave2 
		left outer join @TNomEjerAcvsVigenteAn_4_2	as T_22_2 on T_22_2.ID = TR.ID and T_22_2.clave2 = Tr.Clave2  
		left outer join @TPorcPagAcvsVigenteAn_4_1	as T_23_1 on T_23_1.ID = TR.ID and T_23_1.clave2 = Tr.Clave2 
		left outer join @TPorcPagAcvsVigenteAn_4_2	as T_23_2 on T_23_2.ID = TR.ID and T_23_2.clave2 = Tr.Clave2 
		left outer join @TNomPagAcvsVigenteAn_4_1	as T_24_1 on T_24_1.ID = TR.ID and T_24_1.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAn_4_2	as T_24_2 on T_24_2.ID = TR.ID and T_24_2.clave2 = Tr.Clave2
		group by Clave1, Descripcion, TR.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, NombreAI, Clave5, Descripcion4, Clave6, Descripcion5
		order by Tr.Clave2, Clave5

	END

	If @Tipo = 5 
	BEGIN	
		--Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Distribución Geográfica
		--Valores Absolutos

		DECLARE @TResultadoFinal_5 as table (	Clave1 varchar(8),Descripcion varchar(150) ,Clave2 varchar(8) ,Descripcion2 varchar(150) ,Clave3 varchar(8) ,
		Descripcion3 varchar(150), Clave4 varchar(Max), Id varchar(8),NombreAI varchar(150),Clave5 varchar(8),Descripcion4 varchar(150) , Clave6 varchar(8),
		Descripcion5 varchar(150) , Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), Modificado decimal(15,2), 
		PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2),Comprometido decimal(15,2), PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), 
		Devengado decimal(15,2), CompSinDev decimal(15,2),PresSinDev decimal(15,2),Ejercido decimal(15,2), 	DevSinEjer decimal(15,2), Pagado decimal(15,2), 
		EjerSinPagar decimal(15,2),Deuda decimal(15,2),	PorcAprobAnual decimal(15,2),	PorcAprobadocAnt decimal(15,2),	NomAprobado decimal(15,2),
		PorcPVigenteAnual decimal(15,2),PorcPVigenteAnt decimal(15,2),NomPVigente decimal(15,2),PorcCompvsVigente decimal(15,2),
		NomCompvsVigente decimal(15,2),	PorcDevvsVigente decimal(15,2),	NomDevvsVigente decimal(15,2),	PorcCompAcvsVigenteAc decimal(15,2),
		NomCompAcvsVigenteAc decimal(15,2),	PorcDevAcvsVigenteAc decimal(15,2),	NomDevAcvsVigenteAc decimal(15,2),	PorcEjerAcvsVigenteAc decimal(15,2),
		NomEjerAcvsVigenteAc decimal(15,2),	PorcPagAcvsVigenteAc decimal(15,2),	NomPagAcvsVigenteAc decimal(15,2),	PorcCompAcvsVigenteAn decimal(15,2),
		NomCompAcvsVigenteAn decimal(15,2),	PorcDevAcvsVigenteAn decimal(15,2),	NomDevAcvsVigenteAn decimal(15,2),	PorcEjerAcvsVigenteAn decimal(15,2),
		NomEjerAcvsVigenteAn decimal(15,2),	PorcPagAcvsVigenteAn decimal(15,2),	NomPagAcvsVigenteAn decimal(15,2))
		
		INSERT INTO @TResultadoFinal_5 (Clave1 ,Descripcion ,Clave2 ,Descripcion2 ,Clave3 ,Descripcion3 , Clave4,Id,NombreAI,Clave5 , Descripcion4,Clave6,
		Descripcion5 ,Autorizado , TransferenciaAmp , TransferenciaRed , Modificado , PreComprometido , PresVigSinPreComp ,Comprometido , PreCompSinComp , PresDispComp , 
		Devengado , CompSinDev ,PresSinDev ,Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda,PorcAprobAnual,PorcAprobadocAnt,NomAprobado,
		PorcPVigenteAnual, PorcPVigenteAnt ,NomPVigente,PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,
		NomCompAcvsVigenteAc,PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,
		NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,
		NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)

		Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
		C_AreaResponsabilidad.Clave as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2 , 
		C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3,
		(SELECT tablaID.Clave FROM (select * from C_EP_Ramo as T5 where T5.id= C_EP_Ramo.ID and Nivel = 5) tablaID
		inner join (select * from C_EP_Ramo where  Nivel = 4) tablaAI ON tablaID.IdPadre = tablaAI.Id)as Clave4,  
		C_EP_Ramo.Id,  '' as NombreAI, C_PartidasGenericasPres.IdPartidaGenerica as Clave5 , C_PartidasGenericasPres.DescripcionPartida  as Descripcion4, 
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
		INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal
		ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad 
		ON (C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal 
		ON C_ClasificadorGeograficoPresupuestal.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   INNER JOIN C_EP_Ramo 
		ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto    INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
		where  (Mes BETWEEN @Mes and @Mes2) AND Year=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then c_RamoPresupuestal.Clave else
		@Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then c_RamoPresupuestal.Clave else @Clave2 end) 
		AND C_AreaResponsabilidad.Clave  = case when @ClaveUR = '' then C_AreaResponsabilidad.Clave else @ClaveUR end  
		AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.ID else @IdEP end    
		group by C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida , C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre, C_RamoPresupuestal.CLAVE , C_RamoPresupuestal.DESCRIPCION ,  C_EP_Ramo.Clave, C_EP_Ramo.Nombre, C_EP_Ramo.Id, C_ClasificadorGeograficoPresupuestal.Clave , C_ClasificadorGeograficoPresupuestal.Descripcion  
		Order By C_AreaResponsabilidad.Clave ,C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida,C_RamoPresupuestal.CLAVE 

		--Columna 1 PorcAprobAnual
		declare @TPorcAprobAnual_5_1 as Table (PorcAprobAnual1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcAprobAnual_5_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		declare @TPorcAprobAnual_5_2 as Table (PorcAprobAnual2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcAprobAnual_5_2
		Select  sum(isnull(tp.Autorizado,0))  as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.id FROM T_SellosPresupuestales 
		INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
	
		--Columna 2 PorcAprobadocAnt
		declare @TPorcAprobadocAnt_5_1 as Table (PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcAprobadocAnt_5_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TPorcAprobadocAnt_5_2 as Table (PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcAprobadocAnt_5_2
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 3 y 4 NomAprobado
		declare @TNomAprobado_5_1 as Table (NomAprobado1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomAprobado_5_1
		Select (sum(isnull(tp.Autorizado,0)))as NomAprobado1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
				
		declare @TNomAprobado_5_2 as Table (NomAprobado2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomAprobado_5_2
		Select  sum(isnull(tp.Autorizado,0))as NomAprobado2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--Columna 5 PorcPVigenteAnual
		declare @TPorcPVigenteAnual_5_1 as Table (PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcPVigenteAnual_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg 	ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes = 0) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TPorcPVigenteAnual_5_2 as Table (PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcPVigenteAnual_5_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--Columna 6 PorcPVigenteAnt
		declare @TPorcPVigenteAnt_5_1 as Table (PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcPVigenteAnt_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica  INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		declare @TPorcPVigenteAnt_5_2 as Table (PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcPVigenteAnt_5_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 7 y 8 NomPVigente
		declare @TNomPVigente_5_1 as Table (NomPVigente1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomPVigente_5_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TNomPVigente_5_2 as Table (NomPVigente2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomPVigente_5_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomPVigente2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		-----------------PorcCompvsVigente
		declare @TPorcCompvsVigente_5_1 as Table (PorcCompvsVigente1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcCompvsVigente_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcCompvsVigente1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  	INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		declare @TPorcCompvsVigente_5_2 as Table (PorcCompvsVigente2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcCompvsVigente_5_2
		Select sum(isnull(TP.Comprometido,0)) as PorcCompvsVigente2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
	
		-----------PorcDevvsVigente
		declare @TPorcDevvsVigente_5_1 as Table (PorcDevvsVigente1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcDevvsVigente_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcDevvsVigente1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TPorcDevvsVigente_5_2 as Table (PorcDevvsVigente2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcDevvsVigente_5_2
		Select sum(isnull(TP.Devengado,0)) as PorcDevvsVigente1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		------------PorcCompAcvsVigenteAc
		declare @TPorcCompAcvsVigenteAc_5_1 as Table (PorcCompAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcCompAcvsVigenteAc_5_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcCompAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TPorcCompAcvsVigenteAc_5_2 as Table (PorcCompAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcCompAcvsVigenteAc_5_2
		Select sum(isnull(tp.Comprometido,0))as PorcCompAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--------------NomCompAcvsVigenteAc
		declare @TNomCompAcvsVigenteAc_5_1 as Table (NomCompAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomCompAcvsVigenteAc_5_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0)) as NomCompAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		-----------PorcDevAcvsVigenteAc
		declare @TPorcDevAcvsVigenteAc_5_1 as Table (PorcDevAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcDevAcvsVigenteAc_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcDevAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TPorcDevAcvsVigenteAc_5_2 as Table (PorcDevAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcDevAcvsVigenteAc_5_2
		Select sum(isnull(tp.Devengado,0)) as PorcDevAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--------------NomDevAcvsVigenteAc
		declare @TNomDevAcvsVigenteAc_5_1 as Table (NomDevAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomDevAcvsVigenteAc_5_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0))as NomDevAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico 
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		------------PorcEjerAcvsVigenteAc
		declare @TPorcEjerAcvsVigenteAc_5_1 as Table (PorcEjerAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcEjerAcvsVigenteAc_5_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcEjerAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TPorcEjerAcvsVigenteAc_5_2 as Table (PorcEjerAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcEjerAcvsVigenteAc_5_2
		Select sum(isnull(tp.Ejercido,0))as PorcEjerAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
				
		-------------NomEjerAcvsVigenteAc
		declare @TNomEjerAcvsVigenteAc_5_1 as Table (NomEjerAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomEjerAcvsVigenteAc_5_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0)) as NomEjerAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg	ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
				
		------------PorcPagAcvsVigenteAc
		declare @TPorcPagAcvsVigenteAc_5_1 as Table (PorcPagAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcPagAcvsVigenteAc_5_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPagAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TPorcPagAcvsVigenteAc_5_2 as Table (PorcPagAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcPagAcvsVigenteAc_5_2
		Select sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG 
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		------------NomPagAcvsVigenteAc
		declare @TNomPagAcvsVigenteAc_5_1 as Table (NomPagAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomPagAcvsVigenteAc_5_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0))as NomPagAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
	
		----------------PorcCompAcvsVigenteAn
		declare @TPorcCompAcvsVigenteAn_5_1 as Table (PorcCompAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcCompAcvsVigenteAn_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomPagAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
	
		declare @TPorcCompAcvsVigenteAn_5_2 as Table (PorcCompAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcCompAcvsVigenteAn_5_2
		Select  sum(isnull(tp.Comprometido,0))as PorcCompAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG 
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		-------------NomCompAcvsVigenteAn
		declare @TNomCompAcvsVigenteAn_5_1 as Table (NomCompAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomCompAcvsVigenteAn_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomCompAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TNomCompAcvsVigenteAn_5_2 as Table (NomCompAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomCompAcvsVigenteAn_5_2
		Select  (sum(isnull(tp.Comprometido,0))) as NomCompAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		----------------PorcDevAcvsVigenteAn
		declare @TPorcDevAcvsVigenteAn_5_1 as Table (PorcDevAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcDevAcvsVigenteAn_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcDevAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TPorcDevAcvsVigenteAn_5_2 as Table (PorcDevAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcDevAcvsVigenteAn_5_2
		Select  sum(isnull(tp.Devengado,0)) AS  PorcDevAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		-------------NomDevAcvsVigenteAn
		declare @TNomDevAcvsVigenteAn_5_1 as Table (NomDevAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomDevAcvsVigenteAn_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomDevAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TNomDevAcvsVigenteAn_5_2 as Table (NomDevAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomDevAcvsVigenteAn_5_2
		Select  (sum(isnull(tp.Devengado,0))) as NomDevAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		---------------PorcEjerAcvsVigenteAn
		declare @TPorcEjerAcvsVigenteAn_5_1 as Table (PorcEjerAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcEjerAcvsVigenteAn_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcEjerAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  	INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TPorcEjerAcvsVigenteAn_5_2 as Table (PorcEjerAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcEjerAcvsVigenteAn_5_2
		Select sum(isnull(tp.Ejercido,0))  as PorcEjerAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		----------NomEjerAcvsVigenteAn
		declare @TNomEjerAcvsVigenteAn_5_1 as Table (NomEjerAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomEjerAcvsVigenteAn_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomEjerAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TNomEjerAcvsVigenteAn_5_2 as Table (NomEjerAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomEjerAcvsVigenteAn_5_2
		Select  (sum(isnull(tp.Ejercido,0))) as NomEjerAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--------------PorcPagAcvsVigenteAn
		declare @TPorcPagAcvsVigenteAn_5_1 as Table (PorcPagAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcPagAcvsVigenteAn_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPagAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TPorcPagAcvsVigenteAn_5_2 as Table (PorcPagAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TPorcPagAcvsVigenteAn_5_2
		Select  sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		----------NomPagAcvsVigenteAn
		declare @TNomPagAcvsVigenteAn_5_1 as Table (NomPagAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomPagAcvsVigenteAn_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomPagAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TNomPagAcvsVigenteAn_5_2 as Table (NomPagAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID Int)
		Insert into @TNomPagAcvsVigenteAn_5_2
		Select  (sum(isnull(tp.Pagado,0)))as NomPagAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		--left join  @TResultadoFinal_5 T5 on T5.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Select Clave1, Descripcion, TR.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, NombreAI, Clave5, Descripcion4, Clave6, Descripcion5,
		Sum(Autorizado)Autorizado, sum(TransferenciaAmp)TransferenciaAmp, sum(TransferenciaRed)TransferenciaRed, sum(Modificado)Modificado, 
		Sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, sum(Comprometido)Comprometido, Sum(PreCompSinComp)PreCompSinComp, 
		SUM(PresDispComp)PresDispComp, sum(Devengado)Devengado, Sum(CompSinDev)CompSinDev, Sum(PresSinDev)PresSinDev, sum(Ejercido)Ejercido, 
		Sum(DevSinEjer)DevSinEjer, Sum(Pagado)Pagado, Sum(EjerSinPagar)EjerSinPagar, sum(Deuda)Deuda,
		cast(sum(case when isnull(PorcAprobAnual1,0) = 0 then 0 else isnull(PorcAprobAnual2,0) / isnull(PorcAprobAnual1,0) end) as decimal(15,2))PorcAprobAnual,
		cast(sum(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else isnull(PorcAprobadocAnt2,0) / isnull(PorcAprobadocAnt1,0) end) as decimal(15,2))PorcAprobadocAnt,
		sum(isnull(NomAprobado1,0) - isnull(NomAprobado2,0)) NomAprobado,
		cast(Sum(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else isnull(PorcPVigenteAnual2,0) / isnull(PorcPVigenteAnual1,0) end) as decimal(15,2))PorcPVigenteAnual,
		cast(Sum(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else isnull(PorcPVigenteAnt2,0) / isnull(PorcPVigenteAnt1,0) end) as decimal(15,2))PorcPVigenteAnt,
		sum(isnull(NomPVigente1,0) - isnull(NomPVigente2,0)) NomPVigente,
		cast(Sum(case when isnull(PorcCompvsVigente1,0) = 0 then 0 else isnull(PorcCompvsVigente2,0) / isnull(PorcCompvsVigente1,0) end) as decimal(15,2)) PorcCompvsVigente,
		sum(NomCompvsVigente)NomCompvsVigente,
		cast(sum(case when isnull(PorcDevvsVigente1,0) = 0 then 0 else isnull(PorcDevvsVigente2,0) / isnull(PorcDevvsVigente1,0) end) as decimal(15,2))PorcDevvsVigente,
		Sum(NomDevvsVigente)NomDevvsVigente,
		cast(Sum(case when isnull(PorcCompAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAc2,0) / isnull(PorcCompAcvsVigenteAc1,0) end) as decimal(15,2))PorcCompAcvsVigenteAc,
		sum(isnull(NomCompAcvsVigenteAc1,0))NomCompAcvsVigenteAc,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAc2,0) / isnull(PorcDevAcvsVigenteAc1,0) end) as decimal(15,2)) PorcDevAcvsVigenteAc,
		sum(isnull(NomDevAcvsVigenteAc1,0))NomDevAcvsVigenteAc,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAc2,0) / isnull(PorcEjerAcvsVigenteAc1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAc,
		sum(isnull(NomEjerAcvsVigenteAc1,0))NomEjerAcvsVigenteAc,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAc2,0) / isnull(PorcPagAcvsVigenteAc1,0) end) as decimal(15,2))PorcPagAcvsVigenteAc,
		sum(isnull(NomPagAcvsVigenteAc1,0))NomPagAcvsVigenteAc,
		cast(sum(case when isnull(PorcCompAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAn2,0) / isnull(PorcCompAcvsVigenteAn1,0) end) as decimal(15,2))PorcCompAcvsVigenteAn,
		sum(isnull(NomCompAcvsVigenteAn1,0) - isnull(NomCompAcvsVigenteAn2,0))NomCompAcvsVigenteAn,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAn2,0) / isnull(PorcDevAcvsVigenteAn1,0) end) as decimal(15,2))PorcDevAcvsVigenteAn,
		Sum(isnull(NomDevAcvsVigenteAn1,0)- isnull(NomDevAcvsVigenteAn2,0)) NomDevAcvsVigenteAn,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAn2,0) / isnull(PorcEjerAcvsVigenteAn1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAn,
		sum(isnull(NomEjerAcvsVigenteAn1,0) - isnull(NomEjerAcvsVigenteAn2,0))NomEjerAcvsVigenteAn,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAn2,0) / isnull(PorcPagAcvsVigenteAn1,0) end) as decimal(15,2))PorcPagAcvsVigenteAn,
		sum(isnull(NomPagAcvsVigenteAn1,0) - isnull(NomPagAcvsVigenteAn2,0)) NomPagAcvsVigenteAn
		from @TResultadoFinal_5 as TR
		left outer join @TPorcAprobAnual_5_1		as T_1_1  on T_1_1.ID  = TR.ID and t_1_1.clave2  = Tr.Clave2 
		left outer join @TPorcAprobAnual_5_2		as T_1_2  on T_1_2.ID  = TR.ID and t_1_2.clave2  = Tr.Clave2 
		left outer join @TPorcAprobadocAnt_5_1		as T_2_1  on T_2_1.ID  = TR.ID and T_2_1.clave2  = Tr.Clave2
		left outer join @TPorcAprobadocAnt_5_2		as T_2_2  on T_2_2.ID  = TR.ID and T_2_2.clave2  = Tr.Clave2
		left outer join @TNomAprobado_5_1			as T_3_1  on T_3_1.ID  = TR.ID and T_3_1.clave2  = Tr.Clave2
		left outer join @TNomAprobado_5_2			as T_3_2  on T_3_2.ID  = TR.ID and T_3_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_5_1		as T_4_1  on T_4_1.ID  = TR.ID and T_4_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_5_2		as T_4_2  on T_4_2.ID  = TR.ID and T_4_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_5_1		as T_5_1  on T_5_1.ID  = TR.ID and T_5_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_5_2		as T_5_2  on T_5_2.ID  = TR.ID and T_5_2.clave2  = Tr.Clave2
		left outer join @TNomPVigente_5_1			as T_6_1  on T_6_1.ID  = TR.ID and T_6_1.clave2  = Tr.Clave2
		left outer join @TNomPVigente_5_2			as T_6_2  on T_6_2.ID  = TR.ID and T_6_2.clave2  = Tr.Clave2
		left outer join @TPorcCompvsVigente_5_1		as T_7_1  on T_7_1.ID  = TR.ID and T_7_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompvsVigente_5_2		as T_7_2  on T_7_2.ID  = TR.ID and T_7_2.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_5_1		as T_8_1  on T_8_1.ID  = TR.ID and T_8_1.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_5_2		as T_8_2  on T_8_2.ID  = TR.ID and T_8_2.clave2  = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAc_5_1 as T_9_1  on T_9_1.ID  = TR.ID and T_9_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompAcvsVigenteAc_5_2 as T_9_2  on T_9_2.ID  = TR.ID and T_9_2.clave2  = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAc_5_1	as T_10_1 on T_10_1.ID = TR.ID and T_10_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_5_1	as T_11_1 on T_11_1.ID = TR.ID and T_11_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_5_2	as T_11_2 on T_11_2.ID = TR.ID and T_11_2.clave2 = Tr.Clave2
		left outer join @TNomDevAcvsVigenteAc_5_1	as T_12_1 on T_12_1.ID = TR.ID and T_12_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_5_1 as T_13_1 on T_13_1.ID = TR.ID and T_13_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_5_2 as T_13_2 on T_13_2.ID = TR.ID and T_13_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAc_5_1	as T_14_1 on T_14_1.ID = TR.ID and T_14_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_5_1	as T_15_1 on T_15_1.ID = TR.ID and T_15_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_5_2	as T_15_2 on T_15_2.ID = TR.ID and T_15_2.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAc_5_1	as T_16_1 on T_16_1.ID = TR.ID and T_16_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_5_1 as T_17_1 on T_17_1.ID = TR.ID and T_17_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_5_2 as T_17_2 on T_17_2.ID = TR.ID and T_17_2.clave2 = Tr.Clave2
		left outer join @TNomCompAcvsVigenteAn_5_1	as T_18_1 on T_18_1.ID = TR.ID and T_18_1.clave2 = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAn_5_2	as T_18_2 on T_18_2.ID = TR.ID and T_18_2.clave2 = Tr.Clave2 
		left outer join @TPorcDevAcvsVigenteAn_5_1	as T_19_1 on T_19_1.ID = TR.ID and T_19_1.clave2 = Tr.Clave2  
		left outer join @TPorcDevAcvsVigenteAn_5_2	as T_19_2 on T_19_2.ID = TR.ID and T_19_2.clave2 = Tr.Clave2   
		left outer join @TNomDevAcvsVigenteAn_5_1	as T_20_1 on T_20_1.ID = TR.ID and T_20_1.clave2 = Tr.Clave2  
		left outer join @TNomDevAcvsVigenteAn_5_2	as T_20_2 on T_20_2.ID = TR.ID and T_20_2.clave2 = Tr.Clave2  
		left outer join @TPorcEjerAcvsVigenteAn_5_1 as T_21_1 on T_21_1.ID = TR.ID and T_21_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAn_5_2 as T_21_2 on T_21_2.ID = TR.ID and T_21_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAn_5_1	as T_22_1 on T_22_1.ID = TR.ID and T_22_1.clave2 = Tr.Clave2 
		left outer join @TNomEjerAcvsVigenteAn_5_2	as T_22_2 on T_22_2.ID = TR.ID and T_22_2.clave2 = Tr.Clave2  
		left outer join @TPorcPagAcvsVigenteAn_5_1	as T_23_1 on T_23_1.ID = TR.ID and T_23_1.clave2 = Tr.Clave2 
		left outer join @TPorcPagAcvsVigenteAn_5_2	as T_23_2 on T_23_2.ID = TR.ID and T_23_2.clave2 = Tr.Clave2 
		left outer join @TNomPagAcvsVigenteAn_5_1	as T_24_1 on T_24_1.ID = TR.ID and T_24_1.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAn_5_2	as T_24_2 on T_24_2.ID = TR.ID and T_24_2.clave2 = Tr.Clave2
		group by Clave1, Descripcion, TR.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, NombreAI, Clave5, Descripcion4, Clave6, Descripcion5
		order by Tr.Clave2, Clave5

	END

	If @Tipo = 6 
	BEGIN
		--Ramo o Dependencia / Función / Programas y Proyectos de Inversión
		--Valores Absolutos

		DECLARE @TResultadoFinal_6 as table (Clave1 varchar(8), Descripcion varchar(150) ,Clave2 varchar(8) ,Descripcion2 varchar(150) ,Clave3 varchar(8) ,
		Id varchar(8),Descripcion3 varchar(150), Clave4 varchar(Max), Descripcion4 varchar(150) , Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2),Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2),PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2),Deuda decimal(15,2),PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2),NomAprobado decimal(15,2),PorcPVigenteAnual decimal(15,2),PorcPVigenteAnt decimal(15,2),	NomPVigente decimal(15,2),
		PorcCompvsVigente decimal(15,2),NomCompvsVigente decimal(15,2),PorcDevvsVigente decimal(15,2),NomDevvsVigente decimal(15,2),
		PorcCompAcvsVigenteAc decimal(15,2),NomCompAcvsVigenteAc decimal(15,2),PorcDevAcvsVigenteAc decimal(15,2),NomDevAcvsVigenteAc decimal(15,2),
		PorcEjerAcvsVigenteAc decimal(15,2),NomEjerAcvsVigenteAc decimal(15,2),PorcPagAcvsVigenteAc decimal(15,2),NomPagAcvsVigenteAc decimal(15,2),
		PorcCompAcvsVigenteAn decimal(15,2),NomCompAcvsVigenteAn decimal(15,2),PorcDevAcvsVigenteAn decimal(15,2),NomDevAcvsVigenteAn decimal(15,2),
		PorcEjerAcvsVigenteAn decimal(15,2),NomEjerAcvsVigenteAn decimal(15,2),	PorcPagAcvsVigenteAn decimal(15,2),NomPagAcvsVigenteAn decimal(15,2))

		INSERT INTO @TResultadoFinal_6 (Clave1 ,Descripcion ,Clave2 ,Descripcion2 ,Clave3 ,Id,Descripcion3 , Clave4,Descripcion4,Autorizado , 
		TransferenciaAmp , TransferenciaRed , Modificado , PreComprometido , PresVigSinPreComp ,Comprometido , PreCompSinComp , PresDispComp , Devengado , 
		CompSinDev ,PresSinDev ,Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda,PorcAprobAnual,PorcAprobadocAnt,NomAprobado,PorcPVigenteAnual, 
		PorcPVigenteAnt ,NomPVigente,PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,
		PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,
		NomCompAcvsVigenteAn,PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn )

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
		where   (Mes BETWEEN @Mes and @Mes2) AND Year=@Ejercicio  
		and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.Clave else @Clave end 
		and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.Clave else @Clave2 end) 
		AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		group by C_funciones.Clave, C_funciones.Nombre,  C_funciones.IdFuncion ,C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE ,C_RamoPresupuestal.DESCRIPCION,
		C_EP_Ramo.Clave,C_EP_Ramo.Id,T_SellosPresupuestales.IdProyecto ,C_ProyectosInversion.CLAVE,C_ProyectosInversion.NOMBRE 
		Order By C_RamoPresupuestal.CLAVE,C_funciones.Clave
		
		--Columna 1 PorcAprobAnual
		Declare @TPorcAprobAnual_6_1 as Table (PorcAprobAnual1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcAprobAnual_6_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, cf.Clave, cepr.id	 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 

		Declare @TPorcAprobAnual_6_2 as Table (PorcAprobAnual2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcAprobAnual_6_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, cr.CLAVE, cf.Clave, cepr.id	 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 
 
		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_6_1 as Table (PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcAprobadocAnt_6_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, cf.Clave, cepr.id	
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 
 
		Declare @TPorcAprobadocAnt_6_2 as Table (PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcAprobadocAnt_6_2
		Select  sum(isnull(tp.Autorizado,0))as PorcAprobadocAnt2, cr.CLAVE, cf.Clave, cepr.id	
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 
 
		--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_6_1 as Table (NomAprobado1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomAprobado_6_1
		Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, cf.Clave, cepr.id	
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 
 
		Declare @TNomAprobado_6_2 as Table (NomAprobado2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomAprobado_6_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, cf.Clave, cepr.id	
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 
				
		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_6_1 as Table (PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcPVigenteAnual_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, cf.Clave, cepr.id	
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_EP_Ramo  CEPR ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi
		ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes = 0) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 
				
		Declare @TPorcPVigenteAnual_6_2 as Table (PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcPVigenteAnual_6_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion 
		left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 
				
		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_6_1 as Table (PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcPVigenteAnt_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 
				
		Declare @TPorcPVigenteAnt_6_2 as Table (PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcPVigenteAnt_6_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 
		
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_6_1 as Table (NomPVigente1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomPVigente_6_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 
		
		Declare @TNomPVigente_6_2 as Table (NomPVigente2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomPVigente_6_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones CF	ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 
		
		---------------PorcCompvsVigente
		Declare @TPorcCompvsVigente_6_1 as Table (PorcCompvsVigente1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcCompvsVigente_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcCompvsVigente1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id 
		
		Declare @TPorcCompvsVigente_6_2 as Table (PorcCompvsVigente2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcCompvsVigente_6_2
		Select sum(isnull(TP.Comprometido,0)) as PorcCompvsVigente2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		----------PorcDevvsVigente
		Declare @TPorcDevvsVigente_6_1 as Table (PorcDevvsVigente1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcDevvsVigente_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcDevvsVigente1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		Declare @TPorcDevvsVigente_6_2 as Table (PorcDevvsVigente2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcDevvsVigente_6_2
		Select sum(isnull(TP.Devengado,0)) as PorcDevvsVigente2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		--------------PorcCompAcvsVigenteAc
		Declare @TPorcCompAcvsVigenteAc_6_1 as Table (PorcCompAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcCompAcvsVigenteAc_6_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAc1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		Declare @TPorcCompAcvsVigenteAc_6_2 as Table (PorcCompAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcCompAcvsVigenteAc_6_2
		Select sum(isnull(tp.Comprometido,0)) as PorcCompAcvsVigenteAc2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id
		
		--------------NomCompAcvsVigenteAc
		Declare @TNomCompAcvsVigenteAc_6_1 as Table (NomCompAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomCompAcvsVigenteAc_6_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0)) as NomCompAcvsVigenteAc1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id
		
		--------------PorcDevAcvsVigenteAc
		Declare @TPorcDevAcvsVigenteAc_6_1 as Table (PorcDevAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcDevAcvsVigenteAc_6_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevAcvsVigenteAc1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id
		
		Declare @TPorcDevAcvsVigenteAc_6_2 as Table (PorcDevAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcDevAcvsVigenteAc_6_2
		Select sum(isnull(tp.Devengado,0)) as PorcDevAcvsVigenteAc2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		-------------NomDevAcvsVigenteAc
		Declare @TNomDevAcvsVigenteAc_6_1 as Table (NomDevAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomDevAcvsVigenteAc_6_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0)) as NomDevAcvsVigenteAc1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		--------------PorcEjerAcvsVigenteAc
		Declare @TPorcEjerAcvsVigenteAc_6_1 as Table (PorcEjerAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcEjerAcvsVigenteAc_6_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomDevAcvsVigenteAc1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		Declare @TPorcEjerAcvsVigenteAc_6_2 as Table (PorcEjerAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcEjerAcvsVigenteAc_6_2
		Select sum(isnull(tp.Ejercido,0)) as PorcEjerAcvsVigenteAc2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		--------------NomEjerAcvsVigenteAc
		Declare @TNomEjerAcvsVigenteAc_6_1 as Table (NomEjerAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomEjerAcvsVigenteAc_6_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0))as NomEjerAcvsVigenteAc1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		------------PorcPagAcvsVigenteAc
		Declare @TPorcPagAcvsVigenteAc_6_1 as Table (PorcPagAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcPagAcvsVigenteAc_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcPagAcvsVigenteAc1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		Declare @TPorcPagAcvsVigenteAc_6_2 as Table (PorcPagAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcPagAcvsVigenteAc_6_2
		Select sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAc2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		-----------NomPagAcvsVigenteAc
		Declare @TNomPagAcvsVigenteAc_6_1 as Table (NomPagAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomPagAcvsVigenteAc_6_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0))as NomPagAcvsVigenteAc1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		---------------PorcCompAcvsVigenteAn
		Declare @TPorcCompAcvsVigenteAn_6_1 as Table (PorcCompAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcCompAcvsVigenteAn_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAn1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		Declare @TPorcCompAcvsVigenteAn_6_2 as Table (PorcCompAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcCompAcvsVigenteAn_6_2
		Select  sum(isnull(tp.Comprometido,0)) as PorcCompAcvsVigenteAn2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		------------NomCompAcvsVigenteAn
		Declare @TNomCompAcvsVigenteAn_6_1 as Table (NomCompAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomCompAcvsVigenteAn_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomCompAcvsVigenteAn1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		Declare @TNomCompAcvsVigenteAn_6_2 as Table (NomCompAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomCompAcvsVigenteAn_6_2
		Select  (sum(isnull(tp.Comprometido,0))) as NomCompAcvsVigenteAn2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id
		
		-----------------PorcDevAcvsVigenteAn
		Declare @TPorcDevAcvsVigenteAn_6_1 as Table (PorcDevAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcDevAcvsVigenteAn_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevAcvsVigenteAn1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id
		
		Declare @TPorcDevAcvsVigenteAn_6_2 as Table (PorcDevAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcDevAcvsVigenteAn_6_2
		Select  sum(isnull(tp.Devengado,0)) as PorcDevAcvsVigenteAn2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id
		
		------------NomDevAcvsVigenteAn
		Declare @TNomDevAcvsVigenteAn_6_1 as Table (NomDevAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomDevAcvsVigenteAn_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomDevAcvsVigenteAn1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id
		
		Declare @TNomDevAcvsVigenteAn_6_2 as Table (NomDevAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomDevAcvsVigenteAn_6_2
		Select  (sum(isnull(tp.Devengado,0)))as NomDevAcvsVigenteAn2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		------------PorcEjerAcvsVigenteAn
		Declare @TPorcEjerAcvsVigenteAn_6_1 as Table (PorcEjerAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcEjerAcvsVigenteAn_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcEjerAcvsVigenteAn1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		Declare @TPorcEjerAcvsVigenteAn_6_2 as Table (PorcEjerAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcEjerAcvsVigenteAn_6_2
		Select  sum(isnull(tp.Ejercido,0)) as PorcEjerAcvsVigenteAn2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		------------NomEjerAcvsVigenteAn
		Declare @TNomEjerAcvsVigenteAn_6_1 as Table (NomEjerAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomEjerAcvsVigenteAn_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomEjerAcvsVigenteAn1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		Declare @TNomEjerAcvsVigenteAn_6_2 as Table (NomEjerAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomEjerAcvsVigenteAn_6_2
		Select  (sum(isnull(tp.Ejercido,0))) as NomEjerAcvsVigenteAn2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id
					  
		--------------TPorcPagAcvsVigenteAn
		Declare @TPorcPagAcvsVigenteAn_6_1 as Table (PorcPagAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcPagAcvsVigenteAn_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcPagAcvsVigenteAn1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id

		Declare @TPorcPagAcvsVigenteAn_6_2 as Table (PorcPagAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TPorcPagAcvsVigenteAn_6_2
		Select  sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAn2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id
				
		-----------NomPagAcvsVigenteAn
		Declare @TNomPagAcvsVigenteAn_6_1 as Table (NomPagAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomPagAcvsVigenteAn_6_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomPagAcvsVigenteAn1, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion  left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id
				
		Declare @TNomPagAcvsVigenteAn_6_2 as Table (NomPagAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 Varchar(8), ID Int)
		Insert into @TNomPagAcvsVigenteAn_6_2
		Select  (sum(isnull(tp.Pagado,0))) as NomPagAcvsVigenteAn2, cr.CLAVE, cf.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo  CEPR
		ON CEPR.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_SubFunciones  ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones  CF ON CF.IdFuncion = C_SubFunciones.IdFuncion  
		left JOIN @TResultadoFinal_6 as T6 ON T6.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = cf.Clave and Clave3 = CEPR.Clave and Clave4 = cpi.CLAVE 
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) 
		AND cepr.Id = case when @IdEP = '' then cepr.Id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.id
		
		Select Clave1, Descripcion, tr.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Descripcion4,
		Sum(Autorizado)Autorizado, sum(TransferenciaAmp)TransferenciaAmp, sum(TransferenciaRed)TransferenciaRed, sum(Modificado)Modificado,
		Sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, sum(Comprometido)Comprometido, Sum(PreCompSinComp)PreCompSinComp,
		SUM(PresDispComp)PresDispComp, sum(Devengado)Devengado, Sum(CompSinDev)CompSinDev, Sum(PresSinDev)PresSinDev, sum(Ejercido)Ejercido, 
		Sum(DevSinEjer)DevSinEjer, Sum(Pagado)Pagado, Sum(EjerSinPagar)EjerSinPagar, sum(Deuda)Deuda,
		cast(sum(case when isnull(PorcAprobAnual1,0) = 0 then 0 else isnull(PorcAprobAnual2,0) / isnull(PorcAprobAnual1,0) end) as decimal(15,2))PorcAprobAnual,
		cast(sum(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else isnull(PorcAprobadocAnt2,0) / isnull(PorcAprobadocAnt1,0) end) as decimal(15,2))PorcAprobadocAnt,
		sum(isnull(NomAprobado1,0) - isnull(NomAprobado2,0)) NomAprobado,
		cast(Sum(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else isnull(PorcPVigenteAnual2,0) / isnull(PorcPVigenteAnual1,0) end) as decimal(15,2))PorcPVigenteAnual,
		cast(Sum(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else isnull(PorcPVigenteAnt2,0) / isnull(PorcPVigenteAnt1,0) end) as decimal(15,2))PorcPVigenteAnt,
		sum(isnull(NomPVigente1,0) - isnull(NomPVigente2,0)) NomPVigente,
		cast(Sum(case when isnull(PorcCompvsVigente1,0) = 0 then 0 else isnull(PorcCompvsVigente2,0) / isnull(PorcCompvsVigente1,0) end) as decimal(15,2)) PorcCompvsVigente,
		sum(NomCompvsVigente)NomCompvsVigente,
		cast(sum(case when isnull(PorcDevvsVigente1,0) = 0 then 0 else isnull(PorcDevvsVigente2,0) / isnull(PorcDevvsVigente1,0) end) as decimal(15,2))PorcDevvsVigente,
		Sum(NomDevvsVigente)NomDevvsVigente,
		cast(Sum(case when isnull(PorcCompAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAc2,0) / isnull(PorcCompAcvsVigenteAc1,0) end) as decimal(15,2))PorcCompAcvsVigenteAc,
		sum(isnull(NomCompAcvsVigenteAc1,0))NomCompAcvsVigenteAc,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAc2,0) / isnull(PorcDevAcvsVigenteAc1,0) end) as decimal(15,2)) PorcDevAcvsVigenteAc,
		sum(isnull(NomDevAcvsVigenteAc1,0))NomDevAcvsVigenteAc,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAc2,0) / isnull(PorcEjerAcvsVigenteAc1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAc,
		sum(isnull(NomEjerAcvsVigenteAc1,0))NomEjerAcvsVigenteAc,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAc2,0) / isnull(PorcPagAcvsVigenteAc1,0) end) as decimal(15,2))PorcPagAcvsVigenteAc,
		sum(isnull(NomPagAcvsVigenteAc1,0))NomPagAcvsVigenteAc,
		cast(sum(case when isnull(PorcCompAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAn2,0) / isnull(PorcCompAcvsVigenteAn1,0) end) as decimal(15,2))PorcCompAcvsVigenteAn,
		sum(isnull(NomCompAcvsVigenteAn1,0) - isnull(NomCompAcvsVigenteAn2,0))NomCompAcvsVigenteAn,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAn2,0) / isnull(PorcDevAcvsVigenteAn1,0) end) as decimal(15,2))PorcDevAcvsVigenteAn,
		Sum(isnull(NomDevAcvsVigenteAn1,0)- isnull(NomDevAcvsVigenteAn2,0)) NomDevAcvsVigenteAn,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAn2,0) / isnull(PorcEjerAcvsVigenteAn1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAn,
		sum(isnull(NomEjerAcvsVigenteAn1,0) - isnull(NomEjerAcvsVigenteAn2,0))NomEjerAcvsVigenteAn,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAn2,0) / isnull(PorcPagAcvsVigenteAn1,0) end) as decimal(15,2))PorcPagAcvsVigenteAn,
		sum(isnull(NomPagAcvsVigenteAn1,0) - isnull(NomPagAcvsVigenteAn2,0)) NomPagAcvsVigenteAn
		from @TResultadoFinal_6 as TR
		left outer join @TPorcAprobAnual_6_1		as T_1_1  on T_1_1.ID  = TR.ID and t_1_1.clave2  = Tr.Clave2 
		left outer join @TPorcAprobAnual_6_2		as T_1_2  on T_1_2.ID  = TR.ID and t_1_2.clave2  = Tr.Clave2 
		left outer join @TPorcAprobadocAnt_6_1		as T_2_1  on T_2_1.ID  = TR.ID and T_2_1.clave2  = Tr.Clave2
		left outer join @TPorcAprobadocAnt_6_2		as T_2_2  on T_2_2.ID  = TR.ID and T_2_2.clave2  = Tr.Clave2
		left outer join @TNomAprobado_6_1			as T_3_1  on T_3_1.ID  = TR.ID and T_3_1.clave2  = Tr.Clave2
		left outer join @TNomAprobado_6_2			as T_3_2  on T_3_2.ID  = TR.ID and T_3_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_6_1		as T_4_1  on T_4_1.ID  = TR.ID and T_4_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_6_2		as T_4_2  on T_4_2.ID  = TR.ID and T_4_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_6_1		as T_5_1  on T_5_1.ID  = TR.ID and T_5_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_6_2		as T_5_2  on T_5_2.ID  = TR.ID and T_5_2.clave2  = Tr.Clave2
		left outer join @TNomPVigente_6_1			as T_6_1  on T_6_1.ID  = TR.ID and T_6_1.clave2  = Tr.Clave2
		left outer join @TNomPVigente_6_2			as T_6_2  on T_6_2.ID  = TR.ID and T_6_2.clave2  = Tr.Clave2
		left outer join @TPorcCompvsVigente_6_1		as T_7_1  on T_7_1.ID  = TR.ID and T_7_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompvsVigente_6_2		as T_7_2  on T_7_2.ID  = TR.ID and T_7_2.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_6_1		as T_8_1  on T_8_1.ID  = TR.ID and T_8_1.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_6_2		as T_8_2  on T_8_2.ID  = TR.ID and T_8_2.clave2  = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAc_6_1 as T_9_1  on T_9_1.ID  = TR.ID and T_9_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompAcvsVigenteAc_6_2 as T_9_2  on T_9_2.ID  = TR.ID and T_9_2.clave2  = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAc_6_1	as T_10_1 on T_10_1.ID = TR.ID and T_10_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_6_1	as T_11_1 on T_11_1.ID = TR.ID and T_11_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_6_2	as T_11_2 on T_11_2.ID = TR.ID and T_11_2.clave2 = Tr.Clave2
		left outer join @TNomDevAcvsVigenteAc_6_1	as T_12_1 on T_12_1.ID = TR.ID and T_12_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_6_1 as T_13_1 on T_13_1.ID = TR.ID and T_13_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_6_2 as T_13_2 on T_13_2.ID = TR.ID and T_13_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAc_6_1	as T_14_1 on T_14_1.ID = TR.ID and T_14_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_6_1	as T_15_1 on T_15_1.ID = TR.ID and T_15_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_6_2	as T_15_2 on T_15_2.ID = TR.ID and T_15_2.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAc_6_1	as T_16_1 on T_16_1.ID = TR.ID and T_16_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_6_1 as T_17_1 on T_17_1.ID = TR.ID and T_17_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_6_2 as T_17_2 on T_17_2.ID = TR.ID and T_17_2.clave2 = Tr.Clave2
		left outer join @TNomCompAcvsVigenteAn_6_1	as T_18_1 on T_18_1.ID = TR.ID and T_18_1.clave2 = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAn_6_2	as T_18_2 on T_18_2.ID = TR.ID and T_18_2.clave2 = Tr.Clave2 
		left outer join @TPorcDevAcvsVigenteAn_6_1	as T_19_1 on T_19_1.ID = TR.ID and T_19_1.clave2 = Tr.Clave2  
		left outer join @TPorcDevAcvsVigenteAn_6_2	as T_19_2 on T_19_2.ID = TR.ID and T_19_2.clave2 = Tr.Clave2   
		left outer join @TNomDevAcvsVigenteAn_6_1	as T_20_1 on T_20_1.ID = TR.ID and T_20_1.clave2 = Tr.Clave2  
		left outer join @TNomDevAcvsVigenteAn_6_2	as T_20_2 on T_20_2.ID = TR.ID and T_20_2.clave2 = Tr.Clave2  
		left outer join @TPorcEjerAcvsVigenteAn_6_1 as T_21_1 on T_21_1.ID = TR.ID and T_21_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAn_6_2 as T_21_2 on T_21_2.ID = TR.ID and T_21_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAn_6_1	as T_22_1 on T_22_1.ID = TR.ID and T_22_1.clave2 = Tr.Clave2 
		left outer join @TNomEjerAcvsVigenteAn_6_2	as T_22_2 on T_22_2.ID = TR.ID and T_22_2.clave2 = Tr.Clave2  
		left outer join @TPorcPagAcvsVigenteAn_6_1	as T_23_1 on T_23_1.ID = TR.ID and T_23_1.clave2 = Tr.Clave2 
		left outer join @TPorcPagAcvsVigenteAn_6_2	as T_23_2 on T_23_2.ID = TR.ID and T_23_2.clave2 = Tr.Clave2 
		left outer join @TNomPagAcvsVigenteAn_6_1	as T_24_1 on T_24_1.ID = TR.ID and T_24_1.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAn_6_2	as T_24_2 on T_24_2.ID = TR.ID and T_24_2.clave2 = Tr.Clave2
		group by Clave1, Descripcion, TR.Clave2, Descripcion2, Clave3, Descripcion3, Clave4,  Descripcion4
		order by Tr.Clave2
	END

	If @Tipo = 7 
	BEGIN
		--Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasificación Económica
		--Valores Absolutos

		DECLARE @TResultadoFinal_7 as table (Clave1 varchar(8),Descripcion varchar(150) ,Clave2 varchar(8) ,Descripcion2 varchar(150) ,Clave3 varchar(8) ,
		Descripcion3 varchar(150), Id varchar(8),  Clave4 varchar(MAx), Descripcion4 varchar(150) ,Clave4a varchar(8), Descripcion4a varchar(150) ,
		Clave5 varchar(8),Descripcion5 varchar(150) ,Clave6 varchar(8),Descripcion6 varchar(150) ,Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2),Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2),PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2),Deuda decimal(15,2),PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2),NomAprobado decimal(15,2),PorcPVigenteAnual decimal(15,2),PorcPVigenteAnt decimal(15,2),	NomPVigente decimal(15,2),
		PorcCompvsVigente decimal(15,2),NomCompvsVigente decimal(15,2),PorcDevvsVigente decimal(15,2),NomDevvsVigente decimal(15,2),PorcCompAcvsVigenteAc decimal(15,2),
		NomCompAcvsVigenteAc decimal(15,2), PorcDevAcvsVigenteAc decimal(15,2),NomDevAcvsVigenteAc decimal(15,2),PorcEjerAcvsVigenteAc decimal(15,2),
		NomEjerAcvsVigenteAc decimal(15,2),PorcPagAcvsVigenteAc decimal(15,2),NomPagAcvsVigenteAc decimal(15,2),PorcCompAcvsVigenteAn decimal(15,2),
		NomCompAcvsVigenteAn decimal(15,2),	PorcDevAcvsVigenteAn decimal(15,2),	NomDevAcvsVigenteAn decimal(15,2),PorcEjerAcvsVigenteAn decimal(15,2),
		NomEjerAcvsVigenteAn decimal(15,2),	PorcPagAcvsVigenteAn decimal(15,2),	NomPagAcvsVigenteAn decimal(15,2))	
		
		INSERT INTO @TResultadoFinal_7 (Clave1,Descripcion ,Clave2 ,Descripcion2  ,Clave3  ,Descripcion3 , Id ,  Clave4 , Descripcion4  ,Clave4a , 
		Descripcion4a  ,Clave5 ,Descripcion5  ,Clave6 ,	Descripcion6 ,Autorizado , TransferenciaAmp , TransferenciaRed , Modificado , PreComprometido , 
		PresVigSinPreComp ,Comprometido , PreCompSinComp , PresDispComp , Devengado , CompSinDev ,PresSinDev ,Ejercido , DevSinEjer , Pagado , EjerSinPagar ,
		Deuda, PorcAprobAnual,PorcAprobadocAnt,NomAprobado,PorcPVigenteAnual, PorcPVigenteAnt , NomPVigente,PorcCompvsVigente,NomCompvsVigente,
		PorcDevvsVigente,NomDevvsVigente, PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,
		NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,
		PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn )

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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo 
		ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 	INNER JOIN C_AreaResponsabilidad 
		ON (C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (C_AreaResponsabilidad.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo   				
		WHERE  (Mes BETWEEN @Mes and @Mes2) AND Year=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else
		@Clave end  and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE Else @Clave2 end ) 
		AND C_AreaResponsabilidad.Clave = case when @ClaveUR = '' then C_AreaResponsabilidad.Clave else @ClaveUR   end 
		AND C_EP_Ramo.Id = case when @IdEP = '' Then C_EP_Ramo.Id else @IdEP end
		Group by  C_CapitulosNEP.IdCapitulo, C_CapitulosNEP.Descripcion, C_ConceptosNEP.IdConcepto, C_ConceptosNEP.Descripcion, C_ConceptosNEP.IdCapitulo,
		C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre,C_EP_Ramo.Clave,C_EP_Ramo.Id, C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE,
		C_RamoPresupuestal.DESCRIPCION,C_TipoGasto.Clave, C_TipoGasto.nombre, C_ProyectosInversion.CLAVE, C_ProyectosInversion.NOMBRE   
		Order by  C_AreaResponsabilidad.Clave  ,C_CapitulosNEP.IdCapitulo 

		--Columna 1 PorcAprobAnual
		Declare @TPorcAprobAnual_7_1 as Table (PorcAprobAnual1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcAprobAnual_7_1 
		Select  sum(isnull(TP.Autorizado,0))as PorcAprobAnual1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcAprobAnual_7_2 as Table (PorcAprobAnual2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcAprobAnual_7_2 
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_7_1 as Table (PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcAprobadocAnt_7_1 
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcAprobadocAnt_7_2 as Table (PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcAprobadocAnt_7_2 
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_7_1 as Table (NomAprobado1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomAprobado_7_1 
		Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA	ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg	ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TNomAprobado_7_2 as Table (NomAprobado2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomAprobado_7_2 
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_7_1 as Table (PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcPVigenteAnual_7_1 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes = 0) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcPVigenteAnual_7_2 as Table (PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcPVigenteAnual_7_2 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA	ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_7_1 as Table (PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcPVigenteAnt_7_1 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcPVigenteAnt_7_2 as Table (PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcPVigenteAnt_7_2 
		Select   (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_7_1 as Table (NomPVigente1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomPVigente_7_1
		Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA	ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TNomPVigente_7_2 as Table (NomPVigente2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomPVigente_7_2 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
		INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		------------PorcCompvsVigente
		Declare @TPorcCompvsVigente_7_1 as Table (PorcCompvsVigente1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcCompvsVigente_7_1 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompvsVigente1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg	ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcCompvsVigente_7_2 as Table (PorcCompvsVigente2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcCompvsVigente_7_2 
		Select sum(isnull(TP.Comprometido,0)) as PorcCompvsVigente2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		------------PorcDevvsVigente
		Declare @TPorcDevvsVigente_7_1 as Table (PorcDevvsVigente1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcDevvsVigente_7_1 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevvsVigente1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
		INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcDevvsVigente_7_2 as Table (PorcDevvsVigente2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcDevvsVigente_7_2 
		Select sum(isnull(TP.Devengado,0))  as PorcDevvsVigente2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--------------PorcCompAcvsVigenteAc
		Declare @TPorcCompAcvsVigenteAc_7_1 as Table (PorcCompAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcCompAcvsVigenteAc_7_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcCompAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcCompAcvsVigenteAc_7_2 as Table (PorcCompAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcCompAcvsVigenteAc_7_2 
		Select sum(isnull(tp.Comprometido,0)) as PorcCompAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA	ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		---------------NomCompAcvsVigenteAc
		Declare @TNomCompAcvsVigenteAc_7_1 as Table (NomCompAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomCompAcvsVigenteAc_7_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0))as NomCompAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		------------PorcDevAcvsVigenteAc
		Declare @TPorcDevAcvsVigenteAc_7_1 as Table (PorcDevAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcDevAcvsVigenteAc_7_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcDevAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
		INNER JOIN C_CapitulosNEP  ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcDevAcvsVigenteAc_7_2 as Table (PorcDevAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcDevAcvsVigenteAc_7_2
		Select sum(isnull(tp.Devengado,0))as PorcDevAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA	ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		----------NomDevAcvsVigenteAc
		Declare @TNomDevAcvsVigenteAc_7_1 as Table (NomDevAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomDevAcvsVigenteAc_7_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0))as NomDevAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
		INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		----------------PorcEjerAcvsVigenteAc
		Declare @TPorcEjerAcvsVigenteAc_7_1 as Table (PorcEjerAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcEjerAcvsVigenteAc_7_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcEjerAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
		INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcEjerAcvsVigenteAc_7_2 as Table (PorcEjerAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcEjerAcvsVigenteAc_7_2
		Select sum(isnull(tp.Ejercido,0)) as PorcEjerAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		------   NomEjerAcvsVigenteAc
		Declare @TNomEjerAcvsVigenteAc_7_1 as Table (NomEjerAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomEjerAcvsVigenteAc_7_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0)) as NomEjerAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion  ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		-----------PorcPagAcvsVigenteAc
		Declare @TPorcPagAcvsVigenteAc_7_1 as Table (PorcPagAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcPagAcvsVigenteAc_7_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPagAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcPagAcvsVigenteAc_7_2 as Table (PorcPagAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcPagAcvsVigenteAc_7_2
		Select sum(isnull(tp.Pagado,0))  as PorcPagAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg	ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		---------------NomPagAcvsVigenteAc
		Declare @TNomPagAcvsVigenteAc_7_1 as Table (NomPagAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomPagAcvsVigenteAc_7_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0)) as NomPagAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA	ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg	ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		------------------PorcCompAcvsVigenteAn
		Declare @TPorcCompAcvsVigenteAn_7_1 as Table (PorcCompAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcCompAcvsVigenteAn_7_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA	ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcCompAcvsVigenteAn_7_2 as Table (PorcCompAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcCompAcvsVigenteAn_7_2
		Select   sum(isnull(tp.Comprometido,0)) as PorcCompAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		---------------NomCompAcvsVigenteAn
		Declare @TNomCompAcvsVigenteAn_7_1 as Table (NomCompAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomCompAcvsVigenteAn_7_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcCompAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TNomCompAcvsVigenteAn_7_2 as Table (NomCompAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomCompAcvsVigenteAn_7_2
		Select  (sum(isnull(tp.Comprometido,0)))as PorcCompAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg	ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

	 	----------------PorcDevAcvsVigenteAn
		Declare @TPorcDevAcvsVigenteAn_7_1 as Table (PorcDevAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcDevAcvsVigenteAn_7_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

	 	Declare @TPorcDevAcvsVigenteAn_7_2 as Table (PorcDevAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcDevAcvsVigenteAn_7_2
		Select  sum(isnull(tp.Devengado,0)) as PorcDevAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		-------------NomDevAcvsVigenteAn
		Declare @TNomDevAcvsVigenteAn_7_1 as Table (NomDevAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomDevAcvsVigenteAn_7_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomDevAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA	ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TNomDevAcvsVigenteAn_7_2 as Table (NomDevAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomDevAcvsVigenteAn_7_2
		Select  (sum(isnull(tp.Devengado,0)))as NomDevAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		------------PorcEjerAcvsVigenteAn
		Declare @TPorcEjerAcvsVigenteAn_7_1 as Table (PorcEjerAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcEjerAcvsVigenteAn_7_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcEjerAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcEjerAcvsVigenteAn_7_2 as Table (PorcEjerAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcEjerAcvsVigenteAn_7_2
		Select  sum(isnull(tp.Ejercido,0)) as PorcEjerAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		----------------NomEjerAcvsVigenteAn
		Declare @TNomEjerAcvsVigenteAn_7_1 as Table (NomEjerAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomEjerAcvsVigenteAn_7_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomEjerAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TNomEjerAcvsVigenteAn_7_2 as Table (NomEjerAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomEjerAcvsVigenteAn_7_2
		Select  (sum(isnull(tp.Ejercido,0)))as NomEjerAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		-----------PorcPagAcvsVigenteAn
		Declare @TPorcPagAcvsVigenteAn_7_1 as Table (PorcPagAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcPagAcvsVigenteAn_7_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcPagAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcPagAcvsVigenteAn_7_2 as Table (PorcPagAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TPorcPagAcvsVigenteAn_7_2
		Select  sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--------------NomPagAcvsVigenteAn
		Declare @TNomPagAcvsVigenteAn_7_1 as Table (NomPagAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomPagAcvsVigenteAn_7_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomPagAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TNomPagAcvsVigenteAn_7_2 as Table (NomPagAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), ID int)
		insert into @TNomPagAcvsVigenteAn_7_2
		Select  (sum(isnull(tp.Pagado,0))) as NomPagAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then CA.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Select Clave1, Descripcion, Tr.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Descripcion4, Clave4a, Descripcion4a, Clave5, Descripcion5, 
		Clave6,	Descripcion6, Sum(Autorizado)Autorizado, sum(TransferenciaAmp)TransferenciaAmp, sum(TransferenciaRed)TransferenciaRed, 
		sum(Modificado)Modificado, Sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, sum(Comprometido)Comprometido, 
		Sum(PreCompSinComp)PreCompSinComp, SUM(PresDispComp)PresDispComp, sum(Devengado)Devengado, Sum(CompSinDev)CompSinDev, Sum(PresSinDev)PresSinDev, 
		sum(Ejercido)Ejercido, Sum(DevSinEjer)DevSinEjer, Sum(Pagado)Pagado, Sum(EjerSinPagar)EjerSinPagar, sum(Deuda)Deuda,
		cast(sum(case when isnull(PorcAprobAnual1,0) = 0 then 0 else isnull(PorcAprobAnual2,0) / isnull(PorcAprobAnual1,0) end) as decimal(15,2))PorcAprobAnual,
		cast(sum(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else isnull(PorcAprobadocAnt2,0) / isnull(PorcAprobadocAnt1,0) end) as decimal(15,2))PorcAprobadocAnt,
		sum(isnull(NomAprobado1,0) - isnull(NomAprobado2,0)) NomAprobado,
		cast(Sum(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else isnull(PorcPVigenteAnual2,0) / isnull(PorcPVigenteAnual1,0) end) as decimal(15,2))PorcPVigenteAnual,
		cast(Sum(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else isnull(PorcPVigenteAnt2,0) / isnull(PorcPVigenteAnt1,0) end) as decimal(15,2))PorcPVigenteAnt,
		sum(isnull(NomPVigente1,0) - isnull(NomPVigente2,0)) NomPVigente,
		cast(Sum(case when isnull(PorcCompvsVigente1,0) = 0 then 0 else isnull(PorcCompvsVigente2,0) / isnull(PorcCompvsVigente1,0) end) as decimal(15,2)) PorcCompvsVigente,
		sum(NomCompvsVigente)NomCompvsVigente,
		cast(sum(case when isnull(PorcDevvsVigente1,0) = 0 then 0 else isnull(PorcDevvsVigente2,0) / isnull(PorcDevvsVigente1,0) end) as decimal(15,2))PorcDevvsVigente,
		Sum(NomDevvsVigente)NomDevvsVigente,
		cast(Sum(case when isnull(PorcCompAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAc2,0) / isnull(PorcCompAcvsVigenteAc1,0) end) as decimal(15,2))PorcCompAcvsVigenteAc,
		sum(isnull(NomCompAcvsVigenteAc1,0))NomCompAcvsVigenteAc,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAc2,0) / isnull(PorcDevAcvsVigenteAc1,0) end) as decimal(15,2)) PorcDevAcvsVigenteAc,
		sum(isnull(NomDevAcvsVigenteAc1,0))NomDevAcvsVigenteAc,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAc2,0) / isnull(PorcEjerAcvsVigenteAc1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAc,
		sum(isnull(NomEjerAcvsVigenteAc1,0))NomEjerAcvsVigenteAc,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAc2,0) / isnull(PorcPagAcvsVigenteAc1,0) end) as decimal(15,2))PorcPagAcvsVigenteAc,
		sum(isnull(NomPagAcvsVigenteAc1,0))NomPagAcvsVigenteAc,
		cast(sum(case when isnull(PorcCompAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAn2,0) / isnull(PorcCompAcvsVigenteAn1,0) end) as decimal(15,2))PorcCompAcvsVigenteAn,
		sum(isnull(NomCompAcvsVigenteAn1,0) - isnull(NomCompAcvsVigenteAn2,0))NomCompAcvsVigenteAn,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAn2,0) / isnull(PorcDevAcvsVigenteAn1,0) end) as decimal(15,2))PorcDevAcvsVigenteAn,
		Sum(isnull(NomDevAcvsVigenteAn1,0)- isnull(NomDevAcvsVigenteAn2,0)) NomDevAcvsVigenteAn,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAn2,0) / isnull(PorcEjerAcvsVigenteAn1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAn,
		sum(isnull(NomEjerAcvsVigenteAn1,0) - isnull(NomEjerAcvsVigenteAn2,0))NomEjerAcvsVigenteAn,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAn2,0) / isnull(PorcPagAcvsVigenteAn1,0) end) as decimal(15,2))PorcPagAcvsVigenteAn,
		sum(isnull(NomPagAcvsVigenteAn1,0) - isnull(NomPagAcvsVigenteAn2,0)) NomPagAcvsVigenteAn
		from @TResultadoFinal_7 as TR
		left outer join @TPorcAprobAnual_7_1		as T_1_1  on T_1_1.ID  = TR.ID and t_1_1.clave2  = Tr.Clave2 
		left outer join @TPorcAprobAnual_7_2		as T_1_2  on T_1_2.ID  = TR.ID and t_1_2.clave2  = Tr.Clave2 
		left outer join @TPorcAprobadocAnt_7_1		as T_2_1  on T_2_1.ID  = TR.ID and T_2_1.clave2  = Tr.Clave2
		left outer join @TPorcAprobadocAnt_7_2		as T_2_2  on T_2_2.ID  = TR.ID and T_2_2.clave2  = Tr.Clave2
		left outer join @TNomAprobado_7_1			as T_3_1  on T_3_1.ID  = TR.ID and T_3_1.clave2  = Tr.Clave2
		left outer join @TNomAprobado_7_2			as T_3_2  on T_3_2.ID  = TR.ID and T_3_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_7_1		as T_4_1  on T_4_1.ID  = TR.ID and T_4_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_7_2		as T_4_2  on T_4_2.ID  = TR.ID and T_4_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_7_1		as T_5_1  on T_5_1.ID  = TR.ID and T_5_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_7_2		as T_5_2  on T_5_2.ID  = TR.ID and T_5_2.clave2  = Tr.Clave2
		left outer join @TNomPVigente_7_1			as T_6_1  on T_6_1.ID  = TR.ID and T_6_1.clave2  = Tr.Clave2
		left outer join @TNomPVigente_7_2			as T_6_2  on T_6_2.ID  = TR.ID and T_6_2.clave2  = Tr.Clave2
		left outer join @TPorcCompvsVigente_7_1		as T_7_1  on T_7_1.ID  = TR.ID and T_7_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompvsVigente_7_2		as T_7_2  on T_7_2.ID  = TR.ID and T_7_2.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_7_1		as T_8_1  on T_8_1.ID  = TR.ID and T_8_1.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_7_2		as T_8_2  on T_8_2.ID  = TR.ID and T_8_2.clave2  = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAc_7_1 as T_9_1  on T_9_1.ID  = TR.ID and T_9_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompAcvsVigenteAc_7_2 as T_9_2  on T_9_2.ID  = TR.ID and T_9_2.clave2  = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAc_7_1	as T_10_1 on T_10_1.ID = TR.ID and T_10_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_7_1	as T_11_1 on T_11_1.ID = TR.ID and T_11_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_7_2	as T_11_2 on T_11_2.ID = TR.ID and T_11_2.clave2 = Tr.Clave2
		left outer join @TNomDevAcvsVigenteAc_7_1	as T_12_1 on T_12_1.ID = TR.ID and T_12_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_7_1 as T_13_1 on T_13_1.ID = TR.ID and T_13_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_7_2 as T_13_2 on T_13_2.ID = TR.ID and T_13_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAc_7_1	as T_14_1 on T_14_1.ID = TR.ID and T_14_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_7_1	as T_15_1 on T_15_1.ID = TR.ID and T_15_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_7_2	as T_15_2 on T_15_2.ID = TR.ID and T_15_2.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAc_7_1	as T_16_1 on T_16_1.ID = TR.ID and T_16_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_7_1 as T_17_1 on T_17_1.ID = TR.ID and T_17_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_7_2 as T_17_2 on T_17_2.ID = TR.ID and T_17_2.clave2 = Tr.Clave2
		left outer join @TNomCompAcvsVigenteAn_7_1	as T_18_1 on T_18_1.ID = TR.ID and T_18_1.clave2 = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAn_7_2	as T_18_2 on T_18_2.ID = TR.ID and T_18_2.clave2 = Tr.Clave2 
		left outer join @TPorcDevAcvsVigenteAn_7_1	as T_19_1 on T_19_1.ID = TR.ID and T_19_1.clave2 = Tr.Clave2  
		left outer join @TPorcDevAcvsVigenteAn_7_2	as T_19_2 on T_19_2.ID = TR.ID and T_19_2.clave2 = Tr.Clave2   
		left outer join @TNomDevAcvsVigenteAn_7_1	as T_20_1 on T_20_1.ID = TR.ID and T_20_1.clave2 = Tr.Clave2  
		left outer join @TNomDevAcvsVigenteAn_7_2	as T_20_2 on T_20_2.ID = TR.ID and T_20_2.clave2 = Tr.Clave2  
		left outer join @TPorcEjerAcvsVigenteAn_7_1 as T_21_1 on T_21_1.ID = TR.ID and T_21_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAn_7_2 as T_21_2 on T_21_2.ID = TR.ID and T_21_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAn_7_1	as T_22_1 on T_22_1.ID = TR.ID and T_22_1.clave2 = Tr.Clave2 
		left outer join @TNomEjerAcvsVigenteAn_7_2	as T_22_2 on T_22_2.ID = TR.ID and T_22_2.clave2 = Tr.Clave2  
		left outer join @TPorcPagAcvsVigenteAn_7_1	as T_23_1 on T_23_1.ID = TR.ID and T_23_1.clave2 = Tr.Clave2 
		left outer join @TPorcPagAcvsVigenteAn_7_2	as T_23_2 on T_23_2.ID = TR.ID and T_23_2.clave2 = Tr.Clave2 
		left outer join @TNomPagAcvsVigenteAn_7_1	as T_24_1 on T_24_1.ID = TR.ID and T_24_1.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAn_7_2	as T_24_2 on T_24_2.ID = TR.ID and T_24_2.clave2 = Tr.Clave2
		group by Clave1, Descripcion, Tr.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Descripcion4, Clave4a, Descripcion4a, Clave5, Descripcion5, 
		Clave6,	Descripcion6
		order by Tr.Clave2
	END

	If @Tipo = 8 
	BEGIN
		--Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento
		--Valores Absolutos

		DECLARE @TResultadoFinal_8 as table (Clave1 varchar(8), Descripcion varchar(150) ,Clave2 varchar(8) ,Descripcion2 varchar(150) ,Clave3 varchar(8) ,
		Descripcion3 varchar(150), Clave4 varchar(MAx), Descripcion4 varchar(150) ,Clave5 varchar(8),Id varchar(8),  Descripcion5 varchar(150) ,
		Clave6 varchar(8),Descripcion6 varchar(150) ,Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), 
		Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2),Comprometido decimal(15,2), PreCompSinComp decimal(15,2), 
		PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2),PresSinDev decimal(15,2),Ejercido decimal(15,2), DevSinEjer decimal(15,2), 
		Pagado decimal(15,2), EjerSinPagar decimal(15,2),Deuda decimal(15,2),PorcAprobAnual decimal(15,2),PorcAprobadocAnt decimal(15,2),
		NomAprobado decimal(15,2),PorcPVigenteAnual decimal(15,2),PorcPVigenteAnt decimal(15,2),NomPVigente decimal(15,2),PorcCompvsVigente decimal(15,2),
		NomCompvsVigente decimal(15,2),PorcDevvsVigente decimal(15,2),NomDevvsVigente decimal(15,2),PorcCompAcvsVigenteAc decimal(15,2),
		NomCompAcvsVigenteAc decimal(15,2),PorcDevAcvsVigenteAc decimal(15,2),NomDevAcvsVigenteAc decimal(15,2),PorcEjerAcvsVigenteAc decimal(15,2),
		NomEjerAcvsVigenteAc decimal(15,2),	PorcPagAcvsVigenteAc decimal(15,2),	NomPagAcvsVigenteAc decimal(15,2),	PorcCompAcvsVigenteAn decimal(15,2),
		NomCompAcvsVigenteAn decimal(15,2),	PorcDevAcvsVigenteAn decimal(15,2),	NomDevAcvsVigenteAn decimal(15,2),	PorcEjerAcvsVigenteAn decimal(15,2),
		NomEjerAcvsVigenteAn decimal(15,2),	PorcPagAcvsVigenteAn decimal(15,2),	NomPagAcvsVigenteAn decimal(15,2))

		INSERT INTO @TResultadoFinal_8 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Descripcion4, Clave5, Id, Descripcion5,
		Clave6, Descripcion6, Autorizado, TransferenciaAmp , TransferenciaRed , Modificado , PreComprometido , PresVigSinPreComp ,Comprometido , 
		PreCompSinComp , PresDispComp , Devengado , CompSinDev ,PresSinDev ,Ejercido , DevSinEjer , Pagado , EjerSinPagar ,Deuda, PorcAprobAnual,
		PorcAprobadocAnt, NomAprobado,PorcPVigenteAnual, PorcPVigenteAnt ,NomPVigente, PorcCompvsVigente,NomCompvsVigente,PorcDevvsVigente,NomDevvsVigente, 
		PorcCompAcvsVigenteAc ,NomCompAcvsVigenteAc,PorcDevAcvsVigenteAc,NomDevAcvsVigenteAc,PorcEjerAcvsVigenteAc,NomEjerAcvsVigenteAc,PorcPagAcvsVigenteAc,
		NomPagAcvsVigenteAc,PorcCompAcvsVigenteAn,NomCompAcvsVigenteAn,	PorcDevAcvsVigenteAn,NomDevAcvsVigenteAn,PorcEjerAcvsVigenteAn,NomEjerAcvsVigenteAn,
		PorcPagAcvsVigenteAn,NomPagAcvsVigenteAn)

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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 	INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad 
		ON (C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP 	ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto    
		where  (Mes BETWEEN @Mes and @Mes2) AND Year=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then c_RamoPresupuestal.Clave else
		@Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.Clave else @Clave2 end) 
		and C_AreaResponsabilidad.Clave = case when @ClaveUR = '' then C_AreaResponsabilidad.Clave else @ClaveUR end 
		AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP END
		group by C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida , C_AreaResponsabilidad.Clave  , 
		C_AreaResponsabilidad.Nombre, C_RamoPresupuestal.CLAVE , C_RamoPresupuestal.DESCRIPCION ,  C_EP_Ramo.Clave, C_EP_Ramo.Nombre, C_EP_Ramo.Id, 
		C_FuenteFinanciamiento.CLAVE, C_FuenteFinanciamiento.DESCRIPCION ,C_ProyectosInversion.nombre, C_ProyectosInversion.CLAVE  
		Order By C_AreaResponsabilidad.Clave ,C_PartidasGenericasPres.IdPartidaGenerica , C_RamoPresupuestal.CLAVE 


		--Columna 1 PorcAprobAnual
		Declare @TPorcAprobAnual_8_1 as Table (PorcAprobAnual1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcAprobAnual_8_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcAprobAnual_8_2 as Table (PorcAprobAnual2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcAprobAnual_8_2
		Select sum(isnull(tp.Autorizado,0))  as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg 
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_8_1 as Table (PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcAprobadocAnt_8_1
		Select  sum(isnull(tp.Autorizado,0))  as PorcAprobadocAnt1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg 
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcAprobadocAnt_8_2 as Table (PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcAprobadocAnt_8_2
		Select sum(isnull(tp.Autorizado,0))  as PorcAprobadocAnt2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP  ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		
		--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_8_1 as Table (NomAprobado1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomAprobado_8_1
		Select  (sum(isnull(tp.Autorizado,0)))as NomAprobado1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  INNER JOIN C_ProyectosInversion 	ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id		
		
		Declare @TNomAprobado_8_2 as Table (NomAprobado2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomAprobado_8_2
		Select  sum(isnull(tp.Autorizado,0))as NomAprobado2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
		INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_8_1 as Table (PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcPVigenteAnual_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
		INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes = 0) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcPVigenteAnual_8_2 as Table (PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcPVigenteAnual_8_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto 
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_8_1 as Table (PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcPVigenteAnt_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcPVigenteAnt_8_2 as Table (PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcPVigenteAnt_8_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_8_1 as Table (NomPVigente1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomPVigente_8_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TNomPVigente_8_2 as Table (NomPVigente2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomPVigente_8_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
		INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		-----------------PorcCompvsVigente
		Declare @TPorcCompvsVigente_8_1 as Table (PorcCompvsVigente1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcCompvsVigente_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompvsVigente1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcCompvsVigente_8_2 as Table (PorcCompvsVigente2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcCompvsVigente_8_2
		Select sum(isnull(TP.Comprometido,0)) as PorcCompvsVigente2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		-----------PorcDevvsVigente
		Declare @TPorcDevvsVigente_8_1 as Table (PorcDevvsVigente1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcDevvsVigente_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcDevvsVigente1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
		INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcDevvsVigente_8_2 as Table (PorcDevvsVigente2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcDevvsVigente_8_2
		Select sum(isnull(TP.Devengado,0)) as PorcDevvsVigente2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		---------------PorcCompAcvsVigenteAc
		Declare @TPorcCompAcvsVigenteAc_8_1 as Table (PorcCompAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcCompAcvsVigenteAc_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
		INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcCompAcvsVigenteAc_8_2 as Table (PorcCompAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcCompAcvsVigenteAc_8_2
		Select sum(isnull(tp.Comprometido,0))  as PorcCompAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		-----------NomCompAcvsVigenteAc
		Declare @TNomCompAcvsVigenteAc_8_1 as Table (NomCompAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomCompAcvsVigenteAc_8_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0)) as NomCompAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		-----------------PorcDevAcvsVigenteAc
		Declare @TPorcDevAcvsVigenteAc_8_1 as Table (PorcDevAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcDevAcvsVigenteAc_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcDevAcvsVigenteAc_8_2 as Table (PorcDevAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcDevAcvsVigenteAc_8_2
		Select sum(isnull(tp.Devengado,0))  as PorcDevAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		---------------NomDevAcvsVigenteAc
		Declare @TNomDevAcvsVigenteAc_8_1 as Table (NomDevAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomDevAcvsVigenteAc_8_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0)) as NomDevAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--------------PorcEjerAcvsVigenteAc
		Declare @TPorcEjerAcvsVigenteAc_8_1 as Table (PorcEjerAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcEjerAcvsVigenteAc_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcEjerAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcEjerAcvsVigenteAc_8_2 as Table (PorcEjerAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcEjerAcvsVigenteAc_8_2
		Select sum(isnull(tp.Ejercido,0))  as PorcEjerAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		----------------NomEjerAcvsVigenteAc
		Declare @TNomEjerAcvsVigenteAc_8_1 as Table (NomEjerAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomEjerAcvsVigenteAc_8_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0)) as NomEjerAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida  INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
		INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		------------------PorcPagAcvsVigenteAc
		Declare @TPorcPagAcvsVigenteAc_8_1 as Table (PorcPagAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcPagAcvsVigenteAc_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPagAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcPagAcvsVigenteAc_8_2 as Table (PorcPagAcvsVigenteAc2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcPagAcvsVigenteAc_8_2
		Select sum(isnull(tp.Pagado,0))  as PorcPagAcvsVigenteAc2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--------------------NomPagAcvsVigenteAc
		Declare @TNomPagAcvsVigenteAc_8_1 as Table (NomPagAcvsVigenteAc1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomPagAcvsVigenteAc_8_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0))as NomPagAcvsVigenteAc1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		------------------PorcCompAcvsVigenteAn
		Declare @TPorcCompAcvsVigenteAn_8_1 as Table (PorcCompAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcCompAcvsVigenteAn_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcCompAcvsVigenteAn_8_2 as Table (PorcCompAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcCompAcvsVigenteAn_8_2
		Select  sum(isnull(tp.Comprometido,0)) as PorcCompAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 	INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--------------------NomCompAcvsVigenteAn
		Declare @TNomCompAcvsVigenteAn_8_1 as Table (NomCompAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomCompAcvsVigenteAn_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomCompAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TNomCompAcvsVigenteAn_8_2 as Table (NomCompAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomCompAcvsVigenteAn_8_2
		Select  (sum(isnull(tp.Comprometido,0)))as NomCompAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		---------------PorcDevAcvsVigenteAn
		Declare @TPorcDevAcvsVigenteAn_8_1 as Table (PorcDevAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcDevAcvsVigenteAn_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as PorcDevAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcDevAcvsVigenteAn_8_2 as Table (PorcDevAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcDevAcvsVigenteAn_8_2
		Select  sum(isnull(tp.Devengado,0)) as PorcDevAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		--------------NomDevAcvsVigenteAn
		Declare @TNomDevAcvsVigenteAn_8_1 as Table (NomDevAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomDevAcvsVigenteAn_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomDevAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TNomDevAcvsVigenteAn_8_2 as Table (NomDevAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomDevAcvsVigenteAn_8_2
		Select  (sum(isnull(tp.Devengado,0)))as NomDevAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		----------------PorcEjerAcvsVigenteAn
		Declare @TPorcEjerAcvsVigenteAn_8_1 as Table (PorcEjerAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcEjerAcvsVigenteAn_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcEjerAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcEjerAcvsVigenteAn_8_2 as Table (PorcEjerAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcEjerAcvsVigenteAn_8_2
		Select  sum(isnull(tp.Ejercido,0)) as PorcEjerAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto 	INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		----------------NomEjerAcvsVigenteAn
		Declare @TNomEjerAcvsVigenteAn_8_1 as Table (NomEjerAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomEjerAcvsVigenteAn_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomEjerAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto    INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TNomEjerAcvsVigenteAn_8_2 as Table (NomEjerAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomEjerAcvsVigenteAn_8_2
		Select  (sum(isnull(tp.Ejercido,0)))as NomEjerAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  	INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 	INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento   INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto    INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		-------------------PorcPagAcvsVigenteAn
		Declare @TPorcPagAcvsVigenteAn_8_1 as Table (PorcPagAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcPagAcvsVigenteAn_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPagAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 	INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 	INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento   	INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  	INNER JOIN C_ConceptosNEP 	ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Declare @TPorcPagAcvsVigenteAn_8_2 as Table (PorcPagAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TPorcPagAcvsVigenteAn_8_2
		Select sum(isnull(tp.Pagado,0))  as PorcPagAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP	ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  	INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 	INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 	INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    	INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion 	ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		----------------NomPagAcvsVigenteAn
		Declare @TNomPagAcvsVigenteAn_8_1 as Table (NomPagAcvsVigenteAn1 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomPagAcvsVigenteAn_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPagAcvsVigenteAn1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  	INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 	INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 	INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    	INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  	INNER JOIN C_ConceptosNEP 	ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion 	ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TNomPagAcvsVigenteAn_8_2 as Table (NomPagAcvsVigenteAn2 decimal(15,2), Clave int, Clave2 varchar(8), id Int)
		insert into @TNomPagAcvsVigenteAn_8_2
		Select  (sum(isnull(tp.Pagado,0))) as NomPagAcvsVigenteAn2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    	INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto    	INNER JOIN C_ConceptosNEP 	ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion 	ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then Cr.Clave else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.Clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP  end
		and CA.Clave = case when @ClaveUR = '' then ca.Clave else @ClaveUR end
		group by cr.CLAVE, ca.Clave, cepr.id

		Select Clave1, Descripcion, Tr.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Descripcion4, Clave5, Descripcion5, 
		Clave6,	Descripcion6, Sum(Autorizado)Autorizado, sum(TransferenciaAmp)TransferenciaAmp, sum(TransferenciaRed)TransferenciaRed, 
		sum(Modificado)Modificado, Sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, sum(Comprometido)Comprometido, 
		Sum(PreCompSinComp)PreCompSinComp, SUM(PresDispComp)PresDispComp, sum(Devengado)Devengado, Sum(CompSinDev)CompSinDev, Sum(PresSinDev)PresSinDev, 
		sum(Ejercido)Ejercido, Sum(DevSinEjer)DevSinEjer, Sum(Pagado)Pagado, Sum(EjerSinPagar)EjerSinPagar, sum(Deuda)Deuda,
		cast(sum(case when isnull(PorcAprobAnual1,0) = 0 then 0 else isnull(PorcAprobAnual2,0) / isnull(PorcAprobAnual1,0) end) as decimal(15,2))PorcAprobAnual,
		cast(sum(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else isnull(PorcAprobadocAnt2,0) / isnull(PorcAprobadocAnt1,0) end) as decimal(15,2))PorcAprobadocAnt,
		sum(isnull(NomAprobado1,0) - isnull(NomAprobado2,0)) NomAprobado,
		cast(Sum(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else isnull(PorcPVigenteAnual2,0) / isnull(PorcPVigenteAnual1,0) end) as decimal(15,2))PorcPVigenteAnual,
		cast(Sum(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else isnull(PorcPVigenteAnt2,0) / isnull(PorcPVigenteAnt1,0) end) as decimal(15,2))PorcPVigenteAnt,
		sum(isnull(NomPVigente1,0) - isnull(NomPVigente2,0)) NomPVigente,
		cast(Sum(case when isnull(PorcCompvsVigente1,0) = 0 then 0 else isnull(PorcCompvsVigente2,0) / isnull(PorcCompvsVigente1,0) end) as decimal(15,2)) PorcCompvsVigente,
		sum(NomCompvsVigente)NomCompvsVigente,
		cast(sum(case when isnull(PorcDevvsVigente1,0) = 0 then 0 else isnull(PorcDevvsVigente2,0) / isnull(PorcDevvsVigente1,0) end) as decimal(15,2))PorcDevvsVigente,
		Sum(NomDevvsVigente)NomDevvsVigente,
		cast(Sum(case when isnull(PorcCompAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAc2,0) / isnull(PorcCompAcvsVigenteAc1,0) end) as decimal(15,2))PorcCompAcvsVigenteAc,
		sum(isnull(NomCompAcvsVigenteAc1,0))NomCompAcvsVigenteAc,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAc2,0) / isnull(PorcDevAcvsVigenteAc1,0) end) as decimal(15,2)) PorcDevAcvsVigenteAc,
		sum(isnull(NomDevAcvsVigenteAc1,0))NomDevAcvsVigenteAc,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAc2,0) / isnull(PorcEjerAcvsVigenteAc1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAc,
		sum(isnull(NomEjerAcvsVigenteAc1,0))NomEjerAcvsVigenteAc,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAc2,0) / isnull(PorcPagAcvsVigenteAc1,0) end) as decimal(15,2))PorcPagAcvsVigenteAc,
		sum(isnull(NomPagAcvsVigenteAc1,0))NomPagAcvsVigenteAc,
		cast(sum(case when isnull(PorcCompAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAn2,0) / isnull(PorcCompAcvsVigenteAn1,0) end) as decimal(15,2))PorcCompAcvsVigenteAn,
		sum(isnull(NomCompAcvsVigenteAn1,0) - isnull(NomCompAcvsVigenteAn2,0))NomCompAcvsVigenteAn,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAn2,0) / isnull(PorcDevAcvsVigenteAn1,0) end) as decimal(15,2))PorcDevAcvsVigenteAn,
		Sum(isnull(NomDevAcvsVigenteAn1,0)- isnull(NomDevAcvsVigenteAn2,0)) NomDevAcvsVigenteAn,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAn2,0) / isnull(PorcEjerAcvsVigenteAn1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAn,
		sum(isnull(NomEjerAcvsVigenteAn1,0) - isnull(NomEjerAcvsVigenteAn2,0))NomEjerAcvsVigenteAn,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAn2,0) / isnull(PorcPagAcvsVigenteAn1,0) end) as decimal(15,2))PorcPagAcvsVigenteAn,
		sum(isnull(NomPagAcvsVigenteAn1,0) - isnull(NomPagAcvsVigenteAn2,0)) NomPagAcvsVigenteAn
		from @TResultadoFinal_8 as TR
		left outer join @TPorcAprobAnual_8_1		as T_1_1  on T_1_1.ID  = TR.ID and t_1_1.clave2  = Tr.Clave2 
		left outer join @TPorcAprobAnual_8_2		as T_1_2  on T_1_2.ID  = TR.ID and t_1_2.clave2  = Tr.Clave2 
		left outer join @TPorcAprobadocAnt_8_1		as T_2_1  on T_2_1.ID  = TR.ID and T_2_1.clave2  = Tr.Clave2
		left outer join @TPorcAprobadocAnt_8_2		as T_2_2  on T_2_2.ID  = TR.ID and T_2_2.clave2  = Tr.Clave2
		left outer join @TNomAprobado_8_1			as T_3_1  on T_3_1.ID  = TR.ID and T_3_1.clave2  = Tr.Clave2
		left outer join @TNomAprobado_8_2			as T_3_2  on T_3_2.ID  = TR.ID and T_3_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_8_1		as T_4_1  on T_4_1.ID  = TR.ID and T_4_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnual_8_2		as T_4_2  on T_4_2.ID  = TR.ID and T_4_2.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_8_1		as T_5_1  on T_5_1.ID  = TR.ID and T_5_1.clave2  = Tr.Clave2
		left outer join @TPorcPVigenteAnt_8_2		as T_5_2  on T_5_2.ID  = TR.ID and T_5_2.clave2  = Tr.Clave2
		left outer join @TNomPVigente_8_1			as T_6_1  on T_6_1.ID  = TR.ID and T_6_1.clave2  = Tr.Clave2
		left outer join @TNomPVigente_8_2			as T_6_2  on T_6_2.ID  = TR.ID and T_6_2.clave2  = Tr.Clave2
		left outer join @TPorcCompvsVigente_8_1		as T_7_1  on T_7_1.ID  = TR.ID and T_7_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompvsVigente_8_2		as T_7_2  on T_7_2.ID  = TR.ID and T_7_2.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_8_1		as T_8_1  on T_8_1.ID  = TR.ID and T_8_1.clave2  = Tr.Clave2
		left outer join @TPorcDevvsVigente_8_2		as T_8_2  on T_8_2.ID  = TR.ID and T_8_2.clave2  = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAc_8_1 as T_9_1  on T_9_1.ID  = TR.ID and T_9_1.clave2  = Tr.Clave2 
		left outer join @TPorcCompAcvsVigenteAc_8_2 as T_9_2  on T_9_2.ID  = TR.ID and T_9_2.clave2  = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAc_8_1	as T_10_1 on T_10_1.ID = TR.ID and T_10_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_8_1	as T_11_1 on T_11_1.ID = TR.ID and T_11_1.clave2 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_8_2	as T_11_2 on T_11_2.ID = TR.ID and T_11_2.clave2 = Tr.Clave2
		left outer join @TNomDevAcvsVigenteAc_8_1	as T_12_1 on T_12_1.ID = TR.ID and T_12_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_8_1 as T_13_1 on T_13_1.ID = TR.ID and T_13_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAc_8_2 as T_13_2 on T_13_2.ID = TR.ID and T_13_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAc_8_1	as T_14_1 on T_14_1.ID = TR.ID and T_14_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_8_1	as T_15_1 on T_15_1.ID = TR.ID and T_15_1.clave2 = Tr.Clave2
		left outer join @TPorcPagAcvsVigenteAc_8_2	as T_15_2 on T_15_2.ID = TR.ID and T_15_2.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAc_8_1	as T_16_1 on T_16_1.ID = TR.ID and T_16_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_8_1 as T_17_1 on T_17_1.ID = TR.ID and T_17_1.clave2 = Tr.Clave2
		left outer join @TPorcCompAcvsVigenteAn_8_2 as T_17_2 on T_17_2.ID = TR.ID and T_17_2.clave2 = Tr.Clave2
		left outer join @TNomCompAcvsVigenteAn_8_1	as T_18_1 on T_18_1.ID = TR.ID and T_18_1.clave2 = Tr.Clave2 
		left outer join @TNomCompAcvsVigenteAn_8_2	as T_18_2 on T_18_2.ID = TR.ID and T_18_2.clave2 = Tr.Clave2 
		left outer join @TPorcDevAcvsVigenteAn_8_1	as T_19_1 on T_19_1.ID = TR.ID and T_19_1.clave2 = Tr.Clave2  
		left outer join @TPorcDevAcvsVigenteAn_8_2	as T_19_2 on T_19_2.ID = TR.ID and T_19_2.clave2 = Tr.Clave2   
		left outer join @TNomDevAcvsVigenteAn_8_1	as T_20_1 on T_20_1.ID = TR.ID and T_20_1.clave2 = Tr.Clave2  
		left outer join @TNomDevAcvsVigenteAn_8_2	as T_20_2 on T_20_2.ID = TR.ID and T_20_2.clave2 = Tr.Clave2  
		left outer join @TPorcEjerAcvsVigenteAn_8_1 as T_21_1 on T_21_1.ID = TR.ID and T_21_1.clave2 = Tr.Clave2
		left outer join @TPorcEjerAcvsVigenteAn_8_2 as T_21_2 on T_21_2.ID = TR.ID and T_21_2.clave2 = Tr.Clave2
		left outer join @TNomEjerAcvsVigenteAn_8_1	as T_22_1 on T_22_1.ID = TR.ID and T_22_1.clave2 = Tr.Clave2 
		left outer join @TNomEjerAcvsVigenteAn_8_2	as T_22_2 on T_22_2.ID = TR.ID and T_22_2.clave2 = Tr.Clave2  
		left outer join @TPorcPagAcvsVigenteAn_8_1	as T_23_1 on T_23_1.ID = TR.ID and T_23_1.clave2 = Tr.Clave2 
		left outer join @TPorcPagAcvsVigenteAn_8_2	as T_23_2 on T_23_2.ID = TR.ID and T_23_2.clave2 = Tr.Clave2 
		left outer join @TNomPagAcvsVigenteAn_8_1	as T_24_1 on T_24_1.ID = TR.ID and T_24_1.clave2 = Tr.Clave2
		left outer join @TNomPagAcvsVigenteAn_8_2	as T_24_2 on T_24_2.ID = TR.ID and T_24_2.clave2 = Tr.Clave2
		group by Clave1, Descripcion, Tr.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Descripcion4, Clave5, Descripcion5, 
		Clave6,	Descripcion6
		order by Tr.Clave2, DESCRIPCION4
	END

	If @Tipo = 9
	BEGIN
		--Ramo o Dependencia / Distribución Geográfica / Programas y Proyectos de Inversión
		--Valores Absolutos

		DECLARE @TResultadoFinal_9 as table (Clave1 varchar(8),Descripcion varchar(150) ,Clave2 varchar(8) ,Descripcion2 varchar(150) ,Clave3 varchar(8) ,
		Id varchar(8), Descripcion3 varchar(150), Clave4 varchar(MAx), Descripcion4 varchar(150) ,Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2),Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2),PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2),Deuda decimal(15,2),	PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2),NomAprobado decimal(15,2),PorcPVigenteAnual decimal(15,2),PorcPVigenteAnt decimal(15,2),	NomPVigente decimal(15,2),
		PorcCompvsVigente decimal(15,2),NomCompvsVigente decimal(15,2),PorcDevvsVigente decimal(15,2),NomDevvsVigente decimal(15,2),PorcCompAcvsVigenteAc decimal(15,2),
		NomCompAcvsVigenteAc decimal(15,2),PorcDevAcvsVigenteAc decimal(15,2),NomDevAcvsVigenteAc decimal(15,2),PorcEjerAcvsVigenteAc decimal(15,2),
		NomEjerAcvsVigenteAc decimal(15,2),PorcPagAcvsVigenteAc decimal(15,2),NomPagAcvsVigenteAc decimal(15,2),PorcCompAcvsVigenteAn decimal(15,2),
		NomCompAcvsVigenteAn decimal(15,2),PorcDevAcvsVigenteAn decimal(15,2),NomDevAcvsVigenteAn decimal(15,2),PorcEjerAcvsVigenteAn decimal(15,2),
		NomEjerAcvsVigenteAn decimal(15,2),PorcPagAcvsVigenteAn decimal(15,2),NomPagAcvsVigenteAn decimal(15,2))
		
		INSERT INTO @TResultadoFinal_9 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Id, Descripcion3, Clave4, Descripcion4, Autorizado, 
		TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp,Comprometido, PreCompSinComp, PresDispComp, Devengado, 
		CompSinDev,PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual, PorcAprobadocAnt, NomAprobado, PorcPVigenteAnual, 
		PorcPVigenteAnt, NomPVigente, PorcCompvsVigente, NomCompvsVigente, PorcDevvsVigente, NomDevvsVigente, PorcCompAcvsVigenteAc, NomCompAcvsVigenteAc,
		PorcDevAcvsVigenteAc, NomDevAcvsVigenteAc, PorcEjerAcvsVigenteAc, NomEjerAcvsVigenteAc, PorcPagAcvsVigenteAc, NomPagAcvsVigenteAc,
		PorcCompAcvsVigenteAn, NomCompAcvsVigenteAn, PorcDevAcvsVigenteAn, NomDevAcvsVigenteAn, PorcEjerAcvsVigenteAn, NomEjerAcvsVigenteAn,
		PorcPagAcvsVigenteAn, NomPagAcvsVigenteAn)

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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo 
		ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto  left JOIN C_PartidasPres  
		ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal  
		ON C_ClasificadorGeograficoPresupuestal.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		where  (Mes BETWEEN @Mes and @Mes2) AND Year=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.Clave else @Clave end
		and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end) 
		AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.ID else @IdEP end
		group by C_ClasificadorGeograficoPresupuestal.Clave,C_ClasificadorGeograficoPresupuestal.Descripcion, C_RamoPresupuestal.CLAVE, 
		C_RamoPresupuestal.DESCRIPCION ,C_EP_Ramo.Clave , C_EP_Ramo.Nombre, C_EP_Ramo.Id ,T_SellosPresupuestales.IdProyecto, C_ProyectosInversion.CLAVE ,
		C_ProyectosInversion.nombre 
		Order By C_ClasificadorGeograficoPresupuestal.Clave


		--Columna 1 PorcAprobAnual
		Declare @TPorcAprobAnual_9_1 as Table(PorcAprobAnual1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcAprobAnual_9_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcAprobAnual_9_2 as Table(PorcAprobAnual2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcAprobAnual_9_2
		Select sum(isnull(tp.Autorizado,0))  as PorcAprobAnua1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_9_1 as Table(PorcAprobadocAnt1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcAprobadocAnt_9_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP 	ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  	INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto 	INNER JOIN C_ProyectosInversion cpi	ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  	ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcAprobadocAnt_9_2 as Table(PorcAprobadocAnt2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcAprobadocAnt_9_2
		Select sum(isnull(tp.Autorizado,0))  as PorcAprobadocAnt2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_9_1 as Table(NomAprobado1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomAprobado_9_1
		Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TNomAprobado_9_2 as Table(NomAprobado2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomAprobado_9_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_9_1 as Table(PorcPVigenteAnual1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcPVigenteAnual_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes = 0) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcPVigenteAnual_9_2 as Table(PorcPVigenteAnual2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcPVigenteAnual_9_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnual2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_9_1 as Table(PorcPVigenteAnt1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcPVigenteAnt_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcPVigenteAnt_9_2 as Table(PorcPVigenteAnt2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcPVigenteAnt_9_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_9_1 as Table(NomPVigente1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomPVigente_9_1
		Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TNomPVigente_9_2 as Table(NomPVigente2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomPVigente_9_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as NomPVigente1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		---------------PorcCompvsVigente
		Declare @TPorcCompvsVigente_9_1 as Table(PorcCompvsVigente1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcCompvsVigente_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompvsVigente1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcCompvsVigente_9_2 as Table(PorcCompvsVigente2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcCompvsVigente_9_2
		Select sum(isnull(TP.Comprometido,0)) as PorcCompvsVigente2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi	ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		------------------PorcDevvsVigente
		Declare @TPorcDevvsVigente_9_1 as Table(PorcDevvsVigente1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcDevvsVigente_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevvsVigente1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcDevvsVigente_9_2 as Table(PorcDevvsVigente2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcDevvsVigente_9_2
		Select sum(isnull(TP.Devengado,0)) as PorcDevvsVigente2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN @Mes and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		-----------------PorcCompAcvsVigenteAc
		Declare @TPorcCompAcvsVigenteAc_9_1 as Table(PorcCompAcvsVigenteAc1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcCompAcvsVigenteAc_9_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAc1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcCompAcvsVigenteAc_9_2 as Table(PorcCompAcvsVigenteAc2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcCompAcvsVigenteAc_9_2
		Select sum(isnull(tp.Comprometido,0))  as PorcCompAcvsVigenteAc2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		------------NomCompAcvsVigenteAc
		Declare @TNomCompAcvsVigenteAc_9_1 as Table(NomCompAcvsVigenteAc1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomCompAcvsVigenteAc_9_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Comprometido,0)) as NomCompAcvsVigenteAc1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		---------------PorcDevAcvsVigenteAc
		Declare @TPorcDevAcvsVigenteAc_9_1 as Table(PorcDevAcvsVigenteAc1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcDevAcvsVigenteAc_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevAcvsVigenteAc1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi 	ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcDevAcvsVigenteAc_9_2 as Table(PorcDevAcvsVigenteAc2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcDevAcvsVigenteAc_9_2
		Select sum(isnull(tp.Devengado,0)) as PorcDevAcvsVigenteAc2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		---------------NomDevAcvsVigenteAc
		Declare @TNomDevAcvsVigenteAc_9_1 as Table(NomDevAcvsVigenteAc1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomDevAcvsVigenteAc_9_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Devengado,0)) as NomDevAcvsVigenteAc1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		--------------PorcEjerAcvsVigenteAc
		Declare @TPorcEjerAcvsVigenteAc_9_1 as Table(PorcEjerAcvsVigenteAc1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcEjerAcvsVigenteAc_9_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcEjerAcvsVigenteAc1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales  INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcEjerAcvsVigenteAc_9_2 as Table(PorcEjerAcvsVigenteAc2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcEjerAcvsVigenteAc_9_2
		Select sum(isnull(tp.Ejercido,0))  as PorcEjerAcvsVigenteAc2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		------------------NomEjerAcvsVigenteAc
		Declare @TNomEjerAcvsVigenteAc_9_1 as Table(NomEjerAcvsVigenteAc1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomEjerAcvsVigenteAc_9_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Ejercido,0)) as NomEjerAcvsVigenteAc1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		------------------PorcPagAcvsVigenteAc
		Declare @TPorcPagAcvsVigenteAc_9_1 as Table(PorcPagAcvsVigenteAc1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcPagAcvsVigenteAc_9_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPagAcvsVigenteAc1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcPagAcvsVigenteAc_9_2 as Table(PorcPagAcvsVigenteAc2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcPagAcvsVigenteAc_9_2
		Select sum(isnull(tp.Pagado,0))  as PorcPagAcvsVigenteAc2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		---------------NomPagAcvsVigenteAc
		Declare @TNomPagAcvsVigenteAc_9_1 as Table(NomPagAcvsVigenteAc1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomPagAcvsVigenteAc_9_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(tp.Pagado,0))  as NomPagAcvsVigenteAc1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		------------------PorcCompAcvsVigenteAn
		Declare @TPorcCompAcvsVigenteAn_9_1 as Table(PorcCompAcvsVigenteAn1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcCompAcvsVigenteAn_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcCompAcvsVigenteAn1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcCompAcvsVigenteAn_9_2 as Table(PorcCompAcvsVigenteAn2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcCompAcvsVigenteAn_9_2
		Select  sum(isnull(tp.Comprometido,0))  as PorcCompAcvsVigenteAn2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		--------------NomCompAcvsVigenteAn
		Declare @TNomCompAcvsVigenteAn_9_1 as Table(NomCompAcvsVigenteAn1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomCompAcvsVigenteAn_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomCompAcvsVigenteAn1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TNomCompAcvsVigenteAn_9_2 as Table(NomCompAcvsVigenteAn2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomCompAcvsVigenteAn_9_2
		Select  (sum(isnull(tp.Comprometido,0))) as NomCompAcvsVigenteAn2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		----------------PorcDevAcvsVigenteAn
		Declare @TPorcDevAcvsVigenteAn_9_1 as Table(PorcDevAcvsVigenteAn1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcDevAcvsVigenteAn_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcDevAcvsVigenteAn1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcDevAcvsVigenteAn_9_2 as Table(PorcDevAcvsVigenteAn2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcDevAcvsVigenteAn_9_2
		Select  sum(isnull(tp.Devengado,0)) as PorcDevAcvsVigenteAn2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		----------------NomDevAcvsVigenteAn
		Declare @TNomDevAcvsVigenteAn_9_1 as Table(NomDevAcvsVigenteAn1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomDevAcvsVigenteAn_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomDevAcvsVigenteAn1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TNomDevAcvsVigenteAn_9_2 as Table(NomDevAcvsVigenteAn2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomDevAcvsVigenteAn_9_2
		Select  (sum(isnull(tp.Devengado,0))) as NomDevAcvsVigenteAn2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		---------------PorcEjerAcvsVigenteAn
		Declare @TPorcEjerAcvsVigenteAn_9_1 as Table(PorcEjerAcvsVigenteAn1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcEjerAcvsVigenteAn_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcEjerAcvsVigenteAn1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcEjerAcvsVigenteAn_9_2 as Table(PorcEjerAcvsVigenteAn2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcEjerAcvsVigenteAn_9_2
		Select sum(isnull(tp.Ejercido,0)) as PorcEjerAcvsVigenteAn2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		-------------NomEjerAcvsVigenteAn
		Declare @NomEjerAcvsVigenteAn_9_1 as Table(NomEjerAcvsVigenteAn1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @NomEjerAcvsVigenteAn_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomEjerAcvsVigenteAn1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @NomEjerAcvsVigenteAn_9_2 as Table(NomEjerAcvsVigenteAn2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @NomEjerAcvsVigenteAn_9_2
		Select  (sum(isnull(tp.Ejercido,0)))  as NomEjerAcvsVigenteAn2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico 
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		---------------PorcPagAcvsVigenteAn
		Declare @PorcPagAcvsVigenteAn_9_1 as Table(PorcPagAcvsVigenteAn1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @PorcPagAcvsVigenteAn_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPagAcvsVigenteAn1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @PorcPagAcvsVigenteAn_9_2 as Table(PorcPagAcvsVigenteAn2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @PorcPagAcvsVigenteAn_9_2
		Select sum(isnull(tp.Pagado,0)) as PorcPagAcvsVigenteAn2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		-----------------NomPagAcvsVigenteAn
		Declare @TNomPagAcvsVigenteAn_9_1 as Table(NomPagAcvsVigenteAn1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomPagAcvsVigenteAn_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomPagAcvsVigenteAn1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TNomPagAcvsVigenteAn_9_2 as Table(NomPagAcvsVigenteAn2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomPagAcvsVigenteAn_9_2
		Select  (sum(isnull(tp.Pagado,0))) as NomPagAcvsVigenteAn2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id
		
		
		-------------NomEjerAcvsVigenteAn
		Declare @TNomEjerAcvsVigenteAn_9_1 as Table(NomEjerAcvsVigenteAn1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomEjerAcvsVigenteAn_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomEjerAcvsVigenteAn1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi	ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id
		
		Declare @TNomEjerAcvsVigenteAn_9_2 as Table(NomEjerAcvsVigenteAn2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TNomEjerAcvsVigenteAn_9_2
		Select  (sum(isnull(tp.Ejercido,0))) as NomEjerAcvsVigenteAn2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		----------------PorcPagAcvsVigenteAn
		Declare @TPorcPagAcvsVigenteAn_9_1 as Table(PorcPagAcvsVigenteAn1 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcPagAcvsVigenteAn_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPagAcvsVigenteAn1, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  Mes = 0 AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Declare @TPorcPagAcvsVigenteAn_9_2 as Table(PorcPagAcvsVigenteAn2 decimal(15,2), Clave int, Clave4  varchar(MAx), id Int)
		insert into @TPorcPagAcvsVigenteAn_9_2
		Select sum(isnull(tp.Pagado,0))  as PorcPagAcvsVigenteAn2, cr.CLAVE, cpi.clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.Id = cepr.Id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND Year=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.clave else @Clave2 end) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		group by cr.CLAVE, cpi.clave, cepr.id

		Select Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Tr.Clave4, Descripcion4, 
		Sum(Autorizado)Autorizado, sum(TransferenciaAmp)TransferenciaAmp, sum(TransferenciaRed)TransferenciaRed, 
		sum(Modificado)Modificado, Sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, sum(Comprometido)Comprometido, 
		Sum(PreCompSinComp)PreCompSinComp, SUM(PresDispComp)PresDispComp, sum(Devengado)Devengado, Sum(CompSinDev)CompSinDev, Sum(PresSinDev)PresSinDev, 
		sum(Ejercido)Ejercido, Sum(DevSinEjer)DevSinEjer, Sum(Pagado)Pagado, Sum(EjerSinPagar)EjerSinPagar, sum(Deuda)Deuda,
		cast(sum(case when isnull(PorcAprobAnual1,0) = 0 then 0 else isnull(PorcAprobAnual2,0) / isnull(PorcAprobAnual1,0) end) as decimal(15,2))PorcAprobAnual,
		cast(sum(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else isnull(PorcAprobadocAnt2,0) / isnull(PorcAprobadocAnt1,0) end) as decimal(15,2))PorcAprobadocAnt,
		sum(isnull(NomAprobado1,0) - isnull(NomAprobado2,0)) NomAprobado,
		cast(Sum(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else isnull(PorcPVigenteAnual2,0) / isnull(PorcPVigenteAnual1,0) end) as decimal(15,2))PorcPVigenteAnual,
		cast(Sum(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else isnull(PorcPVigenteAnt2,0) / isnull(PorcPVigenteAnt1,0) end) as decimal(15,2))PorcPVigenteAnt,
		sum(isnull(NomPVigente1,0) - isnull(NomPVigente2,0)) NomPVigente,
		cast(Sum(case when isnull(PorcCompvsVigente1,0) = 0 then 0 else isnull(PorcCompvsVigente2,0) / isnull(PorcCompvsVigente1,0) end) as decimal(15,2)) PorcCompvsVigente,
		sum(NomCompvsVigente)NomCompvsVigente,
		cast(sum(case when isnull(PorcDevvsVigente1,0) = 0 then 0 else isnull(PorcDevvsVigente2,0) / isnull(PorcDevvsVigente1,0) end) as decimal(15,2))PorcDevvsVigente,
		Sum(NomDevvsVigente)NomDevvsVigente,
		cast(Sum(case when isnull(PorcCompAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAc2,0) / isnull(PorcCompAcvsVigenteAc1,0) end) as decimal(15,2))PorcCompAcvsVigenteAc,
		sum(isnull(NomCompAcvsVigenteAc1,0))NomCompAcvsVigenteAc,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAc2,0) / isnull(PorcDevAcvsVigenteAc1,0) end) as decimal(15,2)) PorcDevAcvsVigenteAc,
		sum(isnull(NomDevAcvsVigenteAc1,0))NomDevAcvsVigenteAc,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAc2,0) / isnull(PorcEjerAcvsVigenteAc1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAc,
		sum(isnull(NomEjerAcvsVigenteAc1,0))NomEjerAcvsVigenteAc,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAc1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAc2,0) / isnull(PorcPagAcvsVigenteAc1,0) end) as decimal(15,2))PorcPagAcvsVigenteAc,
		sum(isnull(NomPagAcvsVigenteAc1,0))NomPagAcvsVigenteAc,
		cast(sum(case when isnull(PorcCompAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcCompAcvsVigenteAn2,0) / isnull(PorcCompAcvsVigenteAn1,0) end) as decimal(15,2))PorcCompAcvsVigenteAn,
		sum(isnull(NomCompAcvsVigenteAn1,0) - isnull(NomCompAcvsVigenteAn2,0))NomCompAcvsVigenteAn,
		cast(Sum(case when isnull(PorcDevAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcDevAcvsVigenteAn2,0) / isnull(PorcDevAcvsVigenteAn1,0) end) as decimal(15,2))PorcDevAcvsVigenteAn,
		Sum(isnull(NomDevAcvsVigenteAn1,0)- isnull(NomDevAcvsVigenteAn2,0)) NomDevAcvsVigenteAn,
		cast(Sum(case when isnull(PorcEjerAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcEjerAcvsVigenteAn2,0) / isnull(PorcEjerAcvsVigenteAn1,0) end) as decimal(15,2))PorcEjerAcvsVigenteAn,
		sum(isnull(NomEjerAcvsVigenteAn1,0) - isnull(NomEjerAcvsVigenteAn2,0))NomEjerAcvsVigenteAn,
		cast(Sum(case when isnull(PorcPagAcvsVigenteAn1,0) = 0 then 0 else isnull(PorcPagAcvsVigenteAn2,0) / isnull(PorcPagAcvsVigenteAn1,0) end) as decimal(15,2))PorcPagAcvsVigenteAn,
		sum(isnull(NomPagAcvsVigenteAn1,0) - isnull(NomPagAcvsVigenteAn2,0)) NomPagAcvsVigenteAn
		from @TResultadoFinal_9 as TR
		left outer join @TPorcAprobAnual_9_1		as T_1_1  on T_1_1.ID  = TR.ID and t_1_1.clave4  = Tr.Clave4 
		left outer join @TPorcAprobAnual_9_2		as T_1_2  on T_1_2.ID  = TR.ID and t_1_2.clave4  = Tr.Clave4 
		left outer join @TPorcAprobadocAnt_9_1		as T_2_1  on T_2_1.ID  = TR.ID and T_2_1.clave4  = Tr.Clave4
		left outer join @TPorcAprobadocAnt_9_2		as T_2_2  on T_2_2.ID  = TR.ID and T_2_2.clave4  = Tr.Clave4
		left outer join @TNomAprobado_9_1			as T_3_1  on T_3_1.ID  = TR.ID and T_3_1.clave4  = Tr.Clave4
		left outer join @TNomAprobado_9_2			as T_3_2  on T_3_2.ID  = TR.ID and T_3_2.clave4  = Tr.Clave4
		left outer join @TPorcPVigenteAnual_9_1		as T_4_1  on T_4_1.ID  = TR.ID and T_4_1.clave4  = Tr.Clave4
		left outer join @TPorcPVigenteAnual_9_2		as T_4_2  on T_4_2.ID  = TR.ID and T_4_2.clave4  = Tr.Clave4
		left outer join @TPorcPVigenteAnt_9_1		as T_5_1  on T_5_1.ID  = TR.ID and T_5_1.clave4  = Tr.Clave4
		left outer join @TPorcPVigenteAnt_9_2		as T_5_2  on T_5_2.ID  = TR.ID and T_5_2.clave4  = Tr.Clave4
		left outer join @TNomPVigente_9_1			as T_6_1  on T_6_1.ID  = TR.ID and T_6_1.clave4  = Tr.Clave4
		left outer join @TNomPVigente_9_2			as T_6_2  on T_6_2.ID  = TR.ID and T_6_2.clave4  = Tr.Clave4
		left outer join @TPorcCompvsVigente_9_1		as T_7_1  on T_7_1.ID  = TR.ID and T_7_1.clave4  = Tr.Clave4 
		left outer join @TPorcCompvsVigente_9_2		as T_7_2  on T_7_2.ID  = TR.ID and T_7_2.clave4  = Tr.Clave4
		left outer join @TPorcDevvsVigente_9_1		as T_8_1  on T_8_1.ID  = TR.ID and T_8_1.clave4  = Tr.Clave4
		left outer join @TPorcDevvsVigente_9_2		as T_8_2  on T_8_2.ID  = TR.ID and T_8_2.clave4  = Tr.Clave4
		left outer join @TPorcCompAcvsVigenteAc_9_1 as T_9_1  on T_9_1.ID  = TR.ID and T_9_1.clave4  = Tr.Clave4 
		left outer join @TPorcCompAcvsVigenteAc_9_2 as T_9_2  on T_9_2.ID  = TR.ID and T_9_2.clave4  = Tr.Clave4 
		left outer join @TNomCompAcvsVigenteAc_9_1	as T_10_1 on T_10_1.ID = TR.ID and T_10_1.clave4 = Tr.Clave2
		left outer join @TPorcDevAcvsVigenteAc_9_1	as T_11_1 on T_11_1.ID = TR.ID and T_11_1.clave4 = Tr.Clave4
		left outer join @TPorcDevAcvsVigenteAc_9_2	as T_11_2 on T_11_2.ID = TR.ID and T_11_2.clave4 = Tr.Clave4
		left outer join @TNomDevAcvsVigenteAc_9_1	as T_12_1 on T_12_1.ID = TR.ID and T_12_1.clave4 = Tr.Clave4
		left outer join @TPorcEjerAcvsVigenteAc_9_1 as T_13_1 on T_13_1.ID = TR.ID and T_13_1.clave4 = Tr.Clave4
		left outer join @TPorcEjerAcvsVigenteAc_9_2 as T_13_2 on T_13_2.ID = TR.ID and T_13_2.clave4 = Tr.Clave4
		left outer join @TNomEjerAcvsVigenteAc_9_1	as T_14_1 on T_14_1.ID = TR.ID and T_14_1.clave4 = Tr.Clave4
		left outer join @TPorcPagAcvsVigenteAc_9_1	as T_15_1 on T_15_1.ID = TR.ID and T_15_1.clave4 = Tr.Clave4
		left outer join @TPorcPagAcvsVigenteAc_9_2	as T_15_2 on T_15_2.ID = TR.ID and T_15_2.clave4 = Tr.Clave4
		left outer join @TNomPagAcvsVigenteAc_9_1	as T_16_1 on T_16_1.ID = TR.ID and T_16_1.clave4 = Tr.Clave4
		left outer join @TPorcCompAcvsVigenteAn_9_1 as T_17_1 on T_17_1.ID = TR.ID and T_17_1.clave4 = Tr.Clave4
		left outer join @TPorcCompAcvsVigenteAn_9_2 as T_17_2 on T_17_2.ID = TR.ID and T_17_2.clave4 = Tr.Clave4
		left outer join @TNomCompAcvsVigenteAn_9_1	as T_18_1 on T_18_1.ID = TR.ID and T_18_1.clave4 = Tr.Clave4 
		left outer join @TNomCompAcvsVigenteAn_9_2	as T_18_2 on T_18_2.ID = TR.ID and T_18_2.clave4 = Tr.Clave4 
		left outer join @TPorcDevAcvsVigenteAn_9_1	as T_19_1 on T_19_1.ID = TR.ID and T_19_1.clave4 = Tr.Clave4  
		left outer join @TPorcDevAcvsVigenteAn_9_2	as T_19_2 on T_19_2.ID = TR.ID and T_19_2.clave4 = Tr.Clave4   
		left outer join @TNomDevAcvsVigenteAn_9_1	as T_20_1 on T_20_1.ID = TR.ID and T_20_1.clave4 = Tr.Clave4  
		left outer join @TNomDevAcvsVigenteAn_9_2	as T_20_2 on T_20_2.ID = TR.ID and T_20_2.clave4 = Tr.Clave4  
		left outer join @TPorcEjerAcvsVigenteAn_9_1 as T_21_1 on T_21_1.ID = TR.ID and T_21_1.clave4 = Tr.Clave4
		left outer join @TPorcEjerAcvsVigenteAn_9_2 as T_21_2 on T_21_2.ID = TR.ID and T_21_2.clave4 = Tr.Clave4
		left outer join @TNomEjerAcvsVigenteAn_9_1	as T_22_1 on T_22_1.ID = TR.ID and T_22_1.clave4 = Tr.Clave4 
		left outer join @TNomEjerAcvsVigenteAn_9_2	as T_22_2 on T_22_2.ID = TR.ID and T_22_2.clave4 = Tr.Clave4  
		left outer join @TPorcPagAcvsVigenteAn_9_1	as T_23_1 on T_23_1.ID = TR.ID and T_23_1.clave4 = Tr.Clave4 
		left outer join @TPorcPagAcvsVigenteAn_9_2	as T_23_2 on T_23_2.ID = TR.ID and T_23_2.clave4 = Tr.Clave4 
		left outer join @TNomPagAcvsVigenteAn_9_1	as T_24_1 on T_24_1.ID = TR.ID and T_24_1.clave4 = Tr.Clave4
		left outer join @TNomPagAcvsVigenteAn_9_2	as T_24_2 on T_24_2.ID = TR.ID and T_24_2.clave4 = Tr.Clave4
		group by Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, tr.Clave4, Descripcion4
		order by Tr.Clave2, clave4
	END

END




GO



