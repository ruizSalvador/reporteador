/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Estado_Situacion_FinancieraRangos]    Script Date: 01/21/2014 16:04:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Estado_Situacion_FinancieraRangos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Estado_Situacion_FinancieraRangos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Estado_Situacion_FinancieraRangos]    Script Date: 01/21/2014 16:04:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--Exec SP_RPT_K2_Estado_Situacion_FinancieraRangos 2020,1,1,0,2020,1
CREATE PROCEDURE [dbo].[SP_RPT_K2_Estado_Situacion_FinancieraRangos]
@Año int,
@Mes int,
@Miles bit,
@MostrarVacios bit,
@AñoAnterior int,
@MesAnterior int

AS
BEGIN--Procedimiento
declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

declare @division int
if @miles=1 begin set @division=1000 end
else begin set @division=1 end

Declare @Balanza as table (
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo decimal (18,4), 
AbonosSinFlujo Decimal(18,4),
TotalCargos Decimal(18,4),
TotalAbonos Decimal(18,4),
SaldoDeudor  Decimal(18,4),
SaldoAcreedor  Decimal(18,4),
Afectable int,
Financiero int,
CuentaNumero bigint)

Insert into @Balanza
Exec SP_RPT_K2_BalanzaAcumulada @Mes, @MesAnterior, @Año,1,0,0,0,0,0,'','',0,0



--CREO TABLA TEMPORAL DE AFECTACION PRESUPUESTO AÑO ANTERIOR



--Tabla de Resultados
DECLARE  @Resultado TABLE(
				NumeroCuenta varchar(max),
				NombreCuenta varchar(max),
				Mes int, 
				Year int, 
				NumeroCuentaAnt varchar(max), 
				MesAnt int,
				AñoAnt int,
				Saldo decimal(15,2),
				SaldoANT decimal(15,2)
				)
				
--Tabla de Titulos 
DECLARE  @Titulos TABLE(
				NumeroCuenta varchar(max),
				NombreCuenta varchar(max),
				Mes int, 
				Year int, 
				NumeroCuentaAnt varchar(max), 
				MesAnt int,
				AñoAnt int,
				Nivel1 varchar(Max),
				Nivel2 varchar(Max),
				cSinFlujo decimal (18,4), 
				aSinFlujo Decimal(18,4),
				SaldoDeudor  Decimal(18,4),
				SaldoAcreedor  Decimal(18,4),
				Orden1 int,
				Orden2 int, 
				Aplicacion decimal(15,2),
				Origen decimal(15,2)				 
				)


--Se llena la tabla de titulos, orden y grupos
INSERT INTO @Titulos  values ('111'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Efectivo y Equivalentes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,0,0,1,1,0,0)
INSERT INTO @Titulos  values ('112'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Derechos a Recibir Efectivo o Equivalentes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,0,0,1,1,0,0)
INSERT INTO @Titulos  values ('113'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Derechos a Recibir Bienes o Servicios' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,0,0,1,1,0,0)
INSERT INTO @Titulos  values ('114'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Inventarios' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,0,0,1,1,0,0)
INSERT INTO @Titulos  values ('115'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Almacenes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,0,0,1,1,0,0)
INSERT INTO @Titulos  values ('116'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Estimación por Pérdida o Deterioro de Activos Circulantes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,0,0,1,1,0,0)
INSERT INTO @Titulos  values ('119'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Otros Activos Circulantes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,0,0,1,1,0,0)

INSERT INTO @Titulos  values ('121'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Inversiones Financieras a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,0,0,1,2,0,0)
INSERT INTO @Titulos  values ('122'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Derechos a Recibir Efectivo o Equivalentes a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,0,0,1,2,0,0)
INSERT INTO @Titulos  values ('123'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Bienes Inmuebles, Infraestructura y Construcciones en Proceso' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,0,0,1,2,0,0)
INSERT INTO @Titulos  values ('124'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Bienes Muebles' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,0,0,1,2,0,0)
INSERT INTO @Titulos  values ('125'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Activos Intangibles' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,0,0,1,2,0,0)
INSERT INTO @Titulos  values ('126'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Depreciación, Deterioro y Amortización Acumulada de Bienes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,0,0,1,2,0,0)
INSERT INTO @Titulos  values ('127'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Activos Diferidos' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,0,0,1,2,0,0)
INSERT INTO @Titulos  values ('128'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Estimación por Pérdida o Deterioro de Activos no Circulantes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,0,0,1,2,0,0)
INSERT INTO @Titulos  values ('129'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Otros Activos no Circulantes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,0,0,1,2,0,0)

INSERT INTO @Titulos  values ('211'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Cuentas por Pagar a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,0,0,2,3,0,0)
INSERT INTO @Titulos  values ('212'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Documentos por Pagar a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,0,0,2,3,0,0)
INSERT INTO @Titulos  values ('213'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Porción a Corto Plazo de la Deuda Pública a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,0,0,2,3,0,0)
INSERT INTO @Titulos  values ('214'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Titulos y Valores a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,0,0,2,3,0,0)
INSERT INTO @Titulos  values ('215'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Pasivos Diferidos a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,0,0,2,3,0,0)
INSERT INTO @Titulos  values ('216'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Fondos y Bienes de Terceros en Garantía y/o Administración a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,0,0,2,3,0,0)
INSERT INTO @Titulos  values ('217'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Provisiones a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,0,0,2,3,0,0)
INSERT INTO @Titulos  values ('219'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Otros Pasivos a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,0,0,2,3,0,0)

INSERT INTO @Titulos  values ('221'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Cuentas por Pagar a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo No Circulante',0,0,0,0,2,4,0,0)
INSERT INTO @Titulos  values ('222'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Documentos por Pagar a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo No Circulante',0,0,0,0,2,4,0,0)
INSERT INTO @Titulos  values ('223'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Deuda Pública a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo No Circulante',0,0,0,0,2,4,0,0)
INSERT INTO @Titulos  values ('224'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Pasivos Diferidos a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo No Circulante',0,0,0,0,2,4,0,0)
INSERT INTO @Titulos  values ('225'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Fondos y Bienes de Terceros en Garantía y/o Administración a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo No Circulante',0,0,0,0,2,4,0,0)
INSERT INTO @Titulos  values ('226'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Provisiones a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo No Circulante',0,0,0,0,2,4,0,0)

INSERT INTO @Titulos  values ('311'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Aportaciones' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Contribuido',0,0,0,0,3,5,0,0)
INSERT INTO @Titulos  values ('312'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Donaciones de Capital' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Contribuido',0,0,0,0,3,5,0,0)
INSERT INTO @Titulos  values ('313'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Actualización de la Hacienda Pública/Patrimonio' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Contribuido',0,0,0,0,3,5,0,0)

INSERT INTO @Titulos  values ('321'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Resultados del Ejercicio (Ahorro/Desahorro)' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,0,0,3,6,0,0)
INSERT INTO @Titulos  values ('322'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Resultados de Ejercicios Anteriores' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,0,0,3,6,0,0)
INSERT INTO @Titulos  values ('323'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Revalúos' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,0,0,3,6,0,0)
INSERT INTO @Titulos  values ('324'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Reservas' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,0,0,3,6,0,0)
INSERT INTO @Titulos  values ('325'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Rectificaciones de Resultados de Ejercicios Anteriores' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,0,0,3,6,0,0)

INSERT INTO @Titulos  values ('331'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Resultado por Posición Monetaria' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Exceso o Insuficiencia en la Actualización de la Hacienda Pública/Patrimonio',0,0,0,0,3,7,0,0)
INSERT INTO @Titulos  values ('332'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Resultado por Tenencia de Activos no Monetarios' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Exceso o Insuficiencia en la Actualización de la Hacienda Pública/Patrimonio',0,0,0,0,3,7,0,0)

--cSinFlujo decimal (18,4), 
--				aSinFlujo Decimal(18,4),
--				SaldoDeudor  Decimal(18,4),
--				SaldoAcreedor  Decimal(18,4),
update @Titulos 
set a.cSinFlujo=isnull(b.CargosSinFlujo,0), a.aSinFlujo=isnull(b.AbonosSinFlujo,0), a.SaldoDeudor=b.SaldoDeudor , a.SaldoAcreedor=b.SaldoAcreedor 
from @titulos a
join @Balanza b
 on a.numerocuenta=b.numerocuenta

--update @Titulos set Saldo= Saldo+isnull(@4000_5000,0) where NumeroCuenta='321'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura 
--update @Titulos set SaldoANT = SaldoANT+isnull(@4000_5000Ant,0) where NumeroCuenta='321'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura 
--Select * from @Titulos

Declare @SFinal as decimal(18,2)
Declare @sInicial as decimal(18,2)

	  update @Titulos set Origen = -IIF((SaldoDeudor-SaldoAcreedor)-(cSinFlujo-aSinFlujo)>0,0,(SaldoDeudor-SaldoAcreedor)-(cSinFlujo-aSinFlujo)) Where Nivel1='ACTIVO'
      update @Titulos set Aplicacion = IIF((SaldoDeudor-SaldoAcreedor)-(cSinFlujo-aSinFlujo)<0,0,(SaldoDeudor-SaldoAcreedor)-(cSinFlujo-aSinFlujo)) Where Nivel1='ACTIVO'  
	  
	  update @Titulos set Origen = IIF((SaldoAcreedor-SaldoDeudor)-(aSinFlujo-cSinFlujo)<0,0,(SaldoAcreedor-SaldoDeudor)-(aSinFlujo-cSinFlujo)) Where Nivel1='PASIVO'
	  update @Titulos set Aplicacion = -IIF((SaldoAcreedor-SaldoDeudor)-(aSinFlujo-cSinFlujo)>0,0,(SaldoAcreedor-SaldoDeudor)-(aSinFlujo-cSinFlujo)) Where Nivel1='PASIVO' 

	  update @Titulos set Origen = IIF((SaldoAcreedor-SaldoDeudor)-(aSinFlujo-cSinFlujo)<0,0,(SaldoAcreedor-SaldoDeudor)-(aSinFlujo-cSinFlujo)) Where Nivel1='HACIENDA PÚBLICA/PATRIMONIO'
	  update @Titulos set Aplicacion = -IIF((SaldoAcreedor-SaldoDeudor)-(aSinFlujo-cSinFlujo)>0,0,(SaldoAcreedor-SaldoDeudor)-(aSinFlujo-cSinFlujo)) Where Nivel1='HACIENDA PÚBLICA/PATRIMONIO' 

	
	 Set @sFinal = (Select SUM(SaldoAcreedor-SaldoDeudor) from @Balanza Where NumeroCuenta like '4%' and Afectable = 1 ) - (Select SUM(SaldoDeudor-SaldoAcreedor) from @Balanza Where NumeroCuenta like '5%' and Afectable = 1)	
	 Set @sInicial = (Select SUM(AbonosSinFlujo-CargosSinFlujo) from @Balanza Where NumeroCuenta like '4%' and Afectable = 1) - (Select SUM(CargosSinFlujo-AbonosSinFlujo) from @Balanza Where NumeroCuenta like '5%' and Afectable = 1)
	
	  update @Titulos set Origen = IIF(@sFinal-@sInicial<0,0,@sFinal-@sInicial) Where NumeroCuenta ='321'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura
	  update @Titulos set Aplicacion = -IIF(@sFinal-@sInicial>0,0,@sFinal-@sInicial) Where NumeroCuenta ='321'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura 
 
    

if @MostrarVacios=1 Begin
--Seleccion Final
	select 
	NumeroCuenta ,
	NombreCuenta ,
	Mes , 
	Year , 
	NumeroCuentaAnt , 
	MesAnt ,
	AñoAnt ,
	Upper(Nivel1) as Nivel1,
	Nivel2 ,
	ABS(isnull(SaldoDeudor,0)/@division) as Saldo ,
	ABS(isnull(SaldoAcreedor,0)/@division) as SaldoAnt ,
	Orden1 ,
	Orden2,  
	ISNULL(Aplicacion,0)/@division as Aplicacion,
	ISNULL(Origen,0)/@division  as Origen  
	
	from @titulos
	End
Else Begin
	Select 
	NumeroCuenta ,
	NombreCuenta ,
	Mes , 
	Year , 
	NumeroCuentaAnt , 
	MesAnt ,
	AñoAnt ,
	Upper(Nivel1) as Nivel1 ,
	Nivel2 ,
	ABS(isnull(SaldoDeudor,0)/@division) as Saldo ,
	ABS(isnull(SaldoAcreedor,0)/@division) as SaldoAnt ,
	Orden1 ,
	Orden2,  
	ISNULL(Aplicacion,0)/@division as Aplicacion,
	ISNULL(Origen,0)/@division as Origen 
	
	from @titulos
	Where (Origen + Aplicacion) <> 0
	
	End

END --procedimiento

GO

EXEC SP_FirmasReporte 'Estado de Cambios en la Situación Financiera por Periodos'
GO

--exec SP_RPT_K2_Estado_Situacion_FinancieraRangos @Año=2017,@Mes=7,@Miles=0,@MostrarVacios=1,@AñoAnterior=2017,@MesAnterior=1
--exec SP_RPT_K2_Estado_Situacion_FinancieraRangos @Año=2017,@Mes=7,@Miles=0,@MostrarVacios=1,@AñoAnterior=2017,@MesAnterior=2

Exec SP_CFG_LogScripts 'SP_RPT_K2_Estado_Situacion_FinancieraRangos','2.30'
GO