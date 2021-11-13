/****** Object:  StoredProcedure [dbo].[SP_Guia_Cumplimiento_LDF]    Script Date: 02/01/2017 11:41:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Guia_Cumplimiento_LDF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Guia_Cumplimiento_LDF]
GO
                                        
/****** Object:  StoredProcedure [dbo].[SP_Guia_Cumplimiento_LDF]    Script Date: 02/01/2017 11:45:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                        
CREATE PROCEDURE [dbo].[SP_Guia_Cumplimiento_LDF]	

@Ejercicio int

AS
BEGIN

-- Exec SP_Guia_Cumplimiento_LDF 2021
DECLARE @Titulos TABLE ( Concepto char(200), 
								Mecanismo varchar(max), 
								Fecha varchar(200),
								Monto decimal(18,4), 
								Unidad varchar(100),
							    Fundamento varchar(max), 
								Comentarios varchar(max),
								Negritas int,
								g1 int,
								g2 int,
								g3 int,
								Orden int)

INSERT INTO @Titulos VALUES ('INDICADORES PRESUPUESTARIOS',null,null,null,null,null,null,1,1,0,0,0)
INSERT INTO @Titulos VALUES ('A. INDICADORES CUANTITATIVOS',null,null,null,null,null,null,1,0,1,0,1)
INSERT INTO @Titulos VALUES ('1   Balance Presupuestario Sostenible (j)',null,null,null,null,null,null,1,0,0,1,2)
INSERT INTO @Titulos VALUES ('a. Propuesto','Iniciativa de Ley de Ingresos y Proyecto de Presupuesto de Egresos','',null,'Pesos','Art. 6 y 19 de la LDF','',0,0,0,0,3)
INSERT INTO @Titulos VALUES ('b. Estimada/Aprobado       ','Ley de Ingresos y Presupuesto de Egresos','',null,'Pesos','Art. 6 y 19 de la LDF','',0,0,0,0,4)
INSERT INTO @Titulos VALUES ('c. Devengado','Cuenta Pública / Formato 4','',null,'Pesos','Art. 6 y 19 de la LDF','',0,0,0,0,5)
INSERT INTO @Titulos VALUES ('2   Balance Presupuestario de Recursos Disponibles Sostenible (k)','','',null,'','','',1,0,0,1,6)
INSERT INTO @Titulos VALUES ('a. Propuesto','Iniciativa de Ley de Ingresos y Proyecto de Presupuesto','',null,'Pesos','Art. 6 y 19 de la LDF','',0,0,0,0,7)
INSERT INTO @Titulos VALUES ('b. Estimada/Aprobado       ','Ley de Ingresos y Presupuesto de Egresos','',null,'Pesos','Art. 6 y 19 de la LDF','',0,0,0,0,8)
INSERT INTO @Titulos VALUES ('c. Devengado','Cuenta Pública / Formato 4','',null,'Pesos','Art. 6 y 19 de la LDF',null,0,0,0,0,9)
INSERT INTO @Titulos VALUES ('3 Financiamiento Neto dentro del Techo de Financiamiento Neto (l)','','',null,'','','',1,0,0,1,10)
INSERT INTO @Titulos VALUES ('a. Propuesto','Iniciativa de Ley de Ingresos','',null,'Pesos','Art. 6, 19 y 46 de la LDF','',0,0,0,0,11)
INSERT INTO @Titulos VALUES ('b. Estimada/Aprobado       ','Ley de Ingresos','',null,'Pesos','Art. 6, 19 y 46 de la LDF','',0,0,0,0,12)
INSERT INTO @Titulos VALUES ('c. Devengado','Cuenta Pública / Formato 4 LDF','',null,'Pesos','Art. 6, 19 y 46 de la LDF',null,0,0,0,0,13)
INSERT INTO @Titulos VALUES ('4 Recursos destinados a la atención de desastres naturales','','',null,'','','',1,0,0,1,14)
INSERT INTO @Titulos VALUES ('a. Asignación al fideicomiso para desastres naturales (m)','','',null,'','','',0,0,0,1,15)
INSERT INTO @Titulos VALUES ('a.1 Aprobado','Formato 6 a)','',null,'Pesos','Art. 9 de la LDF','',0,0,0,0,16)
INSERT INTO @Titulos VALUES ('a.2 Pagado','Cuenta Pública / Formato 6 a)','',null,'Pesos','Art. 9 de la LDF','',0,0,0,0,17)
INSERT INTO @Titulos VALUES ('b. Aportación promedio realizada por la Entidad Federativa durante los 5 ejercicios previos, para infraestructura dañada por desastres naturales (n)','Autorizaciones de recursos aprobados por el FONDEN','',null,'Pesos','Art. 9 de la LDF','',0,0,0,0,18)
INSERT INTO @Titulos VALUES ('c. Saldo del fideicomiso para desastres naturales (o)','Cuenta Pública / Auxiliar de Cuentas','',null,'Pesos','Art. 9 de la LDF','',0,0,0,0,19)
INSERT INTO @Titulos VALUES ('d. Costo promedio de los últimos 5 ejercicios de la reconstrucción de infraestructura dañada por desastres naturales (p)','Autorizaciones de recursos aprobados por el FONDEN','',null,'Pesos','Art. 9 de la LDF','',0,0,0,0,20)
INSERT INTO @Titulos VALUES ('5 Techo para servicios personales (q) ','','',null,'',null,null,1,0,0,1,21)
INSERT INTO @Titulos VALUES ('a. Asignación en el Presupuesto de Egresos','Reporte Trim. Formato 6 d)','',null,'Pesos','Art. 10 y 21 de la LDF','',0,0,0,0,22)
INSERT INTO @Titulos VALUES ('b. Devengado','Reporte Trim. Formato 6 d)','',null,'Pesos','Art. 10 y 21 de la LDF','',0,0,0,0,23)
INSERT INTO @Titulos VALUES ('6 Previsiones de gasto para compromisos de pago derivados de APPs (r)','','',null,'','','',1,0,0,1,24)
INSERT INTO @Titulos VALUES ('a. Asignación en el Presupuesto de Egresos','Presupuesto de Egresos','',null,'Pesos','Art. 11 y 21 de la LDF',null,0,0,0,0,25)
INSERT INTO @Titulos VALUES ('7 Techo de ADEFAS para el ejercicio fiscal (s)','','',null,'','','',1,0,0,1,26)
INSERT INTO @Titulos VALUES ('a. Propuesto','Proyecto de Presupuesto de Egresos','',null,'Pesos','Art. 12 y 20 de la LDF','',0,0,0,0,27)
INSERT INTO @Titulos VALUES ('b. Aprobado','Reporte Trim. Formato 6 a)','',null,'Pesos','Art. 12 y 20 de la LDF','',0,0,0,0,28)
INSERT INTO @Titulos VALUES ('c. Devengado','Cuenta Pública / Formato 6 a)','',null,'Pesos','Art. 12 y 20 de la LDF','',0,0,0,0,29)
INSERT INTO @Titulos VALUES ('B. INDICADORES CUALITATIVOS','','',null,'','','',1,1,0,0,30)
INSERT INTO @Titulos VALUES ('1 Iniciativa de Ley de Ingresos y Proyecto de Presupuesto de Egresos','','',null,'','','',1,0,1,0,31)
INSERT INTO @Titulos VALUES ('a. Objetivos anuales, estrategias y metas para el ejercicio fiscal (t)','Iniciativa de Ley de Ingresos y Proyecto de Presupuesto de Egresos','',null,'','Art. 5 y 18 de la LDF','',0,0,0,0,32)
INSERT INTO @Titulos VALUES ('b. Proyecciones de ejercicios posteriores (u)','Iniciativa de Ley de Ingresos y Proyecto de Presupuesto de Egresos / Formatos 7 a) y b)','',null,'','Art. 5 y 18 de la LDF','',0,0,0,0,33)
INSERT INTO @Titulos VALUES ('c. Descripción de riesgos relevantes y propuestas de acción para enfrentarlos (v)','Iniciativa de Ley de Ingresos y Proyecto de Presupuesto de Egresos','',null,'','Art. 5 y 18 de la LDF','',0,0,0,0,34)
INSERT INTO @Titulos VALUES ('d. Resultados de ejercicios fiscales anteriores y el ejercicio fiscal en cuestión (w)','Iniciativa de Ley de Ingresos y Proyecto de Presupuesto de Egresos / Formatos 7 c) y d)','',null,'','Art. 5 y 18 de la LDF','',0,0,0,0,35)
INSERT INTO @Titulos VALUES ('e. Estudio actuarial de las pensiones de sus trabajadores (x)','Proyecto de Presupuesto de Egresos / Formato 8','',null,'','','',0,0,0,0,36)
INSERT INTO @Titulos VALUES ('2 Balance Presupuestario de Recursos Disponibles, en caso de ser negativo','','',null,'','','',1,0,1,0,37)
INSERT INTO @Titulos VALUES ('a. Razones excepcionales que justifican el Balance Presupuestario de Recursos Disponibles negativo (y)','Iniciativa de Ley de Ingresos o Proyecto de Presupuesto de Egresos','',null,'','','',0,0,0,0,38)
INSERT INTO @Titulos VALUES ('b. Fuente de recursos para cubrir el Balance Presupuestario de Recursos Disponibles negativo (z)','Iniciativa de Ley de Ingresos o Proyecto de Presupuesto de Egresos','',null,'','Art. 6 y 19 de la LDF','',0,0,0,0,39)
INSERT INTO @Titulos VALUES ('c. Número de ejercicios fiscales y acciones necesarias para cubrir el Balance Presupuestario de Recursos Disponibles negativo (aa)','Iniciativa de Ley de Ingresos o Proyecto de Presupuesto de Egresos','',null,'','Art. 6 y 19 de la LDF','',0,0,0,0,40)
INSERT INTO @Titulos VALUES ('d. Informes Trimestrales sobre el avance de las acciones para recuperar el Balance Presupuestario de Recursos Disponibles (bb)','Reporte Trim. y Cuenta Pública','',null,'','Art. 6 y 19 de la LDF','',0,0,0,0,41)
INSERT INTO @Titulos VALUES ('3 Servicios Personales','','',null,'','','',1,0,1,0,42)
INSERT INTO @Titulos VALUES ('a. Remuneraciones de los servidores públicos (cc)','Proyecto de Presupuesto','',null,'','Art. 10 y 21 de la LDF','',0,0,0,0,43)
INSERT INTO @Titulos VALUES ('b. Previsiones salariales y económicas para cubrir incrementos salariales, creación de plazas y otros (dd)','Proyecto de Presupuesto','',null,'','Art. 10 y 21 de la LDF','',0,0,0,0,44)
INSERT INTO @Titulos VALUES ('INDICADORES DEL EJERCICIO PRESUPUESTARIO','','',null,'','','',1,1,0,0,45)
INSERT INTO @Titulos VALUES ('A. INDICADORES CUANTITATIVOS','','',null,'','','',1,0,1,0,46)
INSERT INTO @Titulos VALUES ('1 Ingresos Excedentes derivados de Ingresos de Libre Disposición','','',null,'','','',0,0,0,1,47)
INSERT INTO @Titulos VALUES ('a. Monto de Ingresos Excedentes derivados de ILD (ee)','Cuenta Pública / Formato 5','',null,'Pesos','Art. 14 y 21 de la LDF','',0,0,0,0,48)
INSERT INTO @Titulos VALUES ('b. Monto de Ingresos Excedentes derivados de ILD destinados al fin del A.14, fracción I de la LDF (ff)','Cuenta Pública','',null,'Pesos','Art. 14 y 21 de la LDF','',0,0,0,0,49)
INSERT INTO @Titulos VALUES ('c. Monto de Ingresos Excedentes derivados de ILD destinados al fin del A.14, fracción II, a) de la LDF (gg)','Cuenta Pública','',null,'Pesos','Art. 14 y 21 de la LDF','',0,0,0,0,50)
INSERT INTO @Titulos VALUES ('d. Monto de Ingresos Excedentes derivados de ILD destinados al fin del A.14, fracción II, b) de la LDF (hh)','Cuenta Pública','',null,'Pesos','Art. 14 y 21 de la LDF','',0,0,0,0,51)
INSERT INTO @Titulos VALUES ('e. Monto de Ingresos Excedentes derivados de ILD destinados al fin del artículo noveno transitorio de la LDF (ii)','Cuenta Pública','',null,'Pesos','Art. Noveno Transitorio de la LDF','',0,0,0,0,52)
INSERT INTO @Titulos VALUES ('f. Monto de Ingresos Excedentes derivados de ILD destinados al fin señalado por el Artículo 14, párrafo segundo y en el artículo 21 y Noveno Transitorio de la LDF (jj)','Cuenta Pública','',null,'Pesos','Art. Noveno Transitorio de la LDF','',0,0,0,0,53)
INSERT INTO @Titulos VALUES ('g. Monto de Ingresos Excedentes derivados de ILD en un nivel de endeudamiento sostenible de acuerdo al Sistema de Alertas hasta por el 5% de los recursos para cubrir el Gasto Corriente (kk)','Cuenta Pública','',null,'Pesos','Art. Noveno Transitorio de la LDF','',0,0,0,0,54)

INSERT INTO @Titulos VALUES ('B. INDICADORES CUALITATIVOS','','',null,'','','',1,1,0,0,55)
INSERT INTO @Titulos VALUES ('1 Análisis Costo-Beneficio para programas o proyectos de inversión mayores a 10 millones de UDIS (ll)','Página de internet de la Secretaría de Finanzas o Tesorería Municipal','',null,'','Art. 13 frac. III y 21 de la LDF','',0,0,0,0,56)
INSERT INTO @Titulos VALUES ('2 Análisis de conveniencia y análisis de transferencia de riesgos de los proyectos APPs (mm)','Página de internet de la Secretaría de Finanzas o Tesorería Municipal','',null,'','Art. 13 frac. III y 21 de la LDF','',0,0,0,0,57)
INSERT INTO @Titulos VALUES ('3 Identificación de población objetivo, destino y temporalidad de subsidios (nn)','Página de internet de la Secretaría de Finanzas o Tesorería Municipal','',null,'','Art. 13 frac. III y 21 de la LDF','',0,0,0,0,58)
INSERT INTO @Titulos VALUES ('INDICADORES DE DEUDA PÚBLICA','','',null,'','','',1,1,0,0,59)
INSERT INTO @Titulos VALUES ('A. INDICADORES CUANTITATIVOS','','',null,'','','',1,0,1,0,60)
INSERT INTO @Titulos VALUES ('1 Obligaciones a Corto Plazo','','',null,'','','',0,0,0,1,61)
INSERT INTO @Titulos VALUES ('a. Límite de Obligaciones a Corto Plazo (oo)','','',null,'Pesos','Art. 30 frac. I de la LDF','',0,0,0,0,62)
INSERT INTO @Titulos VALUES ('b. Obligaciones a Corto Plazo (pp)','','',null,'Pesos','Art. 30 frac. I de la LDF','',0,0,0,0,63)


Declare @Egresos as table(IdCapitulo int, DescripcionCap varchar(max), IdPartida int, DescripcionPartida Varchar(max), ClaveFF varchar(200),
Autorizado decimal(18,4), Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4))

Insert into @Egresos
Select CG.IdCapitulo, 
CG.Descripcion as DescripcionCap,
CP.IdPartida,
CP.DescripcionPartida,
CF.CLAVE,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado



From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
where (Mes = 0) AND LYear= @Ejercicio AND [Year] = @Ejercicio

Group by  CG.IdCapitulo, CG.Descripcion, CF.CLAVE,

CP.DescripcionPartida, CP.IdPartida--, TS.IdFuenteFinanciamiento 
Order by  CG.IdCapitulo 


-----------------------------------------------------------------------------------------------

Declare @PresupuestoFlujo as Table (
Ejerciio int,
IdPartida int,
Mes Int,
Estimado decimal(13,2),
Ampliaciones decimal(13,2),
Reducciones decimal(13,2),
Modificado decimal(13,2),
Devengado decimal(13,2),
Recaudado decimal(13,2),
PorRecaudar decimal(13,2)
)

INSERT INTO @PresupuestoFlujo 
SELECT * from T_PresupuestoFlujo
where (mes between 1 and 12 ) and Ejercicio = @Ejercicio


Declare @Ingresos as table(ClaveFF varchar(100), DescripcionFF varchar(max),
Estimado decimal(18,4), Modificado decimal(18,4),
Devengado decimal(18,4), Recaudado decimal(18,4))


Insert Into @Ingresos
SELECT    
 C_FuenteFinanciamiento.CLAVE, 
                      C_FuenteFinanciamiento.DESCRIPCION ,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado, 
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado,  
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado 
                      --C_ClasificacionGasto_3.Clave as Clave, 
                     -- SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(ABS(MovimientosPresupuesto.Reducciones),0)) AS AmpliacionesReducciones 
                     
		            FROM  @PresupuestoFlujo MovimientosPresupuesto LEFT OUTER JOIN 
                      C_PartidasGastosIngresos 
                      ON MovimientosPresupuesto.IdPartida = C_PartidasGastosIngresos.IdPartidaGI  
                     
                     LEFT JOIN 
                      C_FuenteFinanciamiento 
                      ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento  

					GROUP BY --C_ClasificacionGasto_3.Descripcion, C_ClasificacionGasto_3.Clave, C_FuenteFinanciamiento.CLAVE,
                      C_FuenteFinanciamiento.DESCRIPCION ,C_FuenteFinanciamiento.CLAVE


---------------------------------------------------------------
UPDATE @Titulos set Monto = (Select ISNULL(SUM(Estimado),0) from @Ingresos)-((Select ISNULL(SUM(Autorizado),0) from @Egresos) - (Select ISNULL(SUM(Autorizado),0) from @Egresos Where LEFT(IdPartida,2) = '91')) Where Orden = 4
--UPDATE @Titulos set Monto = (Select ISNULL(SUM(Estimado),0) from @Ingresos)-(Select ISNULL(SUM(Autorizado),0) from @Egresos Where LEFT(IdPartida,2) not in ('91')) Where Orden = 4
UPDATE @Titulos set Monto = (Select ISNULL(SUM(Devengado),0) from @Ingresos)-(Select ISNULL(SUM(Devengado),0) from @Egresos ) Where Orden = 5

UPDATE @Titulos set Monto = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where LEFT(ClaveFF,2) not in ('25','26','27'))-((Select ISNULL(SUM(Autorizado),0) from @Egresos Where LEFT(ClaveFF,2) not in ('25','26','27')) - (Select ISNULL(SUM(Autorizado),0) from @Egresos Where LEFT(IdPartida,2) = '91' AND LEFT(ClaveFF,2) not in ('25','26','27'))) Where Orden = 8
UPDATE @Titulos set Monto = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where LEFT(ClaveFF,2) not in ('25','26','27'))-(Select ISNULL(SUM(Devengado),0) from @Egresos Where LEFT(ClaveFF,2) not in ('25','26','27')) Where Orden = 9

UPDATE @Titulos set Monto = (Select ISNULL(SUM(Autorizado),0) from @Egresos Where LEFT(IdCapitulo,1) = '1') Where Orden = 22
UPDATE @Titulos set Monto = (Select ISNULL(SUM(Devengado),0) from @Egresos Where LEFT(IdCapitulo,1) = '1') Where Orden = 23

UPDATE @Titulos set Monto = (Select ISNULL(SUM(Autorizado),0) from @Egresos  Where LEFT(IdPartida,2) in ('99')) Where Orden = 28
UPDATE @Titulos set Monto = (Select ISNULL(SUM(Devengado),0) from @Egresos Where LEFT(IdPartida,2) in ('99')) Where Orden = 29

UPDATE @Titulos set Monto = 
CASE WHEN ((Select ISNULL(SUM(Recaudado),0) from @Ingresos)-(Select ISNULL(SUM(Estimado),0) from @Ingresos)) >0 THEN 
(Select ISNULL(SUM(Recaudado),0) from @Ingresos)-(Select ISNULL(SUM(Estimado),0) from @Ingresos)
ELSE null END
Where Orden = 48

UPDATE @Titulos set Monto = (Select ISNULL(SUM(Estimado),0) from @Ingresos ) * .06 Where Orden = 62
UPDATE @Titulos set Monto = (Select ISNULL(SUM(TotalAbonos),0) from VW_RPT_K2_Balanza_De_Comprobacion Where (Mes between 1 and  12) AND [Year] = @Ejercicio AND LEFT(NumeroCuenta,3) = '213' and Afectable = 1 )   Where Orden = 63

SELECT  * FROM @Titulos 

END

EXEC SP_FirmasReporte 'GUÍA DE CUMPLIMIENTO DE LA LEY DE DISCIPLINA FINANCIERA DE LAS ENTIDADES FEDERATIVAS Y LOS MUNICIPIOS'
GO
Exec SP_CFG_LogScripts 'SP_Guia_Cumplimiento_LDF','2.31'
GO