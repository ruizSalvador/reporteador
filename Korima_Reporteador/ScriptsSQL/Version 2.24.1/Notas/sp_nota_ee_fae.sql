Update C_Menu set Utilizar = 1 where IdMenu in (1083,1082,1081)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_ee_fae]') AND type in (N'P'))
DROP PROCEDURE sp_nota_ee_fae
GO
--exec sp_nota_ee_fae 2016,4,0
CREATE PROCEDURE sp_nota_ee_fae
@ejercicio int, @periodo int, @miles bit
AS

declare @Division int
if @Miles=1 set @Division=1000
else set @Division=1

DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), Monto decimal(15,2))
INSERT INTO @tablaRpt
Select NumeroCuenta as Cuenta, NombreCuenta as Nombre, 0
FROM C_Contable
WHERE TipoCuenta <> 'X' And SUBSTRING(NumeroCuenta,1,5) = '11150' And SUBSTRING(NumeroCuenta,1,11) != '11150-00000'
Order By NumeroCuenta

UPDATE @tablaRpt SET Monto = ((CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)/@Division)
FROM C_Contable INNER JOIN @tablaRpt a ON C_Contable.NumeroCuenta = a.Cuenta
INNER JOIN T_SaldosInicialesCont Saldos On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
WHERE Mes = @periodo And [Year] = @ejercicio

SELECT * FROM @tablaRpt

GO

Exec SP_FirmasReporte 'Fondos con Afectación Específica'
GO
Exec SP_CFG_LogScripts 'sp_nota_ee_fae'
GO