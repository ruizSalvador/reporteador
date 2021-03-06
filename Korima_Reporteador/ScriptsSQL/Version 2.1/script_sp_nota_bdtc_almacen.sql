/****** Object:  StoredProcedure [dbo].[sp_nota_bdtc_almacen]    Script Date: 12/04/2012 17:26:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_bdtc_almacen]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_nota_bdtc_almacen]
GO
/****** Object:  StoredProcedure [dbo].[sp_nota_bdtc_almacen]    Script Date: 12/04/2012 17:26:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_nota_bdtc_almacen]

@ejercicio int, 
@periodo int

AS
DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), Monto decimal(15,2))

INSERT INTO @tablaRpt
Select NumeroCuenta as Cuenta, NombreCuenta as Nombre, 0
FROM C_Contable
WHERE TipoCuenta <> 'X' And NumeroCuenta IN ('11510-00000','11511-00000','11512-00000','11513-00000','11514-00000','11515-00000','11516-00000','11517-00000','11518-00000')


Order By NumeroCuenta

UPDATE @tablaRpt SET Monto = (isnull(CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos,0)/1000)
FROM C_Contable INNER JOIN @tablaRpt a ON C_Contable.NumeroCuenta = a.Cuenta
INNER JOIN T_SaldosInicialesCont Saldos On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
WHERE Mes = @periodo And [Year] = @ejercicio

SELECT SUBSTRING(Cuenta,1,5) as Cuenta, Nombre, Monto FROM @tablaRpt


GO

update C_Menu set Utilizar = 1 Where IdMenu In(1082,1088)
GO

Exec SP_FirmasReporte 'Notas al Estado de Situación Financiera- BDTC-Almacén'
GO