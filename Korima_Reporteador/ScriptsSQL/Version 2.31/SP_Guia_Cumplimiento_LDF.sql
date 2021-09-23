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
AS
BEGIN

--Exec SP_Guia_Cumplimiento_LDF
DECLARE @Titulos TABLE ( Concepto char(200), 
								Mecanismo varchar(max), 
								Fecha varchar(200),
								Monto varchar(100), 
								Unidad varchar(100),
							    Fundamento varchar(max), 
								Comentarios varchar(max),
								Negritas int,
								g1 int,
								g2 int,
								g3 int)

INSERT INTO @Titulos VALUES ('INDICADORES PRESUPUESTARIOS',null,null,null,null,null,null,1,1,0,0)
INSERT INTO @Titulos VALUES ('A. INDICADORES CUANTITATIVOS',null,null,null,null,null,null,1,0,1,0)
INSERT INTO @Titulos VALUES ('1   Balance Presupuestario Sostenible (j)',null,null,null,null,null,null,1,0,0,1)
INSERT INTO @Titulos VALUES ('a. Propuesto','Iniciativa de Ley de Ingresos y Proyecto de Presupuesto de Egresos','','','Pesos','Art. 6 y 19 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('b. Aprobado','Ley de Ingresos y Presupuesto de Egresos','','','Pesos','Art. 6 y 19 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('c. Devengado','Cuenta P�blica / Formato 4','','','Pesos','Art. 6 y 19 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('2   Balance Presupuestario de Recursos Disponibles Sostenible (k)','','','','','','',1,0,0,1)
INSERT INTO @Titulos VALUES ('a. Propuesto','Iniciativa de Ley de Ingresos y Proyecto de Presupuesto','','','Pesos','Art. 6 y 19 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('b. Aprobado','Ley de Ingresos y Presupuesto de Egresos','','','Pesos','Art. 6 y 19 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('c. Devengado','Cuenta P�blica / Formato 4','',null,'Pesos','Art. 6 y 19 de la LDF',null,0,0,0,0)
INSERT INTO @Titulos VALUES ('3 Financiamiento Neto dentro del Techo de Financiamiento Neto (l)','','','','','','',1,0,0,1)
INSERT INTO @Titulos VALUES ('a. Propuesto','Iniciativa de Ley de Ingresos','','','Pesos','Art. 6, 19 y 46 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('b. Aprobado','Ley de Ingresos','','','Pesos','Art. 6, 19 y 46 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('c. Devengado','Cuenta P�blica / Formato 4 LDF','',null,'Pesos','Art. 6, 19 y 46 de la LDF',null,0,0,0,0)
INSERT INTO @Titulos VALUES ('4 Recursos destinados a la atenci�n de desastres naturales','','','','','','',1,0,0,1)
INSERT INTO @Titulos VALUES ('a. Asignaci�n al fideicomiso para desastres naturales (m)','','','','','','',0,0,0,1)
INSERT INTO @Titulos VALUES ('a.1 Aprobado','Formato 6 a)','','','Pesos','Art. 9 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('a.2 Pagado','Cuenta P�blica / Formato 6 a)','','','Pesos','Art. 9 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('b. Aportaci�n promedio realizada por la Entidad Federativa durante los 5 ejercicios previos, para infraestructura da�ada por desastres naturales (n)','Autorizaciones de recursos aprobados por el FONDEN','','','Pesos','Art. 9 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('c. Saldo del fideicomiso para desastres naturales (o)','Cuenta P�blica / Auxiliar de Cuentas','','','Pesos','Art. 9 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('d. Costo promedio de los �ltimos 5 ejercicios de la reconstrucci�n de infraestructura da�ada por desastres naturales (p)','Autorizaciones de recursos aprobados por el FONDEN','','','Pesos','Art. 9 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('5 Techo para servicios personales (q) ','','',null,'',null,null,1,0,0,1)
INSERT INTO @Titulos VALUES ('a. Asignaci�n en el Presupuesto de Egresos','Reporte Trim. Formato 6 d)','','','Pesos','Art. 10 y 21 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('b. Ejercido','Reporte Trim. Formato 6 d)','','','Pesos','Art. 10 y 21 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('6 Previsiones de gasto para compromisos de pago derivados de APPs (r)','','','','','','',1,0,0,1)
INSERT INTO @Titulos VALUES ('a. Asignaci�n en el Presupuesto de Egresos','Presupuesto de Egresos','',null,'Pesos','Art. 11 y 21 de la LDF',null,0,0,0,0)
INSERT INTO @Titulos VALUES ('7 Techo de ADEFAS para el ejercicio fiscal (s)','','','','','','',1,0,0,1)
INSERT INTO @Titulos VALUES ('a. Propuesto','Proyecto de Presupuesto de Egresos','','','Pesos','Art. 12 y 20 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('b. Aprobado','Reporte Trim. Formato 6 a)','','','Pesos','Art. 12 y 20 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('c. Ejercido','Cuenta P�blica / Formato 6 a)','','','Pesos','Art. 12 y 20 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('B. INDICADORES CUALITATIVOS','','','','','','',1,1,0,0)
INSERT INTO @Titulos VALUES ('1 Iniciativa de Ley de Ingresos y Proyecto de Presupuesto de Egresos','','','','','','',1,0,1,0)
INSERT INTO @Titulos VALUES ('a. Objetivos anuales, estrategias y metas para el ejercicio fiscal (t)','Iniciativa de Ley de Ingresos y Proyecto de Presupuesto de Egresos','','','','Art. 5 y 18 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('b. Proyecciones de ejercicios posteriores (u)','Iniciativa de Ley de Ingresos y Proyecto de Presupuesto de Egresos / Formatos 7 a) y b)','','','','Art. 5 y 18 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('c. Descripci�n de riesgos relevantes y propuestas de acci�n para enfrentarlos (v)','Iniciativa de Ley de Ingresos y Proyecto de Presupuesto de Egresos','','','','Art. 5 y 18 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('d. Resultados de ejercicios fiscales anteriores y el ejercicio fiscal en cuesti�n (w)','Iniciativa de Ley de Ingresos y Proyecto de Presupuesto de Egresos / Formatos 7 c) y d)','','','','Art. 5 y 18 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('e. Estudio actuarial de las pensiones de sus trabajadores (x)','Proyecto de Presupuesto de Egresos / Formato 8','','','','','',0,0,0,0)
INSERT INTO @Titulos VALUES ('2 Balance Presupuestario de Recursos Disponibles, en caso de ser negativo','','','','','','',1,0,1,0)
INSERT INTO @Titulos VALUES ('a. Razones excepcionales que justifican el Balance Presupuestario de Recursos Disponibles negativo (y)','Iniciativa de Ley de Ingresos o Proyecto de Presupuesto de Egresos','','','','','',0,0,0,0)
INSERT INTO @Titulos VALUES ('b. Fuente de recursos para cubrir el Balance Presupuestario de Recursos Disponibles negativo (z)','Iniciativa de Ley de Ingresos o Proyecto de Presupuesto de Egresos','','','','Art. 6 y 19 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('c. N�mero de ejercicios fiscales y acciones necesarias para cubrir el Balance Presupuestario de Recursos Disponibles negativo (aa)','Iniciativa de Ley de Ingresos o Proyecto de Presupuesto de Egresos','','','','Art. 6 y 19 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('d. Informes Trimestrales sobre el avance de las acciones para recuperar el Balance Presupuestario de Recursos Disponibles (bb)','Reporte Trim. y Cuenta P�blica','','','','Art. 6 y 19 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('3 Servicios Personales','','','','','','',1,0,1,0)
INSERT INTO @Titulos VALUES ('a. Remuneraciones de los servidores p�blicos (cc)','Proyecto de Presupuesto','','','','Art. 10 y 21 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('b. Previsiones salariales y econ�micas para cubrir incrementos salariales, creaci�n de plazas y otros (dd)','Proyecto de Presupuesto','','','','Art. 10 y 21 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('INDICADORES DEL EJERCICIO PRESUPUESTARIO','','','','','','',1,1,0,0)
INSERT INTO @Titulos VALUES ('A. INDICADORES CUANTITATIVOS','','','','','','',1,0,1,0)
INSERT INTO @Titulos VALUES ('1 Ingresos Excedentes derivados de Ingresos de Libre Disposici�n','','','','','','',0,0,0,1)
INSERT INTO @Titulos VALUES ('a. Monto de Ingresos Excedentes derivados de ILD (ee)','Cuenta P�blica / Formato 5','','','Pesos','Art. 14 y 21 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('b. Monto de Ingresos Excedentes derivados de ILD destinados al fin del A.14, fracci�n I de la LDF (ff)','Cuenta P�blica','','','Pesos','Art. 14 y 21 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('c. Monto de Ingresos Excedentes derivados de ILD destinados al fin del A.14, fracci�n II, a) de la LDF (gg)','Cuenta P�blica','','','Pesos','Art. 14 y 21 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('d. Monto de Ingresos Excedentes derivados de ILD destinados al fin del A.14, fracci�n II, b) de la LDF (hh)','Cuenta P�blica','','','Pesos','Art. 14 y 21 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('e. Monto de Ingresos Excedentes derivados de ILD destinados al fin del art�culo noveno transitorio de la LDF (ii)','Cuenta P�blica','','','Pesos','Art. Noveno Transitorio de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('B. INDICADORES CUALITATIVOS','','','','','','',1,1,0,0)
INSERT INTO @Titulos VALUES ('1 An�lisis Costo-Beneficio para programas o proyectos de inversi�n mayores a 10 millones de UDIS (jj)','P�gina de internet de la Secretar�a de Finanzas o Tesorer�a Municipal','','','','Art. 13 frac. III y 21 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('2 An�lisis de conveniencia y an�lisis de transferencia de riesgos de los proyectos APPs (kk)','P�gina de internet de la Secretar�a de Finanzas o Tesorer�a Municipal','','','','Art. 13 frac. III y 21 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('3 Identificaci�n de poblaci�n objetivo, destino y temporalidad de subsidios (ll)','P�gina de internet de la Secretar�a de Finanzas o Tesorer�a Municipal','','','','Art. 13 frac. III y 21 de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('INDICADORES DE DEUDA P�BLICA','','','','','','',1,1,0,0)
INSERT INTO @Titulos VALUES ('A. INDICADORES CUANTITATIVOS','','','','','','',1,0,1,0)
INSERT INTO @Titulos VALUES ('1 Obligaciones a Corto Plazo','','','','','','',0,0,0,1)
INSERT INTO @Titulos VALUES ('a. L�mite de Obligaciones a Corto Plazo (mm)','','','','Pesos','Art. 30 frac. I de la LDF','',0,0,0,0)
INSERT INTO @Titulos VALUES ('b. Obligaciones a Corto Plazo (nn)','','','','Pesos','Art. 30 frac. I de la LDF','',0,0,0,0)


SELECT  * FROM @Titulos 	
END

EXEC SP_FirmasReporte 'GU�A DE CUMPLIMIENTO DE LA LEY DE DISCIPLINA FINANCIERA DE LAS ENTIDADES FEDERATIVAS Y LOS MUNICIPIOS'
GO

--Exec SP_CFG_LogScripts 'SP_Guia_Cumplimiento_LDF','2.30.1'
--GO