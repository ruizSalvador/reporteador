
/****** Object:  View [dbo].[VW_BI_IngresosXTipo]    Script Date: 10/24/2012 09:40:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BI_IngresosXTipo]'))
DROP VIEW [dbo].[VW_BI_IngresosXTipo]
GO
/****** Object:  View [dbo].[VW_BI_IngresosXTipo]    Script Date: 12/04/2012 09:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_BI_IngresosXTipo]
AS

Select 
CASE WHEN P.Fecha IS NOT NULL THEN P.Fecha
	 WHEN T.Fecha IS NOT NULL THEN T.Fecha
	 WHEN M.Fecha IS NOT NULL THEN M.Fecha
	 WHEN R.Fecha IS NOT NULL THEN R.Fecha
	 WHEN LA.Fecha IS NOT NULL THEN LA.Fecha
	 ELSE P.Fecha 
END as Fecha,
ISNULL(P.c3,'12100') as CvePredial, ISNULL(SUM(P.Total),0) as Predial, ISNULL(T.c3,'12200') as CveTraslado, ISNULL(T.Total,0) as Traslado, ISNULL(M.c3,'61010') as CveMultas, ISNULL(M.Total,0) as Multas, ISNULL(R.c3,'61020') as CveRecargos, ISNULL(R.Total,0) as Recargos,  
ISNULL(LA.c2,'43000') as CveLicenciasAnuncios, ISNULL(LA.Total,0) as LicenciasAnuncios, (ISNULL(SUM(P.Total),0) + ISNULL(T.Total,0) + ISNULL(M.Total,0) + ISNULL(R.Total,0) + ISNULL(LA.Total,0)) as Total
from VW_BI_IngresosXConcepto P 
FULL JOIN (Select c3, ISNULL(SUM(Total),0) as Total, Fecha from VW_BI_IngresosXConcepto where c3 = '12200' and Status <> 'N' Group by c3, Fecha ) as T
ON P.Fecha = T.Fecha
FULL JOIN (Select c3, ISNULL(SUM(Total),0) as Total, Fecha from VW_BI_IngresosXConcepto where c3 = '61010' and Status <> 'N' Group by c3, Fecha ) as M
ON P.Fecha = M.Fecha
FULL JOIN (Select c3, ISNULL(SUM(Total),0) as Total, Fecha from VW_BI_IngresosXConcepto where c3 = '61020' and Status <> 'N' Group by c3, Fecha ) as R
ON P.Fecha = R.Fecha
FULL JOIN (Select c2, ISNULL(SUM(Total),0) as Total, Fecha from VW_BI_IngresosXConcepto where c2 = '43000' and Status <> 'N' Group by c2, Fecha ) as LA
ON P.Fecha = LA.Fecha
where P.c3 = '12100' and Status <> 'N'
Group by P.Fecha, P.c3, T.c3, T.Total, T.Fecha, M.c3, M.Total, M.Fecha, R.c3, R.Total, R.Fecha, La.Fecha, LA.c2, LA.Total

GO


