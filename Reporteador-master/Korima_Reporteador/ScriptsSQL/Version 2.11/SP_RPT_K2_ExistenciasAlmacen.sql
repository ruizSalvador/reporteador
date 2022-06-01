/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ExistenciasAlmacen]    Script Date: 10/31/2014 16:31:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_ExistenciasAlmacen]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_ExistenciasAlmacen]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ExistenciasAlmacen]    Script Date: 10/31/2014 16:31:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_ExistenciasAlmacen]
@IdAlmacen int,
@ClavePartida int,
@TipoProducto int,
@IdGrupo int,
@IdSubGrupo int,
@IdFamilia int,
@IdSubClase int
AS 

SELECT 
C_Maestro.IdGrupo,
C_Maestro.IdSubGrupo,
C_Maestro.IdFamilia,
C_Maestro.IdSubClase,
C_Maestro.IdCodigoProducto,
C_Maestro.DescripcionGenerica,
Case C_Maestro.TipoProducto
	WHEN 1 THEN 'Consumible'
	WHEN 2 THEN 'Activo Fijo'
	WHEN 4 THEN 'Control'
ELSE '' END AS TipoProducto,
C_Maestro.ClavePartida,
T_ExistenciasAlmacen.Existencia,
Case C_Maestro.PuntodeReorder
	WHEN 0 THEN 'NA'
	ELSE CAST(PuntodeReorder AS varchar(10))
END AS PuntodeReorder,
C_Almacenes.Almacen,
C_PartidasPres.DescripcionPartida
FROM C_Maestro
JOIN T_ExistenciasAlmacen ON
T_ExistenciasAlmacen.IdAlmacen= C_Maestro.NoEntraAlmacen
AND T_ExistenciasAlmacen.IdGrupo=C_Maestro.IdGrupo
AND T_ExistenciasAlmacen.IdSubGrupo=C_Maestro.IdSubGrupo
AND T_ExistenciasAlmacen.IdCodigoProducto=C_Maestro.IdCodigoProducto
LEFT OUTER JOIN C_Almacenes 
ON C_Almacenes.IdAlmacen= T_ExistenciasAlmacen.IdAlmacen
JOIN C_PartidasPres
ON C_PartidasPres.IdPartida= C_Maestro.ClavePartida
WHERE
--Almacen 
T_ExistenciasAlmacen.IdAlmacen=ISNULL(@IdAlmacen,T_ExistenciasAlmacen.IdAlmacen)
AND
--Partida
C_Maestro.ClavePartida=ISNULL(@ClavePartida,C_Maestro.ClavePartida)
AND
--Tipo
C_Maestro.TipoProducto=ISNULL(@TipoProducto,C_Maestro.TipoProducto)
AND
--Grupo
C_Maestro.IdGrupo=ISNULL(@IdGrupo,C_Maestro.IdGrupo)
AND
--SubGrupo
C_Maestro.IdSubGrupo=ISNULL(@IdSubGrupo,C_Maestro.IdSubGrupo)
AND
--Clase
C_Maestro.IdFamilia=ISNULL(@IdFamilia,C_Maestro.IdFamilia)
AND
--SubClase
C_Maestro.IdSubClase=ISNULL(@IdSubClase,C_Maestro.IdSubClase)

GO

EXEC SP_FirmasReporte 'Existencias en almacén'
GO