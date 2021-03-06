/****** Object:  StoredProcedure [dbo].[sp_nota_nm_presupuestarias]    Script Date: 01/04/2013 17:48:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_nm_presupuestarias]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_nota_nm_presupuestarias]
GO
/****** Object:  StoredProcedure [dbo].[sp_nota_nm_presupuestarias]    Script Date: 01/04/2013 17:48:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_nota_nm_presupuestarias]

@ejercicio int, 
@periodo int

AS
DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), Monto decimal(15,2),Nota1 text)

INSERT INTO @tablaRpt
Select NumeroCuenta as Cuenta, NombreCuenta as Nombre, 0,SUBSTRING(NumeroCuenta,1,5) +  '....Click para editar...'
FROM C_Contable
WHERE TipoCuenta <> 'X' And NumeroCuenta IN ('80000-00000','81000-00000','81100-00000','81200-00000','81300-00000','81400-00000',
'81500-00000','82000-00000','82100-00000','82200-00000','82300-00000','82400-00000','82500-00000','82600-00000','82700-00000')
Order By NumeroCuenta


UPDATE @tablaRpt SET Monto = (isnull(CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos,0)/1000)
FROM C_Contable INNER JOIN @tablaRpt a ON C_Contable.NumeroCuenta = a.Cuenta
INNER JOIN T_SaldosInicialesCont Saldos On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
WHERE Mes = @periodo  And [Year] = @ejercicio



SELECT SUBSTRING(Cuenta,1,5) as Cuenta, Nombre, Monto ,Nota1 FROM @tablaRpt
GO

update C_Menu set Utilizar = 1 Where IdMenu In(1181,1183)
update C_Menu set IdPadre = 1181 Where IdMenu = 1183
update C_Menu set NombreMenu = 'Notas Presupuestarias' Where IdMenu = 1183
update C_Menu set Descripcion  = 'Notas Presupuestarias' Where IdMenu = 1183
GO


Exec SP_FirmasReporte 'Notas al Estado de Situación Financiera_NotasdeMemoria_presupuestarias'
GO