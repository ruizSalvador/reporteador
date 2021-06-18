/*
	Bug:	1226
	Author:	PRodriguez
	Date:   2020-02-11
	Comments: Filtro de metas hijas para reporte de ficha de indicadores
		
*/


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_FichaTecnicaIndicadorProyectoInstitucional]'))
DROP VIEW [dbo].[VW_RPT_FichaTecnicaIndicadorProyectoInstitucional]
GO

CREATE VIEW [dbo].[VW_RPT_FichaTecnicaIndicadorProyectoInstitucional] as
 
SELECT dm.IdDefMeta AS ID, dm.Ejercicio, dm.Clave, dm.Descripcion 
FROM T_DefinicionMetas dm 
WHERE (SELECT count(*) FROM T_DefinicionMetas WHERE IdPadre = dm.IdDefMeta ) = 0
 
       
GO 





