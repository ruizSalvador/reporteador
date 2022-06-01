/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoProductos]    Script Date: 03/01/2014 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CatalogoProductos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CatalogoProductos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoProductos]    Script Date: 03/01/2014 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_CatalogoProductos
CREATE PROCEDURE [dbo].[SP_RPT_CatalogoProductos]
--@Fecha Datetime,
@Todo varchar(max),
@Grupo int,
@SubGrupo int,
@Clase int,
@SubClase int,
@Almacen varchar(max),
@Partida int,
@Estatus varchar(max)
as
DECLARE @Tabla TABLE (Gpo int,SubGpo int,Clase int,SubClase int,Consecutivo int,Descripcion varchar(max),Tipo varchar(max),Partida int, Medida varchar(max), Estatus varchar(max), Almacen varchar(max), CodigoCambs varchar(20),Presentacion varchar(255))

IF @Todo = '(Ninguno)' begin
INSERT @Tabla
select prod.Idgrupo, prod.IdSubGrupo, prod.IdFamilia, prod.IdSubClase, IdCodigoProducto, DescripcionGenerica, 
cast(case
         When prod.TipoProducto =1 then 'Consumible' 
		 When prod.TipoProducto =2 then 'Activo'
		 When prod.TipoProducto =4 then 'Control'                
		 else '' end as varchar (max)) as TipoAct,
ClavePartida, UnidadMedida, 
cast(case
         When prod.EstatusProducto =1 then 'Alta' 
		 When prod.EstatusProducto =2 then 'Baja'
		 When prod.EstatusProducto =3 then 'Descontinuado'                
		 else '' end as varchar (max)) as Estatus,
alm.Almacen,
CodigoCambs,
pres.NombrePresentacion
from C_Maestro as prod
left join C_Almacenes as alm on prod.NoEntraAlmacen = alm.IdAlmacen
left join C_UnidadPresentacion as pres On prod.IdPresentacion = pres.IdUPresentacion
END

IF @Todo = 'G' begin
INSERT @Tabla
select prod.Idgrupo, prod.IdSubGrupo, prod.IdFamilia, prod.IdSubClase, IdCodigoProducto, DescripcionGenerica, 
cast(case
         When prod.TipoProducto =1 then 'Consumible' 
		 When prod.TipoProducto =2 then 'Activo'
		 When prod.TipoProducto =4 then 'Control'                
		 else '' end as varchar (max)) as TipoAct,
ClavePartida, UnidadMedida, 
cast(case
         When prod.EstatusProducto =1 then 'Alta' 
		 When prod.EstatusProducto =2 then 'Baja'
		 When prod.EstatusProducto =3 then 'Descontinuado'                
		 else '' end as varchar (max)) as Estatus,
alm.Almacen,
CodigoCambs,
pres.NombrePresentacion
from C_Maestro as prod
left join C_Almacenes as alm on prod.NoEntraAlmacen = alm.IdAlmacen
left join C_UnidadPresentacion as pres On prod.IdPresentacion = pres.IdUPresentacion
where prod.IdGrupo = @Grupo
END

IF @Todo = 'SG' begin
INSERT @Tabla
select prod.Idgrupo, prod.IdSubGrupo, prod.IdFamilia, prod.IdSubClase, IdCodigoProducto, DescripcionGenerica, 
cast(case
         When prod.TipoProducto =1 then 'Consumible' 
		 When prod.TipoProducto =2 then 'Activo'
		 When prod.TipoProducto =4 then 'Control'                
		 else '' end as varchar (max)) as TipoAct,
ClavePartida, UnidadMedida, 
cast(case
         When prod.EstatusProducto =1 then 'Alta' 
		 When prod.EstatusProducto =2 then 'Baja'
		 When prod.EstatusProducto =3 then 'Descontinuado'                
		 else '' end as varchar (max)) as Estatus,
alm.Almacen,
CodigoCambs,
pres.NombrePresentacion
from C_Maestro as prod
left join C_Almacenes as alm on prod.NoEntraAlmacen = alm.IdAlmacen
left join C_UnidadPresentacion as pres On prod.IdPresentacion = pres.IdUPresentacion
where prod.IdSubGrupo = @SubGrupo
END

IF @Todo = 'C' begin
INSERT @Tabla
select prod.Idgrupo, prod.IdSubGrupo, prod.IdFamilia, prod.IdSubClase, IdCodigoProducto, DescripcionGenerica, 
cast(case
         When prod.TipoProducto =1 then 'Consumible' 
		 When prod.TipoProducto =2 then 'Activo'
		 When prod.TipoProducto =4 then 'Control'                
		 else '' end as varchar (max)) as TipoAct,
ClavePartida, UnidadMedida, 
cast(case
         When prod.EstatusProducto =1 then 'Alta' 
		 When prod.EstatusProducto =2 then 'Baja'
		 When prod.EstatusProducto =3 then 'Descontinuado'                
		 else '' end as varchar (max)) as Estatus,
alm.Almacen,
CodigoCambs,
pres.NombrePresentacion
from C_Maestro as prod
left join C_Almacenes as alm on prod.NoEntraAlmacen = alm.IdAlmacen
left join C_UnidadPresentacion as pres On prod.IdPresentacion = pres.IdUPresentacion
where prod.IdFamilia = @Clase
END

IF @Todo = 'SC' begin
INSERT @Tabla
select prod.Idgrupo, prod.IdSubGrupo, prod.IdFamilia, prod.IdSubClase, IdCodigoProducto, DescripcionGenerica, 
cast(case
         When prod.TipoProducto =1 then 'Consumible' 
		 When prod.TipoProducto =2 then 'Activo'
		 When prod.TipoProducto =4 then 'Control'                
		 else '' end as varchar (max)) as TipoAct,
ClavePartida, UnidadMedida, 
cast(case
         When prod.EstatusProducto =1 then 'Alta' 
		 When prod.EstatusProducto =2 then 'Baja'
		 When prod.EstatusProducto =3 then 'Descontinuado'                
		 else '' end as varchar (max)) as Estatus,
alm.Almacen,
CodigoCambs,
pres.NombrePresentacion
from C_Maestro as prod
left join C_Almacenes as alm on prod.NoEntraAlmacen = alm.IdAlmacen
left join C_UnidadPresentacion as pres On prod.IdPresentacion = pres.IdUPresentacion
where prod.IdSubClase = @SubClase
END

IF @Todo = 'A' begin
INSERT @Tabla
select prod.Idgrupo, prod.IdSubGrupo, prod.IdFamilia, prod.IdSubClase, IdCodigoProducto, DescripcionGenerica, 
cast(case
         When prod.TipoProducto =1 then 'Consumible' 
		 When prod.TipoProducto =2 then 'Activo'
		 When prod.TipoProducto =4 then 'Control'                
		 else '' end as varchar (max)) as TipoAct,
ClavePartida, UnidadMedida, 
cast(case
         When prod.EstatusProducto =1 then 'Alta' 
		 When prod.EstatusProducto =2 then 'Baja'
		 When prod.EstatusProducto =3 then 'Descontinuado'                
		 else '' end as varchar (max)) as Estatus,
alm.Almacen,
CodigoCambs,
pres.NombrePresentacion
from C_Maestro as prod
left join C_Almacenes as alm on prod.NoEntraAlmacen = alm.IdAlmacen
left join C_UnidadPresentacion as pres On prod.IdPresentacion = pres.IdUPresentacion
where alm.Almacen = @Almacen
END

IF @Todo = 'P' begin
if @Partida > 0 begin 
INSERT @Tabla
select prod.Idgrupo, prod.IdSubGrupo, prod.IdFamilia, prod.IdSubClase, IdCodigoProducto, DescripcionGenerica, 
cast(case
         When prod.TipoProducto =1 then 'Consumible' 
		 When prod.TipoProducto =2 then 'Activo'
		 When prod.TipoProducto =4 then 'Control'                
		 else '' end as varchar (max)) as TipoAct,
ClavePartida, UnidadMedida, 
cast(case
         When prod.EstatusProducto =1 then 'Alta' 
		 When prod.EstatusProducto =2 then 'Baja'
		 When prod.EstatusProducto =3 then 'Descontinuado'                
		 else '' end as varchar (max)) as Estatus,
alm.Almacen,
CodigoCambs,
pres.NombrePresentacion
from C_Maestro as prod
left join C_Almacenes as alm on prod.NoEntraAlmacen = alm.IdAlmacen
left join C_UnidadPresentacion as pres On prod.IdPresentacion = pres.IdUPresentacion
where prod.ClavePartida = @Partida
  end
  else
  begin
  INSERT @Tabla
select prod.Idgrupo, prod.IdSubGrupo, prod.IdFamilia, prod.IdSubClase, IdCodigoProducto, DescripcionGenerica, 
cast(case
         When prod.TipoProducto =1 then 'Consumible' 
		 When prod.TipoProducto =2 then 'Activo'
		 When prod.TipoProducto =4 then 'Control'                
		 else '' end as varchar (max)) as TipoAct,
ClavePartida, UnidadMedida, 
cast(case
         When prod.EstatusProducto =1 then 'Alta' 
		 When prod.EstatusProducto =2 then 'Baja'
		 When prod.EstatusProducto =3 then 'Descontinuado'                
		 else '' end as varchar (max)) as Estatus,
alm.Almacen,
CodigoCambs,
pres.NombrePresentacion
from C_Maestro as prod
left join C_Almacenes as alm on prod.NoEntraAlmacen = alm.IdAlmacen
left join C_UnidadPresentacion as pres On prod.IdPresentacion = pres.IdUPresentacion
--where prod.ClavePartida = @Partida
  end
END

IF @Todo = 'E' begin
INSERT @Tabla
select prod.Idgrupo, prod.IdSubGrupo, prod.IdFamilia, prod.IdSubClase, IdCodigoProducto, DescripcionGenerica, 
cast(case
         When prod.TipoProducto =1 then 'Consumible' 
		 When prod.TipoProducto =2 then 'Activo'
		 When prod.TipoProducto =4 then 'Control'                
		 else '' end as varchar (max)) as TipoAct,
ClavePartida, UnidadMedida, 
cast(case
         When prod.EstatusProducto =1 then 'Alta' 
		 When prod.EstatusProducto =2 then 'Baja'
		 When prod.EstatusProducto =3 then 'Descontinuado'                
		 else '' end as varchar (max)) as Estatus,
alm.Almacen,
CodigoCambs,
pres.NombrePresentacion
from C_Maestro as prod
left join C_Almacenes as alm on prod.NoEntraAlmacen = alm.IdAlmacen
left join C_UnidadPresentacion as pres On prod.IdPresentacion = pres.IdUPresentacion
where (cast(case
         When prod.EstatusProducto =1 then 'Alta' 
		 When prod.EstatusProducto =2 then 'Baja'
		 When prod.EstatusProducto =3 then 'Descontinuado'                
		 else '' end as varchar (max))) = @Estatus
END

select * from @Tabla
order by Gpo,SubGpo,Clase,SubClase,Consecutivo

GO

EXEC SP_FirmasReporte 'Cat�logo de Productos'
GO  

Exec SP_CFG_LogScripts 'SP_RPT_CatalogoProductos'
GO




--EXEC SP_RPT_CatalogoProductos '(Ninguno)',0,0,0,0,0,0,''
