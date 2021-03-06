/****** Object:  Table [dbo].[C_ReferenciaMunicipios]    Script Date: 08/26/2013 09:40:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ReferenciaMunicipios]') AND type in (N'U'))
DROP TABLE [dbo].[C_ReferenciaMunicipios]
GO

/****** Object:  Table [dbo].[C_ReferenciaMunicipios]    Script Date: 08/26/2013 09:40:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[C_ReferenciaMunicipios](
	[Id] [int] NULL,
	[NombreMunicipio] [nchar](100) NULL,
	[Nomenclatura] [nchar](3) NULL
) ON [PRIMARY]
GO
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (1, N'AHOME                                                                                               ', N'AHO')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (2, N'ANGOSTURA                                                                                           ', N'ANG')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (3, N'BADIRAGUATO                                                                                         ', N'BAD')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (4, N'CONCORDIA                                                                                           ', N'CON')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (5, N'COSALÁ                                                                                              ', N'COS')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (6, N'CULIACÁN                                                                                            ', N'CUL')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (7, N'CHOIX                                                                                               ', N'CHO')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (9, N'ESCUINAPA                                                                                           ', N'ESC')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (10, N'EL FUERTE                                                                                           ', N'EL ')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (11, N'GUASAVE                                                                                             ', N'GUA')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (12, N'MAZATLÁN                                                                                            ', N'MAZ')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (13, N'MOCORITO                                                                                            ', N'MOC')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (14, N'ROSARIO                                                                                             ', N'ROS')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (15, N'SALVADOR ALVARADO                                                                                   ', N'SAL')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (16, N'SAN IGNACIO                                                                                         ', N'SAN')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (17, N'SINALOA                                                                                             ', N'SIN')
INSERT [dbo].[C_ReferenciaMunicipios] ([Id], [NombreMunicipio], [Nomenclatura]) VALUES (18, N'NAVOLATO                                                                                            ', N'NAV')
