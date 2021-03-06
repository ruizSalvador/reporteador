
/****** Object:  Table [dbo].[C_ClasificacionPlazas]    Script Date: 08/05/2016 10:24:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ClasificacionPlazas]') AND type in (N'U'))
DROP TABLE [dbo].[C_ClasificacionPlazas]
GO
/****** Object:  Table [dbo].[C_ClasificacionPlazas]    Script Date: 08/05/2016 10:24:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[C_ClasificacionPlazas](
	[IdClasPlaza] [int] NOT NULL,
	[Nombre] [varchar](200) NULL,
	[Grupo] [int] NULL,
 CONSTRAINT [PK_ClasPlaza] PRIMARY KEY CLUSTERED 
(
	[IdClasPlaza] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[C_ClasificacionPlazas] ([IdClasPlaza], [Nombre], [Grupo]) VALUES (1, N'Administrativo', 1)
INSERT [dbo].[C_ClasificacionPlazas] ([IdClasPlaza], [Nombre], [Grupo]) VALUES (2, N'Servicios', 1)
INSERT [dbo].[C_ClasificacionPlazas] ([IdClasPlaza], [Nombre], [Grupo]) VALUES (3, N'Docente', 2)
INSERT [dbo].[C_ClasificacionPlazas] ([IdClasPlaza], [Nombre], [Grupo]) VALUES (4, N'Director', 2)
INSERT [dbo].[C_ClasificacionPlazas] ([IdClasPlaza], [Nombre], [Grupo]) VALUES (5, N'Supervisor', 2)
INSERT [dbo].[C_ClasificacionPlazas] ([IdClasPlaza], [Nombre], [Grupo]) VALUES (6, N'Mando', 3)
