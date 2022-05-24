/*
	Bug:	1226
	Date:	2020-01-20
	Author:	PRodriguez
	Comments: SP para reporte de "Ficha Técnica del Indicador del Proyecto Instituciol" 
			  RPT_FichaTecnicaIndicadorProyectoInstitucional
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_FichaTecnicaIndicadorProyectoInstitucional]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[RPT_FichaTecnicaIndicadorProyectoInstitucional]
GO

CREATE PROCEDURE [dbo].[RPT_FichaTecnicaIndicadorProyectoInstitucional]
@Ejercicio int,
@Proyecto  int = 0
AS
BEGIN
	DECLARE @FichaIndicador TABLE (
		IdDefMeta			int,
		Orden				int,
		Clave				varchar(30),
		NombreIndicador		varchar(250),
		DescTipoIndicador	varchar(250),
		DescSentidoMed		varchar(250), 
		DescDimension		varchar(250),
		FormulaDeCalculo	varchar(250),
		DescPeriodicidad	varchar(250),
		DescEntregable		varchar(250),	
		MetaBase1			Decimal(12,4),
		MetaBase2			Decimal(12,4),	
		MetaBase3			Decimal(12,4),	
		MetaBase4			Decimal(12,4),
		Cantidad			Decimal(13,2),
		Observaciones		varchar(255),
		Departamento		varchar(250),
		UnidadAdministrativa varchar(250),	
		NomEmpResp			varchar(250),
		Meta_Ene			Decimal(12,4),
		Meta_Feb			Decimal(12,4),
		Meta_Mar			Decimal(12,4),
		Meta_Abr			Decimal(12,4),
		Meta_May			Decimal(12,4),
		Meta_Jun			Decimal(12,4),
		Meta_Jul			Decimal(12,4),
		Meta_Ago			Decimal(12,4),
		Meta_Sep			Decimal(12,4),
		Meta_Oct			Decimal(12,4),
		Meta_Nov			Decimal(12,4),
		Meta_Dic			Decimal(12,4),
		Porc_Ene			Decimal(12,4),
		Porc_Feb			Decimal(12,4),
		Porc_Mar			Decimal(12,4),
		Porc_Abr			Decimal(12,4),
		Porc_May			Decimal(12,4),
		Porc_Jun			Decimal(12,4),
		Porc_Jul			Decimal(12,4),
		Porc_Ago			Decimal(12,4),
		Porc_Sep			Decimal(12,4),
		Porc_Oct			Decimal(12,4),
		Porc_Nov			Decimal(12,4),
		Porc_Dic			Decimal(12,4)
	)

	DECLARE @DefMetasReporte TABLE (
		IdDefMeta	int, 
		Orden		int, 
		IdPadre		int, 
		MetasHijas  int
	)

	IF @Proyecto != 0 
	BEGIN

		INSERT INTO @DefMetasReporte
		SELECT IdDefMeta, Orden,IdPadre, (SELECT count(*) FROM T_DefinicionMetas WHERE IdPadre = dm.IdDefMeta )
		FROM T_DefinicionMetas dm 
		WHERE dm.Ejercicio = @Ejercicio AND dm.IdDefMeta = @Proyecto  

	
		INSERT INTO @FichaIndicador
		SELECT dm.IdDefMeta,dm.Orden, dm.Clave, 
			   --ISNULL(dm.IdIndicador,0)		 AS Indicador,	
			   ISNULL(i.Nombre,'') AS NombreIndicador, 
			   --ISNULL(i.IdTipoIndicador,0)	 AS TipoIndicador, 
			   CASE WHEN ISNULL(i.IdTipoIndicador,0) != 0 THEN (SELECT DescripcionTipoInd FROM C_TipoIndicador WHERE IdTipoIndicador = i.IdTipoIndicador)
				    ELSE ''
			   END AS 'DescTipoIndicador',  
			   --ISNULL(i.IdSentidoMedicion,0) AS SentidoMed,  
			   CASE WHEN ISNULL(i.IdSentidoMedicion,0) != 0 THEN (SELECT DescripcionSenMed FROM C_SentidoMedicionInd WHERE IdSentidoMedicion = i.IdSentidoMedicion)
				    ELSE ''
			   END AS 'DescSentidoMed',  
			   --ISNULL(i.IdDimension,0)		 AS Dimension,	  			   
			   CASE WHEN ISNULL(i.IdDimension,0) != 0 THEN (SELECT DescripcionDimension FROM C_DimensionInd WHERE IdDimension = i.IdDimension)
				    ELSE ''
			   END AS 'DescDimension', 
			   ISNULL(i.FormulaCalculo,'') AS FormulaDeCalculo,
			   --ISNULL(dm.IdPeriodo,0)        AS Periodicidad,  
			   ISNULL(p.Nombre,'') AS DescPeriodicidad,--ISNULL(dm.IdProdMeta,0)       AS Entregable,   
			   ISNULL(pm.Nombre,'') AS  DescEntregable,
			   dm.MetaBase1, dm.MetaBase2, dm.MetaBase3, dm.MetaBase4,ISNULL(dm.Cantidad,0) 'Cantidad',		   
			   dm.Observaciones, 
			   --ISNULL(dm.IdDepartamento,0) AS IdDepto, 			   
			   CASE WHEN ISNULL(dm.IdDepartamento,0) != 0 THEN (SELECT NombreDepartamento FROM C_Departamentos WHERE IdDepartamento = dm.IdDepartamento)
				    ELSE ''
			   END AS 'Departamento',
			    --ISNULL(d.IdAreaResp,0) AS AreaResp,
			   CASE  WHEN ISNULL(dm.IdDepartamento,0) != 0 THEN (SELECT ar.Nombre FROM C_Departamentos d INNER JOIN C_AreaResponsabilidad ar ON d.IdAreaResp = ar.IdAreaResp  WHERE d.IdDepartamento = dm.IdDepartamento)
			         ELSE ''
			   END AS 'UnidadAdministrativa',  
			    --dm.IdEmpResponsable, 
			   ISNULL(em.nombres+' '+em.ApellidoPaterno+' '+em.ApellidoMaterno,'') AS NomEmpResp,
			   ISNULL(dm.Meta_Ene,0) as 'Meta_Ene', ISNULL(Meta_Feb,0) as 'Meta_Feb', ISNULL(Meta_Mar,0) as 'Meta_Mar',
			   ISNULL(dm.Meta_Abr,0) as 'Meta_Abr', ISNULL(Meta_May,0) as 'Meta_May', ISNULL(Meta_Jun,0) as 'Meta_Jun',
			   ISNULL(dm.Meta_Jul,0) as 'Meta_Jul', ISNULL(Meta_Ago,0) as 'Meta_Ago', ISNULL(Meta_Sep,0) as 'Meta_Sep',			   
			   ISNULL(dm.Meta_Oct,0) as 'Meta_Oct', ISNULL(dm.Meta_Nov,0) as 'Meta_Nov', ISNULL(dm.Meta_Dic,0) as 'Meta_Dic',
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Ene,0)
			        ELSE CAST( (ISNULL(dm.Meta_Ene,0)*100/dm.Cantidad) AS DECIMAL(13,4) ) 
			   END	AS 'Porc_Ene',
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Feb,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Feb,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Feb',	
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Mar,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Mar,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Mar',   			   
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Abr,0)
			        ELSE CAST( (ISNULL(dm.Meta_Abr,0)*100/dm.Cantidad) AS DECIMAL(13,4) )
			   END	AS 'Porc_Abr',
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_May,0)
			        ELSE CAST(  (ISNULL(dm.Meta_May,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_May',	
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Jun,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Jun,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Jun',
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Jul,0)
			        ELSE CAST( (ISNULL(dm.Meta_Jul,0)*100/dm.Cantidad) AS DECIMAL(13,4) )
			   END	AS 'Porc_Jul',
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Ago,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Ago,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Ago',	
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Sep,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Sep,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Sep',   			   
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Oct,0)
			        ELSE CAST( (ISNULL(dm.Meta_Oct,0)*100/dm.Cantidad) AS DECIMAL(13,4) )
			   END	AS 'Porc_Oct',
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Nov,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Nov,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Nov',	
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Dic,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Dic,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Dic'  
		FROM T_DefinicionMetas dm 
			 LEFT JOIN  C_Indicadores i          ON dm.IdIndicador = i.IdIndicador
			 LEFT JOIN  C_Periodicidad p         ON dm.IdPeriodo = p.IdPeriodo
			 LEFT JOIN  C_ProductosMetas pm      ON dm.IdProdMeta = pm.IdProdMeta
			 LEFT JOIN  C_Empleados em           ON dm.IdEmpResponsable = em.numeroEmpleado 
		WHERE dm.Ejercicio = @Ejercicio 
		  AND dm.IdDefMeta =  @Proyecto 
		ORDER BY 1,2 ASC
	END
	ELSE
	BEGIN

		INSERT INTO @DefMetasReporte
		SELECT IdDefMeta, Orden,IdPadre, (SELECT count(*) FROM T_DefinicionMetas WHERE IdPadre = dm.IdDefMeta )
		FROM T_DefinicionMetas dm 
		WHERE dm.Ejercicio = @Ejercicio

		INSERT INTO @FichaIndicador
		SELECT dm.IdDefMeta,dm.Orden, dm.Clave, 
		       --ISNULL(dm.IdIndicador,0)		 AS Indicador,	   
			   ISNULL(i.Nombre,'') AS NombreIndicador, 
			   --ISNULL(i.IdTipoIndicador,0)	 AS TipoIndicador, 
			   CASE WHEN ISNULL(i.IdTipoIndicador,0) != 0 THEN (SELECT DescripcionTipoInd FROM C_TipoIndicador WHERE IdTipoIndicador = i.IdTipoIndicador)
				    ELSE ''
			   END AS 'DescTipoIndicador',  
			   --ISNULL(i.IdSentidoMedicion,0) AS SentidoMed,  
			   CASE WHEN ISNULL(i.IdSentidoMedicion,0) != 0 THEN (SELECT DescripcionSenMed FROM C_SentidoMedicionInd WHERE IdSentidoMedicion = i.IdSentidoMedicion)
				    ELSE ''
			   END AS 'DescSentidoMed',  
			   --ISNULL(i.IdDimension,0)		 AS Dimension,	  			   
			   CASE WHEN ISNULL(i.IdDimension,0) != 0 THEN (SELECT DescripcionDimension FROM C_DimensionInd WHERE IdDimension = i.IdDimension)
				    ELSE ''
			   END AS 'DescDimension', 
			   ISNULL(i.FormulaCalculo,'') AS FormulaDeCalculo, 
			   --ISNULL(dm.IdPeriodo,0)        AS Periodicidad,  
			   ISNULL(p.Nombre,'') AS DescPeriodicidad,--ISNULL(dm.IdProdMeta,0)       AS Entregable,   
			   ISNULL(pm.Nombre,'') AS  DescEntregable,
			   dm.MetaBase1, dm.MetaBase2, dm.MetaBase3, dm.MetaBase4,ISNULL(dm.Cantidad,0) 'Cantidad',		   
			   dm.Observaciones, 
			   --ISNULL(dm.IdDepartamento,0) AS IdDepto, 			   
			   CASE WHEN ISNULL(dm.IdDepartamento,0) != 0 THEN (SELECT NombreDepartamento FROM C_Departamentos WHERE IdDepartamento = dm.IdDepartamento)
				    ELSE ''
			   END AS 'Departamento',
			    --ISNULL(d.IdAreaResp,0) AS AreaResp,
			   CASE  WHEN ISNULL(dm.IdDepartamento,0) != 0 THEN (SELECT ar.Nombre FROM C_Departamentos d INNER JOIN C_AreaResponsabilidad ar ON d.IdAreaResp = ar.IdAreaResp  WHERE d.IdDepartamento = dm.IdDepartamento)
			         ELSE ''
			   END AS 'UnidadAdministrativa', 
			   --dm.IdEmpResponsable, 
			   ISNULL(em.nombres+' '+em.ApellidoPaterno+' '+em.ApellidoMaterno,'') AS NomEmpResp,
			   ISNULL(dm.Meta_Ene,0) as 'Meta_Ene', ISNULL(Meta_Feb,0) as 'Meta_Feb', ISNULL(Meta_Mar,0) as 'Meta_Mar',
			   ISNULL(dm.Meta_Abr,0) as 'Meta_Abr', ISNULL(Meta_May,0) as 'Meta_May', ISNULL(Meta_Jun,0) as 'Meta_Jun',
			   ISNULL(dm.Meta_Jul,0) as 'Meta_Jul', ISNULL(Meta_Ago,0) as 'Meta_Ago', ISNULL(Meta_Sep,0) as 'Meta_Sep',			   
			   ISNULL(dm.Meta_Oct,0) as 'Meta_Oct', ISNULL(dm.Meta_Nov,0) as 'Meta_Nov', ISNULL(dm.Meta_Dic,0) as 'Meta_Dic',
			    CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN  ISNULL(dm.Meta_Ene,0)
			        ELSE  CAST( (ISNULL(dm.Meta_Ene,0)*100/dm.Cantidad) AS DECIMAL(13,4) ) 
			   END	AS 'Porc_Ene',
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Feb,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Feb,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Feb',	
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Mar,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Mar,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Mar',   			   
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Abr,0)
			        ELSE CAST( (ISNULL(dm.Meta_Abr,0)*100/dm.Cantidad) AS DECIMAL(13,4) )
			   END	AS 'Porc_Abr',
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_May,0)
			        ELSE CAST(  (ISNULL(dm.Meta_May,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_May',	
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Jun,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Jun,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Jun',
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Jul,0)
			        ELSE CAST( (ISNULL(dm.Meta_Jul,0)*100/dm.Cantidad) AS DECIMAL(13,4) )
			   END	AS 'Porc_Jul',
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Ago,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Ago,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Ago',	
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Sep,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Sep,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Sep',   			   
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Oct,0)
			        ELSE CAST( (ISNULL(dm.Meta_Oct,0)*100/dm.Cantidad) AS DECIMAL(13,4) )
			   END	AS 'Porc_Oct',
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Nov,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Nov,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Nov',	
			   CASE WHEN ISNULL(dm.Cantidad,0) = 0 THEN ISNULL(dm.Meta_Dic,0)
			        ELSE CAST(  (ISNULL(dm.Meta_Dic,0)*100/dm.Cantidad)  AS DECIMAL(13,4) )
			   END	AS 'Porc_Dic'   
		FROM T_DefinicionMetas dm 
			 LEFT JOIN  C_Indicadores i          ON dm.IdIndicador = i.IdIndicador
			 LEFT JOIN  C_Periodicidad p         ON dm.IdPeriodo = p.IdPeriodo
			 LEFT JOIN  C_ProductosMetas pm      ON dm.IdProdMeta = pm.IdProdMeta
			 LEFT JOIN  C_Empleados em           ON dm.IdEmpResponsable = em.numeroEmpleado 
		WHERE dm.Ejercicio = @Ejercicio  
		  AND dm.IdDefMeta in (SELECT IdDefMeta FROM @DefMetasReporte WHERE MetasHijas = 0) 
		ORDER BY 1,2 ASC
	END
	
	SELECT * 
	FROM @FichaIndicador
	  
END
GO 


 











