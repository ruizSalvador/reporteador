
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles]    Script Date: 10/23/2013 13:05:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles]    Script Date: 10/23/2013 13:05:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles]
@TipoBien varchar(max),
@Ejercicio Int,
@Periodo Int
AS


IF @TipoBien <>'' BEGIN
SELECT 
C_TipoBien.DescripcionTipoBien,
cast(case
         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
		 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
T_Activos.Descripcion,
1 as Cantidad,
T_Activos.CostoAdquisicion,
C_Maestro.UnidadMedida, 
T_Activos.CostoAdquisicion as Importe,
T_Activos.FechaUA as Fecha

FROM T_Activos
JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdTipoBien = T_Activos.IdTipoBien 

Where  C_TipoBien.DescripcionTipoBien= @TipoBien AND YEAR(T_Activos.FechaUA)=@Ejercicio AND (MONTH(T_Activos.FechaUA )between 1 and @Periodo )
ORDER BY T_Activos.NumeroEconomico

END
IF @TipoBien ='' BEGIN
SELECT 
C_TipoBien.DescripcionTipoBien,
cast(case
         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
		 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
T_Activos.Descripcion,
1 as Cantidad,
T_Activos.CostoAdquisicion,
C_Maestro.UnidadMedida, 
T_Activos.CostoAdquisicion as Importe,
T_Activos.FechaUA as Fecha

FROM T_Activos
 JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
 JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
LEFT OUTER JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdGrupo = T_Activos.CodigoGrupo and  C_Maestro.IdSubGrupo = T_Activos.CodigoSubGrupo
Where YEAR(T_Activos.FechaUA)=@Ejercicio AND (MONTH(T_Activos.FechaUA ) between 1 and @Periodo )
ORDER BY C_TipoBien.DescripcionTipoBien, T_Activos.NumeroEconomico
END


GO


EXEC SP_FirmasReporte 'Libro de Inventarios de Bienes Muebles e Inmuebles'
GO

