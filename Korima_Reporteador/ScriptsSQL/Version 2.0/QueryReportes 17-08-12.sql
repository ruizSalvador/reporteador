/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_ComprasYServicios_Dependencia_Partida]    Script Date: 07/05/2012 14:18:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_ComprasYServicios_Dependencia_Partida]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_ComprasYServicios_Dependencia_Partida]
GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia]    Script Date: 07/05/2012 14:18:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia]
GO

/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia]    Script Date: 07/05/2012 14:18:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia]
GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor]    Script Date: 07/05/2012 14:18:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor]
GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor]    Script Date: 07/05/2012 14:18:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor]
GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor_Detalles]    Script Date: 07/05/2012 14:18:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor_Detalles]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor_Detalles]
GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra]    Script Date: 07/05/2012 14:18:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra]
GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor_Detalles]    Script Date: 07/05/2012 14:18:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor_Detalles]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor_Detalles]
GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree]    Script Date: 07/05/2012 14:18:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree]
GO
/*AGREGADO EL 07-08-2012 INICIO*/
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor]    Script Date: 08/07/2012 16:59:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Servicios_Proveedor]'))
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Servicios_Proveedor]
GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompraServicioDependenciaPartidaProveedor]    Script Date: 08/07/2012 16:59:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompraServicioDependenciaPartidaProveedor]'))
DROP VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompraServicioDependenciaPartidaProveedor]
GO
/*AGREGADO EL 07-08-2012 FIN*/
/****** Object:  StoredProcedure [dbo].[SP_RPT_SEC_Accesos_UPD]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_SEC_Accesos_UPD]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_SEC_Accesos_UPD]
GO
/****** Object:  StoredProcedure [dbo].[SP_C_Usuarios_ADD]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_C_Usuarios_ADD]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_C_Usuarios_ADD]
GO
/****** Object:  StoredProcedure [dbo].[SP_C_Usuarios_DEL]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_C_Usuarios_DEL]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_C_Usuarios_DEL]
GO
/****** Object:  StoredProcedure [dbo].[SP_C_Usuarios_GETONE]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_C_Usuarios_GETONE]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_C_Usuarios_GETONE]
GO
/****** Object:  StoredProcedure [dbo].[SP_C_Usuarios_UPD]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_C_Usuarios_UPD]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_C_Usuarios_UPD]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CAT_Reportes_ADD]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_CAT_Reportes_ADD]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_CAT_Reportes_ADD]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CAT_Reportes_DEL]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_CAT_Reportes_DEL]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_CAT_Reportes_DEL]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CAT_Reportes_GETONE]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_CAT_Reportes_GETONE]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_CAT_Reportes_GETONE]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CAT_Reportes_UPD]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_CAT_Reportes_UPD]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_CAT_Reportes_UPD]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_ADD]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_CFG_DatosEntes_ADD]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_CFG_DatosEntes_ADD]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_DEL]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_CFG_DatosEntes_DEL]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_CFG_DatosEntes_DEL]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_GETONE]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_CFG_DatosEntes_GETONE]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_CFG_DatosEntes_GETONE]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_UPD]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_CFG_DatosEntes_UPD]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_CFG_DatosEntes_UPD]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_SEC_Accesos_ADD]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_SEC_Accesos_ADD]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_SEC_Accesos_ADD]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_SEC_Accesos_DEL]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_SEC_Accesos_DEL]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_SEC_Accesos_DEL]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_SEC_Accesos_GETONE]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_SEC_Accesos_GETONE]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_SEC_Accesos_GETONE]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_SEC_Accesos_LIST]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_SEC_Accesos_LIST]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_SEC_Accesos_LIST]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_LIST]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_CFG_DatosEntes_LIST]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_CFG_DatosEntes_LIST]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CAT_Reportes_LIST]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_RPT_CAT_Reportes_LIST]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPT_CAT_Reportes_LIST]
GO
/****** Object:  StoredProcedure [dbo].[SP_C_Usuarios_LIST]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_C_Usuarios_LIST]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_C_Usuarios_LIST]
GO
/****** Object:  Table [dbo].[RPT_CAT_Reportes]    Script Date: 07/05/2012 14:18:37 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[RPT_CAT_Reportes]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[RPT_CAT_Reportes]
GO
/****** Object:  Table [dbo].[RPT_SEC_Accesos]    Script Date: 07/05/2012 14:18:37 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[RPT_SEC_Accesos]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[RPT_SEC_Accesos]
GO
/****** Object:  Table [dbo].[RPT_SEC_Accesos]    Script Date: 07/05/2012 14:18:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[RPT_SEC_Accesos]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[RPT_SEC_Accesos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdUsuario] [int] NULL,
	[IdReporte] [int] NULL,
	[Disponible] [bit] NULL,
 CONSTRAINT [PK_RPT_SEC_Accesos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[RPT_CFG_DatosEntes]    Script Date: 07/05/2012 14:18:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[RPT_CFG_DatosEntes]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[RPT_CFG_DatosEntes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NULL,
	[ClaveSistema] [nvarchar](100) NULL,
	[Domicilio] [nvarchar](250) NULL,
	[Ciudad] [nvarchar](100) NULL,
	[RFC] [nvarchar](20) NULL,
	[Telefonos] [nvarchar](20) NULL,
	[Texto] [nvarchar](1000) NULL,
	[LogoEnte] [image] NULL,
	[LogoKorima] [image] NULL,
	[LastUpdate] [nvarchar](50) NULL,
 CONSTRAINT [PK_RPT_CFG_DatosEntes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[RPT_CAT_Reportes]    Script Date: 07/05/2012 14:18:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[RPT_CAT_Reportes]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[RPT_CAT_Reportes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReporteNombre] [nvarchar](100) NULL,
	[ReporteDescripcion] [nvarchar](100) NULL,
	[ReporteVersion] [nvarchar](50) NULL,
	[ReporteFechaCambio] [nvarchar](50) NULL,
	[ArchivoNombre] [nvarchar](200) NULL,
	[ArchivoReporte] [binary](8000) NULL,
 CONSTRAINT [PK_RPT_CAT_Reportes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[SP_C_Usuarios_LIST]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez Gómez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Enlista registros del catalogo de C_Usuarios
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamín Meléndez   |Adecuación de Procedimiento
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_C_Usuarios_LIST]
(
	 @ViewTable as varchar(1000),			  -- Vista o Tabla
	 @Filter as varchar(1000),			  -- Filtro
     @Order as varchar(1000),			  -- Orden
     @Counter as int,					  -- Numero de filas
     @MjsErrCode as int OUTPUT,			  -- Codigo de Error
     @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS	


DECLARE @SQLCommand as nvarchar(max)

SET @SQLCommand = N'SELECT   ' +  CHAR(13)
If  @Counter is not NULL and @Counter <> 0
    SET @SQLCommand = @SQLCommand + ' TOP ' + cast(@counter as nvarchar(4)) + CHAR(13)
SET @SQLCommand = @SQLCommand + ' * '
SET @SQLCommand = @SQLCommand + ' FROM ' + @ViewTable
If  @Filter is not NULL
    SET @SQLCommand = @SQLCommand + ' Where ' + @Filter + CHAR(13)
If  @Order is not NULL
    SET @SQLCommand = @SQLCommand + @Order + CHAR(13)

EXEC sp_executesql @SQLCommand

 
			 
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/

	If @@ROWCOUNT = 0 
		Begin
			Set  @MjsErrCode = -1
			Set @MjsErrDescr = 'No se encontraron registros.'
		End
	Else
		if (@@Error <> 0)
			Begin
				Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
			End
		Else
			Begin
				 ---Armar mensaje de operación exitosa
				Set @MjsErrDescr = 'Se encontraron registro(s).'
			 	
			End


GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CAT_Reportes_LIST]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez Gómez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Enlista registros del catalogo de RPT_CAT_Reportes
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamín Meléndez   |Adecuación de Procedimiento
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_RPT_CAT_Reportes_LIST]
(
	 @ViewTable as varchar(1000),			  -- Vista o Tabla
	 @Filter as varchar(1000),			  -- Filtro
     @Order as varchar(1000),			  -- Orden
     @Counter as int,					  -- Numero de filas
     @MjsErrCode as int OUTPUT,			  -- Codigo de Error
     @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS



DECLARE @SQLCommand as nvarchar(max)

SET @SQLCommand = N'SELECT   ' +  CHAR(13)
If  @Counter is not NULL and @Counter <> 0
    SET @SQLCommand = @SQLCommand + ' TOP ' + cast(@counter as nvarchar(4)) + CHAR(13)
SET @SQLCommand = @SQLCommand + ' * '
SET @SQLCommand = @SQLCommand + ' FROM ' + @ViewTable
If  @Filter is not NULL
    SET @SQLCommand = @SQLCommand + ' Where ' + @Filter + CHAR(13)
If  @Order is not NULL
    SET @SQLCommand = @SQLCommand + @Order + CHAR(13)

EXEC sp_executesql @SQLCommand

 
			 
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/

	If @@ROWCOUNT = 0 
		Begin
			Set  @MjsErrCode = -1
			Set @MjsErrDescr = 'No se encontraron registros.'
		End
	Else
		if (@@Error <> 0)
			Begin
				Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
			End
		Else
			Begin
				 ---Armar mensaje de operación exitosa
				Set @MjsErrDescr = 'Se encontraron registro(s).'
			End


GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_LIST]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez Gómez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Enlista registros del catalogo de RPT_CFG_DatosEntes
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamín Meléndez   |Adecuación de Procedimiento
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_RPT_CFG_DatosEntes_LIST]
(
	 @ViewTable as varchar(1000),			  -- Vista o Tabla
	 @Filter as varchar(1000),			  -- Filtro
     @Order as varchar(1000),			  -- Orden
     @Counter as int,					  -- Numero de filas
     @MjsErrCode as int OUTPUT,			  -- Codigo de Error
     @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
	

DECLARE @SQLCommand as nvarchar(max)

SET @SQLCommand = N'SELECT   ' +  CHAR(13)
If  @Counter is not NULL and @Counter <> 0
    SET @SQLCommand = @SQLCommand + ' TOP ' + cast(@counter as nvarchar(4)) + CHAR(13)
SET @SQLCommand = @SQLCommand + ' * '
SET @SQLCommand = @SQLCommand + ' FROM ' + @ViewTable
If  @Filter is not NULL
    SET @SQLCommand = @SQLCommand + ' Where ' + @Filter + CHAR(13)
If  @Order is not NULL
    SET @SQLCommand = @SQLCommand + @Order + CHAR(13)

EXEC sp_executesql @SQLCommand

 
			 
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/

	If @@ROWCOUNT = 0 
		Begin
			Set  @MjsErrCode = -1
			Set @MjsErrDescr = 'No se encontraron registros.'
		End
	Else
		if (@@Error <> 0)
			Begin
				Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
			End
		Else
			Begin
				 ---Armar mensaje de operación exitosa
				Set @MjsErrDescr = 'Se encontraron registro(s).'
			 
			End


GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_SEC_Accesos_LIST]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez Gómez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Enlista registros del catalogo de RPT_SEC_Accesos
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamín Meléndez   |Adecuación de Procedimiento
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_RPT_SEC_Accesos_LIST]
(
	 @ViewTable as varchar(1000),			  -- Vista o Tabla
	 @Filter as varchar(1000),			  -- Filtro
     @Order as varchar(1000),			  -- Orden
     @Counter as int,					  -- Numero de filas
     @MjsErrCode as int OUTPUT,			  -- Codigo de Error
     @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
	
DECLARE @SQLCommand as nvarchar(max)

SET @SQLCommand = N'SELECT   ' +  CHAR(13)
If  @Counter is not NULL and @Counter <> 0
    SET @SQLCommand = @SQLCommand + ' TOP ' + cast(@counter as nvarchar(4)) + CHAR(13)
SET @SQLCommand = @SQLCommand + ' * '
SET @SQLCommand = @SQLCommand + ' FROM ' + @ViewTable
If  @Filter is not NULL
    SET @SQLCommand = @SQLCommand + ' Where ' + @Filter + CHAR(13)
If  @Order is not NULL
    SET @SQLCommand = @SQLCommand + @Order + CHAR(13)

EXEC sp_executesql @SQLCommand

 
			 
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/

	If @@ROWCOUNT = 0 
		Begin
			Set  @MjsErrCode = -1
			Set @MjsErrDescr = 'No se encontraron registros.'
		End
	Else
		if (@@Error <> 0)
			Begin
				Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
			End
		Else
			Begin
				 ---Armar mensaje de operación exitosa
				Set @MjsErrDescr = 'Se encontraron registro(s).'

			End

GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_SEC_Accesos_GETONE]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamin Melendez Gomez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Lee un registro del Catalogo de RPT_SEC_Accesos
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.12.05 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamin Melendez   |Adecuación de Procedimiento.
=======================================================================================================
*/
CREATE PROCEDURE [dbo].[SP_RPT_SEC_Accesos_GETONE]
(
     @Id as Int,
     @MjsErrCode as int OUTPUT,			    -- Codigo de Error
     @MjsErrDescr as varchar(255)  OUTPUT    -- Descripcion del Error  

)
AS
Begin Transaction
	
	SELECT TOP 1 *
	FROM 
		 [dbo].RPT_SEC_Accesos
	WHERE  Id = @Id
     
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	If (@@Error <> 0)
		Begin
			Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
			Rollback
		End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se encontro un registro.'
			Declare @OperacionID as Integer
			Set @OperacionID = @@Identity
			Commit
			
	End


GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_SEC_Accesos_DEL]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Elimina registros en el Catalogo de RPT_SEC_Accesos
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0	  |2012.06.04 |Benjamin Melendez   |Adecuación de procedimiento.	
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_RPT_SEC_Accesos_DEL]
(
	@ID as Int,
    @MjsErrCode as Int OUTPUT,			   -- Codigo de Error
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
Begin Transaction
	--- Datos antes del Cambio
	
	
	DELETE FROM [dbo].RPT_SEC_Accesos
		   WHERE ID = @ID 
	 
	
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	
	 
	If (@MjsErrCode <> 0)
		
			Begin
				Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
				Rollback
			End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se elimino con éxito'
			 
			Commit
							
	 End


GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_SEC_Accesos_ADD]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Insertar nuevos registros para el Catalogo de RPT_SEC_Accesos
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamín Meléndez	   |Adecuación de procedimiento.
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_RPT_SEC_Accesos_ADD]
(
	@IdUsuario as int,
	@IdReporte as int,
	@Disponible as bit,
	@OperacionID as Int  OUTPUT,
    @MjsErrCode as Int OUTPUT,			   -- Codigo de Error
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
Begin Transaction
	
	INSERT INTO [dbo].RPT_SEC_Accesos 
				(
				    IdUsuario 
					,IdReporte 
					,Disponible
				)
				VALUES
				(
					@IdUsuario,
					@IdReporte ,
					@Disponible 
				)

	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	If (@@Error <> 0)
		Begin
			Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error And msglangid = 3082)
			Rollback
		End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se agrego con éxito'
			Set @OperacionID = @@Identity
			Commit
			
				
	 End


GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_UPD]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez Gómez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Actualizar registros en el Catalogo de RPT_CFG_DatosEntes
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamín Meléndez     |Adecuación de procedimiento.
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_RPT_CFG_DatosEntes_UPD]
(
	@Id as int,
	@Nombre as nvarchar(100),
	@ClaveSistema as nvarchar(100),
	@Domicilio as nvarchar (250),
	@Ciudad as nvarchar(250),
	@RFC as nvarchar (20),
	@Telefonos as nvarchar(20),
	@Texto as nvarchar (1000),
	@LogoEnte as image,
	@LogoKorima as image,
	@MjsErrCode as Int OUTPUT,			   -- Codigo de Error
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
Begin Transaction
	--- Actualizar Registro
	UPDATE [dbo].RPT_CFG_DatosEntes
		SET  Nombre =@Nombre
			,ClaveSistema  =@ClaveSistema
			,Domicilio=@Domicilio
			,Ciudad=@Ciudad
			,RFC=@RFC
			,Telefonos=@Telefonos
			,Texto=@Texto
			,LogoEnte=@LogoEnte
			,LogoKorima=@LogoKorima
			,LastUpdate=GETDATE()
		WHERE ID = @ID 
			 
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	If (@@Error <> 0)
		Begin
			Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
			Rollback
		End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se modifico con éxito'
			 
			Commit
	 End

GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_GETONE]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamin Melendez Gomez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Lee un registro del Catalogo de RPT_CFG_DatosEntes
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.12.05 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamin Melendez   |Adecuación de Procedimiento.
=======================================================================================================
*/
CREATE PROCEDURE [dbo].[SP_RPT_CFG_DatosEntes_GETONE]
(
     --@Id as Int,
     @MjsErrCode as int OUTPUT,			    -- Codigo de Error
     @MjsErrDescr as varchar(255)  OUTPUT    -- Descripcion del Error  

)
AS
Begin Transaction
	
	SELECT TOP 1 *
	FROM 
		 [dbo].RPT_CFG_DatosEntes
	--WHERE  Id = @Id
     
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	If (@@Error <> 0)
		Begin
			Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
			Rollback
		End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se encontro un registro.'
			Declare @OperacionID as Integer
			Set @OperacionID = @@Identity
			Commit
			
	End


GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_DEL]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Elimina registros en el Catalogo de RPT_CFG_DatosEntes
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0	  |2012.06.04 |Benjamin Melendez   |Adecuación de procedimiento.	
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_RPT_CFG_DatosEntes_DEL]
(
	@ID as Int,
    @MjsErrCode as Int OUTPUT,			   -- Codigo de Error
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
Begin Transaction
		
	DELETE FROM [dbo].RPT_CFG_DatosEntes
		   WHERE ID = @ID 
	 
	
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	
	 
	If (@MjsErrCode <> 0)
		
			Begin
				Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
				Rollback
			End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se elimino con éxito'
			 
			Commit
				
	 End


GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_ADD]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Insertar nuevos registros para el Catalogo de RPT_CFG_DatosEntes
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamín Meléndez	   |Adecuación de procedimiento.
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_RPT_CFG_DatosEntes_ADD]
(
	@Nombre as nvarchar(100),
	@ClaveSistema as nvarchar(100),
	@Domicilio as nvarchar (250),
	@Ciudad as nvarchar(250),
	@RFC as nvarchar (20),
	@Telefonos as nvarchar(20),
	@Texto as nvarchar (1000),
	@LogoEnte as image,
	@LogoKorima as image,
	@OperacionID as Int  OUTPUT,
    @MjsErrCode as Int OUTPUT,			   -- Codigo de Error
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
Begin Transaction
	--- Insertar Registro
	INSERT INTO [dbo].RPT_CFG_DatosEntes 
				(
				    [Nombre]
					,[ClaveSistema]
				   ,[Domicilio]
				   ,[Ciudad]
				   ,[RFC]
				   ,[Telefonos]
				   ,[Texto]
				   ,[LogoEnte]
				   ,[LogoKorima]
				   ,[LastUpdate]
				)
				VALUES
				(
					@Nombre
				   ,@ClaveSistema
				   ,@Domicilio
				   ,@Ciudad
				   ,@RFC
				   ,@Telefonos
				   ,@Texto
				   ,@LogoEnte
				   ,@LogoKorima
				   ,GETDATE()
				)

	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	If (@@Error <> 0)
		Begin
			Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error And msglangid = 3082)
			Rollback
		End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se agrego con éxito'
			Set @OperacionID = @@Identity
			Commit
		
				
	 End

GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CAT_Reportes_UPD]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez Gómez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Actualizar registros en el Catalogo de RPT_CAT_Reportes
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamín Meléndez     |Adecuación de procedimiento.
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_RPT_CAT_Reportes_UPD]
(
	@ID as Int,
	@ReporteNombre as nvarchar(100),
	@ReporteDescripcion as nvarchar(100),
	@ReporteVersion as nvarchar(50),
	@ReporteFechaCambio as nvarchar(50),
	@ArchivoNombre as nvarchar(50),
	@ArchivoReporte as binary (8000),
    @MjsErrCode as Int OUTPUT,			   -- Codigo de Error
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
Begin Transaction
	 

	UPDATE [dbo].RPT_CAT_Reportes
		SET  ReporteNombre =@ReporteNombre
			,ReporteDescripcion =@ReporteDescripcion
			,ReporteVersion=@ReporteVersion
			,ReporteFechaCambio=@ReporteFechaCambio
			,ArchivoNombre=@ArchivoNombre
			,ArchivoReporte= @ArchivoReporte
		WHERE ID = @ID 
			 
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	If (@@Error <> 0)
		Begin
			Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
			Rollback
		End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se modifico con éxito'
			 
			Commit
			
				
	 End


GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CAT_Reportes_GETONE]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamin Melendez Gomez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Lee un registro del Catalogo de RPT_CAT_Reportes
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.12.05 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamin Melendez   |Adecuación de Procedimiento.
=======================================================================================================
*/
CREATE PROCEDURE [dbo].[SP_RPT_CAT_Reportes_GETONE]
(
     @Id as Int,  
     @MjsErrCode as int OUTPUT,			    -- Codigo de Error
     @MjsErrDescr as varchar(255)  OUTPUT    -- Descripcion del Error  

)
AS
Begin Transaction
	
	SELECT TOP 1 *
	FROM 
		 [dbo].RPT_CAT_Reportes
	WHERE  Id = @Id
     
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	If (@@Error <> 0)
		Begin
			Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
			Rollback
		End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se encontro un registro.'
			Declare @OperacionID as Integer
			Set @OperacionID = @@Identity
			Commit
			
	End


GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CAT_Reportes_DEL]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Elimina registros en el Catalogo de RPT_CAT_Reportes
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0	  |2012.06.04 |Benjamin Melendez   |Adecuación de procedimiento.	
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_RPT_CAT_Reportes_DEL]
(
	@ID as Int,
    @MjsErrCode as Int OUTPUT,			   -- Codigo de Error
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
Begin Transaction

		
	DELETE FROM [dbo].RPT_CAT_Reportes
		   WHERE ID = @ID 
	 
	
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	
	 
	If (@MjsErrCode <> 0)
		
			Begin
				Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
				Rollback
			End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se elimino con éxito'
			 
			Commit
			
	 End


GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CAT_Reportes_ADD]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Insertar nuevos registros para el Catalogo de RPT_CAT_Reportes
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamín Meléndez	   |Adecuación de procedimiento.
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_RPT_CAT_Reportes_ADD]
(
	@ReporteNombre as nvarchar(100),
	@ReporteDescripcion as nvarchar(100),
	@ReporteVersion as nvarchar(50),
	@ReporteFechaCambio as nvarchar(50),
	@ArchivoNombre as nvarchar(50),
	@ArchivoReporte as Binary(8000),
	@OperacionID as Int  OUTPUT,
    @MjsErrCode as Int OUTPUT,			   -- Codigo de Error
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
Begin Transaction

	INSERT INTO [dbo].RPT_CAT_Reportes 
				(
				    [ReporteNombre]
					,[ReporteDescripcion]
					,[ReporteVersion]
					,[ReporteFechaCambio]
					,[ArchivoNombre]
					,[ArchivoReporte]
				)
				VALUES
				(
					@ReporteNombre,
					@ReporteDescripcion ,
					@ReporteVersion ,
					@ReporteFechaCambio ,
					@ArchivoNombre,
					@ArchivoReporte
				)

	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	If (@@Error <> 0)
		Begin
			Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error And msglangid = 3082)
			Rollback
		End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se agrego con éxito'
			Set @OperacionID = @@Identity
			Commit
							
	 End


GO
/****** Object:  StoredProcedure [dbo].[SP_C_Usuarios_UPD]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez Gómez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Actualizar registros en el Catalogo de C_Usuarios
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamín Meléndez     |Adecuación de procedimiento.
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_C_Usuarios_UPD]
(
	@IdUsuario as int,
	@NumeroEmpleado as int,
	@Login as varchar(40),
	@Pwd as varchar (12),
	@NivelAutorizacion as smallint,
	@Conectado as smallint,
	@IdGrupo as smallint,
	@TipoMenu as tinyint,
	@Multiventana as tinyint,
    @MjsErrCode as Int OUTPUT,			   -- Codigo de Error
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
Begin Transaction
	
	--- Actualizar Registro
	UPDATE [dbo].C_Usuarios
		SET  NumeroEmpleado =@NumeroEmpleado
			,Login  =@Login
			,Pwd=@Pwd
			,NivelAutorizacion=@NivelAutorizacion
			,Conectado=@Conectado
			,IdGrupo=@IdGrupo
			,TipoMenu=@TipoMenu
			,MultiVentana=@MultiVentana
		WHERE IDUsuario = @IDUsuario
			 
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	If (@@Error <> 0)
		Begin
			Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
			Rollback
		End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se modifico con éxito'
			 
			Commit
			
				
	 End


GO
/****** Object:  StoredProcedure [dbo].[SP_C_Usuarios_GETONE]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamin Melendez Gomez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Lee un registro del Catalogo de C_Usuarios
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.12.05 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamin Melendez   |Adecuación de Procedimiento.
=======================================================================================================
*/
CREATE PROCEDURE [dbo].[SP_C_Usuarios_GETONE]
(
     @IdUsuario as Int,   
     @MjsErrCode as int OUTPUT,			    -- Codigo de Error
     @MjsErrDescr as varchar(255)  OUTPUT    -- Descripcion del Error  

)
AS
Begin Transaction
	
	 
	SELECT TOP 1 *
	FROM 
		 [dbo].C_Usuarios
	WHERE  IdUsuario = @IdUsuario
     
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	If (@@Error <> 0)
		Begin
			Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
			Rollback
		End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se encontro un registro.'
			Declare @OperacionID as Integer
			Set @OperacionID = @@Identity
			Commit
			
	End


GO
/****** Object:  StoredProcedure [dbo].[SP_C_Usuarios_DEL]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Elimina registros en el Catalogo de C_Usuarios
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0	  |2012.06.04 |Benjamin Melendez   |Adecuación de procedimiento.	
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_C_Usuarios_DEL]
(
	@IDUsuario as Int,
    @MjsErrCode as Int OUTPUT,			   -- Codigo de Error
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
Begin Transaction
	
	--- Eliminar Registro
	
	DELETE FROM [dbo].C_Usuarios
		   WHERE IDUsuario = @IDUsuario
	 
	
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	
	 
	If (@MjsErrCode <> 0)
		
			Begin
				Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
				Rollback
			End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se elimino con éxito'
			 
			Commit
			
				
	 End


GO
/****** Object:  StoredProcedure [dbo].[SP_C_Usuarios_ADD]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Insertar nuevos registros para el Catalogo de C_Usuarios
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamín Meléndez	   |Adecuación de procedimiento.
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_C_Usuarios_ADD]
(
	@NumeroEmpleado as int,
	@Login as varchar(40),
	@Pwd as varchar (12),
	@NivelAutorizacion as smallint,
	@Conectado as smallint,
	@IdGrupo as smallint,
	@TipoMenu as tinyint,
	@Multiventana as tinyint,
	@OperacionID as Int  OUTPUT,
    @MjsErrCode as Int OUTPUT,			   -- Codigo de Error
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
Begin Transaction
	
	--- Insertar Registro
	INSERT INTO [dbo].C_Usuarios 
				(
				   [NumeroEmpleado]
				   ,[Login]
				   ,[Pwd]
				   ,[NivelAutorizacion]
				   ,[Conectado]
				   ,[IdGrupo]
				   ,[TipoMenu]
				   ,[Multiventana]
				)
				VALUES
				(
					@NumeroEmpleado
				   ,@Login
				   ,@Pwd
				   ,@NivelAutorizacion
				   ,@Conectado
				   ,@IdGrupo
				   ,@TipoMenu
				   ,@Multiventana
				)

	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	If (@@Error <> 0)
		Begin
			Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error And msglangid = 3082)
			Rollback
		End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se agrego con éxito'
			Set @OperacionID = @@Identity
			Commit
			
				
	 End


GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_SEC_Accesos_UPD]    Script Date: 07/05/2012 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez Gómez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Actualizar registros en el Catalogo de RPT_SEC_Accesos
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamín Meléndez     |Adecuación de procedimiento.
=======================================================================================================
*/
CREATE Procedure [dbo].[SP_RPT_SEC_Accesos_UPD]
(
	@ID as Int,
	@IdUsuario as int,
	@IdReporte as int,
	@Disponible as bit,
    @MjsErrCode as Int OUTPUT,			   -- Codigo de Error
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error
)
AS
Begin Transaction

	UPDATE [dbo].RPT_SEC_Accesos
		SET  IdUsuario =@IdUsuario
			,IdReporte =@IdReporte
			,Disponible=@Disponible
		WHERE ID = @ID 
			 
	/*==============================================================================================
	Control de Errores
	==============================================================================================*/
	Set @MjsErrCode = @@Error
	If (@@Error <> 0)
		Begin
			Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)
			Rollback
		End
	Else
		Begin
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se modifico con éxito'
			 
			Commit

				
	 End


GO

/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor_Detalles]    Script Date: 07/05/2012 14:18:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor_Detalles]
AS
SELECT DISTINCT [C_Proveedores].[RazonSocial],[C_Proveedores].[RFC], 
case dbo.T_Pedidos.Estatus when 'R' then sum (dbo.T_Pedidos.TotalGral) end as Recibido,
case dbo.T_Pedidos.Estatus when 'C' then SUM(dbo.T_Pedidos.TotalGral) end as Ccancelado,
case dbo.T_Pedidos.Estatus when 'P' then SUM(dbo.T_Pedidos.TotalGral) end as Pedido,
T_Pedidos.Fecha 
FROM dbo.C_Proveedores
INNER JOIN dbo.T_Pedidos 
ON dbo.C_Proveedores.IdProveedor = dbo.T_Pedidos.IdProveedor 
Group By [C_Proveedores].[RazonSocial],dbo.T_Pedidos.Estatus, [C_Proveedores].[RFC], T_Pedidos.Fecha


GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra]    Script Date: 07/05/2012 14:18:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra]
AS
SELECT     dbo.T_Pedidos.IdSolicitud, dbo.T_SellosPresupuestales.IdPartida AS IdOrden, dbo.T_Pedidos.Folio, 
                      CASE T_Pedidos.Estatus WHEN 'R' THEN 'Recibido' WHEN 'P' THEN 'Pedido' WHEN 'N' THEN 'Cancelado' END AS Estatus, dbo.T_Pedidos.IdProveedor, 
                      dbo.C_Proveedores.RazonSocial, dbo.T_SellosPresupuestales.Sello AS IdPartida, dbo.T_Pedidos.Observaciones, 
                      dbo.D_Pedidos.DescripcionAdicional AS DescripcionServicio, dbo.C_AreaResponsabilidad.Clave, dbo.C_PartidasPres.ClavePartida, 
                      dbo.C_AreaResponsabilidad.Nombre, dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS maskUnidadResponsable, 
                      dbo.C_AreaResponsabilidad.Clave AS UnidadResponsable_Clave, dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_mask_ClaveNombre, 
                      dbo.C_PartidasPres.ClavePartida AS PartPres_Clave, dbo.C_PartidasPres.DescripcionPartida AS PartPres_Nombre, 
                      dbo.C_PartidasPres.ClavePartida + ' ' + dbo.C_PartidasPres.DescripcionPartida AS PartPres_mask_ClaveNombre, 
                      dbo.C_Proveedores.IdProveedor AS Proveedores_ID, dbo.C_Proveedores.RazonSocial AS Proveedores_RazonSocial, 
                      CAST(dbo.C_Proveedores.IdProveedor AS VARCHAR) + ' ' + dbo.C_Proveedores.RazonSocial AS Proveedores_mask_IdRazonSocial, 
                      dbo.T_Pedidos.Folio AS PedidosDetalle_OrdenCompra, dbo.T_Pedidos.Fecha AS PedidosDetalle_Fecha, dbo.D_Pedidos.Cantidad AS PedidosDetalle_Cantidad, 
                      dbo.D_Pedidos.CostoUnitario AS PedidosDetalle_CostoUnitario, dbo.D_Pedidos.Importe AS PedidosDetalle_Importe, 
                      dbo.C_Maestro.DescripcionGenerica AS PedidosDetalle_Descripcion
FROM         dbo.T_SellosPresupuestales INNER JOIN
                      dbo.D_Pedidos ON dbo.T_SellosPresupuestales.IdSelloPresupuestal = dbo.D_Pedidos.IdSelloPresupuestal INNER JOIN
                      dbo.C_Maestro ON dbo.D_Pedidos.IdCodigoProducto = dbo.C_Maestro.IdCodigoProducto AND dbo.D_Pedidos.IdGrupo = dbo.C_Maestro.IdGrupo AND 
                      dbo.D_Pedidos.IdSubGrupo = dbo.C_Maestro.IdSubGrupo INNER JOIN
                      dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp INNER JOIN
                      dbo.C_PartidasPres ON dbo.T_SellosPresupuestales.IdPartida = dbo.C_PartidasPres.IdPartida RIGHT OUTER JOIN
                      dbo.T_Pedidos ON dbo.D_Pedidos.IdPedido = dbo.T_Pedidos.IdPedido LEFT OUTER JOIN
                      dbo.C_Proveedores ON dbo.C_Proveedores.IdProveedor = dbo.T_Pedidos.IdProveedor
WHERE     (dbo.T_Pedidos.IdPedido IN
                          (SELECT     IdPedido
                            FROM          dbo.D_Pedidos AS D_Pedidos_1
                            WHERE      (IdSelloPresupuestal IN
                                                       (SELECT     IdSelloPresupuestal
                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) AND (dbo.T_Pedidos.Estatus <> 'C')

GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor_Detalles]    Script Date: 07/05/2012 14:18:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor_Detalles]
AS
SELECT DISTINCT [C_Proveedores].[RazonSocial],[C_Proveedores].[RFC], 
case dbo.T_OrdenServicio.Estatus when 'R' then sum (dbo.T_OrdenServicio.TotalGral) end as Recibido,
case dbo.T_OrdenServicio.Estatus when 'C' then SUM(dbo.T_OrdenServicio.TotalGral) end as Cancelado,
case dbo.T_OrdenServicio.Estatus when 'P' then SUM(dbo.T_OrdenServicio.TotalGral) end as Pedido
FROM dbo.C_Proveedores
INNER JOIN dbo.T_OrdenServicio 
ON dbo.C_Proveedores.IdProveedor = dbo.T_OrdenServicio.IdProveedor 
Group By [C_Proveedores].[RazonSocial],dbo.T_OrdenServicio.Estatus, [C_Proveedores].[RFC]

GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor]    Script Date: 07/05/2012 14:18:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor]
AS
SELECT     RazonSocial, RFC,
                          isnull((SELECT     SUM(Recibido) AS Expr1
                            FROM          dbo.VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor_Detalles
                            WHERE      (RazonSocial = dbo.C_Proveedores.RazonSocial)),0) AS Recibido,
                          isnull((SELECT     SUM(Cancelado) AS Expr1
                            FROM          dbo.VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor_Detalles AS VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor_Detalles_2
                            WHERE      (RazonSocial = dbo.C_Proveedores.RazonSocial)),0) AS Cancelado,
                          isnull((SELECT     SUM(Pedido) AS Expr1
                            FROM          dbo.VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor_Detalles AS VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor_Detalles_1
                            WHERE      (RazonSocial = dbo.C_Proveedores.RazonSocial)),0) AS Pedido
                          
FROM         dbo.C_Proveedores

GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor]    Script Date: 07/05/2012 14:18:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor]
AS
SELECT     RazonSocial, RFC,
                          isnull((SELECT     SUM(Recibido) AS Expr1
                            FROM          dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor_Detalles
                            WHERE      (RazonSocial = dbo.C_Proveedores.RazonSocial)),0) AS Recibido,
                          isnull((SELECT     SUM(Ccancelado) AS Expr1
                            FROM          dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor_Detalles AS VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor_Detalles_2
                            WHERE      (RazonSocial = dbo.C_Proveedores.RazonSocial)),0) AS Cancelado,
                          isnull((SELECT     SUM(Pedido) AS Expr1
                            FROM          dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor_Detalles AS VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor_Detalles_1
                            WHERE      (RazonSocial = dbo.C_Proveedores.RazonSocial)),0) AS Pedido
                          
FROM         dbo.C_Proveedores




GO


/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree]    Script Date: 07/17/2012 12:21:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree]
AS
SELECT     dbo.C_EP_Ramo.Id, dbo.C_EP_Ramo.Nivel, dbo.C_EP_Ramo.Nombre, dbo.C_EP_Ramo.Clave, C_EP_Ramo_1.Id AS IdN2, C_EP_Ramo_1.Nivel AS Nivel2, 
                      C_EP_Ramo_1.Nombre AS NombreN2, C_EP_Ramo_1.Clave AS ClaveN2, C_EP_Ramo_2.Id AS idN3, C_EP_Ramo_2.Nivel AS N3, 
                      C_EP_Ramo_2.Nombre AS NombreN3, C_EP_Ramo_2.Clave AS ClaveN3, C_EP_Ramo_3.Id AS IdN4, C_EP_Ramo_3.Nivel AS Nivel4, 
                      C_EP_Ramo_3.Nombre AS NombreN4, C_EP_Ramo_3.Clave AS ClaveN4, C_EP_Ramo_4.Id AS IdN5, C_EP_Ramo_4.Nivel AS Nivel5, 
                      C_EP_Ramo_4.Nombre AS NombreN5, C_EP_Ramo_4.Clave AS ClaveN5
FROM         dbo.C_EP_Ramo LEFT OUTER JOIN
                      dbo.C_EP_Ramo AS C_EP_Ramo_1 ON dbo.C_EP_Ramo.Id = C_EP_Ramo_1.IdPadre LEFT OUTER JOIN
                      dbo.C_EP_Ramo AS C_EP_Ramo_2 ON C_EP_Ramo_1.Id = C_EP_Ramo_2.IdPadre LEFT OUTER JOIN
                      dbo.C_EP_Ramo AS C_EP_Ramo_3 ON C_EP_Ramo_2.Id = C_EP_Ramo_3.IdPadre LEFT OUTER JOIN
                      dbo.C_EP_Ramo AS C_EP_Ramo_4 ON C_EP_Ramo_3.Id = C_EP_Ramo_4.IdPadre

GO



/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia]    Script Date: 07/17/2012 12:20:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia]
AS
SELECT     dbo.T_Pedidos.IdSolicitud, dbo.T_SellosPresupuestales.IdPartida AS IdOrden, dbo.T_Pedidos.Folio, 
                      CASE T_Pedidos.Estatus WHEN 'R' THEN 'Recibido' WHEN 'P' THEN 'Pedido' WHEN 'N' THEN 'Cancelado' END AS Estatus, dbo.T_Pedidos.IdProveedor, 
                      dbo.C_Proveedores.RazonSocial, dbo.T_SellosPresupuestales.Sello AS IdPartida, dbo.T_Pedidos.Observaciones, 
                      dbo.D_Pedidos.DescripcionAdicional AS DescripcionServicio, dbo.C_AreaResponsabilidad.Clave, dbo.C_PartidasPres.ClavePartida, 
                      dbo.C_AreaResponsabilidad.Nombre, dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS maskUnidadResponsable, 
                      dbo.C_AreaResponsabilidad.Clave AS UnidadResponsable_Clave, dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_mask_ClaveNombre, 
                      dbo.C_PartidasPres.ClavePartida AS PartPres_Clave, dbo.C_PartidasPres.DescripcionPartida AS PartPres_Nombre, 
                      dbo.C_PartidasPres.ClavePartida + ' ' + dbo.C_PartidasPres.DescripcionPartida AS PartPres_mask_ClaveNombre, 
                      dbo.C_Proveedores.IdProveedor AS Proveedores_ID, dbo.C_Proveedores.RazonSocial AS Proveedores_RazonSocial, 
                      CAST(dbo.C_Proveedores.IdProveedor AS VARCHAR) + ' ' + dbo.C_Proveedores.RazonSocial AS Proveedores_mask_IdRazonSocial, 
                      dbo.T_Pedidos.Folio AS PedidosDetalle_OrdenCompra, dbo.T_Pedidos.Fecha AS PedidosDetalle_Fecha, dbo.D_Pedidos.Cantidad AS PedidosDetalle_Cantidad, 
                      dbo.D_Pedidos.CostoUnitario AS PedidosDetalle_CostoUnitario, dbo.D_Pedidos.Importe AS PedidosDetalle_Importe, 
                      dbo.C_Maestro.DescripcionGenerica AS PedidosDetalle_Descripcion, dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN5 AS Proyecto, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN4 AS ActividadInstitucional, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN3 AS Accion, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN2 AS Programa, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.Nombre AS Eje, dbo.T_SellosPresupuestales.IdProyecto, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.Clave AS ClaveN1, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN2, dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN3, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN4, dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN5, 
                      dbo.T_Solicitudes.Folio AS FolioRequisicion
FROM         dbo.T_SellosPresupuestales INNER JOIN
                      dbo.D_Pedidos ON dbo.T_SellosPresupuestales.IdSelloPresupuestal = dbo.D_Pedidos.IdSelloPresupuestal INNER JOIN
                      dbo.C_Maestro ON dbo.D_Pedidos.IdCodigoProducto = dbo.C_Maestro.IdCodigoProducto AND dbo.D_Pedidos.IdGrupo = dbo.C_Maestro.IdGrupo AND 
                      dbo.D_Pedidos.IdSubGrupo = dbo.C_Maestro.IdSubGrupo INNER JOIN
                      dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp INNER JOIN
                      dbo.C_PartidasPres ON dbo.T_SellosPresupuestales.IdPartida = dbo.C_PartidasPres.IdPartida INNER JOIN
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree ON 
                      dbo.T_SellosPresupuestales.IdProyecto = dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.IdN5 RIGHT OUTER JOIN
                      dbo.T_Pedidos ON dbo.D_Pedidos.IdPedido = dbo.T_Pedidos.IdPedido LEFT OUTER JOIN
                      dbo.C_Proveedores ON dbo.C_Proveedores.IdProveedor = dbo.T_Pedidos.IdProveedor LEFT OUTER JOIN
                      dbo.T_Solicitudes ON dbo.T_Pedidos.IdSolicitud = dbo.T_Solicitudes.IdSolicitud
WHERE     (dbo.T_Pedidos.IdPedido IN
                          (SELECT     IdPedido
                            FROM          dbo.D_Pedidos AS D_Pedidos_1
                            WHERE      (IdSelloPresupuestal IN
                                                       (SELECT     IdSelloPresupuestal
                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) AND (dbo.T_Pedidos.Estatus <> 'C')

GO

/*AGREGADO EL 07-08-2012 INICIO*/
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompraServicioDependenciaPartidaProveedor]    Script Date: 08/07/2012 16:59:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompraServicioDependenciaPartidaProveedor]
AS
SELECT     dbo.T_Pedidos.IdSolicitud , dbo.T_SellosPresupuestales.IdPartida AS IdOrden, 'OC '+CAST(dbo.T_Pedidos.Folio as varchar) as Folio, 
                      CASE T_Pedidos.Estatus WHEN 'R' THEN 'Recibido' WHEN 'P' THEN 'Pedido' WHEN 'N' THEN 'Cancelado' END AS Estatus, dbo.T_Pedidos.IdProveedor, 
                      dbo.C_Proveedores.RazonSocial, dbo.T_SellosPresupuestales.Sello AS IdPartida, dbo.T_Pedidos.Observaciones, 
                      dbo.D_Pedidos.DescripcionAdicional AS DescripcionServicio, dbo.C_AreaResponsabilidad.Clave, dbo.C_PartidasPres.ClavePartida, 
                      dbo.C_AreaResponsabilidad.Nombre, dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS maskUnidadResponsable, 
                      dbo.C_AreaResponsabilidad.Clave AS UnidadResponsable_Clave, dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_mask_ClaveNombre, 
                      dbo.C_PartidasPres.ClavePartida AS PartPres_Clave, dbo.C_PartidasPres.DescripcionPartida AS PartPres_Nombre, 
                      dbo.C_PartidasPres.ClavePartida + ' ' + dbo.C_PartidasPres.DescripcionPartida AS PartPres_mask_ClaveNombre, 
                      dbo.C_Proveedores.IdProveedor AS Proveedores_ID, dbo.C_Proveedores.RazonSocial AS Proveedores_RazonSocial, 
                      CAST(dbo.C_Proveedores.IdProveedor AS VARCHAR) + ' ' + dbo.C_Proveedores.RazonSocial AS Proveedores_mask_IdRazonSocial, 
                      dbo.T_Pedidos.Folio AS PedidosDetalle_OrdenCompra, dbo.T_Pedidos.Fecha AS PedidosDetalle_Fecha, dbo.D_Pedidos.Cantidad AS PedidosDetalle_Cantidad, 
                      dbo.D_Pedidos.CostoUnitario AS PedidosDetalle_CostoUnitario, dbo.D_Pedidos.Importe AS PedidosDetalle_Importe, 
                      case D_Pedidos.DescripcionAdicional when '' then dbo.C_Maestro.DescripcionGenerica else D_Pedidos.DescripcionAdicional end AS PedidosDetalle_Descripcion,
                      case D_Pedidos.PorcIva when 0 then 0 else ((D_Pedidos.PorcIva/100) *dbo.D_Pedidos.Importe)end  as IVA,
                      case D_Pedidos.PorcIva  when 0 then dbo.D_Pedidos.Importe else((D_Pedidos.PorcIva/100) *dbo.D_Pedidos.Importe)+dbo.D_Pedidos.Importe end as Total
                      --D_Pedidos.DescripcionAdicional end AS PedidosDetalle_Descripcion
FROM         dbo.T_SellosPresupuestales INNER JOIN
                      dbo.D_Pedidos ON dbo.T_SellosPresupuestales.IdSelloPresupuestal = dbo.D_Pedidos.IdSelloPresupuestal INNER JOIN
                      dbo.C_Maestro ON dbo.D_Pedidos.IdCodigoProducto = dbo.C_Maestro.IdCodigoProducto AND dbo.D_Pedidos.IdGrupo = dbo.C_Maestro.IdGrupo AND 
                      dbo.D_Pedidos.IdSubGrupo = dbo.C_Maestro.IdSubGrupo INNER JOIN
                      dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp INNER JOIN
                      dbo.C_PartidasPres ON dbo.T_SellosPresupuestales.IdPartida = dbo.C_PartidasPres.IdPartida RIGHT OUTER JOIN
                      dbo.T_Pedidos ON dbo.D_Pedidos.IdPedido = dbo.T_Pedidos.IdPedido LEFT OUTER JOIN
                      dbo.C_Proveedores ON dbo.C_Proveedores.IdProveedor = dbo.T_Pedidos.IdProveedor
WHERE     (dbo.T_Pedidos.IdPedido IN
                          (SELECT     IdPedido
                            FROM          dbo.D_Pedidos AS D_Pedidos_1
                            WHERE      (IdSelloPresupuestal IN
                                                       (SELECT     IdSelloPresupuestal
                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) AND (dbo.T_Pedidos.Estatus <> 'C')
-----
UNION
SELECT     dbo.T_OrdenServicio.IdSolicitud , dbo.T_SellosPresupuestales.IdPartida AS IdOrden, 'OS '+CAST(dbo.T_OrdenServicio.Folio as varchar)as Folio , 
                      CASE T_OrdenServicio.Estatus WHEN 'R' THEN 'Recibido' WHEN 'P' THEN 'Pedido' WHEN 'N' THEN 'Cancelado' END AS Estatus, dbo.T_OrdenServicio.IdProveedor, 
                      dbo.C_Proveedores.RazonSocial, dbo.T_SellosPresupuestales.Sello AS IdPartida, dbo.T_OrdenServicio.Observaciones, 
                      dbo.D_OrdenServicio.DescripcionServicio AS DescripcionServicio, dbo.C_AreaResponsabilidad.Clave, dbo.C_PartidasPres.ClavePartida, 
                      dbo.C_AreaResponsabilidad.Nombre, dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS maskUnidadResponsable, 
                      dbo.C_AreaResponsabilidad.Clave AS UnidadResponsable_Clave, dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_mask_ClaveNombre, 
                      dbo.C_PartidasPres.ClavePartida AS PartPres_Clave, dbo.C_PartidasPres.DescripcionPartida AS PartPres_Nombre, 
                      dbo.C_PartidasPres.ClavePartida + ' ' + dbo.C_PartidasPres.DescripcionPartida AS PartPres_mask_ClaveNombre, 
                      dbo.C_Proveedores.IdProveedor AS Proveedores_ID, dbo.C_Proveedores.RazonSocial AS Proveedores_RazonSocial, 
                      CAST(dbo.C_Proveedores.IdProveedor AS VARCHAR) + ' ' + dbo.C_Proveedores.RazonSocial AS Proveedores_mask_IdRazonSocial, 
                      dbo.T_OrdenServicio.Folio AS PedidosDetalle_OrdenCompra, dbo.T_OrdenServicio.Fecha AS PedidosDetalle_Fecha, dbo.D_OrdenServicio.Cantidad AS PedidosDetalle_Cantidad, 
                      dbo.D_OrdenServicio.CostoUnitario AS PedidosDetalle_CostoUnitario, dbo.D_OrdenServicio.Importe AS PedidosDetalle_Importe--, 
                      ,D_OrdenServicio.DescripcionServicio as PedidosDetalle_Descripcion
                      , case T_OrdenServicio.IVA_PORC when 0 then 0 else ((T_OrdenServicio.IVA_PORC/100) *dbo.D_OrdenServicio.Importe)end  as IVA,
                      case T_OrdenServicio.IVA_PORC  when 0 then dbo.D_OrdenServicio.Importe else((T_OrdenServicio.IVA_PORC/100) *dbo.D_OrdenServicio.Importe)+dbo.D_OrdenServicio.Importe end as Total
                      --dbo.C_Maestro.DescripcionGenerica AS PedidosDetalle_Descripcion
FROM         dbo.T_SellosPresupuestales INNER JOIN
                      dbo.D_OrdenServicio ON dbo.T_SellosPresupuestales.IdSelloPresupuestal = dbo.D_OrdenServicio.IdSelloPresupuestal 
                      --INNER JOIN
                      --dbo.C_Maestro ON dbo.D_OrdenServicio.IdCodigoProducto = dbo.C_Maestro.IdCodigoProducto AND dbo.D_OrdenServicio.IdGrupo = dbo.C_Maestro.IdGrupo AND 
                      --dbo.D_OrdenServicio.IdSubGrupo = dbo.C_Maestro.IdSubGrupo 
                      INNER JOIN
                      dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp INNER JOIN
                      dbo.C_PartidasPres ON dbo.T_SellosPresupuestales.IdPartida = dbo.C_PartidasPres.IdPartida RIGHT OUTER JOIN
                      dbo.T_OrdenServicio ON dbo.D_OrdenServicio.IdOrden = dbo.T_OrdenServicio.IdOrden LEFT OUTER JOIN
                      dbo.C_Proveedores ON dbo.C_Proveedores.IdProveedor = dbo.T_OrdenServicio.IdProveedor
WHERE     (dbo.T_OrdenServicio.IdOrden IN
                          (SELECT     Idorden
                            FROM          dbo.D_OrdenServicio AS D_Pedidos_1
                            WHERE      (IdSelloPresupuestal IN
                                                       (SELECT     IdSelloPresupuestal
                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) AND (dbo.T_OrdenServicio.Estatus <> 'C')





GO
/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicio_Proveedor]    Script Date: 08/07/2012 16:59:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesCompra_Servicios_Proveedor]
AS

SELECT     dbo.T_Pedidos.IdSolicitud , dbo.T_SellosPresupuestales.IdPartida AS IdOrden, 'OC '+CAST(dbo.T_Pedidos.Folio as varchar) as Folio, 
                      CASE T_Pedidos.Estatus WHEN 'R' THEN 'Recibido' WHEN 'P' THEN 'Pedido' WHEN 'N' THEN 'Cancelado' END AS Estatus, dbo.T_Pedidos.IdProveedor, 
                      C_Proveedores.Domicilio,
					c_ciudades.NombreCiudad,
					C_Proveedores.RFC,
					C_TelefonosClientesProveedores.Numero AS Telefono,
					--case C_TelefonosClientesProveedores.Tipo when 'Oficina' then C_TelefonosClientesProveedores.Numero end as Telefono,
                      dbo.C_Proveedores.RazonSocial, dbo.T_SellosPresupuestales.Sello AS IdPartida, dbo.T_Pedidos.Observaciones, 
                      dbo.D_Pedidos.DescripcionAdicional AS DescripcionServicio, dbo.C_AreaResponsabilidad.Clave, dbo.C_PartidasPres.ClavePartida, 
                      dbo.C_AreaResponsabilidad.Nombre, dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS maskUnidadResponsable, 
                      dbo.C_AreaResponsabilidad.Clave AS UnidadResponsable_Clave, dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_mask_ClaveNombre, 
                      dbo.C_PartidasPres.ClavePartida AS PartPres_Clave, dbo.C_PartidasPres.DescripcionPartida AS PartPres_Nombre, 
                      dbo.C_PartidasPres.ClavePartida + ' ' + dbo.C_PartidasPres.DescripcionPartida AS PartPres_mask_ClaveNombre, 
                      dbo.C_Proveedores.IdProveedor AS Proveedores_ID, dbo.C_Proveedores.RazonSocial AS Proveedores_RazonSocial, 
                      CAST(dbo.C_Proveedores.IdProveedor AS VARCHAR) + ' ' + dbo.C_Proveedores.RazonSocial AS Proveedores_mask_IdRazonSocial, 
                      dbo.T_Pedidos.Folio AS PedidosDetalle_OrdenCompra, dbo.T_Pedidos.Fecha AS Fecha, dbo.D_Pedidos.Cantidad AS PedidosDetalle_Cantidad, 
                      dbo.D_Pedidos.CostoUnitario AS PedidosDetalle_CostoUnitario, dbo.D_Pedidos.Importe AS PedidosDetalle_Importe, 
                      case D_Pedidos.DescripcionAdicional when '' then dbo.C_Maestro.DescripcionGenerica else D_Pedidos.DescripcionAdicional end AS PedidosDetalle_Descripcion,
                      case D_Pedidos.PorcIva when 0 then 0 else ((D_Pedidos.PorcIva/100) *dbo.D_Pedidos.Importe)end  as IVA,
                      case D_Pedidos.PorcIva  when 0 then dbo.D_Pedidos.Importe else((D_Pedidos.PorcIva/100) *dbo.D_Pedidos.Importe)+dbo.D_Pedidos.Importe end as Total
                      --D_Pedidos.DescripcionAdicional end AS PedidosDetalle_Descripcion
FROM         dbo.T_SellosPresupuestales INNER JOIN
                      dbo.D_Pedidos ON dbo.T_SellosPresupuestales.IdSelloPresupuestal = dbo.D_Pedidos.IdSelloPresupuestal INNER JOIN
                      dbo.C_Maestro ON dbo.D_Pedidos.IdCodigoProducto = dbo.C_Maestro.IdCodigoProducto AND dbo.D_Pedidos.IdGrupo = dbo.C_Maestro.IdGrupo AND 
                      dbo.D_Pedidos.IdSubGrupo = dbo.C_Maestro.IdSubGrupo INNER JOIN
                      dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp INNER JOIN
                      dbo.C_PartidasPres ON dbo.T_SellosPresupuestales.IdPartida = dbo.C_PartidasPres.IdPartida RIGHT OUTER JOIN
                      dbo.T_Pedidos ON dbo.D_Pedidos.IdPedido = dbo.T_Pedidos.IdPedido LEFT OUTER JOIN
                      dbo.C_Proveedores ON dbo.C_Proveedores.IdProveedor = dbo.T_Pedidos.IdProveedor
                      inner JOIN
                      c_ciudades
                      					ON c_proveedores.IdCiudad = c_ciudades.idciudad 
                       inner join
C_TelefonosClientesProveedores
ON C_TelefonosClientesProveedores.idProveedor = c_proveedores.idproveedor and C_TelefonosClientesProveedores.Tipo= 'Oficina'

WHERE     (dbo.T_Pedidos.IdPedido IN
                          (SELECT     IdPedido
                            FROM          dbo.D_Pedidos AS D_Pedidos_1
                            WHERE      (IdSelloPresupuestal IN
                                                       (SELECT     IdSelloPresupuestal
                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) AND (dbo.T_Pedidos.Estatus <> 'C')
-----
UNION
SELECT     dbo.T_OrdenServicio.IdSolicitud , dbo.T_SellosPresupuestales.IdPartida AS IdOrden, 'OS '+CAST(dbo.T_OrdenServicio.Folio as varchar)as Folio , 
                      CASE T_OrdenServicio.Estatus WHEN 'R' THEN 'Recibido' WHEN 'P' THEN 'Pedido' WHEN 'N' THEN 'Cancelado' END AS Estatus, dbo.T_OrdenServicio.IdProveedor, 
                       C_Proveedores.Domicilio,
					c_ciudades.NombreCiudad,
					C_Proveedores.RFC,
					C_TelefonosClientesProveedores.Numero as Telefono,
					--case C_TelefonosClientesProveedores.Tipo when 'Oficina' then C_TelefonosClientesProveedores.Numero end as Telefono,
                      dbo.C_Proveedores.RazonSocial, dbo.T_SellosPresupuestales.Sello AS IdPartida, dbo.T_OrdenServicio.Observaciones, 
                      dbo.D_OrdenServicio.DescripcionServicio AS DescripcionServicio, dbo.C_AreaResponsabilidad.Clave, dbo.C_PartidasPres.ClavePartida, 
                      dbo.C_AreaResponsabilidad.Nombre, dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS maskUnidadResponsable, 
                      dbo.C_AreaResponsabilidad.Clave AS UnidadResponsable_Clave, dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_mask_ClaveNombre, 
                      dbo.C_PartidasPres.ClavePartida AS PartPres_Clave, dbo.C_PartidasPres.DescripcionPartida AS PartPres_Nombre, 
                      dbo.C_PartidasPres.ClavePartida + ' ' + dbo.C_PartidasPres.DescripcionPartida AS PartPres_mask_ClaveNombre, 
                      dbo.C_Proveedores.IdProveedor AS Proveedores_ID, dbo.C_Proveedores.RazonSocial AS Proveedores_RazonSocial, 
                      CAST(dbo.C_Proveedores.IdProveedor AS VARCHAR) + ' ' + dbo.C_Proveedores.RazonSocial AS Proveedores_mask_IdRazonSocial, 
                      dbo.T_OrdenServicio.Folio AS PedidosDetalle_OrdenCompra, dbo.T_OrdenServicio.Fecha AS Fecha, dbo.D_OrdenServicio.Cantidad AS PedidosDetalle_Cantidad, 
                      dbo.D_OrdenServicio.CostoUnitario AS PedidosDetalle_CostoUnitario, dbo.D_OrdenServicio.Importe AS PedidosDetalle_Importe--, 
                      ,D_OrdenServicio.DescripcionServicio as PedidosDetalle_Descripcion
                      , case T_OrdenServicio.IVA_PORC when 0 then 0 else ((T_OrdenServicio.IVA_PORC/100) *dbo.D_OrdenServicio.Importe)end  as IVA,
                      case T_OrdenServicio.IVA_PORC  when 0 then dbo.D_OrdenServicio.Importe else((T_OrdenServicio.IVA_PORC/100) *dbo.D_OrdenServicio.Importe)+dbo.D_OrdenServicio.Importe end as Total
                      --dbo.C_Maestro.DescripcionGenerica AS PedidosDetalle_Descripcion
FROM         dbo.T_SellosPresupuestales INNER JOIN
                      dbo.D_OrdenServicio ON dbo.T_SellosPresupuestales.IdSelloPresupuestal = dbo.D_OrdenServicio.IdSelloPresupuestal 
                      --INNER JOIN
                      --dbo.C_Maestro ON dbo.D_OrdenServicio.IdCodigoProducto = dbo.C_Maestro.IdCodigoProducto AND dbo.D_OrdenServicio.IdGrupo = dbo.C_Maestro.IdGrupo AND 
                      --dbo.D_OrdenServicio.IdSubGrupo = dbo.C_Maestro.IdSubGrupo 
                      INNER JOIN
                      dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp INNER JOIN
                      dbo.C_PartidasPres ON dbo.T_SellosPresupuestales.IdPartida = dbo.C_PartidasPres.IdPartida RIGHT OUTER JOIN
                      dbo.T_OrdenServicio ON dbo.D_OrdenServicio.IdOrden = dbo.T_OrdenServicio.IdOrden LEFT OUTER JOIN
                      dbo.C_Proveedores ON dbo.C_Proveedores.IdProveedor = dbo.T_OrdenServicio.IdProveedor
                      inner JOIN
                      c_ciudades
                      					ON c_proveedores.IdCiudad = c_ciudades.idciudad 
                      inner join
C_TelefonosClientesProveedores
ON C_TelefonosClientesProveedores.idProveedor = c_proveedores.idproveedor and C_TelefonosClientesProveedores.Tipo= 'Oficina'
                      
WHERE     (dbo.T_OrdenServicio.IdOrden IN
                          (SELECT     Idorden
                            FROM          dbo.D_OrdenServicio AS D_Pedidos_1
                            WHERE      (IdSelloPresupuestal IN
                                                       (SELECT     IdSelloPresupuestal
                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) AND (dbo.T_OrdenServicio.Estatus <> 'C')




GO

/*AGREGADO EL 07-08-2012 FIN*/

/*AGREGADO EL 08-08-2012 */


/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia]    Script Date: 08/08/2012 09:50:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia]
AS
SELECT     dbo.T_Pedidos.IdSolicitud, dbo.T_SellosPresupuestales.IdPartida AS IdOrden, dbo.T_Pedidos.Folio, 
                      CASE T_Pedidos.Estatus WHEN 'R' THEN 'Recibido' WHEN 'P' THEN 'Pedido' WHEN 'N' THEN 'Cancelado' END AS Estatus, dbo.T_Pedidos.IdProveedor, 
                      dbo.C_Proveedores.RazonSocial, dbo.T_SellosPresupuestales.Sello AS IdPartida, dbo.T_Pedidos.Observaciones, 
                      CASE dbo.D_Pedidos.DescripcionAdicional WHEN '' THEN dbo.C_Maestro.DescripcionGenerica ELSE dbo.D_Pedidos.DescripcionAdicional END AS DescripcionServicio,
                       dbo.C_AreaResponsabilidad.Clave, dbo.C_PartidasPres.ClavePartida, dbo.C_AreaResponsabilidad.Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS maskUnidadResponsable, 
                      dbo.C_AreaResponsabilidad.Clave AS UnidadResponsable_Clave, dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_mask_ClaveNombre, 
                      dbo.C_PartidasPres.ClavePartida AS PartPres_Clave, dbo.C_PartidasPres.DescripcionPartida AS PartPres_Nombre, 
                      dbo.C_PartidasPres.ClavePartida + ' ' + dbo.C_PartidasPres.DescripcionPartida AS PartPres_mask_ClaveNombre, 
                      dbo.C_Proveedores.IdProveedor AS Proveedores_ID, dbo.C_Proveedores.RazonSocial AS Proveedores_RazonSocial, 
                      CAST(dbo.C_Proveedores.IdProveedor AS VARCHAR) + ' ' + dbo.C_Proveedores.RazonSocial AS Proveedores_mask_IdRazonSocial, 
                      dbo.T_Pedidos.Folio AS PedidosDetalle_OrdenCompra, dbo.T_Pedidos.Fecha AS PedidosDetalle_Fecha, dbo.D_Pedidos.Cantidad AS PedidosDetalle_Cantidad, 
                      dbo.D_Pedidos.CostoUnitario AS PedidosDetalle_CostoUnitario, dbo.D_Pedidos.Importe AS PedidosDetalle_Importe, 
                      dbo.C_Maestro.DescripcionGenerica AS PedidosDetalle_Descripcion, dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN5 AS Proyecto, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN4 AS ActividadInstitucional, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN3 AS Accion, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN2 AS Programa, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.Nombre AS Eje, dbo.T_SellosPresupuestales.IdProyecto, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.Clave AS ClaveN1, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN2, dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN3, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN4, dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN5, 
                      dbo.T_Solicitudes.Folio AS FolioRequisicion, 'OC' AS TIPOMOVIMIENTO, CASE dbo.T_Pedidos.AplicaIVA WHEN 1 THEN ROUND((dbo.D_Pedidos.PorcIVA/100) * ( dbo.D_Pedidos.Importe),3) else 0 END AS PedidosDetalle_IVA, 
                      CASE dbo.T_Pedidos.AplicaIVA WHEN 1 THEN ROUND((dbo.D_Pedidos.PorcIVA/100) * ( dbo.D_Pedidos.Importe),3) + dbo.D_Pedidos.Importe else dbo.D_Pedidos.Importe  END  Total
FROM         dbo.T_SellosPresupuestales INNER JOIN
                      dbo.D_Pedidos ON dbo.T_SellosPresupuestales.IdSelloPresupuestal = dbo.D_Pedidos.IdSelloPresupuestal INNER JOIN
                      dbo.C_Maestro ON dbo.D_Pedidos.IdCodigoProducto = dbo.C_Maestro.IdCodigoProducto AND dbo.D_Pedidos.IdGrupo = dbo.C_Maestro.IdGrupo AND 
                      dbo.D_Pedidos.IdSubGrupo = dbo.C_Maestro.IdSubGrupo INNER JOIN
                      dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp INNER JOIN
                      dbo.C_PartidasPres ON dbo.T_SellosPresupuestales.IdPartida = dbo.C_PartidasPres.IdPartida INNER JOIN
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree ON 
                      dbo.T_SellosPresupuestales.IdProyecto = dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.IdN5 RIGHT OUTER JOIN
                      dbo.T_Pedidos ON dbo.D_Pedidos.IdPedido = dbo.T_Pedidos.IdPedido LEFT OUTER JOIN
                      dbo.C_Proveedores ON dbo.C_Proveedores.IdProveedor = dbo.T_Pedidos.IdProveedor LEFT OUTER JOIN
                      dbo.T_Solicitudes ON dbo.T_Pedidos.IdSolicitud = dbo.T_Solicitudes.IdSolicitud
WHERE     (dbo.T_Pedidos.IdPedido IN
                          (SELECT     IdPedido
                            FROM          dbo.D_Pedidos AS D_Pedidos_1
                            WHERE      (IdSelloPresupuestal IN
                                                       (SELECT     IdSelloPresupuestal
                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) AND (dbo.T_Pedidos.Estatus <> 'C')
UNION
SELECT     dbo.T_OrdenServicio.IdSolicitud, dbo.T_SellosPresupuestales.IdPartida AS IdOrden, dbo.T_OrdenServicio.Folio, 
                      CASE T_OrdenServicio.Estatus WHEN 'R' THEN 'Recibido' WHEN 'P' THEN 'Pedido' WHEN 'N' THEN 'Cancelado' END AS Estatus, dbo.T_OrdenServicio.IdProveedor, 
                      dbo.C_Proveedores.RazonSocial, dbo.T_SellosPresupuestales.Sello AS IdPartida, dbo.T_OrdenServicio.Observaciones, dbo.D_OrdenServicio.DescripcionServicio, 
                      dbo.C_AreaResponsabilidad.Clave, dbo.C_PartidasPres.ClavePartida, dbo.C_AreaResponsabilidad.Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS maskUnidadResponsable, 
                      dbo.C_AreaResponsabilidad.Clave AS UnidadResponsable_Clave, dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_Nombre, 
                      dbo.C_AreaResponsabilidad.Clave + ' ' + dbo.C_AreaResponsabilidad.Nombre AS UnidadResponsable_mask_ClaveNombre, 
                      dbo.C_PartidasPres.ClavePartida AS PartPres_Clave, dbo.C_PartidasPres.DescripcionPartida AS PartPres_Nombre, 
                      dbo.C_PartidasPres.ClavePartida + ' ' + dbo.C_PartidasPres.DescripcionPartida AS PartPres_mask_ClaveNombre, 
                      dbo.C_Proveedores.IdProveedor AS Proveedores_ID, dbo.C_Proveedores.RazonSocial AS Proveedores_RazonSocial, 
                      CAST(dbo.C_Proveedores.IdProveedor AS VARCHAR) + ' ' + dbo.C_Proveedores.RazonSocial AS Proveedores_mask_IdRazonSocial, 
                      dbo.T_OrdenServicio.Folio AS PedidosDetalle_OrdenCompra, dbo.T_OrdenServicio.Fecha AS PedidosDetalle_Fecha, 
                      dbo.D_OrdenServicio.Cantidad AS PedidosDetalle_Cantidad, dbo.D_OrdenServicio.CostoUnitario AS PedidosDetalle_CostoUnitario, 
                      dbo.D_OrdenServicio.Importe AS PedidosDetalle_Importe, dbo.D_OrdenServicio.DescripcionServicio AS Pedidos_Detalle_Descripcion, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN5 AS Proyecto, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN4 AS ActividadInstitucional, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN3 AS Accion, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.NombreN2 AS Programa, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.Nombre AS Eje, dbo.T_SellosPresupuestales.IdProyecto, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.Clave AS ClaveN1, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN2, dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN3, 
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN4, dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.ClaveN5, 
                      dbo.T_Solicitudes.Folio AS FolioRequisicion, 'OS' AS TIPOMOVIMIENTO, 
                      CASE dbo.T_OrdenServicio.AplicaIVA WHEN 1 THEN ROUND((dbo.T_OrdenServicio.IVA_PORC/100) * ( dbo.D_OrdenServicio.Importe),3)+ D_OrdenServicio.Importe else 0 END as PedidosDetalle_IVA,
                      --dbo.D_OrdenServicio.Importe * .16 AS PedidosDetalle_IVA, 
                      CASE dbo.T_OrdenServicio.AplicaIVA WHEN 1 THEN ROUND((dbo.T_OrdenServicio.IVA_PORC/100) * ( dbo.D_OrdenServicio.Importe),3)+ D_OrdenServicio.Importe else D_OrdenServicio.Importe end as Total
                       --dbo.D_OrdenServicio.Importe + dbo.D_OrdenServicio.Importe * .16 AS Total
FROM         dbo.T_SellosPresupuestales INNER JOIN
                      dbo.C_AreaResponsabilidad ON dbo.T_SellosPresupuestales.IdAreaResp = dbo.C_AreaResponsabilidad.IdAreaResp INNER JOIN
                      dbo.C_PartidasPres ON dbo.T_SellosPresupuestales.IdPartida = dbo.C_PartidasPres.IdPartida INNER JOIN
                      dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree ON 
                      dbo.T_SellosPresupuestales.IdProyecto = dbo.VW_RPT_K2_Adquisiciones_OrdenesCompra_Dependencia_Tree.IdN5 INNER JOIN
                      dbo.D_OrdenServicio ON dbo.T_SellosPresupuestales.IdSelloPresupuestal = dbo.D_OrdenServicio.IdSelloPresupuestal RIGHT OUTER JOIN
                      dbo.T_OrdenServicio ON dbo.D_OrdenServicio.IdOrden = dbo.T_OrdenServicio.IdOrden LEFT OUTER JOIN
                      dbo.C_Proveedores ON dbo.C_Proveedores.IdProveedor = dbo.T_OrdenServicio.IdProveedor LEFT OUTER JOIN
                      dbo.T_Solicitudes ON dbo.T_OrdenServicio.IdSolicitud = dbo.T_Solicitudes.IdSolicitud
WHERE     (dbo.T_OrdenServicio.IdOrden IN
                          (SELECT     IdOrden
                            FROM          dbo.D_OrdenServicio AS D_Pedidos_1
                            WHERE      (IdSelloPresupuestal IN
                                                       (SELECT     IdSelloPresupuestal
                                                         FROM          dbo.T_SellosPresupuestales AS T_SellosPresupuestales_1)))) AND (dbo.T_OrdenServicio.Estatus <> 'C')
GO


/****** Object:  View [dbo].[VW_RPT_K2_Adquisiciones_ComprasYServicios_Dependencia_Partida]    Script Date: 08/08/2012 09:51:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Adquisiciones_ComprasYServicios_Dependencia_Partida]
AS
SELECT     TOP (100) PERCENT maskUnidadResponsable, PartPres_mask_ClaveNombre, SUM(Total) AS Total, ClavePartida, UnidadResponsable_Clave, PedidosDetalle_Fecha, 
                      UnidadResponsable_Nombre, PartPres_Nombre
FROM         dbo.VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia
GROUP BY maskUnidadResponsable, PartPres_mask_ClaveNombre, ClavePartida, UnidadResponsable_Clave, PedidosDetalle_Fecha, UnidadResponsable_Nombre, 
                      PartPres_Nombre
ORDER BY maskUnidadResponsable, PartPres_mask_ClaveNombre

GO


/*FIN AGREGADO */