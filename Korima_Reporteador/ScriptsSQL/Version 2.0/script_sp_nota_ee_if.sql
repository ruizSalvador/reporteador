/****** Object:  StoredProcedure [dbo].[sp_nota_ee_if]    Script Date: 12/04/2012 12:12:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_ee_if]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_nota_ee_if]
GO
/****** Object:  StoredProcedure [dbo].[sp_nota_ee_if]    Script Date: 12/04/2012 12:12:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_nota_ee_if]
@ejercicio int, 
@periodo int

AS


DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), Monto decimal(15,2),seccion char(1))

Insert Into @tablaRpt
Select NumeroCuenta, NombreCuenta, 0 as Monto, 1 as Seccion from C_Contable
Where TipoCuenta <> 'X' And SUBSTRING(NumeroCuenta,1,5) = '11140'
And RIGHT(RTRIM(NumeroCuenta), 1) != '0'
Union All
Select NumeroCuenta, NombreCuenta, 0 as Monto, 2 as Seccion from C_Contable
Where TipoCuenta <> 'X' And SUBSTRING(NumeroCuenta,1,5) = '11210'
And RIGHT(RTRIM(NumeroCuenta), 1) != '0'
Union All
Select NumeroCuenta, NombreCuenta, 0 as Monto, 3 as Seccion from C_Contable
Where TipoCuenta <> 'X' And SUBSTRING(NumeroCuenta,1,5) = '12110'
And RIGHT(RTRIM(NumeroCuenta), 1) != '0'

UPDATE @tablaRpt 
SET  Monto = (isnull(CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos,0)/1000)
FROM C_Contable b INNER JOIN @tablaRpt a ON b.NumeroCuenta = a.Cuenta
INNER JOIN T_SaldosInicialesCont Saldos On b.IdCuentaContable = Saldos.IdCuentaContable
WHERE Mes = @periodo And [Year] = @ejercicio

IF (Select DISTINCT 1 From @tablaRpt Where Cuenta like '11140%') IS NULL
BEGIN
	Insert Into @tablaRpt
	Select '', '', 0, 1
END
IF (Select DISTINCT  1 From @tablaRpt Where Cuenta like '11210%') IS NULL
BEGIN
	Insert Into @tablaRpt
	Select '', '', 0, 2
END
IF (Select DISTINCT  1 From @tablaRpt Where Cuenta like '12110%') IS NULL
BEGIN
	Insert Into @tablaRpt
	Select '', '', 0, 3
END

Select * From @tablaRpt Order By Cuenta

GO


update C_Menu set Utilizar = 1 Where IdMenu In(1082,1084)
GO

Exec SP_FirmasReporte 'Notas al Estado de Situación Financiera-EE-Inversiones Financieras'
GO