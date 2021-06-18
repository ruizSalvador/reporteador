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
@Tipo varchar(max)
as
DECLARE @Tabla TABLE (IdProv int,RFC varchar(max),RazonSocial varchar(max),Domicilio varchar(max),Colonia varchar(max),CP int,Telefono varchar (max),GiroProv varchar(max),NumeroCuenta varchar(max),NombreBanco varchar(max),Valor1 varchar(max),Valor2 varchar(max),Observaciones varchar(max), contador int)

IF @Tipo <> '(Ninguno)' and @Todo = 'Activos' begin
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial,
 prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, tel.Numero as Telefono,
cast(case
         When Prov.TipoProveedor like 'P' then 'Proveedor'
                 When Prov.TipoProveedor like 'C' then 'Contratista'
                 When Prov.TipoProveedor like 'V' then 'Beneficiario'
                 else '' end as varchar (max)) as GiroProv,
C_contable.NumeroCuenta as NumeroCuenta , C_Bancos.NombreBanco  as NombreBanco ,
Adicional.valor as Valor1 , Adicional2.Valor  as Valor2 ,
Prov.Observaciones as Observaciones, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
from c_proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join R_CtasContxCtesProvEmp on Prov.IdProveedor = R_CtasContxCtesProvEmp.IdProveedor
left join C_Contable  on R_CtasContxCtesProvEmp.IdCuentaContable  = C_Contable.IdCuentaContable
left join D_BancosProveedorDispercion on Prov.IdProveedor = D_BancosProveedorDispercion.IdProveedor
left join C_Bancos on D_BancosProveedorDispercion.IdBanco  = C_Bancos.IdBanco
left join D_DatosAdicionalesProveedorDispersion Adicional on Prov.IdProveedor  = Adicional.IdProveedor 
and Adicional.IdDato =1
left join D_DatosAdicionalesProveedorDispersion Adicional2 on Prov.IdProveedor  = Adicional2.IdProveedor 
and Adicional2.IdDato =2
where Prov.TipoProveedor = @Tipo and prov.Opt_02 = 1
Order by IdProv
END

IF @Tipo <> '(Ninguno)' and @Todo = '' begin
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial,
 prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, tel.Numero as Telefono,
cast(case
         When Prov.TipoProveedor like 'P' then 'Proveedor'
                 When Prov.TipoProveedor like 'C' then 'Contratista'
                 When Prov.TipoProveedor like 'V' then 'Beneficiario'
                 else '' end as varchar (max)) as GiroProv,
C_contable.NumeroCuenta as NumeroCuenta , C_Bancos.NombreBanco  as NombreBanco ,
Adicional.valor as Valor1 , Adicional2.Valor  as Valor2 ,
Prov.Observaciones as Observaciones, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
from c_proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join R_CtasContxCtesProvEmp on Prov.IdProveedor = R_CtasContxCtesProvEmp.IdProveedor
left join C_Contable  on R_CtasContxCtesProvEmp.IdCuentaContable  = C_Contable.IdCuentaContable
left join D_BancosProveedorDispercion on Prov.IdProveedor = D_BancosProveedorDispercion.IdProveedor
left join C_Bancos on D_BancosProveedorDispercion.IdBanco  = C_Bancos.IdBanco
left join D_DatosAdicionalesProveedorDispersion Adicional on Prov.IdProveedor  = Adicional.IdProveedor 
and Adicional.IdDato =1
left join D_DatosAdicionalesProveedorDispersion Adicional2 on Prov.IdProveedor  = Adicional2.IdProveedor 
and Adicional2.IdDato =2
where Prov.TipoProveedor = @Tipo
Order by IdProv
END

IF @Tipo = '(Ninguno)' and @Todo = 'Activos' begin
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial,
 prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, tel.Numero as Telefono,
cast(case
         When Prov.TipoProveedor like 'P' then 'Proveedor'
                 When Prov.TipoProveedor like 'C' then 'Contratista'
                 When Prov.TipoProveedor like 'V' then 'Beneficiario'
                 else '' end as varchar (max)) as GiroProv,
C_contable.NumeroCuenta as NumeroCuenta , C_Bancos.NombreBanco as NombreBanco ,
Adicional.valor as Valor1 , Adicional2.Valor  as Valor2 ,
Prov.Observaciones as Observaciones, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
from c_proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join R_CtasContxCtesProvEmp on Prov.IdProveedor = R_CtasContxCtesProvEmp.IdProveedor
left join C_Contable  on R_CtasContxCtesProvEmp.IdCuentaContable  = C_Contable.IdCuentaContable
left join D_BancosProveedorDispercion on Prov.IdProveedor = D_BancosProveedorDispercion.IdProveedor
left join C_Bancos on D_BancosProveedorDispercion.IdBanco  = C_Bancos.IdBanco
left join D_DatosAdicionalesProveedorDispersion Adicional on Prov.IdProveedor  = Adicional.IdProveedor 
and Adicional.IdDato =1
left join D_DatosAdicionalesProveedorDispersion Adicional2 on Prov.IdProveedor  = Adicional2.IdProveedor 
and Adicional2.IdDato =2
where prov.Opt_02 = 1
Order by IdProv
END

IF @Tipo = '(Ninguno)' and @Todo = '' begin
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial,
 prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, tel.Numero as Telefono,
cast(case
         When Prov.TipoProveedor like 'P' then 'Proveedor'
                 When Prov.TipoProveedor like 'C' then 'Contratista'
                 When Prov.TipoProveedor like 'V' then 'Beneficiario'
                 else '' end as varchar (max)) as GiroProv,
C_contable.NumeroCuenta as NumeroCuenta , C_Bancos.NombreBanco as NombreBanco ,
Adicional.valor as Valor1 , Adicional2.Valor  as Valor2 ,
Prov.Observaciones as Observaciones, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
from c_proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join R_CtasContxCtesProvEmp on Prov.IdProveedor = R_CtasContxCtesProvEmp.IdProveedor
left join C_Contable  on R_CtasContxCtesProvEmp.IdCuentaContable  = C_Contable.IdCuentaContable
left join D_BancosProveedorDispercion on Prov.IdProveedor = D_BancosProveedorDispercion.IdProveedor
left join C_Bancos on D_BancosProveedorDispercion.IdBanco  = C_Bancos.IdBanco
left join D_DatosAdicionalesProveedorDispersion Adicional on Prov.IdProveedor  = Adicional.IdProveedor 
and Adicional.IdDato =1
left join D_DatosAdicionalesProveedorDispersion Adicional2 on Prov.IdProveedor  = Adicional2.IdProveedor 
and Adicional2.IdDato =2
Order by IdProv
END


select distinct * from @Tabla where contador = 1



GO


