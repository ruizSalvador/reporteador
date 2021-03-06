/****** Object:  StoredProcedure [dbo].[sp_nota_if_fideicomisos]    Script Date: 12/07/2012 16:39:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_if_fideicomisos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_nota_if_fideicomisos]
GO
/****** Object:  StoredProcedure [dbo].[sp_nota_if_fideicomisos]    Script Date: 12/07/2012 16:39:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[sp_nota_if_fideicomisos]

@ejercicio int, 
@periodo int,
@Miles bit

AS

declare @Division int
if @Miles=1 set @Division=1000
else set @Division=1

DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), Monto decimal(15,2),Nota1 text)

INSERT INTO @tablaRpt
Select NumeroCuenta as Cuenta, NombreCuenta as Nombre, 0,SUBSTRING(NumeroCuenta,1,5) + ' Click para editar...'
FROM C_Contable
WHERE TipoCuenta <> 'X' And NumeroCuenta IN ('12100-00000','12130-00000','12131-00000','12132-00000','12133-00000','12134-00000','12135-00000','12136-00000','12137-00000','12138-00000','12139-00000')


Order By NumeroCuenta

UPDATE @tablaRpt SET Monto = (isnull(CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos,0)/@Division)
FROM C_Contable INNER JOIN @tablaRpt a ON C_Contable.NumeroCuenta = a.Cuenta
INNER JOIN T_SaldosInicialesCont Saldos On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
WHERE Mes = @periodo And [Year] = @ejercicio

SELECT SUBSTRING(Cuenta,1,5) as Cuenta, Nombre, Monto ,Nota1 FROM @tablaRpt


GO

update C_Menu set Utilizar = 1 Where IdMenu In(1082,1089)
GO

Exec SP_FirmasReporte 'Notas al Estado de Situación Financiera_if_fideicomisos'
GO
Exec SP_CFG_LogScripts 'sp_nota_if_fideicomisos'
GO
