/****** Object:  StoredProcedure [dbo].[SP_RPT_AnaliticoDeLaDeudaPublicaPorPeriodoLDF]    Script Date: 21/07/2015 11:15:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_AnaliticoDeLaDeudaPublicaPorPeriodoLDF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_AnaliticoDeLaDeudaPublicaPorPeriodoLDF]
GO

--Exec SP_RPT_AnaliticoDeLaDeudaPublicaPorPeriodoLDF 1,12,2019,1,0,0,1
CREATE PROCEDURE [dbo].[SP_RPT_AnaliticoDeLaDeudaPublicaPorPeriodoLDF]
@mesInicio smallint,
@mesFin smallint,
@año smallint,
@MuestraVacios bit,
@Miles bit,
@Redondeo bit,
@Tipo int
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

--Variables de montos
Declare @21310AbonoSinFlujo decimal (15,2)
Declare @21410AbonoSinFlujo decimal (15,2)
Declare @21331AbonoSinFlujo decimal (15,2)
Declare @21420AbonoSinFlujo decimal (15,2)
Declare @21332AbonoSinFlujo decimal (15,2)
Declare @22330AbonoSinFlujo decimal (15,2)
Declare @22310AbonoSinFlujo decimal (15,2)
Declare @22351AbonoSinFlujo decimal (15,2)
Declare @22320AbonoSinFlujo decimal (15,2)
Declare @22352AbonoSinFlujo decimal (15,2)
Declare @21900AbonoSinFlujo decimal (15,2)

--
Declare @21310FlujoDelPeriodo decimal (15,2)
Declare @21410FlujoDelPeriodo decimal (15,2)
Declare @21331FlujoDelPeriodo decimal (15,2)
Declare @21420FlujoDelPeriodo decimal (15,2)
Declare @21332FlujoDelPeriodo decimal (15,2)
Declare @22330FlujoDelPeriodo decimal (15,2)
Declare @22310FlujoDelPeriodo decimal (15,2)
Declare @22351FlujoDelPeriodo decimal (15,2)
Declare @22320FlujoDelPeriodo decimal (15,2)
Declare @22352FlujoDelPeriodo decimal (15,2)
Declare @21900FlujoDelPeriodo decimal (15,2)

--Creacion de tabla temporal
--DECLARE @tabla AS TABLE(NumeroCuenta varchar(30),
--	NombreCuenta varchar(255),
--	AbonosSinFlujo decimal(15,2),
--	FlujoDelperiodo decimal(15,2),
--	mes smallint,
--	year smallint,
--	DeudaPublica varchar(50), 
--	Plazo varchar(50), 
--	ordenamiento int, 
--	ordenamiento2 int)
	
--Creacion de tabla de titulos
DECLARE @tablaTitulos AS TABLE(NumeroCuenta varchar(30),
	NombreCuenta varchar(255),
	Saldo decimal(18,2),
	Disposiciones decimal (18,2),
	Amortizaciones decimal (18,2),
	Revaluaciones decimal (18,2),
	PagoDeIntereses decimal (18,2),
	PagoDeComisiones decimal (18,2),
	SaldoFinal decimal (18,2),
	mes smallint,
	year smallint,
	DeudaPublica varchar(50), 
	Plazo varchar(50), 
	ordenamiento int, 
	ordenamiento2 float)

Declare @tabla as table (
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo Decimal (18,2), 
AbonosSinFlujo Decimal(18,2),
TotalCargos Decimal(18,2),
TotalAbonos Decimal(18,2),
SaldoDeudor  Decimal(18,2),
SaldoAcreedor  Decimal(18,2),
Afectable int,
Financiero int
)

Declare @tablaAnterior as table (
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo Decimal (18,2), 
AbonosSinFlujo Decimal(18,2),
TotalCargos Decimal(18,2),
TotalAbonos Decimal(18,2),
SaldoDeudor  Decimal(18,2),
SaldoAcreedor  Decimal(18,2),
Afectable int,
Financiero int
)

Insert into @tabla 
Select NumeroCuenta, NombreCuenta, SUM(CargosSinFlujo) as CargosSinFlujo, SUM(AbonosSinFlujo) as AbonosSinFlujo, SUM(TotalCargos) as TotalCargos, SUM(TotalAbonos) as TotalAbonos,
					Case C_Contable.TipoCuenta 
						When 'A' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						When 'C' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						When 'E' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						When 'G' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						When 'I' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						Else 0
					End as SaldoDeudor,
					Case C_Contable.TipoCuenta 
						When 'A' Then 0
						When 'C' Then 0
						When 'E' Then 0
						When 'G' Then 0
						When 'I' Then 0
						Else SUM(AbonosSinFlujo) - SUM(CargosSinFlujo) + SUM(TotalAbonos) - SUM(TotalCargos) 
					End as SaldoAcreedor, Afectable,C_Contable.Financiero 
	From C_Contable, T_SaldosInicialesCont 
	Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
    And Mes Between @mesInicio and @mesFin  And [Year] = @año And TipoCuenta <> 'X' 
	GROUP BY NumeroCuenta,NombreCuenta, TipoCuenta, Afectable, Financiero 
	Order By NumeroCuenta

Insert into @tablaAnterior 
Select NumeroCuenta, NombreCuenta, SUM(CargosSinFlujo) as CargosSinFlujo, SUM(AbonosSinFlujo) as AbonosSinFlujo, SUM(TotalCargos) as TotalCargos, SUM(TotalAbonos) as TotalAbonos,
					Case C_Contable.TipoCuenta 
						When 'A' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						When 'C' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						When 'E' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						When 'G' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						When 'I' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						Else 0
					End as SaldoDeudor,
					Case C_Contable.TipoCuenta 
						When 'A' Then 0
						When 'C' Then 0
						When 'E' Then 0
						When 'G' Then 0
						When 'I' Then 0
						Else SUM(AbonosSinFlujo) - SUM(CargosSinFlujo) + SUM(TotalAbonos) - SUM(TotalCargos) 
					End as SaldoAcreedor, Afectable,C_Contable.Financiero 
	From C_Contable, T_SaldosInicialesCont 
	Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
    And Mes = 12  And [Year] = (@año -1) And TipoCuenta <> 'X' 
	GROUP BY NumeroCuenta,NombreCuenta, TipoCuenta, Afectable, Financiero 
	Order By NumeroCuenta

 --Se calculan los montos y se guardan en variables 

--Se llena la tabla de titulos sin valores
INSERT INTO @tablaTitulos  Values('','1.-DEUDA PÚBLICA',Null,Null,Null,Null,Null,Null,Null,@mesInicio, @año,'','',1,1)
INSERT INTO @tablaTitulos  Values('','   A.-Corto Plazo',Null,Null,Null,Null,Null,Null,Null,@mesInicio, @año,'','',1,2)
INSERT INTO @tablaTitulos  Values('21310'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'        a1) Instituciones de Crédito',Null,Null,Null,Null,Null,Null,Null,@mesInicio, @año,'','',0,2.1)
INSERT INTO @tablaTitulos  Values('21400'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'        a2) Títulos y Valores',Null,Null,Null,Null,Null,Null,Null,@mesInicio, @año,'','',0,2.2)
INSERT INTO @tablaTitulos  Values('21330'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'        a3) Arrendamientos Financieros',Null,Null,Null,Null,Null,Null,Null,@mesInicio, @año,'','',0,2.3)
INSERT INTO @tablaTitulos  Values('','    B.-Largo Plazo',Null,Null,Null,Null,Null,Null,Null,@mesInicio, @año,'','',1,15)
INSERT INTO @tablaTitulos  Values('22330'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'       b1)Instituciones de Crédito',0,0,0,0,0,0,0,@mesInicio, @año,'','',0,15.1)
INSERT INTO @tablaTitulos  Values('22300'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'       b2)Títulos y Valores',0,0,0,0,0,0,0,@mesInicio, @año,'','',0,15.2)
INSERT INTO @tablaTitulos  Values('22350'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'       b3)Arrendamientos Financieros',0,0,0,0,0,0,0,@mesInicio, @año,'','',0,15.3)
INSERT INTO @tablaTitulos  Values(Null,Null,Null,Null,Null,Null,Null,Null,Null,Null, Null,Null,Null,Null,15.3)
INSERT INTO @tablaTitulos  Values('','2.-Otros Pasivos',Null,Null,Null,Null,Null,Null,Null,@mesInicio, @año,'','',1,16)

INSERT INTO @tablaTitulos  Values('','3. Total de la Deuda Pública y Otros Pasivos',Null,Null,Null,Null,Null,Null,Null,@mesInicio, @año,'','',1,17)
INSERT INTO @tablaTitulos  Values(Null,Null,Null,Null,Null,Null,Null,Null,Null,Null, Null,Null,Null,Null,17)
INSERT INTO @tablaTitulos  Values('','4.-Deuda Contingente 1 (informativo)',Null,Null,Null,Null,Null,Null,Null,@mesInicio, @año,'','',1,21)
INSERT INTO @tablaTitulos  Values('','  A. Deuda Contingente 1',0,0,0,0,0,0,0,@mesInicio, @año,'','',0,22)
INSERT INTO @tablaTitulos  Values('','  B. Deuda Contingente 2',0,0,0,0,0,0,0,@mesInicio, @año,'','',0,23)
INSERT INTO @tablaTitulos  Values('','  C. Deuda Contingente 3',0,0,0,0,0,0,0,@mesInicio, @año,'','',0,24)

INSERT INTO @tablaTitulos  Values('','5.-Valor de Instrumentos Bono Cupón Cero 2 (Informativo)',Null,Null,Null,Null,Null,Null,Null,@mesInicio, @año,'','',1,26)
INSERT INTO @tablaTitulos  Values('','  A. Instrumento Bono Cupón Cero 1',0,0,0,0,0,0,0,@mesInicio, @año,'','',0,28)
INSERT INTO @tablaTitulos  Values('','  B. Instrumento Bono Cupón Cero 2',0,0,0,0,0,0,0,@mesInicio, @año,'','',0,29)
INSERT INTO @tablaTitulos  Values('','  C. Instrumento Bono Cupón Cero 3',0,0,0,0,0,0,0,@mesInicio, @año,'','',0,30)
--INSERT INTO @tablaTitulos  Values('','Total Deuda y Otros Pasivos',Null,Null,@mesInicio, @año,'','',1,31)

update @tablaTitulos 
set a.Saldo=isnull(b.SaldoAcreedor,0)/@Division, a.Disposiciones=isnull(b.TotalAbonos,0)/@Division, a.Amortizaciones=isnull(b.TotalCargos,0)/@Division  
from @tablaTitulos a
join @tabla b
 on a.numerocuenta=b.numerocuenta

update @tablaTitulos 
set a.Saldo=isnull(b.SaldoAcreedor,0)/@Division
from @tablaTitulos a
join @tablaAnterior b
 on a.numerocuenta=b.numerocuenta


 Update @tablaTitulos set --Amortizaciones = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,3) In ('911'))),0),
						 PagoDeIntereses = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,5) In ('92101'))),0),
				       PagoDeComisiones  = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,5) In ('93101'))),0)
				     Where ordenamiento2 = 2.1

Update @tablaTitulos set --Amortizaciones = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,3) In ('912'))),0),
				        PagoDeIntereses = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,3) In ('922'))),0),
				      PagoDeComisiones  = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,3) In ('933'))),0)
				    Where ordenamiento2 = 2.2

Update @tablaTitulos set --Amortizaciones = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,3) In ('913'))),0),
				        PagoDeIntereses = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,3) In ('923'))),0),
				      PagoDeComisiones  = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,3) In ('934'))),0)
				    Where ordenamiento2 = 2.3

Update @tablaTitulos set --Amortizaciones = ISNULL((Select SUM(TotalCargos) from @tabla Where numerocuenta = '22330'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura),0),
				        PagoDeIntereses = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,5) In ('92102'))),0),
				      PagoDeComisiones  = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,5) In ('93102'))),0)
				    Where ordenamiento2 = 15.1

Update @tablaTitulos set --Amortizaciones = ISNULL((Select SUM(TotalCargos) from @tabla Where numerocuenta = '22300'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura),0),
				        PagoDeIntereses = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,3) In ('927'))),0),
				      PagoDeComisiones  = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,5) In ('93103'))),0)
				    Where ordenamiento2 = 15.2

Update @tablaTitulos set --Amortizaciones = ISNULL((Select SUM(TotalCargos) from @tabla Where numerocuenta = '22350'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura),0),
				        PagoDeIntereses = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,3) In ('928'))),0),
				      PagoDeComisiones  = ISNULL((Select SUM(TotalCargos) from @tabla Where SUBSTRING(numerocuenta ,1,4) In ('8270') And(SUBSTRING(numerocuenta ,CHARINDEX('-', numerocuenta) + 1 ,5) In ('93104'))),0)
				    Where ordenamiento2 = 15.3


Update @tablaTitulos set Saldo = ISNULL((Select SUM(SaldoAcreedor) from @tablaAnterior Where numerocuenta = '21100'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura),0) + ISNULL((Select SUM(SaldoAcreedor) from @tablaAnterior Where numerocuenta = '21200'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura),0),
				 Disposiciones = ISNULL((Select SUM(TotalAbonos) from @tabla Where numerocuenta = '21100'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura),0) + ISNULL((Select SUM(TotalAbonos) from @tabla Where numerocuenta = '21200'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura),0),  
				Amortizaciones = ISNULL((Select SUM(TotalCargos) from @tabla Where numerocuenta = '21100'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura),0) + ISNULL((Select SUM(TotalCargos) from @tabla Where numerocuenta = '21200'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura),0)
		   Where ordenamiento2 = 16

update @tablaTitulos set SaldoFinal = null
--update @tablaTitulos 
--set a.Amortizaciones=isnull(b.TotalCargos,0)/@Division, a.Revaluaciones=isnull(b.TotalAbonos,0)/@Division,
--a.PagoDeIntereses = isnull(b.SaldoDeudor,0)/@Division, a.PagoDeComisiones = isnull(b.TotalAbonos,0)/@Division
--from @tablaTitulos a
--join @tabla b
-- on a.numerocuenta=b.numerocuenta
-- Where SUBSTRING(a.numerocuenta ,1,4) In ('8270') And
--(SUBSTRING(a.numerocuenta ,CHARINDEX('-', a.numerocuenta) + 1 ,2) In ('911'))
--and a.ordenamiento2 = 2.1


 ----
 --Se suman las cantidades de la cuenta 22 y 23, se le resta las cantidades actuales del reporte, y el resultado se suma a la cuenta 21900
 Declare @AbonosSinFlujo decimal(15,2)
 select @AbonosSinFlujo = SUM(Isnull(AbonosSinFlujo,0)) From @tabla Where numerocuenta in  ('22000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'21000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)
 
  Declare @RESTAAbonosSinFlujo decimal(15,2)
  select @RESTAAbonosSinFlujo = SUM(Isnull(AbonosSinFlujo,0)) From @tabla Where numerocuenta not in  ('22000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'21000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)
 
 set @AbonosSinFlujo=@AbonosSinFlujo-@RESTAAbonosSinFlujo
--

-- 
  Update @tablaTitulos set SaldoFinal=(Isnull(Saldo,0)+Isnull(Disposiciones,0)-Isnull(Amortizaciones,0)+Isnull(Revaluaciones,0)) 
--Consulta final CON VACIOS
If @Tipo = 1
BEGIN
		 if @MuestraVacios=1  
		 begin
			if @Redondeo =1 
				begin
					select  
					NombreCuenta,
					Round(Saldo,0) as Saldo,
					Round(Disposiciones,0) as Disposiciones,
					Round(Amortizaciones,0) as Amortizaciones,
					Round(Revaluaciones,0) as Revaluaciones,
					Round(SaldoFinal,0) as SaldoFinal,
					Round(PagoDeIntereses,0) as PagoDeIntereses,
					Round(PagoDeComisiones,0) as PagoDeComisiones,
					mes,
					year,
					Round(DeudaPublica,0) as DeudaPublica, 
					Plazo, 
					ordenamiento, 
					ordenamiento2
					from @tablaTitulos order by  ordenamiento2 
				end
			else 
				begin
					select * from @tablaTitulos order by  ordenamiento2  
				end
		 end
 
		 --Consulta final SIN VACIOS
		 else  begin
			if @Redondeo=1 
					begin
							Select  
							NombreCuenta,
							Round(Saldo,0) as Saldo,
							Round(Disposiciones,0) as Disposiciones,
							Round(Amortizaciones,0) as Amortizaciones,
							Round(Revaluaciones,0) as Revaluaciones,
							Round(SaldoFinal,0) as SaldoFinal,
							Round(PagoDeIntereses,0) as PagoDeIntereses,
							Round(PagoDeComisiones,0) as PagoDeComisiones,
							mes,
							year,
							Round(DeudaPublica,0) as DeudaPublica, 
							Plazo, 
							ordenamiento, 
							ordenamiento2
							from @tablaTitulos order by ordenamiento2--where (Saldo <>0 OR Disposiciones <>0 )or Amortizaciones is null or Revaluaciones is null order by ordenamiento2 
					end
 
			else 
				begin
					select * from @tablaTitulos order by ordenamiento2--where (Saldo <>0 OR Disposiciones <>0 )or Amortizaciones is null or Revaluaciones is null order by ordenamiento2 
				end
		end
END
If @Tipo = 2
BEGIN
Delete  from @tablaTitulos
	INSERT INTO @tablaTitulos  Values('','6. Obligaciones a Corto Plazo (Informativo)',Null,Null,Null,Null,Null,Null,Null,@mesInicio, @año,'','',1,1)
	INSERT INTO @tablaTitulos  Values('','A. Crédito 1',0,0,0,0,0,0,0,@mesInicio, @año,'','',0,2)
	INSERT INTO @tablaTitulos  Values('','B. Crédito 2',0,0,0,0,0,0,0,@mesInicio, @año,'','',0,3)
	INSERT INTO @tablaTitulos  Values('','C. Crédito 3',0,0,0,0,0,0,0,@mesInicio, @año,'','',0,4)
	INSERT INTO @tablaTitulos  Values('','D. Crédito 4',0,0,0,0,0,0,0,@mesInicio, @año,'','',0,5)
Select * from @TablaTitulos
END
END
GO

EXEC SP_FirmasReporte 'LDF Informe Analítico de la Deuda Pública y Otros Pasivos Por Periodo'
GO

Exec SP_CFG_LogScripts 'SP_RPT_AnaliticoDeLaDeudaPublicaPorPeriodoLDF','2.30.1'
GO