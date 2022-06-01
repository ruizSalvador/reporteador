/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_FAIS]    Script Date: 10/24/2014 13:11:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_FAIS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_FAIS]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_FAIS]    Script Date: 10/24/2014 13:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_FAIS]
@Periodo INT,
@Ejercicio INT,
@IDFUENTEFINANCIAMIENTO INT

AS BEGIN

DECLARE @Resultado TABLE(
IdFuenteFinanciamiento INT,
FuenteFinanciamiento VARCHAR(MAX),
Ramo VARCHAR(MAX),
Costo DECIMAL(18,4),
IdClasificadorgeografico INT,
Nivel INT,
Entidad VARCHAR(MAX),
Municipio VARCHAR(MAX),
Localiad VARCHAR(MAX),
MontoIngresos Decimal (18,4)
)

DECLARE @MesInicio INT
DECLARE @MesFin INT

--Enero a Marzo
If @Periodo =1 SET @MesInicio=1 SET @MesFin=3
--Abril a Junio
If @Periodo =2 SET @MesInicio=4 SET @MesFin=6
--Julio a Septiembre
If @Periodo =3 SET @MesInicio=7 SET @MesFin=9
--Octubre a Diciembre
If @Periodo =4 SET @MesInicio=10 SET @MesFin=12
--Anual
If @Periodo =5 SET @MesInicio=1 SET @MesFin=12

Declare @FuenteFinanciamiento VARCHAR(150)
SET @FuenteFinanciamiento=(Select DESCRIPCION FROM C_FuenteFinanciamiento where IDFUENTEFINANCIAMIENTO = @IDFUENTEFINANCIAMIENTO)

DECLARE @Ingresos AS TABLE (
Clave varchar(7),
Clasificacion varchar(MAx),
FuenteFinanciamiento varchar(max),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
PorRecaudar decimal (15,2),
PorcModificado decimal (15,2),
PorcDevengado decimal (15,4),
PorcRecaudado decimal (15,4),
SumaPorRecaudar decimal (15,2),
SumaEstimado decimal (15,2),
SumaModificado decimal (15,2),
SumaDevengado decimal (15,2),
SumaRecaudado decimal (15,2),
ResModificado decimal (15,2),
ResDevengado decimal (15,2),
ResRecaudado decimal (15,4),
Orden varchar(Max),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal(15,2),
SumaGrupos decimal(15,4))

INSERT INTO @Ingresos
EXEC SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento
@MesInicio,
0,
@MesFin,
@FuenteFinanciamiento,
@Ejercicio

INSERT @Resultado
SELECT  
C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO,
C_FuenteFinanciamiento.Descripcion as FuenteFinanciamiento,
--C_FuenteFinanciamiento.Clave AS ClaveFuenteFinanciamiento,
--C_EP_Ramo.Clave AS ClaveRamo,
C_EP_Ramo.Nombre AS Ramo,
sum (T_PresupuestoNW.Devengado) AS Costo,
C_ClasificadorGeograficoPresupuestal.IdClasificadorgeografico,
C_ClasificadorGeograficoPresupuestal.Nivel,
	CASE C_ClasificadorGeograficoPresupuestal.Nivel
		WHEN 0 THEN C_ClasificadorGeograficoPresupuestal.Descripcion 
		WHEN 1 THEN ( SELECT b.Descripcion FROM C_ClasificadorGeograficoPresupuestal a
					JOIN C_ClasificadorGeograficoPresupuestal b
					ON b.idclasificadorgeografico=a.idclasificadorgeograficoPadre 
					WHERE a.IdClasificadorGeografico=C_ClasificadorGeograficoPresupuestal.IdClasificadorGeografico)
		WHEN 2 THEN (SELECT c.Descripcion FROM C_ClasificadorGeograficoPresupuestal a
					JOIN C_ClasificadorGeograficoPresupuestal b
					ON b.idclasificadorgeografico=a.idclasificadorgeograficoPadre
					JOIN C_ClasificadorGeograficoPresupuestal c					
					ON c.idclasificadorgeografico=b.idclasificadorgeograficoPadre 
					WHERE a.IdClasificadorGeografico=C_ClasificadorGeograficoPresupuestal.IdClasificadorGeografico)								
	END AS Entidad,
 
	CASE C_ClasificadorGeograficoPresupuestal.Nivel
		WHEN 0 THEN C_ClasificadorGeograficoPresupuestal.Descripcion 
		WHEN 1 THEN C_ClasificadorGeograficoPresupuestal.Descripcion 
		WHEN 2 THEN (SELECT b.Descripcion FROM C_ClasificadorGeograficoPresupuestal a
					JOIN C_ClasificadorGeograficoPresupuestal b
					ON b.idclasificadorgeografico=a.idclasificadorgeograficoPadre
					JOIN C_ClasificadorGeograficoPresupuestal c
					ON c.idclasificadorgeografico=b.idclasificadorgeograficoPadre 
					WHERE a.IdClasificadorGeografico=C_ClasificadorGeograficoPresupuestal.IdClasificadorGeografico)
	END AS Municipio,
 
	CASE C_ClasificadorGeograficoPresupuestal.Nivel
		WHEN 0 THEN C_ClasificadorGeograficoPresupuestal.Descripcion 
		WHEN 1 THEN C_ClasificadorGeograficoPresupuestal.Descripcion 
		WHEN 2 THEN C_ClasificadorGeograficoPresupuestal.Descripcion 
	END AS Localidad,
	0 as MontoIngresos
	
FROM C_FuenteFinanciamiento 
JOIN T_SellosPresupuestales 
ON T_SellosPresupuestales.IdFuenteFinanciamiento=C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO
JOIN C_EP_Ramo 
ON C_EP_Ramo.Id= T_SellosPresupuestales.IdProyecto
JOIN C_ClasificadorGeograficoPresupuestal
ON C_ClasificadorGeograficoPresupuestal.IdClasificadorGeografico= T_SellosPresupuestales.IdClasificadorGeografico
JOIN T_PresupuestoNW
ON  T_PresupuestoNW.IdSelloPresupuestal = T_SellosPresupuestales.IdSelloPresupuestal

WHERE  C_EP_Ramo. Nivel =5 
AND C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO=@IDFUENTEFINANCIAMIENTO 
AND T_PresupuestoNW.Year=@Ejercicio
AND mes BETWEEN @MesInicio 
AND @MesFin
GROUP BY C_EP_Ramo.Clave,C_FuenteFinanciamiento.Clave,C_ClasificadorGeograficoPresupuestal.IdClasificadorgeografico 
--,T_PresupuestoNW.Devengado
,C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO
,C_FuenteFinanciamiento.DESCRIPCION,C_EP_Ramo.Nombre,C_ClasificadorGeograficoPresupuestal.IdClasificadorGeograficoPadre,
C_ClasificadorGeograficoPresupuestal.Nivel, C_ClasificadorGeograficoPresupuestal.Descripcion 
END

UPDATE @Resultado SET MontoIngresos= (SELECT TOP(1) Total_Recaudado FROM @Ingresos)

SELECT * FROM @Resultado 

GO

EXEC SP_FirmasReporte 'Montos que reciban, obras y acciones a realizar con el FAIS'
GO
