
/****** Object:  Table [dbo].[T_CotizacionesServicios]    Script Date: 06/26/2014 12:51:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_CotizacionesServicios]') AND type in (N'U'))
DROP TABLE [dbo].[T_CotizacionesServicios]
GO



/****** Object:  Table [dbo].[T_CotizacionesServicios]    Script Date: 06/26/2014 12:51:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[T_CotizacionesServicios](
	[IdCotizacionServicios] [int] NOT NULL,
	[IdSolicitud] [int] NULL,
	[IdConsolidacion] [int] NULL,
	[Fecha] [datetime] NULL,
	[NoCotizaciones] [smallint] NULL,
	[Observaciones] [varchar](500) NULL,
	[Tipo] [tinyint] NULL,
 CONSTRAINT [PK_CotizacionServicios] PRIMARY KEY NONCLUSTERED 
(
	[IdCotizacionServicios] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



/****** Object:  Table [dbo].[D_CotizacionesServicios]    Script Date: 06/26/2014 12:49:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_CotizacionesServicios]') AND type in (N'U'))
DROP TABLE [dbo].[D_CotizacionesServicios]
GO


/****** Object:  Table [dbo].[D_CotizacionesServicios]    Script Date: 06/26/2014 12:49:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[D_CotizacionesServicios](
	[DCotizacionServicios] [int] NOT NULL,
	[IdCotizacionServicios] [int] NULL,
	[IdUnicoConsolidacion] [int] NULL,
	[Estatus] [varchar](1) NULL,
	[Cantidad] [float] NULL,
	[CostoUnitario] [float] NULL,
	[Importe] [float] NULL,
	[IVA] [decimal](12, 2) NULL,
	[PorcIva] [float] NULL,
	[IdSelloPresupuestal] [int] NULL,
	[IdLineacosto] [varchar](4) NULL,
	[Asignada] [tinyint] NULL,
	[DiasEntrega] [tinyint] NULL,
	[ProgramacionEntrega] [datetime] NULL,
	[Comentario] [varchar](50) NULL,
	[DescripcionAdicional] [varchar](500) NULL,
	[IdTipoServicio] [int] NULL,
 CONSTRAINT [PK_D_CotizacionesServicios] PRIMARY KEY CLUSTERED 
(
	[DCotizacionServicios] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO




/****** Object:  Table [dbo].[T_CotizacionesProvServicios]    Script Date: 06/26/2014 12:52:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_CotizacionesProvServicios]') AND type in (N'U'))
DROP TABLE [dbo].[T_CotizacionesProvServicios]
GO



/****** Object:  Table [dbo].[T_CotizacionesProvServicios]    Script Date: 06/26/2014 12:52:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[T_CotizacionesProvServicios](
	[IdCotizacionProvServicios] [int] NOT NULL,
	[IdCotizacionServicios] [int] NULL,
	[IdProveedor] [smallint] NULL,
	[Fecha] [datetime] NULL,
	[SubTotal] [float] NULL,
	[IVA] [decimal](12, 2) NULL,
	[Descuento] [float] NULL,
	[TotalGral] [decimal](12, 2) NULL,
	[IdMonedaExtrangera] [smallint] NULL,
	[TipodeCambio] [decimal](11, 4) NULL,
	[Estatus] [varchar](1) NULL,
	[IdUsuario] [smallint] NULL,
	[FechaAuditoria] [datetime] NULL,
	[HoraAuditoria] [datetime] NULL,
	[Validado] [tinyint] NULL,
	[PartidasAsignadas] [tinyint] NULL,
	[IdOrden] [int] NULL,
	[IdCondicionEntrega] [smallint] NULL,
	[IdCondicionPago] [smallint] NULL,
	[IdTipoCompra] [varchar](4) NULL,
 CONSTRAINT [Pk_CotizacionProvServicios] PRIMARY KEY NONCLUSTERED 
(
	[IdCotizacionProvServicios] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


