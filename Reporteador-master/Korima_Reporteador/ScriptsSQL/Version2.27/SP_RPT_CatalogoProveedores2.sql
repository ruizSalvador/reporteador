/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoProveedores2]    Script Date: 08/11/2015 12:57:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CatalogoProveedores2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CatalogoProveedores2]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoProveedores2]    Script Date: 08/11/2015 12:57:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[SP_RPT_CatalogoProveedores2]
--@Fecha Datetime,
@Todo varchar (max),
@Tipo varchar(max),
@Periodo varchar (max),
@Ejercicio varchar (max),
@SaldoMayorCero int 

as
DECLARE @Tabla TABLE (IdProv int,RFC varchar(max),RazonSocial varchar(max),Domicilio varchar(max),Colonia varchar(max),CP int,Telefono varchar (max),GiroProv varchar(max),NumeroCuenta varchar(max),NombreBanco varchar(max),Valor1 varchar(max),Valor2 varchar(max),Observaciones varchar(max), contador int,Saldo decimal(18,2))

IF @Tipo <> '(Ninguno)' and @Todo = 'Activos' begin
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial,
 prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, 
 --tel.Numero 
 'Telefono: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Telefono')+
 ', Movil: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Movil')
 +', email: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='email')
 as Telefono,
cast(case
         When Prov.TipoProveedor like 'P' then 'Proveedor'
                 When Prov.TipoProveedor like 'C' then 'Contratista'
                 When Prov.TipoProveedor like 'V' then 'Beneficiario'
                 else '' end as varchar (max)) as GiroProv,
C_contable.NumeroCuenta as NumeroCuenta , C_Bancos.NombreBanco  as NombreBanco ,
Adicional.valor as Valor1 , Adicional2.Valor  as Valor2 ,
Prov.Observaciones as Observaciones, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
,isnull((T_SaldosInicialesCont.AbonosSinFlujo-T_SaldosInicialesCont.CargosSinFlujo+T_SaldosInicialesCont.TotalAbonos-T_SaldosInicialesCont.TotalCargos),0) as Saldo
from c_proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join R_CtasContxCtesProvEmp on Prov.IdProveedor = R_CtasContxCtesProvEmp.IdProveedor and R_CtasContxCtesProvEmp.IdTipoCuenta=1
left join C_Contable  on R_CtasContxCtesProvEmp.IdCuentaContable  = C_Contable.IdCuentaContable 
left join D_BancosProveedorDispercion on Prov.IdProveedor = D_BancosProveedorDispercion.IdProveedor
left join C_Bancos on D_BancosProveedorDispercion.IdBanco  = C_Bancos.IdBanco
left join D_DatosAdicionalesProveedorDispersion Adicional on Prov.IdProveedor  = Adicional.IdProveedor 
and Adicional.IdDato =1
left join D_DatosAdicionalesProveedorDispersion Adicional2 on Prov.IdProveedor  = Adicional2.IdProveedor 
and Adicional2.IdDato =2
left join T_SaldosInicialesCont on T_SaldosInicialesCont.IdCuentaContable= C_Contable.IdCuentaContable and T_SaldosInicialesCont.Mes=@Periodo and T_SaldosInicialesCont.Year=@Ejercicio
where Prov.TipoProveedor = @Tipo and prov.Opt_02 = 1 
Order by IdProv
END

IF @Tipo <> '(Ninguno)' and @Todo = '' begin
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial,
 prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, 
 --tel.Numero 
 'Telefono: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Telefono')+
 ', Movil: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Movil')
 +', email: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='email')
 as Telefono,
cast(case
         When Prov.TipoProveedor like 'P' then 'Proveedor'
                 When Prov.TipoProveedor like 'C' then 'Contratista'
                 When Prov.TipoProveedor like 'V' then 'Beneficiario'
                 else '' end as varchar (max)) as GiroProv,
C_contable.NumeroCuenta as NumeroCuenta , C_Bancos.NombreBanco  as NombreBanco ,
Adicional.valor as Valor1 , Adicional2.Valor  as Valor2 ,
Prov.Observaciones as Observaciones, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
,isnull((T_SaldosInicialesCont.AbonosSinFlujo-T_SaldosInicialesCont.CargosSinFlujo+T_SaldosInicialesCont.TotalAbonos-T_SaldosInicialesCont.TotalCargos),0) as Saldo
from c_proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join R_CtasContxCtesProvEmp on Prov.IdProveedor = R_CtasContxCtesProvEmp.IdProveedor and R_CtasContxCtesProvEmp.IdTipoCuenta=1
left join C_Contable  on R_CtasContxCtesProvEmp.IdCuentaContable  = C_Contable.IdCuentaContable
left join D_BancosProveedorDispercion on Prov.IdProveedor = D_BancosProveedorDispercion.IdProveedor
left join C_Bancos on D_BancosProveedorDispercion.IdBanco  = C_Bancos.IdBanco
left join D_DatosAdicionalesProveedorDispersion Adicional on Prov.IdProveedor  = Adicional.IdProveedor 
and Adicional.IdDato =1
left join D_DatosAdicionalesProveedorDispersion Adicional2 on Prov.IdProveedor  = Adicional2.IdProveedor 
and Adicional2.IdDato =2
left join T_SaldosInicialesCont on T_SaldosInicialesCont.IdCuentaContable= C_Contable.IdCuentaContable and T_SaldosInicialesCont.Mes=@Periodo and T_SaldosInicialesCont.Year=@Ejercicio
where Prov.TipoProveedor = @Tipo 
Order by IdProv
END

IF @Tipo = '(Ninguno)' and @Todo = 'Activos' begin
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial,
 prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, 
 --tel.Numero 
 'Telefono: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Telefono')+
 ', Movil: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Movil')
 +', email: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='email')
 as Telefono,
cast(case
         When Prov.TipoProveedor like 'P' then 'Proveedor'
                 When Prov.TipoProveedor like 'C' then 'Contratista'
                 When Prov.TipoProveedor like 'V' then 'Beneficiario'
                 else '' end as varchar (max)) as GiroProv,
C_contable.NumeroCuenta as NumeroCuenta , C_Bancos.NombreBanco as NombreBanco ,
Adicional.valor as Valor1 , Adicional2.Valor  as Valor2 ,
Prov.Observaciones as Observaciones, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
,isnull((T_SaldosInicialesCont.AbonosSinFlujo-T_SaldosInicialesCont.CargosSinFlujo+T_SaldosInicialesCont.TotalAbonos-T_SaldosInicialesCont.TotalCargos),0) as Saldo
from c_proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join R_CtasContxCtesProvEmp on Prov.IdProveedor = R_CtasContxCtesProvEmp.IdProveedor and R_CtasContxCtesProvEmp.IdTipoCuenta=1
left join C_Contable  on R_CtasContxCtesProvEmp.IdCuentaContable  = C_Contable.IdCuentaContable
left join D_BancosProveedorDispercion on Prov.IdProveedor = D_BancosProveedorDispercion.IdProveedor
left join C_Bancos on D_BancosProveedorDispercion.IdBanco  = C_Bancos.IdBanco
left join D_DatosAdicionalesProveedorDispersion Adicional on Prov.IdProveedor  = Adicional.IdProveedor 
and Adicional.IdDato =1
left join D_DatosAdicionalesProveedorDispersion Adicional2 on Prov.IdProveedor  = Adicional2.IdProveedor 
and Adicional2.IdDato =2
left join T_SaldosInicialesCont on T_SaldosInicialesCont.IdCuentaContable= C_Contable.IdCuentaContable and T_SaldosInicialesCont.Mes=@Periodo and T_SaldosInicialesCont.Year=@Ejercicio
where prov.Opt_02 = 1 
Order by IdProv
END

IF @Tipo = '(Ninguno)' and @Todo = '' begin
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial,
 prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, 
 --tel.Numero 
 'Telefono: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Telefono')+
 ', Movil: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Movil')
 +', email: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='email')
 as Telefono,
cast(case
         When Prov.TipoProveedor like 'P' then 'Proveedor'
                 When Prov.TipoProveedor like 'C' then 'Contratista'
                 When Prov.TipoProveedor like 'V' then 'Beneficiario'
                 else '' end as varchar (max)) as GiroProv,
C_contable.NumeroCuenta as NumeroCuenta , C_Bancos.NombreBanco as NombreBanco ,
Adicional.valor as Valor1 , Adicional2.Valor  as Valor2 ,
Prov.Observaciones as Observaciones, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
,isnull((T_SaldosInicialesCont.AbonosSinFlujo-T_SaldosInicialesCont.CargosSinFlujo+T_SaldosInicialesCont.TotalAbonos-T_SaldosInicialesCont.TotalCargos),0) as Saldo
from c_proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join R_CtasContxCtesProvEmp on Prov.IdProveedor = R_CtasContxCtesProvEmp.IdProveedor and R_CtasContxCtesProvEmp.IdTipoCuenta=1
left join C_Contable  on R_CtasContxCtesProvEmp.IdCuentaContable  = C_Contable.IdCuentaContable
left join D_BancosProveedorDispercion on Prov.IdProveedor = D_BancosProveedorDispercion.IdProveedor
left join C_Bancos on D_BancosProveedorDispercion.IdBanco  = C_Bancos.IdBanco
left join D_DatosAdicionalesProveedorDispersion Adicional on Prov.IdProveedor  = Adicional.IdProveedor 
and Adicional.IdDato =1
left join D_DatosAdicionalesProveedorDispersion Adicional2 on Prov.IdProveedor  = Adicional2.IdProveedor 
and Adicional2.IdDato =2
left join T_SaldosInicialesCont on T_SaldosInicialesCont.IdCuentaContable= C_Contable.IdCuentaContable and T_SaldosInicialesCont.Mes=@Periodo and T_SaldosInicialesCont.Year=@Ejercicio
Order by IdProv
END

if @SaldoMayorCero=0 begin
select distinct * from @Tabla where contador = 1
end

if @SaldoMayorCero=1 begin
select distinct * from @Tabla where contador = 1 and Saldo >0
end

GO

--exec SP_RPT_CatalogoProveedores2 @Todo=N'',@Tipo=N'(Ninguno)',@Periodo ='12',@Ejercicio='2017',@SaldoMayorCero=0
