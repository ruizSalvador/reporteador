Update C_Menu Set Utilizar = 1 Where IdMenu in (1107, 1106, 1081)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_efe_sif]') AND type in (N'P'))
DROP PROCEDURE sp_nota_efe_sif
GO

CREATE PROCEDURE sp_nota_efe_sif
@ejercicio int, @periodo int
AS
DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), SaldoInicial decimal(15,2), SaldoFinal decimal(15,2), SaldoInicialAnt decimal(15,2), SaldoFinalAnt decimal(15,2), anio int)

DECLARE @total decimal(15,2)

Insert Into @tablaRpt 
Select NumeroCuenta, NombreCuenta, 0, 0, 0, 0, @ejercicio   From C_Contable
Where NumeroCuenta In ('11100-00000','11110-00000','11120-00000','11130-00000','11140-00000','11150-00000','11160-00000','11190-00000','11100-000000','11110-000000','11120-000000','11130-000000','11140-000000','11150-000000','11160-000000','11190-000000') Order By NumeroCuenta

Update @tablaRpt Set SaldoInicial = b.CargosSinFlujo, SaldoFinal = b.CargosSinFlujo - b.AbonosSinFlujo + b.TotalCargos - b.TotalAbonos
From T_SaldosInicialesCont b INNER JOIN C_Contable c ON b.IdCuentaContable = c.IdCuentaContable
INNER JOIN @tablaRpt a ON a.Cuenta = c.NumeroCuenta
Where Mes = @periodo And [Year] = @ejercicio

Update @tablaRpt Set SaldoInicialAnt = b.CargosSinFlujo, SaldoFinalAnt = b.CargosSinFlujo - b.AbonosSinFlujo + b.TotalCargos - b.TotalAbonos
From T_SaldosInicialesCont b INNER JOIN C_Contable c ON b.IdCuentaContable = c.IdCuentaContable
INNER JOIN @tablaRpt a ON a.Cuenta = c.NumeroCuenta
Where Mes = @periodo And [Year] = @ejercicio -1 

Select SUBSTRING(Cuenta,1,5) as Cuenta, Nombre, SaldoInicial/1000 as SaldoInicial,
SaldoFinal/1000 as SaldoFinal, SaldoInicialAnt/1000 as SaldoInicialAnt, SaldoFinalAnt/1000 as SaldoFinalAnt,anio 
From @tablaRpt Order by Cuenta


GO

Exec SP_FirmasReporte 'Efectivo y Equivalentes - Saldo Inicial y Final'
GO
--exec sp_nota_efe_sif 1, 2012