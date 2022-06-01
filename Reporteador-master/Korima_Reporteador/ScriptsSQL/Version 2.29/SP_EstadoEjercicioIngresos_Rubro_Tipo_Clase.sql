/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_Rubro_Tipo_Clase]    Script Date: 12/28/2012 10:45:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoEjercicioIngresos_Rubro_Tipo_Clase]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_Rubro_Tipo_Clase]
GO

/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_Rubro_Tipo_Clase]    Script Date: 12/28/2012 10:45:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_Rubro_Tipo_Clase]
@MesInicio as int,
@MostrarVacios as bit,
@MesFin as int,
@Ejercicio as int,
@AprAnual as bit,
@AmpRedAnual as bit

AS
BEGIN

Declare @PresupuestoFlujo as TABLE(
Ejercicio int,
IdPartida int,
Mes Int,
Estimado decimal(13,2),
Ampliaciones decimal(13,2),
Reducciones decimal(13,2),
Modificado decimal(13,2),
Devengado decimal(13,2),
Recaudado decimal(13,2),
PorRecaudar decimal(13,2)
)

Declare @Resultado as TABLE(
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2)
)
--
INSERT INTO @PresupuestoFlujo 
SELECT * from T_PresupuestoFlujo
where (mes between @MesInicio and @MesFin ) and Ejercicio = @Ejercicio 
--
INSERT INTO @Resultado 
--RUBRO
SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_3.Clave as Clave,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,3) as Grupo3,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes
FROM         @PresupuestoFlujo MovimientosPresupuesto LEFT OUTER JOIN
                      C_PartidasGastosIngresos 
                      ON MovimientosPresupuesto.Idpartida = C_PartidasGastosIngresos.IdPartidaGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto 
                      ON C_PartidasGastosIngresos.IdClasificacionGI = C_ClasificacionGasto.IdClasificacionGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_1 
                      ON C_ClasificacionGasto.IdClasificacionGIPadre = C_ClasificacionGasto_1.IdClasificacionGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_2 
                      ON C_ClasificacionGasto_1.IdClasificacionGIPadre = C_ClasificacionGasto_2.IdClasificacionGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_3 
                      ON C_ClasificacionGasto_2.IdClasificacionGIPadre = C_ClasificacionGasto_3.IdClasificacionGI 
GROUP BY C_ClasificacionGasto_3.Descripcion, C_ClasificacionGasto_3.Clave 
UNION

--TIPO
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,3) as Grupo3,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes
FROM         @PresupuestoFlujo MovimientosPresupuesto  LEFT OUTER JOIN
                      C_PartidasGastosIngresos 
                      ON MovimientosPresupuesto.IdPartida = C_PartidasGastosIngresos.IdPartidaGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto 
                      ON C_PartidasGastosIngresos.IdClasificacionGI = C_ClasificacionGasto.IdClasificacionGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_1 
                      ON C_ClasificacionGasto.IdClasificacionGIPadre = C_ClasificacionGasto_1.IdClasificacionGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_2 
                      ON C_ClasificacionGasto_1.IdClasificacionGIPadre = C_ClasificacionGasto_2.IdClasificacionGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_3 
                      ON C_ClasificacionGasto_2.IdClasificacionGIPadre = C_ClasificacionGasto_3.IdClasificacionGI 

GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre
UNION
--CLASE                      
SELECT      C_ClasificacionGasto_1.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_1.Clave,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,3) as Grupo3, 
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes
FROM         @PresupuestoFlujo MovimientosPresupuesto RIGHT OUTER JOIN
                      C_PartidasGastosIngresos 
                      ON MovimientosPresupuesto.IdPartida = C_PartidasGastosIngresos.IdPartidaGI 
                      INNER JOIN
                      C_ClasificacionGasto 
                      ON C_PartidasGastosIngresos.IdClasificacionGI = C_ClasificacionGasto.IdClasificacionGI 
                      INNER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_1 
                      ON C_ClasificacionGasto.IdClasificacionGIPadre = C_ClasificacionGasto_1.IdClasificacionGI 
                      INNER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_2 
                      ON C_ClasificacionGasto_1.IdClasificacionGIPadre = C_ClasificacionGasto_2.IdClasificacionGI 
                      INNER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_3 
                      ON C_ClasificacionGasto_2.IdClasificacionGIPadre = C_ClasificacionGasto_3.IdClasificacionGI 

GROUP BY C_ClasificacionGasto_1.Descripcion, C_ClasificacionGasto_1.Clave
--ORDER BY C_ClasificacionGasto_1.Clave
--
UPDATE @Resultado set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado set Grupo3= SUBSTRING(Clave,1,3)
--
--Clase
INSERT INTO @Resultado (Clave, Clasificacion,Grupo1,Grupo2,Grupo3)
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3  
From C_ClasificacionGasto as gast
where gast.Nivel=4 and gast.Descripcion NOT IN( select clasificacion from @Resultado)
--
--TIPO
INSERT INTO @Resultado (Clave, Clasificacion,Grupo1,Grupo2)
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2 
From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Descripcion NOT IN( select clasificacion from @Resultado)
--
--Rubro
INSERT INTO @Resultado (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado)

UPDATE @Resultado set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado set Grupo3= SUBSTRING(Clave,1,3)
UPDATE @Resultado set Grupo1= '0' where LEN(Clave)=4 or SUBSTRING(clave,1,1)='0'
UPDATE @Resultado set Grupo2= '0' +SUBSTRING(clave,1,1) where LEN(clave)=4
UPDATE @Resultado set Grupo3= '0' +SUBSTRING(clave,1,2) where LEN(clave)=4
--
Delete from @Resultado where Clave not like '___00' and LEN(Clave)=5
Delete from @Resultado where Clave not like '___0' and LEN(Clave)=4


-- Red/Amp Acumuladas
DECLARE @AcumAnual AS TABLE (Clasificacion varchar(255), Clave int, Estimado decimal(18,2), AmpliacionesReducciones decimal(18,2))
		INSERT INTO @AcumAnual
		SELECT C_Clas3.Descripcion, C_Clas3.Clave, SUM(Estimado) AS Estimado_Total, --C_Clas3.IdClasificacionGI, C_Clas3.IdClasificacionGIPadre
		SUM (isnull(Ampliaciones,0) )- SUM (isnull(Reducciones,0)) AS AmpliacionesReducciones
		FROM T_PresupuestoFlujo TP LEFT OUTER JOIN C_PartidasGastosIngresos TS ON TP.IdPartida  = TS.IdPartidaGI 
		LEFT OUTER JOIN C_ClasificacionGasto C_Clas ON TS.IdClasificacionGI = C_Clas.IdClasificacionGI 
		LEFT OUTER JOIN C_ClasificacionGasto C_Clas1
		ON C_Clas.IdClasificacionGIPadre = C_Clas1.IdClasificacionGI LEFT OUTER JOIN C_ClasificacionGasto C_Clas2
		ON C_Clas1.IdClasificacionGIPadre = C_Clas2.IdClasificacionGI LEFT OUTER JOIN C_ClasificacionGasto C_Clas3
		ON C_Clas2.IdClasificacionGIPadre = C_Clas3.IdClasificacionGI
		WHERE TP.Ejercicio = @Ejercicio AND Mes = 0
		GROUP BY C_Clas3.Descripcion, C_Clas3.Clave
		UNION
		SELECT C_Clas2.Descripcion, C_Clas2.Clave, SUM(Estimado) AS Estimado_Total, --C_Clas3.IdClasificacionGI, C_Clas3.IdClasificacionGIPadre
		SUM (isnull(Ampliaciones,0) )- SUM (isnull(Reducciones,0)) AS AmpliacionesReducciones
		FROM T_PresupuestoFlujo TP LEFT OUTER JOIN C_PartidasGastosIngresos TS ON TP.IdPartida  = TS.IdPartidaGI 
		LEFT OUTER JOIN C_ClasificacionGasto C_Clas ON TS.IdClasificacionGI = C_Clas.IdClasificacionGI 
		LEFT OUTER JOIN C_ClasificacionGasto C_Clas1
		ON C_Clas.IdClasificacionGIPadre = C_Clas1.IdClasificacionGI LEFT OUTER JOIN C_ClasificacionGasto C_Clas2
		ON C_Clas1.IdClasificacionGIPadre = C_Clas2.IdClasificacionGI LEFT OUTER JOIN C_ClasificacionGasto C_Clas3
		ON C_Clas2.IdClasificacionGIPadre = C_Clas3.IdClasificacionGI
		WHERE TP.Ejercicio = @Ejercicio AND Mes = 0
		GROUP BY C_Clas2.Descripcion, C_Clas2.Clave,C_Clas3.IdClasificacionGI,C_Clas3.IdClasificacionGIPadre
		UNION
		SELECT C_Clas1.Descripcion, C_Clas1.Clave, SUM(Estimado) AS Estimado_Total, --C_Clas3.IdClasificacionGI, C_Clas3.IdClasificacionGIPadre
		SUM (isnull(Ampliaciones,0))- SUM (isnull(Reducciones,0)) AS AmpliacionesReducciones
		FROM T_PresupuestoFlujo TP LEFT OUTER JOIN C_PartidasGastosIngresos TS ON TP.IdPartida  = TS.IdPartidaGI 
		LEFT OUTER JOIN C_ClasificacionGasto C_Clas ON TS.IdClasificacionGI = C_Clas.IdClasificacionGI 
		LEFT OUTER JOIN C_ClasificacionGasto C_Clas1
		ON C_Clas.IdClasificacionGIPadre = C_Clas1.IdClasificacionGI LEFT OUTER JOIN C_ClasificacionGasto C_Clas2
		ON C_Clas1.IdClasificacionGIPadre = C_Clas2.IdClasificacionGI LEFT OUTER JOIN C_ClasificacionGasto C_Clas3
		ON C_Clas2.IdClasificacionGIPadre = C_Clas3.IdClasificacionGI
		WHERE TP.Ejercicio = @Ejercicio AND Mes = 0
		GROUP BY C_Clas1.Descripcion, C_Clas1.Clave;

IF @AprAnual = 1
	BEGIN
		
		UPDATE A SET A.Total_Estimado = B.Estimado FROM @Resultado A INNER JOIN @AcumAnual B ON A.Clave = B.Clave
	END

	IF @AmpRedAnual = 1
	BEGIN
		
		UPDATE A SET A.AmpliacionesReducciones = B.AmpliacionesReducciones FROM @Resultado A INNER JOIN @AcumAnual B ON A.Clave = B.Clave
	END


IF @MostrarVacios=1
	BEGIN
		SELECT 
		Clave,
		Clasificacion,
		isnull(Total_Estimado,0) as Total_Estimado,
		isnull(Total_Modificado,0) as Total_Modificado,
		isnull(Total_Devengado,0) as Total_Devengado,
		isnull(Total_Recaudado,0) as Total_Recaudado,
		isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0)as PorRecaudar,
		isnull((Total_Modificado/nullif(Total_Estimado,0)),0) as PorcModificado,
		isnull((Total_Devengado/nullif(Total_Estimado,0)),0)as PorcDevengado,
		isnull((Total_Recaudado/nullif(Total_Estimado + AmpliacionesReducciones,0)),0)as PorcRecaudado,
		isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
		isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
		isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
		isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
		isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
		isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0) as ResModificado,
		isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0) as ResDevengado,
		isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Modificado),0) from @Resultado where Grupo2 like '_0' ),0) as ResRecaudado,
		(case  when len(clave)= 4 then 10 when substring(clave,1,1)='0' then 10 when len(clave)=5 then Grupo1  end)as Orden,
		Grupo1,
		Grupo2,
		Grupo3,
		isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
		isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes,
		isnull((Select Sum(AmpliacionesReducciones)from @Resultado where Grupo2 like '_0'),0) as SumaAmpliacionesReducciones, 
		isnull((Select SUM(isnull(Total_Recaudado,0))-sum(isnull(Total_Estimado,0)) from @Resultado where Grupo2 like '_0'),0)as SumaExcedentes 
		FROM @Resultado
		ORDER BY Orden,Grupo3
		END
ELSE
	BEGIN
		SELECT 
		Clave,
		Clasificacion,
		isnull(Total_Estimado,0) as Total_Estimado,
		isnull(Total_Modificado,0) as Total_Modificado,
		isnull(Total_Devengado,0) as Total_Devengado,
		isnull(Total_Recaudado,0) as Total_Recaudado,
		isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0)as PorRecaudar,
		isnull((Total_Modificado/nullif(Total_Estimado,0)),0)as PorcModificado,
		isnull((Total_Devengado/nullif(Total_Estimado,0)),0) as PorcDevengado,
		isnull((Total_Recaudado/nullif(Total_Estimado + AmpliacionesReducciones,0)),0) as PorcRecaudado,
		isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
		isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
		isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
		isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
		isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
		isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0) as ResModificado,
		isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0) as ResDevengado,
		isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Modificado),0) from @Resultado where Grupo2 like '_0' ),0)as ResRecaudado,
		(case  when len(clave)= 4 then 10  when len(clave)=5 then Grupo1 when substring(clave,1,1)='0' then 10 end)as Orden,
		Grupo1,
		Grupo2,
		Grupo3,
		isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
		isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes,
		isnull((Select Sum(AmpliacionesReducciones)from @Resultado where Grupo2 like '_0'),0) as SumaAmpliacionesReducciones, 
		isnull((Select SUM(isnull(Total_Recaudado,0))-sum(isnull(Total_Estimado,0)) from @Resultado where Grupo2 like '_0'),0)as SumaExcedentes
		FROM @Resultado
		WHERE Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
		ORDER BY Clave,Grupo3
	END

END 


GO

EXEC SP_FirmasReporte 'Estado sobre el Ejercicio de los Ingresos por Rubro, Tipo y Clase'
GO
Exec SP_CFG_LogScripts 'SP_EstadoEjercicioIngresos_Rubro_Tipo_Clase','2.29'
GO
UPDATE C_Menu SET Utilizar=1 WHERE IdMenu= 1120
GO
