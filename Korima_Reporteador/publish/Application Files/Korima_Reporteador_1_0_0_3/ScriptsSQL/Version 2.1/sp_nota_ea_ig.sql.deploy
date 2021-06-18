Update C_Menu Set Utilizar = 1 Where IdMenu in (1103, 1102, 1081)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_ea_ig]') AND type in (N'P'))
DROP PROCEDURE sp_nota_ea_ig
GO

CREATE PROCEDURE sp_nota_ea_ig
@ejercicio int, @periodo int
AS
DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), Monto decimal(15,2), Nota text, porcentaje decimal(15,2), negritas bit, tipo bit)

DECLARE @total decimal(15,2)

SELECT @total = SUM(AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos)
FROM C_Contable a INNER JOIN T_SaldosInicialesCont b ON a.IdCuentaContable = b.IdCuentaContable
WHERE Mes = @periodo AND [Year] = @ejercicio AND SUBSTRING(a.NumeroCuenta,1,3) IN ('410','420')

Insert Into @tablaRpt 
Select NumeroCuenta, NombreCuenta, 0, '', 0, 0, 0 From C_Contable
Where Substring(NumeroCuenta,1,2) In ('41','42')
AND (SUBSTRING(NumeroCuenta,7,5) = '00000' or SUBSTRING(NumeroCuenta,7,6) = '000000' )
Order By NumeroCuenta

Update @tablaRpt Set Monto = b.AbonosSinFlujo - b.CargosSinFlujo + b.TotalAbonos - b.TotalCargos,
porcentaje = (((b.AbonosSinFlujo - b.CargosSinFlujo + b.TotalAbonos - b.TotalCargos)*100)/@total),
Nota = Substring(Cuenta,1,5) + ' Click para editar...',
Cuenta = Substring(Cuenta,1,5)
From T_SaldosInicialesCont b INNER JOIN C_Contable c ON b.IdCuentaContable = c.IdCuentaContable
INNER JOIN @tablaRpt a ON a.Cuenta = c.NumeroCuenta
Where Mes = @periodo And [Year] = @ejercicio

Update @tablaRpt Set negritas = 1
Where SUBSTRING(Cuenta,1,2) In ('41', '42')
And SUBSTRING(Cuenta,4,1) = '0'

Update @tablaRpt Set tipo = 1
Where SUBSTRING(Cuenta,1,3) In ('410', '420')


Select SUBSTRING(Cuenta,1,5) as Cuenta, Nombre, Monto/1000 as Monto, porcentaje, Nota, negritas, tipo From @tablaRpt Order by Cuenta


GO




update C_Menu set Utilizar = 1 Where IdMenu =1103
GO

Exec SP_FirmasReporte 'Ingresos de Gestión'
GO
--exec sp_nota_ea_ig 2012, 1