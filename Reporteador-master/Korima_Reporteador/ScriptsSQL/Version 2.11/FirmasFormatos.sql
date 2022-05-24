--Se pensaba eliminar la funcionalidad en estos formatos, pero utilizan código ISO
--UPDATE C_Formatos SET utilizar=0 WHERE Formato IN(
--'Reporte de órdenes de compra y servicios por unida responsable, partida y proveedor',
--'Reporte de ordenes de compras y servicios detallado por proveedor',
--'Reporte de ordenes de compras y servicios detallado por proveedor Sin UR y Departamento',
--'Reporte de Ordenes de Compra y Servicio por Unidad Responsable ',
--'Reporte de órdenes de compra y servicios por unidad responsable y partida',
--'Reporte Balanza de Comprobacion',
--'LIBRO DIARIO ',
--'LIBRO MAYOR.  ',
--'Reporte de ordenes de compras y servicios concentrado por proveedor',
--'Clasificación Económica',
--'Conciliacion Movimientos Conciliados',
--'Conciliacion Movimientos No Conciliados',
--'Cheques y Transferencias',
--'Facturas Recibidas ',
--'Saldos Promedio',
--'Tarifario Ingresos',
--'Catálogo de Empleados ',
--'Catálogo de Productos ',
--'Catalogo de Proveedores ',
--'Catálogo Plan de Cuentas ',
--'Gasto Devengado por Departamento ',
--'AuxiliarPresupuestal',
--'Estado Analítico del Ejercicio del Presupuesto de Egresos Sector Paraestatal',
--'Estado Analítico del Ejercicio del Presupuesto de Egresos Por Poder',
--'Existencias en almacén' 
--)
print 'Eliminando Formatos sin Utilizar...'
GO
DELETE  C_Formatos WHERE Formato in (
'Variaciones en la Hacienda Pública / Patrimonio',
'Analitico de la deuda pública',
'Notas al Estado de Situación Financiera Fondos de Bienes de Terceros en Administracón y/o en garantí',
'Notas al Estado de Situación Financiera- BDTC-Almacén',
'Efectivo y Equivalentes - Bienes Muebles e Inmuebles',
'Efectivo y Equivalentes - Saldo Inicial y Final',
'Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto',
'Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítul',
'Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por ',
'Ramo o Dependencia / Distribución Georgáfica / Programas y Proyectos de Inversión',
'Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por C',
'Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por P',
'Ramo o Dependencia / UR / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasi',
'Ramo o Dependencia / UR / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica',
'IPComp:Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional',
'IPComp:Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gast',
'IPComp:Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por ',
'IPComp:Ramo o Dependencia / Función / Programas y Proyectos de Inversión',
'IPComp:Ramo o Dependencia / UR / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo ',
'IPComp:Ramo o Dependencia / UR / Programas y Proyectos de Inversión / Objeto del Gasto por Partida G',
'IPComp:Ramo o Dependencia / Distribución Georgáfica / Programas y Proyectos de Inversión',
'Reporte de Ordenes de Compra por Unidad Responsable y Partida',
'Reporte de Ordenes de Compra por Unidad Responsable, Partida y Proveedor',
'Reporte de Ordenes de Compra por Proveedor',
'Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica',
'IPComp:Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo',
'IPComp:Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica',
'IPComp:Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento',
'IPComp:Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Distribución Georgráfica',
'IPComp:Ramo o Dependencia / UR / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasificación Económica',
'IPComp:Ramo o Dependencia / UR / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento',
'IPComp:Ramo o Dependencia / Distribución Geográfica / Programas y Proyectos de Inversión',
'Plan de Cuentas',
'NOTAS A LOS ESTADOS FINANCIEROS (De Memoria)',
'NOTAS A LOS ESTADOS FINANCIEROS (Desglose)',
'NOTAS A LOS ESTADOS FINANCIEROS (Gestion Administrativa)',
'NOTAS DE GESTIÓN ADMINISTRATIVA',
'Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo',
'Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento',
'Ramo o Dependencia / UR / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Distribución Georgráfica',
'Ramo o Dependencia / UR / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasificación Económica',
'Ramo o Dependencia / UR / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento',
'Cuenta Economica',
'APROBACION DE SOLICITUD DE PAGO',
'Reporte Ingresos'
)
GO
PRINT 'Homologando Nombres de formatos con firmas y código ISO...'
GO
--Comentados tienen el mismo nombre
--UPDATE C_Formatos SET Formato = 'Estado de actividades' WHERE Formato ='Estado de actividades'
--UPDATE C_Formatos SET Formato = 'Estado de situacion financiera' WHERE Formato ='Estado de situacion financiera'
--UPDATE C_Formatos SET Formato = 'Analitico del activo' WHERE Formato ='Analitico del activo'
UPDATE C_Formatos SET Formato = 'Clasificación General' WHERE Formato ='Ejercicio del Presupuesto Clasificación General'
UPDATE C_Formatos SET Formato = 'Por Fuente de Financiamiento' WHERE Formato ='Ejercicio del Presupuesto Fuente Financiamiento'
UPDATE C_Formatos SET Formato = 'Clasificación Economica (por tipo de Gasto)' WHERE Formato ='Ejercicio del Presupuesto Clasificación Económica'
UPDATE C_Formatos SET Formato = 'Clasificación por Objeto del Gasto (Cap-Con)' WHERE Formato ='Ejercicio del Presupuesto Capítulo del Gasto'
UPDATE C_Formatos SET Formato = 'Clasificación Funcional (Finalidad Y Función)' WHERE Formato ='Ejercicio del Presupuesto Clasificación Funcional'
UPDATE C_Formatos SET Formato = 'Por Clasificación Funcional/Subfunción' WHERE Formato ='Ejercicio del Presupuesto Clasificación Funcional-Subfunción'
UPDATE C_Formatos SET Formato = 'Por Clasificación Económica / Capítulo de Gasto' WHERE Formato ='Ejercicio del Presupuesto Clasificación Económica y Capítulo de Gasto'
UPDATE C_Formatos SET Formato = 'Por Partida/Fuente de Financiamiento' WHERE Formato ='Ejercicio del Presupuesto Partida Genérica y Fuente de Financiamiento'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR' WHERE Formato ='Por Ramo / Unidad Responsable'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Clasificación Económica' WHERE Formato ='Por Ramo / Clasificación Económica'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Clasificación Económica / Capítulo Gasto' WHERE Formato ='Por Ramo / Clasificación Económica / Capítulo Gasto'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Capítulo y Concepto Gasto' WHERE Formato ='Por Ramo / Capítulo y Concepto Gasto'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Clasificación Funcional / Subfunción' WHERE Formato ='Por Ramo / Clasificación Funcional / Subfunción'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Capítulo y Concepto Gasto' WHERE Formato ='Por Ramo / Unidad Responsable / Capítulo y Concepto Gasto'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Programa' WHERE Formato ='Por Ramo / Programa'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Programa' WHERE Formato ='Por Ramo / Unidad Responsable / Programa'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Distribución Geográfica' WHERE Formato ='Por Ramo / Distribución Geográfica'
--UPDATE C_Formatos SET Formato = 'Por Ramo / Clasificación Económica / Distribución Geográfica' WHERE Formato ='Por Ramo / Clasificación Económica / Distribución Geográfica'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Partida Genérica' WHERE Formato ='Por Ramo / Unidad Responsable / Partida Genérica'
--UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Partida Específica' WHERE Formato ='Por Ramo / UR / Partida Específica'
--UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Programa / Actividad Institucional / Objeto Gasto 3N' WHERE Formato ='Por Ramo / UR / Programa / Actividad Institucional / Objeto Gasto 3N'
--UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Programa / Objeto Gasto por Capítulo' WHERE Formato ='Por Ramo / UR / Programa / Objeto Gasto por Capítulo'
UPDATE C_Formatos SET Formato = 'Estado Analitico De Ingresos por Rubro' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos por Rubro'
--UPDATE C_Formatos SET Formato = 'Estado de Flujos de Efectivo' WHERE Formato ='Estado de Flujos de Efectivo'
UPDATE C_Formatos SET Formato = 'Efectivo y Equivalentes/Inversiones' WHERE Formato ='Notas al Estado de Situación Financiera-EE-Inversiones Financieras'
UPDATE C_Formatos SET Formato = 'Efectivo y Equivalentes/Fondos' WHERE Formato ='Fondos con Afectación Específica'
UPDATE C_Formatos SET Formato = 'Pasivos Diferidos Y Otros' WHERE Formato ='Notas al Estado de Situación Financiera Pasivos diferidos y otros'
UPDATE C_Formatos SET Formato = 'Patrimonio Contribuido' WHERE Formato ='Notas al Estado de Variaciones en la Hacienda Pública / Patrimonio'
UPDATE C_Formatos SET Formato = 'Estimaciones y Deterioros' WHERE Formato ='Notas al Estado de Situación Financiera Estimaciones y Deterioros'
UPDATE C_Formatos SET Formato = 'Otros Activos' WHERE Formato ='Notas al Estado de Situación Financiera Otros Activos'
UPDATE C_Formatos SET Formato = 'Bienes Disp Transf o Consumo/Inventarios' WHERE Formato ='Notas al Estado de Situación Financiera-BDToC-Inventarios'
UPDATE C_Formatos SET Formato = 'Derecho a Recibir Efvo y Eq/Contribuciones' WHERE Formato ='Notas al Estado de Situación Financiera-DREoE-CPdeCyRecuperar'
UPDATE C_Formatos SET Formato = 'Derecho a Recibir Efvo y Eq/Derechos,Bienes y Servicios' WHERE Formato ='Notas al Estado de Situación Financiera-DREoE-Dreye-bosrvenc'
UPDATE C_Formatos SET Formato = 'Inversiones Financieras/Fideicomisos' WHERE Formato ='Notas al Estado de Situación Financiera_if_fideicomisos'
UPDATE C_Formatos SET Formato = 'Inversiones Financieras/Participaciones y Aportaciones' WHERE Formato ='Notas al Estado de Situación Financiera -IF-Saldos Aportaciones y Aportaciones Capital'
--UPDATE C_Formatos SET Formato = 'Gastos y Otras Pérdidas' WHERE Formato ='Gastos y Otras Pérdidas'
--UPDATE C_Formatos SET Formato = 'Ingresos de Gestión' WHERE Formato ='Ingresos de Gestión'
UPDATE C_Formatos SET Formato = 'Patrimonio Generado' WHERE Formato ='Monto y procedencia de los recursos que modifican al patrimonio generado'
--UPDATE C_Formatos SET Formato = 'Otros Ingresos y Beneficios' WHERE Formato ='Otros Ingresos y Beneficios'
UPDATE C_Formatos SET Formato = 'Por Ramo / Función / Programa / Actividad' WHERE Formato ='Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional'
UPDATE C_Formatos SET Formato = 'Por Ramo / Función / Proyecto Inversión' WHERE Formato ='Ramo o Dependencia / Función / Programas y Proyectos de Inversión'
UPDATE C_Formatos SET Formato = 'Notas Contables' WHERE Formato ='Notas al Estado de Situación Financiera_NotasdeMemoria_contables'
UPDATE C_Formatos SET Formato = 'Notas Presupuestarias' WHERE Formato ='Notas al Estado de Situación Financiera_NotasdeMemoria_presupuestarias'
UPDATE C_Formatos SET Formato = 'Por Area Administrativa Recaudadora/Rubro/Tipo/Clase/Concepto' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos por Rubro, Tipo, Clase y Concepto'
UPDATE C_Formatos SET Formato = 'Por Rubro/Tipo/Clase' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos por Rubro, Tipo y Clase'
UPDATE C_Formatos SET Formato = 'Por Rubro/Tipo' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos por Rubro y Tipo'
UPDATE C_Formatos SET Formato = 'Por Concepto/Fuente de Financiamiento' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos por Concepto y Fuente de financiamiento'
UPDATE C_Formatos SET Formato = 'Por Clasificación Economica/Rubro/Tipo/Clase/Concepto' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos Clasificacion economica por Rubro, Tipo, Clase y Concepto'
UPDATE C_Formatos SET Formato = 'Cuentas Por Pagar' WHERE Formato ='Notas al Estado de Situacion Financiera Cuentas y Documentos por Pagar'
UPDATE C_Formatos SET Formato = 'Por Clasificación Economica/Rubro/Tipo' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos Clasificacion economica por Rubro y Tipo'
UPDATE C_Formatos SET Formato = 'Por Clasificación Economica/Rubro/Tipo/Clase' WHERE Formato ='Estado sobre el Ejercicio de los Ingresos Clasificacion economica por Rubro, Tipo y Clase'
UPDATE C_Formatos SET Formato = 'Calendario de Ingresos Base Mensual' WHERE Formato ='Calendario Mensual Ingresos'
--UPDATE C_Formatos SET Formato = 'Calendario de Egresos Base Mensual' WHERE Formato ='Calendario de Egresos Base Mensual'
--UPDATE C_Formatos SET Formato = 'Difusión a la Ciudadanía de la Ley de Ingresos' WHERE Formato ='Difusión a la Ciudadanía de la Ley de Ingresos'
UPDATE C_Formatos SET Formato = 'Difusión a la Ciudadanía del presupuesto de Egresos' WHERE Formato ='Difusión a la Ciudadanía del Presupuesto de Egresos'
UPDATE C_Formatos SET Formato = 'Programas con Recursos Concurrente por Orden de Gobierno' WHERE Formato ='Formato de Programas con Recursos Concurrente por Orden de Gobierno'
UPDATE C_Formatos SET Formato = 'Por Ramo/ UR / Programa / Actividad / objeto del Gasto Capítulo' WHERE Formato ='Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / objeto del Gasto por Capítulo'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Programa / Actividad  / Objeto Gasto Partida / Fuente de Financiamiento' WHERE Formato ='Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Programa/ Actividad/ Objeto Gasto Partida / Distribución Georgráfica' WHERE Formato ='Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Distribución Georgráfica'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Proyecto/ Objeto Gasto Capítulo / Clasificación Económica' WHERE Formato ='Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasificación Económica'
UPDATE C_Formatos SET Formato = 'Por Ramo / UR / Proyecto/ Objeto Gasto Partida/ Fuente de Financiamiento' WHERE Formato ='Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento'
UPDATE C_Formatos SET Formato = 'Por Ramo/ Distribución Geográfica /Proyecto' WHERE Formato ='Ramo o Dependencia / Distribución Geográfica / Programas y Proyectos de Inversión'
--UPDATE C_Formatos SET Formato = 'Iniciativa de la Ley de Ingresos' WHERE Formato ='Iniciativa de la Ley de Ingresos'
--UPDATE C_Formatos SET Formato = 'Bienes Muebles e Inmuebles' WHERE Formato ='Bienes Muebles e Inmuebles'
--UPDATE C_Formatos SET Formato = 'Saldos Inicial y Final' WHERE Formato ='Saldo Inicial y Final'
UPDATE C_Formatos SET Formato = 'Bienes Disp Transf o Consumo/Almacen' WHERE Formato ='Notas al Estado de Situación Financiera-BDToC-Almacén'
UPDATE C_Formatos SET Formato = 'Bienes Muebles,Inm e Int/Activos Intangibles y diferidos' WHERE Formato ='Notas al Estado de Situacion Financiera Bienes Inmuebles, Inmuebles e Intangibles - Activos Intangibles y Diferidos'
UPDATE C_Formatos SET Formato = 'Bienes Muebles,Inm e Int/Bienes Muebles e Inmuebles' WHERE Formato ='Notas al Estado de Situacion Financiera Bienes Inmuebles, Inmuebles e Intangibles - Bienes Inmuebles, Inmuebles e Intangibles'
UPDATE C_Formatos SET Formato = 'Fondos' WHERE Formato ='Notas al Estado de Situación Financiera Fondos de Bienes de Terceros en Administracón y/o en garantía a corto y largo plazo'
UPDATE C_Formatos SET Formato = 'Ejercicio y Destino de Gasto Federalizado y Reintegros' WHERE Formato ='Formato del ejercicio y destino de gasto federalizado y reintegros'
--UPDATE C_Formatos SET Formato = 'Obligaciones pagadas o garantizadas con fondos federales' WHERE Formato ='Obligaciones pagadas o garantizadas con fondos federales'
--UPDATE C_Formatos SET Formato = 'Conciliación Ahorro/Desahorro' WHERE Formato ='Conciliación Ahorro Desahorro'
--UPDATE C_Formatos SET Formato = 'Relación de cuentas bancarias productivas específicas' WHERE Formato ='Relación de cuentas bancarias productivas específicas'
UPDATE C_Formatos SET Formato = 'Aplicación de recursos FORTAMUN' WHERE Formato ='Formato de infomación de recursos del FORTAMUN'
UPDATE C_Formatos SET Formato = '74.l.a Personal comisionado o con licencia' WHERE Formato ='Personal comisionado o con licencia'
UPDATE C_Formatos SET Formato = '74.l.b Pagos retroactivos' WHERE Formato ='Pagos retroactivos'
UPDATE C_Formatos SET Formato = '74-l-c Pagos diferentes al costo asociado a las plazas' WHERE Formato ='Pagos diferentes al costo asociado a las plazas'
--UPDATE C_Formatos SET Formato = 'Trabajadores Comisionados' WHERE Formato ='Trabajadores Comisionados'
--UPDATE C_Formatos SET Formato = 'Trabajadores con Licencia' WHERE Formato ='Trabajadores con Licencia'
--UPDATE C_Formatos SET Formato = 'Trabajadores Jubilados y con Licencia Prejubilatoria' WHERE Formato ='Trabajadores Jubilados y con Licencia Prejubilatoria'
--UPDATE C_Formatos SET Formato = 'Tabulador' WHERE Formato ='Tabulador'
UPDATE C_Formatos SET Formato = 'Difusión Resultados Evaluaciones' WHERE Formato ='Formato para la Difusión de los Resultados de las Evaluaciones'
--UPDATE C_Formatos SET Formato = 'Analítico de Plazas' WHERE Formato ='Analítico de Plazas'
UPDATE C_Formatos SET Formato = 'Catálogo de Percepciones y Deducciones' WHERE Formato ='Catálogo de Conceptos de Percepciones y Deducciones'
--UPDATE C_Formatos SET Formato = 'Libro de Inventarios de Bienes Muebles e Inmuebles' WHERE Formato ='Libro de Inventarios de Bienes Muebles e Inmuebles'
--UPDATE C_Formatos SET Formato = 'Montos pagados por ayudas y subsidios' WHERE Formato ='Montos pagados por ayudas y subsidios'
--UPDATE C_Formatos SET Formato = 'Personal por Honorarios' WHERE Formato ='Personal por Honorarios'
--UPDATE C_Formatos SET Formato = 'Plazas Existentes' WHERE Formato ='Plazas Existentes'
--UPDATE C_Formatos SET Formato = 'Relación de Bienes Muebles e Inmuebles' WHERE Formato ='Relación de Bienes Muebles e Inmuebles'
--UPDATE C_Formatos SET Formato = 'Auxiliar Sujeto a Inventario de Bienes Arqueológicos, Artísticos e Históricos' WHERE Formato ='Auxiliar Sujeto a Inventario de Bienes Arqueológicos, Artísticos e Históricos'
--UPDATE C_Formatos SET Formato = 'Libro de Almacén de Materias y Suministros de Consumo' WHERE Formato ='Libro de Almacén de Materias y Suministros de Consumo'
--UPDATE C_Formatos SET Formato = 'Libro de Inventarios de Materias Primas, Materiales y Suministros para Producción y Comercialización' WHERE Formato ='Libro de Inventarios de Materias Primas, Materiales y Suministros para Producción y Comercialización'
--UPDATE C_Formatos SET Formato = 'Personal Comisionado' WHERE Formato ='Personal Comisionado'
UPDATE C_Formatos SET Formato = 'Pagos Retroactivos' WHERE Formato ='Pagos Retroactivos FETA'
--UPDATE C_Formatos SET Formato = 'Personal con Licencia' WHERE Formato ='Personal con Licencia'
--UPDATE C_Formatos SET Formato = 'Plaza/Función' WHERE Formato ='Plaza/Función'
--UPDATE C_Formatos SET Formato = 'Movimientos de Personal por Centro de Trabajo' WHERE Formato ='Movimientos de Personal por Centro de Trabajo'
--UPDATE C_Formatos SET Formato = 'Trabajadores Jubilados' WHERE Formato ='Trabajadores Jubilados'
--UPDATE C_Formatos SET Formato = 'Trabajadores con Licencia Prejubilatoria' WHERE Formato ='Trabajadores con Licencia Prejubilatoria'
--UPDATE C_Formatos SET Formato = 'Trabajadores por Honorarios' WHERE Formato ='Trabajadores por Honorarios'
--UPDATE C_Formatos SET Formato = 'Analítico de Categorías' WHERE Formato ='Analítico de Categorías'
--UPDATE C_Formatos SET Formato = 'Catálogo de Categorías y Tabuladores' WHERE Formato ='Catálogo de Categorías y Tabuladores'
--UPDATE C_Formatos SET Formato = 'Catálogo de Percepciones y Deducciones' WHERE Formato ='Catálogo de Percepciones y Deducciones'
UPDATE C_Formatos SET Formato = 'Trabajadores que Cobran con RFC/CURP con Formato Incorrecto' WHERE Formato ='Formato Incorrecto'
--UPDATE C_Formatos SET Formato = 'Trabajadores con Doble Asignación Salarial' WHERE Formato ='Trabajadores con Doble Asignación Salarial'
--UPDATE C_Formatos SET Formato = 'Trabajadores que Superan el Núm. de Hrs. de Compatibilidad' WHERE Formato ='Trabajadores que Superan el Núm. de Hrs. de Compatibilidad'
--UPDATE C_Formatos SET Formato = 'Trabajadores Cuyo Salario Supere los Ingresos Promedio' WHERE Formato ='Trabajadores Cuyo Salario Supere los Ingresos Promedio'
--UPDATE C_Formatos SET Formato = 'Proyecto del Presupuesto de Egresos' WHERE Formato ='Proyecto del Presupuesto de Egresos'
--UPDATE C_Formatos SET Formato = 'Analítico de la Deuda y Otros Pasivos' WHERE Formato ='Analítico de la Deuda Pública y Otros Pasivos'
--UPDATE C_Formatos SET Formato = 'Estado de Cambios en la Situación Financiera' WHERE Formato ='Estado de Cambios en la Situación Financiera'
--UPDATE C_Formatos SET Formato = 'Estado de Variación en la Hacienda Pública' WHERE Formato ='Estado de Variación en la Hacienda Pública'
UPDATE C_Formatos SET Formato = 'Estado Analitico De Ingresos por fuente de financiamiento' WHERE Formato ='Estado del ejercicio de Ingresos Por Fuente de Financiamiento'
--UPDATE C_Formatos SET Formato = 'Formato Específico de Aplicación de Recursos a Seguridad Pública' WHERE Formato ='Formato Específico de Aplicación de Recursos a Seguridad Pública'
--UPDATE C_Formatos SET Formato = 'Formato Gral. de Aplicación de Recursos a Seguridad Pública' WHERE Formato ='Formato Gral. de Aplicación de Recursos a Seguridad Pública'
UPDATE C_Formatos SET Formato = 'REPORTE FAIS' WHERE Formato ='Montos que reciban, obras y acciones a realizar con el FAIS'
--UPDATE C_Formatos SET Formato = 'Informe Sobre Pasivos Contingentes' WHERE Formato ='Informe Sobre Pasivos Contingentes'
--UPDATE C_Formatos SET Formato = 'Conciliacion entre los Egresos Presupuestales y Gastos Contables' WHERE Formato ='Conciliacion entre los Egresos Presupuestarios y Gastos Contables'
UPDATE C_Formatos SET Formato = 'Clasificación Administrativa-Dependencia' WHERE Formato ='Ejercicio del Presupuesto Clasificación Administrativa'
--UPDATE C_Formatos SET Formato = 'Conciliacion entre los Ingresos Presupuestales y Contables' WHERE Formato ='Conciliacion entre los Ingresos Presupuestarios y Contables'
--UPDATE C_Formatos SET Formato = 'Endeudamiento Neto' WHERE Formato ='Endeudamiento Neto'
--UPDATE C_Formatos SET Formato = 'Indicadores de Postura Fiscal' WHERE Formato ='Indicadores de Postura Fiscal'
--UPDATE C_Formatos SET Formato = 'Interés de la Deuda' WHERE Formato ='Intereses de la Deuda'
--UPDATE C_Formatos SET Formato = 'Gasto por Categoría Programática' WHERE Formato ='Gasto por Categoría Programática'
UPDATE C_Formatos SET Formato = 'Analítico del ejercicio de Egresos' WHERE Formato ='REPORTE ANALÍTICO DEL EJERCICIO DEL PRESUPUESTO DE EGRESOS (POR PARTIDA HASTA 4° NIVEL)'
GO

PRINT'Homologando nombres de Formatos sin firmas (Solo código ISO)'
GO
--Comentados tienen el mismo nombre
UPDATE C_Formatos SET Formato = 'OC/OS Por Unidad Responsable/ Partida/proveedor' WHERE Formato = 'Reporte de órdenes de compra y servicios por unida responsable, partida y proveedor'
UPDATE C_Formatos SET Formato = 'OC/OS Detallado Por Proveedor' WHERE Formato = 'Reporte de ordenes de compras y servicios detallado por proveedor'
UPDATE C_Formatos SET Formato = 'OC/OS Detallado Por Proveedor/Unidad Reponsable' WHERE Formato = 'Reporte de ordenes de compras y servicios detallado por proveedor Sin UR y Departamento'
UPDATE C_Formatos SET Formato = 'OC/OS Por Unidad Reponsable' WHERE Formato = 'Reporte de Ordenes de Compra y Servicio por Unidad Responsable '
UPDATE C_Formatos SET Formato = 'OC/OS Por Unidad Responsable/ Partida' WHERE Formato = 'Reporte de órdenes de compra y servicios por unidad responsable y partida'
UPDATE C_Formatos SET Formato = 'Balanza de Comprobacion' WHERE Formato = 'Reporte Balanza de Comprobacion'
UPDATE C_Formatos SET Formato = 'Libro Diario' WHERE Formato = 'LIBRO DIARIO '
UPDATE C_Formatos SET Formato = 'Libro Mayor' WHERE Formato = 'LIBRO MAYOR.  '
UPDATE C_Formatos SET Formato = 'OC/OS Concentrado Por Proveedor' WHERE Formato = 'Reporte de ordenes de compras y servicios concentrado por proveedor'
--UPDATE C_Formatos SET Formato = 'Clasificación Económica' WHERE Formato = 'Clasificación Económica'
UPDATE C_Formatos SET Formato = 'Movimientos Conciliados' WHERE Formato = 'Conciliacion Movimientos Conciliados'
UPDATE C_Formatos SET Formato = 'Movimientos No Conciliados' WHERE Formato = 'Conciliacion Movimientos No Conciliados'
UPDATE C_Formatos SET Formato = 'Cheques y Transferencias Electronicas' WHERE Formato = 'Cheques y Transferencias'
--UPDATE C_Formatos SET Formato = 'Facturas Recibidas' WHERE Formato = 'Facturas Recibidas '
--UPDATE C_Formatos SET Formato = 'Saldos Promedio' WHERE Formato = 'Saldos Promedio'
--UPDATE C_Formatos SET Formato = 'Tarifario Ingresos' WHERE Formato = 'Tarifario Ingresos'
--UPDATE C_Formatos SET Formato = 'Catálogo de Empleados' WHERE Formato = 'Catálogo de Empleados '
--UPDATE C_Formatos SET Formato = 'Catálogo de Productos' WHERE Formato = 'Catálogo de Productos '
--UPDATE C_Formatos SET Formato = 'Catalogo de Proveedores' WHERE Formato = 'Catalogo de Proveedores '
--UPDATE C_Formatos SET Formato = 'Catálogo Plan de Cuentas' WHERE Formato = 'Catálogo Plan de Cuentas '
--UPDATE C_Formatos SET Formato = 'Gasto Devengado por Departamento' WHERE Formato = 'Gasto Devengado por Departamento '
--UPDATE C_Formatos SET Formato = 'Auxiliar Presupuestal' WHERE Formato = 'AuxiliarPresupuestal'
UPDATE C_Formatos SET Formato = 'Clasificacion Administrativa-Sector Paraestatal' WHERE Formato = 'Estado Analítico del Ejercicio del Presupuesto de Egresos Sector Paraestatal'
UPDATE C_Formatos SET Formato = 'Clasificación Administrativa-Gobierno' WHERE Formato = 'Estado Analítico del Ejercicio del Presupuesto de Egresos Por Poder'
--UPDATE C_Formatos SET Formato = 'Existencias en almacén' WHERE Formato = 'Existencias en almacén' 
GO
