
/*
IF OBJECT_ID (N'FormatoCadena', N'IF') IS NOT NULL
-- deletes function
    DROP FUNCTION FormatoCadena;
GO
IF OBJECT_ID (N'Saldo_Cuenta', N'IF') IS NOT NULL
-- deletes function
    DROP FUNCTION Saldo_Cuenta;
GO
*/
-- determines if function exists in database
IF OBJECT_ID (N'RPT_Balanza_Comprobacio_Anterior', N'IF') IS NOT NULL
-- deletes function
    DROP FUNCTION RPT_Balanza_Comprobacio_Anterior;
GO

/****** Object:  View [dbo].[VW_RPT_K2_Balanza_De_Comprobacion]    Script Date: 07/05/2012 14:18:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Balanza_De_Comprobacion]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[VW_RPT_K2_Balanza_De_Comprobacion]
GO
/****** Object:  View [dbo].[VW_RPT_K2_Balanza_De_Comprobacion_Nivelada]    Script Date: 07/05/2012 14:18:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Balanza_De_Comprobacion_Nivelada]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[VW_RPT_K2_Balanza_De_Comprobacion_Nivelada]
GO
/****** Object:  View [dbo].[VW_RPT_K2_Balanza_De_Comprobacion_Nivelada_Totalizado]    Script Date: 07/05/2012 14:18:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Balanza_De_Comprobacion_Nivelada_Totalizado]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[VW_RPT_K2_Balanza_De_Comprobacion_Nivelada_Totalizado]
GO


/****** Object:  UserDefinedFunction [dbo].[RPT_Balanza_Comprobacio_Anterior]    Script Date: 09/13/2012 11:24:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[RPT_Balanza_Comprobacio_Anterior]
                 ( @mes int,@A�o int)
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
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') AND ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000')or(RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000')) AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '0') AND 
                      (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '4') and dbo.T_SaldosInicialesCont.Mes = @mes and
                      dbo.T_SaldosInicialesCont.Year = @a�o 
ORDER BY dbo.C_Contable.NumeroCuenta
       )
GO


--VISTAS

/****** Object:  View [dbo].[VW_RPT_K2_Balanza_De_Comprobacion]    Script Date: 09/13/2012 11:25:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Balanza_De_Comprobacion]
AS
SELECT     TOP (100) PERCENT dbo.C_Contable.NumeroCuenta, dbo.C_Contable.NombreCuenta, dbo.T_SaldosInicialesCont.CargosSinFlujo, 
                      dbo.T_SaldosInicialesCont.AbonosSinFlujo, dbo.T_SaldosInicialesCont.TotalCargos, dbo.T_SaldosInicialesCont.TotalAbonos, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos
                       - TotalAbonos WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos
                       - TotalCargos END AS SaldoAcreedor, dbo.T_SaldosInicialesCont.Mes, dbo.T_SaldosInicialesCont.Year, dbo.C_Contable.TipoCuenta,dbo.C_Contable.Afectable, C_Contable.Financiero
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable AND 
                      dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X')
ORDER BY dbo.C_Contable.NumeroCuenta

GO


/****** Object:  View [dbo].[VW_RPT_K2_Balanza_De_Comprobacion_Nivelada]    Script Date: 09/13/2012 11:27:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Balanza_De_Comprobacion_Nivelada]
AS
SELECT     TOP (100) PERCENT dbo.C_Contable.NumeroCuenta, dbo.C_Contable.NombreCuenta, dbo.T_SaldosInicialesCont.CargosSinFlujo, 
                      dbo.T_SaldosInicialesCont.AbonosSinFlujo, dbo.T_SaldosInicialesCont.TotalCargos, dbo.T_SaldosInicialesCont.TotalAbonos, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos
                       - TotalAbonos WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos
                       - TotalCargos END AS SaldoAcreedor, LEFT(dbo.C_Contable.NumeroCuenta, 1) AS TipoCuenta, LEFT(dbo.C_Contable.NumeroCuenta, 5) AS MaskNumeroCuenta, 
                      LEN(LEFT(dbo.C_Contable.NumeroCuenta, 5)) - LEN(REPLACE(LEFT(dbo.C_Contable.NumeroCuenta, 5), 0, '')) AS Total, dbo.T_SaldosInicialesCont.Mes, 
                      dbo.T_SaldosInicialesCont.Year, dbo.FormatoCadena(dbo.C_Contable.NombreCuenta, dbo.C_Contable.NumeroCuenta) AS MaskNombreCuenta
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') AND ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000')or(RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000') ) AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '0') AND 
                      (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '4') AND (dbo.T_SaldosInicialesCont.Year = 2011) AND (dbo.T_SaldosInicialesCont.Mes = 12)
ORDER BY dbo.C_Contable.NumeroCuenta

GO


/****** Object:  View [dbo].[VW_RPT_K2_Balanza_De_Comprobacion_Nivelada_Totalizado]    Script Date: 09/13/2012 11:28:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Balanza_De_Comprobacion_Nivelada_Totalizado]
AS
SELECT     TOP (100) 
                      PERCENT CASE C_Contable.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo
                       + TotalCargos - TotalAbonos WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos
                       - TotalAbonos WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos
                       - TotalCargos END AS SaldoAcreedor, dbo.T_SaldosInicialesCont.Mes, dbo.T_SaldosInicialesCont.Year, CASE LEFT(dbo.C_Contable.NumeroCuenta, 1) 
                      WHEN '1' THEN 1 ELSE 2 END AS Agrupador
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') AND ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000')or(RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000')) AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '0') AND 
                      (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '4') AND (LEN(REPLACE(REPLACE(dbo.C_Contable.NumeroCuenta, '0', ''), '-', '')) = 1)
ORDER BY dbo.C_Contable.NumeroCuenta

GO


