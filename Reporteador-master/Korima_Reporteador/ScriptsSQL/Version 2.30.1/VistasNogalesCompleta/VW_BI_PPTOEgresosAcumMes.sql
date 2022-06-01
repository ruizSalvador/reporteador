
/****** Object:  View [dbo].[VW_BI_PPTOEgresosAcumMes]    Script Date: 10/24/2012 09:40:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BI_PPTOEgresosAcumMes]'))
DROP VIEW [dbo].[VW_BI_PPTOEgresosAcumMes]
GO
/****** Object:  View [dbo].[VW_BI_PPTOEgresosAcumMes]    Script Date: 10/24/2012 09:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_BI_PPTOEgresosAcumMes]
AS

Select 
TP.Year as Periodo, TP.Mes,
LEFT(CA.Clave,2) as Dependencia,
--CA.Nombre as NombreDependencia,
CASE LEFT(CA.Clave,2) WHEN  '01' THEN 'OFICINA DE REGIDORES'
WHEN '02' THEN 'DESPACHO DEL SINDICO'
WHEN '03' THEN	'DESPACHO DEL PRESIDENTE'
WHEN '04' THEN 'DESPACHO DEL SECRETARIO'
WHEN '05' THEN 'DESPACHO DEL TESORERO'
WHEN '07' THEN 'DESPACHO DEL DIRECTOR DE SERVICIOS PUBLICOS'
WHEN '08' THEN 'DESPACHO DEL DIRECTOR SEGURIDAD PUBLICA'
WHEN '10' THEN 'DESPACHO DEL CONTRALOR'
WHEN '11' THEN 'DESPACHO DEL OFICIAL'
WHEN '13' THEN 'DESPACHO DEL DIRECTOR DE COMUNICACION SOCIAL'
WHEN '14' THEN 'DESPACHO DEL DIRECTOR DE DESARROLLO SOCIAL' 
WHEN '16' THEN 'DESPACHO DEL DIR. DE ECONOMIA' 
WHEN '18' THEN 'DESPACHO DEL SECRETARIO DE OBRAS PUBLICAS'
WHEN '20' THEN 'DESPACHO DEL DIRECTOR JURIDICO'
WHEN '27' THEN 'DESPACHO DEL DIR. INSTITUTO NOGALENSE DEL DEPORTE'
WHEN '30' THEN 'DESPACHO DEL DIRECTOR DE EDUCACION'
WHEN '31' THEN 'DESPACHO DEL DEIRECTOR DE SALUD'
WHEN '32' THEN 'DESPACHO DE DIRECTOR DE IMAGEN URBANA'
WHEN '33' THEN 'DESPACHO DE DIRECTOR DE JUVENTUD'
WHEN '34' THEN 'DESPACHO DE DIRECTOR DE INFOMATICA'
ELSE ''
END AS NombreDependencia,
RIGHT(CA.Clave,2) as CC,
CG.IdCapitulo as Capitulo, 
CG.Descripcion as DescripcionCapitulo,  
CP.IdPartida as Partida, 
CP.DescripcionPartida as NombrePartida, 
CF.CLAVE as Fuente,
CF.DESCRIPCION as NombreFuente,
sum(isnull(TP.Autorizado,0)) as Aprobado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as Ampliaciones, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Reducciones, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
   
SUM(isnull(TP.Precomprometido,0)) AS Reservado,
sum(isnull(TP.Comprometido,0)) as Comprometido, 
sum(isnull(TP.Devengado,0)) as Devengado, 
sum(isnull(TP.Ejercido,0)) as Ejercido,
sum(isnull(TP.Pagado,0)) as Pagado, 
0.00 as DisponibleSinRequis,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(isnull(TP.Comprometido,0)) As Disponible

From T_PresupuestoNW  TP
INNER JOIN T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
INNER JOIN C_AreaResponsabilidad  CA 
on CA.IdAreaResp = TS.IdAreaResp
INNER JOIN C_PartidasPres CP
on CP.IdPartida = TS.IdPartida
LEFT JOIN C_ConceptosNEP CN
on CN.IdConcepto = CP.IdConcepto
LEFT JOIN C_CapitulosNEP CG
on CG.IdCapitulo = CN.IdCapitulo
LEFT JOIN C_FuenteFinanciamiento CF
on CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento

Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo, CP.IdPartida, CP.DescripcionPartida,
TP.Year, TP.Mes, TS.Sello, CF.CLAVE, CF.DESCRIPCION, CA.Clave, CA.Nombre

GO
