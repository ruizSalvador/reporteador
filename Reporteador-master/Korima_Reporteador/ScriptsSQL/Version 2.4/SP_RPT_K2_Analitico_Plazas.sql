/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Analitico_Plazas]    Script Date: 10/31/2013 12:04:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Analitico_Plazas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Analitico_Plazas]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Analitico_Plazas]    Script Date: 10/31/2013 12:04:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_Analitico_Plazas]
AS

SELECT 
T_Nombramientos.IdNombramiento as IdPuesto,
T_Nombramientos.Nombre,
COUNT(C_Plazas.IdPlaza) AS NumeroPlazas
FROM T_Nombramientos 
JOIN C_Plazas ON C_Plazas.IdNombramiento=T_Nombramientos.IdNombramiento 
GROUP BY T_Nombramientos.IdNombramiento,
T_Nombramientos.Nombre
ORDER BY T_Nombramientos.IdNombramiento

--SELECT C_Puestos.IdPuesto,
--C_Puestos.Nombre,
--COUNT(C_Plazas.IdPlaza) AS NumeroPlazas
--FROM C_Puestos 
--JOIN C_Plazas ON C_Plazas.IdPuesto= C_Puestos.IdPuesto
--GROUP BY C_Puestos.IdPuesto,C_Puestos.Nombre--,C_Plazas.NumeroPuesto
--ORDER BY C_Puestos.IdPuesto 

GO

EXEC SP_FirmasReporte 'Analítico de Plazas'
GO



