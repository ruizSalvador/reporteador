/****** Object:  StoredProcedure [dbo].[SP_Informes_Actuarias]    Script Date: 12/03/2012 17:30:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Informes_Actuarias]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Informes_Actuarias]
GO
/****** Object:  StoredProcedure [dbo].[SP_Informes_Actuarias]    Script Date: 12/03/2012 17:30:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_Informes_Actuarias
CREATE PROCEDURE  [dbo].[SP_Informes_Actuarias]
	
AS
BEGIN

DECLARE @VariableTabla TABLE ( Concepto char(200),
                                Pensiones_y_Jubilaciones decimal (18,2),
								Salud decimal (18,2),
								Riesgos_de_trabajo decimal (18,2),
								Invalidez_y_vida decimal (18,2),
								Otras_prestaciones_sociales decimal (18,2),
								Negritas int)

INSERT INTO @VariableTabla VALUES ('Tipo de Sistema'                                                              ,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('Prestación Laboral o Fondo general para trabajadores del estado o municipio'  ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Beneficio definido, Contribución definida o Mixto'                            ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (''                                                                             ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Población afiliada'                                                           ,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('Activos'                                                                      ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Edad Máxima'                                                                  ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Edad Mínima'                                                                  ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Edad Promedio'                                                                ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Pensionados y Jubilados'                                                      ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Edad Máxima'                                                                  ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Edad Mínima'                                                                  ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Edad Promedio'                                                                ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Beneficiarios'                                                                ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Promedio de años de servicio (trabajadores activos)'                          ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Aportación individual al plan de pensión como % del salario'                  ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Aportación del Ente Publico al plan de pensión como % del salario'            ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Crecimiento esperado de los pensionados y jubilados (como %)'                 ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Crecimiento esperado de los activos (como %)'                                 ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Edad de Jubilación o Pensión'                                                 ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Esperanza de vida'                                                            ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (''                                                                             ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Ingresos del Fondo'                                                           ,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('Ingresos Anuales al Fondo de Pensiones'                                       ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (''                                                                             ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Nomina anual'                                                                 ,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('Activos'                                                                      ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Pensionados y Jubilados'                                                      ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Beneficiarios de Pensionados y Jubilados'                                     ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (''                                                                             ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Monto mensual por pensión'                                                    ,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('Máximo'                                                                       ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Mínimo'                                                                       ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Promedio'                                                                     ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (''                                                                             ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Monto de la Reserva'                                                          ,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES (''                                                                             ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Valor presente de las obligaciones'                                           ,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('Pensiones y Jubilaciones en curso de pago '                                   ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Generación Actual'                                                            ,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('Generaciones Futuras'                                                         ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (''                                                                             ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Valor Presente de las contribuciones asociadas a los sueldos futuros de cotización X%',0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('Generación actual'                                                            ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Generaciones futuras'                                                         ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (''                                                                             ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Valor presente de aportaciones futuras'                                       ,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('Generación actual'                                                            ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Generaciones futuras'                                                         ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Otros Ingresos'                                                               ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (''                                                                             ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Déficit/superávit actuarial'                                                  ,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('Generación actual'                                                            ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Generaciones futuras'                                                         ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (''                                                                             ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Periodo de suficiencia'                                                       ,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('Año de descapitalización'                                                     ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Tasa de rendimiento'                                                          ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (''                                                                             ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Estudio actuarial'                                                            ,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('Año de elaboración del estudio actuarial'                                     ,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('Empresa que elaboro el estudio actuarial'                                     ,0,0,0,0,0,0)

--SELECT  Concepto  FROM @VariableTabla

SELECT  *  FROM @VariableTabla 	
END



GO
EXEC SP_FirmasReporte 'Informes de Actuarias'
GO

Exec SP_CFG_LogScripts 'SP_Informes_Actuarias'
GO

