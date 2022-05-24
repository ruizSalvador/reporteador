--Se pensaba eliminar la funcionalidad en estos formatos, pero utilizan c�digo ISO
--UPDATE C_Formatos SET utilizar=0 WHERE Formato IN(
--'Reporte de �rdenes de compra y servicios por unida responsable, partida y proveedor',
--'Reporte de ordenes de compras y servicios detallado por proveedor',
--'Reporte de ordenes de compras y servicios detallado por proveedor Sin UR y Departamento',
--'Reporte de Ordenes de Compra y Servicio por Unidad Responsable ',
--'Reporte de �rdenes de compra y servicios por unidad responsable y partida',
--'Reporte Balanza de Comprobacion',
--'LIBRO DIARIO ',
--'LIBRO MAYOR.  ',
--'Reporte de ordenes de compras y servicios concentrado por proveedor',
--'Clasificaci�n Econ�mica',
--'Conciliacion Movimientos Conciliados',
--'Conciliacion Movimientos No Conciliados',
--'Cheques y Transferencias',
--'Facturas Recibidas ',
--'Saldos Promedio',
--'Tarifario Ingresos',
--'Cat�logo de Empleados ',
--'Cat�logo de Productos ',
--'Catalogo de Proveedores ',
--'Cat�logo Plan de Cuentas ',
--'Gasto Devengado por Departamento ',
--'AuxiliarPresupuestal',
--'Estado Anal�tico del Ejercicio del Presupuesto de Egresos Sector Paraestatal',
--'Estado Anal�tico del Ejercicio del Presupuesto de Egresos Por Poder',
--'Existencias en almac�n' 
--)
print 'Eliminando Formatos sin Utilizar...'
GO
DELETE  C_Formatos WHERE Formato in (
'Variaciones en la Hacienda P�blica / Patrimonio',
'Analitico de la deuda p�blica',
'Notas al Estado de Situaci�n Financiera Fondos de Bienes de Terceros en Administrac�n y/o en garant�',
'Notas al Estado de Situaci�n Financiera- BDTC-Almac�n',
'Efectivo y Equivalentes - Bienes Muebles e Inmuebles',
'Efectivo y Equivalentes - Saldo Inicial y Final',
'Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto',
'Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Cap�tul',
'Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversi�n / Objeto del Gasto por ',
'Ramo o Dependencia / Distribuci�n Georg�fica / Programas y Proyectos de Inversi�n',
'Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por C',
'Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por P',
'Ramo o Dependencia / UR / Programas y Proyectos de Inversi�n / Objeto del Gasto por Cap�tulo / Clasi',
'Ramo o Dependencia / UR / Programas y Proyectos de Inversi�n / Objeto del Gasto por Partida Gen�rica',
'IPComp:Ramo o Dependencia / Funci�n / Programa Presupuestario / Actividad Institucional',
'IPComp:Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gast',
'IPComp:Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por ',
'IPComp:Ramo o Dependencia / Funci�n / Programas y Proyectos de Inversi�n',
'IPComp:Ramo o Dependencia / UR / Programas y Proyectos de Inversi�n / Objeto del Gasto por Cap�tulo ',
'IPComp:Ramo o Dependencia / UR / Programas y Proyectos de Inversi�n / Objeto del Gasto por Partida G',
'IPComp:Ramo o Dependencia / Distribuci�n Georg�fica / Programas y Proyectos de Inversi�n',
'Reporte de Ordenes de Compra por Unidad Responsable y Partida',
'Reporte de Ordenes de Compra por Unidad Responsable, Partida y Proveedor',
'Reporte de Ordenes de Compra por Proveedor',
'Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Cap�tulo / Clasificaci�n Econ�mica',
'IPComp:Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Cap�tulo',
'IPComp:Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Cap�tulo / Clasificaci�n Econ�mica',
'IPComp:Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Gen�rica / Fuente de Financiamiento',
'IPComp:Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Gen�rica / Distribuci�n Georgr�fica',
'IPComp:Ramo o Dependencia / UR / Programas y Proyectos de Inversi�n / Objeto del Gasto por Cap�tulo / Clasificaci�n Econ�mica',
'IPComp:Ramo o Dependencia / UR / Programas y Proyectos de Inversi�n / Objeto del Gasto por Partida Gen�rica / Fuente de Financiamiento',
'IPComp:Ramo o Dependencia / Distribuci�n Geogr�fica / Programas y Proyectos de Inversi�n',
'Plan de Cuentas',
'NOTAS A LOS ESTADOS FINANCIEROS (De Memoria)',
'NOTAS A LOS ESTADOS FINANCIEROS (Desglose)',
'NOTAS A LOS ESTADOS FINANCIEROS (Gestion Administrativa)',
'NOTAS DE GESTI�N ADMINISTRATIVA',
'Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Cap�tulo',
'Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Gen�rica / Fuente de Financiamiento',
'Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Gen�rica / Distribuci�n Georgr�fica',
'Ramo o Dependencia / UR / Programas y Proyectos de Inversi�n / Objeto del Gasto por Cap�tulo / Clasificaci�n Econ�mica',
'Ramo o Dependencia / UR / Programas y Proyectos de Inversi�n / Objeto del Gasto por Partida Gen�rica / Fuente de Financiamiento',
'Cuenta Economica',
'APROBACION DE SOLICITUD DE PAGO',
'Reporte Ingresos'
)
GO
PRINT 'Homologando Nombres de formatos con firmas y c�digo ISO...'
GO
--Comentados tienen el mismo nombre
--UPDATE C_Formatos SET Formato = 'Estado de actividades' WHERE Formato ='Estado de actividades'
--UPDATE C_Formatos SET Formato = 'Estado de situacion financiera' WHERE Formato ='Estado de situacion financiera'
--UPDATE C_Formatos SET Formato = 'Analitico del activo' WHERE Formato ='Analitico del activo'
UPDATE C_Formatos SET Formato = 'Clasificaci�n General' WHERE Formato ='Ejercicio del Presupuesto Clasificaci�n General'
UPDATE C_Formatos SET Formato = 'Por Fuente de Financiamiento' WHERE Formato ='Ejercicio del Presupuesto Fuente Financiamiento'
UPDATE C_Formatos SET Formato = 'Clasificaci�n Economica (por tipo de Gasto)' WHERE Formato ='Ejercicio del Presupuesto Clasificaci�n Econ�mica'
UPDATE C_Formatos SET Formato = 'Clasificaci�n por Objeto del Gasto (Cap-Con)' WHERE Formato ='Ejercicio del Presupuesto Cap�tulo del Gasto'
UPDATE C_Formatos SET Formato = 'Clasificaci�n Funcional (Finalidad Y Funci�n)' WHERE Formato ='Ejercicio del Presupuesto Clasificaci�n Funcional'
UPDATE C_Formatos SET Formato = 'Por Clasificaci�n Funcional/Subfunci�n' WHERE Formato ='Ejercicio del Presupuesto Clasificaci�n Funcional-Subfunci�n'
UPDATE C_Formatos SET Formato = 'Por Clasificaci�n Econ�mica / Cap�tulo de Gasto' WHERE Formato ='Ejercicio del Presupuesto Clasificaci�n Econ�mica y Cap�tulo de Gasto'
UPDATE C_Formatos SET Formato = 'Por Partida/Fuente de Financiamiento' WHERE Formato ='Ejercicio del Presupuesto Partida Gen�rica y Fuente de Financiamiento'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR' WHERE Formato ='Por Ramo / Unidad Responsable'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Clasificaci�n Econ�mica' WHERE Formato ='Por Ramo / Clasificaci�n Econ�mica'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Clasificaci�n Econ�mica / Cap�tulo Gasto' WHERE Formato ='Por Ramo / Clasificaci�n Econ�mica / Cap�tulo Gasto'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Cap�tulo y Concepto Gasto' WHERE Formato ='Por Ramo / Cap�tulo y Concepto Gasto'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Clasificaci�n Funcional / Subfunci�n' WHERE Formato ='Por Ramo / Clasificaci�n Funcional / Subfunci�n'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Cap�tulo y Concepto Gasto' WHERE Formato ='Por Ramo / Unidad Responsable / Cap�tulo y Concepto Gasto'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Programa' WHERE Formato ='Por Ramo / Programa'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Programa' WHERE Formato ='Por Ramo / Unidad Responsable / Programa'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Distribuci�n Geogr�fica' WHERE Formato ='Por Ramo / Distribuci�n Geogr�fica'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Clasificaci�n Econ�mica / Distribuci�n Geogr�fica' WHERE Formato ='Por Ramo / Clasificaci�n Econ�mica / Distribuci�n Geogr�fica'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Partida Gen�rica' WHERE Formato ='Por Ramo / Unidad Responsable / Partida Gen�rica'
--UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Partida Espec�fica' WHERE Formato ='Por Ramo / UR / Partida Espec�fica'
--UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Programa / Actividad Institucional / Objeto Gasto 3N' WHERE Formato ='Por Ramo / UR / Programa / Actividad Institucional / Objeto Gasto 3N'
--UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Programa / Objeto Gasto por Cap�tulo' WHERE Formato ='Por Ramo / UR / Programa / Objeto Gasto por Cap�tulo'
UPDATE C_Formatos SET Formato = 'Estado Analitico De Ingresos por Rubro' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos por Rubro'
--UPDATE C_Formatos SET Formato = 'Estado de Flujos de Efectivo' WHERE Formato ='Estado de Flujos de Efectivo'
UPDATE C_Formatos SET Formato = 'Efectivo y Equivalentes/Inversiones' WHERE Formato ='Notas al Estado de Situaci�n Financiera-EE-Inversiones Financieras'
UPDATE C_Formatos SET Formato = 'Efectivo y Equivalentes/Fondos' WHERE Formato ='Fondos con Afectaci�n Espec�fica'
UPDATE C_Formatos SET Formato = 'Pasivos Diferidos Y Otros' WHERE Formato ='Notas al Estado de Situaci�n Financiera Pasivos diferidos y otros'
UPDATE C_Formatos SET Formato = 'Patrimonio Contribuido' WHERE Formato ='Notas al Estado de Variaciones en la Hacienda P�blica / Patrimonio'
UPDATE C_Formatos SET Formato = 'Estimaciones y Deterioros' WHERE Formato ='Notas al Estado de Situaci�n Financiera Estimaciones y Deterioros'
UPDATE C_Formatos SET Formato = 'Otros Activos' WHERE Formato ='Notas al Estado de Situaci�n Financiera Otros Activos'
UPDATE C_Formatos SET Formato = 'Bienes Disp Transf o Consumo/Inventarios' WHERE Formato ='Notas al Estado de Situaci�n Financiera-BDToC-Inventarios'
UPDATE C_Formatos SET Formato = 'Derecho a Recibir Efvo y Eq/Contribuciones' WHERE Formato ='Notas al Estado de Situaci�n Financiera-DREoE-CPdeCyRecuperar'
UPDATE C_Formatos SET Formato = 'Derecho a Recibir Efvo y Eq/Derechos,Bienes y Servicios' WHERE Formato ='Notas al Estado de Situaci�n Financiera-DREoE-Dreye-bosrvenc'
UPDATE C_Formatos SET Formato = 'Inversiones Financieras/Fideicomisos' WHERE Formato ='Notas al Estado de Situaci�n Financiera_if_fideicomisos'
UPDATE C_Formatos SET Formato = 'Inversiones Financieras/Participaciones y Aportaciones' WHERE Formato ='Notas al Estado de Situaci�n Financiera -IF-Saldos Aportaciones y Aportaciones Capital'
--UPDATE C_Formatos SET Formato = 'Gastos y Otras P�rdidas' WHERE Formato ='Gastos y Otras P�rdidas'
--UPDATE C_Formatos SET Formato = 'Ingresos de Gesti�n' WHERE Formato ='Ingresos de Gesti�n'
UPDATE C_Formatos SET Formato = 'Patrimonio Generado' WHERE Formato ='Monto y procedencia de los recursos que modifican al patrimonio generado'
--UPDATE C_Formatos SET Formato = 'Otros Ingresos y Beneficios' WHERE Formato ='Otros Ingresos y Beneficios'
UPDATE C_Formatos SET Formato = 'Por Ramo / Funci�n / Programa / Actividad' WHERE Formato ='Ramo o Dependencia / Funci�n / Programa Presupuestario / Actividad Institucional'
UPDATE C_Formatos SET Formato = 'Por Ramo / Funci�n / Proyecto Inversi�n' WHERE Formato ='Ramo o Dependencia / Funci�n / Programas y Proyectos de Inversi�n'
UPDATE C_Formatos SET Formato = 'Notas Contables' WHERE Formato ='Notas al Estado de Situaci�n Financiera_NotasdeMemoria_contables'
UPDATE C_Formatos SET Formato = 'Notas Presupuestarias' WHERE Formato ='Notas al Estado de Situaci�n Financiera_NotasdeMemoria_presupuestarias'
UPDATE C_Formatos SET Formato = 'Por Area Administrativa Recaudadora/Rubro/Tipo/Clase/Concepto' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos por Rubro, Tipo, Clase y Concepto'
UPDATE C_Formatos SET Formato = 'Por Rubro/Tipo/Clase' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos por Rubro, Tipo y Clase'
UPDATE C_Formatos SET Formato = 'Por Rubro/Tipo' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos por Rubro y Tipo'
UPDATE C_Formatos SET Formato = 'Por Concepto/Fuente de Financiamiento' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos por Concepto y Fuente de financiamiento'
UPDATE C_Formatos SET Formato = 'Por Clasificaci�n Economica/Rubro/Tipo/Clase/Concepto' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos Clasificacion economica por Rubro, Tipo, Clase y Concepto'
UPDATE C_Formatos SET Formato = 'Cuentas Por Pagar' WHERE Formato ='Notas al Estado de Situacion Financiera Cuentas y Documentos por Pagar'
UPDATE C_Formatos SET Formato = 'Por Clasificaci�n Economica/Rubro/Tipo' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos Clasificacion economica por Rubro y Tipo'
UPDATE C_Formatos SET Formato = 'Por Clasificaci�n Economica/Rubro/Tipo/Clase' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos Clasificacion economica por Rubro, Tipo y Clase'
UPDATE C_Formatos SET Formato = 'Calendario de Ingresos Base Mensual' WHERE Formato ='Calendario Mensual Ingresos'
--UPDATE C_Formatos SET Formato = 'Calendario de Egresos Base Mensual' WHERE Formato ='Calendario de Egresos Base Mensual'
--UPDATE C_Formatos SET Formato = 'Difusi�n a la Ciudadan�a de la Ley de Ingresos' WHERE Formato ='Difusi�n a la Ciudadan�a de la Ley de Ingresos'
UPDATE C_Formatos SET Formato = 'Difusi�n a la Ciudadan�a del presupuesto de Egresos' WHERE Formato ='Difusi�n a la Ciudadan�a del Presupuesto de Egresos'
UPDATE C_Formatos SET Formato = 'Programas con Recursos Concurrente por Orden de Gobierno' WHERE Formato ='Formato de Programas con Recursos Concurrente por Orden de Gobierno'
UPDATE C_Formatos SET Formato = 'Por Ramo/ UR / Programa / Actividad / objeto del Gasto Cap�tulo' WHERE Formato ='Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / objeto del Gasto por Cap�tulo'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Programa / Actividad  / Objeto Gasto Partida / Fuente de Financiamiento' WHERE Formato ='Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Gen�rica / Fuente de Financiamiento'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Programa/ Actividad/ Objeto Gasto Partida / Distribuci�n Georgr�fica' WHERE Formato ='Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Gen�rica / Distribuci�n Georgr�fica'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Proyecto/ Objeto Gasto Cap�tulo / Clasificaci�n Econ�mica' WHERE Formato ='Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversi�n / Objeto del Gasto por Cap�tulo / Clasificaci�n Econ�mica'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Proyecto/ Objeto Gasto Partida/ Fuente de Financiamiento' WHERE Formato ='Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversi�n / Objeto del Gasto por Partida Gen�rica / Fuente de Financiamiento'
UPDATE C_Formatos SET Formato = 'Por Ramo/ Distribuci�n Geogr�fica /Proyecto' WHERE Formato ='Ramo o Dependencia / Distribuci�n Geogr�fica / Programas y Proyectos de Inversi�n'
--UPDATE C_Formatos SET Formato = 'Iniciativa de la Ley de Ingresos' WHERE Formato ='Iniciativa de la Ley de Ingresos'
--UPDATE C_Formatos SET Formato = 'Bienes Muebles e Inmuebles' WHERE Formato ='Bienes Muebles e Inmuebles'
--UPDATE C_Formatos SET Formato = 'Saldos Inicial y Final' WHERE Formato ='Saldo Inicial y Final'
UPDATE C_Formatos SET Formato = 'Bienes Disp Transf o Consumo/Almacen' WHERE Formato ='Notas al Estado de Situaci�n Financiera-BDToC-Almac�n'
UPDATE C_Formatos SET Formato = 'Bienes Muebles,Inm e Int/Activos Intangibles y diferidos' WHERE Formato ='Notas al Estado de Situacion Financiera Bienes Inmuebles, Inmuebles e Intangibles - Activos Intangibles y Diferidos'
UPDATE C_Formatos SET Formato = 'Bienes Muebles,Inm e Int/Bienes Muebles e Inmuebles' WHERE Formato ='Notas al Estado de Situacion Financiera Bienes Inmuebles, Inmuebles e Intangibles - Bienes Inmuebles, Inmuebles e Intangibles'
UPDATE C_Formatos SET Formato = 'Fondos' WHERE Formato ='Notas al Estado de Situaci�n Financiera Fondos de Bienes de Terceros en Administrac�n y/o en garant�a a corto y largo plazo'
UPDATE C_Formatos SET Formato = 'Ejercicio y Destino de Gasto Federalizado y Reintegros' WHERE Formato ='Formato del ejercicio y destino de gasto federalizado y reintegros'
--UPDATE C_Formatos SET Formato = 'Obligaciones pagadas o garantizadas con fondos federales' WHERE Formato ='Obligaciones pagadas o garantizadas con fondos federales'
--UPDATE C_Formatos SET Formato = 'Conciliaci�n Ahorro/Desahorro' WHERE Formato ='Conciliaci�n Ahorro Desahorro'
--UPDATE C_Formatos SET Formato = 'Relaci�n de cuentas bancarias productivas espec�ficas' WHERE Formato ='Relaci�n de cuentas bancarias productivas espec�ficas'
UPDATE C_Formatos SET Formato = 'Aplicaci�n de recursos FORTAMUN' WHERE Formato ='Formato de infomaci�n de recursos del FORTAMUN'
UPDATE C_Formatos SET Formato = '74.l.a Personal comisionado o con licencia' WHERE Formato ='Personal comisionado o con licencia'
UPDATE C_Formatos SET Formato = '74.l.b Pagos retroactivos' WHERE Formato ='Pagos retroactivos'
UPDATE C_Formatos SET Formato = '74-l-c Pagos diferentes al costo asociado a las plazas' WHERE Formato ='Pagos diferentes al costo asociado a las plazas'
--UPDATE C_Formatos SET Formato = 'Trabajadores Comisionados' WHERE Formato ='Trabajadores Comisionados'
--UPDATE C_Formatos SET Formato = 'Trabajadores con Licencia' WHERE Formato ='Trabajadores con Licencia'
--UPDATE C_Formatos SET Formato = 'Trabajadores Jubilados y con Licencia Prejubilatoria' WHERE Formato ='Trabajadores Jubilados y con Licencia Prejubilatoria'
--UPDATE C_Formatos SET Formato = 'Tabulador' WHERE Formato ='Tabulador'
UPDATE C_Formatos SET Formato = 'Difusi�n Resultados Evaluaciones' WHERE Formato ='Formato para la Difusi�n de los Resultados de las Evaluaciones'
--UPDATE C_Formatos SET Formato = 'Anal�tico de Plazas' WHERE Formato ='Anal�tico de Plazas'
UPDATE C_Formatos SET Formato = 'Cat�logo de Percepciones y Deducciones' WHERE Formato ='Cat�logo de Conceptos de Percepciones y Deducciones'
--UPDATE C_Formatos SET Formato = 'Libro de Inventarios de Bienes Muebles e Inmuebles' WHERE Formato ='Libro de Inventarios de Bienes Muebles e Inmuebles'
--UPDATE C_Formatos SET Formato = 'Montos pagados por ayudas y subsidios' WHERE Formato ='Montos pagados por ayudas y subsidios'
--UPDATE C_Formatos SET Formato = 'Personal por Honorarios' WHERE Formato ='Personal por Honorarios'
--UPDATE C_Formatos SET Formato = 'Plazas Existentes' WHERE Formato ='Plazas Existentes'
--UPDATE C_Formatos SET Formato = 'Relaci�n de Bienes Muebles e Inmuebles' WHERE Formato ='Relaci�n de Bienes Muebles e Inmuebles'
--UPDATE C_Formatos SET Formato = 'Auxiliar Sujeto a Inventario de Bienes Arqueol�gicos, Art�sticos e Hist�ricos' WHERE Formato ='Auxiliar Sujeto a Inventario de Bienes Arqueol�gicos, Art�sticos e Hist�ricos'
--UPDATE C_Formatos SET Formato = 'Libro de Almac�n de Materias y Suministros de Consumo' WHERE Formato ='Libro de Almac�n de Materias y Suministros de Consumo'
--UPDATE C_Formatos SET Formato = 'Libro de Inventarios de Materias Primas, Materiales y Suministros para Producci�n y Comercializaci�n' WHERE Formato ='Libro de Inventarios de Materias Primas, Materiales y Suministros para Producci�n y Comercializaci�n'
--UPDATE C_Formatos SET Formato = 'Personal Comisionado' WHERE Formato ='Personal Comisionado'
UPDATE C_Formatos SET Formato = 'Pagos Retroactivos' WHERE Formato ='Pagos Retroactivos FETA'
--UPDATE C_Formatos SET Formato = 'Personal con Licencia' WHERE Formato ='Personal con Licencia'
--UPDATE C_Formatos SET Formato = 'Plaza/Funci�n' WHERE Formato ='Plaza/Funci�n'
--UPDATE C_Formatos SET Formato = 'Movimientos de Personal por Centro de Trabajo' WHERE Formato ='Movimientos de Personal por Centro de Trabajo'
--UPDATE C_Formatos SET Formato = 'Trabajadores Jubilados' WHERE Formato ='Trabajadores Jubilados'
--UPDATE C_Formatos SET Formato = 'Trabajadores con Licencia Prejubilatoria' WHERE Formato ='Trabajadores con Licencia Prejubilatoria'
--UPDATE C_Formatos SET Formato = 'Trabajadores por Honorarios' WHERE Formato ='Trabajadores por Honorarios'
--UPDATE C_Formatos SET Formato = 'Anal�tico de Categor�as' WHERE Formato ='Anal�tico de Categor�as'
--UPDATE C_Formatos SET Formato = 'Cat�logo de Categor�as y Tabuladores' WHERE Formato ='Cat�logo de Categor�as y Tabuladores'
--UPDATE C_Formatos SET Formato = 'Cat�logo de Percepciones y Deducciones' WHERE Formato ='Cat�logo de Percepciones y Deducciones'
UPDATE C_Formatos SET Formato = 'Trabajadores que Cobran con RFC/CURP con Formato Incorrecto' WHERE Formato ='Formato Incorrecto'
--UPDATE C_Formatos SET Formato = 'Trabajadores con Doble Asignaci�n Salarial' WHERE Formato ='Trabajadores con Doble Asignaci�n Salarial'
--UPDATE C_Formatos SET Formato = 'Trabajadores que Superan el N�m. de Hrs. de Compatibilidad' WHERE Formato ='Trabajadores que Superan el N�m. de Hrs. de Compatibilidad'
--UPDATE C_Formatos SET Formato = 'Trabajadores Cuyo Salario Supere los Ingresos Promedio' WHERE Formato ='Trabajadores Cuyo Salario Supere los Ingresos Promedio'
--UPDATE C_Formatos SET Formato = 'Proyecto del Presupuesto de Egresos' WHERE Formato ='Proyecto del Presupuesto de Egresos'
--UPDATE C_Formatos SET Formato = 'Anal�tico de la Deuda y Otros Pasivos' WHERE Formato ='Anal�tico de la Deuda P�blica y Otros Pasivos'
--UPDATE C_Formatos SET Formato = 'Estado de Cambios en la Situaci�n Financiera' WHERE Formato ='Estado de Cambios en la Situaci�n Financiera'
--UPDATE C_Formatos SET Formato = 'Estado de Variaci�n en la Hacienda P�blica' WHERE Formato ='Estado de Variaci�n en la Hacienda P�blica'
UPDATE C_Formatos SET Formato = 'Estado Analitico De Ingresos por fuente de financiamiento' WHERE Formato ='Estado del ejercicio de Ingresos Por Fuente de Financiamiento'
--UPDATE C_Formatos SET Formato = 'Formato Espec�fico de Aplicaci�n de Recursos a Seguridad P�blica' WHERE Formato ='Formato Espec�fico de Aplicaci�n de Recursos a Seguridad P�blica'
--UPDATE C_Formatos SET Formato = 'Formato Gral. de Aplicaci�n de Recursos a Seguridad P�blica' WHERE Formato ='Formato Gral. de Aplicaci�n de Recursos a Seguridad P�blica'
UPDATE C_Formatos SET Formato = 'REPORTE FAIS' WHERE Formato ='Montos que reciban, obras y acciones a realizar con el FAIS'
--UPDATE C_Formatos SET Formato = 'Informe Sobre Pasivos Contingentes' WHERE Formato ='Informe Sobre Pasivos Contingentes'
--UPDATE C_Formatos SET Formato = 'Conciliacion entre los Egresos Presupuestales y Gastos Contables' WHERE Formato ='Conciliacion entre los Egresos Presupuestarios y Gastos Contables'
UPDATE C_Formatos SET Formato = 'Clasificaci�n Administrativa-Dependencia' WHERE Formato ='Ejercicio del Presupuesto Clasificaci�n Administrativa'
--UPDATE C_Formatos SET Formato = 'Conciliacion entre los Ingresos Presupuestales y Contables' WHERE Formato ='Conciliacion entre los Ingresos Presupuestarios y Contables'
--UPDATE C_Formatos SET Formato = 'Endeudamiento Neto' WHERE Formato ='Endeudamiento Neto'
--UPDATE C_Formatos SET Formato = 'Indicadores de Postura Fiscal' WHERE Formato ='Indicadores de Postura Fiscal'
--UPDATE C_Formatos SET Formato = 'Inter�s de la Deuda' WHERE Formato ='Intereses de la Deuda'
--UPDATE C_Formatos SET Formato = 'Gasto por Categor�a Program�tica' WHERE Formato ='Gasto por Categor�a Program�tica'
UPDATE C_Formatos SET Formato = 'Anal�tico del ejercicio de Egresos' WHERE Formato ='REPORTE ANAL�TICO DEL EJERCICIO DEL PRESUPUESTO DE EGRESOS (POR PARTIDA HASTA 4� NIVEL)'
GO

PRINT'Homologando nombres de Formatos sin firmas (Solo c�digo ISO)'
GO
--Comentados tienen el mismo nombre
UPDATE C_Formatos SET Formato = 'OC/OS Por Unidad Responsable/ Partida/proveedor' WHERE Formato = 'Reporte de �rdenes de compra y servicios por unida responsable, partida y proveedor'
UPDATE C_Formatos SET Formato = 'OC/OS Detallado Por Proveedor' WHERE Formato = 'Reporte de ordenes de compras y servicios detallado por proveedor'
UPDATE C_Formatos SET Formato = 'OC/OS Detallado Por Proveedor/Unidad Reponsable' WHERE Formato = 'Reporte de ordenes de compras y servicios detallado por proveedor Sin UR y Departamento'
UPDATE C_Formatos SET Formato = 'OC/OS Por Unidad Reponsable' WHERE Formato = 'Reporte de Ordenes de Compra y Servicio por Unidad Responsable '
UPDATE C_Formatos SET Formato = 'OC/OS Por Unidad Responsable/ Partida' WHERE Formato = 'Reporte de �rdenes de compra y servicios por unidad responsable y partida'
UPDATE C_Formatos SET Formato = 'Balanza de Comprobacion' WHERE Formato = 'Reporte Balanza de Comprobacion'
UPDATE C_Formatos SET Formato = 'Libro Diario' WHERE Formato = 'LIBRO DIARIO '
UPDATE C_Formatos SET Formato = 'Libro Mayor' WHERE Formato = 'LIBRO MAYOR.  '
UPDATE C_Formatos SET Formato = 'OC/OS Concentrado Por Proveedor' WHERE Formato = 'Reporte de ordenes de compras y servicios concentrado por proveedor'
--UPDATE C_Formatos SET Formato = 'Clasificaci�n Econ�mica' WHERE Formato = 'Clasificaci�n Econ�mica'
UPDATE C_Formatos SET Formato = 'Movimientos Conciliados' WHERE Formato = 'Conciliacion Movimientos Conciliados'
UPDATE C_Formatos SET Formato = 'Movimientos No Conciliados' WHERE Formato = 'Conciliacion Movimientos No Conciliados'
UPDATE C_Formatos SET Formato = 'Cheques y Transferencias Electronicas' WHERE Formato = 'Cheques y Transferencias'
--UPDATE C_Formatos SET Formato = 'Facturas Recibidas' WHERE Formato = 'Facturas Recibidas '
--UPDATE C_Formatos SET Formato = 'Saldos Promedio' WHERE Formato = 'Saldos Promedio'
--UPDATE C_Formatos SET Formato = 'Tarifario Ingresos' WHERE Formato = 'Tarifario Ingresos'
--UPDATE C_Formatos SET Formato = 'Cat�logo de Empleados' WHERE Formato = 'Cat�logo de Empleados '
--UPDATE C_Formatos SET Formato = 'Cat�logo de Productos' WHERE Formato = 'Cat�logo de Productos '
--UPDATE C_Formatos SET Formato = 'Catalogo de Proveedores' WHERE Formato = 'Catalogo de Proveedores '
--UPDATE C_Formatos SET Formato = 'Cat�logo Plan de Cuentas' WHERE Formato = 'Cat�logo Plan de Cuentas '
--UPDATE C_Formatos SET Formato = 'Gasto Devengado por Departamento' WHERE Formato = 'Gasto Devengado por Departamento '
--UPDATE C_Formatos SET Formato = 'Auxiliar Presupuestal' WHERE Formato = 'AuxiliarPresupuestal'
UPDATE C_Formatos SET Formato = 'Clasificacion Administrativa-Sector Paraestatal' WHERE Formato = 'Estado Anal�tico del Ejercicio del Presupuesto de Egresos Sector Paraestatal'
UPDATE C_Formatos SET Formato = 'Clasificaci�n Administrativa-Gobierno' WHERE Formato = 'Estado Anal�tico del Ejercicio del Presupuesto de Egresos Por Poder'
--UPDATE C_Formatos SET Formato = 'Existencias en almac�n' WHERE Formato = 'Existencias en almac�n' 
GO
