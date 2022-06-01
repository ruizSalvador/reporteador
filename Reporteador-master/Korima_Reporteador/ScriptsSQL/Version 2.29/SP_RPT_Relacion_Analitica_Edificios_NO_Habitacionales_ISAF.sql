IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Relacion_Analitica_Edificios_NO_Habitacionales_ISAF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Relacion_Analitica_Edificios_NO_Habitacionales_ISAF]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RPT_Relacion_Analitica_Edificios_NO_Habitacionales_ISAF 6,6,2019;
CREATE PROCEDURE [dbo].[SP_RPT_Relacion_Analitica_Edificios_NO_Habitacionales_ISAF]
@MesInicio smallint,    
@MesFin smallint,
@Ejercicio smallint

AS
BEGIN

DECLARE @Tabla TABLE
	(NumeroCuenta VARCHAR(max),
	NombreCuenta VARCHAR(max),
	CargosSinFlujo DECIMAL(18,2),
	TotalCargos DECIMAL(18,2),
	TotalAbonos DECIMAL(18,2),
	SaldoDeudor DECIMAL(18,2),
	Mes INT,
	[Year] INT);

INSERT INTO @Tabla
	SELECT Cont.NumeroCuenta, 
	Cont.NombreCuenta, 
	MAX(Saldos.CargosSinFlujo) AS CargosSinFlujo, 
	MAX(Saldos.TotalCargos) AS TotalCargos, 
	MAX(Saldos.TotalAbonos) AS TotalAbonos, 
	CASE Cont.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo
	+ TotalCargos - TotalAbonos WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE 0 END AS SaldoDeudor,
	MAX(Saldos.Mes) AS Mes, 
	MAX(Saldos.[Year]) AS 'Year'
FROM C_Contable Cont INNER JOIN T_SaldosInicialesCont Saldos
ON Cont.IdCuentaContable = Saldos.IdCuentaContable
WHERE (Cont.TipoCuenta <> 'X') AND Mes = @MesFin AND [Year] = @Ejercicio 
AND SUBSTRING(CuentaAcumulacion,1,LEN('1233')) = '1233' AND Afectable != 0 --AND SUBSTRING(CuentaAcumulacion,1,LEN('1112')) = '1112'
GROUP BY Cont.NumeroCuenta, Cont.NombreCuenta, TipoCuenta,CargosSinFlujo, AbonosSinFlujo, TotalCargos, TotalAbonos
ORDER BY Cont.NumeroCuenta;

SELECT * FROM @Tabla WHERE (NumeroCuenta = '1233' OR SUBSTRING(NumeroCuenta,1,LEN('1233')) = '1233');

END

GO
EXEC SP_FirmasReporte 'Relacion Analitica de Edificios NO Habitacionales ISAF' 

GO

Exec SP_CFG_LogScripts 'SP_RPT_Relacion_Analitica_Edificios_NO_Habitacionales_ISAF','2.29'
GO