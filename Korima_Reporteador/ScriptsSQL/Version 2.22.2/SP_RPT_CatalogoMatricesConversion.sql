
/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoMatricesConversion]    Script Date: 04/25/2016 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CatalogoMatricesConversion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CatalogoMatricesConversion]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoMatricesConversion]    Script Date: 04/25/2016 11:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_CatalogoMatricesConversion] 

@Tipo as int

AS
BEGIN
Declare @Todos as table (
		TipoCuenta varchar(50)
      ,Descripcion varchar(50)
      ,CuentaInicial varchar(50)
      ,CuentaAcumulacion varchar (50)
      ,CriCogInicial varchar (50)
      ,CriCogFinal varchar (50)
      ,TipoGasto varchar(50)    
 )

 Insert into @Todos
Select 
	CASE Tipo 
		WHEN 'E' THEN 'Empleados'
		WHEN 'P' THEN 'Proveedores'
		WHEN 'C' THEN 'Clientes'
		WHEN 'A' THEN 'Activos'
		WHEN 'T' THEN 'Tarifario'
		WHEN 'S' THEN 'Presupuesto Egresos'
		WHEN 'I' THEN 'Presupuesto Ingresos'
		WHEN 'B' THEN 'Bancos'
		WHEN 'N' THEN 'Nómina'
		WHEN 'O' THEN 'Obra'
		WHEN 'W' THEN 'Retenciones'
		WHEN 'Z' THEN 'Almacenes'
		WHEN 'F' THEN 'Efectivo'
		WHEN 'V' THEN 'Beneficiario'
		WHEN 'R' THEN 'Contratistas'
	ELSE 'Otro'
	END as TipoCuenta, 
	   CTC.Descripcion as Descripcion, 
	   CuentaInicial, 
	   CC.NumeroCuenta as CuentaAcumulacion, 
       Condicion as CriCogInicial, 
	   Condicion2 as CriCogFinal,
	   CuentaFinal as TipoGasto
from T_CuentasAutomaticas TCA
INNER JOIN C_TipoCuentas CTC
	ON TCA.IdTipoCuenta = CTC.IdTipoCuenta
INNER JOIN C_Contable CC
	ON CC.IdCuentaContable = TCA.IdCuentaContablePadre
	ORder by Condicion,NombreCuenta



If @Tipo = 0
	Begin
		Select * from @Todos
	End

If @Tipo = 1
	Begin
		Select * from @Todos Where TipoCuenta IN ('Clientes', 'Tarifario', 'Presupuesto Ingresos')
	End

If @Tipo = 2
	Begin
		Select * from @Todos Where TipoCuenta NOT IN ('Clientes', 'Tarifario', 'Presupuesto Ingresos')
	End

END
--exec [SP_RPT_CatalogoMatricesConversion]


