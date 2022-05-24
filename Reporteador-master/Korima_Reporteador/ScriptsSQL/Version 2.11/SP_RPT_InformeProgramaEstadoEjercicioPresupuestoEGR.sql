
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
@Clave as varchar(25),
@Clave2 as varchar(25),
@ClaveUR as varchar(25),
@IdEP as varchar(25),
@Tipo as int


AS
BEGIN
	--Informes Programáticos del Estado del Estado del Ejercicio del Presupuesto de Egresos

	If @Tipo = 1 
	BEGIN
	-- Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional
	-- Valores Absolutos

		DECLARE @resultadoFinal as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Id varchar(25), Descripcion3 varchar(255), Clave4 varchar(25), NombreAI varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))

		INSERT INTO @resultadoFinal (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Id, Descripcion3, Clave4, NombreAI, 
		Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, 
		PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar,
		Deuda, PorcAprobAnual, PorcAprobadocAnt, NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)


		Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion,
		C_Funciones.Clave as Clave2,  C_Funciones.Nombre as Descripcion2, 
		C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Id, C_EP_Ramo.Nombre as Descripcion3,  
		(Select top 1 tablaID.Clave  FROM (Select * from C_EP_Ramo T1 where T1.id = C_EP_Ramo.Id and Nivel = 5) tablaID
		inner join
		(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as Clave4, 
		(SELECT top 1 tablaID.nombre FROM (select * from C_EP_Ramo T1 where T1.id = C_EP_Ramo.Id and Nivel = 5) tablaID
		inner join
		(select * from C_EP_Ramo T2 where  Nivel = 4) tablaAI ON tablaID.IdPadre = tablaAI.Id) as NombreAI,
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

		WHERE  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end) AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_RAMO.id else @IdEP end 

		GROUP BY C_RamoPresupuestal.CLAVE ,C_RamoPresupuestal.DESCRIPCION , C_EP_Ramo.Clave, C_EP_Ramo.ID, C_EP_Ramo.Nombre, C_Funciones.Clave, C_Funciones.Nombre 
		Order By C_RamoPresupuestal.CLAVE,C_Funciones.Clave



		--Columna 18
		declare @TPorcAprobAnual as Table(PAutorizado decimal(15,2), Clave int, ID int)
		insert into @TPorcAprobAnual 
		Select  sum(isnull(TP.Autorizado,0)),  C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id 

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

		where  Mes = 0 AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end 
		and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) 
		AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end 
		GROUP BY  C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id 

		--Columna 19
		declare @TPorcAprobadocAnt as Table(PAutorizadoAnt decimal(15,2), Clave int, ID int)
		insert into @TPorcAprobadocAnt 
		Select  sum(isnull(tp.Autorizado,0)), cr.CLAVE, cepr.Id 

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

		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY   cr.CLAVE, cepr.Id  

		--Columna 20
		declare @TNomAprobado1 as Table(NomAprobado1 decimal(15,2), Clave int, ID int)
		insert into @TNomAprobado1 

		Select (sum(isnull(tp.Autorizado,0)))NomAprobado1, cr.CLAVE, cepr.Id
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

		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		GROUP BY  cr.CLAVE, cepr.Id

		--Columna 21
		declare @TNomAprobado2 as Table(NomAprobado2 decimal(15,2), Clave Int, ID int)
		insert into @TNomAprobado2

		Select  sum(isnull(tp.Autorizado,0))NomAprobado2, cr.CLAVE, cepr.Id
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

		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		GROUP BY   cr.CLAVE, cepr.Id 

		--Columna 22 PorcPVigenteAnual
		declare @TPorcPVigenteAnual1 as Table(PorcPVigenteAnual1 decimal(15,2), Clave int, ID Int)
		insert into @TPorcPVigenteAnual1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) PorcPVigenteAnual, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
		INNER JOIN C_EP_Ramo cepr ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones 
		ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  LEFT JOIN C_Funciones CF
		ON CF.IdFuncion = C_SubFunciones.IdFuncion LEFT JOIN @resultadoFinal ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		GROUP BY   cr.CLAVE, cepr.Id

		Declare @TPorcPVigenteAnual2 as Table(PorcPVigenteAnual2 decimal(15,2), Clave Int, ID Int)
		Insert Into @TPorcPVigenteAnual2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion LEFT JOIN @resultadoFinal ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end  
		GROUP BY   cr.CLAVE, cepr.Id 

		--Columna 23 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt1 as Table(PorcPVigenteAnt1 decimal(15,2), Clave Int, ID int)
		insert into @TPorcPVigenteAnt1 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt, cr.CLAVE, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion LEFT JOIN @resultadoFinal ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY   cr.CLAVE, cepr.Id 

		Declare @TPorcPVigenteAnt2 as Table(PorcPVigenteAnt2 decimal(15,2), Clave Int, ID Int)
		Insert Into @TPorcPVigenteAnt2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion LEFT JOIN @resultadoFinal ON Clave1 = CR.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY   cr.CLAVE, cepr.Id 


		--Columna 24 y 25 NomPVigente

		Declare @TNomPVigente1 as Table(NomPVigente1  decimal(15,2), TClave1 Int, ID Int)
		insert into @TNomPVigente1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE as Clave1, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY   cr.CLAVE, cepr.Id

		--Declare @TNomPVigente2 as Table(NomPVigente2  decimal(15,2), TClave1 Int, TClave2 int, ID Int)
		Declare @TNomPVigente2 as Table(NomPVigente2  decimal(15,2), TClave1 Int, ID Int)
		insert into @TNomPVigente2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))), cr.Clave as Clave1, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY   cr.CLAVE, cepr.Id
		
		

		--Resultado de la consulta

		Select Clave1, Descripcion, Clave2, Descripcion2, Clave3, TresultadoFinal.id, Descripcion3, Clave4, NombreAI, Autorizado, TransferenciaAmp, TransferenciaRed, 
		Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev,
		Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, cast(CASE WHEN isnull(PAutorizado,0) = 0 THEN 0 ELSE (isnull(Autorizado,0))* 1/ PAutorizado END as Decimal(15,2)) PorcAprobAnual,
		cast(case when isnull(PAutorizadoAnt,0) = 0 then 0 else (isnull(Autorizado,0))* 1/ PAutorizadoAnt END as Decimal(15,2)) PorcAprobadocAnt, cast(isnull(TNomAprobado1.NomAprobado1,0) - isnull(TNomAprobado2.NomAprobado2,0) as Decimal(15,2)) as NomAprobado,
		cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0)*1)/ PorcPVigenteAnual1 end as Decimal(15,2)) PorcPVigenteAnual,
		cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0)*1)/ PorcPVigenteAnt1 end as Decimal(15,2)) PorcPVigenteAnt,
		cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2)) NomPVigente
		from @resultadoFinal as TresultadoFinal left outer join @TPorcAprobAnual as TPorcAprobAnual on TresultadoFinal.ID = TPorcAprobAnual.ID 
		left outer join @TPorcAprobadocAnt as TPorcAprobadocAnt on TPorcAprobadocAnt.ID = TresultadoFinal.Id 
		left outer join @TNomAprobado1 as TNomAprobado1 on TNomAprobado1.ID = TresultadoFinal.Id 
		left outer join @TNomAprobado2 as TNomAprobado2 on TNomAprobado2.ID = TresultadoFinal.Id 
		left outer join @TPorcPVigenteAnual1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.ID = TresultadoFinal.Id 
		left outer join @TPorcPVigenteAnual2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.ID = TresultadoFinal.Id
		left outer join @TPorcPVigenteAnt1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.ID = TresultadoFinal.Id 
		left outer join @TPorcPVigenteAnt2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.ID = TresultadoFinal.Id 
		left outer join @TNomPVigente1 as TNomPVigente1 on TNomPVigente1.ID = TresultadoFinal.ID 
		left outer join @TNomPVigente2 as TNomPVigente2 on TNomPVigente2.ID = TresultadoFinal.ID 
		order by Clave1, Clave2, Clave3, Clave4
	end

	If @Tipo = 2  
	BEGIN
	-- Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo
	-- Valores Absolutos

		DECLARE @TResultadoFinal_2 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Descripcion3 varchar(255), Clave3a varchar(25), Descripcion3a varchar(255), Clave4 varchar(25), Id varchar(25), Descripcion4 varchar(255), 
		Clave5 varchar(25), NombreAI varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), Modificado decimal(15,2), 
		PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), 
		Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2), Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), 
		EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2), PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2),
		PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2)) 

		INSERT INTO @TResultadoFinal_2 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Clave3a,	Descripcion3a,
		Clave4, Id,	Descripcion4, Clave5, NombreAI, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, 
		PresVigSinPreComp, Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, 
		Pagado, EjerSinPagar, Deuda, PorcAprobAnual, PorcAprobadocAnt, NomAprobado,	PorcPVigenteAnual, PorcPVigenteAnt,	NomPVigente )

		Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
		C_AreaResponsabilidad.Clave  as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2,
		C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3, 
		(SELECT tablaID.Clave  	FROM 
		(select * from C_EP_Ramo as C_EP_Ramo1 where C_EP_Ramo1.id =  C_EP_Ramo.Id  and Nivel = 5) tablaID
		inner join 	(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as Clave3a, 
		C_CapitulosNEP.Descripcion as Descripcion3a,
		C_CapitulosNEP.IdCapitulo as Clave4, C_EP_Ramo.Id, 
		C_ConceptosNEP.Descripcion as Descripcion4,  C_ConceptosNEP.IdConcepto  as Clave5, 
		(SELECT tablaID.nombre 	FROM
		(select * from C_EP_Ramo as C_EP_Ramo2 where C_EP_Ramo2.id =  C_EP_Ramo.Id and Nivel = 5) tablaID
		inner join
		(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as NombreAI,
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
		INNER JOIN C_EP_Ramo ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  
		= T_SellosPresupuestales.IdPartida INNER JOIN C_AreaResponsabilidad ON (C_AreaResponsabilidad.IdAreaResp = T_SellosPresupuestales.IdAreaResp) 
		AND (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP 
		ON  C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo 
		WHERE (Mes BETWEEN @Mes  and @Mes2 ) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE 
		else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) 
		AND C_AreaResponsabilidad.Clave = CASE WHEN @ClaveUR = '' THEN C_AreaResponsabilidad.Clave ELSE @ClaveUR END AND C_EP_Ramo.Id = case when @IdEP = '' 
		then C_EP_Ramo.id else @IdEP end
		Group by  C_CapitulosNEP.IdCapitulo, C_CapitulosNEP.Descripcion, C_ConceptosNEP.IdConcepto, C_ConceptosNEP.Descripcion, C_ConceptosNEP.IdCapitulo,C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre,C_EP_Ramo.Clave,C_EP_Ramo.Id, C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE,C_RamoPresupuestal.DESCRIPCION 
		Order by  C_AreaResponsabilidad.Clave  ,C_CapitulosNEP.IdCapitulo 

	--Columna 18
		declare @TPorcAprobAnual_2_1 as Table(PAutorizado1 decimal(15,2), Clave int, ID Int)
		insert into @TPorcAprobAnual_2_1
		Select  sum(isnull(TP.Autorizado,0))as PAutorizado, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto 
		INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = TS.IdPartida 	INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, cepr.Id

		declare @TPorcAprobAnual_2_2 as Table(PAutorizado2 decimal(15,2), Clave int, ID int)
		insert into @TPorcAprobAnual_2_2
		Select (sum(isnull(tp.Autorizado,0))) , cr.CLAVE, cepr.Id FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP
		ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
		INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = TS.IdPartida 
		INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave 
		end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP 
		end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, cepr.Id

	--Columna 19
		declare @TPorcAprobadocAnt_2_1 as table (PorcAprobadocAnt1 decimal(15,2), Clave Int, ID Int)
		insert into @TPorcAprobAnual_2_1 
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1,  cr.CLAVE, cepr.Id 
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = TS.IdPartida 
		INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo  
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, cepr.Id

		declare @TPorcAprobadocAnt_2_2 as table (PorcAprobadocAnt2 decimal(15,2), Clave Int, ID int)
		Insert Into @TPorcAprobadocAnt_2_2 
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = TS.IdPartida 
		INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, cepr.Id

		--Columna 20 y 21
		Declare @TNomAprobado_2_1 as table(NomAprobado1 decimal(15,2), Clave int, ID INT)
		insert into @TNomAprobado_2_1
		Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, cepr.id
		
		Declare @TNomAprobado_2_2 as table(NomAprobado2 decimal(15,2), Clave int, ID INT)
		insert into @TNomAprobado_2_2
		select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) 
		AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, cepr.id

		--Columna 22
		declare @TPorcPVigenteAnual_2_1 as Table(PorcPVigenteAnual1 Decimal(15,2), Clave int, ID Int)
		insert into @TPorcPVigenteAnual_2_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + 
		sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) AND 
		(CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn
		ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE,cepr.id

		declare @TPorcPVigenteAnual_2_2 as Table(PorcPVigenteAnual2 Decimal(15,2), Clave int, ID Int)
		insert into @TPorcPVigenteAnual_2_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) AND 
		(CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn
		ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, cepr.id
		
		--Columna 23
		Declare @TPorcPVigenteAnt_2_1 as Table(PorcPVigenteAnt1 Decimal(15,2), Clave Int, ID Int)
		insert into @TPorcPVigenteAnt_2_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) 
		AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, cepr.id

		Declare @TPorcPVigenteAnt_2_2 as Table(PorcPVigenteAnt2 Decimal(15,2), Clave Int, ID Int)
		insert into @TPorcPVigenteAnt_2_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, cepr.id
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) 
		AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, cepr.id
			
		--Columna 24 y 25
		declare @TNomPVigente_2_1 as Table(NomPVigente1 decimal(15,2), Clave int, ID int)
		insert into @TNomPVigente_2_1
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente1, cr.CLAVE,  cepr.Id 
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) 
		AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE,  cepr.Id
		
		declare @TNomPVigente_2_2 as Table(NomPVigente2 decimal(15,2), Clave int, ID int)
		insert into @TNomPVigente_2_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE,  cepr.Id 
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr 
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) 
		AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto
		INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinal_2 as T2 on T2.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.Id  else @IdEP end 
		and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, cepr.Id 
		
			
	-- Ejecucion de la tabla

		Select Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Clave3a, Descripcion3a, Clave4, Descripcion4, Clave5, 
		sum(Autorizado)Autorizado, sum(TransferenciaAmp)TransferenciaAmp, sum(TransferenciaRed)TransferenciaRed, Sum(Modificado)Modificado, 
		sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, sum(Comprometido)Comprometido, SUM(PreCompSinComp)PreCompSinComp, 
		Sum(PresDispComp)PresDispComp, sum(Devengado)Devengado, sum(CompSinDev)CompSinDev, sum(PresSinDev)PresSinDev, sum(Ejercido)Ejercido, 
		sum(DevSinEjer)DevSinEjer, sum(Pagado)Pagado, sum(EjerSinPagar)EjerSinPagar, sum(Deuda)Deuda, 
		avg(cast(CASE WHEN isnull(PAutorizado1,0) = 0 THEN 0 ELSE PAutorizado2/ PAutorizado1 END as Decimal(15,2))) PorcAprobAnual,
		avg(cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2))) PorcAprobadocAnt,
		sum(cast(isnull(TNomAprobado_2_1.NomAprobado1,0) - isnull(TNomAprobado_2_2.NomAprobado2,0) as Decimal(15,2))) as NomAprobado,
		avg(cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2))) PorcPVigenteAnual,
		Avg(cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2))) PorcPVigenteAnt,
		sum(cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2))) NomPVigente
		from @TResultadoFinal_2 as TResultadoFinal 
		left outer join @TPorcAprobAnual_2_1 as TPorcAprobAnual1 on TResultadoFinal.id = TPorcAprobAnual1.ID 
		left outer join @TPorcAprobAnual_2_2 as TPorcAprobAnual2 on TPorcAprobAnual2.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_2_1 as TPorcAprobadocAnt_2_1 on TPorcAprobadocAnt_2_1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_2_2 as TPorcAprobadocAnt_2_2 on TPorcAprobadocAnt_2_2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_2_1 as TNomAprobado_2_1 on TNomAprobado_2_1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_2_2 as TNomAprobado_2_2 on TNomAprobado_2_2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_2_1 as TPorcPVigenteAnual_2_1 on TPorcPVigenteAnual_2_1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_2_2 as TPorcPVigenteAnual_2_2 on TPorcPVigenteAnual_2_2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_2_1 as TPorcPVigenteAnt_2_1 on TPorcPVigenteAnt_2_1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_2_2 as TPorcPVigenteAnt_2_2 on TPorcPVigenteAnt_2_2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_2_1 as TNomPVigente_2_1 on TNomPVigente_2_1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_2_2 as TNomPVigente_2_2 on TNomPVigente_2_2.ID = TResultadoFinal.id
		group by Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Clave3a, Descripcion3a, Clave4, Descripcion4, Clave5
		order by clave1, clave2, clave3, clave3a, clave5	
		
		
	END

	If @Tipo = 3 
	BEGIN
		--Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica
		--Valores Absolutos

		DECLARE @TResultadoFinal_3 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255),
		Clave3 varchar(25), NombreAI varchar(255), Clave3a varchar(25), Descripcion3a varchar(255), Clave4 varchar(25), Descripcion4 varchar(255),
		Id varchar(25), Clave5 varchar(25), Descripcion3 varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), 
		Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), PreCompSinComp decimal(15,2), 
		PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2), Ejercido decimal(15,2), DevSinEjer decimal(15,2), 
		Pagado decimal(15,2), EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2), PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2),
		PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2)) 
		
		DECLARE @nombre1AI varchar(255)
		DECLARE @clave1AI varchar(255)
	                
		INSERT INTO @TResultadoFinal_3 (Clave1,	Descripcion, Clave2, Descripcion2, Clave3, NombreAI, Clave3a, Descripcion3a, Clave4, Descripcion4, Id,
		Clave5, Descripcion3, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido,
		PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual,
		PorcAprobadocAnt, NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente) 

		Select   C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, C_EP_Ramo.Clave AS Clave2, C_EP_Ramo.Nombre as Descripcion2, 
		(SELECT tablaID.Clave FROM
		(select * from C_EP_Ramo as T1 where id = C_EP_Ramo.id and Nivel = 5) tablaID
		inner join (select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as Clave3, 	
		(SELECT tablaID.nombre 	FROM
		(select * from C_EP_Ramo as T1 where T1.id = C_EP_Ramo.id and Nivel = 5) tablaID
		inner join 	(select * from C_EP_Ramo as T2 where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as NombreAI, 
		C_CapitulosNEP.IdCapitulo as Clave3a, C_CapitulosNEP.Descripcion as Descripcion3a, C_ConceptosNEP.IdConcepto  as Clave4,  C_ConceptosNEP.Descripcion as Descripcion4, 
		C_EP_Ramo.Id, C_TipoGasto.Clave as Clave5, C_TipoGasto.NOMBRE as Descripcion3, 
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_TipoGasto
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres 	ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
		INNER JOIN C_ConceptosNEP ON  C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo
		INNER JOIN C_EP_Ramo ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto 
		where  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE 
		else @Clave end  and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end )  
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
		
		Select Clave1,	Descripcion, Clave2, Descripcion2, Clave3, Clave3a, Descripcion3a, Clave4, Descripcion4, Clave5, Descripcion3, 
		Sum(Autorizado)Autorizado, sum(TransferenciaAmp)-abs(sum(TransferenciaRed))TransferenciaAmp, sum(TransferenciaRed)TransferenciaRed, Sum(Autorizado)+(sum(TransferenciaAmp)-abs(sum(TransferenciaRed))) Modificado, --Sum(Modificado)Modificado, 
		Sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, sum(Comprometido)Comprometido, SUM(PreCompSinComp)PreCompSinComp, 
		sum(PresDispComp)PresDispComp, sum(Devengado)Devengado, sum(CompSinDev)CompSinDev, sum(PresSinDev)PresSinDev, sum(Ejercido)Ejercido, 
		Sum(DevSinEjer)DevSinEjer, sum(Pagado)Pagado, 
		(Sum(Autorizado)+(sum(TransferenciaAmp)-abs(sum(TransferenciaRed))))- (sum(Devengado))EjerSinPagar, --sum(EjerSinPagar)EjerSinPagar, 
		sum(Deuda)Deuda,
		sum(cast(CASE WHEN isnull(PAutorizado1,0) = 0 THEN 0 ELSE PAutorizado2/ PAutorizado1 END as Decimal(15,2))) PorcAprobAnual,
		avg(cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2))) PorcAprobadocAnt,
		sum(cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2))) as NomAprobado,
		avg(cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2))) PorcPVigenteAnual,
		avg(cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2))) PorcPVigenteAnt,
		sum(cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2))) NomPVigente 
		from @TResultadoFinal_3 as TResultadoFinal 
		left outer join @TPorcAprobAnual_3_1 as TPorcAprobAnual1 on TResultadoFinal.id = TPorcAprobAnual1.ID 
		left outer join @TPorcAprobAnual_3_2 as TPorcAprobAnual2 on TPorcAprobAnual2.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_3_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_3_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_3_1 as TNomAprobado1 on TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_3_2 as TNomAprobado2 on TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_3_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_3_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_3_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_3_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_3_1 as TNomPVigente1 on TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_3_2 as TNomPVigente2 on TNomPVigente2.ID = TResultadoFinal.id
		group by Clave1,	Descripcion, Clave2, Descripcion2, Clave3, Clave3a, Descripcion3a, Clave4, Descripcion4, Clave5, Descripcion3
		order by cast(clave2 as int),cast(clave4 as int)
		
	END

	If @Tipo = 4 
	BEGIN
		--Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento
		--Valores Absolutos

		DECLARE @TResultadoFinal_4 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Descripcion3 varchar(255), Clave4 varchar(25), Id varchar(25), NombreAI varchar(255), Clave5 varchar(25), Descripcion4 varchar(255),
		Clave6 varchar(25), Descripcion5 varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), 
		Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), PreCompSinComp decimal(15,2), 
		PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2), Ejercido decimal(15,2), DevSinEjer decimal(15,2), 
		Pagado decimal(15,2), EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2), PorcAprobadocAnt decimal(15,2), 
		NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))

		INSERT INTO @TResultadoFinal_4 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Id, NombreAI, Clave5, Descripcion4, Clave6,
		Descripcion5, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, 
		PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual,	PorcAprobadocAnt,
		NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente )

		Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
		C_AreaResponsabilidad.Clave as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2 , 
		C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3, 
		(SELECT tablaID.Clave  
		FROM (select * from C_EP_Ramo as T1 where T1.id = C_EP_Ramo.ID and Nivel = 5) tablaID
		inner join 	(select * from C_EP_Ramo where  Nivel = 4) tablaAI 	ON tablaID.IdPadre = tablaAI.Id) as Clave4,
		C_EP_Ramo.Id, 
		/*(SELECT tablaID.nombre 	FROM
		(select * from C_EP_Ramo as T2 where T2.id =  C_EP_Ramo.ID and Nivel = 5) tablaID
		inner join 	(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id)*/ '' as NombreAI,
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad 
		ON C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
		where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE 
		else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end  ) 
		and C_AreaResponsabilidad.Clave  = CASE WHEN @ClaveUR = '' THEN C_AreaResponsabilidad.Clave ELSE @ClaveUR END 
		AND C_EP_Ramo.Id =  case when @IdEP = '' then C_EP_Ramo.id else @IdEP end 
		group by C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida , C_AreaResponsabilidad.Clave , 
		C_AreaResponsabilidad.Nombre, C_RamoPresupuestal.CLAVE , C_RamoPresupuestal.DESCRIPCION , C_FuenteFinanciamiento.CLAVE, 
		C_FuenteFinanciamiento.DESCRIPCION , C_EP_Ramo.Clave, C_EP_Ramo.Nombre, C_EP_Ramo.Id  
		Order By C_AreaResponsabilidad.Clave ,C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida,C_RamoPresupuestal.CLAVE 
		
		--Columna 1 PorcAprobAnual
		declare @TPorcAprobAnual_4_1 as Table (PorcAprobAnual1 decimal(15,2), Clave Int, Clave2 varchar(Max), ID int)
		insert into @TPorcAprobAnual_4_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, CA.Clave,  cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TresultadoFinal_4 t4 ON t4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= 
		case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, CA.Clave,  cepr.Id

		declare @TPorcAprobAnual_4_2 as Table (PorcAprobAnual2 decimal(15,2), Clave Int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobAnual_4_2
		Select sum(isnull(tp.Autorizado,0)) PorcAprobAnual2, cr.CLAVE, CA.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
		left join  @TresultadoFinal_4 t4 ON t4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end 
		and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, CA.Clave, cepr.Id  

		--Columna 2 PorcAprobadocAnt
		declare @TPorcAprobadocAnt_4_1 as Table (PorcAprobadocAnt1 decimal(15,2), Clave Int, ID varchar(Max))
		insert into @TPorcAprobadocAnt_4_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, ca.Clave
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TresultadoFinal_4 t4 ON t4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave   
		
		declare @TPorcAprobadocAnt_4_2 as Table (PorcAprobadocAnt2 decimal(15,2), Clave Int, ID varchar(Max))
		insert into @TPorcAprobadocAnt_4_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2, cr.CLAVE, ca.Clave 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 	
		left join  @TresultadoFinal_4 t4 ON t4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave

		--Columna 3 y 4 NomAprobado
		declare @TNomAprobado_4_1 as Table (NomAprobado1 Decimal(15,2), Clave Int, Clave2 varchar(max), ID Int)
		insert into @TNomAprobado_4_1
		Select (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, CA.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
		INNER JOIN C_PartidasGenericasPres ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
		INNER JOIN C_AreaResponsabilidad ca ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TresultadoFinal_4 t4 ON t4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id 
		
		declare @TNomAprobado_4_2 as Table (NomAprobado2 Decimal(15,2), Clave Int, Clave2 varchar(max), ID Int)
		insert into @TNomAprobado_4_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, CA.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TresultadoFinal_4 t4 ON t4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id 
		
		--Columna 5 PorcPVigenteAnual
		declare @TPorcPVigenteAnual_4_1 as Table (PorcPVigenteAnual1 Decimal(15,2), Clave Int, Clave2 varchar(max), ID Int)
		insert into @TPorcPVigenteAnual_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, CA.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento 
		ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
		left join  @TresultadoFinal_4 t4 ON t4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id

		declare @TPorcPVigenteAnual_4_2 as Table (PorcPVigenteAnual2 Decimal(15,2), Clave Int, Clave2 varchar(max), ID Int)
		insert into @TPorcPVigenteAnual_4_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, CA.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento 
		ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
		left join  @TresultadoFinal_4 t4 ON t4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id
		
		--Columna 6 PorcPVigenteAnt
		declare @TPorcPVigenteAnt_4_1 as Table (PorcPVigenteAnt1 Decimal(15,2), Clave Int, Clave2 Varchar(MAx), ID Int)
		insert into @TPorcPVigenteAnt_4_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, CA.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento 
		ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TresultadoFinal_4 t4 ON t4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id 

		declare @TPorcPVigenteAnt_4_2 as Table (PorcPVigenteAnt2 Decimal(15,2), Clave Int, Clave2 Varchar(MAx), ID Int)
		insert into @TPorcPVigenteAnt_4_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnt2, cr.CLAVE, CA.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TresultadoFinal_4 t4 ON t4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id 
		
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_4_1 as Table (NomPVigente1 Decimal(15,2), Clave Int, Clave2 varchar(MAx), ID Int)
		insert into @TNomPVigente_4_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, CA.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TresultadoFinal_4 t4 ON t4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id

		Declare @TNomPVigente_4_2 as Table (NomPVigente2 Decimal(15,2), Clave Int, Clave2 varchar(MAx), ID Int)
		insert into @TNomPVigente_4_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, CA.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TresultadoFinal_4 t4 ON t4.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id 
		
		Select Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Clave5, Descripcion4, Clave6, Descripcion5, 
		Sum(Autorizado)Autorizado, SUM(TransferenciaAmp)TransferenciaAmp, Sum(TransferenciaRed)TransferenciaRed, Sum(Modificado)Modificado, 
		Sum(PreComprometido)PreComprometido, Sum(PresVigSinPreComp)PresVigSinPreComp, Sum(Comprometido)Comprometido, Sum(PreCompSinComp)PreCompSinComp, 
		sum(PresDispComp)PresDispComp, Sum(Devengado)Devengado, Sum(CompSinDev)CompSinDev, Sum(PresSinDev)PresSinDev, Sum(Ejercido)Ejercido, 
		Sum(DevSinEjer)DevSinEjer, Sum(Pagado)Pagado, Sum(EjerSinPagar)EjerSinPagar, Sum(Deuda)Deuda,
		avg(cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2))) PorcAprobAnual,
		avg(cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2))) PorcAprobadocAnt,
		sum(cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2))) as NomAprobado,
		avg(cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2))) PorcPVigenteAnual,
		avg(cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2))) PorcPVigenteAnt,
		Sum(cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2))) NomPVigente 
		from @TResultadoFinal_4 as TResultadoFinal 
		left outer join @TPorcAprobAnual_4_1 as TPorcAprobAnual1 on TPorcAprobAnual1.clave2 = TResultadoFinal.clave2 and TPorcAprobAnual1.ID = TResultadoFinal.ID 
		left outer join @TPorcAprobAnual_4_2 as TPorcAprobAnual2 on TPorcAprobAnual2.Clave2 = TResultadoFinal.clave2 and TPorcAprobAnual2.ID = TResultadoFinal.ID
		left outer join @TPorcAprobadocAnt_4_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_4_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_4_1 as TNomAprobado1 on TNomAprobado1.clave2 = TResultadoFinal.clave2 and TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_4_2 as TNomAprobado2 on TNomAprobado2.clave2 = TResultadoFinal.clave2 and TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_4_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_4_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_4_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_4_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_4_1 as TNomPVigente1 on TNomPVigente1.clave2 = TResultadoFinal.clave2 and TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_4_2 as TNomPVigente2 on TNomPVigente2.clave2 = TResultadoFinal.clave2 and TNomPVigente2.ID = TResultadoFinal.id
		group by Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Clave5, Descripcion4, Clave6, Descripcion5
		
		
	END

	If @Tipo = 5 
	BEGIN	
		--Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Distribución Geográfica
		--Valores Absolutos

		DECLARE @TResultadoFinal_5 as table (Clave1 varchar(25), Descripcion varchar(255),	Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Descripcion3 varchar(255), Clave4 varchar(25), Id varchar(25), NombreAI varchar(255), Clave5 varchar(25), Descripcion4 varchar(255) , Clave6 varchar(25),
		Descripcion5 varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), Modificado decimal(15,2), 
		PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2),	Comprometido decimal(15,2), PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), 
		Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2), Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), 
		EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2), PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2),
		PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))

		INSERT INTO @TResultadoFinal_5 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Id, NombreAI, Clave5, Descripcion4,
		Clave6,	Descripcion5, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, 
		PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda,	PorcAprobAnual,
		PorcAprobadocAnt, NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)

		Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
		C_AreaResponsabilidad.Clave as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2 , 
		C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3,
		(SELECT tablaID.Clave  
		FROM (select * from C_EP_Ramo as T1 where T1.id = C_EP_Ramo.Id and Nivel = 5) tablaID
		inner join (select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as Clave4, 
		C_EP_Ramo.Id,  
		/*(SELECT tablaID.nombre 
		FROM (select * from C_EP_Ramo as T1 where T1.id = C_EP_Ramo.ID and Nivel = 5) tablaID
		inner join (select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) */''as NombreAI,
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
		INNER JOIN C_PartidasGenericasPres 	ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
		INNER JOIN C_AreaResponsabilidad ON (C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  
		and (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) INNER JOIN C_ClasificadorGeograficoPresupuestal  
		ON C_ClasificadorGeograficoPresupuestal.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto    
		INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
		where  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) AND C_AreaResponsabilidad.Clave  = CASE WHEN @ClaveUR = '' THEN C_AreaResponsabilidad.Clave ELSE @ClaveUR END  AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end    
		group by C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida , C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre, C_RamoPresupuestal.CLAVE , C_RamoPresupuestal.DESCRIPCION ,  C_EP_Ramo.Clave, C_EP_Ramo.Nombre, C_EP_Ramo.Id, C_ClasificadorGeograficoPresupuestal.Clave , C_ClasificadorGeograficoPresupuestal.Descripcion  
		Order By C_AreaResponsabilidad.Clave ,C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida,C_RamoPresupuestal.CLAVE 

		--Columna 1 PorcAprobAnual
		declare @TPorcAprobAnual_5_1 as Table (PorcAprobAnual1  decimal(15,2), Clave Int, Clave2 Varchar(MAx), ID int)
		insert into @TPorcAprobAnual_5_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinal_5 T5 on T5.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id

		declare @TPorcAprobAnual_5_2 as Table (PorcAprobAnual2  decimal(15,2), Clave Int, Clave2 Varchar(MAx), ID int)
		insert into @TPorcAprobAnual_5_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinal_5 T5 on T5.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END 
		group by cr.CLAVE, ca.Clave, cepr.Id

		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_5_1 as Table (PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobadocAnt_5_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg	ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinal_5 T5 on T5.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id 
		
		Declare @TPorcAprobadocAnt_5_2 as Table (PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobadocAnt_5_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca 
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg 	ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinal_5 T5 on T5.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id  

	--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_5_1 as Table (NomAprobado1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TNomAprobado_5_1
		Select (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinal_5 T5 on T5.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id
		
		Declare @TNomAprobado_5_2 as Table (NomAprobado2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TNomAprobado_5_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca 
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinal_5 T5 on T5.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id
		
		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_5_1 as Table (PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnual_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinal_5 T5 on T5.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id 

		Declare @TPorcPVigenteAnual_5_2 as Table (PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnual_5_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, ca.Clave, cepr.Id  
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg	ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr 	ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinal_5 T5 on T5.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id

		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_5_1 as Table (PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnt_5_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinal_5 T5 on T5.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id 

		Declare @TPorcPVigenteAnt_5_2 as Table (PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnt_5_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, ca.Clave, cepr.Id  
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg	ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinal_5 T5 on T5.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id
					
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_5_1 as Table (NomPVigente1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TNomPVigente_5_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca 
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr 	ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinal_5 T5 on T5.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id
		
		Declare @TNomPVigente_5_2 as Table (NomPVigente2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TNomPVigente_5_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as NomPVigente2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg  ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr 	ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinal_5 T5 on T5.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END END
		group by cr.CLAVE, ca.Clave, cepr.Id
		
		Select Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Descripcion3, Clave4,  NombreAI, Clave5, Descripcion4,
		Clave6,	Descripcion5, Sum(Autorizado)Autorizado, Sum(TransferenciaAmp)TransferenciaAmp, Sum(TransferenciaRed)TransferenciaRed, 
		Sum(Modificado)Modificado, Sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, Sum(Comprometido)Comprometido, 
		sum(PreCompSinComp)PreCompSinComp, Sum(PresDispComp)PresDispComp, Sum(Devengado)Devengado, Sum(CompSinDev)CompSinDev, Sum(PresSinDev)PresSinDev, 
		Sum(Ejercido)Ejercido, Sum(DevSinEjer)DevSinEjer, Sum(Pagado)Pagado, Sum(EjerSinPagar)EjerSinPagar, Sum(Deuda)Deuda,
		avg(cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2))) PorcAprobAnual,
		avg(cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2))) PorcAprobadocAnt,
		sum(cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2))) as NomAprobado,
		avg(cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2))) PorcPVigenteAnual,
		avg(cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2))) PorcPVigenteAnt,
		sum(cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2))) NomPVigente 
		from @TResultadoFinal_5 as TResultadoFinal 
		left outer join @TPorcAprobAnual_5_1 as TPorcAprobAnual1 on TPorcAprobAnual1.clave2 = TResultadoFinal.clave2 and TPorcAprobAnual1.ID = TResultadoFinal.ID 
		left outer join @TPorcAprobAnual_5_2 as TPorcAprobAnual2 on TPorcAprobAnual2.Clave2 = TResultadoFinal.clave2 and TPorcAprobAnual2.ID = TResultadoFinal.ID
		left outer join @TPorcAprobadocAnt_5_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.clave2 = TResultadoFinal.clave2 and TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_5_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.clave2 = TResultadoFinal.clave2 and TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_5_1 as TNomAprobado1 on TNomAprobado1.clave2 = TResultadoFinal.clave2 and TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_5_2 as TNomAprobado2 on TNomAprobado2.clave2 = TResultadoFinal.clave2 and TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_5_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_5_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_5_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_5_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_5_1 as TNomPVigente1 on TNomPVigente1.clave2 = TResultadoFinal.clave2 and TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_5_2 as TNomPVigente2 on TNomPVigente2.clave2 = TResultadoFinal.clave2 and TNomPVigente2.ID = TResultadoFinal.id
		group by Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Descripcion3, Clave4,  NombreAI, Clave5,Descripcion4,
		Clave6,	Descripcion5
		ORDER BY CLAVE1, clave2, clave3, Clave5
		
		
	END

	If @Tipo = 6 
	BEGIN
		--Ramo o Dependencia / Función / Programas y Proyectos de Inversión
		--Valores Absolutos

		DECLARE @TResultadoFinal_6 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Id varchar(25), Descripcion3 varchar(255), Clave4 varchar(max), Descripcion4 varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
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
		where   (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE 
		else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) 
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
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= 
		case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id

		Select Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, TResultadoFinal.Id, Descripcion4,
		Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, 
		PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda,
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
		 

	END

	If @Tipo = 7 
	BEGIN
		--Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasificación Económica
		--Valores Absolutos

		DECLARE @TResultadoFinal_7 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Descripcion3 varchar(255), Id varchar(25), Clave4 varchar(max), Descripcion4 varchar(255), Clave4a varchar(25), Descripcion4a varchar(255),
		Clave5 varchar(25), Descripcion5 varchar(255), Clave6 varchar(25), Descripcion6 varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2),	PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))

		INSERT INTO @TResultadoFinal_7 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Id, Clave4, Descripcion4, Clave4a, Descripcion4a,
		Clave5,	Descripcion5, Clave6, Descripcion6, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp,
		Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual,
		PorcAprobadocAnt, NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)

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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo 
		ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad ON (C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (C_AreaResponsabilidad.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) 	INNER JOIN C_TipoGasto 
		ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   
		INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP 
		ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo   	
		WHERE  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) AND C_AreaResponsabilidad.Clave = CASE WHEN @ClaveUR = '' THEN C_AreaResponsabilidad.Clave ELSE @ClaveUR END  AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		Group by  C_CapitulosNEP.IdCapitulo, C_CapitulosNEP.Descripcion, C_ConceptosNEP.IdConcepto, C_ConceptosNEP.Descripcion, C_ConceptosNEP.IdCapitulo,C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre,C_EP_Ramo.Clave,C_EP_Ramo.Id, C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE,C_RamoPresupuestal.DESCRIPCION,C_TipoGasto.Clave, C_TipoGasto.nombre, C_ProyectosInversion.CLAVE, C_ProyectosInversion.NOMBRE   
		Order by  C_AreaResponsabilidad.Clave  ,C_CapitulosNEP.IdCapitulo 

		--Columna 1 PorcAprobAnual
		DECLARE @TPorcAprobAnual_7_1 as Table (PorcAprobAnual1 decimal(15,2), Clave int, Clave2 varchar(Max), ID int)
		insert into @TPorcAprobAnual_7_1 
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE , ca.Clave, cepr.ID 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = @ClaveUR
		group by cr.CLAVE , ca.Clave, cepr.ID 

		DECLARE @TPorcAprobAnual_7_2 as Table (PorcAprobAnual2 decimal(15,2), Clave int, Clave2 varchar(Max), ID int)
		insert into @TPorcAprobAnual_7_2 
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, cr.CLAVE , ca.Clave, cepr.ID 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg 	ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.ID
		
		--Columna 2 PorcAprobadocAnt
		DECLARE @TPorcAprobadocAnt_7_1 as Table (PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 varchar(Max), ID int)
		insert into @TPorcAprobadocAnt_7_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE , ca.Clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.ID

		DECLARE @TPorcAprobadocAnt_7_2 as Table (PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 varchar(Max), ID int)
		insert into @TPorcAprobadocAnt_7_2
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.ID
		
		--Columna 3 y 4 NomAprobado
		DECLARE @TNomAprobado_7_1 as Table (NomAprobado1 decimal(15,2), Clave int, Clave2 varchar(Max), ID int)
		insert into @TNomAprobado_7_1
		Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.ID 
		
		DECLARE @TNomAprobado_7_2 as Table (NomAprobado2 decimal(15,2), Clave int, Clave2 varchar(Max), ID int)
		insert into @TNomAprobado_7_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.ID   
		
		--Columna 5 PorcPVigenteAnual
		DECLARE @TPorcPVigenteAnual_7_1 as Table (PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 varchar(Max), ID int)
		insert into @TPorcPVigenteAnual_7_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg	ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.ID 


		DECLARE @TPorcPVigenteAnual_7_2 as Table (PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 varchar(Max), ID int)
		insert into @TPorcPVigenteAnual_7_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnual2, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA	ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.ID
		
		--Columna 6 PorcPVigenteAnt 
		DECLARE @TPorcPVigenteAnt_7_1 as Table (PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 varchar(Max), ID int)
		insert into @TPorcPVigenteAnt_7_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.ID

		DECLARE @TPorcPVigenteAnt_7_2 as Table (PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 varchar(Max), ID int)
		insert into @TPorcPVigenteAnt_7_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.ID
		
		--Columna 7 y 8 NomPVigente
		DECLARE @TNomPVigente_7_1 as Table (NomPVigente1 decimal(15,2), Clave int, Clave2 varchar(Max), ID int)
		insert into @TNomPVigente_7_1
		Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA	ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.ID 
		
		DECLARE @TNomPVigente_7_2 as Table (NomPVigente2 decimal(15,2), Clave int, Clave2 varchar(Max), ID int)
		insert into @TNomPVigente_7_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinal_7 as T7 ON T7.id = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.ID

		Select Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Descripcion3, TResultadoFinal.Id, Clave4, Descripcion4, Clave4a, Descripcion4a,
		Clave5,	Descripcion5, Clave6, Descripcion6, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp,
		Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda,
		cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2)) PorcAprobAnual,
		cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2)) PorcAprobadocAnt,
		cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2)) as NomAprobado,
		cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2)) PorcPVigenteAnual,
		cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2)) PorcPVigenteAnt,
		cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2)) NomPVigente 
		from @TResultadoFinal_7 as TResultadoFinal 
		left outer join @TPorcAprobAnual_7_1 as TPorcAprobAnual1 on TPorcAprobAnual1.clave2 = TResultadoFinal.clave2 and TPorcAprobAnual1.ID = TResultadoFinal.ID 
		left outer join @TPorcAprobAnual_7_2 as TPorcAprobAnual2 on TPorcAprobAnual2.Clave2 = TResultadoFinal.clave2 and TPorcAprobAnual2.ID = TResultadoFinal.ID
		left outer join @TPorcAprobadocAnt_7_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.clave2 = TResultadoFinal.clave2 and TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_7_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.clave2 = TResultadoFinal.clave2 and TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_7_1 as TNomAprobado1 on TNomAprobado1.clave2 = TResultadoFinal.clave2 and TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_7_2 as TNomAprobado2 on TNomAprobado2.clave2 = TResultadoFinal.clave2 and TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_7_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_7_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_7_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_7_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_7_1 as TNomPVigente1 on TNomPVigente1.clave2 = TResultadoFinal.clave2 and TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_7_2 as TNomPVigente2 on TNomPVigente2.clave2 = TResultadoFinal.clave2 and TNomPVigente2.ID = TResultadoFinal.id

	END

	If @Tipo = 8 
	BEGIN
		--Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento
		--Valores Absolutos

		DECLARE @TResultadoFinal_8 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Descripcion3 varchar(255), Clave4 varchar(MAx), Descripcion4 varchar(255), Clave5 varchar(25), Id varchar(25), Descripcion5 varchar(255),
		Clave6 varchar(25), Descripcion6 varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), 
		Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), PreCompSinComp decimal(15,2), 
		PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2), Ejercido decimal(15,2), 
		DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))

		INSERT INTO @TResultadoFinal_8 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Descripcion4, Clave5, Id, Descripcion5,
		Clave6,	Descripcion6, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, 
		PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual, PorcAprobadocAnt,
		NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)

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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad 
		ON (C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (C_AreaResponsabilidad.IdRamoPresupuestal = 
		C_RamoPresupuestal.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO  =
		T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo ON C_EP_Ramo.Id = T_SellosPresupuestales.IdProyecto 
		INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto    		
		where  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) and C_AreaResponsabilidad.Clave = CASE WHEN @ClaveUR = '' THEN C_AreaResponsabilidad.Clave ELSE @ClaveUR END AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		group by C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida , C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre, C_RamoPresupuestal.CLAVE , C_RamoPresupuestal.DESCRIPCION ,  C_EP_Ramo.Clave, C_EP_Ramo.Nombre, C_EP_Ramo.Id, C_FuenteFinanciamiento.CLAVE, C_FuenteFinanciamiento.DESCRIPCION ,C_ProyectosInversion.nombre, C_ProyectosInversion.CLAVE  
		Order By C_AreaResponsabilidad.Clave ,C_PartidasGenericasPres.IdPartidaGenerica , C_RamoPresupuestal.CLAVE 

		--Columna 1 PorcAprobAnual
		Declare @TPorcAprobAnual_8_1 as Table (PorcAprobAnual1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		Insert Into @TPorcAprobAnual_8_1 
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, ca.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id 

		Declare @TPorcAprobAnual_8_2 as Table (PorcAprobAnual2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		Insert Into @TPorcAprobAnual_8_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff 	ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id
		
		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_8_1 as Table (PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		Insert Into @TPorcAprobadocAnt_8_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, ca.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id  

		Declare @TPorcAprobadocAnt_8_2 as Table (PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		Insert Into @TPorcAprobadocAnt_8_2
		Select sum(isnull(tp.Autorizado,0))  as PorcAprobadocAnt1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id
		
		--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_8_1 as Table (NomAprobado1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		Insert Into @TNomAprobado_8_1
		Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg 
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id
		
		Declare @TNomAprobado_8_2 as Table (NomAprobado2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		Insert Into @TNomAprobado_8_2 
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id
		
		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_8_1 as Table (PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		Insert Into @TPorcPVigenteAnual_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA 
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento 	INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id

		Declare @TPorcPVigenteAnual_8_2 as Table (PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		Insert Into @TPorcPVigenteAnual_8_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg 
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA 
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id
		
		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_8_1 as Table (PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		Insert Into @TPorcPVigenteAnt_8_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id

		Declare @TPorcPVigenteAnt_8_2 as Table (PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		Insert Into @TPorcPVigenteAnt_8_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 	INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id
		
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_8_1 as Table (NomPVigente1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		Insert Into @TNomPVigente_8_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id
		
		Declare @TNomPVigente_8_2 as Table (NomPVigente2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		Insert Into @TNomPVigente_8_2 
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinal_8 as T8 ON T8.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id
		
		Select Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Descripcion4, Clave5, TResultadoFinal.Id, Descripcion5,
		Clave6,	Descripcion6, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, 
		PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda,
		cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2)) PorcAprobAnual,
		cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2)) PorcAprobadocAnt,
		cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2)) as NomAprobado,
		cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2)) PorcPVigenteAnual,
		cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2)) PorcPVigenteAnt,
		cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2)) NomPVigente 
		from @TResultadoFinal_8 as TResultadoFinal 
		left outer join @TPorcAprobAnual_8_1 as TPorcAprobAnual1 on TPorcAprobAnual1.clave2 = TResultadoFinal.clave2 and TPorcAprobAnual1.ID = TResultadoFinal.ID 
		left outer join @TPorcAprobAnual_8_2 as TPorcAprobAnual2 on TPorcAprobAnual2.Clave2 = TResultadoFinal.clave2 and TPorcAprobAnual2.ID = TResultadoFinal.ID
		left outer join @TPorcAprobadocAnt_8_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.clave2 = TResultadoFinal.clave2 and TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_8_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.clave2 = TResultadoFinal.clave2 and TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_8_1 as TNomAprobado1 on TNomAprobado1.clave2 = TResultadoFinal.clave2 and TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_8_2 as TNomAprobado2 on TNomAprobado2.clave2 = TResultadoFinal.clave2 and TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_8_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_8_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_8_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_8_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_8_1 as TNomPVigente1 on TNomPVigente1.clave2 = TResultadoFinal.clave2 and TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_8_2 as TNomPVigente2 on TNomPVigente2.clave2 = TResultadoFinal.clave2 and TNomPVigente2.ID = TResultadoFinal.id
		

	END

	If @Tipo = 9
	BEGIN
		--Ramo o Dependencia / Distribución Geográfica / Programas y Proyectos de Inversión
		--Valores Absolutos

		DECLARE @TResultadoFinal_9 as table (Clave1 varchar(25),	Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255),	Clave3 varchar(25),
		Id varchar(25), Descripcion3 varchar(255), Clave4 varchar(MAx), Descripcion4 varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))

		INSERT INTO @TResultadoFinal_9 (Clave1,	Descripcion, Clave2, Descripcion2, Clave3, Id, Descripcion3, Clave4, Descripcion4, Autorizado, TransferenciaAmp, 
		TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev,
		Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual, PorcAprobadocAnt, NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)

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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo 
		ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal  
		ON C_ClasificadorGeograficoPresupuestal.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		--where  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		group by C_ClasificadorGeograficoPresupuestal.Clave,C_ClasificadorGeograficoPresupuestal.Descripcion, C_RamoPresupuestal.CLAVE, C_RamoPresupuestal.DESCRIPCION ,C_EP_Ramo.Clave , C_EP_Ramo.Nombre, C_EP_Ramo.Id ,T_SellosPresupuestales.IdProyecto, C_ProyectosInversion.CLAVE ,C_ProyectosInversion.nombre 
		Order By C_ClasificadorGeograficoPresupuestal.Clave

		--Columna 1 PorcAprobAnual
		Declare @TPorcAprobAnual_9_1 as Table(PorcAprobAnual1 decimal(15,2), Clave int, Clave4 varchar(Max), ID int)
		insert into @TPorcAprobAnual_9_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, cpi.clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cpi.clave, cepr.Id    

		Declare @TPorcAprobAnual_9_2 as Table(PorcAprobAnual2 decimal(15,2), Clave int, Clave4 varchar(Max), ID int)
		insert into @TPorcAprobAnual_9_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, cpi.clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		--group by cr.CLAVE, cepr.Clave ,cpi.clave
		group by cr.CLAVE, cpi.clave, cepr.Id
		
		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_9_1 as Table(PorcAprobadocAnt1 decimal(15,2), Clave int, Clave4 varchar(Max), ID int)
		insert into @TPorcAprobadocAnt_9_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, cpi.clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi
		ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
		left JOIN C_ClasificadorGeograficoPresupuestal cgp ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cpi.clave, cepr.Id 
		
		Declare @TPorcAprobadocAnt_9_2 as Table(PorcAprobadocAnt2 decimal(15,2), Clave int, Clave4 varchar(Max), ID int)
		insert into @TPorcAprobadocAnt_9_2
		Select  sum(isnull(tp.Autorizado,0))  as PorcAprobadocAnt1, cr.CLAVE, cpi.clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cpi.clave, cepr.Id
		
		--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_9_1 as Table(NomAprobado1 decimal(15,2), Clave int, Clave4 varchar(Max), ID int)
		insert into @TNomAprobado_9_1
		Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, cpi.clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  	
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by  cr.CLAVE, cpi.clave, cepr.Id
		
		Declare @TNomAprobado_9_2 as Table(NomAprobado2 decimal(15,2), Clave int, Clave4 varchar(Max), ID int)
		insert into @TNomAprobado_9_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, cpi.clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cpi.clave, cepr.Id
		
		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_9_1 as Table(PorcPVigenteAnual1 decimal(15,2), Clave int, Clave4 varchar(Max), ID int)
		insert into @TPorcPVigenteAnual_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, cpi.clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
		left JOIN C_ClasificadorGeograficoPresupuestal cgp 	ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cpi.clave, cepr.Id

		Declare @TPorcPVigenteAnual_9_2 as Table(PorcPVigenteAnual2 decimal(15,2), Clave int, Clave4 varchar(Max), ID int)
		insert into @TPorcPVigenteAnual_9_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, cpi.clave, cepr.Id  
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cpi.clave, cepr.Id
		
		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_9_1 as Table(PorcPVigenteAnt1 decimal(15,2), Clave int, Clave4 varchar(Max), ID int)
		insert into @TPorcPVigenteAnt_9_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, cpi.clave, cepr.Id  
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi
		ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
		left JOIN C_ClasificadorGeograficoPresupuestal cgp ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cpi.clave, cepr.Id

		Declare @TPorcPVigenteAnt_9_2 as Table(PorcPVigenteAnt2 decimal(15,2), Clave int, Clave4 varchar(Max), ID int)
		insert into @TPorcPVigenteAnt_9_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, cpi.clave, cepr.Id  
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cpi.clave, cepr.Id
		
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_9_1 as Table(NomPVigente1 decimal(15,2), Clave int, Clave4 varchar(Max), ID int)
		insert into @TNomPVigente_9_1
		Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))))  as NomPVigente1, cr.CLAVE, cpi.clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  
		left JOIN C_ClasificadorGeograficoPresupuestal cgp 	ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cpi.clave, cepr.Id
		
		Declare @TNomPVigente_9_2 as Table(NomPVigente2 decimal(15,2), Clave int, Clave4 varchar(Max), ID int)
		insert into @TNomPVigente_9_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, cpi.clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ProyectosInversion cpi 	ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  	
		LEFT JOIN @TResultadoFinal_9 as T9 ON T9.ID = cepr.ID and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cpi.clave, cepr.Id
			

		Select Clave1,	Descripcion, Clave2, Descripcion2, Clave3, TResultadoFinal.Id, Descripcion3, TResultadoFinal.Clave4, Descripcion4, Autorizado, 
		TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, 
		PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda,
		cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2)) PorcAprobAnual,
		cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2)) PorcAprobadocAnt,
		cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2)) as NomAprobado,
		cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2)) PorcPVigenteAnual,
		cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2)) PorcPVigenteAnt,
		cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2)) NomPVigente 
		from @TResultadoFinal_9 as TResultadoFinal 
		left outer join @TPorcAprobAnual_9_1 as TPorcAprobAnual1 on TPorcAprobAnual1.clave4 = TResultadoFinal.clave4 and TPorcAprobAnual1.ID = TResultadoFinal.ID 
		left outer join @TPorcAprobAnual_9_2 as TPorcAprobAnual2 on TPorcAprobAnual2.Clave4 = TResultadoFinal.clave4 and TPorcAprobAnual2.ID = TResultadoFinal.ID
		left outer join @TPorcAprobadocAnt_9_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.clave4 = TResultadoFinal.clave4 and TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_9_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.clave4 = TResultadoFinal.clave4 and TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_9_1 as TNomAprobado1 on TNomAprobado1.clave4 = TResultadoFinal.clave4 and TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_9_2 as TNomAprobado2 on TNomAprobado2.clave4 = TResultadoFinal.clave4 and TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_9_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.clave4 = TResultadoFinal.clave4 and TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_9_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.clave4 = TResultadoFinal.clave4 and TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_9_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.clave4 = TResultadoFinal.clave4 and TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_9_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.clave4 = TResultadoFinal.clave4 and TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_9_1 as TNomPVigente1 on TNomPVigente1.clave4 = TResultadoFinal.clave4 and TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_9_2 as TNomPVigente2 on TNomPVigente2.clave4 = TResultadoFinal.clave4 and TNomPVigente2.ID = TResultadoFinal.id
		 
	END

	--////////******************************VALORES RELATIVOS*************************************//////////////

	If @Tipo = 10 
	BEGIN
		-- Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional
		-- Valores Relativos

		DECLARE @TResultadoFinalR_10 as table (Clave1 varchar(25), Descripcion varchar(255),	Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Id varchar(25), Descripcion3 varchar(255), Clave4 varchar(25), NombreAI varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2),	Deuda decimal(15,2), PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2),	PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))

		INSERT INTO @TResultadoFinalR_10 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Id, Descripcion3, Clave4, NombreAI, Autorizado, TransferenciaAmp, 
		TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev,	
		Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual, PorcAprobadocAnt, NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)

		Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion,
		C_Funciones.Clave as Clave2,  C_Funciones.Nombre as Descripcion2, 
		C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Id, C_EP_Ramo.Nombre as Descripcion3,  
		(SELECT tablaID.Clave  FROM
		(select * from C_EP_Ramo as R10 where R10.id = C_EP_Ramo.ID and Nivel = 5) tablaID
		inner join	(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as Clave4, 
		(SELECT tablaID.nombre FROM
		(select * from C_EP_Ramo as R10 where R10.Id = C_EP_Ramo.id and Nivel = 5) tablaID
		inner join 	(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as NombreAI,
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
		INNER JOIN C_EP_Ramo ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones 
		ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  LEFT JOIN C_Funciones ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion  
		WHERE  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		GROUP BY C_RamoPresupuestal.CLAVE ,C_RamoPresupuestal.DESCRIPCION , C_EP_Ramo.Clave, C_EP_Ramo.ID, C_EP_Ramo.Nombre, C_Funciones.Clave, C_Funciones.Nombre 
		Order By C_RamoPresupuestal.CLAVE,C_Funciones.Clave

		--Columna 18 PorcAprobAnual
		Declare @TPorcAprobAnual_10_1 as table(PorcAprobAnual1 decimal(15,2), Clave int, ID int)
		insert into @TPorcAprobAnual_10_1
		Select  sum(isnull(TP.Autorizado,0))as PorcAprobAnual1,  C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo
		ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion  
		LEFT JOIN @TResultadoFinalR_10 T10 ON T10.id = c_EP_Ramo.id and T10.Clave1 = C_RamoPresupuestal.CLAVE and Clave2 = C_Funciones.Clave 
		where  Mes = 0 AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		GROUP BY  C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id 

		Declare @TPorcAprobAnual_10_2 as table(PorcAprobAnual2 decimal(15,2), Clave int, ID int)
		insert into @TPorcAprobAnual_10_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo
		ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinalR_10 T10 ON T10.id = c_EP_Ramo.id and T10.Clave1 = C_RamoPresupuestal.CLAVE and Clave2 = C_Funciones.Clave 
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		GROUP BY   C_RamoPresupuestal.CLAVE, C_EP_Ramo.Id
		
		--Columna 19 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_10_1 as table(PorcAprobadocAnt1 decimal(15,2), Clave int, ID int)
		insert into @TPorcAprobadocAnt_10_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinalR_10 as T10 ON T10.ID = cepr.id and  Clave1 = CR.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY cr.CLAVE, cepr.Id  

		Declare @TPorcAprobadocAnt_10_2 as table(PorcAprobadocAnt2 decimal(15,2), Clave int, ID int)
		insert into @TPorcAprobadocAnt_10_2
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinalR_10 as T10 ON T10.ID = cepr.id and  Clave1 = CR.CLAVE and Clave2 = CF.Clave  
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY   cr.CLAVE, cepr.Id
		
		--Columna 20 y 21 NomAprobado
		Declare @TNomAprobado_10_1 as table(NomAprobado1 decimal(15,2), Clave int, ID int)
		insert into @TNomAprobado_10_1
		Select (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinalR_10 as T10 ON T10.ID = cepr.id and  Clave1 = CR.CLAVE and Clave2 = CF.Clave  
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY  cr.CLAVE, cepr.Id
		
		Declare @TNomAprobado_10_2 as table(NomAprobado2 decimal(15,2), Clave int, ID int)
		insert into @TNomAprobado_10_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinalR_10 as T10 ON T10.ID = cepr.id and  Clave1 = CR.CLAVE and Clave2 = CF.Clave 
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY   cr.CLAVE, cepr.Id
		
		--Columna 22 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_10_1 as table(PorcPVigenteAnual1 decimal(15,2), Clave int, ID int)
		insert into @TPorcPVigenteAnual_10_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinalR_10 as T10 ON T10.ID = cepr.id and  Clave1 = CR.CLAVE and Clave2 = CF.Clave
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY   cr.CLAVE, cepr.Id 

		Declare @TPorcPVigenteAnual_10_2 as table(PorcPVigenteAnual2 decimal(15,2), Clave int, ID int)
		insert into @TPorcPVigenteAnual_10_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnual2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinalR_10 as T10 ON T10.ID = cepr.id and  Clave1 = CR.CLAVE and Clave2 = CF.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY   cr.CLAVE, cepr.Id
		
		--Columna 23 PorcPVigenteAnt
		declare @TPorcPVigenteAnt_10_1 as Table(PorcPVigenteAnt1 decimal(15,2), Clave Int, ID Int)
		insert into @TPorcPVigenteAnt_10_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinalR_10 as T10 ON T10.ID = cepr.id and  Clave1 = CR.CLAVE and Clave2 = CF.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY   cr.CLAVE, cepr.Id
		
		declare @TPorcPVigenteAnt_10_2 as Table(PorcPVigenteAnt2 decimal(15,2), Clave Int, ID Int)
		insert into @TPorcPVigenteAnt_10_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinalR_10 as T10 ON T10.ID = cepr.id and  Clave1 = CR.CLAVE and Clave2 = CF.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY   cr.CLAVE, cepr.Id 
		
		--Columna 24 y 25 NomPVigente
		declare @TNomPVigente_10_1 as Table(NomPVigente1 decimal(15,2), Clave Int, ID Int)
		insert into @TNomPVigente_10_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinalR_10 as T10 ON T10.ID = cepr.id and  Clave1 = CR.CLAVE and Clave2 = CF.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end 
		GROUP BY   cr.CLAVE, cepr.Id
		
		declare @TNomPVigente_10_2 as Table(NomPVigente2 decimal(15,2), Clave Int, ID Int)
		insert into @TNomPVigente_10_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente1, cr.CLAVE, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto  LEFT JOIN C_SubFunciones ON C_SubFunciones.IdSubFuncion = T_SellosPresupuestales.IdSubFuncion  
		LEFT JOIN C_Funciones CF ON CF.IdFuncion = C_SubFunciones.IdFuncion 
		LEFT JOIN @TResultadoFinalR_10 as T10 ON T10.ID = cepr.id and  Clave1 = CR.CLAVE and Clave2 = CF.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		GROUP BY   cr.CLAVE, cepr.Id 

		Select Clave1, Descripcion, Clave2, Descripcion2, Clave3, TResultadoFinal.Id, Descripcion3, Clave4, NombreAI, Autorizado, TransferenciaAmp, 
		TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev,	
		Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda,
		cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE (isnull(PorcAprobAnual2,0))/ PorcAprobAnual1 END as Decimal(15,2)) PorcAprobAnual,
		cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2)) PorcAprobadocAnt,
		cast(isnull(TNomAprobado1.NomAprobado1,0) - isnull(TNomAprobado2.NomAprobado2,0) as Decimal(15,2)) as NomAprobado,
		cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2)) PorcPVigenteAnual,
		cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2)) PorcPVigenteAnt,
		cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2)) NomPVigente
		from @TResultadoFinalR_10 as TResultadoFinal 
		left outer join @TPorcAprobAnual_10_1 as TPorcAprobAnual1 on TResultadoFinal.id = TPorcAprobAnual1.ID 
		left outer join @TPorcAprobAnual_10_2 as TPorcAprobAnual2 on TPorcAprobAnual2.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_10_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_10_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_10_1 as TNomAprobado1 on TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_10_2 as TNomAprobado2 on TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_10_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_10_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_10_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_10_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_10_1 as TNomPVigente1 on TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_10_2 as TNomPVigente2 on TNomPVigente2.ID = TResultadoFinal.id
		order by Clave1, Clave2, Clave3, Clave4

	END

	If @Tipo = 11 
	BEGIN
		-- Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo
		-- Valores Relativos

		DECLARE @TResultadoFinalR_11 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Descripcion3 varchar(255), Clave3a varchar(25), Descripcion3a varchar(255), Clave4 varchar(25), Id varchar(25), Descripcion4 varchar(255), Clave5 varchar(25),
		NombreAI varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), Modificado decimal(15,2), 
		PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2),	Comprometido decimal(15,2), PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), 
		Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2), Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), 
		EjerSinPagar decimal(15,2),	Deuda decimal(15,2), PorcAprobAnual decimal(15,2), PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2),
		PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2),	NomPVigente decimal(15,2))

		INSERT INTO @TResultadoFinalR_11 (Clave1, Descripcion, Clave2,	Descripcion2, Clave3, Descripcion3, Clave3a, Descripcion3a, Clave4, Id, Descripcion4, 
		Clave5,	NombreAI, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, 
		PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda,	PorcAprobAnual,	PorcAprobadocAnt, NomAprobado,
		PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)

		Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, C_AreaResponsabilidad.Clave  as Clave2, 
		C_AreaResponsabilidad.Nombre as Descripcion2, C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3, (SELECT  tablaID.Clave  FROM
		(select * from C_EP_Ramo as T11 where T11.id = C_EP_Ramo.ID and Nivel = 5) tablaID inner join 	(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as Clave3a, C_CapitulosNEP.Descripcion as Descripcion3a, C_CapitulosNEP.IdCapitulo as Clave4, C_EP_Ramo.Id, 
		C_ConceptosNEP.Descripcion as Descripcion4,  C_ConceptosNEP.IdConcepto  as Clave5, (SELECT tablaID.nombre 	FROM
		(select * from C_EP_Ramo as T11 where T11.id = C_EP_Ramo.ID and Nivel = 5) tablaID 	inner join 	(select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as NombreAI,
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal 
		INNER JOIN C_EP_Ramo ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_AreaResponsabilidad 
		ON (C_AreaResponsabilidad.IdAreaResp = T_SellosPresupuestales.IdAreaResp) AND (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ConceptosNEP ON  C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto	INNER JOIN C_CapitulosNEP 
		ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo 
		WHERE (Mes BETWEEN @Mes  and @Mes2 ) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) AND C_AreaResponsabilidad.Clave = CASE WHEN @ClaveUR = '' THEN C_AreaResponsabilidad.Clave ELSE @ClaveUR END AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		Group by  C_CapitulosNEP.IdCapitulo, C_CapitulosNEP.Descripcion, C_ConceptosNEP.IdConcepto, C_ConceptosNEP.Descripcion, C_ConceptosNEP.IdCapitulo,C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre,C_EP_Ramo.Clave,C_EP_Ramo.Id, C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE,C_RamoPresupuestal.DESCRIPCION 
		Order by  C_AreaResponsabilidad.Clave, C_CapitulosNEP.IdCapitulo 

		--Columna 18
		Declare @TPorcAprobAnual_11_1 as Table (PorcAprobAnual1 decimal(15,2), Clave int, Clave2 varchar(MAx), ID Int)
		Insert into @TPorcAprobAnual_11_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto	INNER JOIN C_CapitulosNEP cpn 	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinalR_11 as T11 on T11.ID = cepr.Id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.ID

		Declare @TPorcAprobAnual_11_2 as Table (PorcAprobAnual2 decimal(15,2), Clave int, Clave2 varchar(MAx), ID Int)
		Insert into @TPorcAprobAnual_11_2
		Select sum(isnull(tp.Autorizado,0))  as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinalR_11 as T11 on T11.ID = cepr.Id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.ID

		--Columna 19 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_11_1 as Table (PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 varchar(MAx), ID Int)
		Insert into @TPorcAprobadocAnt_11_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto	INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinalR_11 as T11 on T11.ID = cepr.Id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave,  cepr.ID
		
		Declare @TPorcAprobadocAnt_11_2 as Table (PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 varchar(MAx), ID Int)
		Insert into @TPorcAprobadocAnt_11_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinalR_11 as T11 on T11.ID = cepr.Id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.ID
		
		--Columna 20 y 21 NomAprobado
		Declare @TNomAprobado_11_1 as Table (NomAprobado1 decimal(15,2), Clave int, Clave2 varchar(MAx), ID Int)
		Insert into @TNomAprobado_11_1
		Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinalR_11 as T11 on T11.ID = cepr.Id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.ID
		
		Declare @TNomAprobado_11_2 as Table (NomAprobado2 decimal(15,2), Clave int, Clave2 varchar(MAx), ID Int)
		Insert into @TNomAprobado_11_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado1, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto	INNER JOIN C_CapitulosNEP cpn 	ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinalR_11 as T11 on T11.ID = cepr.Id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.ID
		
		--Columna 22 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_11_1 as Table (PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 varchar(MAx), ID Int)
		Insert into @TPorcPVigenteAnual_11_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales TS	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr	ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinalR_11 as T11 on T11.ID = cepr.Id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.ID

		Declare @TPorcPVigenteAnual_11_2 as Table (PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 varchar(MAx), ID Int)
		Insert into @TPorcPVigenteAnual_11_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal	INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinalR_11 as T11 on T11.ID = cepr.Id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.ID

		--Columna 23 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_11_1 as Table (PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 varchar(MAx), ID Int)
		Insert into @TPorcPVigenteAnual_11_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales TS INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinalR_11 as T11 on T11.ID = cepr.Id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.ID 

		Declare @TPorcPVigenteAnt_11_2 as Table (PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 varchar(MAx), ID Int)
		Insert into @TPorcPVigenteAnual_11_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) INNER JOIN C_ConceptosNEP cn 
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinalR_11 as T11 on T11.ID = cepr.Id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.ID
		
		--Columna 24 y 25 NomPVigente
		Declare @TNomPVigente_11_1 as Table (NomPVigente1 decimal(15,2), Clave int, Clave2 varchar(MAx), ID Int)
		Insert into @TNomPVigente_11_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA 
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ConceptosNEP cn ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinalR_11 as T11 on T11.ID = cepr.Id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.ID
		
		Declare @TNomPVigente_11_2 as Table (NomPVigente2 decimal(15,2), Clave int, Clave2 varchar(MAx), ID Int)
		Insert into @TNomPVigente_11_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, ca.Clave, cepr.ID
		FROM T_SellosPresupuestales TS 	INNER JOIN T_PRESUPUESTONW TP ON TS.IdSelloPresupuestal = TP.IdSelloPresupuestal INNER JOIN C_RamoPresupuestal cr
		ON cr.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr ON cepr.Id  = TS.IdProyecto INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = TS.IdPartida INNER JOIN C_AreaResponsabilidad  CA
		ON (CA.IdAreaResp = TS.IdAreaResp) AND (CA.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 	INNER JOIN C_ConceptosNEP cn
		ON  cn.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP cpn ON cpn.IdCapitulo = cpn.IdCapitulo 
		left join @TResultadoFinalR_11 as T11 on T11.ID = cepr.Id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave4 = cpn.IdCapitulo  and cn.IdConcepto = clave5 and cepr.Clave = Clave3
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.ID
		
		Select Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Clave3a, Descripcion3a, Clave4, Descripcion4, Clave5, 
		sum(Autorizado)Autorizado, sum(TransferenciaAmp)TransferenciaAmp, sum(TransferenciaRed)TransferenciaRed, Sum(Modificado)Modificado, 
		sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, sum(Comprometido)Comprometido, SUM(PreCompSinComp)PreCompSinComp, 
		Sum(PresDispComp)PresDispComp, sum(Devengado)Devengado, sum(CompSinDev)CompSinDev, sum(PresSinDev)PresSinDev, sum(Ejercido)Ejercido, 
		sum(DevSinEjer)DevSinEjer, sum(Pagado)Pagado, sum(EjerSinPagar)EjerSinPagar, sum(Deuda)Deuda, 
		avg(cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2))) PorcAprobAnual,
		avg(cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2))) PorcAprobadocAnt,
		sum(cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2))) as NomAprobado,
		avg(cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2))) PorcPVigenteAnual,
		Avg(cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2))) PorcPVigenteAnt,
		sum(cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2))) NomPVigente
		from @TResultadoFinalR_11 as TResultadoFinal
		left outer join @TPorcAprobAnual_11_1 as TPorcAprobAnual1 on TResultadoFinal.id = TPorcAprobAnual1.ID and TPorcAprobAnual1.Clave2 = TResultadoFinal.Clave2
		left outer join @TPorcAprobAnual_11_2 as TPorcAprobAnual2 on TPorcAprobAnual2.ID = TResultadoFinal.id and TPorcAprobAnual2.Clave2 = TResultadoFinal.Clave2 
		left outer join @TPorcAprobadocAnt_11_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.ID = TResultadoFinal.id and TPorcAprobadocAnt1.Clave2 = TResultadoFinal.Clave2 
		left outer join @TPorcAprobadocAnt_11_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.ID = TResultadoFinal.id and TPorcAprobadocAnt2.Clave2 = TResultadoFinal.Clave2 
		left outer join @TNomAprobado_11_1 as TNomAprobado1 on TNomAprobado1.ID = TResultadoFinal.ID and TNomAprobado1.Clave2 = TResultadoFinal.Clave2 
		left outer join @TNomAprobado_11_2 as TNomAprobado2 on TNomAprobado2.ID = TResultadoFinal.ID and TNomAprobado2.Clave2 = TResultadoFinal.Clave2 
		left outer join @TPorcPVigenteAnual_11_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.ID = TResultadoFinal.ID and TPorcPVigenteAnual1.Clave2 = TResultadoFinal.Clave2
		left outer join @TPorcPVigenteAnual_11_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.ID = TResultadoFinal.id and TPorcPVigenteAnual2.Clave2 = TResultadoFinal.Clave2
		left outer join @TPorcPVigenteAnt_11_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.ID = TResultadoFinal.clave2 and TPorcPVigenteAnt1.Clave2 = TResultadoFinal.Clave2
		left outer join @TPorcPVigenteAnt_11_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.ID = TResultadoFinal.clave2 and TPorcPVigenteAnt2.Clave2 = TResultadoFinal.Clave2
		left outer join @TNomPVigente_11_1 as TNomPVigente1 on TNomPVigente1.ID = TResultadoFinal.id and TNomPVigente1.Clave2 = TResultadoFinal.Clave2
		left outer join @TNomPVigente_11_2 as TNomPVigente2 on TNomPVigente2.ID = TResultadoFinal.id and TNomPVigente2.Clave2 = TResultadoFinal.Clave2
		group by Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Clave3a, Descripcion3a, Clave4, Descripcion4, Clave5
		order by clave1, clave2, clave3, clave3a, clave5	
		
	
	END

	If @Tipo = 12 
	BEGIN
		--Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica
		--Valores Relativos

		DECLARE @TResultadoFinalR_12 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25),	Descripcion2 varchar(255), Clave3 varchar(25),
		NombreAI varchar(255), Clave3a varchar(25), Descripcion3a varchar(255), Clave4 varchar(25), Descripcion4 varchar(255), Id varchar(25), Clave5 varchar(25),
		Descripcion3 varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), Modificado decimal(15,2), 
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

	If @Tipo = 13 
	BEGIN
		--Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento
		--Valores Relativos

		DECLARE @TResultadoFinalR_13 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Descripcion3 varchar(255), Clave4 varchar(25), Id varchar(25), NombreAI varchar(255), Clave5 varchar(25), Descripcion4 varchar(255), 
		Clave6 varchar(25), Descripcion5 varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), 
		Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), PreCompSinComp decimal(15,2), 
		PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2), Ejercido decimal(15,2), 
		DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2), 
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))

		INSERT INTO @TResultadoFinalR_13 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Id, NombreAI, Clave5, Descripcion4, Clave6,
		Descripcion5, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, 
		PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual, PorcAprobadocAnt,
		NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)
		Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
		C_AreaResponsabilidad.Clave as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2 , 
		C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3, 
		/*(SELECT tablaID.Clave  FROM (select * from C_EP_Ramo AS T13 where T13.id = C_EP_Ramo.id and Nivel = 5) tablaID
		inner join (select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id)*/ '' as Clave4,C_EP_Ramo.Id,  
		/*(SELECT  tablaID.nombre FROM (select * from C_EP_Ramo AS T13 where T13.id = C_EP_Ramo.ID and Nivel = 5) tablaID
		inner join (select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id)*/ '' as NombreAI,
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
		where  (Mes BETWEEN @Mes and @Mes2 ) AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE 
		else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end  ) 
		and C_AreaResponsabilidad.Clave  = CASE WHEN @ClaveUR = '' THEN C_AreaResponsabilidad.Clave ELSE @ClaveUR END AND C_EP_Ramo.Id = 
		case when @IdEP = '' then C_EP_Ramo.id else @IdEP end 
 		group by C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida , C_AreaResponsabilidad.Clave  , 
 		C_AreaResponsabilidad.Nombre, C_RamoPresupuestal.CLAVE , C_RamoPresupuestal.DESCRIPCION , C_FuenteFinanciamiento.CLAVE, 
 		C_FuenteFinanciamiento.DESCRIPCION , C_EP_Ramo.Clave, C_EP_Ramo.Nombre, C_EP_Ramo.Id  
		Order By C_AreaResponsabilidad.Clave ,C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida,C_RamoPresupuestal.CLAVE 


		--Columna 1 PorcAprobAnual
		declare @TPorcAprobAnual_13_1 as Table(PorcAprobAnual1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobAnual_13_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, ca.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TResultadoFinalR_13 as T13 ON  t13.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id 

		declare @TPorcAprobAnual_13_2 as Table(PorcAprobAnual2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobAnual_13_2
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal 
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL  INNER JOIN C_FuenteFinanciamiento 
		ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
		left join  @TResultadoFinalR_13 as T13 ON  t13.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id

		--Columna 2 PorcAprobadocAnt
		declare @TPorcAprobadocAnt_13_1 as Table(PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobadocAnt_13_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TResultadoFinalR_13 as T13 ON  t13.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id
		
		declare @TPorcAprobadocAnt_13_2 as Table(PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobadocAnt_13_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida  INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
		INNER JOIN C_AreaResponsabilidad ca ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TResultadoFinalR_13 as T13 ON  t13.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id
		
		--Columna 3 y 4 NomAprobado
		declare @TNomAprobado_13_1 as Table(NomAprobado1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TNomAprobado_13_1
		Select (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL 
		INNER JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento   
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TResultadoFinalR_13 as T13 ON  t13.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id
		
		declare @TNomAprobado_13_2 as Table(NomAprobado2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TNomAprobado_13_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento 
		ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TResultadoFinalR_13 as T13 ON  t13.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id
		
		--Columna 5 PorcPVigenteAnual
		declare @TPorcPVigenteAnual_13_1 as Table(PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnual_13_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento 
		ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
		left join  @TResultadoFinalR_13 as T13 ON  t13.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id

		declare @TPorcPVigenteAnual_13_2 as Table(PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnual_13_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0))
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento 
		ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
		left join  @TResultadoFinalR_13 as T13 ON  t13.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id 
		
		--Columna 6 PorcPVigenteAnt
		declare @TPorcPVigenteAnt_13_1 as Table(PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnt_13_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento 
		ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TResultadoFinalR_13 as T13 ON  t13.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id
		
		declare @TPorcPVigenteAnt_13_2 as Table(PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnt_13_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento 
		ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TResultadoFinalR_13 as T13 ON  t13.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 7 y 8 NomPVigente
		declare @TNomPVigente_13_1 as Table(NomPVigente1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TNomPVigente_13_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))))  as NomPVigente1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal 
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento 
		ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TResultadoFinalR_13 as T13 ON  t13.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id 
		
		declare @TNomPVigente_13_2 as Table(NomPVigente2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TNomPVigente_13_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as NomPVigente2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp  and ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL INNER JOIN C_FuenteFinanciamiento 
		ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO   = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto 
		left join  @TResultadoFinalR_13 as T13 ON  t13.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave3 = CEPR.Clave and C_FuenteFinanciamiento.CLAVE = clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Select Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Clave4, Clave5, Descripcion4, Clave6, Descripcion5, 
		Sum(Autorizado)Autorizado, SUM(TransferenciaAmp)TransferenciaAmp, Sum(TransferenciaRed)TransferenciaRed, Sum(Modificado)Modificado, 
		Sum(PreComprometido)PreComprometido, Sum(PresVigSinPreComp)PresVigSinPreComp, Sum(Comprometido)Comprometido, Sum(PreCompSinComp)PreCompSinComp, 
		sum(PresDispComp)PresDispComp, Sum(Devengado)Devengado, Sum(CompSinDev)CompSinDev, Sum(PresSinDev)PresSinDev, Sum(Ejercido)Ejercido, 
		Sum(DevSinEjer)DevSinEjer, Sum(Pagado)Pagado, Sum(EjerSinPagar)EjerSinPagar, Sum(Deuda)Deuda,
		avg(cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2))) PorcAprobAnual,
		avg(cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2))) PorcAprobadocAnt,
		sum(cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2))) as NomAprobado,
		avg(cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2))) PorcPVigenteAnual,
		avg(cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2))) PorcPVigenteAnt,
		Sum(cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2))) NomPVigente
		from @TResultadoFinalR_13 as TResultadoFinal 
		left outer join @TPorcAprobAnual_13_1 as TPorcAprobAnual1 on TPorcAprobAnual1.clave2 = TResultadoFinal.clave2 and TPorcAprobAnual1.ID = TResultadoFinal.ID 
		left outer join @TPorcAprobAnual_13_2 as TPorcAprobAnual2 on TPorcAprobAnual2.Clave2 = TResultadoFinal.clave2 and TPorcAprobAnual2.ID = TResultadoFinal.ID
		left outer join @TPorcAprobadocAnt_13_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_13_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_13_1 as TNomAprobado1 on TNomAprobado1.clave2 = TResultadoFinal.clave2 and TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_13_2 as TNomAprobado2 on TNomAprobado2.clave2 = TResultadoFinal.clave2 and TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_13_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_13_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_13_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_13_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_13_1 as TNomPVigente1 on TNomPVigente1.clave2 = TResultadoFinal.clave2 and TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_13_2 as TNomPVigente2 on TNomPVigente2.clave2 = TResultadoFinal.clave2 and TNomPVigente2.ID = TResultadoFinal.id
		group by Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Clave4, Clave5, Descripcion4, Clave6, Descripcion5
		
				
	END

	If @Tipo = 14
	BEGIN	
		--Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Distribución Geográfica
		--Valores Relativos

		DECLARE @TResultadoFinalR_14 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Descripcion3 varchar(255), Clave4 varchar(25), Id varchar(25), NombreAI varchar(255), Clave5 varchar(25), Descripcion4 varchar(255), Clave6 varchar(25),
		Descripcion5 varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), Modificado decimal(15,2), 
		PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), 
		Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2), Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), 
		EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2), PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2),
		PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2)) 
		
		INSERT INTO @TResultadoFinalR_14 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Id, NombreAI, Clave5, Descripcion4, Clave6,
		Descripcion5, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, 
		PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual, PorcAprobadocAnt,
		NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)

		Select  C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion, 
		C_AreaResponsabilidad.Clave as Clave2 , C_AreaResponsabilidad.Nombre as Descripcion2 , 
		C_EP_Ramo.Clave AS Clave3, C_EP_Ramo.Nombre as Descripcion3,
		(SELECT tablaID.Clave FROM
		(select * from C_EP_Ramo as T14 where T14.id=  C_EP_Ramo.id and Nivel = 5) tablaID
		inner join (select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as Clave4, C_EP_Ramo.Id,  
		(SELECT tablaID.nombre FROM
		(select * from C_EP_Ramo as T14 where T14.id = C_EP_Ramo.id and Nivel = 5) tablaID
		inner join (select * from C_EP_Ramo where  Nivel = 4) tablaAI
		ON tablaID.IdPadre = tablaAI.Id) as NombreAI,
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad 
		ON (C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal ON C_ClasificadorGeograficoPresupuestal.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  
		where  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE 
		else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) 
		AND C_AreaResponsabilidad.Clave  = CASE WHEN @ClaveUR = '' THEN C_AreaResponsabilidad.Clave ELSE @ClaveUR END  AND C_EP_Ramo.Id = 
		case when @IdEP = '' then C_EP_Ramo.id else @IdEP end    
		group by C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida , C_AreaResponsabilidad.Clave  , 
		C_AreaResponsabilidad.Nombre, C_RamoPresupuestal.CLAVE , C_RamoPresupuestal.DESCRIPCION ,  C_EP_Ramo.Clave, C_EP_Ramo.Nombre, C_EP_Ramo.Id, 
		C_ClasificadorGeograficoPresupuestal.Clave , C_ClasificadorGeograficoPresupuestal.Descripcion  
		Order By C_AreaResponsabilidad.Clave ,C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida,C_RamoPresupuestal.CLAVE 

		--Columna 1 PorcAprobAnual
		declare @TPorcAprobAnual_14_1 as Table(PorcAprobAnual1 decimal(15,2), Clave int, Clave2 varchar(Max), id Int)
		Insert Into @TPorcAprobAnual_14_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinalR_14 as T14 on t14.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id

		declare @TPorcAprobAnual_14_2 as Table(PorcAprobAnual2 decimal(15,2), Clave int, Clave2 varchar(Max), id Int)
		Insert Into @TPorcAprobAnual_14_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinalR_14 as T14 on t14.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END 
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 2 PorcAprobadocAnt
		declare @TPorcAprobadocAnt_14_1 as Table(PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 varchar(Max), id Int)
		Insert Into @TPorcAprobadocAnt_14_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg 	ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinalR_14 as T14 on t14.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TPorcAprobadocAnt_14_2 as Table(PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 varchar(Max), id Int)
		Insert Into @TPorcAprobadocAnt_14_2
		Select  sum(isnull(tp.Autorizado,0))  as PorcAprobadocAnt2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg 	ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr 	ON cepr.Id    = T_SellosPresupuestales.IdProyecto 	INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinalR_14 as T14 on t14.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 3 y 4 NomAprobado
		declare @TNomAprobado_14_1 as Table(NomAprobado1 decimal(15,2), Clave int, Clave2 varchar(Max), id Int)
		Insert Into @TNomAprobado_14_1
		Select (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinalR_14 as T14 on t14.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id 
		
		declare @TNomAprobado_14_2 as Table(NomAprobado2 decimal(15,2), Clave int, Clave2 varchar(Max), id Int)
		Insert Into @TNomAprobado_14_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinalR_14 as T14 on t14.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 5 PorcPVigenteAnual
		declare @TPorcPVigenteAnual_14_1 as Table(PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 varchar(Max), id Int)
		Insert Into @TPorcPVigenteAnual_14_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal 
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinalR_14 as T14 on t14.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id 
		
		declare @TPorcPVigenteAnual_14_2 as Table(PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 varchar(Max), id Int)
		Insert Into @TPorcPVigenteAnual_14_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
			ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinalR_14 as T14 on t14.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id 
		 
		--Columna 6 PorcPVigenteAnt
		declare @TPorcPVigenteAnt_14_1 as Table(PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 varchar(Max), id Int)
		Insert Into @TPorcPVigenteAnt_14_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinalR_14 as T14 on t14.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id

		declare @TPorcPVigenteAnt_14_2 as Table(PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 varchar(Max), id Int)
		Insert Into @TPorcPVigenteAnt_14_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, ca.Clave, cepr.id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinalR_14 as T14 on t14.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id
		
		--Columna 7 y 8 NomPVigente
		declare @TNomPVigente_14_1 as Table(NomPVigente1 decimal(15,2), Clave int, Clave2 varchar(Max), id Int)
		Insert Into @TNomPVigente_14_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca 
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinalR_14 as T14 on t14.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id
		
		declare @TNomPVigente_14_2 as Table(NomPVigente2 decimal(15,2), Clave int, Clave2 varchar(Max), id Int)
		Insert Into @TNomPVigente_14_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal cr ON cr.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres  CPG
		ON  CPG.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad ca
		ON (ca.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (ca.IdRamoPresupuestal = cr.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_ClasificadorGeograficoPresupuestal cg ON cg.IdClasificadorGeografico   = T_SellosPresupuestales.IdClasificadorGeografico   
		INNER JOIN C_EP_Ramo  cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = CPG.IdConcepto 
		left join  @TResultadoFinalR_14 as T14 on t14.ID = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = CPG.IdPartidaGenerica and Clave3 = CEPR.Clave and cg.Clave = Clave6
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id
		
		Select Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Descripcion3, Clave4,  NombreAI, Clave5, Descripcion4,
		Clave6,	Descripcion5, Sum(Autorizado)Autorizado, Sum(TransferenciaAmp)TransferenciaAmp, Sum(TransferenciaRed)TransferenciaRed, 
		Sum(Modificado)Modificado, Sum(PreComprometido)PreComprometido, sum(PresVigSinPreComp)PresVigSinPreComp, Sum(Comprometido)Comprometido, 
		sum(PreCompSinComp)PreCompSinComp, Sum(PresDispComp)PresDispComp, Sum(Devengado)Devengado, Sum(CompSinDev)CompSinDev, Sum(PresSinDev)PresSinDev, 
		Sum(Ejercido)Ejercido, Sum(DevSinEjer)DevSinEjer, Sum(Pagado)Pagado, Sum(EjerSinPagar)EjerSinPagar, Sum(Deuda)Deuda,
		avg(cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2))) PorcAprobAnual,
		avg(cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2))) PorcAprobadocAnt,
		sum(cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2))) as NomAprobado,
		avg(cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2))) PorcPVigenteAnual,
		avg(cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2))) PorcPVigenteAnt,
		sum(cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2))) NomPVigente 
		from @TResultadoFinalR_14 as TResultadoFinal 
		left outer join @TPorcAprobAnual_14_1 as TPorcAprobAnual1 on TPorcAprobAnual1.clave2 = TResultadoFinal.clave2 and TPorcAprobAnual1.ID = TResultadoFinal.ID 
		left outer join @TPorcAprobAnual_14_2 as TPorcAprobAnual2 on TPorcAprobAnual2.Clave2 = TResultadoFinal.clave2 and TPorcAprobAnual2.ID = TResultadoFinal.ID
		left outer join @TPorcAprobadocAnt_14_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_14_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_14_1 as TNomAprobado1 on TNomAprobado1.clave2 = TResultadoFinal.clave2 and TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_14_2 as TNomAprobado2 on TNomAprobado2.clave2 = TResultadoFinal.clave2 and TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_14_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_14_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_14_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_14_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_14_1 as TNomPVigente1 on TNomPVigente1.clave2 = TResultadoFinal.clave2 and TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_14_2 as TNomPVigente2 on TNomPVigente2.clave2 = TResultadoFinal.clave2 and TNomPVigente2.ID = TResultadoFinal.id
		group by Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Descripcion3, Clave4,  NombreAI, Clave5, Descripcion4,
		Clave6,	Descripcion5
		ORDER BY CLAVE1, clave2, clave3, clave5

	END

	If @Tipo = 15
	BEGIN
		--Ramo o Dependencia / Función / Programas y Proyectos de Inversión
		--Valores Relativos
				
		DECLARE @TResultadoFinalR_15 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Id varchar(25), Descripcion3 varchar(255), Clave4 varchar(MAx), Descripcion4 varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal 
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo 
		ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto  left JOIN C_SubFunciones  
		ON C_SubFunciones.IdSubFuncion  = T_SellosPresupuestales.IdSubFuncion left JOIN C_Funciones ON C_Funciones.IdFuncion = C_SubFunciones.IdFuncion  
		where   (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
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
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
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
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cf.Clave, cepr.Id 
			
		Select Clave1, Descripcion,	TResultadoFinal.Clave2, Descripcion2, Clave3, TResultadoFinal.Id, Descripcion3, Clave4, Descripcion4, Autorizado, TransferenciaAmp, 
		TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev,
		Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, 
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
		  
	END

	If @Tipo = 16
	BEGIN
		--Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasificación Económica
		--Valores Relativos

		DECLARE @TResultadoFinalR_16 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Descripcion3 varchar(255), Id varchar(25), Clave4 varchar(Max), Descripcion4 varchar(255), Clave4a varchar(25), Descripcion4a varchar(255),
		Clave5 varchar(25), Descripcion5 varchar(255), Clave6 varchar(25), Descripcion6 varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2), PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))

		INSERT INTO @TResultadoFinalR_16 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Id, Clave4, Descripcion4, Clave4a, Descripcion4a,
		Clave5, Descripcion5, Clave6, Descripcion6, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp,
		Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual,
		PorcAprobadocAnt, NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)

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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal 
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo 
		ON C_EP_Ramo.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad ON (C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  
		(C_AreaResponsabilidad.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal) and (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_TipoGasto ON C_TipoGasto.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto INNER JOIN C_PartidasPres 
		ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  
		INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo 
		WHERE  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) AND C_AreaResponsabilidad.Clave = CASE WHEN @ClaveUR = '' THEN C_AreaResponsabilidad.Clave ELSE @ClaveUR END  AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		Group by  C_CapitulosNEP.IdCapitulo, C_CapitulosNEP.Descripcion, C_ConceptosNEP.IdConcepto, C_ConceptosNEP.Descripcion, C_ConceptosNEP.IdCapitulo,C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre,C_EP_Ramo.Clave,C_EP_Ramo.Id, C_EP_Ramo.Nombre,C_RamoPresupuestal.CLAVE,C_RamoPresupuestal.DESCRIPCION,C_TipoGasto.Clave, C_TipoGasto.nombre, C_ProyectosInversion.CLAVE, C_ProyectosInversion.NOMBRE   
		Order by  C_AreaResponsabilidad.Clave  ,C_CapitulosNEP.IdCapitulo 
		
		--Columna 1 PorcAprobAnual
		Declare @TPorcAprobAnual_16_1 as Table (PorcAprobAnual1 decimal(15,2), Clave int, Clave2 varchar(MAx), id Int)
		insert into @TPorcAprobAnual_16_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal 
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinalR_16 as T16 ON T16.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.id

		Declare @TPorcAprobAnual_16_2 as Table (PorcAprobAnual2 decimal(15,2), Clave int, Clave2 varchar(MAx), id Int)
		insert into @TPorcAprobAnual_16_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg 	ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinalR_16 as T16 ON T16.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id
		
		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_16_1 as Table (PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 varchar(MAx), id Int)
		insert into @TPorcAprobadocAnt_16_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinalR_16 as T16 ON T16.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id

		Declare @TPorcAprobadocAnt_16_2 as Table (PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 varchar(MAx), id Int)
		insert into @TPorcAprobadocAnt_16_2
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg	ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinalR_16 as T16 ON T16.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id
		
		--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_16_1 as Table (NomAprobado1 decimal(15,2), Clave int, Clave2 varchar(MAx), id Int)
		insert into @TNomAprobado_16_1
		Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg	ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinalR_16 as T16 ON T16.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id
		
		Declare @TNomAprobado_16_2 as Table (NomAprobado2 decimal(15,2), Clave int, Clave2 varchar(MAx), id Int)
		insert into @TNomAprobado_16_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinalR_16 as T16 ON T16.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id
		
		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_16_1 as Table (PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 varchar(MAx), id Int)
		insert into @TPorcPVigenteAnual_16_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg 	ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinalR_16 as T16 ON T16.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id 

		Declare @TPorcPVigenteAnual_16_2 as Table (PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 varchar(MAx), id Int)
		insert into @TPorcPVigenteAnual_16_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA	ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinalR_16 as T16 ON T16.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id

		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_16_1 as Table (PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 varchar(MAx), id Int)
		insert into @TPorcPVigenteAnt_16_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  	INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinalR_16 as T16 ON T16.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id 

		Declare @TPorcPVigenteAnt_16_2 as Table (PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 varchar(MAx), id Int)
		insert into @TPorcPVigenteAnt_16_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnt2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinalR_16 as T16 ON T16.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id
		
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_16_1 as Table (NomPVigente1 decimal(15,2), Clave int, Clave2 varchar(MAx), id Int)
		insert into @TNomPVigente_16_1
		Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg	ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres  ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinalR_16 as T16 ON T16.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id
		
		Declare @TNomPVigente_16_2 as Table (NomPVigente2 decimal(15,2), Clave int, Clave2 varchar(MAx), id Int)
		insert into @TNomPVigente_16_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))as NomPVigente2, cr.CLAVE, ca.Clave, cepr.id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id  = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto 
		INNER JOIN C_AreaResponsabilidad CA ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp) and  (CA.IdRamoPresupuestal = T_SellosPresupuestales.IdRamoPresupuestal)
		and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_TipoGasto ctg	ON ctg.IDTIPOGASTO = T_SellosPresupuestales.IdTipoGasto  
		INNER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida   INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasPres.IdConcepto  INNER JOIN C_CapitulosNEP ON C_CapitulosNEP.IdCapitulo = C_ConceptosNEP.IdCapitulo  
		LEFT JOIN @TResultadoFinalR_16 as T16 ON T16.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave6 = ctg.Clave and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id

		Select Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Descripcion3, TResultadoFinal.Id, Clave4, Descripcion4, Clave4a, Descripcion4a,
		Clave5, Descripcion5, Clave6, Descripcion6, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp,
		Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda,
		cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2)) PorcAprobAnual,
		cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2)) PorcAprobadocAnt,
		cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2)) as NomAprobado,
		cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2)) PorcPVigenteAnual,
		cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2)) PorcPVigenteAnt,
		cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2)) NomPVigente 
		from @TResultadoFinalR_16 as TResultadoFinal 
		left outer join @TPorcAprobAnual_16_1 as TPorcAprobAnual1 on TPorcAprobAnual1.clave2 = TResultadoFinal.clave2 and TPorcAprobAnual1.ID = TResultadoFinal.ID 
		left outer join @TPorcAprobAnual_16_2 as TPorcAprobAnual2 on TPorcAprobAnual2.Clave2 = TResultadoFinal.clave2 and TPorcAprobAnual2.ID = TResultadoFinal.ID
		left outer join @TPorcAprobadocAnt_16_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.clave2 = TResultadoFinal.clave2 and TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_16_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.clave2 = TResultadoFinal.clave2 and TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_16_1 as TNomAprobado1 on TNomAprobado1.clave2 = TResultadoFinal.clave2 and TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_16_2 as TNomAprobado2 on TNomAprobado2.clave2 = TResultadoFinal.clave2 and TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_16_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_16_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_16_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_16_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_16_1 as TNomPVigente1 on TNomPVigente1.clave2 = TResultadoFinal.clave2 and TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_16_2 as TNomPVigente2 on TNomPVigente2.clave2 = TResultadoFinal.clave2 and TNomPVigente2.ID = TResultadoFinal.id


	END

	If @Tipo = 17
	BEGIN
		--Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento
		--Valores Relativos

		DECLARE @TResultadoFinalR_17 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25), Descripcion2 varchar(255), Clave3 varchar(25),
		Descripcion3 varchar(255), Clave4 varchar(MAx), Descripcion4 varchar(255), Clave5 varchar(25), Id varchar(25), Descripcion5 varchar(255),
		Clave6 varchar(25), Descripcion6 varchar(255), Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), TransferenciaRed decimal(15,2), 
		Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), PreCompSinComp decimal(15,2), 
		PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2), Ejercido decimal(15,2), DevSinEjer decimal(15,2), 
		Pagado decimal(15,2), EjerSinPagar decimal(15,2), Deuda decimal(15,2), PorcAprobAnual decimal(15,2), PorcAprobadocAnt decimal(15,2),
		NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2),	PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))
		
		INSERT INTO @TResultadoFinalR_17 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Descripcion4, Clave5, Id, Descripcion5,
		Clave6, Descripcion6, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, 
		PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda, PorcAprobAnual,	PorcAprobadocAnt,
		NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)

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
		 FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad 
		ON (C_AreaResponsabilidad.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (C_AreaResponsabilidad.IdRamoPresupuestal = C_RamoPresupuestal.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto    
		where  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) and C_AreaResponsabilidad.Clave = CASE WHEN @ClaveUR = '' THEN C_AreaResponsabilidad.Clave ELSE @ClaveUR END AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		group by C_PartidasGenericasPres.IdPartidaGenerica , C_PartidasGenericasPres.DescripcionPartida , C_AreaResponsabilidad.Clave  , C_AreaResponsabilidad.Nombre, C_RamoPresupuestal.CLAVE , C_RamoPresupuestal.DESCRIPCION ,  C_EP_Ramo.Clave, C_EP_Ramo.Nombre, C_EP_Ramo.Id, C_FuenteFinanciamiento.CLAVE, C_FuenteFinanciamiento.DESCRIPCION ,C_ProyectosInversion.nombre, C_ProyectosInversion.CLAVE  
		Order By C_AreaResponsabilidad.Clave ,C_PartidasGenericasPres.IdPartidaGenerica , C_RamoPresupuestal.CLAVE 
		
		--Columna 1 PorcAprobAnual
		Declare @TPorcAprobAnual_17_1 as Table(PorcAprobAnual1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobAnual_17_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, ca.Clave, cepr.Id 
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 	INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinalR_17 as T17 ON T17.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE, ca.Clave, cepr.Id 

		Declare @TPorcAprobAnual_17_2 as Table(PorcAprobAnual2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobAnual_17_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobAnual2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinalR_17 as T17 ON T17.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id
		
		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_17_1 as Table(PorcAprobadocAnt1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobadocAnt_17_1
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinalR_17 as T17 ON T17.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id

		Declare @TPorcAprobadocAnt_17_2 as Table(PorcAprobadocAnt2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcAprobadocAnt_17_2
		Select sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinalR_17 as T17 ON T17.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id
		
		--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_17_1 as Table(NomAprobado1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TNomAprobado_17_1
		Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto  INNER JOIN C_ConceptosNEP 
		ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinalR_17 as T17 ON T17.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id 
		
		Declare @TNomAprobado_17_2 as Table(NomAprobado2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TNomAprobado_17_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento    
		INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinalR_17 as T17 ON T17.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, CEPR.ID
		
		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_17_1 as Table(PorcPVigenteAnual1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnual_17_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento  INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinalR_17 as T17 ON T17.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id

		Declare @TPorcPVigenteAnual_17_2 as Table(PorcPVigenteAnual2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnual_17_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr ON cepr.Id    = T_SellosPresupuestales.IdProyecto    
		INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinalR_17 as T17 ON T17.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id
		
		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_17_1 as Table(PorcPVigenteAnt1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnt_17_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) 
		INNER JOIN C_FuenteFinanciamiento  cff ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinalR_17 as T17 ON T17.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id

		Declare @TPorcPVigenteAnt_17_2 as Table(PorcPVigenteAnt2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnt_17_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as PorcPVigenteAnt1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinalR_17 as T17 ON T17.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.Id 
		
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_17_1 as Table(NomPVigente1 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TNomPVigente_17_1
		Select ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))))  as NomPVigente1, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinalR_17 as T17 ON T17.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id
		
		Declare @TNomPVigente_17_2 as Table(NomPVigente2 decimal(15,2), Clave int, Clave2 varchar(Max), ID Int)
		insert into @TNomPVigente_17_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))  as NomPVigente2, cr.CLAVE, ca.Clave, cepr.Id
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_PartidasPres 
		ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida INNER JOIN C_PartidasGenericasPres cpg
		ON  cpg.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica INNER JOIN C_AreaResponsabilidad CA
		ON (CA.IdAreaResp  = T_SellosPresupuestales.IdAreaResp)  and (CA.IdRamoPresupuestal = CR.IDRAMOPRESUPUESTAL) INNER JOIN C_FuenteFinanciamiento  cff
		ON cff.IDFUENTEFINANCIAMIENTO  = T_SellosPresupuestales.IdFuenteFinanciamiento INNER JOIN C_EP_Ramo cepr 
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = cpg.IdConcepto  
		INNER JOIN C_ProyectosInversion ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto  
		LEFT JOIN @TResultadoFinalR_17 as T17 ON T17.id = cepr.id and Clave1 = cr.CLAVE and Clave2 = ca.Clave and Clave5 = cpg.IdPartidaGenerica  and cff.CLAVE = Clave6 and Clave3 = CEPR.Clave
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end and CA.Clave = CASE WHEN @ClaveUR = '' THEN CA.Clave ELSE @ClaveUR END
		group by cr.CLAVE , ca.Clave, cepr.id

		Select Clave1, Descripcion, TResultadoFinal.Clave2, Descripcion2, Clave3, Descripcion3, Clave4, Descripcion4, Clave5, TResultadoFinal.Id, Descripcion5,
		Clave6, Descripcion6, Autorizado, TransferenciaAmp, TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, 
		PresDispComp, Devengado, CompSinDev, PresSinDev, Ejercido, DevSinEjer, Pagado, EjerSinPagar, Deuda,
		cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2)) PorcAprobAnual,
		cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2)) PorcAprobadocAnt,
		cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2)) as NomAprobado,
		cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2)) PorcPVigenteAnual,
		cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2)) PorcPVigenteAnt,
		cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2)) NomPVigente 
		from @TResultadoFinalR_17 as TResultadoFinal 
		left outer join @TPorcAprobAnual_17_1 as TPorcAprobAnual1 on TPorcAprobAnual1.clave2 = TResultadoFinal.clave2 and TPorcAprobAnual1.ID = TResultadoFinal.ID 
		left outer join @TPorcAprobAnual_17_2 as TPorcAprobAnual2 on TPorcAprobAnual2.Clave2 = TResultadoFinal.clave2 and TPorcAprobAnual2.ID = TResultadoFinal.ID
		left outer join @TPorcAprobadocAnt_17_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.Clave2 = TResultadoFinal.clave2 and TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_17_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.Clave2 = TResultadoFinal.clave2 and TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_17_1 as TNomAprobado1 on TNomAprobado1.clave2 = TResultadoFinal.clave2 and TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_17_2 as TNomAprobado2 on TNomAprobado2.clave2 = TResultadoFinal.clave2 and TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_17_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_17_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_17_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_17_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.clave2 = TResultadoFinal.clave2 and TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_17_1 as TNomPVigente1 on TNomPVigente1.clave2 = TResultadoFinal.clave2 and TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_17_2 as TNomPVigente2 on TNomPVigente2.clave2 = TResultadoFinal.clave2 and TNomPVigente2.ID = TResultadoFinal.id
		
	END

	If @Tipo = 18
	BEGIN
		--Ramo o Dependencia / Distribución Geográfica / Programas y Proyectos de Inversión
		--Valores Relativos

		DECLARE @TResultadoFinalR_18 as table (Clave1 varchar(25), Descripcion varchar(255), Clave2 varchar(25),	Descripcion2 varchar(255), Clave3 varchar(25),
		Id varchar(25), Descripcion3 varchar(255), Clave4 varchar(MAx), Descripcion4 varchar(255),	Autorizado decimal(15,2), TransferenciaAmp decimal(15,2), 
		TransferenciaRed decimal(15,2), Modificado decimal(15,2), PreComprometido decimal(15,2), PresVigSinPreComp decimal(15,2), Comprometido decimal(15,2), 
		PreCompSinComp decimal(15,2), PresDispComp decimal(15,2), Devengado decimal(15,2), CompSinDev decimal(15,2), PresSinDev decimal(15,2),
		Ejercido decimal(15,2), DevSinEjer decimal(15,2), Pagado decimal(15,2), EjerSinPagar decimal(15,2),	Deuda decimal(15,2), PorcAprobAnual decimal(15,2),
		PorcAprobadocAnt decimal(15,2), NomAprobado decimal(15,2), PorcPVigenteAnual decimal(15,2),	PorcPVigenteAnt decimal(15,2), NomPVigente decimal(15,2))

		INSERT INTO @TResultadoFinalR_18 (Clave1, Descripcion, Clave2, Descripcion2, Clave3, Id, Descripcion3,	Clave4, Descripcion4, Autorizado, TransferenciaAmp, 
		TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev,
		Ejercido, DevSinEjer, Pagado, EjerSinPagar,	Deuda, PorcAprobAnual, PorcAprobadocAnt, NomAprobado, PorcPVigenteAnual, PorcPVigenteAnt, NomPVigente)

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
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo 
		ON C_EP_Ramo.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO = T_SellosPresupuestales.Proyecto  left JOIN C_PartidasPres  
		ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal  
		ON C_ClasificadorGeograficoPresupuestal.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		where  (Mes BETWEEN @Mes and @Mes2) AND LYear=@Ejercicio  and (C_RamoPresupuestal.CLAVE >= case when @Clave = '' then C_RamoPresupuestal.CLAVE else @Clave end and C_RamoPresupuestal.CLAVE <= case when @Clave2 = '' then C_RamoPresupuestal.CLAVE else @Clave2 end ) AND C_EP_Ramo.Id = case when @IdEP = '' then C_EP_Ramo.id else @IdEP end
		group by C_ClasificadorGeograficoPresupuestal.Clave,C_ClasificadorGeograficoPresupuestal.Descripcion, C_RamoPresupuestal.CLAVE, C_RamoPresupuestal.DESCRIPCION ,C_EP_Ramo.Clave , C_EP_Ramo.Nombre, C_EP_Ramo.Id ,T_SellosPresupuestales.IdProyecto, C_ProyectosInversion.CLAVE ,C_ProyectosInversion.nombre 
		Order By C_ClasificadorGeograficoPresupuestal.Clave

		--Columna 1 PorcAprobAnual
		Declare @TPorcAprobAnual_18_1 as Table (PorcAprobAnual1 decimal(15,1), Clave int, Clave4 varchar(Max), ID Int)
		insert into @TPorcAprobAnual_18_1
		Select  sum(isnull(TP.Autorizado,0)) as PorcAprobAnual1, cr.CLAVE, cpi.clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinalR_18 as T18 ON T18.id = cepr.id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  Mes = 0 AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cpi.CLAVE, cepr.Id   

		Declare @TPorcAprobAnual_18_2 as Table (PorcAprobAnual2 decimal(15,1), Clave int, Clave4 varchar(Max), ID Int)
		insert into @TPorcAprobAnual_18_2
		Select  sum(isnull(tp.Autorizado,0))  as PorcAprobAnual2, cr.CLAVE, cpi.clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinalR_18 as T18 ON T18.id = cepr.id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2 ) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cepr.Clave ,cpi.clave, cepr.Id 
		
		--Columna 2 PorcAprobadocAnt
		Declare @TPorcAprobadocAnt_18_1 as Table (PorcAprobadocAnt1 decimal(15,1), Clave int, Clave4 varchar(Max), ID Int)
		insert into @TPorcAprobadocAnt_18_1
		Select  sum(isnull(tp.Autorizado,0))  as PorcAprobadocAnt1, cr.CLAVE, cpi.clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinalR_18 as T18 ON T18.id = cepr.id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio -1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cepr.Clave , cpi.clave, cepr.Id 
		
		Declare @TPorcAprobadocAnt_18_2 as Table (PorcAprobadocAnt2 decimal(15,1), Clave int, Clave4 varchar(Max), ID Int)
		insert into @TPorcAprobadocAnt_18_2
		Select  sum(isnull(tp.Autorizado,0)) as PorcAprobadocAnt1, cr.CLAVE, cpi.clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinalR_18 as T18 ON T18.id = cepr.id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cepr.Clave , cpi.clave, cepr.Id 

		--Columna 3 y 4 NomAprobado
		Declare @TNomAprobado_18_1 as Table (NomAprobado1 decimal(15,1), Clave int, Clave4 varchar(Max), ID Int)
		insert into @TNomAprobado_18_1
		Select  (sum(isnull(tp.Autorizado,0))) as NomAprobado1, cr.CLAVE, cpi.clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinalR_18 as T18 ON T18.id = cepr.id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE,  cepr.Clave , cpi.clave, cepr.id
		
		Declare @TNomAprobado_18_2 as Table (NomAprobado2 decimal(15,1), Clave int, Clave4 varchar(Max), ID Int)
		insert into @TNomAprobado_18_2
		Select  sum(isnull(tp.Autorizado,0)) as NomAprobado2, cr.CLAVE, cpi.clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinalR_18 as T18 ON T18.id = cepr.id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE,  cepr.Clave , cpi.clave, cepr.id
		
		--Columna 5 PorcPVigenteAnual
		Declare @TPorcPVigenteAnual_18_1 as Table (PorcPVigenteAnual1 decimal(15,1), Clave int, Clave4 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnual_18_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual1, cr.CLAVE, cpi.clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinalR_18 as T18 ON T18.id = cepr.id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes = 0) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE,  cepr.Clave , cpi.clave, cepr.Id 

		Declare @TPorcPVigenteAnual_18_2 as Table (PorcPVigenteAnual2 decimal(15,1), Clave int, Clave4 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnual_18_2
		Select (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnual2, cr.CLAVE, cpi.clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinalR_18 as T18 ON T18.id = cepr.id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE,  cepr.Clave , cpi.clave, cepr.id
		
		--Columna 6 PorcPVigenteAnt
		Declare @TPorcPVigenteAnt_18_1 as Table (PorcPVigenteAnt1 decimal(15,1), Clave int, Clave4 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnt_18_1
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt1, cr.CLAVE, cpi.clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinalR_18 as T18 ON T18.id = cepr.id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1 and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE,  cepr.Clave , cpi.clave, cepr.id

		Declare @TPorcPVigenteAnt_18_2 as Table (PorcPVigenteAnt2 decimal(15,1), Clave int, Clave4 varchar(Max), ID Int)
		insert into @TPorcPVigenteAnt_18_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as PorcPVigenteAnt2, cr.CLAVE, cpi.clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinalR_18 as T18 ON T18.id = cepr.id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cepr.Clave , cpi.clave, cepr.id
		
		--Columna 7 y 8 NomPVigente
		Declare @TNomPVigente_18_1 as Table (NomPVigente1 decimal(15,1), Clave int, Clave4 varchar(Max), ID Int)
		insert into @TNomPVigente_18_1
		Select  ((sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0))))) as NomPVigente1, cr.CLAVE, cpi.clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinalR_18 as T18 ON T18.id = cepr.id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio-1  and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE, cepr.Clave , cpi.clave, cepr.id
		
		Declare @TNomPVigente_18_2 as Table (NomPVigente2 decimal(15,1), Clave int, Clave4 varchar(Max), ID Int)
		insert into @TNomPVigente_18_2
		Select  (sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) 
		+ sum(ISNULL(TP.TransferenciaRed,0)))) as NomPVigente2, cr.CLAVE, cpi.clave, cepr.ID
		FROM T_SellosPresupuestales INNER JOIN T_PRESUPUESTONW TP ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		INNER JOIN C_RamoPresupuestal  CR ON CR.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  INNER JOIN C_EP_Ramo cepr
		ON cepr.Id    = T_SellosPresupuestales.IdProyecto INNER JOIN C_ProyectosInversion cpi ON cpi.PROYECTO = T_SellosPresupuestales.Proyecto  
		left JOIN C_PartidasPres  ON C_PartidasPres.IdPartida   = T_SellosPresupuestales.IdPartida  left JOIN C_ClasificadorGeograficoPresupuestal cgp 
		ON cgp.IdClasificadorGeografico = T_SellosPresupuestales.IdClasificadorGeografico  
		LEFT JOIN @TResultadoFinalR_18 as T18 ON T18.id = cepr.id and Clave1 = cr.CLAVE and Clave2= cgp.Clave and Clave3= cepr.Clave and cpi.CLAVE = Clave4
		where  (Mes BETWEEN 1 and @Mes2) AND LYear=@Ejercicio and (cr.CLAVE >= case when @Clave = '' then cr.CLAVE else @Clave end and cr.CLAVE <= case when @Clave2 = '' then cr.CLAVE else @Clave2 end ) AND cepr.Id = case when @IdEP = '' then cepr.id else @IdEP end
		group by cr.CLAVE,  cepr.Clave , cpi.clave, cepr.id

		Select Clave1, Descripcion, Clave2, Descripcion2, Clave3, TResultadoFinal.Id, Descripcion3,	TResultadoFinal.Clave4, Descripcion4, Autorizado, TransferenciaAmp, 
		TransferenciaRed, Modificado, PreComprometido, PresVigSinPreComp, Comprometido, PreCompSinComp, PresDispComp, Devengado, CompSinDev, PresSinDev,
		Ejercido, DevSinEjer, Pagado, EjerSinPagar,	Deuda,
		cast(CASE WHEN isnull(PorcAprobAnual1,0) = 0 THEN 0 ELSE PorcAprobAnual2/ PorcAprobAnual1 END as Decimal(15,2)) PorcAprobAnual,
		cast(case when isnull(PorcAprobadocAnt1,0) = 0 then 0 else (isnull(PorcAprobadocAnt2,0))/ PorcAprobadocAnt1 END as Decimal(15,2)) PorcAprobadocAnt,
		cast(isnull(NomAprobado1,0) - isnull(NomAprobado2,0) as Decimal(15,2)) as NomAprobado,
		cast(case when isnull(PorcPVigenteAnual1,0) = 0 then 0 else (isnull(PorcPVigenteAnual2,0))/ PorcPVigenteAnual1 end as Decimal(15,2)) PorcPVigenteAnual,
		cast(case when isnull(PorcPVigenteAnt1,0) = 0 then 0 else (isnull(PorcPVigenteAnt2,0))/ PorcPVigenteAnt1 end as Decimal(15,2)) PorcPVigenteAnt,
		cast(ISNULL(NomPVigente1,0)- ISNULL(NomPVigente2,0) as Decimal(15,2)) NomPVigente
		from @TResultadoFinalR_18 as TResultadoFinal 
		left outer join @TPorcAprobAnual_18_1 as TPorcAprobAnual1 on TPorcAprobAnual1.clave4 = TResultadoFinal.clave4 and TPorcAprobAnual1.ID = TResultadoFinal.ID 
		left outer join @TPorcAprobAnual_18_2 as TPorcAprobAnual2 on TPorcAprobAnual2.Clave4 = TResultadoFinal.clave4 and TPorcAprobAnual2.ID = TResultadoFinal.ID
		left outer join @TPorcAprobadocAnt_18_1 as TPorcAprobadocAnt1 on TPorcAprobadocAnt1.clave4 = TResultadoFinal.clave4 and TPorcAprobadocAnt1.ID = TResultadoFinal.id
		left outer join @TPorcAprobadocAnt_18_2 as TPorcAprobadocAnt2 on TPorcAprobadocAnt2.clave4 = TResultadoFinal.clave4 and TPorcAprobadocAnt2.ID = TResultadoFinal.id
		left outer join @TNomAprobado_18_1 as TNomAprobado1 on TNomAprobado1.clave4 = TResultadoFinal.clave4 and TNomAprobado1.ID = TResultadoFinal.ID
		left outer join @TNomAprobado_18_2 as TNomAprobado2 on TNomAprobado2.clave4 = TResultadoFinal.clave4 and TNomAprobado2.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_18_1 as TPorcPVigenteAnual1 on TPorcPVigenteAnual1.clave4 = TResultadoFinal.clave4 and TPorcPVigenteAnual1.ID = TResultadoFinal.ID
		left outer join @TPorcPVigenteAnual_18_2 as TPorcPVigenteAnual2 on TPorcPVigenteAnual2.clave4 = TResultadoFinal.clave4 and TPorcPVigenteAnual2.ID = TResultadoFinal.id
		left outer join @TPorcPVigenteAnt_18_1 as TPorcPVigenteAnt1 on TPorcPVigenteAnt1.clave4 = TResultadoFinal.clave4 and TPorcPVigenteAnt1.ID = TResultadoFinal.clave2
		left outer join @TPorcPVigenteAnt_18_2 as TPorcPVigenteAnt2 on TPorcPVigenteAnt2.clave4 = TResultadoFinal.clave4 and TPorcPVigenteAnt2.ID = TResultadoFinal.clave2
		left outer join @TNomPVigente_18_1 as TNomPVigente1 on TNomPVigente1.clave4 = TResultadoFinal.clave4 and TNomPVigente1.ID = TResultadoFinal.id
		left outer join @TNomPVigente_18_2 as TNomPVigente2 on TNomPVigente2.clave4 = TResultadoFinal.clave4 and TNomPVigente2.ID = TResultadoFinal.id
	END
End


GO




EXEC SP_RPT_InformeProgramaEstadoEjercicioPresupuestoEGR
6,6,2015,'','','','',4
