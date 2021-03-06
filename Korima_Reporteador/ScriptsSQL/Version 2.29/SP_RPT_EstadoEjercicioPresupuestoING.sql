
/****** Object:  StoredProcedure [dbo].[SP_RPT_EstadoEjercicioPresupuestoING]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_EstadoEjercicioPresupuestoING]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_EstadoEjercicioPresupuestoING]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_EstadoEjercicioPresupuestoING]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RPT_EstadoEjercicioPresupuestoING 1,3,1,2019,'',1,1,1
CREATE PROCEDURE [dbo].[SP_RPT_EstadoEjercicioPresupuestoING] 

@Mes  as int, 
@Mes2 as int,  
@Tipo as int,
@Ejercicio as int,
@ClaveFF as varchar(6),
@Todo as bit,
@AprAnual as bit,
@AmpRedAnual as bit

AS
BEGIN

If @Tipo=1 
BEGIN
Declare @AllData as Table (IdPartida int, 
Clave varchar (100), 
Estimado decimal(18,2), 
Ampliaciones decimal (18,2),
 Reducciones decimal (18,2), 
 Modificado decimal (18,2),
 Devengado decimal (18,2),
 Recaudado decimal (18,2),  
 PorRecaudar decimal (18,2),
 Avance decimal (18,2),
 AvanceTotal decimal (18,2))
--VALORES ABSOLUTOS
--Consulta para Reporte General Estado del Ejercicio del Presupuesto 



IF @Todo = 1
	BEGIN
		INSERT INTO @AllData 
			Select TP.IdPartida  , TS.Clave as Clave , 
			sum(ISNULL(TP.Estimado,0)) as Estimado, 
			sum(ISNULL(TP.Ampliaciones ,0)) as Ampliaciones, 
			sum(ISNULL(TP.Reducciones ,0)) as Reducciones, 
			sum(ISNULL(TP.Modificado ,0)) as Modificado,
			sum(ISNULL(TP.Devengado ,0)) as Devengado,
			sum(ISNULL(TP.Recaudado ,0)) as Recaudado,  
			sum(ISNULL(TP.PorRecaudar  ,0)) as PorRecaudar,
		CASE sum(ISNULL(TP.Devengado ,0)) WHEN 0 THEN 0
		ELSE (sum(ISNULL(TP.Recaudado ,0)) * 100) /Nullif(sum(ISNULL(TP.Devengado ,0)),0)
		END as Avance,
		(SELECT (sum(ISNULL(TP2.Recaudado ,0)) * 100) / Nullif(sum(ISNULL(TP2.Devengado ,0)),0)   as AvanceTotal  FROM T_PresupuestoFlujo  As TP2
			WHERE  (Mes BETWEEN @Mes AND @Mes2) AND TP2.Ejercicio  =@Ejercicio) AS AvanceTotal		 
		FROM T_PresupuestoFlujo  As TP, C_PartidasGastosIngresos  As TS 
		WHERE TP.IdPartida  = TS.IdPartidaGI
		and   (Mes BETWEEN @Mes AND @Mes2) AND TP.Ejercicio  =@Ejercicio
		GROUP BY TP.IdPartida, TS.Clave--,Devengado, Recaudado
	UNION ALL
		SELECT  TS.IdPartidaGI as IdPartida, TS.Clave as Clave,
			0 as Estimado, 
			0 as Ampliaciones, 
			0 as Reducciones, 
			0 as Modificado,
			0 as Devengado,
			0 as Recaudado,  
			0 as PorRecaudar,
			0 as Avance,
			0 as AvanceTotal		 
		 FROM C_PartidasGastosIngresos  As TS 
		 ORDER BY TP.IdPartida

		--SELECT  
		--	IdPartida, 
		--	Clave, 
		--	SUM(Estimado) as Estimado, 
		--	SUM(Ampliaciones) as Ampliaciones,
		--	SUM(Reducciones) as Reducciones, 
		--	SUM(Modificado) as Modificado,
		--	SUM(Devengado) as Devengado,
		--	SUM(Recaudado) as Recaudado,  
		--	SUM(PorRecaudar) as PorRecaudar,
		--	SUM(Avance) as Avance,
		--	SUM(AvanceTotal) as AvanceTotal 
		--FROM @AllData 
		--GROUP BY IdPartida, Clave
		--ORDER BY IdPartida
	END
ELSE
	BEGIN
	INSERT INTO @AllData
		SELECT TP.IdPartida  , TS.Clave as Clave , 
		sum(ISNULL(TP.Estimado,0)) as Estimado, 
		sum(ISNULL(TP.Ampliaciones ,0)) as Ampliaciones, 
		sum(ISNULL(TP.Reducciones ,0)) as Reducciones, 
		sum(ISNULL(TP.Modificado ,0)) as Modificado,
		sum(ISNULL(TP.Devengado ,0)) as Devengado,
		sum(ISNULL(TP.Recaudado ,0)) as Recaudado,  
		sum(ISNULL(TP.PorRecaudar  ,0)) as PorRecaudar,
		CASE sum(ISNULL(TP.Devengado ,0)) WHEN 0 THEN 0
		ELSE (sum(ISNULL(TP.Recaudado ,0)) * 100) /Nullif(sum(ISNULL(TP.Devengado ,0)),0)
		END AS Avance,
		(SELECT (sum(ISNULL(TP2.Recaudado ,0)) * 100) / Nullif(sum(ISNULL(TP2.Devengado ,0)),0)   as AvanceTotal  FROM T_PresupuestoFlujo  AS TP2
		WHERE  (Mes BETWEEN @Mes AND @Mes2) AND TP2.Ejercicio  =@Ejercicio) AS AvanceTotal		 
		FROM T_PresupuestoFlujo TP, C_PartidasGastosIngresos TS 
		WHERE TP.IdPartida  = TS.IdPartidaGI
		AND (Mes BETWEEN @Mes AND @Mes2) AND TP.Ejercicio  =@Ejercicio
		GROUP BY TP.IdPartida, TS.Clave--,Devengado, Recaudado
		ORDER BY TP.IdPartida

	END

END

--- Red/Amp Acumuladas

IF @AprAnual = 1
	BEGIN
		DECLARE @AcumAnual AS TABLE (IdPartidaGI int, Estimado decimal(18,2))
		INSERT INTO @AcumAnual
		SELECT IdPartidaGI, Estimado FROM T_PresupuestoFlujo TP INNER JOIN C_PartidasGastosIngresos TS ON TP.IdPartida  = TS.IdPartidaGI  WHERE TP.Ejercicio = @Ejercicio AND Mes = 0;

		UPDATE A SET A.Estimado = B.Estimado FROM @AllData A INNER JOIN @AcumAnual B ON A.IdPartida = B.IdPartidaGI

	END

IF @AmpRedAnual = 1
	BEGIN
	Select * from @AllData
	
		DECLARE @AcumAnualAmp AS TABLE (IdPartidaGI int, Ampliaciones decimal(18,2), Reducciones decimal(18,2))
		INSERT INTO @AcumAnualAmp
		SELECT IdPartidaGI, Ampliaciones, Reducciones FROM T_PresupuestoFlujo TP INNER JOIN C_PartidasGastosIngresos TS ON TP.IdPartida  = TS.IdPartidaGI  WHERE TP.Ejercicio = @Ejercicio AND Mes = 0;
		Select * from @AcumAnualAmp
		--SELECT IdPartidaGI, Ampliaciones, Reducciones FROM T_PresupuestoFlujo TP INNER JOIN C_PartidasGastosIngresos TS ON TP.IdPartida  = TS.IdPartidaGI  WHERE TP.Ejercicio = 2019 AND Mes = 0;
		UPDATE A SET A.Ampliaciones = B.Ampliaciones, A.Reducciones = B.Reducciones FROM @AllData A INNER JOIN @AcumAnualAmp B ON A.IdPartida = B.IdPartidaGI

	END

SELECT * FROM @AllData;

END
GO

Exec SP_FirmasReporte 'Clasificación General'
GO
Exec SP_CFG_LogScripts 'SP_RPT_EstadoEjercicioPresupuestoING','2.29'
GO



