/****** Object:  View [dbo].[VW_RPT_K2_LibroMayor]    Script Date: 12/20/2012 11:13:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_LibroMayor]'))
DROP VIEW [dbo].[VW_RPT_K2_LibroMayor]
GO

/****** Object:  View [dbo].[VW_RPT_K2_LibroMayor]    Script Date: 12/20/2012 11:13:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_RPT_K2_LibroMayor]
as
SELECT
T_Polizas.Fecha,
T_Polizas.TipoPoliza + CAST(t_polizas.NoPoliza AS VARCHAR(10)) AS Folio,
ROW_NUMBER() over(order by t_polizas.idpoliza)as NoAsiento,
D_Polizas.Referencia,
C_Contable.NumeroCuenta AS NumeroCuentaContable,
C_Contable.NombreCuenta AS NombreCuentaContable,
C_Contable.Nivel,
T_Polizas.Concepto,
D_Polizas.IdDPoliza,
D_Polizas.ImporteCargo,
D_Polizas.ImporteAbono,
	Case C_Contable .TipoCuenta    
      When 'A' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      When 'C' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      When 'E' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      When 'G' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      When 'I' Then T_SaldosInicialesCont.CargosSinFlujo  + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      Else T_SaldosInicialesCont.AbonosSinFlujo +(D_Polizas.ImporteAbono - D_Polizas.ImporteCargo)
	End as SaldoFila,
	--Case C_Contable .TipoCuenta    
 --     When 'A' Then T_SaldosInicialesCont.CargosSinFlujo - T_SaldosInicialesCont.AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
 --     When 'C' Then T_SaldosInicialesCont.CargosSinFlujo - T_SaldosInicialesCont.AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
 --     When 'E' Then T_SaldosInicialesCont.CargosSinFlujo - T_SaldosInicialesCont.AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
 --     When 'G' Then T_SaldosInicialesCont.CargosSinFlujo - T_SaldosInicialesCont.AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
 --     When 'I' Then T_SaldosInicialesCont.CargosSinFlujo - T_SaldosInicialesCont.AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
 --     Else T_SaldosInicialesCont.AbonosSinFlujo - T_SaldosInicialesCont.CargosSinFlujo + T_SaldosInicialesCont.TotalAbonos - T_SaldosInicialesCont.TotalCargos+(D_Polizas.ImporteAbono - D_Polizas.ImporteCargo)
	--End as SaldoFila,
c_contable.CuentaAcumulacion,
 Case C_Contable .TipoCuenta  
          When 'A' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'C' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'E' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'G' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'I' Then T_SaldosInicialesCont.CargosSinFlujo 
          Else T_SaldosInicialesCont.AbonosSinFlujo 
      End as SaldoInicial,
 --Case C_Contable .TipoCuenta  
 --         When 'A' Then T_SaldosInicialesCont.CargosSinFlujo - T_SaldosInicialesCont.AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos
 --         When 'C' Then T_SaldosInicialesCont.CargosSinFlujo - T_SaldosInicialesCont.AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos
 --         When 'E' Then T_SaldosInicialesCont.CargosSinFlujo - T_SaldosInicialesCont.AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos
 --         When 'G' Then T_SaldosInicialesCont.CargosSinFlujo - T_SaldosInicialesCont.AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos
 --         When 'I' Then T_SaldosInicialesCont.CargosSinFlujo - T_SaldosInicialesCont.AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos
 --         Else T_SaldosInicialesCont.AbonosSinFlujo - T_SaldosInicialesCont.CargosSinFlujo + T_SaldosInicialesCont.TotalAbonos - T_SaldosInicialesCont.TotalCargos 
 --     End as SaldoInicial,
      T_SaldosInicialesCont.Mes,
T_SaldosInicialesCont.year,
C_Contable.TipoCuenta
FROM T_Polizas
JOIN
D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza
JOIN
C_Contable ON C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable 
JOIN
T_SaldosInicialesCont ON C_Contable.IdCuentaContable= T_SaldosInicialesCont.IdCuentaContable
 where TipoCuenta <> 'X'
and T_Polizas.NoPoliza>0


GO