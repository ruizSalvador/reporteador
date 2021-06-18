 /****** Object:  StoredProcedure [dbo].[REPORTE_Estado_De_ActividadesRedondeo_UltimoNivel]  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[REPORTE_Estado_De_ActividadesRedondeo_UltimoNivel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[REPORTE_Estado_De_ActividadesRedondeo_UltimoNivel]
GO

/****** Object:  StoredProcedure [dbo].[REPORTE_Estado_De_ActividadesRedondeo_UltimoNivel]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 

--Exec REPORTE_Estado_De_ActividadesRedondeo_UltimoNivel 1,2019,0,1,0
CREATE PROCEDURE [dbo].[REPORTE_Estado_De_ActividadesRedondeo_UltimoNivel]  
@mes smallint,  
@año smallint,  
@Miles bit,  
@MostrarVacios bit,  
@Redondeo bit  
AS  
BEGIN  
  
--- Manejo Miles de pesos  
declare @Division int  
if @Miles=1 set @Division=1000  
else set @Division=1  
  
--Tipos de estructura 5-5 , 5-6 , 6-6  
declare @Estructura1 as int  
declare @Estructura2 as int  
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))  
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))  
declare @CerosEstructura varchar(20)  
set @CerosEstructura = REPLICATE('0',@Estructura2)  
  
--variables   
 Declare @Reporte int  
 Declare @SSaldo decimal(15,2)  
 Declare @SSaldoAnt Decimal(15,2)  
 Declare @SSaldo5 decimal(15,2)  
 Declare @SSaldoAnt5 decimal(15,2)  
 Declare @433ACR decimal(15,2)  
 Declare @433ACRAnt decimal(15,2)  
 Declare @434ACR decimal(15,2)  
 Declare @434ACRAnt decimal(15,2)  
 Declare @551ACR decimal(15,2)  
 Declare @551ACRAnt decimal(15,2)  
 Declare @552ACR decimal(15,2)  
 Declare @552ACRAnt decimal(15,2)  
 Declare @554ACR decimal(15,2)  
 Declare @554ACRAnt decimal(15,2)  
 Declare @555ACR decimal(15,2)  
 Declare @555ACRAnt decimal(15,2)  
  
 Declare @433DEU decimal(15,2)  
 Declare @433DEUAnt decimal(15,2)  
 Declare @434DEU decimal(15,2)  
 Declare @434DEUAnt decimal(15,2)  
 Declare @551DEU decimal(15,2)  
 Declare @551DEUAnt decimal(15,2)  
 Declare @552DEU decimal(15,2)  
 Declare @552DEUAnt decimal(15,2)  
 Declare @554DEU decimal(15,2)  
 Declare @554DEUAnt decimal(15,2)  
 Declare @555DEU decimal(15,2)  
 Declare @555DEUAnt decimal(15,2)  

Declare @SaldoAcreedorTemp decimal(15,2)  
Declare @SaldoDeudorTemp decimal(15,2)

   
 
Declare @SaldoAcreedorTempAnt decimal(15,2)  
Declare @SaldoDeudorTempAnt decimal(15,2)

Declare @Tmp_BalanzaDeComprobacion TABLE(  
NumeroCuenta varchar(max),  
NombreCuenta varchar(max),  
CargosSinFlujo decimal(15,2),  
AbonosSinFlujo decimal(15,2),  
TotalCargos decimal(15,2),  
TotalAbonos decimal(15,2),  
SaldoDeudor decimal(15,2),  
SaldoAcreedor decimal(15,2),  
TipoCuenta int,    
MaskNumeroCuenta varchar(max),  
Total int,   
Mes int,   
Year int,   
MaskNombreCuenta varchar(max),  
NumeroCuentaAnt varchar(max),   
SaldoDeudorAnt decimal(15,2),  
SaldoAcreedorAnt decimal(15,2),  
MesAnt int,  
AñoAnt int,  
Agrupador int,
Nivel int  )  
--Manejo de nombres fijos  
Declare @TablaTitulos table  
(Numerocuenta varchar(max),  
Nombre varchar(max),  
Total int,
Nivel smallint)  

  
Insert Into @TablaTitulos values ('400'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura,'    Ingresos y otros beneficios',4,0)  
Insert Into @TablaTitulos values('410'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura,'          Ingresos de gestión',3,0) 
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '411' and Nivel <= 4  
--Insert Into @TablaTitulos values('411'+REPLICATE('0',@Estructura1-3),'              IMPUESTOS',2)  
--Insert Into @TablaTitulos values('4111'+REPLICATE('0',@Estructura1-4),'                  IMPUESTOS SOBRE LOS INGRESOS',1)  
--Insert Into @TablaTitulos values('4112'+REPLICATE('0',@Estructura1-4),'                  IMPUESTOS SOBRE EL PATRIMONIO',1)
--Insert Into @TablaTitulos values('4113'+REPLICATE('0',@Estructura1-4),'                  IMPUESTOS SOBRE LA PRODUCCION, EL CONSUMO Y LAS TRANSACCIONES',1)
--Insert Into @TablaTitulos values('4114'+REPLICATE('0',@Estructura1-4),'                  IMPUESTOS AL COMERCIO EXTERIOR',1)
--Insert Into @TablaTitulos values('4115'+REPLICATE('0',@Estructura1-4),'                  IMPUESTOS SOBRE NÓMINAS Y ASIMILABLES',1)
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '412' and Nivel <= 4    
--Insert Into @TablaTitulos values('4121'+REPLICATE('0',@Estructura1-4),'                  Aportaciones para Fondos de Vivienda',1)  
--Insert Into @TablaTitulos values('4122'+REPLICATE('0',@Estructura1-4),'                  Cuotas para el Seguro Social',1)
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '413' and Nivel <= 4   
--Insert Into @TablaTitulos values('4131'+REPLICATE('0',@Estructura1-4),'                  Contribución de mejoras por obras públicas',1)
--Insert Into @TablaTitulos values('4141'+REPLICATE('0',@Estructura1-4),'                  Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público',1)  
--Insert Into @TablaTitulos values('4142'+REPLICATE('0',@Estructura1-4),'                  Derechos a los Hidrocarburos',1)
--Insert Into @TablaTitulos values('4143'+REPLICATE('0',@Estructura1-4),'                  Derechos por Prestación de Servicios',1)
--Insert Into @TablaTitulos values('4144'+REPLICATE('0',@Estructura1-4),'                  Accesorios de Derechos',1)
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '415' and Nivel <= 4   
--Insert Into @TablaTitulos values('4151'+REPLICATE('0',@Estructura1-4),'                  Productos derivados del uso y aprovechamiento de bienes no sujetos a régimen de dominio público',1)  
--Insert Into @TablaTitulos values('4152'+REPLICATE('0',@Estructura1-4),'                  Enajenación de bienes muebles no sujetos a ser inventariados',1)
--Insert Into @TablaTitulos values('4153'+REPLICATE('0',@Estructura1-4),'                  Accesorios de productos',1)
--Insert Into @TablaTitulos values('4159'+REPLICATE('0',@Estructura1-4),'                  Otros productos que generan ingresos corrientes',1)
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '416' and Nivel <= 4   
--Insert Into @TablaTitulos values('4161'+REPLICATE('0',@Estructura1-4),'                  Incentivos derivados de la colaboración fiscal',1)  
--Insert Into @TablaTitulos values('4162'+REPLICATE('0',@Estructura1-4),'                  Multas',1)
--Insert Into @TablaTitulos values('4163'+REPLICATE('0',@Estructura1-4),'                  Indemnizaciones',1)
--Insert Into @TablaTitulos values('4164'+REPLICATE('0',@Estructura1-4),'                  Reintegros',1)
--Insert Into @TablaTitulos values('4165'+REPLICATE('0',@Estructura1-4),'                  Aprovechamientos provenientes de obras públicas',1)  
--Insert Into @TablaTitulos values('4166'+REPLICATE('0',@Estructura1-4),'                  Aprovechamientos por Participaciones  Derivadas de la Aplicación de Leyes',1)
--Insert Into @TablaTitulos values('4167'+REPLICATE('0',@Estructura1-4),'                  Aprovechamientos por Aportaciones y Cooperaciones',1)
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '417' and Nivel <= 4 
--Insert Into @TablaTitulos values('4171'+REPLICATE('0',@Estructura1-4),'                  Ingresos por Venta de Mercancia',1)  
--Insert Into @TablaTitulos values('4172'+REPLICATE('0',@Estructura1-4),'                  Ingresos por venta de bienes y servicios producidos en establecimientos del gobierno',1)
--Insert Into @TablaTitulos values('4173'+REPLICATE('0',@Estructura1-4),'                  Ingresos por venta de bienes y servicios de organismos descentralizados',1)
----------------------------------------------------------------------------------------
--Insert into @TablaTitulos
--Select NumeroCuenta, NombreCuenta,2 FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '417'
--order by NumeroCuenta
----------------------------------------------------------------------------------------
--Insert Into @TablaTitulos values('419'+REPLICATE('0',@Estructura1-3),'              INGRESOS NO COMPRENDIDOS EN LAS FRACCIONES DE LA LEY DE INGRESOS CAUSADOS EN EJERCICIOS FISCALES ANTERIORES PENDIENTES DE LIQUIDACIÓN O PAGO',2)  
--Insert Into @TablaTitulos values('4191'+REPLICATE('0',@Estructura1-4),'                  IMPUESTOS NO COMPRENDIDOS EN LAS FRACCIONES DE LA LEY DE INGRESOS CAUSADOS EN EJERCICIOS FISCALES ANTERIORES PENDIENTES DE LIQUIDACIÓN O PAGO',1)  
--Insert Into @TablaTitulos values('4191'+REPLICATE('0',@Estructura1-4),'                  Contribuciones de mejoras, derechos, productos y aprovechamientos no comprendidas en las fracciones de la ley de ingresos causadas en ejercicios fiscales anteriores ',1)  
Insert Into @TablaTitulos values('420'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura,'          Participaciones, aportaciones, convenios, incentivos derivados de la colaboración fiscal, fondos distintos de aportaciones, transferencias, asignaciones, subsidios y subvenciones, y pensiones y jubilaciones',3,0) 
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '421' and Nivel <= 4 
--Insert Into @TablaTitulos values('4211'+REPLICATE('0',@Estructura1-4),'                  Participaciones',1)  
--Insert Into @TablaTitulos values('4212'+REPLICATE('0',@Estructura1-4),'                  Aportaciones',1)
--Insert Into @TablaTitulos values('4213'+REPLICATE('0',@Estructura1-4),'                  Convenios',1)
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '422' and Nivel <= 4 
--Insert Into @TablaTitulos values('4221'+REPLICATE('0',@Estructura1-4),'                  Transferencias internas y asignaciones del sector público',1)
--Insert Into @TablaTitulos values('4222'+REPLICATE('0',@Estructura1-4),'                  Transferencias al resto del sector público',1)
--Insert Into @TablaTitulos values('4223'+REPLICATE('0',@Estructura1-4),'                  Subsidios y subvenciones',1)
--Insert Into @TablaTitulos values('4224'+REPLICATE('0',@Estructura1-4),'                  Ayudas sociales',1)
Insert Into @TablaTitulos values('430'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura,'          Otros ingresos y beneficios',3,0)  
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '431' and Nivel <= 4 
--Insert Into @TablaTitulos values('4320'+REPLICATE('0',@Estructura1-4),'                  Incremento por variación de inventarios',1)
--Insert Into @TablaTitulos values('4331'+REPLICATE('0',@Estructura1-4),'                  Disminución del exceso de estimaciones por pérdida o deterioro u obsolescencia',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '432' and Nivel <= 4 
--Insert Into @TablaTitulos values('4321'+REPLICATE('0',@Estructura1-4),'                  Incremento por variación de Inventarios de Mercancias para Venta',1)
--Insert Into @TablaTitulos values('4322'+REPLICATE('0',@Estructura1-4),'                  Incremento por variación de inventarios de Mercancias Terminadas',1)
 
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '433' and Nivel <= 4 
--Insert Into @TablaTitulos values('4331'+REPLICATE('0',@Estructura1-4),'                  Disminución del exceso de estimaciones por pérdida o deterioro u obsolescencia',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '434' and Nivel <= 4 
--Insert Into @TablaTitulos values('4341'+REPLICATE('0',@Estructura1-4),'                  Disminución del exceso de provisiones',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '439' and Nivel <= 4 
--Insert Into @TablaTitulos values('4391'+REPLICATE('0',@Estructura1-4),'                  Otros ingresos de ejercicios anteriores',1)
--Insert Into @TablaTitulos values('4392'+REPLICATE('0',@Estructura1-4),'                  Bonificaciones y descuentos obtenidos',1)
--Insert Into @TablaTitulos values('4393'+REPLICATE('0',@Estructura1-4),'                  Diferencias por tipo de cambio a Favor en efectivo y Equivalentes',1)
--Insert Into @TablaTitulos values('4394'+REPLICATE('0',@Estructura1-4),'                  Diferencias de Cotizaciones a Favor en Valares Negaciables',1)
  
Insert Into @TablaTitulos values('500'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura,'    Gastos y otras pérdidas',4,0)  
Insert Into @TablaTitulos values('510'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura,'          Gastos de funcionamiento',3,0)
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '511' and Nivel <= 4 
--Insert Into @TablaTitulos values('5111'+REPLICATE('0',@Estructura1-4),'                  Remuneraciones al personal de carácter permanente',1)
--Insert Into @TablaTitulos values('5112'+REPLICATE('0',@Estructura1-4),'                  Remuneraciones al personal de carácter transitorio',1)
--Insert Into @TablaTitulos values('5113'+REPLICATE('0',@Estructura1-4),'                  Remuneraciones adicionales y especiales',1)
--Insert Into @TablaTitulos values('5114'+REPLICATE('0',@Estructura1-4),'                  Seguridad social',1)
--Insert Into @TablaTitulos values('5115'+REPLICATE('0',@Estructura1-4),'                  Otras prestaciones sociales y económicas',1)
--Insert Into @TablaTitulos values('5116'+REPLICATE('0',@Estructura1-4),'                  Pago de estímulos a servidores públicos',1)

--Insert Into @TablaTitulos values('512'+REPLICATE('0',@Estructura1-3),'              MATERIALES Y SUMINISTROS',2) 
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '512' and Nivel <= 4  
--Insert Into @TablaTitulos values('5121'+REPLICATE('0',@Estructura1-4),'                  Materiales de administración, emisión de documentos y artículos oficiales',1)
--Insert Into @TablaTitulos values('5122'+REPLICATE('0',@Estructura1-4),'                  Alimentos y utensilios',1)
--Insert Into @TablaTitulos values('5123'+REPLICATE('0',@Estructura1-4),'                  Materias primas y materiales de producción y comercialización',1)
--Insert Into @TablaTitulos values('5124'+REPLICATE('0',@Estructura1-4),'                  Materiales y artículos de construcción y de reparación',1)
--Insert Into @TablaTitulos values('5125'+REPLICATE('0',@Estructura1-4),'                  Productos químicos, farmacéuticos y de laboratorio',1)
--Insert Into @TablaTitulos values('5126'+REPLICATE('0',@Estructura1-4),'                  Combustibles, lubricantes y aditivos',1)
--Insert Into @TablaTitulos values('5127'+REPLICATE('0',@Estructura1-4),'                  Vestuario, blancos, prendas de protección y artículos deportivos',1)
--Insert Into @TablaTitulos values('5128'+REPLICATE('0',@Estructura1-4),'                  Materiales y suministros para seguridad',1)
--Insert Into @TablaTitulos values('5129'+REPLICATE('0',@Estructura1-4),'                  Herramientas, refacciones y accesorios menores',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '513' and Nivel <= 4  
--Insert Into @TablaTitulos values('5131'+REPLICATE('0',@Estructura1-4),'                  Servicios básicos',1)
--Insert Into @TablaTitulos values('5132'+REPLICATE('0',@Estructura1-4),'                  Servicios de arrendamiento',1)
--Insert Into @TablaTitulos values('5133'+REPLICATE('0',@Estructura1-4),'                  Servicios profesionales, científicos y técnicos y otros servicios',1)
--Insert Into @TablaTitulos values('5134'+REPLICATE('0',@Estructura1-4),'                  Servicios financieros, bancarios y comerciales',1)
--Insert Into @TablaTitulos values('5135'+REPLICATE('0',@Estructura1-4),'                  Servicios de instalación, reparación, mantenimiento y conservación',1)
--Insert Into @TablaTitulos values('5136'+REPLICATE('0',@Estructura1-4),'                  Servicios de comunicación social y publicidad',1)
--Insert Into @TablaTitulos values('5137'+REPLICATE('0',@Estructura1-4),'                  Servicios de traslado y viáticos',1)
--Insert Into @TablaTitulos values('5138'+REPLICATE('0',@Estructura1-4),'                  Servicios oficiales',1)
--Insert Into @TablaTitulos values('5139'+REPLICATE('0',@Estructura1-4),'                  Otros servicios generales',1)

Insert Into @TablaTitulos values('520'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura,'          Transferencias, asignaciones, subsidios y otras ayudas',3,0)  
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '521' and Nivel <= 4  
--Insert Into @TablaTitulos values('5211'+REPLICATE('0',@Estructura1-4),'                  Asignaciones al Sector Público',1)
--Insert Into @TablaTitulos values('5212'+REPLICATE('0',@Estructura1-4),'                  Transferencias Internas al Sector Público',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '522' and Nivel <= 4  
--Insert Into @TablaTitulos values('5221'+REPLICATE('0',@Estructura1-4),'                  Transferencias a Entidades Paraestatales',1)
--Insert Into @TablaTitulos values('5222'+REPLICATE('0',@Estructura1-4),'                  Transferencias a Entidades Federativas y Municipios',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '523' and Nivel <= 4  
--Insert Into @TablaTitulos values('5231'+REPLICATE('0',@Estructura1-4),'                  Subsidios',1)
--Insert Into @TablaTitulos values('5232'+REPLICATE('0',@Estructura1-4),'                  Subvenciones',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '524' and Nivel <= 4  
--Insert Into @TablaTitulos values('5241'+REPLICATE('0',@Estructura1-4),'                  Ayudas sociales a personas',1)
--Insert Into @TablaTitulos values('5242'+REPLICATE('0',@Estructura1-4),'                  Becas',1)
--Insert Into @TablaTitulos values('5243'+REPLICATE('0',@Estructura1-4),'                  Ayudas sociales a instituciones',1)
--Insert Into @TablaTitulos values('5244'+REPLICATE('0',@Estructura1-4),'                  Ayudas sociales por desastres naturales y otros siniestros',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '525' and Nivel <= 4  
--Insert Into @TablaTitulos values('5251'+REPLICATE('0',@Estructura1-4),'                  Pensiones',1)
--Insert Into @TablaTitulos values('5252'+REPLICATE('0',@Estructura1-4),'                  Jubilaciones',1)
--Insert Into @TablaTitulos values('5259'+REPLICATE('0',@Estructura1-4),'                  Otras pensiones y jubilaciones',1)
 
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '526' and Nivel <= 4 
--Insert Into @TablaTitulos values('5261'+REPLICATE('0',@Estructura1-4),'                  Transferencias a Fideicomisos, Mandatos y Contratos Análogos al Gobierno',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '527' and Nivel <= 4  
--Insert Into @TablaTitulos values('5271'+REPLICATE('0',@Estructura1-4),'                  Transferencias por obligaciones de Ley',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '528' and Nivel <= 4  
--Insert Into @TablaTitulos values('5281'+REPLICATE('0',@Estructura1-4),'                  Donativos a instituciones sin fines de lucro',1)
--Insert Into @TablaTitulos values('5282'+REPLICATE('0',@Estructura1-4),'                  Donativos a entidades Federativas y Municipios',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '529' and Nivel <= 4  
--Insert Into @TablaTitulos values('5291'+REPLICATE('0',@Estructura1-4),'                  Transferencias al exterior a Gobiernos extranjeros y organismos internacionales',1)
--Insert Into @TablaTitulos values('5292'+REPLICATE('0',@Estructura1-4),'                  Transferencias al sector privado externo',1)

Insert Into @TablaTitulos values('530'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura,'          Participaciones y aportaciones',3,0)  
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '531' and Nivel <= 4  
--Insert Into @TablaTitulos values('5311'+REPLICATE('0',@Estructura1-4),'                  Participaciones de la Federación a Entidades Federativas y Municipios',1)
--Insert Into @TablaTitulos values('5312'+REPLICATE('0',@Estructura1-4),'                  Participaciones de las Entidades Federativas a los Municipios',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '532' and Nivel <= 4  
--Insert Into @TablaTitulos values('5321'+REPLICATE('0',@Estructura1-4),'                  Aportaciones de la Federación a Entidades Federativas y Municipios',1)
--Insert Into @TablaTitulos values('5322'+REPLICATE('0',@Estructura1-4),'                  Aportaciones de las Entidades Federativas a los Municipios',1)
 
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '533' and Nivel <= 4 
--Insert Into @TablaTitulos values('5331'+REPLICATE('0',@Estructura1-4),'                  Convenios de Reasignación',1)
--Insert Into @TablaTitulos values('5332'+REPLICATE('0',@Estructura1-4),'                  Convenios de Descentralización y Otros',1)

Insert Into @TablaTitulos values('540'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura,'          Intereses, comisiones y otros gastos de la deuda pública',3,0)  
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '541' and Nivel <= 4  
--Insert Into @TablaTitulos values('5411'+REPLICATE('0',@Estructura1-4),'                  Intereses de la deuda pública interna',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '542' and Nivel <= 4  
--Insert Into @TablaTitulos values('5121'+REPLICATE('0',@Estructura1-4),'                  Comisiones de la deuda pública interna',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '543' and Nivel <= 4 
--Insert Into @TablaTitulos values('5431'+REPLICATE('0',@Estructura1-4),'                  Gastos de la deuda pública interna',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '544' and Nivel <= 4 
--Insert Into @TablaTitulos values('5441'+REPLICATE('0',@Estructura1-4),'                  Costo por coberturas',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '545' and Nivel <= 4 
--Insert Into @TablaTitulos values('5451'+REPLICATE('0',@Estructura1-4),'                  Apoyos financieros a intermediarios',1)
--Insert Into @TablaTitulos values('5452'+REPLICATE('0',@Estructura1-4),'                  Apoyos financieros a Ahorradores y deudores del sistema financiero nacional',1)

Insert Into @TablaTitulos values('550'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura,'          Otros gastos y pérdidas extraordinarias',3,0)  
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '551' and Nivel <= 4 
--Insert Into @TablaTitulos values('5511'+REPLICATE('0',@Estructura1-4),'                  Estimaciones por pérdida o deterioro de de activos circulantes',1)
--Insert Into @TablaTitulos values('5512'+REPLICATE('0',@Estructura1-4),'                  Estimaciones por pérdida o deterioro de de activos no circulantes',1)
--Insert Into @TablaTitulos values('5513'+REPLICATE('0',@Estructura1-4),'                  Depreciación de bienes inmuebles',1)
--Insert Into @TablaTitulos values('5514'+REPLICATE('0',@Estructura1-4),'                  Depreciación de infraestructura',1)
--Insert Into @TablaTitulos values('5515'+REPLICATE('0',@Estructura1-4),'                  Depreciación de bienes muebles',1)
--Insert Into @TablaTitulos values('5516'+REPLICATE('0',@Estructura1-4),'                  Deterioro de los activos biológicos',1)
--Insert Into @TablaTitulos values('5517'+REPLICATE('0',@Estructura1-4),'                  Amortización de activos intangibles',1)
--Insert Into @TablaTitulos values('5518'+REPLICATE('0',@Estructura1-4),'                  Disminución de Bienes por pérdida, obsolescencia y deterioro',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '552' and Nivel <= 4 
--Insert Into @TablaTitulos values('5521'+REPLICATE('0',@Estructura1-4),'                  Provisiones de pasivos corto plazo',1)
--Insert Into @TablaTitulos values('5522'+REPLICATE('0',@Estructura1-4),'                  Provisiones de pasivos largo plazo',1)
 
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '553' and Nivel <= 4 
--Insert Into @TablaTitulos values('5531'+REPLICATE('0',@Estructura1-4),'                  Disminución de Inventarios de Mercancías para venta',1)
--Insert Into @TablaTitulos values('5532'+REPLICATE('0',@Estructura1-4),'                  Disminución de Inventarios de Mercancías terminadas',1)
--Insert Into @TablaTitulos values('5533'+REPLICATE('0',@Estructura1-4),'                  Disminución de Inventarios de Mercancías en Proceso de Elaboración',1)
--Insert Into @TablaTitulos values('5534'+REPLICATE('0',@Estructura1-4),'                  Disminución de Inventarios de Materias primas, materiales y suministros para producción ',1)
--Insert Into @TablaTitulos values('5534'+REPLICATE('0',@Estructura1-4),'                  Disminución de Almacén de materiales y suministros de consumo',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '554' and Nivel <= 4 
--Insert Into @TablaTitulos values('5441'+REPLICATE('0',@Estructura1-4),'                  Aumento por insuficiencia de estimaciones por pérdida o deterioro u obsolescencia',1)

Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '555' and Nivel <= 4 
--Insert Into @TablaTitulos values('5551'+REPLICATE('0',@Estructura1-4),'                  Aumento por insuficiencia de provisiones',1)
 
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '559' and Nivel <= 4 
--Insert Into @TablaTitulos values('5591'+REPLICATE('0',@Estructura1-4),'                  Gastos de ejercicios anteriores',1)
--Insert Into @TablaTitulos values('5592'+REPLICATE('0',@Estructura1-4),'                  Pérdidas por responsabilidades',1)
--Insert Into @TablaTitulos values('5593'+REPLICATE('0',@Estructura1-4),'                  Bonificaciones y descuentos otorgados',1)
--Insert Into @TablaTitulos values('5599'+REPLICATE('0',@Estructura1-4),'                  Otros gastos varios',1)

 
Insert Into @TablaTitulos values('560'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura,'          Inversión pública',3,0)  
Insert Into @TablaTitulos Select NumeroCuenta, NombreCuenta,2,Nivel FROM C_Contable Where SUBSTRING(NumeroCuenta,1,3) = '561' and Nivel <= 4 
--Insert Into @TablaTitulos values('5611'+REPLICATE('0',@Estructura1-4),'                  Construcción en bienes no capitalizable',1)
--fin de manejo de nombres fijos  
--Update @TablaTitulos set NumeroCuenta = LEFT(NumeroCuenta, @Estructura1) Where Nivel = 2

--Select * from @TablaTitulos

INSERT INTO @Tmp_BalanzaDeComprobacion 
SELECT  TOP (100) PERCENT   
dbo.C_Contable.NumeroCuenta,   
dbo.C_Contable.NombreCuenta,   
dbo.T_SaldosInicialesCont.CargosSinFlujo,   
dbo.T_SaldosInicialesCont.AbonosSinFlujo,   
dbo.T_SaldosInicialesCont.TotalCargos,   
dbo.T_SaldosInicialesCont.TotalAbonos,   
CASE C_Contable.TipoCuenta   
WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos   
WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos   
WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos   
WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos  
WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos   
ELSE 0 END AS SaldoDeudor,   
CASE C_Contable.TipoCuenta   
WHEN 'A' THEN 0   
WHEN 'C' THEN 0   
WHEN 'E' THEN 0   
WHEN 'G' THEN 0   
WHEN 'I' THEN 0   
ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos END AS SaldoAcreedor,   
LEFT(dbo.C_Contable.NumeroCuenta, 1) AS TipoCuenta,   
LEFT(dbo.C_Contable.NumeroCuenta, @Estructura1) AS MaskNumeroCuenta,   
LEN(LEFT(dbo.C_Contable.NumeroCuenta, @Estructura1)) - LEN(REPLACE(LEFT(dbo.C_Contable.NumeroCuenta, @Estructura1), 0, '')) AS Total,   
dbo.T_SaldosInicialesCont.Mes,   
dbo.T_SaldosInicialesCont.Year,   
dbo.FormatoCadena(dbo.C_Contable.NombreCuenta, dbo.C_Contable.NumeroCuenta) AS MaskNombreCuenta,  
RPT_Balanza_Comprobacio_Anterior_1.NumeroCuenta AS NumeroCuentaAnt,   
RPT_Balanza_Comprobacio_Anterior_1.SaldoDeudor AS SaldoDeudorAnt,   
RPT_Balanza_Comprobacio_Anterior_1.SaldoAcreedor AS SaldoAcreedorAnt,   
RPT_Balanza_Comprobacio_Anterior_1.Mes AS MesAnt,   
RPT_Balanza_Comprobacio_Anterior_1.Year AS AñoAnt,   
1 as Agrupador,
Nivel   
FROM         dbo.C_Contable   
INNER JOIN dbo.T_SaldosInicialesCont   
ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable   
LEFT OUTER JOIN dbo.RPT_Balanza_Comprobacio_Anterior_Niveles(@mes , @año - 1) AS RPT_Balanza_Comprobacio_Anterior_1   
ON dbo.C_Contable.IdCuentaContable = RPT_Balanza_Comprobacio_Anterior_1.IdCuentaContable  
WHERE     (dbo.C_Contable.TipoCuenta <> 'X')   
--AND ((RIGHT(C_Contable.NumeroCuenta, @Estructura2) = @CerosEstructura ))   
AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '3')   
AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '6')   
AND  (dbo.T_SaldosInicialesCont.Mes = @mes)   
AND (dbo.T_SaldosInicialesCont.Year = @año)   
--and dbo.C_Contable.NumeroCuenta in (Select NumeroCuenta From @TablaTitulos where Nivel <> 0)  
ORDER BY dbo.C_Contable.NumeroCuenta  

 --Select * from @Tmp_BalanzaDeComprobacion
--Acreedor  
Select @433ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('433'+REPLICATE('0',@Estructura1-3)))  
Select @434ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('434'+REPLICATE('0',@Estructura1-3)))  
select @551ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('551'+REPLICATE('0',@Estructura1-3)))  
select @552ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('552'+REPLICATE('0',@Estructura1-3)))  
select @554ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('554'+REPLICATE('0',@Estructura1-3)))  
select @555ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('555'+REPLICATE('0',@Estructura1-3)))  
--AcreedorAnt  
Select @433ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('433'+REPLICATE('0',@Estructura1-3)))  
Select @434ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('434'+REPLICATE('0',@Estructura1-3)))  
select @551ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('551'+REPLICATE('0',@Estructura1-3)))  
select @552ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('552'+REPLICATE('0',@Estructura1-3)))  
select @554ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('554'+REPLICATE('0',@Estructura1-3)))  
select @555ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('555'+REPLICATE('0',@Estructura1-3)))  
--Deudor  
Select @433DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('433'+REPLICATE('0',@Estructura1-3)))  
Select @434DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('434'+REPLICATE('0',@Estructura1-3)))  
select @551DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('551'+REPLICATE('0',@Estructura1-3)))  
select @552DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('552'+REPLICATE('0',@Estructura1-3)))  
select @554DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('554'+REPLICATE('0',@Estructura1-3)))  
select @555DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('555'+REPLICATE('0',@Estructura1-3)))  
--DeudorAnt  
Select @433DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('433'+REPLICATE('0',@Estructura1-3)))  
Select @434DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('434'+REPLICATE('0',@Estructura1-3)))  
select @551DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('551'+REPLICATE('0',@Estructura1-3)))  
select @552DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('552'+REPLICATE('0',@Estructura1-3)))  
select @554DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('554'+REPLICATE('0',@Estructura1-3)))  
select @555DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('555'+REPLICATE('0',@Estructura1-3)))  
  
UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta ='              DISMINUCIÓN DEL EXCESO DE ESTIMACIONES POR PÉRDIDA O DETERIORO U OBSOLESCENCIA', saldoacreedor = saldoacreedor+@434ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@434ACRAnt,  
 SaldoDeudor=SaldoDeudor+@434DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @434DEUAnt where MaskNumeroCuenta = ('433'+REPLICATE('0',@Estructura1-3))  
--UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = '              ESTIMACIONES, DEPRECIACIONES, DETERIOROS, OBSOLESCENCIAS, AMORTIZACIONES', saldoacreedor = saldoacreedor+@552ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@552ACRAnt,  
-- SaldoDeudor=SaldoDeudor+@552DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @552DEUAnt where MaskNumeroCuenta = ('551'+REPLICATE('0',@Estructura1-3))  
UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = '              AUMENTO POR INSUFICIENCIA DE ESTIMACIONES POR PÉRDIDA, DETERIORO Y OBSOLESCENCIA',saldoacreedor = saldoacreedor+@554ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@554ACRAnt,  
 SaldoDeudor=SaldoDeudor+@554DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @554DEUAnt where MaskNumeroCuenta = ('554'+REPLICATE('0',@Estructura1-3))  
--UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = MaskNombreCuenta+'*' where MaskNumeroCuenta=('415'+REPLICATE('0',@Estructura1-3))  
--UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = MaskNombreCuenta+' [Resultado Integral de Financiamiento (RIF)]'where MaskNumeroCuenta='55900'  
   
DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = ('434'+REPLICATE('0',@Estructura1-3))  
--DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = ('552'+REPLICATE('0',@Estructura1-3))  
DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = ('555'+REPLICATE('0',@Estructura1-3))  
  

--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like '___0_' and masknumerocuenta not like '___00'  
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___1'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___10'+REPLICATE('0',@Estructura1-5))  
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___2'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___20'+REPLICATE('0',@Estructura1-5))  
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___3'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___30'+REPLICATE('0',@Estructura1-5))  
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___4'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___40'+REPLICATE('0',@Estructura1-5))  
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___5'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___50'+REPLICATE('0',@Estructura1-5))  
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___6'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___60'+REPLICATE('0',@Estructura1-5))  
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___7'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___70'+REPLICATE('0',@Estructura1-5))  
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___8'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___80'+REPLICATE('0',@Estructura1-5))  
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___9'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___90'+REPLICATE('0',@Estructura1-5))  
--Select * from @Tmp_BalanzaDeComprobacion  
--llena las cuentas faltantes (en caso que no esten)  

Insert into @Tmp_BalanzaDeComprobacion   
--Select NumeroCuenta+'-'+ REPLICATE('0',@Estructura2),
Select NumeroCuenta,     
Nombre,  
0,  
0,  
0,  
0,  
0,  
0,convert(int,SUBSTRING(NumeroCuenta,1,1)),NumeroCuenta,Total,@Mes,@Año,Nombre,NumeroCuenta,0,0,@Mes,@Año-1,1,Nivel  
  
--NumeroCuenta varchar(max),  
--NombreCuenta varchar(max),  
--CargosSinFlujo decimal(15,2),  
--AbonosSinFlujo decimal(15,2),  
--TotalCargos decimal(15,2),  
--TotalAbonos decimal(15,2),  
--SaldoDeudor decimal(15,2),  
--SaldoAcreedor decimal(15,2),  
--TipoCuenta int,    
--MaskNumeroCuenta varchar(max),  
--Total int,   
--Mes int,   
--Year int,   
--MaskNombreCuenta varchar(max),  
--NumeroCuentaAnt varchar(max),   
--SaldoDeudorAnt decimal(15,2),  
--SaldoAcreedorAnt decimal(15,2),  
--MesAnt int,  
--AñoAnt int,  
--Agrupador int  
  
from @TablaTitulos where Numerocuenta not in (Select NumeroCuenta from @Tmp_BalanzaDeComprobacion)  
--Select * from @Tmp_BalanzaDeComprobacion  
--Select * from @TablaTitulos  
  Select  @SaldoAcreedorTemp = ISNULL(SaldoAcreedor,0) from @Tmp_BalanzaDeComprobacion where NumeroCuenta = '400'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura
  --Select  @SaldoAcreedorTemp
 Select @SaldoDeudorTemp = ISNULL(SaldoDeudor,0) from @Tmp_BalanzaDeComprobacion where NumeroCuenta = '500'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura
--Select @SaldoDeudorTemp

 Select @SaldoAcreedorTempAnt = ISNULL(SaldoAcreedorAnt,0) from @Tmp_BalanzaDeComprobacion where NumeroCuenta = '400'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura
 Select @SaldoDeudorTempAnt = ISNULL(SaldoDeudorAnt,0)  from @Tmp_BalanzaDeComprobacion where NumeroCuenta = '500'+REPLICATE('0',@Estructura1-3)+'-'+@cerosEstructura

if @SaldoDeudorTemp = 0 Set @SaldoDeudorTemp = 1
if @SaldoAcreedorTemp = 0 Set @SaldoAcreedorTemp = 1
if @SaldoDeudorTempAnt = 0 Set @SaldoDeudorTempAnt = 1
if @SaldoAcreedorTempAnt = 0 Set @SaldoAcreedorTempAnt = 1

if @SaldoDeudorTemp is null Set @SaldoDeudorTemp = 1
if @SaldoAcreedorTemp is null Set @SaldoAcreedorTemp = 1
if @SaldoDeudorTempAnt is null Set @SaldoDeudorTempAnt = 1
if @SaldoAcreedorTempAnt is null Set @SaldoAcreedorTempAnt = 1

--Select * from @Tmp_BalanzaDeComprobacion
--Select * from @TablaTitulos
if @MostrarVacios =1   
begin  
 if @Redondeo = 1   
  Begin  

  SELECT   
  A.NumeroCuenta,  
  NombreCuenta,  
  Round(isnull(cast((CargosSinFlujo/@Division)as decimal (18,2)),0),0) as CargosSinFlujo,  
  Round(isnull(cast((AbonosSinFlujo/@Division)as decimal (18,2)),0),0) as AbonosSinFlujo,  
  Round(isnull(cast((TotalCargos/@Division)as decimal (18,2)),0),0) as TotalCargos,  
  Round(isnull(cast((TotalAbonos/@Division)as decimal (18,2)),0),0) as TotalAbonos,  
  Round(isnull(cast((SaldoDeudor/@Division)as decimal (18,3)),0),0) as SaldoDeudor,  
  Round(isnull(cast((SaldoAcreedor/@Division)as decimal (18,3)),0),0) as SaldoAcreedor,  
  TipoCuenta,    
  MaskNumeroCuenta,  
  A.Total,   
  Mes,   
  Year,  
   COALESCE((Round(isnull(cast((SaldoDeudor/@Division)as decimal (18,3)),0),0) / NULLIF(Round(isnull(cast((@SaldoDeudorTemp/@Division)as decimal (18,3)),0),0),0))+
	 (Round(isnull(cast((SaldoAcreedor/@Division)as decimal (18,3)),0),0) / NULLIF(Round(isnull(cast((@SaldoAcreedorTemp/@Division)as decimal (18,3)),0),0),0)),0)*100  porcentaje,
 
  --CASE    
  -- WHEN MaskNumeroCuenta IN ('400'+REPLICATE('0',@Estructura1-3),'500'+REPLICATE('0',@Estructura1-3))   
  --  THEN (Select UPPER(LEFT(B.Nombre,5))+LOWER(SUBSTRING(B.Nombre,6,LEN(B.Nombre))))  
  -- WHEN MaskNumeroCuenta IN ('410'+REPLICATE('0',@Estructura1-3),'420'+REPLICATE('0',@Estructura1-3),'430'+REPLICATE('0',@Estructura1-3),'510'+REPLICATE('0',@Estructura1-3),'520'+REPLICATE('0',@Estructura1-3),'530'+REPLICATE('0',@Estructura1-3),'540'+REPLICATE('0',@Estructura1-3),'550'+REPLICATE('0',@Estructura1-3),'560'+REPLICATE('0',@Estructura1-3))   
  --  THEN (Select UPPER(LEFT(B.Nombre,11))+LOWER(SUBSTRING(B.Nombre,12,LEN(B.Nombre))))  
  -- ELSE (Select UPPER(LEFT(B.Nombre,15))+LOWER(SUBSTRING(B.Nombre,16,LEN(B.Nombre))))  
  --END  as MaskNombreCuenta,  
  CASE A.Nivel
  When 0 THEN Nombre
  When 1 THEN '          '+NombreCuenta
  When 2 THEN '             '+NombreCuenta
  When 3 THEN '                '+NombreCuenta
  When 4 THEN '                   '+NombreCuenta
  ELSE        '                      '+NombreCuenta
  END AS MaskNombreCuenta, 
  NumeroCuentaAnt,   
  Round(isnull(cast((SaldoDeudorAnt/@Division)as decimal (18,4)),0),0) as SaldoDeudorAnt,  
  Round(isnull(cast((SaldoAcreedorAnt/@Division)as decimal (18,4)),0),0) as SaldoAcreedorAnt,  
  MesAnt,  
  AñoAnt,  
      COALESCE((Round(isnull(cast((SaldoDeudorAnt/@Division)as decimal (18,4)),0),0)/ NULLIF(Round(isnull(cast((@SaldoDeudorTempAnt/@Division)as decimal (18,3)),0),0),0))+
	  (Round(isnull(cast((SaldoAcreedorAnt/@Division)as decimal (18,4)),0),0)/ NULLIF(Round(isnull(cast((@SaldoAcreedorTempAnt/@Division)as decimal (18,3)),0),0),0)),0)*100 porcentajeAnt,

  Agrupador,
  A.Nivel  
  FROM @Tmp_BalanzaDeComprobacion A LEFT JOIN @TablaTitulos B ON A.NumeroCuenta = B.NumeroCuenta
  Where A.Nivel <= 4  
  order by MaskNumeroCuenta  
  end  
 Else  
  Begin  
  
  SELECT   
  A.NumeroCuenta,  
  NombreCuenta,  
  isnull(cast((CargosSinFlujo/@Division)as decimal (18,2)),0) as CargosSinFlujo,  
  isnull(cast((AbonosSinFlujo/@Division)as decimal (18,2)),0) as AbonosSinFlujo,  
  isnull(cast((TotalCargos/@Division)as decimal (18,2)),0) as TotalCargos,  
  isnull(cast((TotalAbonos/@Division)as decimal (18,2)),0) as TotalAbonos,  
  isnull(cast((SaldoDeudor/@Division)as decimal (18,3)),0) as SaldoDeudor,  
  isnull(cast((SaldoAcreedor/@Division)as decimal (18,3)),0) as SaldoAcreedor,  
  TipoCuenta,    
  MaskNumeroCuenta,  
  A.Total,   
  Mes,   
  Year,  
	COALESCE((Round(isnull(cast((SaldoDeudor/@Division)as decimal (18,3)),0),0) / NULLIF(Round(isnull(cast((@SaldoDeudorTemp/@Division)as decimal (18,3)),0),0),0))+
	(Round(isnull(cast((SaldoAcreedor/@Division)as decimal (18,3)),0),0) / NULLIF(Round(isnull(cast((@SaldoAcreedorTemp/@Division)as decimal (18,3)),0),0),0)),0)*100 as porcentaje,

  --CASE    
  -- WHEN MaskNumeroCuenta IN ('400'+REPLICATE('0',@Estructura1-3),'500'+REPLICATE('0',@Estructura1-3))   
  --  THEN (Select UPPER(LEFT(B.Nombre,5))+LOWER(SUBSTRING(B.Nombre,6,LEN(B.Nombre))))  
  -- WHEN MaskNumeroCuenta IN ('410'+REPLICATE('0',@Estructura1-3),'420'+REPLICATE('0',@Estructura1-3),'430'+REPLICATE('0',@Estructura1-3),'510'+REPLICATE('0',@Estructura1-3),'520'+REPLICATE('0',@Estructura1-3),'530'+REPLICATE('0',@Estructura1-3),'540'+REPLICATE('0',@Estructura1-3),'550'+REPLICATE('0',@Estructura1-3),'560'+REPLICATE('0',@Estructura1-3))   
  --  THEN (Select UPPER(LEFT(B.Nombre,11))+LOWER(SUBSTRING(B.Nombre,12,LEN(B.Nombre))))  
  -- ELSE (Select UPPER(LEFT(B.Nombre,15))+LOWER(SUBSTRING(B.Nombre,16,LEN(B.Nombre))))  
  --END  as MaskNombreCuenta,
    CASE A.Nivel
  When 0 THEN Nombre
  When 1 THEN '          '+NombreCuenta
  When 2 THEN '             '+NombreCuenta
  When 3 THEN '                '+NombreCuenta
  When 4 THEN '                   '+NombreCuenta
  ELSE        '                      '+NombreCuenta
  END AS MaskNombreCuenta, 
  NumeroCuentaAnt,   
  isnull(cast((SaldoDeudorAnt/@Division)as decimal (18,4)),0) as SaldoDeudorAnt,  
  isnull(cast((SaldoAcreedorAnt/@Division)as decimal (18,4)),0) as SaldoAcreedorAnt,  
  MesAnt,  
  AñoAnt,  
     COALESCE((Round(isnull(cast((SaldoDeudorAnt/@Division)as decimal (18,4)),0),0) / NULLIF(Round(isnull(cast((@SaldoDeudorTempAnt/@Division)as decimal (18,3)),0),0),0))+
	  (Round(isnull(cast((SaldoAcreedorAnt/@Division)as decimal (18,4)),0),0) / NULLIF(Round(isnull(cast((@SaldoAcreedorTempAnt/@Division)as decimal (18,3)),0),0),0)),0)*100 as porcentajeAnt,

  Agrupador,
  A.Nivel  
  FROM @Tmp_BalanzaDeComprobacion A LEFT JOIN @TablaTitulos B ON A.NumeroCuenta = B.NumeroCuenta 
  Where A.Nivel <= 4   
  order by MaskNumeroCuenta  
  end  
End  
Else  
Begin  
 if @Redondeo=1  
 Begin 
  
  SELECT   
  A.NumeroCuenta,  
  NombreCuenta,  
  Round(isnull(cast((CargosSinFlujo/NULLIF(@Division,0))as decimal (18,2)),0),0) as CargosSinFlujo,  
  Round(isnull(cast((AbonosSinFlujo/NULLIF(@Division,0))as decimal (18,2)),0),0) as AbonosSinFlujo,  
  Round(isnull(cast((TotalCargos/NULLIF(@Division,0))as decimal (18,2)),0),0) as TotalCargos,  
  Round(isnull(cast((TotalAbonos/NULLIF(@Division,0))as decimal (18,2)),0),0) as TotalAbonos,  
  Round(isnull(cast((SaldoDeudor/NULLIF(@Division,0))as decimal (18,3)),0),0) as SaldoDeudor,  
  Round(isnull(cast((SaldoAcreedor/NULLIF(@Division,0))as decimal (18,3)),0),0) as SaldoAcreedor,  
  TipoCuenta,    
  MaskNumeroCuenta,  
  A.Total,   
  Mes,   
  Year, 
     ((CONVERT(FLOAT,ROUND(isnull(cast((SaldoDeudor/NULLIF(@Division,0))as decimal (18,3)),0), 4, 1))/ CONVERT(FLOAT,ROUND(isnull(cast((@SaldoDeudorTemp/NULLIF(@Division,0))as decimal (18,3)),0), 4, 1)))+
	 (CONVERT(FLOAT,Round(isnull(cast((SaldoAcreedor/NULLIF(@Division,0))as decimal (18,3)),0), 4, 1))/CONVERT(FLOAT,Round(isnull(cast((@SaldoAcreedorTemp/NULLIF(@Division,0))as decimal (18,3)),0), 4, 1)) ))*100 as porcentaje,
  --CASE    
  -- WHEN MaskNumeroCuenta IN ('400'+REPLICATE('0',@Estructura1-3),'500'+REPLICATE('0',@Estructura1-3))   
  --  THEN (Select UPPER(LEFT(B.Nombre,5))+LOWER(SUBSTRING(B.Nombre,6,LEN(B.Nombre))))  
  -- WHEN MaskNumeroCuenta IN ('410'+REPLICATE('0',@Estructura1-3),'420'+REPLICATE('0',@Estructura1-3),'430'+REPLICATE('0',@Estructura1-3),'510'+REPLICATE('0',@Estructura1-3),'520'+REPLICATE('0',@Estructura1-3),'530'+REPLICATE('0',@Estructura1-3),'540'+REPLICATE('0',@Estructura1-3),'550'+REPLICATE('0',@Estructura1-3),'560'+REPLICATE('0',@Estructura1-3))   
  --  THEN (Select UPPER(LEFT(B.Nombre,11))+LOWER(SUBSTRING(B.Nombre,12,LEN(B.Nombre))))  
  -- ELSE (Select UPPER(LEFT(B.Nombre,15))+LOWER(SUBSTRING(B.Nombre,16,LEN(B.Nombre))))  
  --END  as MaskNombreCuenta,  
     CASE A.Nivel
  When 0 THEN Nombre
  When 1 THEN '          '+NombreCuenta
  When 2 THEN '             '+NombreCuenta
  When 3 THEN '                '+NombreCuenta
  When 4 THEN '                   '+NombreCuenta
  ELSE        '                      '+NombreCuenta
  END AS MaskNombreCuenta, 
  NumeroCuentaAnt,   
  Round(isnull(cast((SaldoDeudorAnt/NULLIF(@Division,0))as decimal (18,4)),0),0) as SaldoDeudorAnt,  
  Round(isnull(cast((SaldoAcreedorAnt/NULLIF(@Division,0))as decimal (18,4)),0),0) as SaldoAcreedorAnt,  
  MesAnt,  
  AñoAnt,  
       COALESCE(Round(isnull(cast((SaldoDeudorAnt/@Division)as decimal (18,4)),0),0)/ NULLIF(Round(isnull(cast((@SaldoDeudorTempAnt/@Division)as decimal (18,3)),0),0),0)+
	  Round(isnull(cast((SaldoAcreedorAnt/@Division)as decimal (18,4)),0),0)/ NULLIF(Round(isnull(cast((@SaldoAcreedorTempAnt/@Division)as decimal (18,3)),0),0),0),0)*100 as porcentajeAnt,
  Agrupador,
  A.Nivel  
  FROM @Tmp_BalanzaDeComprobacion A LEFT JOIN @TablaTitulos B ON A.NumeroCuenta = B.NumeroCuenta  
  Where (SaldoDeudor <>0 or SaldoAcreedor<>0 or SaldoDeudorAnt <>0 or SaldoAcreedorAnt <> 0)  
  And A.Nivel <= 4  
  order by MaskNumeroCuenta  
 End   
 Else  
 Begin  
 
  SELECT   
  A.NumeroCuenta,  
  NombreCuenta,  
  isnull(cast((CargosSinFlujo/NULLIF(@Division,0))as decimal (18,2)),0) as CargosSinFlujo,  
  isnull(cast((AbonosSinFlujo/NULLIF(@Division,0))as decimal (18,2)),0) as AbonosSinFlujo,  
  isnull(cast((TotalCargos/NULLIF(@Division,0))as decimal (18,2)),0) as TotalCargos,  
  isnull(cast((TotalAbonos/NULLIF(@Division,0))as decimal (18,2)),0) as TotalAbonos,  
  isnull(cast((SaldoDeudor/NULLIF(@Division,0))as decimal (18,3)),0) as SaldoDeudor,  
  isnull(cast((SaldoAcreedor/NULLIF(@Division,0))as decimal (18,3)),0) as SaldoAcreedor,  
  TipoCuenta,    
  MaskNumeroCuenta,  
  A.Total,   
  Mes,   
  Year,  
  
   COALESCE((Round(isnull(cast((SaldoDeudor/@Division)as decimal (18,3)),0),0) / NULLIF(Round(isnull(cast((@SaldoDeudorTemp/@Division)as decimal (18,3)),0),0),0))+
	 (Round(isnull(cast((SaldoAcreedor/@Division)as decimal (18,3)),0),0) / NULLIF(Round(isnull(cast((@SaldoAcreedorTemp/@Division)as decimal (18,3)),0),0),0)),0)*100 as porcentaje,
   
  --CASE    
  -- WHEN MaskNumeroCuenta IN ('400'+REPLICATE('0',@Estructura1-3),'500'+REPLICATE('0',@Estructura1-3))   
  --  THEN (Select UPPER(LEFT(B.Nombre,5))+LOWER(SUBSTRING(B.Nombre,6,LEN(B.Nombre))))  
  -- WHEN MaskNumeroCuenta IN ('410'+REPLICATE('0',@Estructura1-3),'420'+REPLICATE('0',@Estructura1-3),'430'+REPLICATE('0',@Estructura1-3),'510'+REPLICATE('0',@Estructura1-3),'520'+REPLICATE('0',@Estructura1-3),'530'+REPLICATE('0',@Estructura1-3),'540'+REPLICATE('0',@Estructura1-3),'550'+REPLICATE('0',@Estructura1-3),'560'+REPLICATE('0',@Estructura1-3))   
  --  THEN (Select UPPER(LEFT(B.Nombre,11))+LOWER(SUBSTRING(B.Nombre,12,LEN(B.Nombre))))  
  -- ELSE (Select UPPER(LEFT(B.Nombre,15))+LOWER(SUBSTRING(B.Nombre,16,LEN(B.Nombre))))  
  --END  as MaskNombreCuenta,  
   CASE A.Nivel
  When 0 THEN Nombre
  When 1 THEN '          '+NombreCuenta
  When 2 THEN '             '+NombreCuenta
  When 3 THEN '                '+NombreCuenta
  When 4 THEN '                   '+NombreCuenta
  ELSE        '                      '+NombreCuenta
  END AS MaskNombreCuenta, 
  NumeroCuentaAnt,   
  isnull(cast((SaldoDeudorAnt/NULLIF(@Division,0))as decimal (18,4)),0) as SaldoDeudorAnt,  
  isnull(cast((SaldoAcreedorAnt/NULLIF(@Division,0))as decimal (18,4)),0) as SaldoAcreedorAnt,  
  MesAnt,  
  AñoAnt,  
      COALESCE((Round(isnull(cast((SaldoDeudorAnt/@Division)as decimal (18,4)),0),0)) / NULLIF(Round(isnull(cast((@SaldoDeudorTempAnt/@Division)as decimal (18,3)),0),0),0)+
	  (Round(isnull(cast((SaldoAcreedorAnt/@Division)as decimal (18,4)),0),0) / NULLIF(Round(isnull(cast((@SaldoAcreedorTempAnt/@Division)as decimal (18,3)),0),0),0)),0)*100 as porcentajeAnt,

  Agrupador,
  A.Nivel  
  FROM @Tmp_BalanzaDeComprobacion A LEFT JOIN @TablaTitulos B ON A.NumeroCuenta = B.NumeroCuenta  
  Where (SaldoDeudor <>0 or SaldoAcreedor<>0 or SaldoDeudorAnt <>0 or SaldoAcreedorAnt <> 0) 
  And A.Nivel <= 4   
  order by MaskNumeroCuenta  
  end  
End  
--FIN DE PROCEDIMIENTO  
  
END 

--go
  
--Exec [REPORTE_Estado_De_ActividadesRedondeo_Detallado] 4,2018,0,0,1 