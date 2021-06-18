Update C_Menu Set Utilizar = 1 Where IdMenu in (1101, 1099, 1081)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_evhpp_mpg_mprmpg]') AND type in (N'P'))
DROP PROCEDURE sp_nota_evhpp_mpg_mprmpg
GO
CREATE PROCEDURE sp_nota_evhpp_mpg_mprmpg
@ejercicio int, @periodo int
AS
DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), Monto decimal(15,2))
INSERT INTO @tablaRpt
Select NumeroCuenta as Cuenta, NombreCuenta as Nombre, 0
FROM C_Contable
WHERE TipoCuenta <> 'X' And NumeroCuenta IN ('32000-00000','32100-00000','32200-00000','32300-00000','32400-00000','32500-00000') 
Order By NumeroCuenta

UPDATE @tablaRpt SET Monto = (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos) /1000
FROM C_Contable INNER JOIN @tablaRpt a ON C_Contable.NumeroCuenta = a.Cuenta
INNER JOIN T_SaldosInicialesCont Saldos On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
WHERE Mes = @periodo And [Year] = @ejercicio

SELECT substring(Cuenta,1,5) as Cuenta, Nombre, Monto FROM @tablaRpt

GO

Exec SP_FirmasReporte 'Monto y procedencia de los recursos que modifican al patrimonio generado'
GO