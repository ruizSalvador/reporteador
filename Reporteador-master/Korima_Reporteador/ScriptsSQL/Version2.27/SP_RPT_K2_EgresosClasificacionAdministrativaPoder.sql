/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_EgresosClasificacionAdministrativaPoder]    Script Date: 11/13/2014 16:21:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_EgresosClasificacionAdministrativaPoder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_EgresosClasificacionAdministrativaPoder]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_EgresosClasificacionAdministrativaPoder]    Script Date: 11/13/2014 16:21:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_K2_EgresosClasificacionAdministrativaPoder 1,4,2016,0,1
CREATE PROCEDURE [dbo].[SP_RPT_K2_EgresosClasificacionAdministrativaPoder]
@MesInicio INT,
@MesFin INT,
@Ejercicio INT,
@IdArea as INT,
@AmpRedAnual as INT

AS
DECLARE @Anual TABLE(Clave VARCHAR(5),Aprobado DECIMAL (18,2), AmpliacionesReducciones decimal (18,2))
Insert into @Anual
SELECT CR.CLAVE,
SUM(ISNULL(TP.Autorizado,0)) as Aprobado,
(SUM(ISNULL(TP.Ampliaciones,0)) + SUM(ISNULL(TP.TransferenciaAmp,0)))- 
(SUM(ISNULL(TP.Reducciones,0)) + SUM(ISNULL(TP.TransferenciaRed,0))) as AmpliacionesReducciones
FROM T_PresupuestoNW  TP
INNER JOIN T_SellosPresupuestales TS 
ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 

WHERE  (Mes = 0) AND LYear=@Ejercicio AND  Year=@Ejercicio AND CR.CLAVE in ('11111','11112','11113','11114',
'21111','21112','21113','21114','31111')
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END

GROUP BY CR.CLAVE
ORDER BY CR.CLAVE
--Tabla de Titulos vacios
DECLARE @Titulos TABLE(Clave VARCHAR(5),Descripcion VARCHAR(max),
Aprobado DECIMAL (15,2), AmpliacionesReducciones DECIMAL(15,2),Modificado DECIMAL(15,2),Devengado DECIMAL(15,2),Pagado DECIMAL(15,2),SubEjercicio DECIMAL(15,2))
INSERT @Titulos values('11111','Poder Ejecutivo',null,null,null,null,null,null)
INSERT @Titulos values('11112','Poder Legislativo',null,null,null,null,null,null)
INSERT @Titulos values('11113','Poder Judicial',null,null,null,null,null,null)
INSERT @Titulos values('11114','Órganos Autónomos',null,null,null,null,null,null)

--Tabla de Recuperacion de Valores
DECLARE @Valores TABLE(Clave VARCHAR(5),
Aprobado DECIMAL (18,2), AmpliacionesReducciones DECIMAL(15,2),Modificado DECIMAL(15,2),Devengado DECIMAL(15,2),Pagado DECIMAL(15,2),SubEjercicio DECIMAL(15,2))
INSERT INTO @Valores 
SELECT CR.CLAVE,
SUM(ISNULL(TP.Autorizado,0)) as Aprobado,  
(SUM(ISNULL(TP.Ampliaciones,0)) + SUM(ISNULL(TP.TransferenciaAmp,0)))- 
(SUM(ISNULL(TP.Reducciones,0)) + SUM(ISNULL(TP.TransferenciaRed,0))) as AmpliacionesReducciones, 
SUM(ISNULL(TP.Autorizado,0)) +
((SUM(ISNULL(TP.Ampliaciones,0)) + SUM(ISNULL(TP.TransferenciaAmp,0)))- 
(SUM(ISNULL(TP.Reducciones,0)) + SUM(ISNULL(TP.TransferenciaRed,0))) )as Modificado,
SUM(ISNULL(TP.Devengado,0)) as Devengado, 
SUM(ISNULL(TP.Pagado,0)) as Pagado,
(SUM(ISNULL(TP.Autorizado,0)) + (SUM(ISNULL(TP.Ampliaciones,0)) + SUM(ISNULL(TP.TransferenciaAmp,0))) - (SUM(ISNULL(TP.Reducciones,0)) + SUM(ISNULL(TP.TransferenciaRed,0))))-
SUM(ISNULL(TP.Devengado,0)) as SubEjercicio
FROM T_PresupuestoNW  TP
INNER JOIN T_SellosPresupuestales TS 
ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
INNER JOIN C_RamoPresupuestal CR
ON CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 

WHERE  (Mes BETWEEN  @MesInicio AND @MesFin) AND LYear=@Ejercicio AND  Year=@Ejercicio AND CR.CLAVE in ('11111','11112','11113','11114',
'21111','21112','21113','21114','31111')
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
GROUP BY CR.CLAVE
ORDER BY CR.CLAVE

--Se actualizan los montos en la tabla de titulos
UPDATE @Titulos  
SET T.Aprobado=T2.Aprobado,
	T.AmpliacionesReducciones= T2.AmpliacionesReducciones,
	T.Modificado=T2.Modificado,
	T.Devengado=T2.Devengado,
	T.Pagado=T2.Pagado,
	T.SubEjercicio=T2.SubEjercicio
FROM @Titulos T
JOIN @Valores T2
ON substring(T.Clave,2,5)=substring(T2.Clave,2,5)

--INSERT @Titulos 
--select '','Total del Gasto',
--SUM(Aprobado),
--SUM(AmpliacionesReducciones),
--SUM(Modificado),
--SUM(Devengado),
--SUM(Pagado),
--SUM(SubEjercicio)
--FROM @Titulos

--Consulta Final
If @AmpRedAnual = 1
	Begin
		update r set r.Aprobado = a.Aprobado, r.AmpliacionesReducciones = a.AmpliacionesReducciones FROM @Anual a, @Titulos r Where substring(a.Clave,2,5) =  substring(r.Clave,2,5)
	End
--Else
--	Begin
--		update r set r.Aprobado = a.Aprobado FROM @Anual a, @Titulos r Where substring(a.Clave,2,5) =  substring(r.Clave,2,5)
--	End 
SELECT * FROM @Titulos

GO

exec SP_FirmasReporte 'Estado Analítico del Ejercicio del Presupuesto de Egresos Por Poder'
GO
Exec SP_CFG_LogScripts 'SP_RPT_K2_EgresosClasificacionAdministrativaPoder'
GO


