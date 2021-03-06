
/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoProveedores]    Script Date: 07/01/2015 12:59:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Exec SP_RPT_CatalogoProveedores '','P',0
ALTER PROCEDURE [dbo].[SP_RPT_CatalogoProveedores]

--@Fecha Datetime,
@Todo varchar (max),
@Tipo varchar(max),
@Local int

as
DECLARE @Tabla TABLE (IdProv int,RFC varchar(max),RazonSocial varchar(max),Domicilio varchar(max),Colonia varchar(max),CP int,Telefono varchar (max),GiroProv varchar(max),Observaciones varchar(max), Descripcion varchar(max), Clave varchar(max), NacionalExtranjero varchar(max),TipoContribuyente varchar(max),Confiable varchar(max),contador int, LocalForaneo varchar(20), Ciudad varchar(200))

IF @Tipo <> '(Ninguno)' and @Todo = 'Activos' begin 
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial, prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP,  --tel.Numero 
 'Telefono: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Telefono')+
 ', Movil: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Movil')
 +', email: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='email')
 as Telefono,
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
		 else '' end as varchar (max)) as Confiable, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador,
	 CASE Prov.Opt_04
			 WHEN 1 THEN 'Local'
			 WHEN 2 THEN 'Foráneo'
			 ELSE CAST(Prov.Opt_04 as varchar(4))
		 END  as LocalForaneo,
		 CCD.NombreCiudad
from C_Proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join C_tipoproveedores as tprov on Prov.IdTipoProveedor = tprov.idtipoproveedor
left join C_Ciudades as CCD on CCD.IdCiudad = Prov.IdCiudad
where Prov.TipoProveedor = @Tipo and prov.Opt_02 = 1 
Order by IdProv
END

IF @Tipo <> '(Ninguno)' and @Todo = '' begin 
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial, prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP,  --tel.Numero 
 'Telefono: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Telefono')+
 ', Movil: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Movil')
 +', email: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='email')
 as Telefono, 
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
		 else '' end as varchar (max)) as Confiable, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador,
		CASE Prov.Opt_04
			 WHEN 1 THEN 'Local'
			 WHEN 2 THEN 'Foráneo'
			 ELSE CAST(Prov.Opt_04 as varchar(4))
		 END  as LocalForaneo,
		  CCD.NombreCiudad
from C_Proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join C_tipoproveedores as tprov on Prov.IdTipoProveedor = tprov.idtipoproveedor
left join C_Ciudades as CCD on CCD.IdCiudad = Prov.IdCiudad

where Prov.TipoProveedor = @Tipo 
Order by IdProv
END

IF @Tipo = '(Ninguno)' and @Todo = 'Activos' begin
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial, prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP,  --tel.Numero 
 'Telefono: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Telefono')+
 ', Movil: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Movil')
 +', email: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='email')
 as Telefono, 
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
		 else '' end as varchar (max)) as Confiable, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador,
		 CASE Prov.Opt_04
			 WHEN 1 THEN 'Local'
			 WHEN 2 THEN 'Foráneo'
			 ELSE CAST(Prov.Opt_04 as varchar(4))
		 END  as LocalForaneo,
		 		 CCD.NombreCiudad

from C_Proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join C_tipoproveedores as tprov on Prov.IdTipoProveedor = tprov.idtipoproveedor
left join C_Ciudades as CCD on CCD.IdCiudad = Prov.IdCiudad

where prov.Opt_02 = 1 
Order by IdProv
END

IF @Tipo = '(Ninguno)' and @Todo = '' begin
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial, prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, --tel.Numero 
 'Telefono: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Telefono')+
 ', Movil: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='Movil')
 +', email: '+(select Numero from C_TelefonosClientesProveedores where IdProveedor=Prov.IdProveedor and Tipo='email')
 as Telefono,
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
		 else '' end as varchar (max)) as Confiable, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador,
		 CASE Prov.Opt_04
			 WHEN 1 THEN 'Local'
			 WHEN 2 THEN 'Foráneo'
			 ELSE CAST(Prov.Opt_04 as varchar(4))
		 END  as LocalForaneo,
		 		 CCD.NombreCiudad

from C_Proveedores as Prov
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
left join C_tipoproveedores as tprov on Prov.IdTipoProveedor = tprov.idtipoproveedor
left join C_Ciudades as CCD on CCD.IdCiudad = Prov.IdCiudad

Order by IdProv
END

IF @Local = 0
Begin
select distinct * from @Tabla where contador = 1
end

IF @Local = 1
Begin
select distinct * from @Tabla where contador = 1 and LocalForaneo = 'Local'
end

IF @Local = 2
Begin
select distinct * from @Tabla where contador = 1 and LocalForaneo = 'Foráneo'
end

