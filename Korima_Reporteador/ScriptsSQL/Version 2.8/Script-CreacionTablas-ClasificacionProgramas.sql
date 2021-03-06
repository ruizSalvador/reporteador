/****** Object:  Table [dbo].[C_ProgramaPresupuestario]    Script Date: 06/04/2014 17:12:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ProgramaPresupuestario]') AND type in (N'U'))
DROP TABLE [dbo].[C_ProgramaPresupuestario]
GO
/****** Object:  Table [dbo].[C_SubProgramaPresupuestal]    Script Date: 06/04/2014 17:12:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_SubProgramaPresupuestal]') AND type in (N'U'))
DROP TABLE [dbo].[C_SubProgramaPresupuestal]
GO
/****** Object:  Table [dbo].[C_SubProgramaPresupuestal]    Script Date: 06/04/2014 17:12:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_SubProgramaPresupuestal]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[C_SubProgramaPresupuestal](
	[IdSubProgPres] [int] NOT NULL,
	[IdProgPres] [int] NULL,
	[Clave] [varchar](10) NULL,
	[Nombre] [varchar](100) NULL,
 CONSTRAINT [Pk_IdSubProgPres] PRIMARY KEY CLUSTERED 
(
	[IdSubProgPres] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (1, 1, N'S', N'Sujetos a Reglas de Operación')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (2, 1, N'U', N'Otros Subsidios')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (3, 2, N'E', N'Prestación de Servicios Públicos')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (4, 2, N'B', N'Provisión de Bienes Públicos')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (5, 2, N'P', N'Planeación, seguimiento y evaluación de políticas públicas')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (6, 2, N'F', N'Promoción y fomento')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (7, 2, N'G', N'Regulación y supervisión')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (8, 2, N'A', N'Funciones de las Fuerzas Armadas (Únicamente Gobierno Federal)')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (9, 2, N'R', N'Específicos')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (10, 2, N'K', N'Proyectos de Inversión')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (11, 3, N'M', N'Apoyo al proceso presupuestario y para mejorar la eficiencia institucional')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (12, 3, N'O', N'Apoyo a la función pública y al mejoramiento de la gestión')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (13, 3, N'W', N'Operaciones ajenas')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (14, 4, N'L', N'Obligaciones de cumplimiento de resolución jurisdiccional')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (15, 4, N'N', N'Desastres Naturales')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (16, 5, N'J', N'Pensiones y jubilaciones')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (17, 5, N'T', N'Aportaciones a la seguridad social')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (18, 5, N'Y', N'Aportaciones a fondos de estabilización')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (19, 5, N'Z', N'Aportaciones a fondos de inversión y reestructura de pensiones')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (20, 6, N'I', N'Gasto Federalizado')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (21, 6, N'C', N'Participaciones a entidades federativas y municipios')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (22, 6, N'D', N'Costo financiero, deuda o apoyos a deudores y ahorradores de la banca')
INSERT [dbo].[C_SubProgramaPresupuestal] ([IdSubProgPres], [IdProgPres], [Clave], [Nombre]) VALUES (23, 6, N'H', N'Adeudos de ejercicios fiscales anteriores')
/****** Object:  Table [dbo].[C_ProgramaPresupuestario]    Script Date: 06/04/2014 17:12:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ProgramaPresupuestario]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[C_ProgramaPresupuestario](
	[IdProgPres] [int] NOT NULL,
	[Nombre] [varchar](100) NULL,
 CONSTRAINT [Pk_IdProgPres] PRIMARY KEY CLUSTERED 
(
	[IdProgPres] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[C_ProgramaPresupuestario] ([IdProgPres], [Nombre]) VALUES (1, N'Subsidios: Sector Social y Privado o Entidades Federativas y Municipios')
INSERT [dbo].[C_ProgramaPresupuestario] ([IdProgPres], [Nombre]) VALUES (2, N'Desempeño de las Funciones')
INSERT [dbo].[C_ProgramaPresupuestario] ([IdProgPres], [Nombre]) VALUES (3, N'Administrativos y de Apoyo')
INSERT [dbo].[C_ProgramaPresupuestario] ([IdProgPres], [Nombre]) VALUES (4, N'Compromisos')
INSERT [dbo].[C_ProgramaPresupuestario] ([IdProgPres], [Nombre]) VALUES (5, N'Obligaciones')
INSERT [dbo].[C_ProgramaPresupuestario] ([IdProgPres], [Nombre]) VALUES (6, N'Programas de Gasto Federalizado (Gobierno Federal)')


IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, sysindexes SC
WHERE SO.id = SC.id
and SO.name = 'C_SubProgramaPresupuestal'
and SC.name = 'Fk_IdProgPres')

CREATE INDEX Fk_IdProgPres
ON C_SubProgramaPresupuestal (IdProgPres )
GO
