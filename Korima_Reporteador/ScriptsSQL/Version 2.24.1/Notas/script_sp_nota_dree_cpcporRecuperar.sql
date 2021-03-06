/****** Object:  StoredProcedure [dbo].[sp_nota_dree_cpcporRecuperar]    Script Date: 12/11/2012 09:38:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_dree_cpcporRecuperar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_nota_dree_cpcporRecuperar]
GO
/****** Object:  StoredProcedure [dbo].[sp_nota_dree_cpcporRecuperar]    Script Date: 12/11/2012 09:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec sp_nota_dree_cpcporRecuperar 2016,4,0
CREATE PROCEDURE [dbo].[sp_nota_dree_cpcporRecuperar]

@ejercicio int, 
@periodo int,
@Miles bit

AS

declare @Division int
if @Miles=1 set @Division=1000
else set @Division=1

DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), Monto decimal(15,2),Nota1 decimal(15,2))

INSERT INTO @tablaRpt
Select NumeroCuenta as Cuenta, NombreCuenta as Nombre, 0,0 
FROM C_Contable
WHERE TipoCuenta <> 'X' And NumeroCuenta IN ('11240-00001','11240-00002','112401-00003','11240-00004','11240-00005','11240-00006','12230-00000')


Order By NumeroCuenta

UPDATE @tablaRpt SET Monto = (isnull(CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos,0)/@Division)
FROM C_Contable INNER JOIN @tablaRpt a ON C_Contable.NumeroCuenta = a.Cuenta
INNER JOIN T_SaldosInicialesCont Saldos On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
WHERE Mes = @periodo And [Year] = @ejercicio


SELECT Cuenta, Nombre, Monto, Nota1 FROM @tablaRpt
GO

update C_Menu set Utilizar = 1 Where IdMenu In(1082,1085)
GO

Exec SP_FirmasReporte 'Notas al Estado de Situación Financiera-DREoE-CPdeCyRecuperar'
GO
Exec SP_CFG_LogScripts 'sp_nota_dree_cpcporRecuperar'
GO