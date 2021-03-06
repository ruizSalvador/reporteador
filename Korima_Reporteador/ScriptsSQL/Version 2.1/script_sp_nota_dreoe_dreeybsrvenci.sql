/****** Object:  StoredProcedure [dbo].[sp_nota_dreoe_dreeybsrv]    Script Date: 12/11/2012 09:33:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_dreoe_dreeybsrv]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_nota_dreoe_dreeybsrv]
GO
/****** Object:  StoredProcedure [dbo].[sp_nota_dreoe_dreeybsrv]    Script Date: 12/11/2012 09:33:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_nota_dreoe_dreeybsrv]

@ejercicio int, 
@periodo int

AS
DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), Monto decimal(15,2), Monto365 decimal(15,2), seccion char(1), Nota1 decimal(15,2), Nota2 decimal(15,2), Nota3 decimal(15,2) )
INSERT INTO @tablaRpt
Select NumeroCuenta as Cuenta, NombreCuenta as Nombre, 0,0,
      case SUBSTRING(NumeroCuenta,1,5)
      when '11200' Then '1'
      when '11300' Then '2'
      when '12200' Then '3'
      Else 0 End, 0, 0, 0
FROM C_Contable
WHERE TipoCuenta <> 'X' and NumeroCuenta IN('11200-00000','11220-00000','11230-00000','11250-00000','11260-00000','11290-00000')

Order By NumeroCuenta

INSERT INTO @tablaRpt
Select NumeroCuenta as Cuenta, NombreCuenta as Nombre, 0,0,
      case SUBSTRING(NumeroCuenta,1,5)
      when '11200' Then '1'
      when '11300' Then '2'
      when '12200' Then '3'
      Else 0 End, 0, 0, 0
FROM C_Contable
WHERE TipoCuenta <> 'X' and NumeroCuenta IN('11300-00000','11310-00000','11320-00000','11330-00000','11340-00000','11390-00000') 

Order By NumeroCuenta

INSERT INTO @tablaRpt
Select NumeroCuenta as Cuenta, NombreCuenta as Nombre, 0,0,
      case SUBSTRING(NumeroCuenta,1,5)
      when '11200' Then '1'
      when '11300' Then '2'
      when '12200' Then '3'
      Else 0 End, null, null, null
FROM C_Contable
WHERE TipoCuenta <> 'X' and  NumeroCuenta IN('12200-00000','12210-00000','12220-00000','12240-00000','12290-00000') 
Order By NumeroCuenta
     
UPDATE @tablaRpt SET Monto = (isnull(CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos,0)/1000)
FROM C_Contable INNER JOIN @tablaRpt a ON C_Contable.NumeroCuenta = a.Cuenta
INNER JOIN T_SaldosInicialesCont Saldos On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
WHERE Mes = @periodo And [Year] = @ejercicio


UPDATE @tablaRpt SET Monto365 = (isnull(CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos,0)/1000)
FROM C_Contable INNER JOIN @tablaRpt a ON C_Contable.NumeroCuenta = a.Cuenta
INNER JOIN T_SaldosInicialesCont Saldos On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
WHERE Mes = @periodo and [Year] = @ejercicio and NumeroCuenta IN('12200-00000','12210-00000','12220-00000','12240-00000','12290-00000') 

Insert into @tablaRpt( 
Cuenta, Nombre, Monto , Monto365, seccion, Nota1, Nota2 , Nota3) values(

'TOTAL', '', 
isnull((Select SUM (monto) from @tablaRpt where substring(Cuenta,1,5)='1120' or substring(Cuenta,1,5)='1130' or substring(Cuenta,1,5)='1220'),0) , 
isnull((Select SUM (monto365) from @tablaRpt where substring(Cuenta,1,5)='1120'or substring(Cuenta,1,5)='1130' or substring(Cuenta,1,5)='1220'),0), 
'4',0, 0, 0
)

SELECT SUBSTRING(Cuenta,1,5) as Cuenta, Nombre, Monto, Monto365, seccion,Nota1,Nota2,Nota3  FROM @tablaRpt



GO
update C_Menu set Utilizar = 1 Where IdMenu In(1082,1086)
GO

Exec SP_FirmasReporte 'Notas al Estado de Situación Financiera-DREoE-Dreye-bosrvenc'
GO
