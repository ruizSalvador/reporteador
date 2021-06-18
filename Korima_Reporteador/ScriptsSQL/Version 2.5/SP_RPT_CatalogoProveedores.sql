/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoProveedores]    Script Date: 12/12/2013 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CatalogoProveedores]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CatalogoProveedores]
GO


/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoProveedores]    Script Date: 12/12/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_CatalogoProveedores]
--@Fecha Datetime,
@Todo varchar (max),
@Tipo varchar(max)
as
DECLARE @Tabla TABLE (IdProv int,RFC varchar(max),RazonSocial varchar(max),Domicilio varchar(max),Colonia varchar(max),CP int,Telefono varchar (max),GiroProv varchar(max),Observaciones varchar(max), contador int)

IF @Tipo <> '(Ninguno)' and @Todo = 'Activos' begin 
INSERT @Tabla
select  prov.IdProveedor as IdProv, prov.RFC as RFC, prov.RazonSocial as RazonSocial, prov.Domicilio as Domicilio, prov.Colonia as Colonia, prov.CP as CP, tel.Numero as Telefono, 
cast(case
         When Prov.TipoProveedor like 'P' then 'Proveedor' 
		 When Prov.TipoProveedor like 'C' then 'Contratista' 
		 When Prov.TipoProveedor like 'V' then 'Beneficiario'                 
		 else '' end as varchar (max)) as GiroProv, 
Prov.Observaciones as Observaciones, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
from C_Proveedores as Prov  
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
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
Prov.Observaciones as Observaciones, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador 
from c_proveedores as Prov  
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
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
Prov.Observaciones as Observaciones, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador 
from c_proveedores as Prov  
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
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
Prov.Observaciones as Observaciones, row_number() over (partition by prov.IdProveedor order by prov.IdProveedor) as contador
from c_proveedores as Prov  
left join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor
Order by IdProv
END


select distinct * from @Tabla where contador = 1

GO

EXEC SP_FirmasReporte 'Catalogo de Proveedores'
GO
