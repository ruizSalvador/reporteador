/****** Object:  StoredProcedure [dbo].[RPT_Balanza_Comprobacio_Anterior_Periodos]    Script Date: 11/26/2012 15:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_Balanza_Comprobacio_Anterior_Periodos]') AND type IN (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[RPT_Balanza_Comprobacio_Anterior_Periodos]
GO
/******** Object:  StoredProcedure [dbo].[RPT_Balanza_Comprobacio_Anterior_Periodos]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Select * from  dbo.RPT_Balanza_Comprobacio_Anterior_Periodos(2,5,2018)
CREATE FUNCTION [dbo].[RPT_Balanza_Comprobacio_Anterior_Periodos]
                 ( @mes int, @mes2 int, @Año int)
RETURNS table
AS
RETURN (
	Select TOP (300) C_Contable.IdCuentaContable, NumeroCuenta, NombreCuenta, 
	SUM(CargosSinFlujo) as CargosSinFlujo, 
	SUM(AbonosSinFlujo) as AbonosSinFlujo, 
	SUM(TotalCargos) as TotalCargos, 
	SUM(TotalAbonos) as TotalAbonos,
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
						When 'I'  Then 0
						Else SUM(AbonosSinFlujo) - SUM(CargosSinFlujo) + SUM(TotalAbonos) - SUM(TotalCargos) 
					End as SaldoAcreedor, 
					Afectable,C_Contable.Financiero 
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') AND ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000') OR (RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000')) AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '0') AND 
                      (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '3' AND LEFT(dbo.C_Contable.NumeroCuenta, 1) < '6') and (dbo.T_SaldosInicialesCont.Mes between @mes and @mes2) and
                      dbo.T_SaldosInicialesCont.Year = @Año 
GROUP BY C_Contable.IdCuentaContable,NumeroCuenta,NombreCuenta, TipoCuenta, Afectable, Financiero 
	Order By NumeroCuenta
       )

GO


Exec SP_CFG_LogScripts 'RPT_Balanza_Comprobacio_Anterior_Periodos','2.29'
GO


