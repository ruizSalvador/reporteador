/****** Object:  StoredProcedure [dbo].[REPORTE_Estado_De_ActividadesAnaliticoRedondeoPorcentaje]    Script Date: 07/23/2014 09:45:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[REPORTE_Estado_De_ActividadesAnaliticoRedondeoPorcentaje]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[REPORTE_Estado_De_ActividadesAnaliticoRedondeoPorcentaje]
GO

/****** Object:  StoredProcedure [dbo].[REPORTE_Estado_De_ActividadesAnaliticoRedondeoPorcentaje]    Script Date: 03/10/2014 09:45:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec REPORTE_Estado_De_ActividadesAnaliticoRedondeoPorcentaje 1,2,2016,0,0,1
CREATE PROCEDURE [dbo].[REPORTE_Estado_De_ActividadesAnaliticoRedondeoPorcentaje]
@mes smallint,
@mes2 smallint,
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
Declare @Inicio smallint = @mes

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
Agrupador int  )

Declare @Tmp_BalanzaDeComprobacionFinal TABLE(
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
TotalAbonos2 decimal(18,2),
TotalCargos2 decimal(18,2),
TotalAbonos3 decimal(18,2),
TotalCargos3 decimal(18,2),
TotalAbonos4 decimal(18,2),
TotalCargos4 decimal(18,2),
TotalAbonos5 decimal(18,2),
TotalCargos5 decimal(18,2), 
TotalAbonos6 decimal(18,2),
TotalCargos6 decimal(18,2), 
TotalAbonos7 decimal(18,2),
TotalCargos7 decimal(18,2),
TotalAbonos8 decimal(18,2),
TotalCargos8 decimal(18,2),
TotalAbonos9 decimal(18,2),
TotalCargos9 decimal(18,2),
TotalAbonos10 decimal(18,2),
TotalCargos10 decimal(18,2),
TotalAbonos11 decimal(18,2),
TotalCargos11 decimal(18,2),
TotalAbonos12 decimal(18,2),
TotalCargos12 decimal(18,2),
TotalFinal decimal(18,2))
--Manejo de nombres fijos
Declare @TablaTitulos table
(Numerocuenta varchar(max),
Nombre varchar(max),
Total int)

Insert Into @TablaTitulos values ('400'+REPLICATE('0',@Estructura1-3),'    INGRESOS Y OTROS BENEFICIOS',4)
Insert Into @TablaTitulos values('410'+REPLICATE('0',@Estructura1-3),'          INGRESOS DE GESTIÓN',3)
Insert Into @TablaTitulos values('411'+REPLICATE('0',@Estructura1-3),'              IMPUESTOS',2)
Insert Into @TablaTitulos values('412'+REPLICATE('0',@Estructura1-3),'              CUOTAS Y APORTACIONES DE SEGURIDAD SOCIAL',2)
Insert Into @TablaTitulos values('413'+REPLICATE('0',@Estructura1-3),'              CONTRIBUCIONES DE MEJORAS',2)
Insert Into @TablaTitulos values('4143'+REPLICATE('0',@Estructura1-4),'             DERECHOS POR PRESTACIÓN DE SERVICIOS',2)
Insert Into @TablaTitulos values('4144'+REPLICATE('0',@Estructura1-4),'             ACCESORIOS DE DERECHOS',2)
Insert Into @TablaTitulos values('4149'+REPLICATE('0',@Estructura1-4),'              OTROS DERECHOS',2)
Insert Into @TablaTitulos values('414'+REPLICATE('0',@Estructura1-3),'              DERECHOS',2)
Insert Into @TablaTitulos values('415'+REPLICATE('0',@Estructura1-3),'              PRODUCTOS DE TIPO CORRIENTE*',2)
Insert Into @TablaTitulos values('416'+REPLICATE('0',@Estructura1-3),'              APROVECHAMIENTOS DE TIPO CORRIENTE',2)
Insert Into @TablaTitulos values('417'+REPLICATE('0',@Estructura1-3),'              INGRESOS POR VENTA DE BIENES Y SERVICIOS',2)
Insert Into @TablaTitulos values('419'+REPLICATE('0',@Estructura1-3),'              INGRESOS NO COMPRENDIDOS EN LAS FRACCIONES DE LA LEY DE INGRESOS CAUSADOS EN EJERCICIOS FISCALES ANTERIORES	PENDIENTES DE LIQUIDACIÓN O PAGO',2)
--Insert Into @TablaTitulos values('4191'+REPLICATE('0',@Estructura1-4),'                  IMPUESTOS NO COMPRENDIDOS EN LAS FRACCIONES DE LA LEY DE INGRESOS CAUSADOS EN EJERCICIOS FISCALES ANTERIORES	PENDIENTES DE LIQUIDACIÓN O PAGO',1)
Insert Into @TablaTitulos values('420'+REPLICATE('0',@Estructura1-3),'          PARTICIPACIONES,APORTACIONES,TRANSFERENCIAS,ASIGNACIONES,SUBSIDIOS Y OTRAS AYUDAS',3)
Insert Into @TablaTitulos values('421'+REPLICATE('0',@Estructura1-3),'              PARTICIPACIONES Y APORTACIONES',2)
Insert Into @TablaTitulos values('422'+REPLICATE('0',@Estructura1-3),'              TRANSFERENCIAS, ASIGNACIONES, SUBSIDIOS Y OTRAS AYUDAS',2)
Insert Into @TablaTitulos values('4223'+REPLICATE('0',@Estructura1-4),'              SUBSIDIOS Y SUBVENCIONES',2)
Insert Into @TablaTitulos values('4224'+REPLICATE('0',@Estructura1-4),'              AYUDAS SOCIALES',2)
Insert Into @TablaTitulos values('430'+REPLICATE('0',@Estructura1-3),'          OTROS INGRESOS Y BENEFICIOS',3)
Insert Into @TablaTitulos values('431'+REPLICATE('0',@Estructura1-3),'              INGRESOS FINANCIEROS',2)
Insert Into @TablaTitulos values('432'+REPLICATE('0',@Estructura1-3),'              INCREMENTO POR VARIACIÓN DE INVENTARIOS',2)
Insert Into @TablaTitulos values('433'+REPLICATE('0',@Estructura1-3),'              DISMINUCIÓN DEL EXCESO DE ESTIMACIONES POR PÉRDIDA O DETERIORO U OBSOLESCENCIA',2)
Insert Into @TablaTitulos values('4341'+REPLICATE('0',@Estructura1-4),'          DISMINUCIÓN DEL EXCESO EN PROVISIONES',1)
Insert Into @TablaTitulos values('434'+REPLICATE('0',@Estructura1-3),'          DISMINUCIÓN DEL EXCESO DE PROVISIONES',1)
Insert Into @TablaTitulos values('439'+REPLICATE('0',@Estructura1-3),'              OTROS INGRESOS Y BENEFICIOS VARIOS',2)

Insert Into @TablaTitulos values('500'+REPLICATE('0',@Estructura1-3),'    GASTOS Y OTRAS PERDIDAS',4)
Insert Into @TablaTitulos values('510'+REPLICATE('0',@Estructura1-3),'          GASTOS DE FUNCIONAMIENTO',3)
Insert Into @TablaTitulos values('511'+REPLICATE('0',@Estructura1-3),'              SERVICIOS PERSONALES',2)
Insert Into @TablaTitulos values('5111'+REPLICATE('0',@Estructura1-4),'                REMUNERACIONES AL PERSONAL DE CARÁCTER PERMANENTE',2)
Insert Into @TablaTitulos values('5112'+REPLICATE('0',@Estructura1-4),'                REMUNERACIONES AL PERSONAL DE CARÁCTER TRANSITORIO',2)
Insert Into @TablaTitulos values('5113'+REPLICATE('0',@Estructura1-4),'                REMUNERACIONES ADICIONALES Y ESPECIALES',2)
Insert Into @TablaTitulos values('5114'+REPLICATE('0',@Estructura1-4),'                SEGURIDAD SOCIAL',2)
Insert Into @TablaTitulos values('5115'+REPLICATE('0',@Estructura1-4),'                OTRAS PRESTACIONES SOCIALES Y ECONÓMICAS',2)
Insert Into @TablaTitulos values('5116'+REPLICATE('0',@Estructura1-4),'                PAGO DE ESTÍMULOS A SERVIDORES PÚBLICOS',2)
Insert Into @TablaTitulos values('512'+REPLICATE('0',@Estructura1-3),'              MATERIALES Y SUMINISTROS',2)
Insert Into @TablaTitulos values('5121'+REPLICATE('0',@Estructura1-4),'                MATERIALES DE ADMINISTRACIÓN, EMISIÓN DE DOCUMENTOS Y ARTÍCULOS OFICIALES',2)
Insert Into @TablaTitulos values('5122'+REPLICATE('0',@Estructura1-4),'                ALIMENTOS Y UTENSILIOS',2)
Insert Into @TablaTitulos values('5123'+REPLICATE('0',@Estructura1-4),'                MATERIAS PRIMAS Y MATERIALES DE PRODUCCIÓN',2)
Insert Into @TablaTitulos values('5124'+REPLICATE('0',@Estructura1-4),'                MATERIALES Y ARTÍCULOS DE CONSTRUCCIÓN Y DE REPARACIÓN',2)
Insert Into @TablaTitulos values('5125'+REPLICATE('0',@Estructura1-4),'                PRODUCTOS QUÍMICOS, FARMACÉUTICOS Y DE LABORATORIO',2)
Insert Into @TablaTitulos values('5126'+REPLICATE('0',@Estructura1-4),'                COMBUSTIBLES, LUBRICANTES Y ADITIVOS',2)
Insert Into @TablaTitulos values('5127'+REPLICATE('0',@Estructura1-4),'                VESTUARIO, BLANCOS, PRENDAS DE PROTECCIÓN Y ARTÍCULOS DEPORTIVOS',2)
Insert Into @TablaTitulos values('5128'+REPLICATE('0',@Estructura1-4),'                MATERIALES Y SUMINISTROS PARA SEGURIDAD',2)
Insert Into @TablaTitulos values('5129'+REPLICATE('0',@Estructura1-4),'                HERRAMIENTAS, REFACCIONES Y ACCESSORIOS MENORES',2)
Insert Into @TablaTitulos values('513'+REPLICATE('0',@Estructura1-3),'              SERVICIOS GENERALES',2)
Insert Into @TablaTitulos values('5131'+REPLICATE('0',@Estructura1-4),'                SERVICIOS BÁSICOS',2)
Insert Into @TablaTitulos values('5132'+REPLICATE('0',@Estructura1-4),'                SERVICIOS DE ARRENDAMIENTO',2)
Insert Into @TablaTitulos values('5133'+REPLICATE('0',@Estructura1-4),'                SERVICIOS PROFESIONALES, CIENTÍFICOS Y TÉCNICOS Y OTROS SERVICIOS',2)
Insert Into @TablaTitulos values('5134'+REPLICATE('0',@Estructura1-4),'                SERVICIOS FINANCIEROS, BANCARIOS Y COMERCIALES',2)
Insert Into @TablaTitulos values('5135'+REPLICATE('0',@Estructura1-4),'                SERVICIOS DE INSTALACIÓN, REPARACIÓN, MANTENIMIENTO Y CONVSERVACIÓN',2)
Insert Into @TablaTitulos values('5136'+REPLICATE('0',@Estructura1-4),'                SERVICIOS DE COMUNICACIÓN SOCIAL',2)
Insert Into @TablaTitulos values('5137'+REPLICATE('0',@Estructura1-4),'                SERVICIOS DE TRASLADO Y VIÁTICOS',2)
Insert Into @TablaTitulos values('5138'+REPLICATE('0',@Estructura1-4),'                SERVICIOS OFICIALES',2)
Insert Into @TablaTitulos values('5139'+REPLICATE('0',@Estructura1-4),'                OTROS SERVICIOS GENERALES',2)
Insert Into @TablaTitulos values('520'+REPLICATE('0',@Estructura1-3),'          TRANSFERENCIAS, ASIGNACIONES, SUBSIDIOS Y OTRAS AYUDAS',3)
Insert Into @TablaTitulos values('521'+REPLICATE('0',@Estructura1-3),'              TRANSFERENCIAS INTERNAS Y ASIGNACIONES AL SECTOR PÚBLICO',2)
Insert Into @TablaTitulos values('5211'+REPLICATE('0',@Estructura1-4),'                ASIGNACIONES AL SECTOR PÚBLICO',2)
Insert Into @TablaTitulos values('5212'+REPLICATE('0',@Estructura1-4),'                TRANSFERENCIAS INTERNAS AL SECTOR PÚBLICO',2)
Insert Into @TablaTitulos values('522'+REPLICATE('0',@Estructura1-3),'              TRANSFERENCIAS AL RESTO DEL SECTOR PÚBLICO',2)
Insert Into @TablaTitulos values('5221'+REPLICATE('0',@Estructura1-4),'                TRANSFERENCIAS A ENTIDADES PARAESTATALES',2)
Insert Into @TablaTitulos values('5222'+REPLICATE('0',@Estructura1-4),'                TRANSFERENCIAS A ENTIDADES FEDERATIVAS Y MUNICIPIOS',2)
Insert Into @TablaTitulos values('523'+REPLICATE('0',@Estructura1-3),'              SUBSIDIOS Y SUBVENCIONES',2)
Insert Into @TablaTitulos values('5231'+REPLICATE('0',@Estructura1-4),'                SUBSIDIOS',2)
Insert Into @TablaTitulos values('5232'+REPLICATE('0',@Estructura1-4),'                SUBVENCIONES',2)
Insert Into @TablaTitulos values('524'+REPLICATE('0',@Estructura1-3),'              AYUDAS SOCIALES',2)
Insert Into @TablaTitulos values('5241'+REPLICATE('0',@Estructura1-4),'                AYUDAS SOCIALES A PERSONAS',2)
Insert Into @TablaTitulos values('5242'+REPLICATE('0',@Estructura1-4),'                BECAS',2)
Insert Into @TablaTitulos values('5243'+REPLICATE('0',@Estructura1-4),'                AYUDAS SOCIALES A INSTITUCIONES',2)
Insert Into @TablaTitulos values('5244'+REPLICATE('0',@Estructura1-4),'                AYUDAS SOCIALES POR DESASTRES NATURALES Y OTROS SINIESTROS',2)
Insert Into @TablaTitulos values('525'+REPLICATE('0',@Estructura1-3),'              PENSIONES Y JUBILACIONES',2)
Insert Into @TablaTitulos values('5251'+REPLICATE('0',@Estructura1-4),'                PENSIONES',2)
Insert Into @TablaTitulos values('5252'+REPLICATE('0',@Estructura1-4),'                JUBILACIONES',2)
Insert Into @TablaTitulos values('5259'+REPLICATE('0',@Estructura1-4),'                OTRAS PENSIONES Y JUBILACIONES',2)
Insert Into @TablaTitulos values('526'+REPLICATE('0',@Estructura1-3),'              TRANSFERENCIAS A FIDEICOMISOS,MANDATOS Y CONTRATOS ANÁLOGOS',2)
Insert Into @TablaTitulos values('5261'+REPLICATE('0',@Estructura1-4),'                TRANSFERENCIAS A FIDEICOMISOS, MANDATOS Y CONTRATOS ANÁLOGOS AL GOBIERNO',2)
Insert Into @TablaTitulos values('5262'+REPLICATE('0',@Estructura1-4),'                TRANSFERENCIAS A FIDEICOMISOS, MANDATOS Y CONTRATOS ANÁLOGOS A ENTIDADES PARAESTATALES',2)
Insert Into @TablaTitulos values('527'+REPLICATE('0',@Estructura1-3),'              TRANSFERENCIAS A LA SEGURIDAD SOCIAL',2)
Insert Into @TablaTitulos values('5271'+REPLICATE('0',@Estructura1-4),'                TRANSFERENCIAS POR OBLIGACIONES DE LEY',2)
Insert Into @TablaTitulos values('528'+REPLICATE('0',@Estructura1-3),'              DONATIVOS',2)
Insert Into @TablaTitulos values('5281'+REPLICATE('0',@Estructura1-4),'                DONATIVOS A INSTITUCIONES SIN FINES DE LUCRO',2)
Insert Into @TablaTitulos values('5282'+REPLICATE('0',@Estructura1-4),'                DONATIVOS A ENTIDADES FEDERATIVAS Y MUNICIPIOS',2)
Insert Into @TablaTitulos values('5283'+REPLICATE('0',@Estructura1-4),'                DONATIVOS A FIDEICOMISO, MANDATOS Y CONTRATOS ANÁLOGOS PRIVADOS',2)
Insert Into @TablaTitulos values('5284'+REPLICATE('0',@Estructura1-4),'                DONATIVOS A FIDEICOMISO, MANDATOS Y CONTRATOS ANÁLOGOS ESTATALES',2)
Insert Into @TablaTitulos values('5285'+REPLICATE('0',@Estructura1-4),'                DONATIVOS INTERNACIONALES',2)
Insert Into @TablaTitulos values('529'+REPLICATE('0',@Estructura1-3),'              TRANSFERENCIAS AL EXTERIOR',2)
Insert Into @TablaTitulos values('5291'+REPLICATE('0',@Estructura1-4),'                TRANSFERENCIAS AL EXTERIOR A GOBIERNOS EXTRANJEROS Y ORGANISMOS INTERNACIONALES',2)
Insert Into @TablaTitulos values('5292'+REPLICATE('0',@Estructura1-4),'                TRANSFERENCIAS AL SECTOR PRIVADO EXTERNO',2)
Insert Into @TablaTitulos values('530'+REPLICATE('0',@Estructura1-3),'          PARTICIPACIONES Y APORTACIONES',3)
Insert Into @TablaTitulos values('531'+REPLICATE('0',@Estructura1-3),'              PARTICIPACIONES',2)
Insert Into @TablaTitulos values('5311'+REPLICATE('0',@Estructura1-4),'                PARTICIPACIONES DE LA FEDERACIÓN A ENTIDADES FEDERATIVAS Y MUNICIPIOS',2)
Insert Into @TablaTitulos values('5312'+REPLICATE('0',@Estructura1-4),'                PARTICIPACIONES DE LAS ENTIDADES FEDERATIVAS A LOS MUNICIPIOS',2)
Insert Into @TablaTitulos values('532'+REPLICATE('0',@Estructura1-3),'              APORTACIONES',2)
Insert Into @TablaTitulos values('5321'+REPLICATE('0',@Estructura1-4),'                APORTACIONES DE LA FEDERACIÓN A ENTIDADES FEDERATIVAS Y MUNICIPIOS',2)
Insert Into @TablaTitulos values('5322'+REPLICATE('0',@Estructura1-4),'                APORTACIONES DE LAS ENTIDADES FEDERATIVAS A LOS MUNICIPIOS',2)
Insert Into @TablaTitulos values('533'+REPLICATE('0',@Estructura1-3),'              CONVENIOS',2)
Insert Into @TablaTitulos values('5331'+REPLICATE('0',@Estructura1-4),'                CONVENIOS DE REASIGNACIÓN',2)
Insert Into @TablaTitulos values('5332'+REPLICATE('0',@Estructura1-4),'                CONVENIOS DE DESCENTRALIZACIÓN Y OTROS ',2)
Insert Into @TablaTitulos values('540'+REPLICATE('0',@Estructura1-3),'          INTERESES,COMISIONES Y OTROS GASTOS DE LA DEUDA PÚBLICA',3)
Insert Into @TablaTitulos values('541'+REPLICATE('0',@Estructura1-3),'              INTERESES DE LA DEUDA PÚBLICA',2)
Insert Into @TablaTitulos values('5411'+REPLICATE('0',@Estructura1-4),'                INTERESES DE LA DEUDA PÚBLICA INTERNA',2)
Insert Into @TablaTitulos values('5412'+REPLICATE('0',@Estructura1-4),'                INTERESES DE LA DEUDA PÚBLICA EXTERNA',2)
Insert Into @TablaTitulos values('542'+REPLICATE('0',@Estructura1-3),'              COMISIONES DE LA DEUDA PÚBLICA',2)
Insert Into @TablaTitulos values('5421'+REPLICATE('0',@Estructura1-4),'                COMISIONES DE LA DEUDA PÚBLICA INTERNA',2)
Insert Into @TablaTitulos values('5422'+REPLICATE('0',@Estructura1-4),'                COMISIONES DE LA DEUDA PÚBLICA EXTERNA',2)
Insert Into @TablaTitulos values('543'+REPLICATE('0',@Estructura1-3),'              GASTOS DE LA DEUDA PÚBLICA',2)
Insert Into @TablaTitulos values('5431'+REPLICATE('0',@Estructura1-4),'                GASTOS DE LA DEUDA PÚBLICA INTERNA',2)
Insert Into @TablaTitulos values('5432'+REPLICATE('0',@Estructura1-4),'                GASTOS DE LA DEUDA PÚBLICA EXTERNA',2)
Insert Into @TablaTitulos values('544'+REPLICATE('0',@Estructura1-3),'              COSTO POR COBERTURAS',2)
Insert Into @TablaTitulos values('5441'+REPLICATE('0',@Estructura1-4),'                COSTO POR COBERTURAS',2)
Insert Into @TablaTitulos values('545'+REPLICATE('0',@Estructura1-3),'              APOYOS FINANCIEROS',2)
Insert Into @TablaTitulos values('5451'+REPLICATE('0',@Estructura1-4),'                APOYOS FINANCIEROS A INTERMEDIARIOS',2)
Insert Into @TablaTitulos values('5452'+REPLICATE('0',@Estructura1-4),'                APOYOS FINANCIEROS A AHORRADORES Y DEUDORES DEL SISTEMA FINANCIERO NACIONAL',2)
Insert Into @TablaTitulos values('550'+REPLICATE('0',@Estructura1-3),'          OTROS GASTOS Y PERDIDAS EXTRAORDINARIAS',3)
Insert Into @TablaTitulos values('551'+REPLICATE('0',@Estructura1-3),'             ESTIMACIONES, DEPRECIACIONES, DETERIOROS, OBSOLESCENCIAS, AMORTIZACIONES',2)
Insert Into @TablaTitulos values('5511'+REPLICATE('0',@Estructura1-4),'                ESTIMACIONES POR PÉRDIDA O DETERIORO DE ACTIVOS CIRCULANTES',2)
Insert Into @TablaTitulos values('5512'+REPLICATE('0',@Estructura1-4),'                ESTIMACIONES POR PÉRDIDA O DETERIORO DE ACTIVOS NO CIRCULANTE',2)
Insert Into @TablaTitulos values('5513'+REPLICATE('0',@Estructura1-4),'                DEPRECIACION DE BIENES INMUEBLES',2)
Insert Into @TablaTitulos values('5514'+REPLICATE('0',@Estructura1-4),'                DEPRECIACIÓN DE INFRAESTRUCTURA',2)
Insert Into @TablaTitulos values('5515'+REPLICATE('0',@Estructura1-4),'                DEPRECIACIÓN DE BIENES MUEBLES',2)
Insert Into @TablaTitulos values('5516'+REPLICATE('0',@Estructura1-4),'                DETERIORO DE LOS ACTIVOS BIOLÓGICOS',2)
Insert Into @TablaTitulos values('5517'+REPLICATE('0',@Estructura1-4),'                AMORTIZACIÓN DE ACTIVOS INTANGIBLES',2)
Insert Into @TablaTitulos values('552'+REPLICATE('0',@Estructura1-3),'              PROVISIONES',2)
Insert Into @TablaTitulos values('5521'+REPLICATE('0',@Estructura1-4),'                PROVISIONES DE PASIVOS A CORTO PLAZO',2)
Insert Into @TablaTitulos values('5522'+REPLICATE('0',@Estructura1-4),'                PROVISIONES DE PASIVOS A LARGO PLAZO',2)
Insert Into @TablaTitulos values('553'+REPLICATE('0',@Estructura1-3),'              DISMINUCIÓN DE INVENTARIOS',2)
Insert Into @TablaTitulos values('5531'+REPLICATE('0',@Estructura1-4),'                DISMINUCIÓN DE INVENTARIOS DE MERCANCÍAS PARA VENTA',2)
Insert Into @TablaTitulos values('5532'+REPLICATE('0',@Estructura1-4),'                DISMINUCIÓN DE INVENTARIOS DE MERCANCÍAS TERMINADAS',2)
Insert Into @TablaTitulos values('5533'+REPLICATE('0',@Estructura1-4),'                DISMINUCIÓN DE INVENTARIOS DE MERCANCÍAS EN PROCESO DE ELABORACIÓN ',2)
Insert Into @TablaTitulos values('5534'+REPLICATE('0',@Estructura1-4),'                DISMINUCIÓN DE INVENTARIOS DE MATERIAS PRIMAS, MATERIALES Y SUMINISTROS PARA PRODUCCIÓN',2)
Insert Into @TablaTitulos values('5535'+REPLICATE('0',@Estructura1-4),'                DISMINUCIÓN DE ALMACÉN DE MATERIALES Y SUMINISTROS DE CONSUMO',2)
Insert Into @TablaTitulos values('554'+REPLICATE('0',@Estructura1-3),'              AUMENTO POR INSUFICIENCIA DE ESTIMACIONES POR PÉRDIDA, DETERIORO Y OBSOLESCENCIA',2)
Insert Into @TablaTitulos values('5541'+REPLICATE('0',@Estructura1-4),'                AUMENTO POR INSUFICIENCIA DE ESTIMACIONES POR PÉRDIDA O DETERIORO U OBSOLESCENCIA',2)
Insert Into @TablaTitulos values('555'+REPLICATE('0',@Estructura1-3),'              AUMENTO POR INSUFICIENCIA DE PROVISIONES',2)
Insert Into @TablaTitulos values('5551'+REPLICATE('0',@Estructura1-4),'                AUMENTO POR INSUFICIENCIA DE PROVISIONES',2)
Insert Into @TablaTitulos values('559'+REPLICATE('0',@Estructura1-3),'              OTROS GASTOS',2)
Insert Into @TablaTitulos values('5591'+REPLICATE('0',@Estructura1-4),'                GASTOS DE EJERCICIOS ANTERIORES',2)
Insert Into @TablaTitulos values('5592'+REPLICATE('0',@Estructura1-4),'                PÉRDIDAS POR RESPONSABILIDADES',2)
Insert Into @TablaTitulos values('5593'+REPLICATE('0',@Estructura1-4),'                BONIFICACIONES Y DESCUENTOS OTORGADOS',2)
Insert Into @TablaTitulos values('5594'+REPLICATE('0',@Estructura1-4),'                DIFERENCIAS POR TIPO DE CAMBIO NEGATIVAS EN EFECTIVO Y EQUIVALENTES',2)
Insert Into @TablaTitulos values('5595'+REPLICATE('0',@Estructura1-4),'                DIFERENCIAS DE COTIZACIONES NEGATIVAS EN VALORES NEGOCIABLES',2)
Insert Into @TablaTitulos values('5596'+REPLICATE('0',@Estructura1-4),'                RESULTADO POR POSICIÓN MONETARIA',2)
Insert Into @TablaTitulos values('5597'+REPLICATE('0',@Estructura1-4),'                PÉRDIDAS POR PARTICIPACIÓN PATRIMONIAL',2)
Insert Into @TablaTitulos values('5599'+REPLICATE('0',@Estructura1-4),'                OTROS GASTOS VARIOS',2)
Insert Into @TablaTitulos values('560'+REPLICATE('0',@Estructura1-3),'          INVERSION PUBLICA',3)
Insert Into @TablaTitulos values('561'+REPLICATE('0',@Estructura1-3),'              INVERSION PUBLICA NO CAPITALIZABLE',2)
Insert Into @TablaTitulos values('5611'+REPLICATE('0',@Estructura1-4),'                CONSTRUCCIÓN EN BIENES NO CAPITALIZABLE',2)

--fin de manejo de nombres fijos
--Declare @mesini smallint= @mes-1
While @mes <= @mes2
Begin

	INSERT INTO @Tmp_BalanzaDeComprobacion SELECT  TOP (100) PERCENT 
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
	1 as Agrupador 
	FROM         dbo.C_Contable 
	INNER JOIN dbo.T_SaldosInicialesCont 
	ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable 
	LEFT OUTER JOIN dbo.RPT_Balanza_Comprobacio_Anterior(@mes , @año - 1) AS RPT_Balanza_Comprobacio_Anterior_1 
	ON dbo.C_Contable.IdCuentaContable = RPT_Balanza_Comprobacio_Anterior_1.IdCuentaContable
	WHERE     (dbo.C_Contable.TipoCuenta <> 'X') 
	AND ((RIGHT(C_Contable.NumeroCuenta, @Estructura2) = @CerosEstructura )) 
	AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '3') 
	AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '6') 
	AND  (dbo.T_SaldosInicialesCont.Mes = @mes) 
	AND (dbo.T_SaldosInicialesCont.Year = @año) 
	and LEFT(dbo.C_Contable.NumeroCuenta, @Estructura1) in (Select NumeroCuenta From @TablaTitulos)
	ORDER BY dbo.C_Contable.NumeroCuenta
	

	UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta ='              DISMINUCIÓN DEL EXCESO DE ESTIMACIONES POR PÉRDIDA O DETERIORO U OBSOLESCENCIA', saldoacreedor = saldoacreedor+@434ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@434ACRAnt,
		SaldoDeudor=SaldoDeudor+@434DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @434DEUAnt where MaskNumeroCuenta = ('433'+REPLICATE('0',@Estructura1-3))
	UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = '              ESTIMACIONES, DEPRECIACIONES, DETERIOROS, OBSOLESCENCIAS, AMORTIZACIONES', saldoacreedor = saldoacreedor+@552ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@552ACRAnt,
		SaldoDeudor=SaldoDeudor+@552DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @552DEUAnt where MaskNumeroCuenta = ('551'+REPLICATE('0',@Estructura1-3))
	UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = '              AUMENTO POR INSUFICIENCIA DE ESTIMACIONES POR PÉRDIDA, DETERIORO Y OBSOLESCENCIA',saldoacreedor = saldoacreedor+@554ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@554ACRAnt,
		SaldoDeudor=SaldoDeudor+@554DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @554DEUAnt where MaskNumeroCuenta = ('554'+REPLICATE('0',@Estructura1-3))
	--UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = MaskNombreCuenta+'*' where MaskNumeroCuenta=('415'+REPLICATE('0',@Estructura1-3))
	--UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = MaskNombreCuenta+' [Resultado Integral de Financiamiento (RIF)]'where MaskNumeroCuenta='55900'
	
	DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = ('434'+REPLICATE('0',@Estructura1-3))
	--DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = ('552'+REPLICATE('0',@Estructura1-3))
	DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = ('555'+REPLICATE('0',@Estructura1-3))
--End

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

--llena las cuentas faltantes (en caso que no esten)
Insert into @Tmp_BalanzaDeComprobacion 
Select NumeroCuenta+'-'+ REPLICATE('0',@Estructura2), 
Nombre,
0,
0,
0,
0,
0,
0,convert(int,SUBSTRING(NumeroCuenta,1,1)),NumeroCuenta,Total,@Mes,@Año,Nombre,NumeroCuenta,0,0,@Mes,@Año-1,1

from @TablaTitulos where Numerocuenta not in (Select MaskNumeroCuenta from @Tmp_BalanzaDeComprobacion)
Set @mes = @mes+1

End


Insert into @Tmp_BalanzaDeComprobacionFinal
Select NumeroCuenta,
	   NombreCuenta,
	   CargosSinFlujo,
	   AbonosSinFlujo,
	   TotalCargos,
	   TotalAbonos,
	   SaldoDeudor,
	   SaldoAcreedor,
	   TipoCuenta,
	   MaskNumeroCuenta,
	   Total,
	   Mes,
	   Year,
	   MaskNombreCuenta,
	   NumeroCuentaAnt,
	   SaldoDeudorAnt,
	   SaldoAcreedorAnt,
	   MesAnt,
	   AñoAnt,
	   Agrupador,
	    0 as TotalAbonos2,
		0 as TotalCargos2 ,
		0 as TotalAbonos3 ,
		0 as TotalCargos3 ,
		0 as TotalAbonos4 ,
		0 as TotalCargos4 ,
		0 as TotalAbonos5 ,
		0 as TotalCargos5, 
		0 as TotalAbonos6 ,
		0 as TotalCargos6 , 
		0 as TotalAbonos7 ,
		0 as TotalCargos7 ,
		0 as TotalAbonos8 ,
		0 as TotalCargos8 ,
		0 as TotalAbonos9 ,
		0 as TotalCargos9 ,
		0 as TotalAbonos10 ,
		0 as TotalCargos10 ,
		0 as TotalAbonos11 ,
		0 as TotalCargos11 ,
		0 as TotalAbonos12 ,
		0 as TotalCargos12 ,
		0 as TotalFinal
 from @Tmp_BalanzaDeComprobacion Where Mes = @Inicio

 if @Inicio <> 1
 Begin
 Update @Tmp_BalanzaDeComprobacionFinal Set TotalAbonos = 0
 Update @Tmp_BalanzaDeComprobacionFinal Set TotalCargos = 0
 End
 Update Final Set Final.TotalAbonos2 = tmp.TotalAbonos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 2
 Update Final Set Final.TotalCargos2 = tmp.TotalCargos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 2
  Update Final Set Final.TotalAbonos3 = tmp.TotalAbonos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 3
 Update Final Set Final.TotalCargos3 = tmp.TotalCargos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 3
  Update Final Set Final.TotalAbonos4 = tmp.TotalAbonos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 4
 Update Final Set Final.TotalCargos4 = tmp.TotalCargos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 4
  Update Final Set Final.TotalAbonos5 = tmp.TotalAbonos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 5
 Update Final Set Final.TotalCargos5 = tmp.TotalCargos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 5
  Update Final Set Final.TotalAbonos6 = tmp.TotalAbonos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 6
 Update Final Set Final.TotalCargos6 = tmp.TotalCargos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 6
  Update Final Set Final.TotalAbonos7 = tmp.TotalAbonos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 7
 Update Final Set Final.TotalCargos7 = tmp.TotalCargos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 7
  Update Final Set Final.TotalAbonos8 = tmp.TotalAbonos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 8
 Update Final Set Final.TotalCargos8 = tmp.TotalCargos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 8
  Update Final Set Final.TotalAbonos9 = tmp.TotalAbonos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 9
 Update Final Set Final.TotalCargos9 = tmp.TotalCargos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 9
  Update Final Set Final.TotalAbonos10 = tmp.TotalAbonos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 10
 Update Final Set Final.TotalCargos10 = tmp.TotalCargos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 10
  Update Final Set Final.TotalAbonos11 = tmp.TotalAbonos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 11
 Update Final Set Final.TotalCargos11 = tmp.TotalCargos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 11
  Update Final Set Final.TotalAbonos12 = tmp.TotalAbonos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 12
 Update Final Set Final.TotalCargos12 = tmp.TotalCargos FROM  @Tmp_BalanzaDeComprobacionFinal As Final Inner Join @Tmp_BalanzaDeComprobacion As tmp ON Final.NumeroCuenta = tmp.NumeroCuenta And tmp.Mes = 12

 --Where @Tmp_BalanzaDeComprobacionFinal.NumeroCuenta = @Tmp_BalanzaDeComprobacion.NumeroCuenta and @Tmp_BalanzaDeComprobacion.Mes = 2
 Declare @Final TABLE(
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
Porcentaje1 decimal (18,2),
TotalAbonos2 decimal(18,2),
TotalCargos2 decimal(18,2),
Porcentaje2 decimal (18,2),
TotalAbonos3 decimal(18,2),
TotalCargos3 decimal(18,2),
Porcentaje3 decimal (18,2),
TotalAbonos4 decimal(18,2),
TotalCargos4 decimal(18,2),
Porcentaje4 decimal (18,2),
TotalAbonos5 decimal(18,2),
TotalCargos5 decimal(18,2),
Porcentaje5 decimal (18,2), 
TotalAbonos6 decimal(18,2),
TotalCargos6 decimal(18,2),
Porcentaje6 decimal (18,2), 
TotalAbonos7 decimal(18,2),
TotalCargos7 decimal(18,2),
Porcentaje7 decimal (18,2),
TotalAbonos8 decimal(18,2),
TotalCargos8 decimal(18,2),
Porcentaje8 decimal (18,2),
TotalAbonos9 decimal(18,2),
TotalCargos9 decimal(18,2),
Porcentaje9 decimal (18,2),
TotalAbonos10 decimal(18,2),
TotalCargos10 decimal(18,2),
Porcentaje10 decimal (18,2),
TotalAbonos11 decimal(18,2),
TotalCargos11 decimal(18,2),
Porcentaje11 decimal (18,2),
TotalAbonos12 decimal(18,2),
TotalCargos12 decimal(18,2),
TotalFinal decimal(18,2)
,mesFin int)

if @Redondeo = 1 
	begin
	Insert into @Final
		SELECT 
		NumeroCuenta,
		NombreCuenta,
		Round(isnull(cast((CargosSinFlujo/@Division)as decimal (18,2)),0),0) as CargosSinFlujo,
		Round(isnull(cast((AbonosSinFlujo/@Division)as decimal (18,2)),0),0) as AbonosSinFlujo,
		Round(isnull(cast((TotalCargos/@Division)as decimal (18,2)),0),0) as TotalCargos,
		Round(isnull(cast((TotalAbonos/@Division)as decimal (18,2)),0),0) as TotalAbonos,
		Round(isnull(cast((SaldoDeudor/@Division)as decimal (18,3)),0),0) as SaldoDeudor,
		Round(isnull(cast((SaldoAcreedor/@Division)as decimal (18,3)),0),0) as SaldoAcreedor,
		TipoCuenta,  
		MaskNumeroCuenta,
		Total, 
		Mes, 
		Year, 
		MaskNombreCuenta,
		NumeroCuentaAnt, 
		Round(isnull(cast((SaldoDeudorAnt/@Division)as decimal (18,4)),0),0) as SaldoDeudorAnt,
		Round(isnull(cast((SaldoAcreedorAnt/@Division)as decimal (18,4)),0),0) as SaldoAcreedorAnt,
		MesAnt,
		AñoAnt,
		Agrupador,
	   CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos2-TotalAbonos2)/@Division),0)/Nullif(isnull(((TotalCargos-TotalAbonos)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos2-TotalCargos2)/@Division),0)/Nullif(isnull(((TotalAbonos-TotalCargos)/@Division),0),0))*100,0) End as Porcentaje1,
		Round(isnull(cast((TotalAbonos2/@Division) as decimal (18,4)),0),0) as TotalAbonos2,
	    Round(isnull(cast((TotalCargos2/@Division) as decimal (18,4)),0),0) as TotalCargos2,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos3-TotalAbonos3)/@Division),0)/Nullif(isnull(((TotalCargos2-TotalAbonos2)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos3-TotalCargos3)/@Division),0)/Nullif(isnull(((TotalAbonos2-TotalCargos2)/@Division),0),0))*100,0) End as Porcentaje2,
	    Round(isnull(cast((TotalAbonos3/@Division) as decimal (18,4)),0),0) as TotalAbonos3,
	    Round(isnull(cast((TotalCargos3/@Division) as decimal (18,4)),0),0) as TotalCargos3,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos4-TotalAbonos4)/@Division),0)/Nullif(isnull(((TotalCargos3-TotalAbonos3)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos4-TotalCargos4)/@Division),0)/Nullif(isnull(((TotalAbonos3-TotalCargos3)/@Division),0),0))*100,0) End as Porcentaje3,
	    Round(isnull(cast((TotalAbonos4/@Division) as decimal (18,4)),0),0) as TotalAbonos4,
	    Round(isnull(cast((TotalCargos4/@Division) as decimal (18,4)),0),0) as TotalCargos4,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos5-TotalAbonos5)/@Division),0)/Nullif(isnull(((TotalCargos4-TotalAbonos4)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos5-TotalCargos5)/@Division),0)/Nullif(isnull(((TotalAbonos4-TotalCargos4)/@Division),0),0))*100,0) End as Porcentaje4,
	    Round(isnull(cast((TotalAbonos5/@Division) as decimal (18,4)),0),0) as TotalAbonos5,
	    Round(isnull(cast((TotalCargos5/@Division) as decimal (18,4)),0),0) as TotalCargos5,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos6-TotalAbonos6)/@Division),0)/Nullif(isnull(((TotalCargos5-TotalAbonos5)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos6-TotalCargos6)/@Division),0)/Nullif(isnull(((TotalAbonos5-TotalCargos5)/@Division),0),0))*100,0) End as Porcentaje5, 
	    Round(isnull(cast((TotalAbonos6/@Division) as decimal (18,4)),0),0) as TotalAbonos6,
	    Round(isnull(cast((TotalCargos6/@Division) as decimal (18,4)),0),0) as TotalCargos6,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos7-TotalAbonos7)/@Division),0)/Nullif(isnull(((TotalCargos6-TotalAbonos6)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos7-TotalCargos7)/@Division),0)/Nullif(isnull(((TotalAbonos6-TotalCargos6)/@Division),0),0))*100,0)  End as Porcentaje6, 
	    Round(isnull(cast((TotalAbonos7/@Division) as decimal (18,4)),0),0) as TotalAbonos7,
	    Round(isnull(cast((TotalCargos7/@Division) as decimal (18,4)),0),0) as TotalCargos7,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos8-TotalAbonos8)/@Division),0)/Nullif(isnull(((TotalCargos7-TotalAbonos7)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos8-TotalCargos8)/@Division),0)/Nullif(isnull(((TotalAbonos7-TotalCargos7)/@Division),0),0))*100,0) End as Porcentaje7,
	    Round(isnull(cast((TotalAbonos8/@Division) as decimal (18,4)),0),0) as TotalAbonos8,
	    Round(isnull(cast((TotalCargos8/@Division) as decimal (18,4)),0),0) as TotalCargos8,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos9-TotalAbonos9)/@Division),0)/Nullif(isnull(((TotalCargos8-TotalAbonos8)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos9-TotalCargos9)/@Division),0)/Nullif(isnull(((TotalAbonos8-TotalCargos8)/@Division),0),0))*100,0) End as Porcentaje8,
	    Round(isnull(cast((TotalAbonos9/@Division) as decimal (18,4)),0),0) as TotalAbonos9,
	    Round(isnull(cast((TotalCargos9/@Division) as decimal (18,4)),0),0) as TotalCargos9,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos10-TotalAbonos10)/@Division),0)/Nullif(isnull(((TotalCargos9-TotalAbonos9)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos10-TotalCargos10)/@Division),0)/Nullif(isnull(((TotalAbonos9-TotalCargos9)/@Division),0),0))*100,0) End as Porcentaje9,
	    Round(isnull(cast((TotalAbonos10/@Division) as decimal (18,4)),0),0) as TotalAbonos10,
	    Round(isnull(cast((TotalCargos10/@Division) as decimal (18,4)),0),0) as TotalCargos10,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos11-TotalAbonos11)/@Division),0)/Nullif(isnull(((TotalCargos10-TotalAbonos10)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos11-TotalCargos11)/@Division),0)/Nullif(isnull(((TotalAbonos10-TotalCargos10)/@Division),0),0))*100,0) End as Porcentaje10,
	    Round(isnull(cast((TotalAbonos11/@Division) as decimal (18,4)),0),0) as TotalAbonos11,
	    Round(isnull(cast((TotalCargos11/@Division) as decimal (18,4)),0),0) as TotalCargos11,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos12-TotalAbonos12)/@Division),0)/Nullif(isnull(((TotalCargos11-TotalAbonos11)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos12-TotalCargos12)/@Division),0)/Nullif(isnull(((TotalAbonos11-TotalCargos11)/@Division),0),0))*100,0) End as Porcentaje11,
	    Round(isnull(cast((TotalAbonos12/@Division) as decimal (18,4)),0),0) as TotalAbonos12,
	    Round(isnull(cast((TotalCargos12/@Division) as decimal (18,4)),0),0) as TotalCargos12,
	    Round((TotalAbonos+TotalCargos+TotalAbonos2+TotalCargos2+TotalAbonos3+TotalCargos3+TotalAbonos4+TotalCargos4+TotalAbonos5+TotalCargos5+TotalAbonos6+TotalCargos6+TotalAbonos7+TotalCargos7+TotalAbonos8+TotalCargos8+TotalAbonos9+TotalCargos9+TotalAbonos10+TotalCargos10+TotalAbonos11+TotalCargos11+TotalAbonos12+TotalCargos12)/@Division,0) as TotalFinal
		,@mes2 as mesFin
		FROM @Tmp_BalanzaDeComprobacionFinal
	end
else
	begin
	Insert into @Final
		Select NumeroCuenta,
	   NombreCuenta,
	   isnull(cast((CargosSinFlujo/@Division) as decimal (18,2)),0) as CargosSinFlujo,
	   isnull(cast((AbonosSinFlujo/@Division) as decimal (18,2)),0) as AbonosSinFlujo,
	   isnull(cast((TotalCargos/@Division) as decimal (18,2)),0) as TotalCargos,
	   isnull(cast((TotalAbonos/@Division) as decimal (18,2)),0) as TotalAbonos,
	   isnull(cast((SaldoDeudor/@Division) as decimal (18,3)),0) as SaldoDeudor,
	   isnull(cast((SaldoAcreedor/@Division )as decimal (18,3)),0) as SaldoAcreedor,
	   TipoCuenta,
	   MaskNumeroCuenta,
	   Total,
	   Mes,
	   Year,
	   MaskNombreCuenta,
	   NumeroCuentaAnt,
	   isnull(cast((SaldoDeudorAnt/@Division)as decimal (18,4)),0) as SaldoDeudorAnt,
	   isnull(cast((SaldoAcreedorAnt/@Division)as decimal (18,4)),0) as SaldoAcreedorAnt,
	   MesAnt,
	   AñoAnt,
	   Agrupador,
	   CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos2-TotalAbonos2)/@Division),0)/Nullif(isnull(((TotalCargos-TotalAbonos)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos2-TotalCargos2)/@Division),0)/Nullif(isnull(((TotalAbonos-TotalCargos)/@Division),0),0))*100,0) End as Porcentaje1,
	    isnull(cast((TotalAbonos2/@Division) as decimal (18,4)),0) as TotalAbonos2,
	    isnull(cast((TotalCargos2/@Division) as decimal (18,4)),0) as TotalCargos2,
	   CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos3-TotalAbonos3)/@Division),0)/Nullif(isnull(((TotalCargos2-TotalAbonos2)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos3-TotalCargos3)/@Division),0)/Nullif(isnull(((TotalAbonos2-TotalCargos2)/@Division),0),0))*100,0) End as Porcentaje2,
	    isnull(cast((TotalAbonos3/@Division) as decimal (18,4)),0) as TotalAbonos3,
	    isnull(cast((TotalCargos3/@Division) as decimal (18,4)),0) as TotalCargos3,
	   CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos4-TotalAbonos4)/@Division),0)/Nullif(isnull(((TotalCargos3-TotalAbonos3)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos4-TotalCargos4)/@Division),0)/Nullif(isnull(((TotalAbonos3-TotalCargos3)/@Division),0),0))*100,0) End as Porcentaje3,
	    isnull(cast((TotalAbonos4/@Division) as decimal (18,4)),0) as TotalAbonos4,
	    isnull(cast((TotalCargos4/@Division) as decimal (18,4)),0) as TotalCargos4,
	   CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos5-TotalAbonos5)/@Division),0)/Nullif(isnull(((TotalCargos4-TotalAbonos4)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos5-TotalCargos5)/@Division),0)/Nullif(isnull(((TotalAbonos4-TotalCargos4)/@Division),0),0))*100,0) End as Porcentaje4,
	    isnull(cast((TotalAbonos5/@Division) as decimal (18,4)),0) as TotalAbonos5,
	    isnull(cast((TotalCargos5/@Division) as decimal (18,4)),0) as TotalCargos5,
	   CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos6-TotalAbonos6)/@Division),0)/Nullif(isnull(((TotalCargos5-TotalAbonos5)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos6-TotalCargos6)/@Division),0)/Nullif(isnull(((TotalAbonos5-TotalCargos5)/@Division),0),0))*100,0) End as Porcentaje5,  
	    isnull(cast((TotalAbonos6/@Division) as decimal (18,4)),0) as TotalAbonos6,
	    isnull(cast((TotalCargos6/@Division) as decimal (18,4)),0) as TotalCargos6,
	   CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos7-TotalAbonos7)/@Division),0)/Nullif(isnull(((TotalCargos6-TotalAbonos6)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos7-TotalCargos7)/@Division),0)/Nullif(isnull(((TotalAbonos6-TotalCargos6)/@Division),0),0))*100,0)  End as Porcentaje6, 
	    isnull(cast((TotalAbonos7/@Division) as decimal (18,4)),0) as TotalAbonos7,
	    isnull(cast((TotalCargos7/@Division) as decimal (18,4)),0) as TotalCargos7,
	   CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos8-TotalAbonos8)/@Division),0)/Nullif(isnull(((TotalCargos7-TotalAbonos7)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos8-TotalCargos8)/@Division),0)/Nullif(isnull(((TotalAbonos7-TotalCargos7)/@Division),0),0))*100,0) End as Porcentaje7,
	    isnull(cast((TotalAbonos8/@Division) as decimal (18,4)),0) as TotalAbonos8,
	    isnull(cast((TotalCargos8/@Division) as decimal (18,4)),0) as TotalCargos8,
	   CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos9-TotalAbonos9)/@Division),0)/Nullif(isnull(((TotalCargos8-TotalAbonos8)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos9-TotalCargos9)/@Division),0)/Nullif(isnull(((TotalAbonos8-TotalCargos8)/@Division),0),0))*100,0) End as Porcentaje8,
	    isnull(cast((TotalAbonos9/@Division) as decimal (18,4)),0) as TotalAbonos9,
	    isnull(cast((TotalCargos9/@Division) as decimal (18,4)),0) as TotalCargos9,
	   CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos10-TotalAbonos10)/@Division),0)/Nullif(isnull(((TotalCargos9-TotalAbonos9)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos10-TotalCargos10)/@Division),0)/Nullif(isnull(((TotalAbonos9-TotalCargos9)/@Division),0),0))*100,0) End as Porcentaje9,
	    isnull(cast((TotalAbonos10/@Division) as decimal (18,4)),0) as TotalAbonos10,
	    isnull(cast((TotalCargos10/@Division) as decimal (18,4)),0) as TotalCargos10,
	   CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos11-TotalAbonos11)/@Division),0)/Nullif(isnull(((TotalCargos10-TotalAbonos10)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos11-TotalCargos11)/@Division),0)/Nullif(isnull(((TotalAbonos10-TotalCargos10)/@Division),0),0))*100,0) End as Porcentaje10,
	    isnull(cast((TotalAbonos11/@Division) as decimal (18,4)),0) as TotalAbonos11,
	    isnull(cast((TotalCargos11/@Division) as decimal (18,4)),0) as TotalCargos11,
	   CASE WHEN MaskNumeroCuenta Like '5%' THEN ISNULL((isnull(((TotalCargos12-TotalAbonos12)/@Division),0)/Nullif(isnull(((TotalCargos11-TotalAbonos11)/@Division),0),0))*100,0) Else
		ISNULL((isnull(((TotalAbonos12-TotalCargos12)/@Division),0)/Nullif(isnull(((TotalAbonos11-TotalCargos11)/@Division),0),0))*100,0) End as Porcentaje11,
	    isnull(cast((TotalAbonos12/@Division) as decimal (18,4)),0) as TotalAbonos12,
	    isnull(cast((TotalCargos12/@Division) as decimal (18,4)),0) as TotalCargos12,
	   (TotalAbonos+TotalCargos+TotalAbonos2+TotalCargos2+TotalAbonos3+TotalCargos3+TotalAbonos4+TotalCargos4+TotalAbonos5+TotalCargos5+TotalAbonos6+TotalCargos6+TotalAbonos7+TotalCargos7+TotalAbonos8+TotalCargos8+TotalAbonos9+TotalCargos9+TotalAbonos10+TotalCargos10+TotalAbonos11+TotalCargos11+TotalAbonos12+TotalCargos12)/@Division as TotalFinal
		,@mes2 as mesFin
		from @Tmp_BalanzaDeComprobacionFinal
	end

Select NumeroCuenta,
	   NombreCuenta,
	   CargosSinFlujo,
	   AbonosSinFlujo,
	   TotalCargos,
	   TotalAbonos,
	   SaldoDeudor,
	   SaldoAcreedor,
	   TipoCuenta,
	   MaskNumeroCuenta,
	   Total,
	   Mes,
	   Year,
	   MaskNombreCuenta,
	   NumeroCuentaAnt,
	   SaldoDeudorAnt,
	   SaldoAcreedorAnt,
	   --MesAnt,
	  -- AñoAnt,
	   Agrupador,
	   Porcentaje1,
	    TotalAbonos2,
		TotalCargos2 ,
	   Porcentaje2,
		TotalAbonos3 ,
		TotalCargos3 ,
	   Porcentaje3,
		TotalAbonos4 ,
		TotalCargos4 ,
	   Porcentaje4,
		TotalAbonos5 ,
		TotalCargos5,
	   Porcentaje5, 
		TotalAbonos6 ,
		TotalCargos6 ,
	   Porcentaje6, 
		TotalAbonos7 ,
		TotalCargos7 ,
	   Porcentaje7,
		TotalAbonos8 ,
		TotalCargos8 ,
	   Porcentaje8,
		TotalAbonos9 ,
		TotalCargos9 ,
	   Porcentaje9,
		TotalAbonos10 ,
		TotalCargos10 ,
	   Porcentaje10,
		TotalAbonos11 ,
		TotalCargos11 ,
	   Porcentaje11,
		TotalAbonos12 ,
		TotalCargos12 ,
		TotalFinal,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN (Select Porcentaje1 from @Final where MaskNumeroCuenta like '5000%') ELSE
		(Select Porcentaje1 from @Final where MaskNumeroCuenta like '4000%') End as PrcGrp1,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN (Select Porcentaje2 from @Final where MaskNumeroCuenta like '5000%') ELSE
		(Select Porcentaje2 from @Final where MaskNumeroCuenta like '4000%') End as PrcGrp2,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN (Select Porcentaje3 from @Final where MaskNumeroCuenta like '5000%') ELSE
		(Select Porcentaje3 from @Final where MaskNumeroCuenta like '4000%') End as PrcGrp3,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN (Select Porcentaje4 from @Final where MaskNumeroCuenta like '5000%') ELSE
		(Select Porcentaje4 from @Final where MaskNumeroCuenta like '4000%') End as PrcGrp4,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN (Select Porcentaje5 from @Final where MaskNumeroCuenta like '5000%') ELSE
		(Select Porcentaje5 from @Final where MaskNumeroCuenta like '4000%') End as PrcGrp5,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN (Select Porcentaje6 from @Final where MaskNumeroCuenta like '5000%') ELSE
		(Select Porcentaje6 from @Final where MaskNumeroCuenta like '4000%') End as PrcGrp6,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN (Select Porcentaje7 from @Final where MaskNumeroCuenta like '5000%') ELSE
		(Select Porcentaje7 from @Final where MaskNumeroCuenta like '4000%') End as PrcGrp7,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN (Select Porcentaje8 from @Final where MaskNumeroCuenta like '5000%') ELSE
		(Select Porcentaje8 from @Final where MaskNumeroCuenta like '4000%') End as PrcGrp8,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN (Select Porcentaje9 from @Final where MaskNumeroCuenta like '5000%') ELSE
		(Select Porcentaje9 from @Final where MaskNumeroCuenta like '4000%') End as PrcGrp9,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN (Select Porcentaje10 from @Final where MaskNumeroCuenta like '5000%') ELSE
		(Select Porcentaje10 from @Final where MaskNumeroCuenta like '4000%') End as PrcGrp10,
		CASE WHEN MaskNumeroCuenta Like '5%' THEN (Select Porcentaje11 from @Final where MaskNumeroCuenta like '5000%') ELSE
		(Select Porcentaje11 from @Final where MaskNumeroCuenta like '4000%') End as PrcGrp11,
	   ISNULL((((Select (TotalCargos2 - TotalAbonos2) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos2 - TotalCargos2) from @Final where MaskNumeroCuenta like '4000%'))/ 
	    Nullif(((Select (TotalCargos - TotalAbonos) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos - TotalCargos) from @Final where MaskNumeroCuenta like '4000%')),0)) * 100,0) as PrcSum1,
		ISNULL((((Select (TotalCargos3 - TotalAbonos3) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos3 - TotalCargos3) from @Final where MaskNumeroCuenta like '4000%'))/ 
	    Nullif(((Select (TotalCargos2 - TotalAbonos2) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos2 - TotalCargos2) from @Final where MaskNumeroCuenta like '4000%')),0))*100,0) as PrcSum2,
		ISNULL((((Select (TotalCargos4 - TotalAbonos4) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos4 - TotalCargos4) from @Final where MaskNumeroCuenta like '4000%'))/ 
	    Nullif(((Select (TotalCargos3 - TotalAbonos3) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos3- TotalCargos3) from @Final where MaskNumeroCuenta like '4000%')),0))*100,0) as PrcSum3,
		ISNULL((((Select (TotalCargos5 - TotalAbonos5) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos5 - TotalCargos5) from @Final where MaskNumeroCuenta like '4000%'))/ 
	    Nullif(((Select (TotalCargos4 - TotalAbonos4) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos4- TotalCargos4) from @Final where MaskNumeroCuenta like '4000%')),0))*100,0) as PrcSum4,
		ISNULL((((Select (TotalCargos6 - TotalAbonos6) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos6 - TotalCargos6) from @Final where MaskNumeroCuenta like '4000%'))/ 
	    Nullif(((Select (TotalCargos5 - TotalAbonos5) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos5- TotalCargos5) from @Final where MaskNumeroCuenta like '4000%')),0))*100,0) as PrcSum5,
		ISNULL((((Select (TotalCargos7 - TotalAbonos7) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos7 - TotalCargos7) from @Final where MaskNumeroCuenta like '4000%'))/ 
	    Nullif(((Select (TotalCargos6 - TotalAbonos6) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos6- TotalCargos6) from @Final where MaskNumeroCuenta like '4000%')),0))*100,0) as PrcSum6,
		ISNULL((((Select (TotalCargos8 - TotalAbonos8) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos8 - TotalCargos8) from @Final where MaskNumeroCuenta like '4000%'))/ 
	    Nullif(((Select (TotalCargos7 - TotalAbonos7) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos7 - TotalCargos7) from @Final where MaskNumeroCuenta like '4000%')),0))*100,0) as PrcSum7,
		ISNULL((((Select (TotalCargos9 - TotalAbonos9) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos9 - TotalCargos9) from @Final where MaskNumeroCuenta like '4000%'))/ 
	    Nullif(((Select (TotalCargos8 - TotalAbonos8) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos8 - TotalCargos8) from @Final where MaskNumeroCuenta like '4000%')),0))*100,0) as PrcSum8,
		ISNULL((((Select (TotalCargos10 - TotalAbonos10) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos10 - TotalCargos10) from @Final where MaskNumeroCuenta like '4000%'))/ 
	    Nullif(((Select (TotalCargos9 - TotalAbonos9) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos9 - TotalCargos9) from @Final where MaskNumeroCuenta like '4000%')),0))*100,0) as PrcSum9,
		ISNULL((((Select (TotalCargos11 - TotalAbonos11) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos11 - TotalCargos11) from @Final where MaskNumeroCuenta like '4000%'))/ 
	    Nullif(((Select (TotalCargos10 - TotalAbonos10) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos10 - TotalCargos10) from @Final where MaskNumeroCuenta like '4000%')),0))*100,0) as PrcSum10,
		ISNULL((((Select (TotalCargos12 - TotalAbonos12) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos12 - TotalCargos12) from @Final where MaskNumeroCuenta like '4000%'))/ 
	    Nullif(((Select (TotalCargos11 - TotalAbonos11) from @Final where MaskNumeroCuenta like '5000%')-(Select (TotalAbonos11 - TotalCargos11) from @Final where MaskNumeroCuenta like '4000%')),0))*100,0) as PrcSum11
		,@mes2 as mesFin
 from @Final
--FIN DE PROCEDIMIENTO

END

GO

Exec SP_FirmasReporte 'Estado de actividades Analítico'
GO
Exec SP_CFG_LogScripts 'REPORTE_Estado_De_ActividadesAnaliticoRedondeoPorcentaje'
GO


--Exec REPORTE_Estado_De_ActividadesAnaliticoRedondeoPorcentaje 1,6,2017,1,1,1