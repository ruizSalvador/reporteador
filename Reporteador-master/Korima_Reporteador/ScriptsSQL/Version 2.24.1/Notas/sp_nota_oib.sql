Update C_Menu Set Utilizar = 1 Where IdMenu in (1104, 1102, 1081)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_oib]') AND type in (N'P'))
DROP PROCEDURE sp_nota_oib
GO

CREATE PROCEDURE sp_nota_oib
@ejercicio int, @periodo int, @Miles bit
AS

declare @Division int
if @Miles=1 set @Division=1000
else set @Division=1
DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), Monto decimal(15,2), Nota text, porcentaje decimal(15,2), negritas bit, tipo bit)

DECLARE @total decimal(15,2)

SELECT @total = isnull((Select SUM(AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos)
FROM C_Contable a INNER JOIN T_SaldosInicialesCont b ON a.IdCuentaContable = b.IdCuentaContable
WHERE Mes = @periodo AND [Year] = @ejercicio 
AND a.NumeroCuenta Like '430%'),0)

Insert Into @tablaRpt 
Select NumeroCuenta, NombreCuenta, 0, Substring(NumeroCuenta,1,5) + ' Click para editar...', 0, 0, 0 From C_Contable
Where NumeroCuenta like '43%'
AND (SUBSTRING(NumeroCuenta,7,5) = '00000' or SUBSTRING(NumeroCuenta,7,6) = '000000')
Order By NumeroCuenta

If @total > 0
begin
Update @tablaRpt Set Monto = b.AbonosSinFlujo - b.CargosSinFlujo + b.TotalAbonos - b.TotalCargos,
porcentaje = (((b.AbonosSinFlujo - b.CargosSinFlujo + b.TotalAbonos - b.TotalCargos)*100)/@total)
From T_SaldosInicialesCont b INNER JOIN C_Contable c ON b.IdCuentaContable = c.IdCuentaContable
INNER JOIN @tablaRpt a ON a.Cuenta = c.NumeroCuenta
Where Mes = @periodo And [Year] = @ejercicio
end
else if @total = 0
begin
Update @tablaRpt Set Monto = 0
end 

Update @tablaRpt Set negritas = 1
Where Cuenta like '43%' and SUBSTRING(Cuenta,4,1) = '0'

Update @tablaRpt Set tipo = 1
Where Cuenta like '430%'

Select substring(Cuenta,1,5)as Cuenta, Nombre, Monto/@Division as Monto, porcentaje, Nota, negritas, tipo From @tablaRpt Order by Cuenta



GO




Exec SP_FirmasReporte 'Otros Ingresos y Beneficios'
GO
Exec SP_CFG_LogScripts 'sp_nota_oib'
GO
--exec sp_nota_oib 1, 2012