/****** Object:  StoredProcedure [dbo].[RPT_SP_Balanza_Nivel_Afectable]    Script Date: 06/05/2021 16:31:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_Balanza_Nivel_Afectable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_Balanza_Nivel_Afectable]
GO

/****** Object:  StoredProcedure [dbo].[RPT_SP_Balanza_Nivel_Afectable]    Script Date: 06/05/2021 16:31:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Exec RPT_SP_Balanza_Nivel_Afectable 2020
CREATE PROCEDURE [dbo].[RPT_SP_Balanza_Nivel_Afectable]

@Ejercicio int,
@Periodo1 int,
@Periodo2 int

AS

BEGIN

declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

Declare @SaldosFinales as table (
IdCuenta int,
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo decimal (18,4), 
AbonosSinFlujo Decimal(18,4),
TotalCargos Decimal(18,4),
TotalAbonos Decimal(18,4),
SaldoDeudor  Decimal(18,4),
SaldoAcreedor  Decimal(18,4),
Afectable int,
Financiero int)

CREATE TABLE #Balanza(
	[nocuenta] [varchar](30) NULL,
	[nombre] [varchar](255) NULL,
	[cSinFlujo] [decimal](15, 2) NULL,
	[aSinFlujo] [decimal](15, 2) NULL,
	[TotalCargos] [decimal](15, 2) NULL,
	[TotalAbonos] [decimal](15, 2) NULL,
	[SaldoDeudor] [decimal](15, 2) NULL,
	[SaldoAcreedor] [decimal](15, 2) NULL,
	[Afectable] [int] NULL,
	[Financiero] [int] NULL,
	[CuentaNumero] [bigint] NULL
)

Insert Into #Balanza
EXEC SP_RPT_K2_BalanzaAcumulada @Periodo1,@Periodo2,@Ejercicio,0,0,0,0,0,0,'','',0,0

Declare @Todo as table (
Sello varchar(max),
ID_UR varchar(100), 
DESC_UR varchar(MAX),
CLASPROGRAMTICA varchar(100),
DESC_CLASPROGRAMTICA varchar(max),
OBJ_GASTO int,
DESC_OBJ_GASTO varchar(max),
ID_TIPO_GASSTO varchar(100),
TIPO_GASTO varchar (max),
ID_CRI int,
DESC_CRI varchar(10),
ID_FF varchar(100),
DESC_FF varchar(max),
ID_MUNICIPIO varchar(10),
MUNICIPIO varchar(max),
GENERO int,
DESC_GENERO varchar(max),
GRUPO bigint,
DESC_GRUPO varchar(max),
RUBRO bigint,
DESC_RUBRO varchar(max),
CuentaNumero bigint,
CUENTA bigint,
DESC_CUENTA varchar(max),
SUBCUENTA int,
DESC_SUBCUENTA varchar(10),
SS_CUENTA int,
DESC_SS_CUENTA varchar(10),
SS_CUENTA_ESP varchar(50),
DESC_SSCUENTA varchar(max),
InicialDeudor decimal (18,4), 
InicialAcreedor Decimal(18,4),
ImporteCargo Decimal(18,4),
ImporteAbono Decimal(18,4),
FinalDeudor  Decimal(18,4),
FinalAcreedor  Decimal(18,4),
Poliza int,
Fecha datetime,
Referencia varchar(max))


INSERT INTO @SaldosFinales
Select VW_C_Contable.IdCuentaContable, NumeroCuenta, NombreCuenta, 
	CargosSinFlujo, AbonosSinFlujo, TotalCargos, TotalAbonos,
					Case VW_C_Contable.TipoCuenta 
						When 'A' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
						When 'C' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
						When 'E' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
						When 'G' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
						When 'I' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
						Else 0
					End as SaldoDeudor,
					Case VW_C_Contable.TipoCuenta 
						When 'A' Then 0
						When 'C' Then 0
						When 'E' Then 0
						When 'G' Then 0
						When 'I'  Then 0
						Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
					End as SaldoAcreedor, Afectable,VW_C_Contable.Financiero 
	From VW_C_Contable JOIN T_SaldosInicialesCont ON VW_C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
	Where  
	 Mes = @Periodo2  And [Year] = @Ejercicio And TipoCuenta <> 'X' --AND NumeroCuenta like '5%'
	Order By NumeroCuenta


Insert into @Todo
SELECT
	sellos.sello as CLAVE_PRESUPUESTAL, 
	--sellos.IdSelloPresupuestal,
	CA.Clave as ID_UR, CA.Nombre as DESC_UR,
	CEPR.Clave as CLASPROGRAMATICA, CEPR.Nombre as DESCRIPCIONCLASPROGRAMATICA,
	CPP.IdPartida as OBJ_GASTO, CPP.DescripcionPartida as DESC_OBJ_GASTO,
	CTG.Clave as ID_TIPO_GASTO, CTG.DESCRIPCION as TIPO_GASTO,
	0  as ID_CRI, '' as DESC_CRI,
	CF.CLAVE as ID_FF, CF.DESCRIPCION as DESC_FF,
	CG.Clave as ID_MUNICIPIO, CG.Descripcion as MUNICIPIO,

	LEFT(CC.NumeroCuenta,1) as GENERO,
	(Select NombreCuenta from VW_C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,1) +Replicate('0',@Estructura1-1)+'-'+@cerosEstructura)) as DESC_GENERO,

		LEFT(CC.NumeroCuenta,2) as GRUPO,
	(Select NombreCuenta from VW_C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,2) +Replicate('0',@Estructura1-2)+'-'+@cerosEstructura)) as DESC_GRUPO,

	
		LEFT(CC.NumeroCuenta,3) as RUBRO,
	(Select NombreCuenta from VW_C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,3) +Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) as DESC_RUBRO,

	convert(bigint, Replace(CC.Numerocuenta,'-','')) as CuentaNumero,
			LEFT(CC.NumeroCuenta,5) as CUENTA,
	(Select NombreCuenta from VW_C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,5) +Replicate('0',@Estructura1-5)+'-'+@cerosEstructura)) as DESC_CUENTA,

	0 as SUBCUENTA,
	'' as DESC_SUBCUENTA,

	0 as SS_CUENTA,
	'' as DESC_SS_CUENTA,

	RIGHT(TRIM(CC.NumeroCuenta),5) as SS_CUENTA_ESP,
CC.NombreCuenta  as DESC_SSCUENTA,
--CC.NumeroCuenta,

			0.0000 as  InicialDeudor,
			0.0000 as InicialAcreedor,
			--TotalCargos, TotalAbonos,
			D_Polizas.ImporteCargo,
			D_Polizas.ImporteAbono,
					Finales.SaldoDeudor as FinalDeudor,
					Finales.SaldoAcreedor as FinalAcreedor,

			T_polizas.NoPoliza AS Poliza,
			T_Polizas.Fecha,
			D_Polizas.Referencia
			
			FROM T_Polizas
			JOIN
			D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza AND D_Polizas.IdPoliza in (Select IdPoliza from T_Polizas Where Ejercicio = @Ejercicio)
			 JOIN
			VW_C_Contable CC ON CC.IdCuentaContable= D_Polizas.IdCuentaContable 
			
			LEFT JOIN 
			T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque join T_SellosPresupuestales Sellos
			on d_polizas.IdSelloPresupuestal = Sellos.IdSelloPresupuestal 
			LEFT JOIN C_FuenteFinanciamiento  CF ON Sellos.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento
			LEFT JOIN C_TipoGasto CTG ON CTG.IDTIPOGASTO = Sellos.IdTipoGasto
			LEFT JOIN C_AreaResponsabilidad CA ON CA.IdAreaResp = Sellos.IdAreaResp
			LEFT JOIN C_PartidasPres CPP ON CPP.IdPartida = Sellos.IdPartida
			LEFT join   C_EP_Ramo  CEPR on CEPR.Id = Sellos.IdProyecto

			LEFT JOIN C_ClasificadorGeograficoPresupuestal CG ON CG.IdClasificadorGeografico = Sellos.IdClasificadorGeografico
--ON TCA.IdCheques = TCA.IdCheques
LEFT JOIN T_SolicitudCheques TSCA
ON T_Cheques.IdSolicitudCheque = TSCA.IdSolicitudCheques
LEFT JOIN T_RecepcionFacturas TRFA
ON TRFA.IdRecepcionServicios = TSCA.IdRecepcionServicios
LEFT JOIN @SaldosFinales Finales  ON Finales.IdCuenta = D_Polizas.IdCuentaContable 

			 where TipoCuenta <> 'X'
			 AND (T_Polizas.NoPoliza>0 
			 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
			 and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N')))and T_Polizas.NoPoliza>0))
			AND MONTH(T_Polizas.Fecha) >= @Periodo1  
			AND MONTH(T_Polizas.Fecha) <= @Periodo2  
			AND YEAR(T_Polizas.Fecha) <= @Ejercicio  
			--AND (CC.NumeroCuenta like '5%')
				
			ORDER BY T_Polizas.IdPoliza


Insert into @Todo
SELECT
	'' as CLAVE_PRESUPUESTAL, 
	'' as ID_UR, '' as DESC_UR,
	'' as CLASPROGRAMATICA, '' as DESCRIPCIONCLASPROGRAMATICA,
	0 as OBJ_GASTO, '' as DESC_OBJ_GASTO,
	'' as ID_TIPO_GASTO, '' as TIPO_GASTO,
	0  as ID_CRI, '' as DESC_CRI,
	'' as ID_FF, '' as DESC_FF,
	'' as ID_MUNICIPIO, '' as MUNICIPIO,

	LEFT(CC.nocuenta,1) as GENERO,
	(Select NombreCuenta from VW_C_Contable WHere NumeroCuenta = (LEFT(CC.nocuenta,1) +Replicate('0',@Estructura1-1)+'-'+@cerosEstructura)) as DESC_GENERO,

		LEFT(CC.nocuenta,2) as GRUPO,
	(Select NombreCuenta from VW_C_Contable WHere NumeroCuenta = (LEFT(CC.nocuenta,2) +Replicate('0',@Estructura1-2)+'-'+@cerosEstructura)) as DESC_GRUPO,

	
		LEFT(CC.nocuenta,3) as RUBRO,
	(Select NombreCuenta from VW_C_Contable WHere NumeroCuenta = (LEFT(CC.nocuenta,3) +Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) as DESC_RUBRO,

	convert(bigint, Replace(CC.nocuenta,'-','')) as CuentaNumero,
			LEFT(CC.nocuenta,5) as CUENTA,
	(Select NombreCuenta from VW_C_Contable WHere NumeroCuenta = (LEFT(CC.nocuenta,5) +Replicate('0',@Estructura1-5)+'-'+@cerosEstructura)) as DESC_CUENTA,

	0 as SUBCUENTA,
	'' as DESC_SUBCUENTA,

	0 as SS_CUENTA,
	'' as DESC_SS_CUENTA,

	RIGHT(TRIM(CC.nocuenta),5) as SS_CUENTA_ESP,
CC.nombre  as DESC_SSCUENTA,

			
			cSinFlujo as  InicialDeudor,
			aSinFlujo as InicialAcreedor,
			TotalCargos,
			TotalAbonos,
			
			SaldoDeudor,
			SaldoAcreedor,

			0 AS Poliza,
			null as Fecha,
			'' as Referencia
			
			From #Balanza CC 
			Where CC.CuentaNumero not in (Select distinct CuentaNumero from @Todo) AND CC.Afectable = 1

	Select * from @Todo  order by CuentaNumero
	Drop Table #Balanza
END

--Select * from VW_C_Contable
			


