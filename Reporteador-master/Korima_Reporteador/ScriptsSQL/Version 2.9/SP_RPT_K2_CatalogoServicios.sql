/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_CatalogoServicios]    Script Date: 09/25/2014 11:48:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_CatalogoServicios]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_CatalogoServicios]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_CatalogoServicios]    Script Date: 09/25/2014 11:48:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_CatalogoServicios]
@PartidaInicial INT,
@PartidaFinal INT,
@Tipo INT,
@Orden VARCHAR(MAX)
AS
BEGIN
DECLARE @consulta NVARCHAR(MAX)
SET @consulta =
'SELECT DescripcionTipoServicio,
IdPartida,
TipoServicio,
CASE TipoServicio
WHEN 3 THEN ''Servicios''
WHEN 4 THEN ''Honorarios''
WHEN 5 THEN ''Obra''
WHEN 6 THEN ''Deuda''
WHEN 7 THEN ''Subsidios''
ELSE '''' END as Tipo
FROM C_TipoServicios' 

IF (@PartidaInicial<>0 OR @PartidaFinal<> 0 OR @Tipo<>0) BEGIN
SET @consulta +=  ' Where '
END

IF @PartidaInicial<>0 OR @PartidaFinal<>0 BEGIN
SET @consulta += ' IdPartida Between '+ CONVERT(VARCHAR(MAX),@PartidaInicial) +  ' AND ' + CONVERT(VARCHAR(MAX),@PartidaFinal)
END

IF @PartidaInicial<>0 AND @PartidaFinal<> 0 AND @Tipo<>0 BEGIN
SET @consulta += ' AND '
END

IF @Tipo<>0 BEGIN
SET @consulta += ' TipoServicio = '+CONVERT(VARCHAR(MAX),@Tipo)
END

SET @consulta += ' ORDER BY '+@Orden

EXEC(@Consulta)
END

GO


/****** Object:  View [dbo].[VW_RPT_K2_PartidasServicios]    Script Date: 09/10/2014 09:08:17 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_PartidasServicios]'))
DROP VIEW [dbo].[VW_RPT_K2_PartidasServicios]
GO

/****** Object:  View [dbo].[VW_RPT_K2_PartidasServicios]    Script Date: 09/10/2014 09:08:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_PartidasServicios] AS
SELECT DISTINCT IdPartida FROM C_TipoServicios

GO


