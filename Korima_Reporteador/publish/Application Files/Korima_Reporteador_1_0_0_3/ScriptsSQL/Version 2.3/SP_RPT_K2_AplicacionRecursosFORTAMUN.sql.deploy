/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AplicacionRecursosFORTAMUN]    Script Date: 08/05/2013 10:14:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_AplicacionRecursosFORTAMUN]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_AplicacionRecursosFORTAMUN]
GO


/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AplicacionRecursosFORTAMUN]    Script Date: 08/05/2013 10:14:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_AplicacionRecursosFORTAMUN]
@MesInicio Int,
@MesFin Int,
@Ejercicio Int,
@IdFuenteFinanciamiento Int
AS BEGIN

Declare @Tabla table(
Descripcion varchar(150),
Pagado decimal(11,2),
Nombre varchar(max)
)
INSERT INTO @Tabla 
SELECT C_FuenteFinanciamiento.DESCRIPCION,
SUM(ISNULL(T_PresupuestoNW.Pagado,0)) AS Pagado,
C_EP_Ramo.Nombre

FROM T_PresupuestoNW
JOIN T_SellosPresupuestales 
ON T_PresupuestoNW.IdSelloPresupuestal = T_SellosPresupuestales.IdSelloPresupuestal 
JOIN C_FuenteFinanciamiento
ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = T_SellosPresupuestales.IdFuenteFinanciamiento 
JOIN C_EP_Ramo 
ON C_EP_Ramo.Id = T_SellosPresupuestales.IdProyecto

WHERE (Mes BETWEEN @MesInicio AND @MesFin) 
AND Year=@Ejercicio 
AND C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO =@IdFuenteFinanciamiento 

GROUP BY C_FuenteFinanciamiento.DESCRIPCION, C_EP_Ramo.Nombre
ORDER BY C_FuenteFinanciamiento.DESCRIPCION

SELECT * FROM @Tabla 
END
GO
EXEC SP_FirmasReporte 'Formato de infomación de recursos del FORTAMUN'
GO


