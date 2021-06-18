IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Relacion_Analitica_Mobiliario_Equipo_Admon_ISAF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Relacion_Analitica_Mobiliario_Equipo_Admon_ISAF]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RPT_Relacion_Analitica_Mobiliario_Equipo_Admon_ISAF 1,7,2019;
CREATE PROCEDURE [dbo].[SP_RPT_Relacion_Analitica_Mobiliario_Equipo_Admon_ISAF]
@MesInicio smallint,    
@MesFin smallint,
@Ejercicio smallint

AS
BEGIN

--DECLARE @Tabla TABLE
--	(NumeroCuenta VARCHAR(max),
--	NombreCuenta VARCHAR(max),
--	CargosSinFlujo DECIMAL(18,2),
--	TotalCargos DECIMAL(18,2),
--	TotalAbonos DECIMAL(18,2),
--	SaldoDeudor DECIMAL(18,2),
--	Mes int,
--	Year int);

--INSERT INTO @Tabla
--	SELECT Cont.NumeroCuenta, 
--	Cont.NombreCuenta, 
--	Saldos.CargosSinFlujo, 
--	Saldos.TotalCargos, 
--	Saldos.TotalAbonos, 
--	CASE Cont.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo
--	+ TotalCargos - TotalAbonos WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE 0 END AS SaldoDeudor,
--	Saldos.Mes, 
--	Saldos.Year
--FROM C_Contable Cont INNER JOIN T_SaldosInicialesCont Saldos
--ON Cont.IdCuentaContable = Saldos.IdCuentaContable
--WHERE (Cont.TipoCuenta <> 'X') AND Mes BETWEEN @MesInicio AND @MesFin AND [Year] = @Ejercicio 
--AND SUBSTRING(CuentaAcumulacion,1,LEN('1241')) = '1241' AND Afectable != 0 --AND SUBSTRING(CuentaAcumulacion,1,LEN('1112')) = '1112'
--ORDER BY Cont.NumeroCuenta;

--SELECT * FROM @Tabla WHERE (NumeroCuenta = '1241' OR SUBSTRING(NumeroCuenta,1,LEN('1241')) = '1241');

DECLARE @MobAdmon TABLE
	(No_Inventario VARCHAR(max),
	No_Serie VARCHAR(max),
	Denominacion VARCHAR(max),
	Responsable VARCHAR(max),
	AreaAsignada VARCHAR(max),
	ValorBien DECIMAL(18,2),
	NumeroCuenta VARCHAR(MAX));

	--INSERT INTO @MobAdmon
	--	SELECT Activ.NumeroEconomico, 
	--	Activ.NoSerie, 
	--	Activ.Descripcion,
	--	CONCAT(Emp.Nombres,' ',Emp.ApellidoPaterno,' ',Emp.ApellidoMaterno) AS Responsable,
	--	ISNULL(Depas.NombreDepartamento,'') AS AreaAsignada, 
	--	Activ.CostoAdquisicion
	--FROM T_Activos Activ LEFT JOIN  D_Resguardos Resg_D
	--ON Activ.NumeroEconomico = Resg_D.NumeroEconomico LEFT JOIN T_Resguardos Resg_T
	--ON Resg_D.FolioResguardo = Resg_T.FolioResguardo LEFT JOIN C_Empleados Emp
	--ON Resg_T.NumeroEmpleadoDestino = Emp.NumeroEmpleado LEFT JOIN C_Departamentos Depas
	--ON Emp.IdDepartamento =  Depas.IdDepartamento
	--WHERE YEAR(Activ.FechaUA) = @Ejercicio AND MONTH(Activ.FechaUA) BETWEEN @MesInicio AND @MesFin;

	--SELECT * FROM @MobAdmon;

	INSERT INTO @MobAdmon
	SELECT Activ.NumeroEconomico, 
		Activ.NoSerie, 
		Activ.Descripcion,
		(Emp.Nombres + ' ' + Emp.ApellidoPaterno + ' ' + Emp.ApellidoMaterno) AS Responsable,
		ISNULL(Ubica.Ubicacion,'') AS AreaAsignada, 
		Activ.CostoAdquisicion,
		Cont.NumeroCuenta
	FROM T_Activos Activ LEFT JOIN  D_Resguardos Resg_D
		ON Activ.NumeroEconomico = Resg_D.NumeroEconomico LEFT JOIN T_Resguardos Resg_T
		ON Resg_D.FolioResguardo = Resg_T.FolioResguardo LEFT JOIN C_Empleados Emp
		ON Resg_T.NumeroEmpleadoDestino = Emp.NumeroEmpleado LEFT JOIN C_UbicacionesFisicas Ubica
		ON Resg_D.IdUbicacion =  Ubica.IdUbicacion LEFT JOIN C_TipoBien Tipo
		ON Activ.IdTipoBien = Tipo.IdTipoBien LEFT JOIN R_CtasContxCtesProvEmp CtaProv
		ON Tipo.IdTipoBien = CtaProv.IdTipoBien AND CtaProv.IdTipoCuenta = Tipo.IdCuentaContable
		LEFT JOIN C_Contable Cont ON CtaProv.IdCuentaContable = Cont.IdCuentaContable
	WHERE YEAR(Activ.FechaUA) = @Ejercicio AND MONTH(Activ.FechaUA) BETWEEN @MesInicio AND @MesFin


	SELECT * FROM @MobAdmon WHERE (NumeroCuenta = '1241' OR SUBSTRING(NumeroCuenta,1,LEN('1241')) = '1241') ORDER BY No_Inventario;


END

GO
EXEC SP_FirmasReporte 'Relacion Analitica de Mobiliarios y Equipos de Admon ISAF' 

GO

Exec SP_CFG_LogScripts 'SP_RPT_Relacion_Analitica_Mobiliario_Equipo_Admon_ISAF','2.29'
GO