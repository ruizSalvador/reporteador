
/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoProveedores]    Script Date: 07/01/2015 12:59:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_RPT_CatalogoProveedores]
--@Fecha Datetime,
@Todo varchar (max),
@Tipo varchar(max)
as
DECLARE @Tabla TABLE (IdProv int,RFC varchar(max),RazonSocial varchar(max),Domicilio varchar(max),Colonia varchar(max),CP int,Telefono varchar (max),GiroProv varchar(max),Observaciones varchar(max), Descripcion varchar(max), Clave varchar(max), NacionalExtranjero varchar(max),TipoContribuyente varchar(max),Confiable varchar(max),contador int)

IF @Tipo <> '(Ninguno)' and @Todo = 'Activos' begin 
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial, prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, tel.Numero as Telefono, 
cast(case
         When Prov.TipoProveedor like 'P' then 'Proveedor' 
		 When Prov.TipoProveedor like 'C' then 'Contratista' 
		 When Prov.TipoProveedor like 'V' then 'Beneficiario'                 
		 else '' end as varchar (max)) as GiroProv, 
Prov.Observaciones as Observaciones,tprov.descripcion as Descripcion,Prov.Clave as Clave, 
cast(case
         When Prov.NacionalExtanjero = 'N' then 'Nacional' 
		 When Prov.NacionalExtanjero = 'E' then 'Extranjero'                 
		 else '' end as varchar (max)) as NacionalExtranjero, 
cast(case
         When Prov.TipoContribuyente = 'F' then 'Física' 
		 When Prov.TipoContribuyente = 'M' then 'Moral'                 
		 else '' end as varchar (max)) as TipoContribuyente, 
cast(case
         When Prov.Opt_01 = 1 then 'Confiable' 
		 When Prov.Opt_01 = 2 then 'No Confiable'                 
		 else '' end as varchar (max)) as Confiable, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
from C_Proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join C_tipoproveedores as tprov on Prov.IdTipoProveedor = tprov.idtipoproveedor
where Prov.TipoProveedor = @Tipo and prov.Opt_02 = 1
Order by IdProv
END

IF @Tipo <> '(Ninguno)' and @Todo = '' begin 
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial, prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, tel.Numero as Telefono, 
cast(case
         When Prov.TipoProveedor like 'P' then 'Proveedor' 
		 When Prov.TipoProveedor like 'C' then 'Contratista' 
		 When Prov.TipoProveedor like 'V' then 'Beneficiario'                 
		 else '' end as varchar (max)) as GiroProv, 
Prov.Observaciones as Observaciones,tprov.descripcion as Descripcion,Prov.Clave as Clave, 
cast(case
         When Prov.NacionalExtanjero = 'N' then 'Nacional' 
		 When Prov.NacionalExtanjero = 'E' then 'Extranjero'                 
		 else '' end as varchar (max)) as NacionalExtranjero, 
cast(case
         When Prov.TipoContribuyente = 'F' then 'Física' 
		 When Prov.TipoContribuyente = 'M' then 'Moral'                 
		 else '' end as varchar (max)) as TipoContribuyente, 
cast(case
         When Prov.Opt_01 = 1 then 'Confiable' 
		 When Prov.Opt_01 = 2 then 'No Confiable'                 
		 else '' end as varchar (max)) as Confiable, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
from C_Proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join C_tipoproveedores as tprov on Prov.IdTipoProveedor = tprov.idtipoproveedor
where Prov.TipoProveedor = @Tipo
Order by IdProv
END

IF @Tipo = '(Ninguno)' and @Todo = 'Activos' begin
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial, prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, tel.Numero as Telefono, 
cast(case
         When Prov.TipoProveedor like 'P' then 'Proveedor' 
		 When Prov.TipoProveedor like 'C' then 'Contratista' 
		 When Prov.TipoProveedor like 'V' then 'Beneficiario'                 
		 else '' end as varchar (max)) as GiroProv, 
Prov.Observaciones as Observaciones,tprov.descripcion as Descripcion,Prov.Clave as Clave, 
cast(case
         When Prov.NacionalExtanjero = 'N' then 'Nacional' 
		 When Prov.NacionalExtanjero = 'E' then 'Extranjero'                 
		 else '' end as varchar (max)) as NacionalExtranjero, 
cast(case
         When Prov.TipoContribuyente = 'F' then 'Física' 
		 When Prov.TipoContribuyente = 'M' then 'Moral'                 
		 else '' end as varchar (max)) as TipoContribuyente, 
cast(case
         When Prov.Opt_01 = 1 then 'Confiable' 
		 When Prov.Opt_01 = 2 then 'No Confiable'                 
		 else '' end as varchar (max)) as Confiable, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
from C_Proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join C_tipoproveedores as tprov on Prov.IdTipoProveedor = tprov.idtipoproveedor
where prov.Opt_02 = 1
Order by IdProv
END

IF @Tipo = '(Ninguno)' and @Todo = '' begin
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial, prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, tel.Numero as Telefono, 
cast(case
         When Prov.TipoProveedor like 'P' then 'Proveedor' 
		 When Prov.TipoProveedor like 'C' then 'Contratista' 
		 When Prov.TipoProveedor like 'V' then 'Beneficiario'                 
		 else '' end as varchar (max)) as GiroProv, 
Prov.Observaciones as Observaciones,tprov.descripcion as Descripcion,Prov.Clave as Clave, 
cast(case
         When Prov.NacionalExtanjero = 'N' then 'Nacional' 
		 When Prov.NacionalExtanjero = 'E' then 'Extranjero'                 
		 else '' end as varchar (max)) as NacionalExtranjero, 
cast(case
         When Prov.TipoContribuyente = 'F' then 'Física' 
		 When Prov.TipoContribuyente = 'M' then 'Moral'                 
		 else '' end as varchar (max)) as TipoContribuyente, 
cast(case
         When Prov.Opt_01 = 1 then 'Confiable' 
		 When Prov.Opt_01 = 2 then 'No Confiable'                 
		 else '' end as varchar (max)) as Confiable, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
from C_Proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join C_tipoproveedores as tprov on Prov.IdTipoProveedor = tprov.idtipoproveedor
Order by IdProv
END


select distinct * from @Tabla where contador = 1

