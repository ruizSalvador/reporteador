/****** Object:  StoredProcedure [dbo].[RPT_SP_Padron_Proveedores]    Script Date: 02/01/2017 11:41:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_Padron_Proveedores]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_Padron_Proveedores]
GO
                                        
/****** Object:  StoredProcedure [dbo].[RPT_SP_Padron_Proveedores]    Script Date: 02/01/2017 11:45:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
 -- RPT_SP_Padron_Proveedores 2020
CREATE PROCEDURE [dbo].[RPT_SP_Padron_Proveedores]	

@Ejercicio int
--@Fecha Datetime,

AS
BEGIN

DECLARE @Tabla TABLE (
Id_Prov int,
Id_Actividad_Proveedor int,
Actividad varchar(max),
RFC varchar(14),
Nombre varchar(max),
Direccion varchar(max),
Ciudad varchar(max),
Estado varchar (max),
Correo_Electronico varchar(max),
Representante varchar(max)
)

Insert Into @Tabla
Select  Prov.IdProveedor as Id_Prov,
C_TipoProveedores.IdTipoProveedor as Id_Actividad_Proveedor,
C_TipoProveedores.Descripcion as Actividad,
Prov.RFC as RFC, 
Prov.RazonSocial as Nombre, 
Prov.Domicilio as Direccion,  
C_Ciudades.NombreCiudad as Ciudad,
C_Estados.NombreEstados as Estado,
tel.Numero as Correo_Electronico,
Prov.Representante

From C_Proveedores as Prov
Left Join C_Ciudades ON Prov.IdCiudad = C_Ciudades.IdCiudad
Left Join C_Estados ON C_Ciudades.IdEstado = C_Estados.IdEstado
Left Join C_TipoProveedores ON C_TipoProveedores.IdTipoProveedor = Prov.IdTipoProveedor
Left Join C_TelefonosClientesProveedores as tel on Prov.IdProveedor = tel.IdProveedor And tel.Tipo = 'Mail'

Order by Prov.IdProveedor

Select * from @Tabla WHere Id_Prov in(
(SELECT Distinct tabla3.IdProveedor
		FROM
		(Select * From T_Polizas Where YEAR(Fecha)=@Ejercicio AND TipoPoliza in ('D','E')) tabla1
		Inner Join
		(Select * From D_Polizas ) tabla2
		ON tabla1.IdPoliza = tabla2.IdPoliza
		Inner Join 
		(Select Distinct * From R_CtasContxCtesProvEmp Where  IdProveedor <> 0) tabla3
		ON tabla2.IdCuentaContable = tabla3.IdCuentaContable) 
		)
		Order by Id_Prov
END

Exec SP_CFG_LogScripts 'RPT_SP_Padron_Proveedores','2.30.1'
GO