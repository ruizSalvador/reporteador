Update C_Menu Set Utilizar = 1 Where IdMenu in (1108, 1106)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_bmi_armscsc]') AND type in (N'P'))
DROP PROCEDURE sp_nota_bmi_armscsc
GO

CREATE PROCEDURE sp_nota_bmi_armscsc
@ejercicio int, @periodo int
AS
DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), Monto decimal(15,2), Nota1 decimal(15,2), Nota2 text, negritas bit, tipo bit)

Insert Into @tablaRpt 
Select NumeroCuenta, NombreCuenta, 0, 0, 'Click para editar', 0, 0 From C_Contable
Where substring(NumeroCuenta,1,3) in ('123','124') AND (SUBSTRING(NumeroCuenta,7,5) = '00000' or SUBSTRING(NumeroCuenta,7,6) = '000000')
Order By NumeroCuenta

Update @tablaRpt Set Monto = CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos,
Cuenta = Substring(Cuenta,1,5)
From T_SaldosInicialesCont b INNER JOIN C_Contable c ON b.IdCuentaContable = c.IdCuentaContable
INNER JOIN @tablaRpt a ON a.Cuenta = c.NumeroCuenta
Where Mes = @periodo And [Year] = @ejercicio

Update @tablaRpt Set negritas = 1
Where Cuenta in ('12300','12340','12350','12360','12390','12400','12410','12410','12420','12430','12440','12450','12460','12470','12480')
And SUBSTRING(Cuenta,5,1) = '0'

Update @tablaRpt Set tipo = 1
Where Cuenta In ('12300','12400')


Select SUBSTRING(Cuenta,1,5) as Cuenta, Nombre, Monto/1000 as Monto, Nota1, Nota2, negritas, tipo From @tablaRpt Order by Cuenta


GO




Exec SP_FirmasReporte 'Efectivo y Equivalentes - Bienes Muebles e Inmuebles'
GO
--exec sp_nota_bmi_armscsc 2012, 1