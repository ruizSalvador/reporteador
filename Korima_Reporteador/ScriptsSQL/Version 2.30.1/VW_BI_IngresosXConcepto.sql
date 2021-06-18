
/****** Object:  View [dbo].[BI_IngresosXConcepto]    Script Date: 12/04/2020 09:40:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BI_IngresosXConcepto]'))
DROP VIEW [dbo].[VW_BI_IngresosXConcepto]
GO
/****** Object:  View [dbo].[VW_BI_IngresosXConcepto]    Script Date: 12/04/2012 09:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_BI_IngresosXConcepto]
AS

SELECT distinct
CF.DESCRIPCION as Tipo,
 C_Clas3.Clave as c1, C_Clas3.Descripcion as d1,
 C_Clas2.Clave as c2,	C_Clas2.Descripcion as d2, 
 C_Clas1.Clave as c3,	C_Clas1.Descripcion as d3, 
 C_Clas.Clave as Concepto,	C_Clas.Descripcion, 
 TRC.GranTotal as Total,
 TRC.Fecha,
 TRC.Status
FROM 
T_RecibosCaja TRC
JOIN
d_recibos as DR ON dr.IdIngreso = TRC.idingreso
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DR.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
		LEFT OUTER JOIN C_ClasificacionGasto C_Clas ON C_PartidasGastosIngresos.IdClasificacionGI = C_Clas.IdClasificacionGI 
		LEFT OUTER JOIN C_ClasificacionGasto C_Clas1
		ON C_Clas.IdClasificacionGIPadre = C_Clas1.IdClasificacionGI LEFT OUTER JOIN C_ClasificacionGasto C_Clas2
		ON C_Clas1.IdClasificacionGIPadre = C_Clas2.IdClasificacionGI LEFT OUTER JOIN C_ClasificacionGasto C_Clas3
		ON C_Clas2.IdClasificacionGIPadre = C_Clas3.IdClasificacionGI
JOIN C_FuenteFinanciamiento CF
ON CF.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento

Group By  CF.DESCRIPCION,C_Clas3.Descripcion, C_Clas3.Clave, C_Clas2.Descripcion, C_Clas2.Clave, C_Clas1.Descripcion, C_Clas1.Clave, C_Clas.Descripcion, C_Clas.Clave,
TRC.GranTotal, TRC.Fecha, TRC.Status


UNION ALL

SELECT distinct
CF.DESCRIPCION as Fuente,
 C_Clas3.Clave as Clave3, C_Clas3.Descripcion as Descripcion3,
 C_Clas2.Clave as Clave2,	C_Clas2.Descripcion as Descripcion2, 
 C_Clas1.Clave as Clave1,	C_Clas1.Descripcion as Descripcion1, 
 C_Clas.Clave as Clave,	C_Clas.Descripcion, 
 SUM(TFACT.TotalFacturado) as TotalFacturado,
		TFACT.Fecha,
		TFACT.Status
FROM 
T_Facturas TFACT
JOIN
D_Facturas as DF ON DF.IdFactura = TFACT.IdFactura
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DF.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
		LEFT OUTER JOIN C_ClasificacionGasto C_Clas ON C_PartidasGastosIngresos.IdClasificacionGI = C_Clas.IdClasificacionGI 
		LEFT OUTER JOIN C_ClasificacionGasto C_Clas1
		ON C_Clas.IdClasificacionGIPadre = C_Clas1.IdClasificacionGI LEFT OUTER JOIN C_ClasificacionGasto C_Clas2
		ON C_Clas1.IdClasificacionGIPadre = C_Clas2.IdClasificacionGI LEFT OUTER JOIN C_ClasificacionGasto C_Clas3
		ON C_Clas2.IdClasificacionGIPadre = C_Clas3.IdClasificacionGI
JOIN C_FuenteFinanciamiento CF
ON CF.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento
Where PagoInmediato in (1,2)

Group By  CF.DESCRIPCION,C_Clas3.Descripcion, C_Clas3.Clave, C_Clas2.Descripcion, C_Clas2.Clave, C_Clas1.Descripcion, C_Clas1.Clave, C_Clas.Descripcion, C_Clas.Clave,
TFACT.Fecha, TFACT.Status, TFACT.PagoInmediato

GO
