/****** Object:  StoredProcedure [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado]    Script Date: 12/03/2012 17:30:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado]
GO
/****** Object:  StoredProcedure [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado]    Script Date: 12/03/2012 17:30:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Exec SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado
CREATE PROCEDURE  [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado]
	
AS
BEGIN

DECLARE @VariableTabla TABLE ( Concepto char(200),Negritas int)

INSERT INTO @VariableTabla VALUES ('A. Servicios Personales				                                                                 ',0)
INSERT INTO @VariableTabla VALUES ('         a1)Remuneraciones al personal de car�cter permanente			                         	',0)
INSERT INTO @VariableTabla VALUES ('         a2)Remuneraciones al personal de car�cter transitorio				                         ',0)
INSERT INTO @VariableTabla VALUES ('         a3)Remuneraciones adicionales y especiales				                                   ',0)
INSERT INTO @VariableTabla VALUES ('         a4)Seguridad Social				                                                            ',0)
INSERT INTO @VariableTabla VALUES ('         a5)Otras prestaciones sociales y econ�micas				                                   ',0)
INSERT INTO @VariableTabla VALUES ('         a6)Previsiones				                                                                 ',0)
INSERT INTO @VariableTabla VALUES ('         a7)Pago de est�mulos a servidores p�blicos				                                   ',0)
INSERT INTO @VariableTabla VALUES ('B.Materiales y Suministros				                                                            ',0)
INSERT INTO @VariableTabla VALUES ('         b1)Materiales de administraci�n, emisi�n de documentos y art�culos oficiales				',0)
INSERT INTO @VariableTabla VALUES ('         b2)Alimentos y utensilios				                                                  ',0)
INSERT INTO @VariableTabla VALUES ('         b3)Materias primas y materiales de producci�n y comercializaci�n				               ',0)
INSERT INTO @VariableTabla VALUES ('         b4)Materiales y art�culos de construcci�n y de reparaci�n				                    ',0)
INSERT INTO @VariableTabla VALUES ('         b5)Productos qu�micos, farmac�uticos y de laboratorio				                         ',0)
INSERT INTO @VariableTabla VALUES ('         b6)Combustibles, lubricantes y aditivos				                                        ',0)
INSERT INTO @VariableTabla VALUES ('         b7)Vestuario, blancos, prendas de protecci�n y art�culos deportivos				          ',0)
INSERT INTO @VariableTabla VALUES ('         b8)Materiales y suministros para seguridad				                                   ',0)
INSERT INTO @VariableTabla VALUES ('         b9)Herramientas, refacciones y accesorios menores				                              ',0)
INSERT INTO @VariableTabla VALUES ('C. Servicios Generales				                                                                 ',0)
INSERT INTO @VariableTabla VALUES ('         c1)Servicios b�sicos				                                                       ',0)
INSERT INTO @VariableTabla VALUES ('         c2)Servicios de arrendamiento				                                                  ',0)
INSERT INTO @VariableTabla VALUES ('         c3)Servicios profesionales, cient�ficos, t�cnicos y otros servicios				          ',0)
INSERT INTO @VariableTabla VALUES ('         c4)Servicios financieros, bancarios y comerciales				                              ',0)
INSERT INTO @VariableTabla VALUES ('         c5)Servicios de instalaci�n, reparaci�n, mantenimiento y conservaci�n				          ',0)
INSERT INTO @VariableTabla VALUES ('         c6)Servicios de comunicaci�n social y publicidad				                              ',0)
INSERT INTO @VariableTabla VALUES ('         c7)Servicios de traslado y vi�ticos				                                        ',0)
INSERT INTO @VariableTabla VALUES ('         c8)Servicios oficiales				                                                       ',0)
INSERT INTO @VariableTabla VALUES ('         c9)Otros servicios generales				                                                  ',0)
INSERT INTO @VariableTabla VALUES ('D. Trasnferencias, Asignaciones, Subsidios y Otras ayudas				                              ',0)
INSERT INTO @VariableTabla VALUES ('         d1)Transferencias internas y asignaciones al sector p�blico				                    ',0)
INSERT INTO @VariableTabla VALUES ('         d2)Transferencias al resto del sector p�blico				                              ',0)
INSERT INTO @VariableTabla VALUES ('         d3)Subsidios y subvenciones				                                                  ',0)
INSERT INTO @VariableTabla VALUES ('         d4)Ayudas sociales				                                                            ',0)
INSERT INTO @VariableTabla VALUES ('         d5)Pensiones y jubilaciones				                                                  ',0)
INSERT INTO @VariableTabla VALUES ('         d6)Transferencias a fideicomisos, mandatos y otros an�logos				                    ',0)
INSERT INTO @VariableTabla VALUES ('         d7)Transferencias a la seguridad social				                                        ',0)
INSERT INTO @VariableTabla VALUES ('         d8)Donativos				                                                                 ',0)
INSERT INTO @VariableTabla VALUES ('         d9)Transferencias al exterior				                                                  ',0)
INSERT INTO @VariableTabla VALUES ('E. Bienes Muebles, Inmuebles e Intangibles				                                             ',0)
INSERT INTO @VariableTabla VALUES ('         e1)Mobiliario y equipo de administraci�n				                                   ',0)
INSERT INTO @VariableTabla VALUES ('         e2)Mobiliario y equipo educacional y recreativo				                              ',0)
INSERT INTO @VariableTabla VALUES ('         e3)Equipo e instrumental m�dico y de laboratorio				                              ',0)
INSERT INTO @VariableTabla VALUES ('         e4)Veh�culos y equipo de transporte				                                        ',0)
INSERT INTO @VariableTabla VALUES ('         e5)Equipo de defensa y seguridad				                                             ',0)
INSERT INTO @VariableTabla VALUES ('         e6)Maquinaria, otros equipos y herramientas				                                   ',0)
INSERT INTO @VariableTabla VALUES ('         e7)Activos biol�gicos				                                                       ',0)
INSERT INTO @VariableTabla VALUES ('         e8)Bienes inmuebles				                                                            ',0)
INSERT INTO @VariableTabla VALUES ('         e9)Activos intangibles				                                                       ',0)
INSERT INTO @VariableTabla VALUES ('F. Inversion Publica 				                                                                 ',0)
INSERT INTO @VariableTabla VALUES ('         f1)Obra p�blica en bienes de dominio p�blico				                                   ',0)
INSERT INTO @VariableTabla VALUES ('         f2)Obra p�blica en bienes propios				                                             ',0)
INSERT INTO @VariableTabla VALUES ('         f3)Proyectos productivos y acciones de fomento				                              ',0)
INSERT INTO @VariableTabla VALUES ('G. Inversiones Financieras y Otras Provisiones				                                        ',0)
INSERT INTO @VariableTabla VALUES ('         g1)Inversiones para el fomento de actividades productivas				                    ',0)
INSERT INTO @VariableTabla VALUES ('         g2)Acciones y participaciones de capital				                                   ',0)
INSERT INTO @VariableTabla VALUES ('         g3)Compra de t�tulos y valores				                                             ',0)
INSERT INTO @VariableTabla VALUES ('         g4)Concesi�n de pr�stamos				                                                  ',0)
INSERT INTO @VariableTabla VALUES ('         g5)Inversiones en fideicomisos, mandatos y otros an�logos				                    ',0)
INSERT INTO @VariableTabla VALUES ('         g6)Otras inversiones financieras				                                             ',0)
INSERT INTO @VariableTabla VALUES ('         g7)Provisiones para contingencias y otras erogaciones especiales				               ',0)
INSERT INTO @VariableTabla VALUES ('H. Participaciones y Aportaciones				                                                       ',0)
INSERT INTO @VariableTabla VALUES ('         h1)Participaciones				                                                            ',0)
INSERT INTO @VariableTabla VALUES ('         h2)Aportaciones				                                                            ',0)
INSERT INTO @VariableTabla VALUES ('         h3)Convenios				                                                                 ',0)
INSERT INTO @VariableTabla VALUES ('I.Deuda Publica				                                                                      ',0)
INSERT INTO @VariableTabla VALUES ('         i1)Amortizaci�n de la deuda p�blica				                                        ',0)
INSERT INTO @VariableTabla VALUES ('         i2)Intereses de la deuda p�blica				                                             ',0)
INSERT INTO @VariableTabla VALUES ('         i3)Comisiones de la deuda p�blica				                                             ',0)
INSERT INTO @VariableTabla VALUES ('         i4)Gastos de la deuda p�blica				                                                  ',0)
INSERT INTO @VariableTabla VALUES ('         i5)Costo por coberturas				                                                       ',0)
INSERT INTO @VariableTabla VALUES ('         i6)Apoyos financieros				                                                       ',0)
INSERT INTO @VariableTabla VALUES ('         i7)Adeudos de ejercicios fiscales anteriores (ADEFAS)				                         ',0)
INSERT INTO @VariableTabla VALUES (''                                                                                                        ,0)
INSERT INTO @VariableTabla VALUES ('II. Gasto Etiquetado (II= A + B + C + D + E + F + G + H + I )				                         ',1)
INSERT INTO @VariableTabla VALUES ('A. Servicios Personales				'                                                                 ,0)
INSERT INTO @VariableTabla VALUES ('           a1)Remuneraciones al personal de car�cter permanente				                         ',0)
INSERT INTO @VariableTabla VALUES ('           a2)Remuneraciones al personal de car�cter transitorio				'                    ,0)
INSERT INTO @VariableTabla VALUES ('           a3)Remuneraciones adicionales y especiales				'                                   ,0)
INSERT INTO @VariableTabla VALUES ('           a4)Seguridad Social				'                                                       ,0)
INSERT INTO @VariableTabla VALUES ('           a5)Otras prestaciones sociales y econ�micas				'                              ,0)
INSERT INTO @VariableTabla VALUES ('           a6)Previsiones				'                                                            ,0)
INSERT INTO @VariableTabla VALUES ('           a7)Pago de est�mulos a servidores p�blicos				'                                   ,0)
INSERT INTO @VariableTabla VALUES ('B.Materiales y Suministros				'                                                            ,0)
INSERT INTO @VariableTabla VALUES ('           b1)Materiales de administraci�n, emisi�n de documentos y art�culos oficiales				',0)
INSERT INTO @VariableTabla VALUES ('           b2)Alimentos y utensilios				'                                                  ,0)
INSERT INTO @VariableTabla VALUES ('           b3)Materias primas y materiales de producci�n y comercializaci�n				'          ,0)
INSERT INTO @VariableTabla VALUES ('           b4)Materiales y art�culos de construcci�n y de reparaci�n				'                    ,0)
INSERT INTO @VariableTabla VALUES ('           b5)Productos qu�micos, farmac�uticos y de laboratorio				'                    ,0)
INSERT INTO @VariableTabla VALUES ('           b6)Combustibles, lubricantes y aditivos				 '                                  ,0)
INSERT INTO @VariableTabla VALUES ('           b7)Vestuario, blancos, prendas de protecci�n y art�culos deportivos				'          ,0)
INSERT INTO @VariableTabla VALUES ('           b8)Materiales y suministros para seguridad				'                                   ,0)
INSERT INTO @VariableTabla VALUES ('           b9)Herramientas, refacciones y accesorios menores				'                         ,0)
INSERT INTO @VariableTabla VALUES ('C. Servicios Generales				'                                                                 ,0)
INSERT INTO @VariableTabla VALUES ('           c1)Servicios b�sicos				'                                                       ,0)
INSERT INTO @VariableTabla VALUES ('           c2)Servicios de arrendamiento				'                                             ,0)
INSERT INTO @VariableTabla VALUES ('           c3)Servicios profesionales, cient�ficos, t�cnicos y otros servicios				'          ,0)
INSERT INTO @VariableTabla VALUES ('           c4)Servicios financieros, bancarios y comerciales				'                         ,0)
INSERT INTO @VariableTabla VALUES ('           c5)Servicios de instalaci�n, reparaci�n, mantenimiento y conservaci�n				'     ,0)
INSERT INTO @VariableTabla VALUES ('           c6)Servicios de comunicaci�n social y publicidad				'                         ,0)
INSERT INTO @VariableTabla VALUES ('           c7)Servicios de traslado y vi�ticos				'                                        ,0)
INSERT INTO @VariableTabla VALUES ('           c8)Servicios oficiales				'                                                       ,0)
INSERT INTO @VariableTabla VALUES ('           c9)Otros servicios generales				'                                             ,0)
INSERT INTO @VariableTabla VALUES ('D. Trasnferencias, Asignaciones, Subsidios y Otras ayudas				'                              ,0)
INSERT INTO @VariableTabla VALUES ('           d1)Transferencias internas y asignaciones al sector p�blico				'               ,0)
INSERT INTO @VariableTabla VALUES ('           d2)Transferencias al resto del sector p�blico				'                              ,0)
INSERT INTO @VariableTabla VALUES ('           d3)Subsidios y subvenciones				'                                                  ,0)
INSERT INTO @VariableTabla VALUES ('           d4)Ayudas sociales				'                                                       ,0)
INSERT INTO @VariableTabla VALUES ('           d5)Pensiones y jubilaciones				'                                                  ,0)
INSERT INTO @VariableTabla VALUES ('           d6)Transferencias a fideicomisos, mandatos y otros an�logos				'               ,0)
INSERT INTO @VariableTabla VALUES ('           d7)Transferencias a la seguridad social				'                                   ,0)
INSERT INTO @VariableTabla VALUES ('           d8)Donativos				'                                                                 ,0)
INSERT INTO @VariableTabla VALUES ('           d9)Transferencias al exterior				'                                             ,0)
INSERT INTO @VariableTabla VALUES ('E. Bienes Muebles, Inmuebles e Intangibles				'                                             ,0)
INSERT INTO @VariableTabla VALUES ('           e1)Mobiliario y equipo de administraci�n				'                                   ,0)
INSERT INTO @VariableTabla VALUES ('           e2)Mobiliario y equipo educacional y recreativo				'                              ,0)
INSERT INTO @VariableTabla VALUES ('           e3)Equipo e instrumental m�dico y de laboratorio				'                         ,0)
INSERT INTO @VariableTabla VALUES ('           e4)Veh�culos y equipo de transporte				'                                        ,0)
INSERT INTO @VariableTabla VALUES ('           e5)Equipo de defensa y seguridad				'                                             ,0)
INSERT INTO @VariableTabla VALUES ('           e6)Maquinaria, otros equipos y herramientas				'                              ,0)
INSERT INTO @VariableTabla VALUES ('           e7)Activos biol�gicos				'                                                       ,0)
INSERT INTO @VariableTabla VALUES ('           e8)Bienes inmuebles				'                                                       ,0)
INSERT INTO @VariableTabla VALUES ('           e9)Activos intangibles				'                                                       ,0)
INSERT INTO @VariableTabla VALUES ('F. Inversion Publica 				'                                                                 ,0)
INSERT INTO @VariableTabla VALUES ('           f1)Obra p�blica en bienes de dominio p�blico				'                              ,0)
INSERT INTO @VariableTabla VALUES ('           f2)Obra p�blica en bienes propios				'                                        ,0)
INSERT INTO @VariableTabla VALUES ('           f3)Proyectos productivos y acciones de fomento		 		'                              ,0)
INSERT INTO @VariableTabla VALUES ('G. Inversiones Financieras y Otras Provisiones				'                                        ,0)
INSERT INTO @VariableTabla VALUES ('            g1)Inversiones para el fomento de actividades productivas				'               ,0)
INSERT INTO @VariableTabla VALUES ('            g2)Acciones y participaciones de capital				'                                   ,0)
INSERT INTO @VariableTabla VALUES ('            g3)Compra de t�tulos y valores				'                                             ,0)
INSERT INTO @VariableTabla VALUES ('            g4)Concesi�n de pr�stamos				'                                                  ,0)
INSERT INTO @VariableTabla VALUES ('            g5)Inversiones en fideicomisos, mandatos y otros an�logos				'               ,0)
INSERT INTO @VariableTabla VALUES ('            g6)Otras inversiones financieras				'                                        ,0)
INSERT INTO @VariableTabla VALUES ('            g7)Provisiones para contingencias y otras erogaciones especiales				'          ,0)
INSERT INTO @VariableTabla VALUES ('H. Participaciones y Aportaciones				'                                                       ,0)
INSERT INTO @VariableTabla VALUES ('            h1)Participaciones				'                                                       ,0)
INSERT INTO @VariableTabla VALUES ('            h2)Aportaciones				'                                                            ,0)
INSERT INTO @VariableTabla VALUES ('            h3)Convenios				'                                                            ,0)
INSERT INTO @VariableTabla VALUES ('I.Deuda Publica				'                                                                      ,0)
INSERT INTO @VariableTabla VALUES ('            i1)Amortizaci�n de la deuda p�blica				'                                        ,0)
INSERT INTO @VariableTabla VALUES ('            i2)Intereses de la deuda p�blica				'                                        ,0)
INSERT INTO @VariableTabla VALUES ('            i3)Comisiones de la deuda p�blica				'                                        ,0)
INSERT INTO @VariableTabla VALUES ('            i4)Gastos de la deuda p�blica				'                                             ,0)
INSERT INTO @VariableTabla VALUES ('            i5)Costo por coberturas				'                                                  ,0)
INSERT INTO @VariableTabla VALUES ('            i6)Apoyos financieros				'                                                       ,0)
INSERT INTO @VariableTabla VALUES ('            i7)Adeudos de ejercicios fiscales anteriores (ADEFAS)				'                    ,0)
INSERT INTO @VariableTabla VALUES ('	'                                                                                                    ,0)
INSERT INTO @VariableTabla VALUES ('III. Total de Egresos III= I + II )	'                                                                 ,1)

SELECT  * FROM @VariableTabla 
END



EXEC SP_FirmasReporte 'Clasificacion por Objeto Gasto(Capitulo y Concepto)'
GO

Exec SP_CFG_LogScripts 'SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado'

GO