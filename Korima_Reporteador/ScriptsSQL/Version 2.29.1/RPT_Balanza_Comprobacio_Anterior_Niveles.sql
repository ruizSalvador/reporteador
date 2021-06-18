/****** Object:  UserDefinedFunction [dbo].[RPT_Balanza_Comprobacio_Anterior_Niveles]    Script Date: 05/07/2013 09:23:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_Balanza_Comprobacio_Anterior_Niveles]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[RPT_Balanza_Comprobacio_Anterior_Niveles]
GO
/****** Object:  UserDefinedFunction [dbo].[RPT_Balanza_Comprobacio_Anterior_Niveles]    Script Date: 05/07/2013 09:23:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--///////////////RPT_Balanza_Comprobacio_Anterior
/****** Object:  UserDefinedFunction [dbo].[RPT_Balanza_Comprobacio_Anterior_Niveles]    Script Date: 10/08/2012 13:00:46 ******/

CREATE FUNCTION [dbo].[RPT_Balanza_Comprobacio_Anterior_Niveles]
                 ( @mes int,@Año int)
RETURNS table
AS
RETURN (
SELECT     TOP (100) PERCENT dbo.C_Contable.IdCuentaContable, dbo.C_Contable.NumeroCuenta,
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos
                       - TotalAbonos WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos
                       - TotalCargos END AS SaldoAcreedor,dbo.T_SaldosInicialesCont.Mes, 
                      dbo.T_SaldosInicialesCont.Year
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') 
--AND ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000') OR (RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000')) 
AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '0') AND 
    (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '3' 
	AND LEFT(dbo.C_Contable.NumeroCuenta, 1) < '6') and dbo.T_SaldosInicialesCont.Mes = @mes and
                      dbo.T_SaldosInicialesCont.Year = @año 
ORDER BY dbo.C_Contable.NumeroCuenta
       )


GO


