
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Conceptos_Percepciones_Deducciones]    Script Date: 11/05/2013 11:59:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Conceptos_Percepciones_Deducciones]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Conceptos_Percepciones_Deducciones]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Conceptos_Percepciones_Deducciones]    Script Date: 11/05/2013 11:59:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_Conceptos_Percepciones_Deducciones]
@Orden INT
AS
declare @Tabla as table (COG INT, Tipo varchar(max),Concepto varchar(max),IdPartidaGenerica INT,DescripcionPartida varchar(max),Orden INT)

INSERT INTO @Tabla 
	SELECT 
	C_PartidasPres.IdPartida as COG,
	CASE C_ConceptosNomina.Tipo
	WHEN 'P' THEN 'Percepción' 
	WHEN 'O' THEN 'Oblicación' 
	WHEN 'D' THEN 'Deducción'END AS Tipo,
	C_ConceptosNomina.Descripcion AS Concepto,
	substring(convert(varchar(max),C_PartidasPres.IdPartidaGenerica),1, len(C_PartidasPres.IdPartidaGenerica)-1)as IdPartidaGenerica,
	--C_PartidasPres.IdPartidaGenerica,
	C_PartidasPres.DescripcionPartida,
	CASE C_ConceptosNomina.Tipo
	WHEN 'P' THEN 1
	WHEN 'O' THEN 2 
	WHEN 'D' THEN 3 END AS Orden
	FROM C_ConceptosNomina
	LEFT OUTER JOIN C_PartidasPres ON C_PartidasPres.IdPartida = C_ConceptosNomina.IdPartida 
	WHERE C_ConceptosNomina.Tipo <>'O'
IF @Orden=0 BEGIN
	
	select COG,Tipo,Concepto,IdPartidaGenerica,DescripcionPartida, 
	'' AS Notas1,
	'' AS Notas2,
	'' AS Notas3,
	--convert(varchar(max),ROW_NUMBER ()over(ORDER BY Orden, COG))+ ' Click Aqui...' AS Notas1,
	--convert(varchar(max),ROW_NUMBER ()over(ORDER BY Orden, COG))+ ' Click Aqui...' AS Notas2,
	--convert(varchar(max),ROW_NUMBER ()over(ORDER BY Orden, COG))+ ' Click Aqui...' AS Notas3,
	Orden
	from @Tabla
	ORDER BY Orden, COG
END

IF @Orden=1 BEGIN
	select COG,Tipo,Concepto,IdPartidaGenerica,DescripcionPartida, 
	'' AS Notas1,
	'' AS Notas2,
	'' AS Notas3,
	--convert(varchar(max),ROW_NUMBER ()over(ORDER BY COG))+ ' Click Aqui...' AS Notas1,
	--convert(varchar(max),ROW_NUMBER ()over(ORDER BY COG))+ ' Click Aqui...' AS Notas2,
	--convert(varchar(max),ROW_NUMBER ()over(ORDER BY COG))+ ' Click Aqui...' AS Notas3,
	Orden
	from @Tabla
	ORDER BY COG
END 

	



GO


EXEC SP_FirmasReporte 'Catálogo de Conceptos de Percepciones y Deducciones'
GO

