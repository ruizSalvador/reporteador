
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Libro_Inventario_Arqueologicos_Artisticos_Historicos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Libro_Inventario_Arqueologicos_Artisticos_Historicos]
GO


/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Libro_Inventario_Arqueologicos_Artisticos_Historicos]    Script Date: 07/14/2015 09:56:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[SP_RPT_K2_Libro_Inventario_Arqueologicos_Artisticos_Historicos]
@TipoBien varchar(max),
@Ejercicio Int,
@Periodo Int
AS


IF @TipoBien <>'' BEGIN

SELECT T_AltaActivos.FechaAlta , T_Activos.IdTipoBien , T_Activos.Observaciones , C_TipoBien.IdCuentaContable, 
C_TipoBien.DescripcionTipoBien, 
T_Activos.Descripcion, T_Activos.NumeroEconomico
FROM T_Activos
JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
LEFT OUTER JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdGrupo = T_Activos.CodigoGrupo and  C_Maestro.IdSubGrupo = T_Activos.CodigoSubGrupo

Where  C_TipoBien.DescripcionTipoBien= @TipoBien AND YEAR(T_Activos.FechaUA)=@Ejercicio AND (MONTH(T_Activos.FechaUA )between 1 and @Periodo )
ORDER BY T_Activos.NumeroEconomico

END
IF @TipoBien ='' BEGIN
SELECT T_AltaActivos.FechaAlta , T_Activos.IdTipoBien , T_Activos.Observaciones , C_TipoBien.IdCuentaContable, 
C_TipoBien.DescripcionTipoBien, 
T_Activos.Descripcion, T_Activos.NumeroEconomico
FROM T_Activos
 JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
 JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
LEFT OUTER JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdGrupo = T_Activos.CodigoGrupo and  C_Maestro.IdSubGrupo = T_Activos.CodigoSubGrupo
Where YEAR(T_Activos.FechaUA)=@Ejercicio AND (MONTH(T_Activos.FechaUA ) between 1 and @Periodo )
and C_TipoBien.IdTipoBien  in (11,12,13,21,22,31,32,34,33)
ORDER BY C_TipoBien.DescripcionTipoBien, T_Activos.NumeroEconomico
END


