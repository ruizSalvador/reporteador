/****** Object:  StoredProcedure [dbo].[RPT_SP_K2_Balanza_Comprobacion_ASEJ]    Script Date: 04/11/2013 16:31:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_K2_Balanza_Comprobacion_ASEJ]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_K2_Balanza_Comprobacion_ASEJ]
GO

/****** Object:  StoredProcedure [dbo].[RPT_SP_K2_Balanza_Comprobacion_ASEJ]    Script Date: 04/11/2013 16:31:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--EXEC RPT_SP_K2_Balanza_Comprobacion_ASEJ 2020,12,0,0,0,0,0,0,0,0
CREATE PROCEDURE [dbo].[RPT_SP_K2_Balanza_Comprobacion_ASEJ]
@Ejercicio int,
@Mes int,
@SaldoMayor0 bit,
@ConMovimientos bit,
@MovimientoySaldoNOcero bit,
@MovimientoOSaldoNOcero bit,
@CuentasDeMayor bit,
@CuentasDeOrden bit,
@CuentaInicio float,
@CuentaFin float

AS
BEGIN
SET NOCOUNT ON

Create Table #Balanza (
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo decimal (18,4), 
AbonosSinFlujo Decimal(18,4),
TotalCargos Decimal(18,4),
TotalAbonos Decimal(18,4),
SaldoDeudor  Decimal(18,4),
SaldoAcreedor  Decimal(18,4),
Mes int,
[Year] int,
TipoCuenta varchar(10),
Afectable int,
Financiero int,
CuentaNumero float,
Orden int,
Negritas int)

Create Table #BalanzaAcu (
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

--Declare @Extras as table (
--Fecha datetime,
--NumeroCuenta varchar(100), 
--NombreCuenta varchar(MAX),
--ImporteCargo decimal (18,4),
--ImporteAbono decimal (28,4), 
--SaldoFila Decimal(18,4),
--CuentaAcumulacion varchar(100),
--SaldoInicial Decimal(18,4),
--Mes int,
--[Year] int,
--iNumeroCuenta bigint,
--sello varchar(100),
--IdSelloPresupuestal int,
--ClavePartida int,
--ClaveFF int,
--TipoCuenta varchar(10)
--)

 Update C_BalanzaASEJ set 
   CargosSinFlujo = 0,
   AbonosSinFlujo = 0,
TotalCargos = 0,
TotalAbonos = 0,
SaldoDeudor = 0,
SaldoAcreedor = 0


declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

DECLARE @sql nvarchar(max)


Insert Into #BalanzaAcu
Exec SP_RPT_K2_BalanzaAcumulada 1,@Mes,@Ejercicio,@SaldoMayor0,@ConMovimientos,@CuentasDeMayor,@CuentasDeOrden,@MovimientoySaldoNOcero,@MovimientoOSaldoNOcero,'','',0,0
--SELECT SUBSTRING(NumeroCuenta,0,6),NombreCuenta,CargosSinFlujo,AbonosSinFlujo,TotalCargos,TotalAbonos,SaldoDeudor,SaldoAcreedor,Mes,[Year],TipoCuenta,Afectable,Financiero,CAST(SUBSTRING(NumeroCuenta,0,6) as float),1,0 FROM VW_RPT_K2_Balanza_De_Comprobacion 
--     Where NumeroCuenta like '____'+Replicate('0', @Estructura1 + -4)+'-'+ @CerosEstructura AND NumeroCuenta not like '8%' AND NumeroCuenta not like '4%' AND NumeroCuenta not like '5%'
--AND Mes = @Mes AND [Year] = @Ejercicio

--Delete from @BalanzaAcu Where NumeroCuenta not like '____'+Replicate('0', @Estructura1 + -4)+'-'+ @CerosEstructura OR NumeroCuenta  like '8%' OR NumeroCuenta like '4%' OR NumeroCuenta like '5%'
 
Insert into #Balanza
SELECT SUBSTRING(NumeroCuenta,0,6),NombreCuenta,CargosSinFlujo,AbonosSinFlujo,TotalCargos,TotalAbonos,SaldoDeudor,SaldoAcreedor,@Mes,@Ejercicio,'Z',Afectable,Financiero,CAST(SUBSTRING(NumeroCuenta,0,6) as float),1,0 FROM #BalanzaAcu
Where NumeroCuenta like '____'+Replicate('0', @Estructura1 + -4)+'-'+ @CerosEstructura AND NumeroCuenta not like '8%' AND NumeroCuenta not like '4%' AND NumeroCuenta not like '5%'

--Select * from #Balanza
 Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41110-11110','41110-11115','41110-11120','41110-11130','41110-11150','41110-11160') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41110-11110','41110-11115','41110-11120','41110-11130','41110-11150','41110-11160') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41110-11110','41110-11115','41110-11120','41110-11130','41110-11150','41110-11160') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41110-11110','41110-11115','41110-11120','41110-11130','41110-11150','41110-11160') ),
  SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41110-11110','41110-11115','41110-11120','41110-11130','41110-11150','41110-11160') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41110-11110','41110-11115','41110-11120','41110-11130','41110-11150','41110-11160') )
 Where IdCuenta = 198

  Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12110','41120-12120') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12110','41120-12120') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12110','41120-12120') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12110','41120-12120') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12110','41120-12120') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12110','41120-12120') )
 Where IdCuenta = 200

  Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12210','41120-12220') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12210','41120-12220') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12210','41120-12220') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12210','41120-12220') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12210','41120-12220') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12210','41120-12220') )
 Where IdCuenta = 201

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12310','41120-12320','41120-12330') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12310','41120-12320','41120-12330') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12310','41120-12320','41120-12330') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12310','41120-12320','41120-12330') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12310','41120-12320','41120-12330') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41120-12310','41120-12320','41120-12330') )
 Where IdCuenta = 202

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17200','41170-17210') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17200','41170-17210') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17200','41170-17210') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17200','41170-17210') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17200','41170-17210') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17200','41170-17210') )
 Where IdCuenta = 210

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17410') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17410') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17410') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17410') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17410') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17410') )
 Where IdCuenta = 211

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17490') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17490') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17490') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17490') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17490') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17490'))
 Where IdCuenta = 212

       Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41180-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41180-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41180-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41180-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41180-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41180-00000') )
 Where IdCuenta = 214

        Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41190-18110') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41190-18110') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41190-18110') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41190-18110') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41190-18110') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41190-18110') )
 Where IdCuenta = 216

         Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41310-31101')),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41310-31101') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41310-31101')),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41310-31101') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41310-31101') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41310-31101') )
 Where IdCuenta = 225

 Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41110','41410-41120','41410-41130') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41110','41410-41120','41410-41130') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41110','41410-41120','41410-41130') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41110','41410-41120','41410-41130') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41110','41410-41120','41410-41130') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41110','41410-41120','41410-41130') )
 Where IdCuenta = 230

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41320','41410-41330') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41320','41410-41330') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41320','41410-41330') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41320','41410-41330') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41320','41410-41330') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41320','41410-41330') )
 Where IdCuenta = 232

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41410') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41410') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41410') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41410') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41410') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41410-41410') )
 Where IdCuenta = 233

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43010','41430-43011','41430-43012','41430-43013') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43010','41430-43011','41430-43012','41430-43013') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43010','41430-43011','41430-43012','41430-43013') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43010','41430-43011','41430-43012','41430-43013') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43010','41430-43011','41430-43012','41430-43013') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43010','41430-43011','41430-43012','41430-43013') )
 Where IdCuenta = 236

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43020') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43020') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43020') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43020') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43020') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43020') )
 Where IdCuenta = 237

       Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43030','41430-43031','41430-43032','41430-43033') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43030','41430-43031','41430-43032','41430-43033') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43030','41430-43031','41430-43032','41430-43033') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43030','41430-43031','41430-43032','41430-43033') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43030','41430-43031','41430-43032','41430-43033') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43030','41430-43031','41430-43032','41430-43033') )
 Where IdCuenta = 238

        Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43040','41430-43041') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43040','41430-43041') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43040','41430-43041') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43040','41430-43041') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43040','41430-43041') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43040','41430-43041') )
 Where IdCuenta = 240

         Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43050','41430-43051') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43050','41430-43051') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43050','41430-43051') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43050','41430-43051') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43050','41430-43051') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43050','41430-43051') )
 Where IdCuenta = 241

          Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43061') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43061') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43061') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43061') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43061') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43061') )
 Where IdCuenta = 242

           Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43070','41430-43071','41430-43073') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43070','41430-43071','41430-43073') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43070','41430-43071','41430-43073') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43070','41430-43071','41430-43073') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43070','41430-43071','41430-43073') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43070','41430-43071','41430-43073') )
 Where IdCuenta = 243

            Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43009','41430-43080') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43009','41430-43080') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43009','41430-43080') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43009','41430-43080') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43009','41430-43080') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43009','41430-43080') )
 Where IdCuenta = 244

             Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43110','41430-43122','41430-43123') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43110','41430-43122','41430-43123') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43110','41430-43122','41430-43123') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43110','41430-43122','41430-43123') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43110','41430-43122','41430-43123') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43110','41430-43122','41430-43123') )
 Where IdCuenta = 246

              Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43310','41430-43311','41430-43312') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43310','41430-43311','41430-43312') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43310','41430-43311','41430-43312') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43310','41430-43311','41430-43312') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43310','41430-43311','41430-43312') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43310','41430-43311','41430-43312') )
 Where IdCuenta = 248

               Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43410','41430-43420','41430-43421','41430-43422','41430-43423','41430-43424') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43410','41430-43420','41430-43421','41430-43422','41430-43423','41430-43424') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43410','41430-43420','41430-43421','41430-43422','41430-43423','41430-43424') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43410','41430-43420','41430-43421','41430-43422','41430-43423','41430-43424') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43410','41430-43420','41430-43421','41430-43422','41430-43423','41430-43424') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41430-43410','41430-43420','41430-43421','41430-43422','41430-43423','41430-43424') )
 Where IdCuenta = 249

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-45110') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-45110') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-45110') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-45110') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-45110') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-45110') )
 Where IdCuenta = 251

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-45210') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-45210') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-45210') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-45210') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-45210') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-45210') )
 Where IdCuenta = 253

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41620-61105','41620-61106','41620-61110') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41620-61105','41620-61106','41620-61110') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41620-61105','41620-61106','41620-61110') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41620-61105','41620-61106','41620-61110') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41620-61105','41620-61106','41620-61110') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41620-61105','41620-61106','41620-61110') )
 Where IdCuenta = 272

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41630-61210') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41630-61210') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41630-61210') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41630-61210') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41630-61210') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41630-61210') )
 Where IdCuenta = 274

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41650-61510') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41650-61510') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41650-61510') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41650-61510') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41650-61510') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41650-61510') )
 Where IdCuenta = 276

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41680-63999') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41680-63999') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41680-63999') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41680-63999') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41680-63999') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41680-63999') )
 Where IdCuenta = 287

       Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-61999','41690-63999') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-61999','41690-63999') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-61999','41690-63999') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-61999','41690-63999') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-61999','41690-63999') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-61999','41690-63999') )
 Where IdCuenta = 289

       Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41710-00001') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41710-00001') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41710-00001')),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41710-00001') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41710-00001') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41710-00001') )
 Where IdCuenta = 292


        Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81010') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81010') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81010') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81010') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81010') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81010') )
 Where IdCuenta = 308

        Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81020') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81020') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81020') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81020') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81020') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81020') )
 Where IdCuenta = 309

         Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81030') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81030') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81030') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81030') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81030') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81030') )
 Where IdCuenta = 310

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81040') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81040') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81040') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81040') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81040') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81040') )
 Where IdCuenta = 311

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81060') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81060') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81060') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81060') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81060') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81060') )
 Where IdCuenta = 313

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81090') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81090') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81090') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81090') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81090') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81090') )
 Where IdCuenta = 316

       Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81100') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81100') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81100') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81100') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81100') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81100') )
 Where IdCuenta = 317

       Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81110') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81110') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81110') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81110') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81110') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81110') )
 Where IdCuenta = 318

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81120') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81120') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81120') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81120') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81120') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42110-81120') )
 Where IdCuenta = 319

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42120-82010') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42120-82010') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42120-82010') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42120-82010') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42120-82010') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42120-82010') )
 Where IdCuenta = 321

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42120-82020') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42120-82020') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42120-82020') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42120-82020') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42120-82020') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42120-82020') )
 Where IdCuenta = 322

       Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42130-83040') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42130-83040') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42130-83040') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42130-83040') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42130-83040') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42130-83040') )
 Where IdCuenta = 328

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42130-83043') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42130-83043') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42130-83043') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42130-83043') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42130-83043') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42130-83043') )
 Where IdCuenta = 329

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84010') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84010') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84010') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84010') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84010') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84010') )
 Where IdCuenta = 331

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84020') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84020') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84020') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84020') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84020') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84020') )
 Where IdCuenta = 332

       Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84030') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84030') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84030') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84030') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84030') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42140-84030') )
 Where IdCuenta = 333

        Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42230-00000','42240-94110') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('42230-00000','42240-94110') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42230-00000','42240-94110') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('42230-00000','42240-94110') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42230-00000','42240-94110') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('42230-00000','42240-94110') )
 Where IdCuenta = 345

         Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43110-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43110-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43110-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43110-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43110-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43110-00000') )
 Where IdCuenta = 355

          Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43200-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43200-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43200-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43200-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43200-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43200-00000') )
 Where IdCuenta = 359

           Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43210-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43210-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43210-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43210-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43210-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43210-00000') )
 Where IdCuenta = 360

            Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') )
 Where IdCuenta = 361

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') )
 Where IdCuenta = 361

       Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43230-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43230-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43230-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43230-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43230-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43230-00000') )
 Where IdCuenta = 362

        Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43240-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43240-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43240-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43240-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43240-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43240-00000') )
 Where IdCuenta = 363

         Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') )
 Where IdCuenta = 364

          Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43300-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43300-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43300-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43300-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43300-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43300-00000') )
 Where IdCuenta = 365

          Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43310-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43310-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43310-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43310-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43310-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43310-00000') )
 Where IdCuenta = 366

           Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43400-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43400-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43400-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43400-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43400-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43400-00000') )
 Where IdCuenta = 368

            Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43410-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43410-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43410-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43410-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43410-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43410-00000') )
 Where IdCuenta = 369

             Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43900-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43900-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43900-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43900-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43900-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43900-00000') )
 Where IdCuenta = 371

              Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43910-90309') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43910-90309') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43910-90309') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43910-90309') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43910-90309') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43910-90309') )
 Where IdCuenta = 372

               Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43920-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43920-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43920-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43920-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43920-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43920-00000') )
 Where IdCuenta = 373

                Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43930-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43930-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43930-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43930-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43930-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43930-00000') )
 Where IdCuenta = 375

                 Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43940-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43940-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43940-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43940-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43940-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43940-00000') )
 Where IdCuenta = 377

                 Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43950-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43950-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43950-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43950-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43950-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43950-00000') )
 Where IdCuenta = 379

                  Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43960-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43960-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43960-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43960-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43960-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43960-00000') )
 Where IdCuenta = 381

         Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43970-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43970-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43970-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43970-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43970-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43970-00000') )
 Where IdCuenta = 383

          Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00000') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00000') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00000') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00000') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00000') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00000') )
 Where IdCuenta = 385

           Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00001') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00001') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00001') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00001') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00001') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00001') )
 Where IdCuenta = 386
 -------------------------------------------------------5 mil

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51110-01111') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51110-01111') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51110-01111') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51110-01111') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51110-01111') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51110-01111') )
 Where IdCuenta = 391

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51110-00001','51110-01131') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51110-00001','51110-01131') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51110-00001','51110-01131') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51110-00001','51110-01131') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51110-00001','51110-01131') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51110-00001','51110-01131') )
 Where IdCuenta = 393

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51120-01212') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51120-01212') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51120-01212') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51120-01212') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51120-01212') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51120-01212') )
 Where IdCuenta = 396

       Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01221') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01221') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01221') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01221') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01221') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01221') )
 Where IdCuenta = 397

         Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01321') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01321') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01321') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01321') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01321') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01321') )
 Where IdCuenta = 402

        Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01331') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01331') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01331') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01331') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01331') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51130-01331') )
 Where IdCuenta = 403

        Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01413') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01413') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01413') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01413') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01413') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01413') )
 Where IdCuenta = 410

         Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01431') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01431') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01431') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01431') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01431') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01431') )
 Where IdCuenta = 412

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01441') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01441') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01441') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01441') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01441') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51140-01441') )
 Where IdCuenta = 413

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51150-01522') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51150-01522') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51150-01522') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51150-01522') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51150-01522') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51150-01522') )
 Where IdCuenta = 416

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51150-01591','51150-01592') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51150-01591','51150-01592') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51150-01591','51150-01592') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51150-01591','51150-01592') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51150-01591','51150-01592') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51150-01591','51150-01592') )
 Where IdCuenta = 420

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02111') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02111') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02111') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02111') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02111') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02111') )
 Where IdCuenta = 426

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02121') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02121') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02121') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02121') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02121') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02121') )
 Where IdCuenta = 427

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02131') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02131') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02131') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02131') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02131') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02131') )
 Where IdCuenta = 428

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02141') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02141') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02141') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02141') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02141') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02141') )
 Where IdCuenta = 429

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02151') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02151') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02151') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02151') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02151') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02151') )
 Where IdCuenta = 430

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02161') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02161') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02161') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02161') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02161') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02161') )
 Where IdCuenta = 431

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02181','51210-02182') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02181','51210-02182') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02181','51210-02182') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02181','51210-02182') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02181','51210-02182') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02181','51210-02182') )
 Where IdCuenta = 433

 --     Update C_BalanzaASEJ set
 --CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02181','51210-02182') ),
 --AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02181','51210-02182') ),
 --TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02181','51210-02182') ),
 --TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02181','51210-02182') ),
 --SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02181','51210-02182') ),
 --SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51210-02181','51210-02182') )
 --Where NumeroCuenta = '51210-8'

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02211','51220-02212') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02211','51220-02212') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02211','51220-02212') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02211','51220-02212') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02211','51220-02212') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02211','51220-02212') )
 Where IdCuenta = 435

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02221') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02221') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02221') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02221') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02221') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02221') )
 Where IdCuenta = 436

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02231') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02231') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02231') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02231') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02231') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51220-02231') )
 Where IdCuenta = 437

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51230-02371') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51230-02371') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51230-02371') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51230-02371') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51230-02371') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51230-02371') )
 Where IdCuenta = 445

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02411') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02411') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02411') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02411') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02411') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02411') )
 Where IdCuenta = 449

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02421') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02421') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02421') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02421') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02421') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02421') )
 Where IdCuenta = 450

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02431') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02431') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02431') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02431') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02431') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02431') )
 Where IdCuenta = 451

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02461') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02461') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02461') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02461') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02461') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02461') )
 Where IdCuenta = 454

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02471') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02471') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02471') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02471') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02471') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02471') )
 Where IdCuenta = 455

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02481') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02481') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02481') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02481') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02481') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02481') )
 Where IdCuenta = 456

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02491') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02491') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02491') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02491') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02491') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51240-02491') )
 Where IdCuenta = 457

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02521') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02521') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02521') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02521') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02521') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02521') )
 Where IdCuenta = 460

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02531') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02531') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02531') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02531') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02531') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02531') )
 Where IdCuenta = 461

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02541') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02541') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02541') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02541') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02541') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02541') )
 Where IdCuenta = 462

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02591') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02591') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02591') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02591') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02591') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51250-02591') )
 Where IdCuenta = 465

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51260-02611','51260-02612','51260-02613') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51260-02611','51260-02612','51260-02613') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51260-02611','51260-02612','51260-02613') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51260-02611','51260-02612','51260-02613') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51260-02611','51260-02612','51260-02613') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51260-02611','51260-02612','51260-02613') )
 Where IdCuenta = 467

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02711') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02711') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02711') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02711') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02711') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02711') )
 Where IdCuenta = 470

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02722') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02722') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02722') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02722') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02722') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02722') )
 Where IdCuenta = 471

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02731') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02731') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02731') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02731') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02731') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02731') )
 Where IdCuenta = 472

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02741') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02741') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02741') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02741') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02741') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02741') )
 Where IdCuenta = 473

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02751') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02751') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02751') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02751') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02751') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51270-02751') )
 Where IdCuenta = 474

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02811') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02811') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02811') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02811') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02811') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02811') )
 Where IdCuenta = 476

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02821') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02821') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02821') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02821') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02821') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02821') )
 Where IdCuenta = 477


     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02831') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02831') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02831') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02831') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02831') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51280-02831') )
 Where IdCuenta = 478

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02911') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02911') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02911') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02911') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02911') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02911') )
 Where IdCuenta = 480

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02921') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02921') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02921') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02921') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02921') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02921') )
 Where IdCuenta = 481

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02931','51290-02932') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02931','51290-02932') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02931','51290-02932') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02931','51290-02932') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02931','51290-02932') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02931','51290-02932') )
 Where IdCuenta = 482

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02941') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02941') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02941') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02941') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02941') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02941') )
 Where IdCuenta = 483

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02961') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02961') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02961') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02961') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02961') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02961') )
 Where IdCuenta = 485

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02971') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02971') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02971') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02971') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02971') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02971') )
 Where IdCuenta = 486

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02981') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02981') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02981') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02981') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02981') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02981') )
 Where IdCuenta = 487

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02991') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02991') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02991') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02991') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02991') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51290-02991') )
 Where IdCuenta = 488

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03111','51310-03112') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03111','51310-03112') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03111','51310-03112') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03111','51310-03112') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03111','51310-03112') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03111','51310-03112') )
 Where IdCuenta = 491

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03141') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03141') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03141') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03141') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03141') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03141') )
 Where IdCuenta = 494

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03151') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03151') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03151') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03151') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03151') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03151') )
 Where IdCuenta = 495

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03161') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03161') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03161') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03161') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03161') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03161') )
 Where IdCuenta = 496

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03181') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03181') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03181') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03181') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03181') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51310-03181') )
 Where IdCuenta = 498

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03211') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03211') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03211') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03211') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03211') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03211') )
 Where IdCuenta = 501

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03221') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03221') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03221') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03221') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03221') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03221') )
 Where IdCuenta = 502

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03251') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03251') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03251') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03251') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03251') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03251') )
 Where IdCuenta = 505

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03261') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03261') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03261') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03261') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03261') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03261') )
 Where IdCuenta = 506

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03291') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03291') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03291') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03291') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03291') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51320-03291') )
 Where IdCuenta = 509

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03311') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03311') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03311') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03311') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03311') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03311') )
 Where IdCuenta = 511

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03321') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03321') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03321') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03321') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03321') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03321') )
 Where IdCuenta = 512

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03331') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03331') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03331') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03331') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03331') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03331') )
 Where IdCuenta = 513

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03341') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03341') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03341') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03341') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03341') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03341') )
 Where IdCuenta = 514

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03361') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03361') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03361') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03361') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03361') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03361') )
 Where IdCuenta = 516

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03371') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03371') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03371') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03371') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03371') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03371') )
 Where IdCuenta = 517

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03391') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03391') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03391') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03391') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03391') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51330-03391') )
 Where IdCuenta = 519

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03411') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03411') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03411') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03411') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03411') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03411') )
 Where IdCuenta = 521

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03431') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03431') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03431') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03431') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03431') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03431') )
 Where IdCuenta = 523

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03441') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03441') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03441') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03441') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03441') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03441') )
 Where IdCuenta = 524

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03451') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03451') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03451') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03451') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03451') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03451') )
 Where IdCuenta = 525

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03471') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03471') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03471') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03471') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03471') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03471') )
 Where IdCuenta = 527

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03491') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03491') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03491') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03491') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03491') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51340-03491') )
 Where IdCuenta = 529

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03511') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03511') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03511' ) ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03511') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03511') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03511') )
 Where IdCuenta = 531

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03521') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03521') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03521') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03521') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03521') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03521') )
 Where IdCuenta = 532

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03531') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03531') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03531') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03531') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03531') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03531') )
 Where IdCuenta = 533

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03551') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03551') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03551') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03551') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03551') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03551') )
 Where IdCuenta = 535

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03561') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03561') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03561') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03561') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03561') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03561') )
 Where IdCuenta = 536

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03571') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03571') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03571') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03571') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03571') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03571') )
 Where IdCuenta = 537

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03581') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03581') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03581') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03581') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03581') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03581') )
 Where IdCuenta = 538

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03591') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03591') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03591') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03591') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03591') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51350-03591') )
 Where IdCuenta = 539

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03611') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03611') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03611') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03611') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03611') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03611') )
 Where IdCuenta = 541

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03621') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03621') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03621') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03621') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03621') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03621') )
 Where IdCuenta = 542

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03661') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03661') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03661') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03661') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03661') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51360-03661') )
 Where IdCuenta = 546

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03711') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03711') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03711') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03711') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03711') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03711') )
 Where IdCuenta = 549

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03721') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03721') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03721') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03721') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03721') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03721') )
 Where IdCuenta = 550

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03751') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03751') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03751') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03751') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03751') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03751') )
 Where IdCuenta = 553

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03761') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03761') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03761') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03761') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03761') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03761') )
 Where IdCuenta = 554

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03781') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03781') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03781') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03781') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03781') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51370-03781') )
 Where IdCuenta = 556

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03811') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03811') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03811') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03811') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03811') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03811') )
 Where IdCuenta = 559

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03821','51380-03822','51380-03823','51380-03824','51380-03825') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03821','51380-03822','51380-03823','51380-03824','51380-03825') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03821','51380-03822','51380-03823','51380-03824','51380-03825') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03821','51380-03822','51380-03823','51380-03824','51380-03825') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03821','51380-03822','51380-03823','51380-03824','51380-03825') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03821','51380-03822','51380-03823','51380-03824','51380-03825') )
 Where IdCuenta = 560

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03831') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03831') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03831') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03831') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03831') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03831') )
 Where IdCuenta = 561

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03841','51380-03842','51380-03843') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03841','51380-03842','51380-03843') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03841','51380-03842','51380-03843') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03841','51380-03842','51380-03843') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03841','51380-03842','51380-03843') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51380-03841','51380-03842','51380-03843') )
 Where IdCuenta = 562

    Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03911') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03911') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03911') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03911') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03911') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03911') )
 Where IdCuenta = 565

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03921') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03921') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03921') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03921') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03921') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03921') )
 Where IdCuenta = 566

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03951') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03951') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03951') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03951') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03951') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03951') )
 Where IdCuenta = 569

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03961') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03961') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03961') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03961') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03961') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03961') )
 Where IdCuenta = 570

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03991') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03991') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03991') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03991') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03991') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('51390-03991') )
 Where IdCuenta = 573

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52110-04111') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52110-04111') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52110-04111') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52110-04111') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52110-04111') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52110-04111') )
 Where IdCuenta = 577

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52110-04141') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52110-04141') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52110-04141') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52110-04141') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52110-04141') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52110-04141') )
 Where IdCuenta = 580

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52210-04211') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52210-04211') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52210-04211') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52210-04211') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52210-04211') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52210-04211') )
 Where IdCuenta = 589

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52410-04411') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52410-04411') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52410-04411') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52410-04411') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52410-04411') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52410-04411') )
 Where IdCuenta = 609

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52420-04421') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52420-04421') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52420-04421') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52420-04421') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52420-04421') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52420-04421') )
 Where IdCuenta = 611

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52430-04431') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52430-04431') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52430-04431') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52430-04431') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52430-04431') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52430-04431') )
 Where IdCuenta = 613

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52430-04451') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52430-04451') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52430-04451') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52430-04451') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52430-04451') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52430-04451') )
 Where IdCuenta = 615

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52510-04511') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52510-04511') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52510-04511') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52510-04511') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52510-04511') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52510-04511') )
 Where IdCuenta = 622

      Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52520-04521') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52520-04521') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52520-04521') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52520-04521') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52520-04521') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52520-04521') )
 Where IdCuenta = 624

     Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52620-04641') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52620-04641') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52620-04641') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52620-04641') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52620-04641') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52620-04641') )
 Where IdCuenta = 629

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('54110-09211') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('54110-09211') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('54110-09211') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('54110-09211') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('54110-09211') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('54110-09211') )
 Where IdCuenta = 684

   Update C_BalanzaASEJ set
 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17110') ),
 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17110') ),
 TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17110') ),
 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17110') ),
 SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17110') ),
 SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41170-17110') )
 Where IdCuenta = 208

 --Select * FROM #BalanzaAcu order by NumeroCuenta
--Select * from C_BalanzaASEJ order by NumeroCuenta
--Select * from C_BalanzaASEJ Where NumeroCuenta like '4%' order by NumeroCuenta

--------------------------------------------------------------------------------
CREATE TABLE #Sumatorias (
       RowID int IDENTITY(1, 1), 
      NumeroCuenta varchar(100)
 )
DECLARE @NumberRecords int
Declare @RowCounter int
DECLARE @NumeroCuenta varchar(100)

INSERT INTO #Sumatorias
SELECT NumeroCuenta FROM C_BalanzaASEJ 
     Where NumeroCuenta like '____'+Replicate('0', @Estructura1 -4)
	 AND (NumeroCuenta like '4%' AND SUBSTRING(NumeroCuenta,4,1) <> '0')

SET @NumberRecords = @@RowCount 
SET @RowCounter = 1

WHILE @RowCounter <= @NumberRecords
BEGIN
 SELECT @NumeroCuenta = NumeroCuenta 
 FROM #Sumatorias
 WHERE RowID = @RowCounter

						--Select @NumeroCuenta
						--Select NumeroCuenta,CargosSinFlujo from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta + '-%'
					Update C_BalanzaASEJ set 
				    CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta + '-%'),
				    AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta + '-%'),
			        TotalCargos = (Select ISNULL(SUM(TotalCargos),0) from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta + '-%'),
					TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta + '-%'),
					SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta + '-%'),
					SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta + '-%')
					Where NumeroCuenta = @NumeroCuenta
									

 SET @RowCounter = @RowCounter + 1
END

TRUNCATE TABLE #Sumatorias
--------------------------------------------------------------------------------
--Select * from C_BalanzaASEJ
--------------------------------------------------------------------------------2

Set @NumberRecords = 0
Set @RowCounter = 0
Set @NumeroCuenta = ''

INSERT INTO #Sumatorias
SELECT NumeroCuenta FROM C_BalanzaASEJ 
     Where NumeroCuenta like '____'+Replicate('0', @Estructura1 -4)
	 AND (NumeroCuenta like '4%' AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0')

SET @NumberRecords = @@RowCount 
SET @RowCounter = 1

WHILE @RowCounter <= @NumberRecords
BEGIN
 SELECT @NumeroCuenta = NumeroCuenta 
 FROM #Sumatorias
 WHERE RowID = @RowCounter

        --Select @NumeroCuenta
		--Select * from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0'
					   Update C_BalanzaASEJ set 
					   CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0' AND LEN(NumeroCuenta)=5),
						AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0' AND LEN(NumeroCuenta)=5),
						TotalCargos = (Select ISNULL(SUM(TotalCargos),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0' AND LEN(NumeroCuenta)=5),
					   TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0' AND LEN(NumeroCuenta)=5),
						SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0' AND LEN(NumeroCuenta)=5),
						SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0' AND LEN(NumeroCuenta)=5)
						 Where NumeroCuenta = @NumeroCuenta			

 SET @RowCounter = @RowCounter + 1
END

TRUNCATE TABLE #Sumatorias
--------------------------------------------------------------------------------
--Select * from C_BalanzaASEJ
--------------------------------------------------------------------------------3
Set @NumberRecords = 0
Set @RowCounter = 0
Set @NumeroCuenta = ''

INSERT INTO #Sumatorias
SELECT NumeroCuenta FROM C_BalanzaASEJ 
     Where NumeroCuenta like '____'+Replicate('0', @Estructura1 -4)
	 AND (NumeroCuenta like '4%' AND SUBSTRING(NumeroCuenta,2,1) <> '0' AND SUBSTRING(NumeroCuenta,3,1) = '0' AND SUBSTRING(NumeroCuenta,4,1) = '0')

SET @NumberRecords = @@RowCount 
SET @RowCounter = 1

WHILE @RowCounter <= @NumberRecords
BEGIN
 SELECT @NumeroCuenta = NumeroCuenta 
 FROM #Sumatorias
 WHERE RowID = @RowCounter
							
									--Select @NumeroCuenta
					 Update C_BalanzaASEJ set 
					 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,2) = SUBSTRING(@NumeroCuenta,1,2) AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0'),
					 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,2) = SUBSTRING(@NumeroCuenta,1,2) AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0'),
					TotalCargos = (Select ISNULL(SUM(TotalCargos),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,2) = SUBSTRING(@NumeroCuenta,1,2) AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0'),
					TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,2) = SUBSTRING(@NumeroCuenta,1,2) AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0'),
					SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,2) = SUBSTRING(@NumeroCuenta,1,2) AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0'),
					SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,2) = SUBSTRING(@NumeroCuenta,1,2) AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0')
					 Where NumeroCuenta = @NumeroCuenta

 SET @RowCounter = @RowCounter + 1
END

DROP TABLE #Sumatorias
--------------------------------------------------------------------------------
--------------------------------------------------------------5 mil------------------------------------------------------------
--------------------------------------------------------------------------------
CREATE TABLE #Sumatorias5 (
       RowID int IDENTITY(1, 1), 
      NumeroCuenta varchar(100)
 )
DECLARE @NumberRecords5 int
Declare @RowCounter5 int
DECLARE @NumeroCuenta5 varchar(100)

INSERT INTO #Sumatorias5
SELECT NumeroCuenta FROM C_BalanzaASEJ 
     Where NumeroCuenta like '____'+Replicate('0', @Estructura1 -4)
	 AND (NumeroCuenta like '5%' AND SUBSTRING(NumeroCuenta,4,1) <> '0')

SET @NumberRecords5 = @@RowCount 
SET @RowCounter5 = 1

WHILE @RowCounter5 <= @NumberRecords5
BEGIN
 SELECT @NumeroCuenta5 = NumeroCuenta 
 FROM #Sumatorias5
 WHERE RowID = @RowCounter5

						--Select @NumeroCuenta5
						--Select NumeroCuenta,CargosSinFlujo from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta5 + '-%'
					Update C_BalanzaASEJ set 
				    CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta5 + '-%'),
				    AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta5 + '-%'),
			        TotalCargos = (Select ISNULL(SUM(TotalCargos),0) from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta5 + '-%'),
					TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta5 + '-%'),
					SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta5 + '-%'),
					SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) from C_BalanzaASEJ Where NumeroCuenta like @NumeroCuenta5 + '-%')
					Where NumeroCuenta = @NumeroCuenta5
									

 SET @RowCounter5 = @RowCounter5 + 1
END

TRUNCATE TABLE #Sumatorias5
--------------------------------------------------------------------------------
--Select * from C_BalanzaASEJ
--------------------------------------------------------------------------------2

Set @NumberRecords5 = 0
Set @RowCounter5 = 0
Set @NumeroCuenta5 = ''

INSERT INTO #Sumatorias5
SELECT NumeroCuenta FROM C_BalanzaASEJ 
     Where NumeroCuenta like '____'+Replicate('0', @Estructura1 -4)
	 AND (NumeroCuenta like '5%' AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0')

SET @NumberRecords5 = @@RowCount 
SET @RowCounter5 = 1

WHILE @RowCounter5 <= @NumberRecords5
BEGIN
 SELECT @NumeroCuenta5 = NumeroCuenta 
 FROM #Sumatorias5
 WHERE RowID = @RowCounter5

        --Select @NumeroCuenta5
		--Select * from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta5,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0'
					   Update C_BalanzaASEJ set 
					   CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta5,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0' AND LEN(NumeroCuenta)=5),
						AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta5,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0' AND LEN(NumeroCuenta)=5),
						TotalCargos = (Select ISNULL(SUM(TotalCargos),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta5,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0' AND LEN(NumeroCuenta)=5),
					   TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta5,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0' AND LEN(NumeroCuenta)=5),
						SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta5,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0' AND LEN(NumeroCuenta)=5),
						SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,3) = SUBSTRING(@NumeroCuenta5,1,3) AND SUBSTRING(NumeroCuenta,4,1) <> '0' AND LEN(NumeroCuenta)=5)
						 Where NumeroCuenta = @NumeroCuenta5			

 SET @RowCounter5 = @RowCounter5 + 1
END

TRUNCATE TABLE #Sumatorias5
--------------------------------------------------------------------------------
--Select * from C_BalanzaASEJ
--------------------------------------------------------------------------------3
Set @NumberRecords5 = 0
Set @RowCounter5 = 0
Set @NumeroCuenta5 = ''

INSERT INTO #Sumatorias5
SELECT NumeroCuenta FROM C_BalanzaASEJ 
     Where NumeroCuenta like '____'+Replicate('0', @Estructura1 -4)
	 AND (NumeroCuenta like '5%' AND SUBSTRING(NumeroCuenta,2,1) <> '0' AND SUBSTRING(NumeroCuenta,3,1) = '0' AND SUBSTRING(NumeroCuenta,4,1) = '0')

SET @NumberRecords5 = @@RowCount 
SET @RowCounter5 = 1

WHILE @RowCounter5 <= @NumberRecords5
BEGIN
 SELECT @NumeroCuenta5 = NumeroCuenta 
 FROM #Sumatorias5
 WHERE RowID = @RowCounter5
							
									--Select @NumeroCuenta5
					 Update C_BalanzaASEJ set 
					 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,2) = SUBSTRING(@NumeroCuenta5,1,2) AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0'),
					 AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,2) = SUBSTRING(@NumeroCuenta5,1,2) AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0'),
					TotalCargos = (Select ISNULL(SUM(TotalCargos),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,2) = SUBSTRING(@NumeroCuenta5,1,2) AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0'),
					TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,2) = SUBSTRING(@NumeroCuenta5,1,2) AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0'),
					SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,2) = SUBSTRING(@NumeroCuenta5,1,2) AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0'),
					SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) from C_BalanzaASEJ Where SUBSTRING(NumeroCuenta,1,2) = SUBSTRING(@NumeroCuenta5,1,2) AND SUBSTRING(NumeroCuenta,3,1) <> '0' AND SUBSTRING(NumeroCuenta,4,1) = '0')
					 Where NumeroCuenta = @NumeroCuenta5

 SET @RowCounter5 = @RowCounter5 + 1
END

DROP TABLE #Sumatorias5

---------------------------Cuentas solas-------------------
		 --
		Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41200-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41200-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41200-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41200-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41200-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41200-00000') )
		 Where CuentaNumero = 41200

		Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41210-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41210-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41210-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41210-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41210-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41210-00000') )
		 Where CuentaNumero = 41210

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41220-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41220-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41220-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41220-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41220-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41220-00000') )
		 Where CuentaNumero = 41220

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41230-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41230-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41230-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41230-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41230-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41230-00000') )
		 Where CuentaNumero = 41230

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41240-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41240-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41240-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41240-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41240-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41240-00000') )
		 Where CuentaNumero = 41240

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41290-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41290-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41290-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41290-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41290-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41290-00000') )
		 Where CuentaNumero = 41290

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41300-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41300-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41300-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41300-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41300-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41300-00000') )
		 Where CuentaNumero = 41300

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41320-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41320-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41320-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41320-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41320-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41320-00000') )
		 Where CuentaNumero = 41320

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41400-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41400-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41400-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41400-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41400-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41400-00000') )
		 Where CuentaNumero = 41400

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41440-00000') )
		 Where CuentaNumero = 41440

					Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41450-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41450-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41450-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41450-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41450-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41450-00000') )
		 Where CuentaNumero = 41450

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41490-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41490-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41490-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41490-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41490-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41490-00000') )
		 Where CuentaNumero = 41490

	 		Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41500-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41500-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41500-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41500-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41500-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41500-00000') )
		 Where CuentaNumero = 41500

		 		Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41510-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41510-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41510-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41510-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41510-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41510-00000') )
		 Where CuentaNumero = 41510

			 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41520-00001') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41520-00001') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41520-00001') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41520-00001') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41520-00001') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41520-00001') )
		 Where CuentaNumero = 41520

				 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41540-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41540-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41540-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41540-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41540-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41540-00000') )
		 Where CuentaNumero = 41540

					 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41600-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41600-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41600-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41600-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41600-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41600-00000') )
		 Where CuentaNumero = 41600

			 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41610-61412') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41610-61412') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41610-61412') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41610-61412') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41610-61412') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41610-61412') )
		 Where CuentaNumero = 41610

			 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41620-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41620-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41620-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41620-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41620-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41620-00000') )
		 Where CuentaNumero = 41620

				 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41630-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41630-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41630-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41630-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41630-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41630-00000') )
		 Where CuentaNumero = 41630

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41640-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41640-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41640-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41640-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41640-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41640-00000') )
		 Where CuentaNumero = 41640

					Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41650-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41650-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41650-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41650-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41650-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41650-00000') )
		 Where CuentaNumero = 41650

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41660-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41660-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41660-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41660-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41660-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41660-00000') )
		 Where CuentaNumero = 41660

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41680-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41680-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41680-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41680-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41680-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41680-00000') )
		 Where CuentaNumero = 41680

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-00000') )
		 Where CuentaNumero = 41690

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41690-00000') )
		 Where CuentaNumero = 41690

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41700-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41700-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41700-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41700-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41700-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41700-00000') )
		 Where CuentaNumero = 41700

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41710-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41710-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41710-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41710-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41710-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41710-00000') )
		 Where CuentaNumero = 41710

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41720-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41720-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41720-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41720-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41720-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41720-00000') )
		 Where CuentaNumero = 41720

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41730-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41730-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41730-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41730-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41730-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41730-00000') )
		 Where CuentaNumero = 41730

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41740-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41740-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41740-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41740-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41740-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41740-00000') )
		 Where CuentaNumero = 41740

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41750-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41750-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41750-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41750-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41750-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41750-00000') )
		 Where CuentaNumero = 41750

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41760-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41760-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41760-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41760-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41760-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41760-00000') )
		 Where CuentaNumero = 41760

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41780-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('41780-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41780-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('41780-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41780-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('41780-00000') )
		 Where CuentaNumero = 41780

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43110-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43110-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43110-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43110-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43110-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43110-00000') )
		 Where CuentaNumero = 43110

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43200-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43200-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43200-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43200-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43200-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43200-00000') )
		 Where CuentaNumero = 43200

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43210-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43210-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43210-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43210-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43210-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43210-00000') )
		 Where CuentaNumero = 43210

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43220-00000') )
		 Where CuentaNumero = 43220

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43230-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43230-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43230-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43230-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43230-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43230-00000') )
		 Where CuentaNumero = 43230

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43240-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43240-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43240-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43240-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43240-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43240-00000') )
		 Where CuentaNumero = 43240

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') )
		 Where CuentaNumero = 43250

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43250-00000') )
		 Where CuentaNumero = 43250

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43300-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43300-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43300-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43300-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43300-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43300-00000') )
		 Where CuentaNumero = 43300

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43310-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43310-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43310-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43310-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43310-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43310-00000') )
		 Where CuentaNumero = 43310

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43400-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43400-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43400-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43400-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43400-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43400-00000') )
		 Where CuentaNumero = 43400

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43410-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43410-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43410-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43410-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43410-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43410-00000') )
		 Where CuentaNumero = 43410

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43900-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43900-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43900-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43900-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43900-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43900-00000') )
		 Where CuentaNumero = 43900

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43910-90309') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43910-90309') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43910-90309') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43910-90309') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43910-90309') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43910-90309') )
		 Where CuentaNumero = 43910

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43920-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43920-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43920-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43920-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43920-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43920-00000') )
		 Where CuentaNumero = 43920

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43930-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43930-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43930-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43930-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43930-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43930-00000') )
		 Where CuentaNumero = 43930

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43940-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43940-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43940-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43940-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43940-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43940-00000') )
		 Where CuentaNumero = 43940

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43950-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43950-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43950-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43950-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43950-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43950-00000') )
		 Where CuentaNumero = 43950

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43960-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43960-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43960-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43960-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43960-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43960-00000') )
		 Where CuentaNumero = 43960

					Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43970-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43970-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43970-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43970-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43970-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43970-00000') )
		 Where CuentaNumero = 43970

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('43990-00000') )
		 Where CuentaNumero = 43990

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52120-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52120-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52120-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52120-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52120-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52120-00000') )
		 Where CuentaNumero = 52120

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52210-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52210-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52210-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52210-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52210-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52210-00000') )
		 Where CuentaNumero = 52210

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52220-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('52220-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52220-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('52220-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52220-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('52220-00000') )
		 Where CuentaNumero = 52220


			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55100-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55100-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55100-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('555100-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55100-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55100-00000') )
		 Where CuentaNumero = 55100

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55110-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55110-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55110-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55110-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55110-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55110-00000') )
		 Where CuentaNumero = 55110

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55120-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55120-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55120-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55120-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55120-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55120-00000') )
		 Where CuentaNumero = 55120

					Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55130-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55130-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55130-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55130-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55130-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55130-00000') )
		 Where CuentaNumero = 55130

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55140-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55140-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55140-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55140-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55140-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55140-00000') )
		 Where CuentaNumero = 55140

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55150-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55150-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55150-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55150-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55150-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55150-00000') )
		 Where CuentaNumero = 55150

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55160-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55160-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55160-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55160-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55160-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55160-00000') )
		 Where CuentaNumero = 55160

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55170-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55170-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55170-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55170-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55170-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55170-00000') )
		 Where CuentaNumero = 55170

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55200-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55200-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55200-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55200-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55200-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55200-00000') )
		 Where CuentaNumero = 55200

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55210-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55210-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55210-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55210-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55210-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55210-00000') )
		 Where CuentaNumero = 55210

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55220-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55220-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55220-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55220-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55220-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55220-00000') )
		 Where CuentaNumero = 55220

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55300-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55300-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55300-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55300-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55300-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55300-00000') )
		 Where CuentaNumero = 55300

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55310-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55310-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55310-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55310-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55310-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55310-00000') )
		 Where CuentaNumero = 55310

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55320-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55320-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55320-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55320-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55320-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55320-00000') )
		 Where CuentaNumero = 55320

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55330-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55330-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55330-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55330-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55330-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55330-00000') )
		 Where CuentaNumero = 55330

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55340-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55340-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55340-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55340-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55340-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55340-00000') )
		 Where CuentaNumero = 55340

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55350-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55350-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55350-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55350-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55350-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55350-00000') )
		 Where CuentaNumero = 55350

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55400-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55400-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55400-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55400-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55400-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55400-00000') )
		 Where CuentaNumero = 55400

		 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55410-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55410-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55410-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55410-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55410-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55410-00000') )
		 Where CuentaNumero = 55410

			 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55500-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55500-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55500-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55500-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55500-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55500-00000') )
		 Where CuentaNumero = 55500

			 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55510-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55510-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55510-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55510-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55510-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55510-00000') )
		 Where CuentaNumero = 55510

			 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55900-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55900-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55900-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55900-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55900-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55900-00000') )
		 Where CuentaNumero = 55900

			 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55910-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55910-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55910-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55910-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55910-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55910-00000') )
		 Where CuentaNumero = 55910

		 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55920-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55920-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55920-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55920-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55920-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55920-00000') )
		 Where CuentaNumero = 55920

			 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55930-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55930-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55930-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55930-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55930-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55930-00000') )
		 Where CuentaNumero = 55930

			 Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55950-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55950-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55950-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55950-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55950-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55950-00000') )
		 Where CuentaNumero = 55950

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55960-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55960-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55960-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55960-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55960-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55960-00000') )
		 Where CuentaNumero = 55960

				Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55970-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55970-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55970-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55970-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55970-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55970-00000') )
		 Where CuentaNumero = 55970

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55980-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55980-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55980-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55980-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55980-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55980-00000') )
		 Where CuentaNumero = 55980

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55990-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('55990-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55990-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('55990-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55990-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('55990-00000') )
		 Where CuentaNumero = 55990

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('56000-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('56000-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('56000-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('56000-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('56000-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('56000-00000') )
		 Where CuentaNumero = 56000

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('56100-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('56100-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('56100-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('56100-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('56100-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('56100-00000') )
		 Where CuentaNumero = 56100

			Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('56110-00000') ),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu Where NumeroCuenta in ('56110-00000') ),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu Where NumeroCuenta in ('56110-00000') ),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu Where NumeroCuenta in ('56110-00000') ),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) FROM #BalanzaAcu Where NumeroCuenta in ('56110-00000') ),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) FROM #BalanzaAcu Where NumeroCuenta in ('56110-00000') )
		 Where CuentaNumero = 56110
-----------------------------------------------------------
--------------------------------------------------------------------------------
		--Total 4000
		Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) from C_BalanzaASEJ Where IdCuenta in (195,305,353)),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) from C_BalanzaASEJ Where IdCuenta in (195,305,353)),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) from C_BalanzaASEJ Where IdCuenta in (195,305,353)),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) from C_BalanzaASEJ Where IdCuenta in (195,305,353)),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) from C_BalanzaASEJ Where IdCuenta in (195,305,353)),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) from C_BalanzaASEJ Where IdCuenta in (195,305,353))
		 Where IdCuenta = 194

		 --Total 5000
		Update C_BalanzaASEJ set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) from C_BalanzaASEJ Where IdCuenta in (388,574,657,681,711,744)),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) from C_BalanzaASEJ Where IdCuenta in (388,574,657,681,711,744)),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) from C_BalanzaASEJ Where IdCuenta in (388,574,657,681,711,744)),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) from C_BalanzaASEJ Where IdCuenta in (388,574,657,681,711,744)),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) from C_BalanzaASEJ Where IdCuenta in (388,574,657,681,711,744)),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) from C_BalanzaASEJ Where IdCuenta in (388,574,657,681,711,744))
		 Where IdCuenta = 387
--------------------------------------------------------------------------------------
Exec RPT_SP_Actualiza_Tabla_BalanzaASEJ @Ejercicio,@Mes,''
--Select * from #BalanzaAcu

Delete from #BalanzaAcu Where NumeroCuenta not like '____'+Replicate('0', @Estructura1 + -4)+'-'+ @CerosEstructura OR NumeroCuenta  like '8%' OR NumeroCuenta like '4%' OR NumeroCuenta like '5%'

Insert into #Balanza
Select NumeroCuenta,NombreCuenta,CargosSinFlujo,AbonosSinFlujo,TotalCargos,TotalAbonos,SaldoDeudor,SaldoAcreedor,
@Mes,@Ejercicio,'Z',4,Financiero,CuentaNumero,Orden,Negritas
from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '4%' or NumeroCuenta like '5%' 



Insert into #Balanza
Select NumeroCuenta,NombreCuenta,CargosSinFlujo,AbonosSinFlujo,TotalCargos,TotalAbonos,SaldoDeudor,SaldoAcreedor,
@Mes,@Ejercicio,'Z',7,Financiero,CuentaNumero,Orden,Negritas
from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '8%'

--------------------------------------Totales Finales---------------------------------
Update [dbo].[C_BalanzaASEJ] set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) from #Balanza Where CuentaNumero in (10000,20000,30000,40000,50000,60000)),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) from #Balanza Where CuentaNumero in (10000,20000,30000,40000,50000,60000)),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) from #Balanza Where CuentaNumero in (10000,20000,30000,40000,50000,60000)),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) from #Balanza Where CuentaNumero in (10000,20000,30000,40000,50000,60000)),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) from #Balanza Where CuentaNumero in (10000,20000,30000,40000,50000,60000)),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) from #Balanza Where CuentaNumero in (10000,20000,30000,40000,50000,60000))
		 Where CuentaNumero = 69999

Update [dbo].[C_BalanzaASEJ] set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) from #Balanza Where CuentaNumero in (70000)),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) from #Balanza Where CuentaNumero in (70000)),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) from #Balanza Where CuentaNumero in (70000)),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) from #Balanza Where CuentaNumero in (70000)),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) from #Balanza Where CuentaNumero in (70000)),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) from #Balanza Where CuentaNumero in (70000))
		 Where CuentaNumero = 79999

Update [dbo].[C_BalanzaASEJ] set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) from #Balanza Where CuentaNumero in (80000,90000)),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) from #Balanza Where CuentaNumero in (80000,90000)),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) from #Balanza Where CuentaNumero in (80000,90000)),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) from #Balanza Where CuentaNumero in (80000,90000)),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) from #Balanza Where CuentaNumero in (80000,90000)),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) from #Balanza Where CuentaNumero in (80000,90000))
		 Where CuentaNumero = 99999

Update [dbo].[C_BalanzaASEJ] set 
		 CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) from #Balanza Where CuentaNumero in (10000,20000,30000,40000,50000,60000,70000,80000,90000)),
		AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) from #Balanza Where CuentaNumero in (10000,20000,30000,40000,50000,60000,70000,80000,90000)),
		TotalCargos = (Select ISNULL(SUM(TotalCargos),0) from #Balanza Where CuentaNumero in (10000,20000,30000,40000,50000,60000,70000,80000,90000)),
		 TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) from #Balanza Where CuentaNumero in (10000,20000,30000,40000,50000,60000,70000,80000,90000)),
		SaldoDeudor = (Select ISNULL(SUM(SaldoDeudor),0) from #Balanza Where CuentaNumero in (10000,20000,30000,40000,50000,60000,70000,80000,90000)),
		SaldoAcreedor = (Select ISNULL(SUM(SaldoAcreedor),0) from #Balanza Where CuentaNumero in (10000,20000,30000,40000,50000,60000,70000,80000,90000))
	Where CuentaNumero in (100000)
--------------------------------------------------------------------------------------



--Sumas Finales
Insert into #Balanza
Select NumeroCuenta,NombreCuenta,CargosSinFlujo,AbonosSinFlujo,TotalCargos,TotalAbonos,SaldoDeudor,SaldoAcreedor,
@Mes,@Ejercicio,'S',12,Financiero,CuentaNumero,Orden,Negritas
from [dbo].[C_BalanzaASEJ] 
Where IdCuenta in (751,2084,2085)

Insert into #Balanza
Select NumeroCuenta,NombreCuenta,CargosSinFlujo,AbonosSinFlujo,TotalCargos,TotalAbonos,SaldoDeudor,SaldoAcreedor,
@Mes,@Ejercicio,'Z',7,Financiero,CuentaNumero,Orden,Negritas
from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (11940,77000,77100,77200,77300,77400)

Insert into #Balanza
Select NumeroCuenta,NombreCuenta,CargosSinFlujo,AbonosSinFlujo,TotalCargos,TotalAbonos,SaldoDeudor,SaldoAcreedor,
@Mes,@Ejercicio,'T',7,Financiero,CuentaNumero,Orden,Negritas
from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (100000)

Update t1 SET t1.Orden = t2.Orden From #Balanza t1 , C_BalanzaASEJ t2 Where t1.NumeroCuenta = t2.NumeroCuenta
Update t1 SET t1.NombreCuenta = t2.NombreCuenta From #Balanza t1 , C_BalanzaASEJ t2 Where t1.NumeroCuenta = t2.NumeroCuenta and t2.CuentaNumero in (11450,12600,32000,75000)


Delete from #Balanza Where CuentaNumero in (32210,32220,32230,32240,31310)

--Select NumeroCuenta,NombreCuenta,CargosSinFlujo,AbonosSinFlujo,TotalCargos,TotalAbonos,SaldoDeudor,SaldoAcreedor,Mes,[Year],TipoCuenta,Afectable,Financiero, CuentaNumero,Orden from #Balanza Where 1=1 order by Orden

SET @sql = N'Select NumeroCuenta,NombreCuenta,CargosSinFlujo,AbonosSinFlujo,TotalCargos,TotalAbonos,SaldoDeudor,SaldoAcreedor,Mes,[Year],TipoCuenta,Afectable,Financiero, CuentaNumero,Orden,Negritas from #Balanza Where 1=1' 

IF @SaldoMayor0 = 1
SET @sql +=  ' AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0)'

  IF @ConMovimientos = 1
 SET @sql +=  ' AND (TotalCargos <> 0 OR TotalAbonos <> 0) '
 
IF @MovimientoySaldoNOcero = 1
 SET @sql += ' AND ((SaldoDeudor <> 0 or SaldoAcreedor <> 0) AND (TotalCargos<>0 OR TotalAbonos <> 0))'
    
IF @MovimientoOSaldoNOcero = 1
 SET @sql += ' AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0 or TotalCargos <> 0 OR TotalAbonos <> 0)'

IF @CuentasDeMayor = 1
 SET @sql += ' AND Financiero = 1'
       
 IF @CuentasDeOrden = 1
 SET @sql += ' AND NumeroCuenta NOT LIKE ''8%'' AND NumeroCuenta NOT LIKE ''7%'' AND NumeroCuenta NOT LIKE ''9%''' 

 IF @CuentaInicio<>0 and @CuentaFin<>0
 set @sql += ' AND (CuentaNumero Between '+ Convert(nvarchar(200),@CuentaInicio) + ' AND '+ Convert(nvarchar(200),@CuentaFin) +')'


 Set @sql += ' Order by Orden'

EXEC (@sql)

DROP TABLE #Balanza
DROP TABLE #BalanzaAcu
	--Select * from #Balanza  Where 1=1--order by NumeroCuenta
	--UNION 
	--Select * from @Balanza8 order by NumeroCuenta
END

GO

