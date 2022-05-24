/****** Object:  StoredProcedure [dbo].[sp_nota_InvFinan_SPyAC]    Script Date: 12/05/2012 11:14:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_InvFinan_SPyAC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_nota_InvFinan_SPyAC]
GO
/****** Object:  StoredProcedure [dbo].[sp_nota_InvFinan_SPyAC]    Script Date: 12/05/2012 11:14:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_nota_InvFinan_SPyAC]

@ejercicio int, 
@periodo int,
@Miles bit

AS

declare @Division int
if @Miles=1 set @Division=1000
else set @Division=1

DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), Monto decimal(15,2))

INSERT INTO @tablaRpt
Select NumeroCuenta as Cuenta, NombreCuenta as Nombre, 0
FROM C_Contable
WHERE TipoCuenta <> 'X' And NumeroCuenta IN ('12100-00000','12140-00000','12141-00000','12142-00000','12143-00000')


Order By NumeroCuenta

UPDATE @tablaRpt SET Monto = (isnull(CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos,0)/@Division)
FROM C_Contable INNER JOIN @tablaRpt a ON C_Contable.NumeroCuenta = a.Cuenta
INNER JOIN T_SaldosInicialesCont Saldos On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
WHERE Mes = @periodo And [Year] = @ejercicio

SELECT SUBSTRING(Cuenta,1,5) as Cuenta, Nombre, Monto FROM @tablaRpt

GO

update C_Menu set Utilizar = 1 Where IdMenu In(1082,1090)
GO

Exec SP_FirmasReporte 'Notas al Estado de Situación Financiera -IF-Saldos Aportaciones y Aportaciones Capital'
GO
Exec SP_CFG_LogScripts 'sp_nota_InvFinan_SPyAC'
GO