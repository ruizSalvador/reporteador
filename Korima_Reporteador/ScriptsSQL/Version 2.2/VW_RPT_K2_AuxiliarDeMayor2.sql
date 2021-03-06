/****** Object:  View [dbo].[VW_RPT_K2_AuxiliarDeMayor]    Script Date: 12/20/2012 11:13:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_AuxiliarDeMayor]'))
DROP VIEW [dbo].[VW_RPT_K2_AuxiliarDeMayor]
GO

/****** Object:  View [dbo].[VW_RPT_K2_AuxiliarDeMayor]    Script Date: 12/20/2012 11:13:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_RPT_K2_AuxiliarDeMayor]
AS

SELECT DISTINCT
T_Polizas.Fecha,
T_Polizas.TipoPoliza + CAST(t_polizas.NoPoliza AS VARCHAR(10)) AS Folio,
0 as NoAsiento,--ROW_NUMBER() over(order by t_polizas.idpoliza)as NoAsiento,
D_Polizas.Referencia,
C_Contable.NumeroCuenta AS NumeroCuentaContable,
C_Contable.NombreCuenta AS NombreCuentaContable,
C_Contable.Nivel,
T_Polizas.Concepto,
T_Polizas.IdPoliza,
--D_Polizas.IdDPoliza,
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
C_Contable.TipoCuenta,
T_Cheques.ConceptoPago,
T_Cheques.FolioCheque,
T_Cheques.Status
FROM T_Polizas
left outer JOIN
D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza
left outer JOIN
C_Contable ON C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable 
left outer JOIN
T_SaldosInicialesCont ON C_Contable.IdCuentaContable= T_SaldosInicialesCont.IdCuentaContable
left outer JOIN 
T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque 
 where TipoCuenta <> 'X'
 AND T_Polizas.NoPoliza>0 and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')
 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
   and( T_Cheques.Status= 'D' or T_Cheques.Status='I'OR T_Cheques.Status='N'))
 
 --and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N') and T_Cheques.Entregado=1)))



GO

exec SP_RPT_K2_AuxiliarMayor '','',2013,5,5,1
GO
--9688

select * from t_cheques
where
((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
   and( T_Cheques.Status= 'D' or T_Cheques.Status='I'OR T_Cheques.Status='N'))
 and T_Cheques.FolioCheque='9688'