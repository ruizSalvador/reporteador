IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Relacion_Analitica_Proveedores_por_Pagar_Corto_Plazo_ISAF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Relacion_Analitica_Proveedores_por_Pagar_Corto_Plazo_ISAF]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RPT_Relacion_Analitica_Proveedores_por_Pagar_Corto_Plazo_ISAF 6,6,2019;
CREATE PROCEDURE [dbo].[SP_RPT_Relacion_Analitica_Proveedores_por_Pagar_Corto_Plazo_ISAF]
@MesInicio smallint,    
@MesFin smallint,
@Ejercicio smallint

AS
BEGIN

DECLARE @Tabla TABLE
	(NumeroCuenta VARCHAR(max),
	NombreCuenta VARCHAR(max),
	SaldoInicial DECIMAL(18,2),
	TotalCargos DECIMAL(18,2),
	TotalAbonos DECIMAL(18,2),
	Fecha_Ult_Mov DATE,
	SaldoFinal DECIMAL(18,2),
	Mes int,
	Year int);

--INSERT INTO @Tabla
--	SELECT Cont.NumeroCuenta, 
--	Cont.NombreCuenta, 
--	SUM(CASE Cont .TipoCuenta WHEN 'A' THEN CargosSinFlujo WHEN 'C' THEN CargosSinFlujo WHEN 'E' THEN CargosSinFlujo WHEN 'G' THEN CargosSinFlujo WHEN 'I' THEN CargosSinFlujo ELSE AbonosSinFlujo END) AS SaldoInicial,
--	SUM(Saldos.TotalCargos) AS TotalCargos, 
--	SUM(Saldos.TotalAbonos) AS TotalAbonos, 
--	MAX(Pol.Fecha) 'Fecha_Ult_Mov',
--	SUM(CASE Cont.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
--	WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos END) AS SaldoFinal,
--	MAX(Saldos.Mes) AS Mes, 
--	MAX(Saldos.Year) AS Año
--FROM C_Contable Cont INNER JOIN T_SaldosInicialesCont Saldos
--	ON Cont.IdCuentaContable = Saldos.IdCuentaContable 
--	LEFT JOIN (SELECT IdCuentaContable, MAX(CONVERT(DATE, Fecha)) AS Fecha FROM T_Polizas TPol INNER JOIN D_Polizas DPol ON TPol.IdPoliza = DPol.IdPoliza WHERE Ejercicio = @Ejercicio AND Periodo BETWEEN @MesInicio AND @MesFin GROUP BY IdCuentaContable) Pol
--	ON Saldos.IdCuentaContable = Pol.IdCuentaContable -- AND Mes = Periodo
--WHERE (Cont.TipoCuenta <> 'X') AND Mes BETWEEN @MesInicio AND @MesFin AND [Year] = @Ejercicio
--AND SUBSTRING(CuentaAcumulacion,1,LEN('2112')) = '2112' AND Afectable != 0 
--GROUP BY Cont.NumeroCuenta, Cont.NombreCuenta
--ORDER BY Cont.NumeroCuenta;

INSERT INTO @Tabla
	SELECT Cont.NumeroCuenta, 
	Cont.NombreCuenta, 
	ISNULL(MAX(SaldosIniciales.SaldoInicial), 0) AS SaldoInicial, 
	SUM(Saldos.TotalCargos) AS TotalCargos, 
	SUM(Saldos.TotalAbonos) AS TotalAbonos, 
	MAX(Pol.Fecha) 'Fecha_Ult_Mov',
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
			AND SUBSTRING(CuentaAcumulacion,1,LEN('2112')) = '2112' AND Afectable != 0 ) SaldosIniciales
ON Cont.IdCuentaContable = SaldosIniciales.IdCuentaContable
LEFT JOIN (Select C_Contable.IdCuentaContable, 
			(Case C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos END) AS SaldoFinal
			FROM C_Contable INNER JOIN T_SaldosInicialesCont
			ON C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
			WHERE  Mes = @MesFin  And [Year] = @Ejercicio And TipoCuenta <> 'X' 
			AND SUBSTRING(CuentaAcumulacion,1,LEN('2112')) = '2112' AND Afectable != 0) SaldosFinales 
ON Cont.IdCuentaContable = SaldosFinales.IdCuentaContable
LEFT JOIN (SELECT IdCuentaContable, MAX(CONVERT(DATE, Fecha)) AS Fecha FROM T_Polizas TPol INNER JOIN D_Polizas DPol ON TPol.IdPoliza = DPol.IdPoliza WHERE Ejercicio = @Ejercicio AND Periodo BETWEEN @MesInicio AND @MesFin GROUP BY IdCuentaContable) Pol
ON Saldos.IdCuentaContable = Pol.IdCuentaContable -- AND Mes = Periodo
WHERE (Cont.TipoCuenta <> 'X') AND Mes BETWEEN @MesInicio AND @MesFin AND [Year] = @Ejercicio AND Afectable != 0 
--AND SUBSTRING(CuentaAcumulacion,1,LEN('1112')) = '1112'
GROUP BY Cont.NumeroCuenta, Cont.NombreCuenta --, CargosSinFlujo, AbonosSinFlujo, TotalCargos, TotalAbonos, TipoCuenta
ORDER BY Cont.NumeroCuenta;

SELECT * FROM @Tabla WHERE (NumeroCuenta = '2112' OR SUBSTRING(NumeroCuenta,1,LEN('2112')) = '2112');

END

GO
EXEC SP_FirmasReporte 'Relacion Analitica de Proveedores por Pagar a Corto Plazo ISAF' 

GO
Exec SP_CFG_LogScripts 'SP_RPT_Relacion_Analitica_Proveedores_por_Pagar_Corto_Plazo_ISAF','2.29'
GO