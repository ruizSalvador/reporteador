/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_EgresosClasificacionAdministrativaParaestatal]    Script Date: 11/13/2014 16:21:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_EgresosClasificacionAdministrativaParaestatal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_EgresosClasificacionAdministrativaParaestatal]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_EgresosClasificacionAdministrativaParaestatal]    Script Date: 11/13/2014 16:21:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RPT_K2_EgresosClasificacionAdministrativaParaestatal 1,12,2016,0,1
CREATE PROCEDURE [dbo].[SP_RPT_K2_EgresosClasificacionAdministrativaParaestatal]
@MesInicio INT,
@MesFin INT,
@Ejercicio INT,
@IdArea INT,
@AmpRedAnual INT

AS
DECLARE @Anual TABLE(Clave VARCHAR(5), Aprobado DECIMAL (18,2), AmpliacionesReducciones decimal(18,2))
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

WHERE  (Mes = 0) AND LYear=@Ejercicio AND  Year=@Ejercicio AND (CR.CLAVE Like '1112%' OR CR.CLAVE Like '2112%' OR CR.CLAVE Like '3112%'
OR CR.CLAVE Like '1113%' OR CR.CLAVE Like '2113%' OR CR.CLAVE Like '3113%'
OR CR.CLAVE Like '1120%' OR CR.CLAVE Like '2120%' OR CR.CLAVE Like '3120%'
OR CR.CLAVE Like '1121%' OR CR.CLAVE Like '2121%' OR CR.CLAVE Like '3121%'
OR CR.CLAVE Like '1122%' OR CR.CLAVE Like '2122%' OR CR.CLAVE Like '3122%'
OR CR.CLAVE in ('12200','12300','12400',
				'22200','22300','22400',
				'32200','32300','32400'))
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
GROUP BY CR.CLAVE 
ORDER BY CR.CLAVE


DECLARE @Anual2 TABLE(Clave VARCHAR(5), Aprobado DECIMAL (18,2), AmpliacionesReducciones decimal(18,2))
Insert into @Anual2
Select 
Substring(Clave,2,3),
SUM(ISNULL(Aprobado,0)) as Aprobado,
SUM(ISNULL(AmpliacionesReducciones,0)) as AmpliacionesReducciones
from @Anual
group by Substring(Clave,2,3)


--Tabla de Titulos vacios NOTA hast 11229
DECLARE @Titulos TABLE(Clave VARCHAR(5),Descripcion VARCHAR(max),
Aprobado DECIMAL (15,2), AmpliacionesReducciones DECIMAL(15,2),Modificado DECIMAL(15,2),Devengado DECIMAL(15,2),Pagado DECIMAL(15,2),SubEjercicio DECIMAL(15,2))
INSERT @Titulos values('11120','Entidades Paraestatales y Fideicomisos No Empresariales y No Financieros',null,null,null,null,null,null)
INSERT @Titulos values('11130','Instituciones Públicas de la Seguridad Social',null,null,null,null,null,null)
INSERT @Titulos values('11200','Entidades Paraestatales Empresariales No Financieras con Participación Estatal Mayoritaria',null,null,null,null,null,null)
INSERT @Titulos values('11220','Fideicomisos Empresariales No Financieros con Participación Estatal Mayoritaria.',null,null,null,null,null,null)
INSERT @Titulos values('12200','Entidades Paraestatales Empresariales Financieras Monetarias con Participación Estatal Mayoritaria.',null,null,null,null,null,null)
INSERT @Titulos values('12300','Entidades Paraestatales Empresariales Financieras No Monetarias con Participación Estatal Mayoritaria.',null,null,null,null,null,null)
INSERT @Titulos values('12400','Fideicomisos Financieros Públicos con Participación Estatal Mayoritaria.',null,null,null,null,null,null)

--Tabla de Recuperacion de Valores
DECLARE @Valores TABLE(Clave VARCHAR(5),
Aprobado DECIMAL (15,2), AmpliacionesReducciones DECIMAL(15,2),Modificado DECIMAL(15,2),Devengado DECIMAL(15,2),Pagado DECIMAL(15,2),SubEjercicio DECIMAL(15,2))
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

WHERE  (Mes BETWEEN  @MesInicio AND @MesFin) AND LYear=@Ejercicio AND  Year=@Ejercicio AND (CR.CLAVE Like '1112%' OR CR.CLAVE Like '2112%' OR CR.CLAVE Like '3112%'
OR CR.CLAVE Like '1113%' OR CR.CLAVE Like '2113%' OR CR.CLAVE Like '3113%'
OR CR.CLAVE Like '1120%' OR CR.CLAVE Like '2120%' OR CR.CLAVE Like '3120%'
OR CR.CLAVE Like '1121%' OR CR.CLAVE Like '2121%' OR CR.CLAVE Like '3121%'
OR CR.CLAVE Like '1122%' OR CR.CLAVE Like '2122%' OR CR.CLAVE Like '3122%'
OR CR.CLAVE in ('12200','12300','12400',
				'22200','22300','22400',
				'32200','32300','32400'))
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
GROUP BY CR.CLAVE, CR.DESCRIPCION 
ORDER BY CR.CLAVE


DECLARE @Valores2 TABLE(Clave VARCHAR(5),
Aprobado DECIMAL (15,2), AmpliacionesReducciones DECIMAL(15,2),Modificado DECIMAL(15,2),Devengado DECIMAL(15,2),Pagado DECIMAL(15,2),SubEjercicio DECIMAL(15,2)) 
Insert into @Valores2
Select 
Substring(Clave,2,3),
SUM(ISNULL(Aprobado,0)) as Aprobado,
SUM(ISNULL(AmpliacionesReducciones,0)) as AmpliacionesReducciones,
SUM(ISNULL(Modificado,0)) as Modificado,
SUM(ISNULL(Devengado,0)) as Devengado,
SUM(ISNULL(Pagado,0)) as Pagado,
SUM(ISNULL(SubEjercicio,0)) as SubEjercicio
from @Valores
group by Substring(Clave,2,3)

--Se actualizan los montos en la tabla de titulos
UPDATE @Titulos  
SET T.Aprobado=T2.Aprobado,
	T.AmpliacionesReducciones= T2.AmpliacionesReducciones,
	T.Modificado=T2.Modificado,
	T.Devengado=T2.Devengado,
	T.Pagado=T2.Pagado,
	T.SubEjercicio=T2.SubEjercicio
FROM @Titulos T
JOIN @Valores2 T2
ON substring(T.Clave,2,3)=substring(T2.Clave,1,3)

--INSERT @Titulos 
--select '','Total del Gasto',
--SUM(Aprobado),
--SUM(AmpliacionesReducciones),
--SUM(Modificado),
--SUM(Devengado),
--SUM(Pagado),
--SUM(SubEjercicio)
--FROM @Titulos
--Select * from @Titulos
--Consulta Final
If @AmpRedAnual = 1
	Begin
		update r set r.Aprobado = a.Aprobado, r.AmpliacionesReducciones = a.AmpliacionesReducciones FROM @Anual2 a, @Titulos r Where substring(a.Clave,1,3)=substring(r.Clave,2,3)
	End
--Else
--	Begin
--		update r set r.Aprobado = a.Aprobado FROM @Anual2 a, @Titulos r Where substring(a.Clave,1,3)=substring(r.Clave,2,3)
--	End

SELECT  
Substring(Clave,1,4),
Descripcion,
SUM(Aprobado) as Aprobado,
SUM(AmpliacionesReducciones) as AmpliacionesReducciones,
SUM(Modificado) as Modificado,
SUM(Devengado) as Devengado,
SUM(Pagado) as Pagado,
SUM(SubEjercicio) as SubEjercicio
FROM @Titulos
group by Descripcion, Substring(Clave,1,4)

GO

exec SP_FirmasReporte 'Estado Analítico del Ejercicio del Presupuesto de Egresos Sector Paraestatal'
GO
Exec SP_CFG_LogScripts 'SP_RPT_K2_EgresosClasificacionAdministrativaParaestatal'
GO
