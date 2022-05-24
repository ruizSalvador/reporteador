IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Relacion_Analitica_Efectivo_ISAF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Relacion_Analitica_Efectivo_ISAF]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RPT_Relacion_Analitica_Efectivo_ISAF 6,6,2019;
CREATE PROCEDURE [dbo].[SP_RPT_Relacion_Analitica_Efectivo_ISAF]
@MesInicio smallint,    
@MesFin smallint,
@Ejercicio smallint

AS
BEGIN

DECLARE @TablaEfect TABLE
	(NumeroCuenta VARCHAR(max),
	Responsable VARCHAR(max),
	SaldoDeudor DECIMAL(18,2),
	Mes int,
	Year int);

INSERT INTO @TablaEfect
	SELECT Cont.NumeroCuenta, 
		CASE WHEN ((Emp.Nombres + ' ' + Emp.ApellidoPaterno + ' ' + Emp.ApellidoMaterno) = '') THEN Cont.NombreCuenta ELSE (Emp.Nombres + ' ' + Emp.ApellidoPaterno + ' ' + Emp.ApellidoMaterno) END AS Responsable,
		CASE Cont.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
		WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
		WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE 0 END AS SaldoDeudor,
		MAX(Saldos.Mes) AS Mes, 
		MAX(Saldos.Year) AS Year
	FROM C_Contable Cont INNER JOIN T_SaldosInicialesCont Saldos
	ON Cont.IdCuentaContable = Saldos.IdCuentaContable LEFT JOIN R_CtasContxCtesProvEmp Ctas
	ON Cont.IdCuentaContable = Ctas.IdCuentaContable LEFT JOIN C_Empleados Emp
	ON Ctas.NumeroEmpleado = Emp.NumeroEmpleado
	WHERE (Cont.TipoCuenta <> 'X') AND Mes = @MesFin AND [Year] = @Ejercicio AND Afectable != 0
	-- AND SUBSTRING(CuentaAcumulacion,1,LEN('1111')) = '1111'
	-- AND (NumeroCuenta = '1111' OR SUBSTRING(NumeroCuenta,1,LEN('1111')) = '1111') 
	GROUP BY Cont.NumeroCuenta, (Emp.Nombres + ' ' + Emp.ApellidoPaterno + ' ' + Emp.ApellidoMaterno), Cont.NombreCuenta, TipoCuenta,
	CargosSinFlujo, AbonosSinFlujo, TotalCargos, TotalAbonos
	ORDER BY Cont.NumeroCuenta;

SELECT * FROM @TablaEfect WHERE (NumeroCuenta = '1111' OR SUBSTRING(NumeroCuenta,1,LEN('1111')) = '1111');

END

GO
EXEC SP_FirmasReporte 'Relacion Analitica del Efectivo ISAF' 

GO

Exec SP_CFG_LogScripts 'SP_RPT_Relacion_Analitica_Efectivo_ISAF', '2.29'
GO