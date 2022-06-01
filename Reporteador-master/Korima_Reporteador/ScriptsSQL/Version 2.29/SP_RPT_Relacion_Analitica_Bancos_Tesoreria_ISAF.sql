IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Relacion_Analitica_Bancos_Tesoreria_ISAF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Relacion_Analitica_Bancos_Tesoreria_ISAF]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RPT_Relacion_Analitica_Bancos_Tesoreria_ISAF 6,6,2019;
CREATE PROCEDURE [dbo].[SP_RPT_Relacion_Analitica_Bancos_Tesoreria_ISAF]
@MesInicio smallint,    
@MesFin smallint,
@Ejercicio smallint

AS
BEGIN

DECLARE @TablaBanks TABLE
	(NumeroCuenta VARCHAR(max),
	NombreCuenta VARCHAR(max),
	CargosSinFlujo DECIMAL(18,2),
	TotalCargos DECIMAL(18,2),
	TotalAbonos DECIMAL(18,2),
	SaldoDeudor DECIMAL(18,2),
	Mes int,
	Year int);

INSERT INTO @TablaBanks
	SELECT Cont.NumeroCuenta, 
	Cont.NombreCuenta, 
	ISNULL(MAX(SaldosIniciales.SaldoInicial), 0) AS SaldoInicial, 
	SUM(Saldos.TotalCargos) AS TotalCargos, 
	SUM(Saldos.TotalAbonos) AS TotalAbonos, 
	ISNULL(MAX(SaldosFinales.SaldoFinal), 0) AS SaldoFinal,
	MAX(Saldos.Mes) AS Mes, 
	MAX(Saldos.Year) AS Año
FROM C_Contable Cont INNER JOIN T_SaldosInicialesCont Saldos
ON Cont.IdCuentaContable = Saldos.IdCuentaContable
LEFT JOIN (Select C_Contable.IdCuentaContable, 
			CASE C_Contable.TipoCuenta WHEN 'A' THEN CargosSinFlujo WHEN 'C' THEN CargosSinFlujo WHEN 'E' THEN CargosSinFlujo WHEN 'G' THEN CargosSinFlujo WHEN 'I' THEN CargosSinFlujo 
			ELSE AbonosSinFlujo END AS SaldoInicial
			FROM  C_Contable INNER JOIN T_SaldosInicialesCont
			ON C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
			WHERE  Mes = @MesInicio  And [Year] = @Ejercicio And TipoCuenta <> 'X' 
			AND SUBSTRING(CuentaAcumulacion,1,LEN('1112')) = '1112' AND Afectable != 0 ) SaldosIniciales
ON Cont.IdCuentaContable = SaldosIniciales.IdCuentaContable
LEFT JOIN (Select C_Contable.IdCuentaContable, 
			(Case C_Contable.TipoCuenta When 'A' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos When 'C' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
			When 'E' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos When 'G' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos When 'I' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
			ELSE 0 END) AS SaldoFinal
			FROM C_Contable INNER JOIN T_SaldosInicialesCont
			ON C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
			WHERE  Mes = @MesFin  And [Year] = @Ejercicio And TipoCuenta <> 'X' 
			AND SUBSTRING(CuentaAcumulacion,1,LEN('1112')) = '1112' AND Afectable != 0) SaldosFinales 
ON Cont.IdCuentaContable = SaldosFinales.IdCuentaContable
WHERE (Cont.TipoCuenta <> 'X') AND Mes BETWEEN @MesInicio AND @MesFin AND [Year] = @Ejercicio AND Afectable != 0 
--AND SUBSTRING(CuentaAcumulacion,1,LEN('1112')) = '1112'
GROUP BY Cont.NumeroCuenta, Cont.NombreCuenta --, CargosSinFlujo, AbonosSinFlujo, TotalCargos, TotalAbonos, TipoCuenta
ORDER BY Cont.NumeroCuenta;

SELECT * FROM @TablaBanks WHERE (NumeroCuenta = '1112' OR SUBSTRING(NumeroCuenta,1,LEN('1112')) = '1112');

END

GO
EXEC SP_FirmasReporte 'Relacion Analitica Bancos y Tesoreria ISAF' 

GO

Exec SP_CFG_LogScripts 'SP_RPT_Relacion_Analitica_Bancos_Tesoreria_ISAF','2.29'
GO