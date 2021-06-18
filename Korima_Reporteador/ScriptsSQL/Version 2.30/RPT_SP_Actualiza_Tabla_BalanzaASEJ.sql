/****** Object:  StoredProcedure [dbo].[RPT_SP_Actualiza_Tabla_BalanzaASEJ]    Script Date: 06/10/2020 16:31:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_Actualiza_Tabla_BalanzaASEJ]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_Actualiza_Tabla_BalanzaASEJ]
GO

/****** Object:  StoredProcedure [dbo].[RPT_SP_Actualiza_Tabla_BalanzaASEJ]    Script Date: 06/10/2020 16:31:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <11-11-2020>
-- Description:	<Actualiza Tabla BalanzaASEJ cuentas 8 mil>
-- =============================================

--Exec RPT_SP_Actualiza_Tabla_BalanzaASEJ 2020,1,''
CREATE PROCEDURE [dbo].[RPT_SP_Actualiza_Tabla_BalanzaASEJ]
@Ejercicio int,
@Mes int,
 @MsgErrDescr as varchar(255)  OUTPUT

AS
BEGIN TRANSACTION
SET NOCOUNT ON
	Declare @Extras as table (
Fecha datetime,
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
ImporteCargo decimal (18,2),
ImporteAbono decimal (18,2), 
SaldoFila Decimal(18,2),
CuentaAcumulacion varchar(100),
SaldoInicial Decimal(18,2),
Mes int,
[Year] int,
iNumeroCuenta bigint,
sello varchar(100),
IdSelloPresupuestal int,
ClavePartida int,
ClaveFF int,
TipoCuenta varchar(10)
)

UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-900','Deuda pública',
	CargosSinFlujo=0,
	AbonosSinFlujo=0,
	TotalCargos=0,
	TotalAbonos=0,
	SaldoDeudor=0,
	SaldoAcreedor=0
Where NumeroCuenta like '8%'

Insert into @Extras
SELECT
			T_Polizas.Fecha,
			C_Contable.NumeroCuenta AS NumeroCuentaContable,
			C_Contable.NombreCuenta AS NombreCuentaContable,
			D_Polizas.ImporteCargo,
			D_Polizas.ImporteAbono,
				Case C_Contable .TipoCuenta    
				  When 'A' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
				  When 'C' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
				  When 'E' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
				  When 'G' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
				  When 'I' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
				  Else T_SaldosInicialesCont.AbonosSinFlujo +(D_Polizas.ImporteAbono - D_Polizas.ImporteCargo)
				End as SaldoFila,
			c_contable.CuentaAcumulacion,
			 Case C_Contable .TipoCuenta  
					  When 'A' Then T_SaldosInicialesCont.CargosSinFlujo 
					  When 'C' Then T_SaldosInicialesCont.CargosSinFlujo 
					  When 'E' Then T_SaldosInicialesCont.CargosSinFlujo 
					  When 'G' Then T_SaldosInicialesCont.CargosSinFlujo 
					  When 'I' Then T_SaldosInicialesCont.CargosSinFlujo 
					  Else T_SaldosInicialesCont.AbonosSinFlujo 
				  End as SaldoInicial,
				  T_SaldosInicialesCont.Mes,
			T_SaldosInicialesCont.year,
			convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta, sellos.sello, 
			sellos.IdSelloPresupuestal,
			CPG.IdPartidaGenerica as ClavePartida,
			LEFT(CF.Clave,2),
			C_Contable .TipoCuenta 
			FROM T_Polizas
			JOIN
			D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza
			JOIN
			C_Contable ON C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable 
			JOIN
			T_SaldosInicialesCont ON C_Contable.IdCuentaContable= T_SaldosInicialesCont.IdCuentaContable
			AND T_SaldosInicialesCont.Mes= T_Polizas.Periodo 
			and T_SaldosInicialesCont.Year= T_Polizas.Ejercicio 
			LEFT JOIN 
			T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque 
			left outer join T_SellosPresupuestales Sellos
			on d_polizas.IdSelloPresupuestal = Sellos.IdSelloPresupuestal
			 Left Join  C_PartidasPres CP on Sellos.IdPartida  = CP.IdPartida
			 Left Join C_PartidasGenericasPres  CPG  ON CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
			LEFT JOIN C_FuenteFinanciamiento  CF ON Sellos.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento
			 where TipoCuenta <> 'X'
			 AND (T_Polizas.NoPoliza>0 --and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')
			 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
			 and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N')))and T_Polizas.NoPoliza>0))
			AND Mes >= 1    
			AND Mes <= @Mes  
			AND [year] = @Ejercicio 
			AND NumeroCuenta like '8%'
			AND sellos.IdSelloPresupuestal is not null
			ORDER BY CPG.IdPartidaGenerica, Fecha

			--Select * from C_BalanzaASEJ
---------------------------------------------------81100--------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-11%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-11%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-11%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-11%')
	Where IdCuenta = 794

		UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-12%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-12%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-12%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-12%')
	Where IdCuenta = 795

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-13%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-13%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-13%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-13%')
	Where IdCuenta = 796

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-14%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-14%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-14%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-14%')
	Where IdCuenta = 797

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-15%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-15%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-15%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-15%')
	Where IdCuenta = 798

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-16%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-16%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-16%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-16%')
	Where IdCuenta = 799

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-17%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-17%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-17%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-17%')
	Where IdCuenta = 800

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-18%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-18%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-18%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-18%')
	Where IdCuenta = 801

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-19%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-19%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-19%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-19%')
	Where IdCuenta = 802

	-----81100-10
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (794,795,796,797,798,799,800,801,802)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (794,795,796,797,798,799,800,801,802)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (794,795,796,797,798,799,800,801,802)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (794,795,796,797,798,799,800,801,802))
	Where IdCuenta = 793

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-21%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-21%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-21%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-21%')
	Where IdCuenta = 804

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-22%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-22%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-22%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-22%')
	Where IdCuenta = 805

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-23%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-23%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-23%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-23%')
	Where IdCuenta = 806

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-24%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-24%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-24%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-24%')
	Where IdCuenta = 807

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-25%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-25%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-25%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-25%')
	Where IdCuenta = 808

		-----81100-20
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (804,805,806,807,808)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (804,805,806,807,808)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (804,805,806,807,808)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (804,805,806,807,808))
	Where IdCuenta = 803

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-31%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-31%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-31%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-31%')
	Where IdCuenta = 810

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-32%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-32%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-32%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-32%')
	Where IdCuenta = 811

	-----81100-30
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (810,811)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (810,811)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (810,811)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (810,811))
	Where IdCuenta = 809

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-41%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-41%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-41%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-41%')
	Where IdCuenta = 813

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-42%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-42%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-42%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-42%')
	Where IdCuenta = 814

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-43%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-43%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-43%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-43%')
	Where IdCuenta = 815

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-44%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-44%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-44%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-44%')
	Where IdCuenta = 816

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-45%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-45%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-45%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-45%')
	Where IdCuenta = 817

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-46%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-46%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-46%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-46%')
	Where IdCuenta = 818

	-----81100-40
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (813,814,815,816,817,818)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (813,814,815,816,817,818)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (813,814,815,816,817,818)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (813,814,815,816,817,818))
	Where IdCuenta = 812

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-51%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-51%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-51%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-51%')
	Where IdCuenta = 820

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-52%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-52%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-52%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-52%')
	Where IdCuenta = 821

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-53%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-53%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-53%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-53%')
	Where IdCuenta = 822

	-----81100-50
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (820,821,822)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (820,821,822)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (820,821,822)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (820,821,822))
	Where IdCuenta = 819

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-61%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-61%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-61%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-61%')
	Where IdCuenta = 824

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-62%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-62%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-62%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-62%')
	Where IdCuenta = 825

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-63%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-63%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-63%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-63%')
	Where IdCuenta = 826

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-64%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-64%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-64%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-64%')
	Where IdCuenta = 827

	-----81100-60
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (824,825,826,827)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (824,825,826,827)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (824,825,826,827)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (824,825,826,827))
	Where IdCuenta = 823

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-71%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-71%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-71%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-71%')
	Where IdCuenta = 829

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-72%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-72%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-72%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-72%')
	Where IdCuenta = 830

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-73%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-73%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-73%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-73%')
	Where IdCuenta = 831

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-74%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-74%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-74%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-74%')
	Where IdCuenta = 832

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-75%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-75%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-75%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-75%')
	Where IdCuenta = 833

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-76%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-76%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-76%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-76%')
	Where IdCuenta = 834


				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-77%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-77%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-77%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-77%')
	Where IdCuenta = 835

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-78%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-78%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-78%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-78%')
	Where IdCuenta = 836

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-79%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-79%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-79%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-79%')
	Where IdCuenta = 837

	-----81100-70
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (829,830,831,832,833,834,835,836,837)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (829,830,831,832,833,834,835,836,837)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (829,830,831,832,833,834,835,836,837)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (829,830,831,832,833,834,835,836,837))
	Where IdCuenta = 828

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-81%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-81%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-81%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-81%')
	Where IdCuenta = 839

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-82%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-82%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-82%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-82%')
	Where IdCuenta = 840

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-83%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-83%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-83%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-83%')
	Where IdCuenta = 841

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-84%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-84%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-84%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-84%')
	Where IdCuenta = 842

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-85%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-85%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-85%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-85%')
	Where IdCuenta = 843

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-86%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-86%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-86%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-86%')
	Where IdCuenta = 844

	-----81100-80
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (839,840,841,842,843,844)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (839,840,841,842,843,844)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (839,840,841,842,843,844)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (839,840,841,842,843,844))
	Where IdCuenta = 838

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-91%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-91%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-91%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-91%')
	Where IdCuenta = 846

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-92%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-92%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-92%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-92%')
	Where IdCuenta = 847

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-93%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-93%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-93%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-93%')
	Where IdCuenta = 848

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-94%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-94%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-94%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-94%')
	Where IdCuenta = 849

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-95%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-95%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-95%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-95%')
	Where IdCuenta = 850

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-96%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-96%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-96%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-96%')
	Where IdCuenta = 851

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-97%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-97%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-97%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-97%')
	Where IdCuenta = 852

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-98%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-98%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-98%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-98%')
	Where IdCuenta = 853

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-99%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-99%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-99%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-99%')
	Where IdCuenta = 854

	-----81100-90
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (846,847,848,849,850,851,852,853,854)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (846,847,848,849,850,851,852,853,854)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (846,847,848,849,850,851,852,853,854)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (846,847,848,849,850,851,852,853,854))
	Where IdCuenta = 845

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-01%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-01%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-01%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-01%')
	Where IdCuenta = 856

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-02%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-02%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-02%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-02%')
	Where IdCuenta = 857
				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-03%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-03%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-03%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81100-03%')
	Where IdCuenta = 858

-----81100-00
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (856,857,858)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (856,857,858)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (856,857,858)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (856,857,858))
	Where IdCuenta = 855
----------------------------------------------------------------------------------------------------------------
---------------------------------------------------81200--------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-11%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-11%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-11%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-11%')
	Where IdCuenta = 861

		UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-12%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-12%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-12%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-12%')
	Where IdCuenta = 862

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-13%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-13%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-13%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-13%')
	Where IdCuenta = 863

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-14%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-14%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-14%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-14%')
	Where IdCuenta = 864

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-15%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-15%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-15%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-15%')
	Where IdCuenta = 865

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-16%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-16%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-16%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-16%')
	Where IdCuenta = 866

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-17%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-17%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-17%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-17%')
	Where IdCuenta = 867

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-18%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-18%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-18%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-18%')
	Where IdCuenta = 868

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-19%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-19%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-19%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-19%')
	Where IdCuenta = 869

-----81200-10
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (861,862,863,864,865,866,867,868,869)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (861,862,863,864,865,866,867,868,869)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (861,862,863,864,865,866,867,868,869)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (861,862,863,864,865,866,867,868,869))
	Where IdCuenta = 860

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-21%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-21%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-21%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-21%')
	Where IdCuenta = 871

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-22%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-22%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-22%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-22%')
	Where IdCuenta = 872

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-23%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-23%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-23%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-23%')
	Where IdCuenta = 873

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-24%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-24%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-24%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-24%')
	Where IdCuenta = 874

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-25%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-25%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-25%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-25%')
	Where IdCuenta = 875

	-----81200-20
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (871,872,873,874,875)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (871,872,873,874,875)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (871,872,873,874,875)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (871,872,873,874,875))
	Where IdCuenta = 870

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-31%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-31%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-31%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-31%')
	Where IdCuenta = 877

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-32%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-32%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-32%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-32%')
	Where IdCuenta = 878

	-----81200-30
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (877,878)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (877,878)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (877,878)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (877,878))
	Where IdCuenta = 876

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-41%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-41%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-41%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-41%')
	Where IdCuenta = 880

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-42%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-42%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-42%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-42%')
	Where IdCuenta = 881

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-43%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-43%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-43%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-43%')
	Where IdCuenta = 882

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-44%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-44%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-44%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-44%')
	Where IdCuenta = 883

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-45%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-45%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-45%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-45%')
	Where IdCuenta = 884

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-46%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-46%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-46%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-46%')
	Where IdCuenta = 885

	-----81200-40
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (880,881,882,883,884,885)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (880,881,882,883,884,885)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (880,881,882,883,884,885)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (880,881,882,883,884,885))
	Where IdCuenta = 879

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-51%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-51%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-51%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-51%')
	Where IdCuenta = 887

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-52%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-52%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-52%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-52%')
	Where IdCuenta = 888

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-53%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-53%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-53%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-53%')
	Where IdCuenta = 889

		-----81200-50
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (887,888,889)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (887,888,889)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (887,888,889)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (887,888,889))
	Where IdCuenta = 886

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-61%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-61%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-61%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-61%')
	Where IdCuenta = 891

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-62%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-62%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-62%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-62%')
	Where IdCuenta = 892

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-63%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-63%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-63%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-63%')
	Where IdCuenta = 893

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-64%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-64%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-64%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-64%')
	Where IdCuenta = 894

		-----81200-60
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (891,892,893,894)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (891,892,893,894)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (891,892,893,894)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (891,892,893,894))
	Where IdCuenta = 890

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-71%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-71%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-71%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-71%')
	Where IdCuenta = 896

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-72%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-72%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-72%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-72%')
	Where IdCuenta = 897

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-73%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-73%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-73%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-73%')
	Where IdCuenta = 898

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-74%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-74%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-74%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-74%')
	Where IdCuenta = 899

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-75%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-75%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-75%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-75%')
	Where IdCuenta = 900

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-76%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-76%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-76%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-76%')
	Where IdCuenta = 901


				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-77%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-77%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-77%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-77%')
	Where IdCuenta = 902

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-78%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-78%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-78%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-78%')
	Where IdCuenta = 903

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-79%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-79%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-79%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-79%')
	Where IdCuenta = 904

		-----81200-70
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (896,897,898,899,900,901,902,903,904)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (896,897,898,899,900,901,902,903,904)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (896,897,898,899,900,901,902,903,904)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (896,897,898,899,900,901,902,903,904))
	Where IdCuenta = 895

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-81%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-81%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-81%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-81%')
	Where IdCuenta = 906

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-82%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-82%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-82%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-82%')
	Where IdCuenta = 907

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-83%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-83%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-83%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-83%')
	Where IdCuenta = 908

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-84%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-84%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-84%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-84%')
	Where IdCuenta = 909

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-85%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-85%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-85%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-85%')
	Where IdCuenta = 910

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-86%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-86%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-86%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-86%')
	Where IdCuenta = 911

		-----81200-80
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (906,907,908,909,910,911)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (906,907,908,909,910,911)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (906,907,908,909,910,911)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (906,907,908,909,910,911))
	Where IdCuenta = 905

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-91%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-91%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-91%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-91%')
	Where IdCuenta = 913

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-92%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-92%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-92%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-92%')
	Where IdCuenta = 914

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-93%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-93%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-93%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-93%')
	Where IdCuenta = 915

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-94%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-94%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-94%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-94%')
	Where IdCuenta = 916

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-95%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-95%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-95%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-95%')
	Where IdCuenta = 917

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-96%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-96%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-96%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-96%')
	Where IdCuenta = 918

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-97%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-97%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-97%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-97%')
	Where IdCuenta = 919

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-98%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-98%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-98%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-98%')
	Where IdCuenta = 920

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-99%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-99%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-99%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-99%')
	Where IdCuenta = 921

	-----81200-90
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (913,914,915,916,917,918,919,920,921)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (913,914,915,916,917,918,919,920,921)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (913,914,915,916,917,918,919,920,921)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (913,914,915,916,917,918,919,920,921))
	Where IdCuenta = 912

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-01%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-01%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-01%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-01%')
	Where IdCuenta = 923

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-02%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-02%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-02%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-02%')
	Where IdCuenta = 924
				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-03%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-03%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-03%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81200-03%')
	Where IdCuenta = 925

	-----81200-00
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (923,924,925)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (923,924,925)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (923,924,925)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (923,924,925))
	Where IdCuenta = 922
----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------81300--------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-11%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-11%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-11%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-11%')
	Where IdCuenta = 928

		UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-12%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-12%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-12%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-12%')
	Where IdCuenta = 929

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-13%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-13%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-13%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-13%')
	Where IdCuenta = 930

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-14%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-14%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-14%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-14%')
	Where IdCuenta = 931

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-15%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-15%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-15%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-15%')
	Where IdCuenta = 932

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-16%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-16%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-16%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-16%')
	Where IdCuenta = 933

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-17%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-17%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-17%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-17%')
	Where IdCuenta = 934

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-18%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-18%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-18%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-18%')
	Where IdCuenta = 935

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-19%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-19%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-19%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-19%')
	Where IdCuenta = 936

	-----81300-10
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (928,929,930,931,932,933,934,935,936)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (928,929,930,931,932,933,934,935,936)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (928,929,930,931,932,933,934,935,936)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (928,929,930,931,932,933,934,935,936))
	Where IdCuenta = 927

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-21%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-21%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-21%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-21%')
	Where IdCuenta = 938

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-22%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-22%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-22%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-22%')
	Where IdCuenta = 939

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-23%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-23%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-23%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-23%')
	Where IdCuenta = 940

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-24%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-24%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-24%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-24%')
	Where IdCuenta = 941

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-25%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-25%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-25%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-25%')
	Where IdCuenta = 942

	-----81300-20
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (938,939,940,941,942)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (938,939,940,941,942)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (938,939,940,941,942)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (938,939,940,941,942))
	Where IdCuenta = 937

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-31%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-31%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-31%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-31%')
	Where IdCuenta = 944

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-32%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-32%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-32%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-32%')
	Where IdCuenta = 945

	-----81300-30
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (944,945)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (944,945)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (944,945)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (944,945))
	Where IdCuenta = 943

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-41%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-41%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-41%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-41%')
	Where IdCuenta = 947

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-42%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-42%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-42%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-42%')
	Where IdCuenta = 948

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-43%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-43%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-43%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-43%')
	Where IdCuenta = 949

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-44%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-44%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-44%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-44%')
	Where IdCuenta = 950

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-45%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-45%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-45%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-45%')
	Where IdCuenta = 951

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-46%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-46%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-46%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-46%')
	Where IdCuenta = 952

	-----81300-40
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (947,948,949,950,951,952)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (947,948,949,950,951,952)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (947,948,949,950,951,952)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (947,948,949,950,951,952))
	Where IdCuenta = 946

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-51%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-51%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-51%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-51%')
	Where IdCuenta = 954

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-52%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-52%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-52%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-52%')
	Where IdCuenta = 955

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-53%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-53%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-53%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-53%')
	Where IdCuenta = 956

	-----81300-50
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (954,955,956)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (954,955,956)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (954,955,956)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (954,955,956))
	Where IdCuenta = 953

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-61%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-61%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-61%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-61%')
	Where IdCuenta = 958

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-62%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-62%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-62%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-62%')
	Where IdCuenta = 959

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-63%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-63%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-63%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-63%')
	Where IdCuenta = 960

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-64%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-64%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-64%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-64%')
	Where IdCuenta = 961

-----81300-60
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (958,959,960,961)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (958,959,960,961)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (958,959,960,961)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (958,959,960,961))
	Where IdCuenta = 957

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-71%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-71%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-71%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-71%')
	Where IdCuenta = 963

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-72%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-72%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-72%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-72%')
	Where IdCuenta = 964

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-73%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-73%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-73%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-73%')
	Where IdCuenta = 965

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-74%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-74%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-74%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-74%')
	Where IdCuenta = 966

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-75%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-75%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-75%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-75%')
	Where IdCuenta = 967

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-76%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-76%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-76%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-76%')
	Where IdCuenta = 968


				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-77%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-77%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-77%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-77%')
	Where IdCuenta = 969

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-78%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-78%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-78%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-78%')
	Where IdCuenta = 970

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-79%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-79%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-79%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-79%')
	Where IdCuenta = 971

-----81300-70
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (963,964,965,966,967,968,969,970,971)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (963,964,965,966,967,968,969,970,971)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (963,964,965,966,967,968,969,970,971)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (963,964,965,966,967,968,969,970,971))
	Where IdCuenta = 962

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-81%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-81%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-81%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-81%')
	Where IdCuenta = 973

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-82%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-82%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-82%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-82%')
	Where IdCuenta = 974

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-83%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-83%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-83%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-83%')
	Where IdCuenta = 975

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-84%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-84%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-84%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-84%')
	Where IdCuenta = 976

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-85%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-85%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-85%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-85%')
	Where IdCuenta = 977

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-86%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-86%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-86%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-86%')
	Where IdCuenta = 978

-----81300-80
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (973,974,975,976,977,978)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (973,974,975,976,977,978)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (973,974,975,976,977,978)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (973,974,975,976,977,978))
	Where IdCuenta = 972

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-91%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-91%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-91%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-91%')
	Where IdCuenta = 980

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-92%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-92%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-92%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-92%')
	Where IdCuenta = 981

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-93%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-93%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-93%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-93%')
	Where IdCuenta = 982

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-94%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-94%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-94%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-94%')
	Where IdCuenta = 983

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-95%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-95%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-95%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-95%')
	Where IdCuenta = 984

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-96%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-96%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-96%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-96%')
	Where IdCuenta = 985

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-97%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-97%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-97%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-97%')
	Where IdCuenta = 986

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-98%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-98%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-98%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-98%')
	Where IdCuenta = 987

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-99%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-99%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-99%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-99%')
	Where IdCuenta = 988

-----81300-90
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (980,981,982,983,984,985,986,987,988)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (980,981,982,983,984,985,986,987,988)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (980,981,982,983,984,985,986,987,988)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (980,981,982,983,984,985,986,987,988))
	Where IdCuenta = 979

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-01%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-01%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-01%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-01%')
	Where IdCuenta = 990

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-02%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-02%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-02%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-02%')
	Where IdCuenta = 991
				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-03%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-03%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-03%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81300-03%')
	Where IdCuenta = 992

-----81300-00
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (990,991,992)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (990,991,992)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (990,991,992)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (990,991,992))
	Where IdCuenta = 989
----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------81400--------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-11%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-11%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-11%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-11%')
	Where IdCuenta = 995

		UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-12%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-12%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-12%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-12%')
	Where IdCuenta = 996

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-13%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-13%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-13%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-13%')
	Where IdCuenta = 997

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-14%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-14%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-14%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-14%')
	Where IdCuenta = 998

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-15%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-15%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-15%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-15%')
	Where IdCuenta = 999

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-16%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-16%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-16%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-16%')
	Where IdCuenta = 1000

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-17%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-17%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-17%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-17%')
	Where IdCuenta = 1001

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-18%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-18%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-18%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-18%')
	Where IdCuenta = 1002

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-19%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-19%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-19%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-19%')
	Where IdCuenta = 1003

-----81400-10
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (995,996,997,998,999,1000,1001,1002,1003)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (995,996,997,998,999,1000,1001,1002,1003)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (995,996,997,998,999,1000,1001,1002,1003)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (995,996,997,998,999,1000,1001,1002,1003))
	Where IdCuenta = 994

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-21%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-21%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-21%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-21%')
	Where IdCuenta = 1005

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-22%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-22%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-22%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-22%')
	Where IdCuenta = 1006

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-23%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-23%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-23%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-23%')
	Where IdCuenta = 1007

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-24%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-24%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-24%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-24%')
	Where IdCuenta = 1008

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-25%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-25%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-25%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-25%')
	Where IdCuenta = 1009

-----81400-20
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1005,1006,1007,1008,1009)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1005,1006,1007,1008,1009)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1005,1006,1007,1008,1009)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1005,1006,1007,1008,1009))
	Where IdCuenta = 1004

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-31%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-31%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-31%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-31%')
	Where IdCuenta = 1011

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-32%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-32%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-32%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-32%')
	Where IdCuenta = 1012

-----81400-30
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1011,1012)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1011,1012)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1011,1012)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1011,1012))
	Where IdCuenta = 1010

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-41%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-41%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-41%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-41%')
	Where IdCuenta = 1014

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-42%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-42%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-42%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-42%')
	Where IdCuenta = 1015

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-43%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-43%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-43%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-43%')
	Where IdCuenta = 1016

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-44%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-44%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-44%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-44%')
	Where IdCuenta = 1017

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-45%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-45%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-45%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-45%')
	Where IdCuenta = 1018

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-46%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-46%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-46%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-46%')
	Where IdCuenta = 1019

-----81400-40
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1014,1015,1016,1017,1018,1019)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1014,1015,1016,1017,1018,1019)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1014,1015,1016,1017,1018,1019)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1014,1015,1016,1017,1018,1019))
	Where IdCuenta = 1013

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-51%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-51%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-51%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-51%')
	Where IdCuenta = 1021

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-52%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-52%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-52%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-52%')
	Where IdCuenta = 1022

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-53%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-53%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-53%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-53%')
	Where IdCuenta = 1023

-----81400-50
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1021,1022,1023)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1021,1022,1023)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1021,1022,1023)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1021,1022,1023))
	Where IdCuenta = 1020

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-61%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-61%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-61%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-61%')
	Where IdCuenta = 1025

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-62%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-62%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-62%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-62%')
	Where IdCuenta = 1026

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-63%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-63%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-63%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-63%')
	Where IdCuenta = 1027

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-64%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-64%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-64%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-64%')
	Where IdCuenta = 1028

	-----81400-60
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1025,1026,1027,1028)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1025,1026,1027,1028)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1025,1026,1027,1028)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1025,1026,1027,1028))
	Where IdCuenta = 1024

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-71%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-71%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-71%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-71%')
	Where IdCuenta = 1030

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-72%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-72%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-72%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-72%')
	Where IdCuenta = 1031

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-73%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-73%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-73%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-73%')
	Where IdCuenta = 1032

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-74%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-74%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-74%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-74%')
	Where IdCuenta = 1033

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-75%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-75%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-75%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-75%')
	Where IdCuenta = 1034

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-76%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-76%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-76%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-76%')
	Where IdCuenta = 1035


				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-77%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-77%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-77%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-77%')
	Where IdCuenta = 1036

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-78%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-78%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-78%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-78%')
	Where IdCuenta = 1037

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-79%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-79%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-79%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-79%')
	Where IdCuenta = 1038

	-----81400-70
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1030,1031,1032,1033,1034,1035,1036,1037,1038)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1030,1031,1032,1033,1034,1035,1036,1037,1038)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1030,1031,1032,1033,1034,1035,1036,1037,1038)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1030,1031,1032,1033,1034,1035,1036,1037,1038))
	Where IdCuenta = 1029

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-81%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-81%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-81%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-81%')
	Where IdCuenta = 1040

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-82%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-82%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-82%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-82%')
	Where IdCuenta = 1041

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-83%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-83%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-83%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-83%')
	Where IdCuenta = 1042

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-84%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-84%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-84%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-84%')
	Where IdCuenta = 1043

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-85%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-85%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-85%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-85%')
	Where IdCuenta = 1044

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-86%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-86%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-86%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-86%')
	Where IdCuenta = 1045

	-----81400-80
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1040,1041,1042,1043,1044,1045)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1040,1041,1042,1043,1044,1045)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1040,1041,1042,1043,1044,1045)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1040,1041,1042,1043,1044,1045))
	Where IdCuenta = 1039

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-91%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-91%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-91%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-91%')
	Where IdCuenta = 1047

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-92%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-92%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-92%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-92%')
	Where IdCuenta = 1048

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-93%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-93%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-93%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-93%')
	Where IdCuenta = 1049

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-94%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-94%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-94%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-94%')
	Where IdCuenta = 1050

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-95%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-95%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-95%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-95%')
	Where IdCuenta = 1051

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-96%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-96%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-96%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-96%')
	Where IdCuenta = 1052

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-97%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-97%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-97%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-97%')
	Where IdCuenta = 1053

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-98%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-98%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-98%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-98%')
	Where IdCuenta = 1054

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-99%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-99%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-99%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-99%')
	Where IdCuenta = 1055

	-----81400-90
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1047,1048,1049,1050,1051,1052,1053,1054,1055)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1047,1048,1049,1050,1051,1052,1053,1054,1055)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1047,1048,1049,1050,1051,1052,1053,1054,1055)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1047,1048,1049,1050,1051,1052,1053,1054,1055))
	Where IdCuenta = 1046

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-01%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-01%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-01%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-01%')
	Where IdCuenta = 1057

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-02%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-02%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-02%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-02%')
	Where IdCuenta = 1058

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-03%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-03%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-03%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81400-03%')
	Where IdCuenta = 1059

	-----81400-00
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1057,1058,1059)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1057,1058,1059)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1057,1058,1059)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1057,1058,1059))
	Where IdCuenta = 1056
----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------81500--------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-11%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-11%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-11%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-11%')
	Where IdCuenta = 1062

		UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-12%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-12%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-12%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-12%')
	Where IdCuenta = 1063

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-13%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-13%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-13%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-13%')
	Where IdCuenta = 1064

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-14%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-14%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-14%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-14%')
	Where IdCuenta = 1065

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-15%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-15%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-15%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-15%')
	Where IdCuenta = 1066

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-16%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-16%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-16%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-16%')
	Where IdCuenta = 1067

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-17%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-17%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-17%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-17%')
	Where IdCuenta = 1068

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-18%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-18%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-18%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-18%')
	Where IdCuenta = 1069

			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-19%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-19%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-19%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-19%')
	Where IdCuenta = 1070

	-----81500-10
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1062,1063,1064,1065,1066,1067,1068,1069,1070)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1062,1063,1064,1065,1066,1067,1068,1069,1070)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1062,1063,1064,1065,1066,1067,1068,1069,1070)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1062,1063,1064,1065,1066,1067,1068,1069,1070))
	Where IdCuenta = 1061

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-21%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-21%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-21%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-21%')
	Where IdCuenta = 1072

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-22%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-22%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-22%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-22%')
	Where IdCuenta = 1073

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-23%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-23%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-23%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-23%')
	Where IdCuenta = 1074

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-24%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-24%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-24%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-24%')
	Where IdCuenta = 1075

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-25%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-25%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-25%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-25%')
	Where IdCuenta = 1076

	-----81500-20
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1072,1073,1074,1075,1076)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1072,1073,1074,1075,1076)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1072,1073,1074,1075,1076)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1072,1073,1074,1075,1076))
	Where IdCuenta = 1071

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-31%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-31%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-31%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-31%')
	Where IdCuenta = 1078

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-32%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-32%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-32%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-32%')
	Where IdCuenta = 1079

	-----81500-30
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1078,1079)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1078,1079)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1078,1079)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1078,1079))
	Where IdCuenta = 1077

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-41%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-41%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-41%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-41%')
	Where IdCuenta = 1081

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-42%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-42%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-42%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-42%')
	Where IdCuenta = 1082

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-43%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-43%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-43%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-43%')
	Where IdCuenta = 1083

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-44%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-44%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-44%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-44%')
	Where IdCuenta = 1084

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-45%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-45%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-45%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-45%')
	Where IdCuenta = 1085

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-46%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-46%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-46%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-46%')
	Where IdCuenta = 1086

	-----81500-40
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1081,1082,1083,1084,1085,1086)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1081,1082,1083,1084,1085,1086)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1081,1082,1083,1084,1085,1086)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1081,1082,1083,1084,1085,1086))
	Where IdCuenta = 1080

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-51%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-51%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-51%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-51%')
	Where IdCuenta = 1088

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-52%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-52%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-52%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-52%')
	Where IdCuenta = 1089

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-53%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-53%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-53%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-53%')
	Where IdCuenta = 1090

	-----81500-50
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1088,1089,1090)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1088,1089,1090)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1088,1089,1090)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1088,1089,1090))
	Where IdCuenta = 1087

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-61%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-61%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-61%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-61%')
	Where IdCuenta = 1092

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-62%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-62%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-62%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-62%')
	Where IdCuenta = 1093

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-63%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-63%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-63%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-63%')
	Where IdCuenta = 1094

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-64%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-64%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-64%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-64%')
	Where IdCuenta = 1095

	-----81500-60
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1092,1093,1094,1095)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1092,1093,1094,1095)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1092,1093,1094,1095)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1092,1093,1094,1095))
	Where IdCuenta = 1091

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-71%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-71%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-71%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-71%')
	Where IdCuenta = 1097

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-72%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-72%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-72%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-72%')
	Where IdCuenta = 1098

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-73%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-73%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-73%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-73%')
	Where IdCuenta = 1099

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-74%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-74%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-74%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-74%')
	Where IdCuenta = 1100

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-75%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-75%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-75%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-75%')
	Where IdCuenta = 1101

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-76%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-76%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-76%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-76%')
	Where IdCuenta = 1102


				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-77%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-77%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-77%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-77%')
	Where IdCuenta = 1103

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-78%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-78%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-78%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-78%')
	Where IdCuenta = 1104

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-79%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-79%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-79%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-79%')
	Where IdCuenta = 1105

	-----81500-70
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1097,1098,1099,1100,1101,1102,1103,1104,1105)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1097,1098,1099,1100,1101,1102,1103,1104,1105)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1097,1098,1099,1100,1101,1102,1103,1104,1105)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1097,1098,1099,1100,1101,1102,1103,1104,1105))
	Where IdCuenta = 1096

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-81%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-81%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-81%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-81%')
	Where IdCuenta = 1107

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-82%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-82%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-82%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-82%')
	Where IdCuenta = 1108

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-83%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-83%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-83%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-83%')
	Where IdCuenta = 1109

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-84%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-84%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-84%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-84%')
	Where IdCuenta = 1110

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-85%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-85%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-85%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-85%')
	Where IdCuenta = 1111

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-86%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-86%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-86%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-86%')
	Where IdCuenta = 1112

	-----81500-80
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1107,1108,1109,1110,1111,1112)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1107,1108,1109,1110,1111,1112)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1107,1108,1109,1110,1111,1112)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1107,1108,1109,1110,1111,1112))
	Where IdCuenta = 1106

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-91%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-91%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-91%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-91%')
	Where IdCuenta = 1114

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-92%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-92%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-92%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-92%')
	Where IdCuenta = 1115

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-93%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-93%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-93%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-93%')
	Where IdCuenta = 1116

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-94%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-94%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-94%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-94%')
	Where IdCuenta = 1117

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-95%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-95%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-95%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-95%')
	Where IdCuenta = 1118

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-96%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-96%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-96%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-96%')
	Where IdCuenta = 1119

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-97%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-97%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-97%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-97%')
	Where IdCuenta = 1120

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-98%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-98%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-98%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-98%')
	Where IdCuenta = 1121

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-99%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-99%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-99%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-99%')
	Where IdCuenta = 1122

	-----81500-90
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1114,1115,1116,1117,1118,1119,1120,1121,1122)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1114,1115,1116,1117,1118,1119,1120,1121,1122)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1114,1115,1116,1117,1118,1119,1120,1121,1122)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1114,1115,1116,1117,1118,1119,1120,1121,1122))
	Where IdCuenta = 1113

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-01%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-01%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-01%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-01%')
	Where IdCuenta = 1124

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-02%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-02%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-02%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-02%')
	Where IdCuenta = 1125

				UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-03%'),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-03%'),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-03%'),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM #BalanzaAcu  Where  NumeroCuenta like '81500-03%')
	Where IdCuenta = 1126

	-----81500-00
			UPDATE [dbo].[C_BalanzaASEJ] SET
	CargosSinFlujo = (Select ISNULL(SUM(CargosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1124,1125,1126)),
	AbonosSinFlujo = (Select ISNULL(SUM(AbonosSinFlujo),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1124,1125,1126)),
	TotalCargos = (Select ISNULL(SUM(TotalCargos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1124,1125,1126)),
	TotalAbonos = (Select ISNULL(SUM(TotalAbonos),0) FROM [dbo].[C_BalanzaASEJ]  Where  IdCuenta in (1124,1125,1126))
	Where IdCuenta = 1123

-------------------------------------------------------------------------82000------------------------------------------------

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos = (Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1130

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1131
	-----------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1132

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1133
--------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1134

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1135
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1136

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1137
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1138

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1139
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1140

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1141
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1142

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1143
---------------------------------------------------------200
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1145

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1146
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1147

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1148
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1149

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1150
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1151

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1152
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1153

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1154
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1155

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1156
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1157

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1158
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1159

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1160
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1161

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1162
---------------------------------------------------------300
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1164

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1165
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1166

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1167
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1168

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1169
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1170

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1171
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1172

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1173
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1174

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1175
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1176

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1177
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1178

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1179
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1180

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1181
---------------------------------------------------------400
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1183

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1184
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1185

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1186
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1187

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1188
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1189

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1190
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1191

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1192
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1193

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1194
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1195

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1196
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1197

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1198
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1199

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1200
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1202

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1203
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1204

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1205
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1206

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1207
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1208

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1209
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1210

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1211
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1212

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1213
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1214

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1215
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1216

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1217
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1218

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1219
---------------------------------------------------------600
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1221

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1222
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1223

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1224
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1225

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1226
---------------------------------------------------------700
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1228

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1229
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1230

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1231
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1232

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1233
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1234

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1235
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1236

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1237
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1238

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1239
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1240

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1241
---------------------------------------------------------800
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1243

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1244
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1245

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1246
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1247

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1248
---------------------------------------------------------900
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1250

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1251
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1252

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1253
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1254

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1255
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1256

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1257
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1258

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1259
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1260

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1261
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '821%')
	Where IdCuenta = 1262

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '821%')
	Where IdCuenta = 1263

--Select * from @Balanza

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82000','PRESUPUESTO DE EGRESOS',
	CargosSinFlujo =(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82%')
	Where IdCuenta = 1127

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100','PRESUPUESTO DE EGRESOS',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '821%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '821%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '821%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '821%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '821%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '821%')
	Where IdCuenta = 1128

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-100','Servicios personales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-1%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-1%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-1%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-1%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-1%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-1%')
	Where IdCuenta = 1129

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-200','Materiales y suministros',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-2%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-2%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-2%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-2%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-2%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-2%')
	Where IdCuenta = 1144

		UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-300','Servicios generales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-3%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-3%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-3%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-3%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-3%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-3%')
	Where IdCuenta = 1163

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-400','Transferencias, asignaciones, subsidios y otras ayudas ',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-4%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-4%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-4%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-4%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-4%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-4%')
	Where IdCuenta = 1182

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-500','Bienes muebles, inmuebles e intangibles',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-5%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-5%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-5%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-5%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-5%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-5%')
	Where IdCuenta = 1201

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-600','Inversión pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-6%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-6%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-6%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-6%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-6%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-6%')
	Where IdCuenta = 1220

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-700','Inversiones financieras y otras provisiones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-7%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-7%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-7%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-7%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-7%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-7%')
	Where IdCuenta = 1227

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-800','Participaciones y aportaciones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-8%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-8%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-8%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-8%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-8%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-8%')
	Where IdCuenta = 1242

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-900','Deuda pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-9%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-9%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-9%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-9%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-9%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82100-9%')
	Where IdCuenta = 1249

------------------------------------------------------------------82200----------------------------------------------------------------------------------------------------------------------------
UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos = (Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1266

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1267
	-----------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1268

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1269
--------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1270

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1271
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1272

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1273
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1274

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1275
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1276

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1277
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1278

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1279
---------------------------------------------------------200
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1281

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1282
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1283

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1284
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1285

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1286
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1287

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1288
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1289

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1290
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1291

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1292
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1293

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1294
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1295

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1296
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1297

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1298
---------------------------------------------------------300
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1300

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1301
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1302

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1303
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1304

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1305
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1306

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1307
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1308

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1309
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1310

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1311
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1312

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1313
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1314

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1315
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1316

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1317
---------------------------------------------------------400
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1319

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1320
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1321

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1322
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1323

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1324
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1325

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1326
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1327

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1328
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1329

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1330
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1331

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1332
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1333

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1334
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1335

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1336
---------------------------------------------------------500
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1338

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1339
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1340

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1341
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1342

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1343
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1344

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1345
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1346

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1347
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1348

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1349
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1350

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1351
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1352

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1353
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1354

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1355
---------------------------------------------------------600
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1357

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1358
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1359

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1360
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1361

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1362
---------------------------------------------------------700
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1364

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1365
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1366

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1367
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1368

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1369
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1370

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1371
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1372

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1373
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1374

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1375
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1376

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1377
---------------------------------------------------------800
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1379

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1380
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1381

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1382
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1383

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1384
---------------------------------------------------------900
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1386

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1387
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1388

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1389
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1390

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1391
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1392

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1393
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1394

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1395
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1396

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1397
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '822%')
	Where IdCuenta = 1398

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '822%')
	Where IdCuenta = 1399

	---------Totales

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100','PRESUPUESTO DE EGRESOS',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '822%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '822%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '822%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '822%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '822%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '822%')
	Where IdCuenta = 1264

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-100','Servicios personales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-1%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-1%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-1%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-1%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-1%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-1%')
	Where IdCuenta = 1265

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-200','Materiales y suministros',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-2%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-2%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-2%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-2%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-2%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-2%')
	Where IdCuenta = 1280

		UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-300','Servicios generales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-3%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-3%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-3%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-3%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-3%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-3%')
	Where IdCuenta = 1299

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-400','Transferencias, asignaciones, subsidios y otras ayudas ',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-4%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-4%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-4%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-4%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-4%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-4%')
	Where IdCuenta = 1318

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-500','Bienes muebles, inmuebles e intangibles',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-5%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-5%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-5%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-5%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-5%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-5%')
	Where IdCuenta = 1337

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-600','Inversión pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-6%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-6%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-6%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-6%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-6%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-6%')
	Where IdCuenta = 1356

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-700','Inversiones financieras y otras provisiones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-7%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-7%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-7%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-7%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-7%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-7%')
	Where IdCuenta = 1363

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-800','Participaciones y aportaciones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-8%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-8%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-8%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-8%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-8%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-8%')
	Where IdCuenta = 1378

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-900','Deuda pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-9%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-9%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-9%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-9%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-9%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82200-9%')
	Where IdCuenta = 1385
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------82300----------------------------------------------------------------------------------------------------------------------------
UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos = (Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1402

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1403
	-----------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1404

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1405
--------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1406

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1407
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1408

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1409
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1410

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1411
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1412

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1413
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1414

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1415
---------------------------------------------------------200
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1417

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1418
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1419

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1420
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1421

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1422
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1423

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1424
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1425

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1426
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1427

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1428
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1429

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1430
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1431

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1432
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1433

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1434
---------------------------------------------------------300
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1436

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1437
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1438

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1439
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1440

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1441
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1442

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1443
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1444

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1445
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1446

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1447
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1448

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1449
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1450

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1451
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1452

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1453
---------------------------------------------------------400
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1455

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1456
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1457

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1458
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1459

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1460
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1461

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1462
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1463

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1464
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1465

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1466
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1467

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1468
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1469

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1470
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 11471

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1472
---------------------------------------------------------500
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1474

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1475
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1476

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1477
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1478

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1479
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1480

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1481
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1482

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1483
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1484

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1485
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1486

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1487
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1488

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1489
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1490

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1491
---------------------------------------------------------600
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1493

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1494
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1495

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1496
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1497

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1498
---------------------------------------------------------700
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1500

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1501
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1502

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1503
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1504

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1505
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1506

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1507
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1508

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1509
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1510

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1511
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1512

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1513
---------------------------------------------------------800
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1515

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1516
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1517

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1518
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1519

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1520
---------------------------------------------------------900
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1522

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1523
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1524

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1525
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1526

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1527
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1528

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1529
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1530

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1531
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1532

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1533
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '823%')
	Where IdCuenta = 1534

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '823%')
	Where IdCuenta = 1535

	---------Totales

	--UPDATE [dbo].[C_BalanzaASEJ] SET
	----Select '82300','PRESUPUESTO DE EGRESOS',
	--CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%' ),
	--TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%')
	--Where IdCuenta = 1264

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82300-100','Servicios personales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-1%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-1%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-1%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-1%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-1%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-1%')
	Where IdCuenta = 1401

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-200','Materiales y suministros',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-2%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-2%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-2%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-2%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-2%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-2%')
	Where IdCuenta = 1416

		UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-300','Servicios generales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-3%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-3%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-3%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-3%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-3%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-3%')
	Where IdCuenta = 1435

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-400','Transferencias, asignaciones, subsidios y otras ayudas ',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-4%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-4%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-4%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-4%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-4%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-4%')
	Where IdCuenta = 1454

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-500','Bienes muebles, inmuebles e intangibles',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-5%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-5%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-5%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-5%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-5%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-5%')
	Where IdCuenta = 1473

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-600','Inversión pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-6%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-6%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-6%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-6%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-6%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-6%')
	Where IdCuenta = 1492

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-700','Inversiones financieras y otras provisiones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-7%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-7%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-7%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-7%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-7%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-7%')
	Where IdCuenta = 1499

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-800','Participaciones y aportaciones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-8%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-8%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-8%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-8%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-8%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-8%')
	Where IdCuenta = 1514

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-900','Deuda pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-9%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-9%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-9%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-9%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-9%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82300-9%')
	Where IdCuenta = 1521
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------82400----------------------------------------------------------------------------------------------------------------------------
UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos = (Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1538

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1539
	-----------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1540

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1541
--------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1542

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1543
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1544

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1545
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1546

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1547
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1548

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1549
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1550

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1551
---------------------------------------------------------200
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1553

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1554
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1555

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1556
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1557

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1558
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1559

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1560
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1561

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1562
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1563

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1564
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1565

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1566
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1567

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1568
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1569

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1570
---------------------------------------------------------300
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1572

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1573
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1574

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1575
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1576

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1577
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1578

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1579
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1580

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1581
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1582

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1583
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1584

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1585
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1586

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1587
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1588

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1589
---------------------------------------------------------400
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1591

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1592
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1593

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1594
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1595

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1596
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1597

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1598
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1599

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1600
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1601

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1602
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1603

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1604
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1605

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1606
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1607

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1608
---------------------------------------------------------500
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1610

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1611
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1612

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1613
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1614

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1615
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1616

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1617
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1618

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1619
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1620

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1621
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1622

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1623
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1624

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1625
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1626

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1627
---------------------------------------------------------600
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1629

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1630
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1631

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1632
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1633

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1634
---------------------------------------------------------700
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1636

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1637
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1638

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1639
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1640

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1641
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1642

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1643
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1644

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1645
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1646

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1647
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1648

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1649
---------------------------------------------------------800
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1651

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1652
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1653

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1654
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1655

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1656
---------------------------------------------------------900
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1658

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1659
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1660

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1661
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1662

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1663
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1664

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1665
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1666

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1667
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1668

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1669
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '824%')
	Where IdCuenta = 1670

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '824%')
	Where IdCuenta = 1671

	---------Totales

	--UPDATE [dbo].[C_BalanzaASEJ] SET
	----Select '82300','PRESUPUESTO DE EGRESOS',
	--CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%' ),
	--TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%')
	--Where IdCuenta = 1264

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82400-100','Servicios personales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-1%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-1%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-1%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-1%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-1%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-1%')
	Where IdCuenta = 1537

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82400-200','Materiales y suministros',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-2%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-2%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-2%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-2%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-2%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-2%')
	Where IdCuenta = 1552

		UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-300','Servicios generales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-3%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-3%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-3%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-3%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-3%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-3%')
	Where IdCuenta = 1571

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-400','Transferencias, asignaciones, subsidios y otras ayudas ',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-4%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-4%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-4%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-4%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-4%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-4%')
	Where IdCuenta = 1590

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-500','Bienes muebles, inmuebles e intangibles',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-5%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-5%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-5%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-5%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-5%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-5%')
	Where IdCuenta = 1609

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-600','Inversión pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-6%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-6%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-6%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-6%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-6%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-6%')
	Where IdCuenta = 1628

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-700','Inversiones financieras y otras provisiones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-7%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-7%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-7%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-7%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-7%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-7%')
	Where IdCuenta = 1635

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-800','Participaciones y aportaciones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-8%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-8%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-8%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-8%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-8%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-8%')
	Where IdCuenta = 1650

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-900','Deuda pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-9%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-9%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-9%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-9%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-9%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82400-9%')
	Where IdCuenta = 1657
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------82500----------------------------------------------------------------------------------------------------------------------------
UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos = (Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1674

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1675
	-----------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1676

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1677
--------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1678

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1679
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1680

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1681
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1682

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1683
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1684

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1685
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1686

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1687
---------------------------------------------------------200
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1689

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1690
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1691

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1692
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1693

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1694
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1695

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1696
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1697

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1698
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1699

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1700
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1701

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1702
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1703

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1704
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1705

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1706
---------------------------------------------------------300
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1708

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1709
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1710

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1711
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1712

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1713
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1714

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1715
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1716

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1717
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1718

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1719
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1720

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1721
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1722

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1723
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1724

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1725
---------------------------------------------------------400
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1727

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1728
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1729

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1730
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1731

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1732
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1733

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1734
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1735

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1736
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1737

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1738
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1739

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1740
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1741

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1742
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1743

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1744
---------------------------------------------------------500
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1746

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1747
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1748

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1749
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1750

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1751
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1752

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1753
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1754

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1755
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1756

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1757
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1758

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1759
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1760

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1761
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1762

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1763
---------------------------------------------------------600
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1765

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1766
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1767

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1768
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1769

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1770
---------------------------------------------------------700
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1772

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1773
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1774

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1775
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1776

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1777
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1778

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1779
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1780

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1781
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1782

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1783
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1784

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1785
---------------------------------------------------------800
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1787

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1788
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1789

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1790
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1791

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1792
---------------------------------------------------------900
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1794

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1795
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1796

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1797
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1798

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1799
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1800

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1801
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1802

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1803
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1804

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1805
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '825%')
	Where IdCuenta = 1806

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '825%')
	Where IdCuenta = 1807

	---------Totales

	--UPDATE [dbo].[C_BalanzaASEJ] SET
	----Select '82300','PRESUPUESTO DE EGRESOS',
	--CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%' ),
	--TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%')
	--Where IdCuenta = 1264

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82500-100','Servicios personales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-1%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-1%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-1%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-1%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-1%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-1%')
	Where IdCuenta = 1673

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82500-200','Materiales y suministros',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-2%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-2%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-2%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-2%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-2%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-2%')
	Where IdCuenta = 1688

		UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-300','Servicios generales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-3%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-3%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-3%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-3%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-3%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-3%')
	Where IdCuenta = 1707

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-400','Transferencias, asignaciones, subsidios y otras ayudas ',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-4%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-4%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-4%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-4%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-4%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-4%')
	Where IdCuenta = 1726

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-500','Bienes muebles, inmuebles e intangibles',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-5%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-5%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-5%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-5%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-5%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-5%')
	Where IdCuenta = 1745

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-600','Inversión pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-6%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-6%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-6%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-6%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-6%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-6%')
	Where IdCuenta = 1764

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-700','Inversiones financieras y otras provisiones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-7%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-7%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-7%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-7%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-7%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-7%')
	Where IdCuenta = 1771

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-800','Participaciones y aportaciones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-8%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-8%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-8%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-8%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-8%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-8%')
	Where IdCuenta = 1786

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-900','Deuda pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-9%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-9%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-9%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-9%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-9%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82500-9%')
	Where IdCuenta = 1793
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------82600----------------------------------------------------------------------------------------------------------------------------
UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos = (Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1810

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1811
	-----------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1812

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1813
--------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1814

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1815
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1816

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1817
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1818

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1819
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1820

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1821
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1822

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1823
---------------------------------------------------------200
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1825

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1826
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1827

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1828
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1829

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1830
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1831

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1832
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1833

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1834
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1835

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1836
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1837

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1838
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1839

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1840
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1841

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1842
---------------------------------------------------------300
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1844

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1845
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1846

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1847
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1848

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1849
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1850

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1851
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1852

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1853
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1854

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1855
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1856

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1857
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1858

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1859
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1860

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1861
---------------------------------------------------------400
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1863

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1864
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1865

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1866
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1867

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1868
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1869

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1870
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1871

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1872
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1873

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1874
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1875

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1876
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1877

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1878
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1879

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1880
---------------------------------------------------------500
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1882

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1883
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1884

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1885
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1886

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1887
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1888

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1889
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1890

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1891
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1892

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1893
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1894

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1895
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1896

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1897
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1898

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1899
---------------------------------------------------------600
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1901

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1902
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1903

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1904
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1905

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1906
---------------------------------------------------------700
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1908

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1909
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1910

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1911
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1912

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1913
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1914

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1915
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1916

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1917
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1918

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1919
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1920

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1921
---------------------------------------------------------800
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1923

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1924
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1925

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1926
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1927

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1928
---------------------------------------------------------900
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1930

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1931
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1932

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1933
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1934

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1935
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1936

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1937
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1938

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1939
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1940

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1941
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '826%')
	Where IdCuenta = 1942

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '826%')
	Where IdCuenta = 1943

	---------Totales

	--UPDATE [dbo].[C_BalanzaASEJ] SET
	----Select '82300','PRESUPUESTO DE EGRESOS',
	--CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%' ),
	--TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%')
	--Where IdCuenta = 1264

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82600-100','Servicios personales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-1%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-1%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-1%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-1%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-1%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-1%')
	Where IdCuenta = 1809

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82600-200','Materiales y suministros',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-2%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-2%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-2%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-2%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-2%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-2%')
	Where IdCuenta = 1824

		UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-300','Servicios generales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-3%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-3%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-3%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-3%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-3%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-3%')
	Where IdCuenta = 1843

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-400','Transferencias, asignaciones, subsidios y otras ayudas ',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-4%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-4%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-4%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-4%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-4%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-4%')
	Where IdCuenta = 1862

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-500','Bienes muebles, inmuebles e intangibles',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-5%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-5%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-5%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-5%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-5%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-5%')
	Where IdCuenta = 1881

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-600','Inversión pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-6%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-6%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-6%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-6%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-6%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-6%')
	Where IdCuenta = 1900

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-700','Inversiones financieras y otras provisiones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-7%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-7%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-7%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-7%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-7%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-7%')
	Where IdCuenta = 1907

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-800','Participaciones y aportaciones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-8%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-8%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-8%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-8%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-8%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-8%')
	Where IdCuenta = 1922

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-900','Deuda pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-9%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-9%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-9%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-9%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-9%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82600-9%')
	Where IdCuenta = 1929
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------82700----------------------------------------------------------------------------------------------------------------------------
UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos = (Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1946

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo = (Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos = (Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1110,1120,1130,1140) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1947
	-----------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1948

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1210,1220,1230,1240) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1949
--------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1950

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1310,1320,1330,1340,1350,1360,1370,1380) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1951
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1952

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos =(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos =(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1410,1420,1430,1440) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1953
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1954

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1510,1520,1530,1540,1550,1590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1955
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1956

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1610) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1957
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1958

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (1710,1720) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1959
---------------------------------------------------------200
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1961

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2110,2120,2130,2140,2150,2160,2170,2180) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1962
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1963

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2210,2220,2230) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1964
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1965

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2310,2320,2330,2340,2350,2360,2370,2380,2390) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1966
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1967

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2410,2420,2430,2440,2450,2460,2470,2480,2490) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1968
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1969

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2510,2520,2530,2540,2550,2560,2590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1970
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1971

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2610,2620) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1972
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1973

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2710,2720,2730,2740,2750) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1974
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1975

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1976
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1977

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (2810,2820,2830) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1978
---------------------------------------------------------300
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1980

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3110,3120,3130,3140,3150,3160,3170,3180,3190) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1981
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1982

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3210,3220,3230,3240,3250,3260,3270,3280,3290) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1983
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1984

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3310,3320,3330,3340,3350,3360,3370,3380,3390) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1985
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1986

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3410,3420,3430,3440,3450,3460,3470,3480,3490) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1987
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1988

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3510,3520,3530,3540,3550,3560,3570,3580,3590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1989
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1990

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3610,3620,3630,3640,3650,3660,3690) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1991
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1992

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3710,3720,3730,3740,3750,3760,3770,3780,3790) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1993
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1994

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3810,3820,3830,3840,3850) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1995
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1996

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (3910,3920,3930,3940,3950,3960,3970,3980,3990) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 1997
---------------------------------------------------------400
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 1999

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4110,4120,4130,4140,4150,4160,4170,4180,4190) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2000
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2001

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4210,4220,4230,4240,4250) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2002
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2003

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4310,4320,4330,4340,4350,4360,4370,4380,4390) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2004
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2005

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4410,4420,4430,4440,4450,4460,4470,4480) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2006
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2007

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4510,4520,4590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2008
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2009

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4610,4620,4630,4640,4650,4660,4690) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2010
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2011

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4710) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2012
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2013

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4810,4820,4830,4840,4850) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2014
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2015

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (4910,4920,4930) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2016
---------------------------------------------------------500
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2018

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5110,5120,5130,5140,5150,5190) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2019
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2020

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5210,5220,5230,5290) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2021
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2022

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5310,5320) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2023
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2024

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5410,5420,5430,5440,5450,5490) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2025
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2026

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5510) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2027
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2028

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5610,5620,5630,5640,5650,5660,5670,5690) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2029
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2030

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5710,5720,5730,5740,5750,5760,5770,5780,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2031
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2032

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5810,5820,5830,5890) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2033
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2034

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (5910,5920,5930,5940,5950,5960,5970,5980,5790) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2035
---------------------------------------------------------600
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2037

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6110,6120,6130,6140,6150,6160,6170,6190) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2038
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2039

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6210,6220,6230,6240,6250,6260,6270,6290) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2040
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2041

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (6310,6320) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2042
---------------------------------------------------------700
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2044

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(Saldoinicial),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7110,7120) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2045
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2046

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7210,7220,7230,7240,7250,7260,7270,7280,7290) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2047
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2048

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7310,7320,7330,7340,7350,7390) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2049
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2050

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7410,7420,7430,7440,7450,7460,7470,7480,7490) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2051
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2052

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7510,7520,7530,7540,7550,7560,7570,7580,7590) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2053
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2054

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7610,7620) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2055
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2056

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (7910,7920,7990) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2057
---------------------------------------------------------800
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2059

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8110,8120,8130,8140,8150,8160) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2060
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2061

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8310,8320,8330,8340,8350) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2062
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2063

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (8510,8520,8530) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2064
---------------------------------------------------------900
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2066

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9110,9120,9130,9140,9150,9160,9170,9180) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2067
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2068

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9210,9220,9230,9240,9250,9260,9270,9280) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2069
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2070

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9310,9320) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2071
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2072

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9410,9420) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2073
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2074

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9510,9520) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2075
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2076

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9610,9620) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2077
---------------------------------------------------------
	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (11,12,13,14,15,16,17) AND NumeroCuenta like '827%')
	Where IdCuenta = 2078

	UPDATE [dbo].[C_BalanzaASEJ] SET
	AbonosSinFlujo =(Select ISNULL(SUM(SaldoInicial),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalCargos=(Select ISNULL(SUM(ImporteCargo),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%'),
	TotalAbonos=(Select ISNULL(SUM(ImporteAbono),0) from @Extras Where ClavePartida in (9910) and ClaveFF in (25,26,27) AND NumeroCuenta like '827%')
	Where IdCuenta = 2079

	---------Totales

	--UPDATE [dbo].[C_BalanzaASEJ] SET
	----Select '82300','PRESUPUESTO DE EGRESOS',
	--CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%' ),
	--TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%'),
	--SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '823%')
	--Where IdCuenta = 1264

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82700-100','Servicios personales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-1%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-1%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-1%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-1%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-1%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-1%')
	Where IdCuenta = 1945

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82700-200','Materiales y suministros',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-2%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-2%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-2%' ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-2%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-2%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-2%')
	Where IdCuenta = 1960

		UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-300','Servicios generales',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-3%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-3%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-3%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-3%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-3%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-3%')
	Where IdCuenta = 1979

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-400','Transferencias, asignaciones, subsidios y otras ayudas ',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-4%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-4%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-4%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-4%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-4%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-4%')
	Where IdCuenta = 1998

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-500','Bienes muebles, inmuebles e intangibles',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-5%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-5%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-5%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-5%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-5%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-5%')
	Where IdCuenta = 2017

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-600','Inversión pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-6%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-6%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-6%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-6%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-6%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-6%')
	Where IdCuenta = 2036

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-700','Inversiones financieras y otras provisiones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-7%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-7%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-7%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-7%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-7%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-7%')
	Where IdCuenta = 2043

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-800','Participaciones y aportaciones',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-8%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-8%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-8%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-8%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-8%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-8%')
	Where IdCuenta = 2058

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100-900','Deuda pública',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-9%'),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-9%'),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-9%'),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-9%'),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-9%'),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where NumeroCuenta like '82700-9%')
	Where IdCuenta = 2065
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------Totales 8 mil mayores
	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '81100'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81100.1,81100.2,81100.3,81100.4,81100.5,81100.6,81100.7,81100.8,81100.9,81100.05)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81100.1,81100.2,81100.3,81100.4,81100.5,81100.6,81100.7,81100.8,81100.9,81100.05)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81100.1,81100.2,81100.3,81100.4,81100.5,81100.6,81100.7,81100.8,81100.9,81100.05) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81100.1,81100.2,81100.3,81100.4,81100.5,81100.6,81100.7,81100.8,81100.9,81100.05)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81100.1,81100.2,81100.3,81100.4,81100.5,81100.6,81100.7,81100.8,81100.9,81100.05)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81100.1,81100.2,81100.3,81100.4,81100.5,81100.6,81100.7,81100.8,81100.9,81100.05))
	Where IdCuenta = 792

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '81200'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81200.1,81200.2,81200.3,81200.4,81200.5,81200.6,81200.7,81200.8,81200.9,81200.05)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81200.1,81200.2,81200.3,81200.4,81200.5,81200.6,81200.7,81200.8,81200.9,81200.05)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81200.1,81200.2,81200.3,81200.4,81200.5,81200.6,81200.7,81200.8,81200.9,81200.05) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81200.1,81200.2,81200.3,81200.4,81200.5,81200.6,81200.7,81200.8,81200.9,81200.05)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81200.1,81200.2,81200.3,81200.4,81200.5,81200.6,81200.7,81200.8,81200.9,81200.05)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81200.1,81200.2,81200.3,81200.4,81200.5,81200.6,81200.7,81200.8,81200.9,81200.05))
	Where IdCuenta = 859

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '81300'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81300.1,81300.2,81300.3,81300.4,81300.5,81300.6,81300.7,81300.8,81300.9,81300.05)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81300.1,81300.2,81300.3,81300.4,81300.5,81300.6,81300.7,81300.8,81300.9,81300.05)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81300.1,81300.2,81300.3,81300.4,81300.5,81300.6,81300.7,81300.8,81300.9,81300.05) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81300.1,81300.2,81300.3,81300.4,81300.5,81300.6,81300.7,81300.8,81300.9,81300.05)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81300.1,81300.2,81300.3,81300.4,81300.5,81300.6,81300.7,81300.8,81300.9,81300.05)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81300.1,81300.2,81300.3,81300.4,81300.5,81300.6,81300.7,81300.8,81300.9,81300.05))
	Where IdCuenta = 926

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '81400'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81400.1,81400.2,81400.3,81400.4,81400.5,81400.6,81400.7,81400.8,81400.9,81400.05)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81400.1,81400.2,81400.3,81400.4,81400.5,81400.6,81400.7,81400.8,81400.9,81400.05)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81400.1,81400.2,81400.3,81400.4,81400.5,81400.6,81400.7,81400.8,81400.9,81400.05) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81400.1,81400.2,81400.3,81400.4,81400.5,81400.6,81400.7,81400.8,81400.9,81400.05)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81400.1,81400.2,81400.3,81400.4,81400.5,81400.6,81400.7,81400.8,81400.9,81400.05)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81400.1,81400.2,81400.3,81400.4,81400.5,81400.6,81400.7,81400.8,81400.9,81400.05))
	Where IdCuenta = 993

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '81500'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81500.1,81500.2,81500.3,81500.4,81500.5,81500.6,81500.7,81500.8,81500.9,81500.05)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81500.1,81500.2,81500.3,81500.4,81500.5,81500.6,81500.7,81500.8,81500.9,81500.05)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81500.1,81500.2,81500.3,81500.4,81500.5,81500.6,81500.7,81500.8,81500.9,81500.05) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81500.1,81500.2,81500.3,81500.4,81500.5,81500.6,81500.7,81500.8,81500.9,81500.05)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81500.1,81500.2,81500.3,81500.4,81500.5,81500.6,81500.7,81500.8,81500.9,81500.05)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81500.1,81500.2,81500.3,81500.4,81500.5,81500.6,81500.7,81500.8,81500.9,81500.05))
	Where IdCuenta = 1060

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82100'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82100.1,82100.2,82100.3,82100.4,82100.5,82100.6,82100.7,82100.8,82100.9)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82100.1,82100.2,82100.3,82100.4,82100.5,82100.6,82100.7,82100.8,82100.9)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82100.1,82100.2,82100.3,82100.4,82100.5,82100.6,82100.7,82100.8,82100.9) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82100.1,82100.2,82100.3,82100.4,82100.5,82100.6,82100.7,82100.8,82100.9)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82100.1,82100.2,82100.3,82100.4,82100.5,82100.6,82100.7,82100.8,82100.9)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82100.1,82100.2,82100.3,82100.4,82100.5,82100.6,82100.7,82100.8,82100.9))
	Where CuentaNumero = 82100

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82200',
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82200.1,82200.2,82200.3,82200.4,82200.5,82200.6,82200.7,82200.8,82200.9)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82200.1,82200.2,82200.3,82200.4,82200.5,82200.6,82200.7,82200.8,82200.9)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82200.1,82200.2,82200.3,82200.4,82200.5,82200.6,82200.7,82200.8,82200.9) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82200.1,82200.2,82200.3,82200.4,82200.5,82200.6,82200.7,82200.8,82200.9)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82200.1,82200.2,82200.3,82200.4,82200.5,82200.6,82200.7,82200.8,82200.9)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82200.1,82200.2,82200.3,82200.4,82200.5,82200.6,82200.7,82200.8,82200.9))
	Where CuentaNumero = 82200

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82300'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82300.1,82300.2,82300.3,82300.4,82300.5,82300.6,82300.7,82300.8,82300.9)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82300.1,82300.2,82300.3,82300.4,82300.5,82300.6,82300.7,82300.8,82300.9)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82300.1,82300.2,82300.3,82300.4,82300.5,82300.6,82300.7,82300.8,82300.9) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82300.1,82300.2,82300.3,82300.4,82300.5,82300.6,82300.7,82300.8,82300.9)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82300.1,82300.2,82300.3,82300.4,82300.5,82300.6,82300.7,82300.8,82300.9)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82300.1,82300.2,82300.3,82300.4,82300.5,82300.6,82300.7,82300.8,82300.9))
	Where CuentaNumero = 82300

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82400'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82400.1,82400.2,82400.3,82400.4,82400.5,82400.6,82400.7,82400.8,82400.9)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82400.1,82400.2,82400.3,82400.4,82400.5,82400.6,82400.7,82400.8,82400.9)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82400.1,82400.2,82400.3,82400.4,82400.5,82400.6,82400.7,82400.8,82400.9) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82400.1,82400.2,82400.3,82400.4,82400.5,82400.6,82400.7,82400.8,82400.9)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82400.1,82400.2,82400.3,82400.4,82400.5,82400.6,82400.7,82400.8,82400.9)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82400.1,82400.2,82400.3,82400.4,82400.5,82400.6,82400.7,82400.8,82400.9))
	Where CuentaNumero = 82400

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82500'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82500.1,82500.2,82500.3,82500.4,82500.5,82500.6,82500.7,82500.8,82500.9)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82500.1,82500.2,82500.3,82500.4,82500.5,82500.6,82500.7,82500.8,82500.9)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82500.1,82500.2,82500.3,82500.4,82500.5,82500.6,82500.7,82500.8,82500.9) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82500.1,82500.2,82500.3,82500.4,82500.5,82500.6,82500.7,82500.8,82500.9)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82500.1,82500.2,82500.3,82500.4,82500.5,82500.6,82500.7,82500.8,82500.9)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82500.1,82500.2,82500.3,82500.4,82500.5,82500.6,82500.7,82500.8,82500.9))
	Where CuentaNumero = 82500

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82600'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82600.1,82600.2,82600.3,82600.4,82600.5,82600.6,82600.7,82600.8,82600.9)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82600.1,82600.2,82600.3,82600.4,82600.5,82600.6,82600.7,82600.8,82600.9)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82600.1,82600.2,82600.3,82600.4,82600.5,82600.6,82600.7,82600.8,82600.9) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82600.1,82600.2,82600.3,82600.4,82600.5,82600.6,82600.7,82600.8,82600.9)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82600.1,82600.2,82600.3,82600.4,82600.5,82600.6,82600.7,82600.8,82600.9)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82600.1,82600.2,82600.3,82600.4,82600.5,82600.6,82600.7,82600.8,82600.9))
	Where CuentaNumero = 82600

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '82700'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82700.1,82700.2,82700.3,82700.4,82700.5,82700.6,82700.7,82700.8,82700.9)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82700.1,82700.2,82700.3,82700.4,82700.5,82700.6,82700.7,82700.8,82700.9)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82700.1,82700.2,82700.3,82700.4,82700.5,82700.6,82700.7,82700.8,82700.9) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82700.1,82700.2,82700.3,82700.4,82700.5,82700.6,82700.7,82700.8,82700.9)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82700.1,82700.2,82700.3,82700.4,82700.5,82700.6,82700.7,82700.8,82700.9)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82700.1,82700.2,82700.3,82700.4,82700.5,82700.6,82700.7,82700.8,82700.9))
	Where CuentaNumero = 82700


	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '81000'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81100,81200,81300,81400,81500)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81100,81200,81300,81400,81500)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81100,81200,81300,81400,81500) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81100,81200,81300,81400,81500)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81100,81200,81300,81400,81500)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81100,81200,81300,81400,81500))
	Where CuentaNumero = 81000

UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '80000'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82700,82600,82500,82400,82300,82200,82100)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82700,82600,82500,82400,82300,82200,82100)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82700,82600,82500,82400,82300,82200,82100) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82700,82600,82500,82400,82300,82200,82100)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82700,82600,82500,82400,82300,82200,82100)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (82700,82600,82500,82400,82300,82200,82100))
	Where CuentaNumero = 82000

	UPDATE [dbo].[C_BalanzaASEJ] SET
	--Select '80000'
	CargosSinFlujo=(Select ISNULL(SUM(CargosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81000,82000)),
	AbonosSinFlujo=(Select ISNULL(SUM(AbonosSinFlujo),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81000,82000)),
	TotalCargos=(Select ISNULL(SUM(TotalCargos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81000,82000) ),
	TotalAbonos=(Select ISNULL(SUM(TotalAbonos),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81000,82000)),
	SaldoDeudor=(Select ISNULL(SUM(SaldoDeudor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81000,82000)),
	SaldoAcreedor=(Select ISNULL(SUM(SaldoAcreedor),0) from [dbo].[C_BalanzaASEJ] Where CuentaNumero in (81000,82000))
	Where CuentaNumero = 80000

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Update [dbo].[C_BalanzaASEJ] set SaldoAcreedor = AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos
	--Select * from C_BalanzaASEJ


 --Set @MsgErrCode = @@Error
       If (@@Error <> 0)
             Begin
                    Set @MsgErrDescr = ERROR_MESSAGE()
                    Rollback
             End
       Else
             Begin
                    /* Message of results */
                    Set @MsgErrDescr = 'Update records'
                    Commit
                    /* Add log and history optional*/
		
END