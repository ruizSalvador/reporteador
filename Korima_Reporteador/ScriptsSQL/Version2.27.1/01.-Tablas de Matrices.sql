/****** Object:  Table [dbo].[C_MatrizRecaudadoIngresosSinDevengado]    Script Date: 22/03/2018 12:05:32 a. m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_MatrizRecaudadoIngresosSinDevengado]') AND type in (N'P', N'PC','U'))
DROP TABLE [dbo].[C_MatrizRecaudadoIngresosSinDevengado]
GO
/****** Object:  Table [dbo].[C_MatrizPagadoGasto]    Script Date: 22/03/2018 12:05:32 a. m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_MatrizPagadoGasto]') AND type in (N'P', N'PC','U'))
DROP TABLE [dbo].[C_MatrizPagadoGasto]
GO
/****** Object:  Table [dbo].[C_MatrizIngresosRecaudados]    Script Date: 22/03/2018 12:05:32 a. m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_MatrizIngresosRecaudados]') AND type in (N'P', N'PC','U'))
DROP TABLE [dbo].[C_MatrizIngresosRecaudados]
GO
/****** Object:  Table [dbo].[C_MatrizIngresosDevengados]    Script Date: 22/03/2018 12:05:32 a. m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_MatrizIngresosDevengados]') AND type in (N'P', N'PC','U'))
DROP TABLE [dbo].[C_MatrizIngresosDevengados]
GO
/****** Object:  Table [dbo].[C_MatrizDevengadoGastos]    Script Date: 22/03/2018 12:05:32 a. m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_MatrizDevengadoGastos]') AND type in (N'P', N'PC','U'))
DROP TABLE [dbo].[C_MatrizDevengadoGastos]
GO
/****** Object:  Table [dbo].[C_MatrizDevengadoGastos]    Script Date: 22/03/2018 12:05:32 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[C_MatrizDevengadoGastos](
	[COG] [varchar](10) NULL,
	[NombreCOG] [varchar](max) NULL,
	[TipoGasto] [varchar](3) NULL,
	[Caracteristicas] [varchar](max) NULL,
	[CuentaCargo] [varchar](80) NULL,
	[NombreCuentaCargo] [varchar](max) NULL,
	[CuentaAbono] [varchar](80) NULL,
	[NombreCuentaAbono] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[C_MatrizIngresosDevengados]    Script Date: 22/03/2018 12:05:32 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[C_MatrizIngresosDevengados](
	[CRI] [varchar](10) NULL,
	[NombreCRI] [varchar](max) NULL,
	[Caracteristicas] [varchar](max) NULL,
	[CuentaCargo] [varchar](80) NULL,
	[NombreCuentaCargo] [varchar](max) NULL,
	[CuentaAbono] [varchar](80) NULL,
	[NombreCuentaAbono] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[C_MatrizIngresosRecaudados]    Script Date: 22/03/2018 12:05:32 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[C_MatrizIngresosRecaudados](
	[CRI] [varchar](10) NULL,
	[NombreCRI] [varchar](max) NULL,
	[Caracteristicas] [varchar](max) NULL,
	[MedioPago] [varchar](max) NULL,
	[CuentaCargo] [varchar](80) NULL,
	[NombreCuentaCargo] [varchar](max) NULL,
	[CuentaAbono] [varchar](80) NULL,
	[NombreCuentaAbono] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[C_MatrizPagadoGasto]    Script Date: 22/03/2018 12:05:32 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[C_MatrizPagadoGasto](
	[COG] [varchar](10) NULL,
	[NombreCOG] [varchar](max) NULL,
	[TipoGasto] [varchar](3) NULL,
	[Caracteristicas] [varchar](max) NULL,
	[MedioPago] [varchar](max) NULL,
	[CuentaCargo] [varchar](80) NULL,
	[NombreCuentaCargo] [varchar](max) NULL,
	[CuentaAbono] [varchar](80) NULL,
	[NombreCuentaAbono] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[C_MatrizRecaudadoIngresosSinDevengado]    Script Date: 22/03/2018 12:05:32 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[C_MatrizRecaudadoIngresosSinDevengado](
	[CRI] [varchar](10) NULL,
	[NombreCRI] [varchar](max) NULL,
	[MedioRecaudacion] [varchar](max) NULL,
	[CuentaCargo] [varchar](80) NULL,
	[NombreCuentaCargo] [varchar](max) NULL,
	[CuentaAbono] [varchar](80) NULL,
	[NombreCuentaAbono] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'111', N'Dietas', N'1', N' ', N'5.1.1.1', N'Remuneraciones al Personal de carácter Permanente ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'112', N'Haberes', N'1', N' ', N'5.1.1.1', N'Remuneraciones al Personal de carácter Permanente ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'113', N'Sueldos base al personal permanente', N'1', N' ', N'5.1.1.1', N'Remuneraciones al Personal de carácter Permanente ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'114', N'Remuneraciones por adscripción laboral en el extranjero', N'1', N' ', N'5.1.1.1', N'Remuneraciones al Personal de carácter Permanente ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'121', N'Honorarios asimilables a salarios', N'1', N' ', N'5.1.1.2', N'Remuneraciones al Personal de carácter Transitorio ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'122', N'Sueldos base al personal eventual', N'1', N' ', N'5.1.1.2', N'Remuneraciones al Personal de carácter Transitorio ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'123', N'Retribuciones por servicios de carácter social', N'1', N' ', N'5.1.1.2', N'Remuneraciones al Personal de carácter Transitorio ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'124', N'Retribución a los representantes de los trabajadores y de los patrones en la Junta de Conciliación y Arbitraje', N'1', N' ', N'5.1.1.2', N'Remuneraciones al Personal de carácter Transitorio ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'131', N'Primas por años de servicios efectivos prestados', N'1', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'132', N'Primas de vacaciones, dominical y gratificación de fin de año', N'1', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'133', N'Horas extraordinarias', N'1', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'134', N'Compensaciones', N'1', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'135', N'Sobrehaberes', N'1', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'136', N'Asignaciones de técnico, de mando, por comisión, de vuelo y de técnico especial', N'1', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'137', N'Honorarios especiales', N'1', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'138', N'Participaciones por vigilancia en el cumplimiento de las leyes y custodia de valores', N'1', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'141', N'Aportaciones de seguridad social', N'1', N' ', N'5.1.1.4', N'Seguridad Social ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'142', N'Aportaciones a fondos de vivienda', N'1', N' ', N'5.1.1.4', N'Seguridad Social ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'143', N'Aportaciones al sistema para el retiro', N'1', N' ', N'5.1.1.4', N'Seguridad Social ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'144', N'Aportaciones para seguros', N'1', N' ', N'5.1.1.4', N'Seguridad Social ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'151', N'Cuotas para el fondo de ahorro y fondo de trabajo', N'1', N' ', N'5.1.1.5', N'Otras prestaciones sociales y económicas ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'152', N'Indemnizaciones', N'1', N' ', N'5.1.1.5', N'Otras prestaciones sociales y económicas ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'153', N'Prestaciones y haberes de retiro', N'1', N' ', N'5.1.1.5', N'Otras prestaciones sociales y económicas ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'154', N'Prestaciones contractuales', N'1', N' ', N'5.1.1.5', N'Otras prestaciones sociales y económicas ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'155', N'Apoyos a la capacitación de los servidores públicos', N'1', N' ', N'5.1.1.5', N'Otras prestaciones sociales y económicas ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'159', N'Otras prestaciones sociales y económicas', N'1', N' ', N'5.1.1.5', N'Otras prestaciones sociales y económicas ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'171', N'Estímulos', N'1', N' ', N'5.1.1.6', N'Pago de estímulos a servidores públicos ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'172', N'Recompensas', N'1', N' ', N'5.1.1.6', N'Pago de estímulos a servidores públicos ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'211', N'Materiales, útiles y equipos menores de oficina', N'1', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'212', N'Materiales y útiles de impresión y reproducción', N'1', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'213', N'Material estadístico y geográfico', N'1', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'214', N'Materiales, útiles y equipos menores de tecnologías de la información y comunicaciones', N'1', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'215', N'Material impreso e información digital', N'1', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'216', N'Material de limpieza', N'1', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'217', N'Materiales y útiles de enseñanza', N'1', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'218', N'Materiales para el registro e identificación de bienes y personas', N'1', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'221', N'Productos alimenticios para personas', N'1', N' ', N'5.1.2.2', N'Alimentos y Utensilios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'222', N'Productos alimenticios para animales', N'1', N' ', N'5.1.2.2', N'Alimentos y Utensilios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'223', N'Utensilios para el servicio de alimentación', N'1', N' ', N'5.1.2.2', N'Alimentos y Utensilios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'231', N'Productos alimenticios, agropecuarios y forestales adquiridos como materia prima', N'1', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'232', N'Insumos textiles adquiridos como materia prima', N'1', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'233', N'Productos de papel, cartón e impresos adquiridos como materia prima', N'1', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'234', N'Combustibles, lubricantes, aditivos, carbón y sus derivados adquiridos como materia prima', N'1', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'235', N'Productos químicos, farmacéuticos y de laboratorio adquiridos como materia prima', N'1', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'236', N'Productos metálicos y a base de minerales no metálicos adquiridos como materia prima', N'1', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'237', N'Productos de cuero, piel, plástico y hule adquiridos como materia prima', N'1', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'238', N'Mercancías adquiridas para su Comercialización', N'1', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'239', N'Otros productos adquiridos como materia prima', N'1', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'241', N'Productos minerales no metálicos', N'1', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'242', N'Cemento y productos de concreto', N'1', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'243', N'Cal, yeso y productos de yeso', N'1', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'244', N'Madera y productos de madera', N'1', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'245', N'Vidrio y productos de vidrio', N'1', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'246', N'Material eléctrico y electrónico', N'1', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'247', N'Artículos metálicos para la construcción', N'1', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'248', N'Materiales complementarios', N'1', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'249', N'Otros materiales y artículos de construcción y reparación', N'1', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'251', N'Productos químicos básicos', N'1', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'252', N'Fertilizantes, pesticidas y otros agroquímicos', N'1', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'253', N'Medicinas y productos farmacéuticos', N'1', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'254', N'Materiales, accesorios y suministros médicos', N'1', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'255', N'Materiales, accesorios y suministros de laboratorio', N'1', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'256', N'Fibras sintéticas, hules, plásticos y derivados', N'1', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'259', N'Otros productos químicos', N'1', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'261', N'Combustibles, lubricantes y aditivos', N'1', N' ', N'5.1.2.6', N'Combustibles, Lubricantes y Aditivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'262', N'Carbón y sus derivados', N'1', N' ', N'5.1.2.6', N'Combustibles, Lubricantes y Aditivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'271', N'Vestuario y uniformes', N'1', N' ', N'5.1.2.7', N'Vestuario, Blancos, Prendas de Protección y Artículos Deportivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'272', N'Prendas de seguridad y protección personal', N'1', N' ', N'5.1.2.7', N'Vestuario, Blancos, Prendas de Protección y Artículos Deportivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'273', N'Artículos deportivos', N'1', N' ', N'5.1.2.7', N'Vestuario, Blancos, Prendas de Protección y Artículos Deportivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'274', N'Productos textiles', N'1', N' ', N'5.1.2.7', N'Vestuario, Blancos, Prendas de Protección y Artículos Deportivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'275', N'Blancos y otros productos textiles, excepto prendas de vestir', N'1', N' ', N'5.1.2.7', N'Vestuario, Blancos, Prendas de Protección y Artículos Deportivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'281', N'Sustancias y materiales explosivos', N'1', N' ', N'5.1.2.8', N'Materiales y suministros para Seguridad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'282', N'Materiales de seguridad pública', N'1', N' ', N'5.1.2.8', N'Materiales y suministros para Seguridad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'283', N'Prendas de protección para seguridad pública y nacional', N'1', N' ', N'5.1.2.8', N'Materiales y suministros para Seguridad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'291', N'Herramientas menores', N'1', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'292', N'Refacciones y accesorios menores de edificios', N'1', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'293', N'Refacciones y accesorios menores de mobiliario y equipo de administración, educacional y recreativo', N'1', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'294', N'Refacciones y accesorios menores de equipo de cómputo y tecnologías de la información', N'1', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'295', N'Refacciones y accesorios menores de equipo e instrumental médico y de laboratorio', N'1', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'296', N'Refacciones y accesorios menores de equipo de transporte', N'1', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'297', N'Refacciones y accesorios menores de equipo de defensa y seguridad', N'1', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'298', N'Refacciones y accesorios menores de maquinaria y otros equipos', N'1', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'299', N'Refacciones y accesorios menores otros bienes muebles', N'1', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'311', N'Energía eléctrica', N'1', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'312', N'Gas', N'1', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'313', N'Agua', N'1', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'314', N'Telefonía tradicional', N'1', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'315', N'Telefonía celular', N'1', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'316', N'Servicios de telecomunicaciones y satélites', N'1', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'317', N'Servicios de acceso de Internet, redes y procesamiento de información', N'1', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'318', N'Servicios postales y telegráficos', N'1', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'319', N'Servicios integrales y otros servicios', N'1', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'321', N'Arrendamiento de terrenos', N'1', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'322', N'Arrendamiento de edificios', N'1', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'323', N'Arrendamiento de mobiliario y equipo de administración, educacional y recreativo', N'1', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'324', N'Arrendamiento de equipo e instrumental médico y de laboratorio', N'1', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'325', N'Arrendamiento de equipo de transporte', N'1', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'326', N'Arrendamiento de maquinaria, otros equipos y herramientas', N'1', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'327', N'Arrendamiento de activos intangibles', N'1', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'328', N'Arrendamiento financiero', N'1', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'329', N'Otros arrendamientos', N'1', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'331', N'Servicios legales, de contabilidad, auditoría y relacionados', N'1', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'332', N'Servicios de diseño, arquitectura, ingeniería y actividades relacionadas', N'1', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'333', N'Servicios de consultoría administrativa, procesos, técnica y en tecnologías de la información', N'1', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'334', N'Servicios de capacitación ', N'1', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'335', N'Servicios de investigación científica y desarrollo', N'1', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'336', N'Servicios de apoyo administrativo, traducción, fotocopiado e impresión', N'1', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'337', N'Servicios de protección y seguridad', N'1', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'338', N'Servicios de vigilancia', N'1', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'339', N'Servicios profesionales, científicos y técnicos integrales', N'1', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'341', N'Servicios financieros y bancarios', N'1', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'342', N'Servicios de cobranza, investigación crediticia y similar', N'1', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'343', N'Servicios de recaudación, traslado y custodia de valores', N'1', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'344', N'Seguros de responsabilidad patrimonial y fianzas', N'1', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'345', N'Seguro de bienes patrimoniales', N'1', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'346', N'Almacenaje, envase y embalaje', N'1', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'347', N'Fletes y maniobras', N'1', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'348', N'Comisiones por ventas', N'1', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'349', N'Servicios financieros, bancarios y Comerciales integrales', N'1', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'351', N'Conservación y mantenimiento menor de inmuebles', N'1', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'352', N'Instalación, reparación y mantenimiento de mobiliario y equipo de administración, educacional y recreativo', N'1', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'353', N'Instalación, reparación y mantenimiento de equipo de cómputo y tecnología de la información', N'1', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'354', N'Instalación, reparación y mantenimiento de equipo e instrumental médico y de laboratorio', N'1', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'355', N'Reparación y mantenimiento de equipo de transporte', N'1', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'356', N'Reparación y mantenimiento de equipo de defensa y seguridad', N'1', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'357', N'Instalación, reparación y mantenimiento de maquinaria, otros equipos y herramienta', N'1', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'358', N'Servicios de limpieza y manejo de desechos', N'1', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'359', N'Servicios de jardinería y fumigación', N'1', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'361', N'Difusión por radio, televisión y otros medios de mensajes sobre programas y actividades gubernamentales', N'1', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'362', N'Difusión por radio, televisión y otros medios de mensajes Comerciales para promover la venta de bienes o servicios', N'1', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'363', N'Servicios de creatividad, preproducción y producción de publicidad, excepto Internet', N'1', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'364', N'Servicios de revelado de fotografías', N'1', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'365', N'Servicios de la industria fílmica, del sonido y del video', N'1', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'366', N'Servicio de creación y difusión de contenido exclusivamente a través de Internet', N'1', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'369', N'Otros servicios de información', N'1', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'371', N'Pasajes aéreos', N'1', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'372', N'Pasajes terrestres', N'1', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'373', N'Pasajes marítimos, lacustres y fluviales', N'1', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'374', N'Autotransporte', N'1', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'375', N'Viáticos en el país', N'1', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'376', N'Viáticos en el extranjero', N'1', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'377', N'Gastos de instalación y traslado de menaje', N'1', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'378', N'Servicios integrales de traslado y viáticos', N'1', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'379', N'Otros servicios de traslado y hospedaje', N'1', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'381', N'Gastos de ceremonial', N'1', N' ', N'5.1.3.8', N'Servicios Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'382', N'Gastos de orden social y cultural', N'1', N' ', N'5.1.3.8', N'Servicios Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'383', N'Congresos y convenciones', N'1', N' ', N'5.1.3.8', N'Servicios Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'384', N'Exposiciones', N'1', N' ', N'5.1.3.8', N'Servicios Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'385', N'Gastos de representación', N'1', N' ', N'5.1.3.8', N'Servicios Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'391', N'Servicios funerarios y de cementerios', N'1', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'392', N'Impuestos y derechos', N'1', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'393', N'Impuestos y derechos de importación', N'1', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'394', N'Sentencias y resoluciones judiciales', N'1', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'395', N'Penas, multas, accesorios y actualizaciones', N'1', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'396', N'Otros gastos por responsabilidades', N'1', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'397', N'Utilidades', N'', N'', N'', N'Partida adicionada DOF 02-01-2013', N'', N'')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'398', N'Impuestos sobre nóminas y otros que se deriven de una relación laboral', N'', N'', N'', N'Partida adicionada DOF 02-01-2013', N'', N'')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'399', N'Otros servicios generales', N'1', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'411', N'Asignaciones presupuestarias al Poder Ejecutivo', N'1', N' ', N'5.2.1.1', N' Asignaciones al Sector Público ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'412', N'Asignaciones presupuestarias al Poder Legislativo', N'1', N' ', N'5.2.1.1', N' Asignaciones al Sector Público ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'413', N'Asignaciones presupuestarias al Poder Judicial', N'1', N' ', N'5.2.1.1', N' Asignaciones al Sector Público ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'414', N'Asignaciones presupuestarias a Órganos Autónomos', N'1', N' ', N'5.2.1.1', N' Asignaciones al Sector Público ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'415', N'Transferencias internas otorgadas a entidades paraestatales no empresariales y no financieras', N'1', N' ', N'5.2.1.2', N'Transferencias internas al Sector Público ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'416', N'Transferencias internas otorgadas a entidades paraestatales empresariales y no financieras', N'1', N' ', N'5.2.1.2', N'Transferencias internas al Sector Público ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'417', N'Transferencias internas otorgadas a fideicomisos públicos empresariales y no financieros', N'1', N' ', N'5.2.1.2', N'Transferencias internas al Sector Público ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'418', N'Transferencias internas otorgadas a instituciones paraestatales públicas financieras', N'1', N' ', N'5.2.1.2', N'Transferencias internas al Sector Público ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'419', N'Transferencias internas otorgadas a fideicomisos públicos financieros', N'1', N' ', N'5.2.1.2', N'Transferencias internas al Sector Público ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'421', N'Transferencias otorgadas a entidades paraestatales no empresariales y no financieras', N'1', N' ', N'5.2.2.1', N'Transferencias a Entidades Paraestatales', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'422', N'Transferencias otorgadas para entidades paraestatales empresariales y no financieras', N'1', N' ', N'5.2.2.1', N'Transferencias a Entidades Paraestatales', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'423', N'Transferencias otorgadas para instituciones paraestatales públicas financieras', N'1', N' ', N'5.2.2.1', N'Transferencias a Entidades Paraestatales', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'424', N'Transferencias otorgadas a entidades federativas y municipios', N'1', N'', N'5.2.2.2', N'Transferencias a Entidades Federativas y Municipios', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'425', N'Transferencias a fideicomisos de entidades federativas y municipios', N'1', N'', N'5.2.2.2', N'Transferencias a Entidades Federativas y Municipios', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'431', N'Subsidios a la producción', N'1', N' ', N'5.2.3.1', N'Subsidios ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'432', N'Subsidios a la distribución', N'1', N' ', N'5.2.3.1', N'Subsidios ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'433', N'Subsidios a la inversión', N'1', N' ', N'5.2.3.1', N'Subsidios ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'434', N'Subsidios a la prestación de servicios públicos', N'1', N' ', N'5.2.3.1', N'Subsidios ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'435', N'Subsidios para cubrir diferenciales de tasas de interés', N'1', N' ', N'5.2.3.1', N'Subsidios ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'436', N'Subsidios a la vivienda', N'1', N' ', N'5.2.3.1', N'Subsidios ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'437', N'Subvenciones al consumo', N'1', N' ', N'5.2.3.2', N'Subvenciones ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'438', N'Subsidios a entidades federativas y municipios', N'', N'', N'', N'Partida adicionada DOF 02-01-2013', N'', N'')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'439', N'Otros Subsidios', N'', N'', N'', N'Partida adicionada DOF 02-01-2013', N'', N'')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'441', N'Ayudas sociales a personas', N'1', N' ', N'5.2.4.1', N'Ayudas Sociales a Personas', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'442', N'Becas y otras ayudas para programas de capacitación', N'1', N' ', N'5.2.4.2', N'Becas', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'443', N'Ayudas sociales a instituciones de enseñanza', N'1', N'', N'5.2.4.3', N'Ayudas Sociales a Instituciones', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'444', N'Ayudas sociales a actividades científicas o académicas', N'1', N'', N'5.2.4.3', N'Ayudas Sociales a Instituciones', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'445', N'Ayudas sociales a instituciones sin fines de lucro', N'1', N' ', N'5.2.4.3', N'Ayudas Sociales a Instituciones', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'446', N'Ayudas sociales a cooperativas', N'1', N' ', N'5.2.4.3', N'Ayudas Sociales a Instituciones', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'447', N'Ayudas sociales a entidades de interés público', N'1', N' ', N'5.2.4.3', N'Ayudas Sociales a Instituciones', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'448', N'Ayudas por desastres naturales y otros siniestros', N'1', N' ', N'5.2.4.4', N'Ayudas Sociales por desastres naturales y otros siniestros', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'451', N'Pensiones', N'4', N'', N'5.2.5.1', N'Pensiones ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'452', N'Jubilaciones', N'4', N' ', N'5.2.5.2', N'Jubilaciones ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'459', N'Otras Pensiones y jubilaciones', N'4', N'', N'5.2.5.9', N'Otras Pensiones y Jubilaciones', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'461', N'Transferencias a fideicomisos del Poder Ejecutivo', N'1', N' ', N'5.2.6.1', N'Transferencias a Fideicomisos, Mandatos y Contratos Análogos al Gobierno ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'462', N'Transferencias a fideicomisos del Poder Legislativo', N'1', N' ', N'5.2.6.1', N'Transferencias a Fideicomisos, Mandatos y Contratos Análogos al Gobierno ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'463', N'Transferencias a fideicomisos del Poder Judicial', N'1', N' ', N'5.2.6.1', N'Transferencias a Fideicomisos, Mandatos y Contratos Análogos al Gobierno ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'464', N'Transferencias a fideicomisos públicos de entidades paraestatales no empresariales y no financieras', N'1', N' ', N'5.2.6.2', N'Transferencias a Fideicomisos, Mandatos y Contratos Análogos a Entidades Paraestatales ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'465', N'Transferencias a fideicomisos públicos de entidades paraestatales empresariales y no financieras', N'1', N' ', N'5.2.6.2', N'Transferencias a Fideicomisos, Mandatos y Contratos Análogos a Entidades Paraestatales ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'466', N'Transferencias a fideicomisos de instituciones públicas financieras', N'1', N' ', N'5.2.6.2', N'Transferencias a Fideicomisos, Mandatos y Contratos Análogos a Entidades Paraestatales ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'469', N'Otras transferencias a fideicomisos', N'1', N' ', N'5.2.6.1', N'Transferencias a Fideicomisos, Mandatos y Contratos Análogos al Gobierno ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'469', N'Otras transferencias a fideicomisos', N'1', N' ', N'5.2.6.2', N'Transferencias a Fideicomisos, Mandatos y Contratos Análogos a Entidades Paraestatales ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'471', N'Transferencias por obligación de Ley', N'4', N'', N'5.2.7.1', N'Transferencias por Obligación de Ley', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'481', N'Donativos a instituciones sin fines de lucro', N'1', N'', N'5.2.8.1', N'Donativos a Instituciones sin Fines de Lucro', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'482', N'Donativos a entidades federativas', N'1', N'', N'5.2.8.2', N'Donativos a Entidades Federativas y Municipios', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'483', N'Donativos a fideicomiso privados', N'1', N'', N'5.2.8.3', N'Donativos a Fideicomiso, Mandatos y Contratos Análogos Privados', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'484', N'Donativos a fideicomiso estatales', N'1', N'', N'5.2.8.4', N'Donativos a Fideicomiso, Mandatos y Contratos Análogos Estatales', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'485', N'Donativos Internacionales', N'1', N'', N'5.2.8.5', N'Donativos Internacionales', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'491', N'Transferencias para gobiernos extranjeros', N'1', N'', N'5.2.9.1', N'Transferencias al Exterior a Gobiernos Extranjeros y Organismos Internacionales', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'492', N'Transferencias para organismos internacionales', N'1', N'', N'5.2.9.1', N'Transferencias al Exterior a Gobiernos Extranjeros y Organismos Internacionales', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'493', N'Transferencias para el sector privado externo', N'1', N'', N'5.2.9.2', N'Transferencias al Sector Privado Externo', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'511', N'Muebles de oficina y estantería', N'2', N' ', N'1.2.4.1.1', N'Muebles de oficina y estantería ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'512', N'Muebles, excepto de oficina y estantería', N'2', N' ', N'1.2.4.1.2', N'Muebles, excepto de oficina y estantería ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'513', N'Bienes artísticos, culturales y científicos', N'2', N' ', N'1.2.4.7.1', N'Bienes artísticos, culturales y científicos', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'514', N'Objetos de valor', N'2', N' ', N'1.2.4.7.2', N'Objetos de valor', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'515', N'Equipo de cómputo y de tecnologías de la información', N'2', N' ', N'1.2.4.1.3', N'Equipo de cómputo y de tecnologías de la información', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'519', N'Otros mobiliarios y equipos de administración', N'2', N' ', N'1.2.4.1.9', N'Otros mobiliarios y equipos de administración', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'521', N'Equipos y aparatos audiovisuales', N'2', N' ', N'1.2.4.2.1', N'Equipos y aparatos audiovisuales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'522', N'Aparatos deportivos', N'2', N' ', N'1.2.4.2.2', N'Aparatos deportivos', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'523', N'Cámaras Fotográficas y de video', N'2', N' ', N'1.2.4.2.3', N'Cámaras Fotográficas y de video ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'529', N'Otro mobiliario y equipo educacional y recreativo', N'2', N' ', N'1.2.4.2.9', N'Otro mobiliario y equipo educacional y recreativo ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'531', N'Equipo médico y de laboratorio', N'2', N' ', N'1.2.4.3.1', N'Equipo médico y de laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'532', N'Instrumental médico y de laboratorio', N'2', N' ', N'1.2.4.3.2', N'Instrumental médico y de laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'541', N'Vehículos y equipo terrestre', N'2', N' ', N'1.2.4.4.1', N'Automóviles y Equipo Terrestre', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'542', N'Carrocerías y remolques', N'2', N' ', N'1.2.4.4.2', N'Carrocerías y remolques ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'543', N'Equipo aeroespacial', N'2', N' ', N'1.2.4.4.3', N'Equipo aeroespacial ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'544', N'Equipo ferroviario', N'2', N' ', N'1.2.4.4.4', N'Equipo ferroviario ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'545', N'Embarcaciones', N'2', N' ', N'1.2.4.4.5', N'Embarcaciones ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'549', N'Otros equipos de transporte', N'2', N' ', N'1.2.4.4.9', N'Otros equipos de transporte ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'551', N'Equipo de defensa y seguridad', N'2', N' ', N'1.2.4.5', N'Equipo de defensa y Seguridad', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'561', N'Maquinaria y equipo agropecuario', N'2', N' ', N'1.2.4.6.1', N'Maquinaria y equipo agropecuario ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'562', N'Maquinaria y equipo industrial', N'2', N' ', N'1.2.4.6.2', N'Maquinaria y equipo industrial ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'563', N'Maquinaria y equipo de construcción', N'2', N' ', N'1.2.4.6.3', N'Maquinaria y equipo de construcción ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'564', N'Sistemas de aire acondicionado, calefacción y de refrigeración industrial y Comercial', N'2', N' ', N'1.2.4.6.4', N'Sistemas de aire acondicionado, calefacción y de refrigeración industrial y Comercial ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'565', N'Equipo de comunicación y telecomunicación', N'2', N' ', N'1.2.4.6.5', N'Equipo de Comunicación y Telecomunicación', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'566', N'Equipos de Generación Eléctrica, Aparatos y Accesorios Eléctricos', N'2', N' ', N'1.2.4.6.6', N'Equipos de Generación Eléctrica, Aparatos y Accesorios Eléctricos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'567', N'Herramientas y máquinas-herramienta', N'2', N' ', N'1.2.4.6.7', N'Herramientas y Máquinas-Herramienta ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'569', N'Otros equipos', N'2', N' ', N'1.2.4.6.9', N'Otros Equipos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'571', N'Bovinos', N'2', N' ', N'1.2.4.8.1', N'Bovinos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'572', N'Porcinos', N'2', N' ', N'1.2.4.8.2', N'Porcinos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'573', N'Aves', N'2', N' ', N'1.2.4.8.3', N'Aves ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'574', N'Ovinos y caprinos', N'2', N' ', N'1.2.4.8.4', N'Ovinos y caprinos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'575', N'Peces y Acuicultura', N'2', N' ', N'1.2.4.8.5', N'Peces y Acuicultura ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'576', N'Equinos', N'2', N' ', N'1.2.4.8.6', N'Equinos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'577', N'Especies menores y de zoológico', N'2', N' ', N'1.2.4.8.7', N'Especies menores y de zoológico ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'578', N'Árboles y plantas', N'2', N' ', N'1.2.4.8.8', N'Árboles y Plantas ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'579', N'Otros activos biológicos', N'2', N' ', N'1.2.4.8.9', N'Otros activos biológicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'581', N'Terrenos', N'2', N' ', N'1.2.3.1', N'Terrenos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'582', N'Viviendas', N'2', N' ', N'1.2.3.2', N'Viviendas', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'583', N'Edificios no residenciales', N'2', N' ', N'1.2.3.3', N'Edificios no residenciales', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'589', N'Otros bienes inmuebles', N'2', N' ', N'1.2.3.9', N'Otros bienes inmuebles', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'591', N'Software', N'2', N' ', N'1.2.5.1', N'Software ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'592', N'Patentes', N'2', N' ', N'1.2.5.2.1', N'Patentes ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'593', N'Marcas', N'2', N' ', N'1.2.5.2.2', N'Marcas ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'594', N'Derechos', N'2', N' ', N'1.2.5.2.3', N'Derechos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'595', N'Concesiones', N'2', N' ', N'1.2.5.3.1', N'Concesiones ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'596', N'Franquicias', N'2', N' ', N'1.2.5.3.2', N'Franquicias ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'597', N'Licencias informáticas e intelectuales', N'2', N' ', N'1.2.5.4.1', N'Licencias Informáticas e Intelectuales', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'598', N'Licencias industriales, Comerciales y otras', N'2', N' ', N'1.2.5.4.2', N'Licencias Industriales, Comerciales y otras', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'599', N'Otros activos intangibles', N'2', N' ', N'1.2.5.9', N'Otros Activos Intangibles ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'611', N'Edificación habitacional', N'2', N' ', N'1.2.3.5.1', N'Edificación habitacional en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'612', N'Edificación no habitacional', N'2', N' ', N'1.2.3.5.2', N'Edificación no habitacional en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'613', N'Construcción de obras para el abastecimiento de agua, petróleo, gas, electricidad y telecomunicaciones', N'2', N' ', N'1.2.3.5.3', N'Construcción de Obras para el Abastecimiento de Agua, Petróleo, Gas, Electricidad y Telecomunicaciones en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'614', N'División de terrenos y construcción de obras de urbanización', N'2', N' ', N'1.2.3.5.4', N'División de Terrenos y Construcción de Obras de Urbanización en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'615', N'Construcción de vías de comunicación', N'2', N' ', N'1.2.3.5.5', N'Construcción de Vías de Comunicación en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'616', N'Otras construcciones de ingeniería civil u obra pesada', N'2', N' ', N'1.2.3.5.6', N'Otras Construcciones de Ingeniería Civil u Obra Pesada en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'617', N'Instalaciones y equipamiento en construcciones', N'2', N' ', N'1.2.3.5.7', N'Instalaciones y Equipamiento en Construcciones en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'619', N'Trabajos de acabados en edificaciones y otros trabajos especializados', N'2', N' ', N'1.2.3.5.9', N'Trabajos de Acabados en Edificaciones y Otros Trabajos Especializados en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'621', N'Edificación habitacional', N'2', N' ', N'1.2.3.6.1', N'Edificación Habitacional en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'622', N'Edificación no habitacional', N'2', N' ', N'1.2.3.6.2', N'Edificación no Habitacional en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'623', N'Construcción de obras para el abastecimiento de agua, petróleo, gas, electricidad y telecomunicaciones', N'2', N' ', N'1.2.3.6.3', N'Construcción de Obras para el Abastecimiento de Agua, Petróleo, Gas, Electricidad y Telecomunicaciones en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'624', N'División de terrenos y construcción de obras de urbanización', N'2', N' ', N'1.2.3.6.4', N'División de Terrenos y Construcción de Obras de Urbanización en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'625', N'Construcción de vías de comunicación', N'2', N' ', N'1.2.3.6.5', N'Construcción de Vías de Comunicación en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'626', N'Otras construcciones de ingeniería civil u obra pesada', N'2', N' ', N'1.2.3.6.6', N'Otras Construcciones de Ingeniería Civil u Obra Pesada en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'627', N'Instalaciones y equipamiento en construcciones', N'2', N' ', N'1.2.3.6.7', N'Instalaciones y Equipamiento en Construcciones en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'629', N'Trabajos de acabados en edificaciones y otros trabajos especializados', N'2', N' ', N'1.2.3.6.9', N'Trabajos de Acabados en Edificaciones y Otros Trabajos Especializados en Proceso', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'631', N'Estudios, formulación y evaluación de proyectos productivos no incluidos en conceptos anteriores de este capítulo', N'2', N'S/cartera de Inversión', N'1.2.7.1', N'Estudios, formulación y evaluación de proyectos ', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'631', N'Estudios, formulación y evaluación de proyectos productivos no incluidos en conceptos anteriores de este capítulo', N'2', N'S/cartera de Inversión', N'1.2.7.1', N'Estudios, formulación y evaluación de proyectos ', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'721', N'Acciones y participaciones de capital en entidades paraestatales no empresariales y no financieras con fines de política económica', N'2', N' ', N'1.2.1.4.1', N'Participaciones y aportaciones de Capital a LP en el Sector Público', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'722', N'Acciones y participaciones de capital en entidades paraestatales empresariales y no financieras con fines de política económica', N'2', N' ', N'1.2.1.4.1', N'Participaciones y aportaciones de Capital a LP en el Sector Público', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'723', N'Acciones y participaciones de capital en instituciones paraestatales públicas financieras con fines de política económica', N'2', N' ', N'1.2.1.4.1', N'Participaciones y aportaciones de Capital a LP en el Sector Público', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'724', N'Acciones y participaciones de capital en el sector privado con fines de política económica', N'2', N' ', N'1.2.1.4.1', N'Participaciones y aportaciones de Capital a LP en el Sector Público', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'725', N'Acciones y participaciones de capital en organismos internacionales con fines de política económica', N'2', N' ', N'1.2.1.4.3', N'Participaciones y aportaciones de Capital a LP en el Sector Externo', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'726', N'Acciones y participaciones de capital en el sector externo con fines de política económica', N'2', N' ', N'1.2.1.4.3', N'Participaciones y aportaciones de Capital a LP en el Sector Externo', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'727', N'Acciones y participaciones de capital en el sector público con fines de gestión de liquidez', N'2', N' ', N'1.2.1.4.1', N'Participaciones y aportaciones de Capital a LP en el Sector Público', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'728', N'Acciones y participaciones de capital en el sector privado con fines de gestión de liquidez', N'2', N' ', N'1.2.1.4.2', N'Participaciones y aportaciones de Capital a LP en el Sector Privado', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'729', N'Acciones y participaciones de capital en el sector externo con fines de gestión de liquidez', N'2', N' ', N'1.2.1.4.3', N'Participaciones y aportaciones de Capital a LP en el Sector Externo', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'731', N'Bonos', N'2', N' ', N'1.2.1.2.1', N' Bonos a LP', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'732', N'Valores representativos de deuda adquiridos con fines de política económica', N'2', N' ', N'1.2.1.2.2', N'Valores Representativos de Deuda a LP ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'733', N'Valores representativos de la deuda adquiridos con fines de gestión de liquidez', N'2', N' ', N'1.2.1.2.2', N'Valores Representativos de Deuda a LP', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'734', N'Obligaciones negociables adquiridas con fines de política económica', N'2', N' ', N'1.2.1.2.3', N'Obligaciones Negociables a LP ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'735', N'Obligaciones negociables adquiridas con fines de gestión de liquidez', N'2', N' ', N'1.2.1.2.3', N'Obligaciones Negociables a LP ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'739', N'Otros valores', N'2', N' ', N'1.2.1.2.9', N'Otros Valores a LP ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'741', N'Concesión de préstamos a entidades paraestatales no empresariales y no financieras con fines de política económica', N'2', N' ', N'1.2.2.4.1', N'Préstamos Otorgados a LP al Sector Público ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'742', N'Concesión de préstamos a entidades paraestatales empresariales y no financieras con fines de política económica', N'2', N' ', N'1.2.2.4.1', N'Préstamos Otorgados a LP al Sector Público ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'743', N'Concesión de préstamos a instituciones paraestatales públicas financieras con fines de política económica', N'2', N' ', N'1.2.2.4.1', N'Préstamos Otorgados a LP al Sector Público ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'744', N'Concesión de préstamos a entidades federativas y municipios con fines de política económica', N'2', N' ', N'1.2.2.4.1', N'Préstamos Otorgados a LP al Sector Público ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'745', N'Concesión de préstamos al sector privado con fines de política económica', N'2', N' ', N'1.2.2.4.2', N'Préstamos Otorgados a LP al Sector Privado ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'746', N'Concesión de préstamos al sector externo con fines de política económica', N'2', N' ', N'1.2.2.4.3', N'Préstamos Otorgados a LP al Sector Externo ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'747', N'Concesión de préstamos al sector público con fines de gestión de liquidez', N'2', N' ', N'1.2.2.4.1', N'Préstamos Otorgados a LP al Sector Público ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'748', N'Concesión de préstamos al sector privado con fines de gestión de liquidez', N'2', N' ', N'1.2.2.4.2', N'Préstamos Otorgados a LP al Sector Privado ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'749', N'Concesión de préstamos al sector externo con fines de gestión de liquidez', N'2', N' ', N'1.2.2.4.3', N'Préstamos Otorgados a LP al Sector Externo ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'751', N'Inversiones en fideicomisos del Poder Ejecutivo', N'2', N' ', N'1.2.1.3.1', N'Fideicomisos, Mandatos y Contratos Análogos del Poder Ejecutivo', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'752', N'Inversiones en fideicomisos del Poder Legislativo', N'2', N' ', N'1.2.1.3.2', N'Fideicomisos, Mandatos y Contratos Análogos del Poder Legislativo', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'753', N'Inversiones en fideicomisos del Poder Judicial', N'2', N' ', N'1.2.1.3.3', N'Fideicomisos, Mandatos y Contratos Análogos del Poder Judicial', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'754', N'Inversiones en fideicomisos públicos no empresariales y no financieros', N'2', N' ', N'1.2.1.3.4', N'Fideicomisos, Mandatos y Contratos Análogos públicos no empresariales y no financieros ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'755', N'Inversiones en fideicomisos públicos empresariales y no financieros', N'2', N' ', N'1.2.1.3.5', N'Fideicomisos, Mandatos y Contratos Análogos públicos empresariales y no financieros ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'756', N'Inversiones en fideicomisos públicos financieros', N'2', N' ', N'1.2.1.3.6', N'Fideicomisos, Mandatos y Contratos Análogos públicos financieros ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'757', N'Inversiones en fideicomisos de entidades federativas', N'2', N' ', N'1.2.1.3.7', N'Fideicomisos, Mandatos y Contratos Análogos de Entidades Federativas ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'758', N'Inversiones en fideicomisos de municipios', N'2', N' ', N'1.2.1.3.8', N'Fideicomisos, Mandatos y Contratos Análogos de Municipios ', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'759', N'Otras inversiones en fideicomisos', N'2', N' ', N'1.2.1.3.9', N'Otros Fideicomisos, Mandatos y Contratos Análogos', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'761', N'Depósitos a LP en Moneda Nacional', N'2', N' ', N'1.2.1.1.1', N'Depósitos a LP en Moneda Nacional', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'762', N'Depósitos a LP en Moneda Extranjera', N'2', N' ', N'1.2.1.1.2', N'Depósitos a LP en Moneda Extranjera ', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'811', N'Fondo general de participaciones', N'5', N' ', N'5.3.1.1', N'Participaciones de la Federación a Entidades Federativas y Municipios ', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'812', N'Fondo de fomento municipal', N'5', N' ', N'5.3.1.1', N'Participaciones de la Federación a Entidades Federativas y Municipios ', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'813', N'Participaciones de las entidades federativas a los municipios', N'5', N' ', N'5.3.1.2', N'Participaciones de las Entidades Federativas a los Municipios ', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'814', N'Otros conceptos participables de la Federación a entidades federativas', N'5', N' ', N'5.3.1.1', N'Participaciones de la Federación a Entidades Federativas y Municipios ', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'815', N'Otros conceptos participables de la Federación a municipios', N'5', N' ', N'5.3.1.1', N'Participaciones de la Federación a Entidades Federativas y Municipios ', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'816', N'Convenios de colaboración administrativa', N'5', N' ', N'5.3.1.1', N'Participaciones de la Federación a Entidades Federativas y Municipios ', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'921', N'Intereses de la deuda interna con instituciones de crédito', N'1', N' ', N'5.4.1.1', N'Intereses de la Deuda Pública Interna ', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'922', N'Intereses derivados de la colocación de títulos y valores', N'1', N' ', N'5.4.1.1', N'Intereses de la Deuda Pública Interna ', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'923', N'Intereses por arrendamientos financieros nacionales', N'1', N' ', N'5.4.1.1', N'Intereses de la Deuda Pública Interna ', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'924', N'Intereses de la deuda externa con instituciones de crédito', N'1', N' ', N'5.4.1.2', N'Intereses de la Deuda Pública Externa ', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'925', N'Intereses de la deuda con organismos financieros Internacionales', N'1', N' ', N'5.4.1.2', N'Intereses de la Deuda Pública Externa ', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'926', N'Intereses de la deuda bilateral', N'1', N' ', N'5.4.1.2', N'Intereses de la Deuda Pública Externa ', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'927', N'Intereses derivados de la colocación de títulos y valores en el exterior', N'1', N' ', N'5.4.1.2', N'Intereses de la Deuda Pública Externa ', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'928', N'Intereses por arrendamientos financieros internacionales', N'1', N' ', N'5.4.1.2', N'Intereses de la Deuda Pública Externa ', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'931', N'Comisiones de la deuda pública interna', N'1', N' ', N'5.4.2.1', N'Comisiones de la Deuda Pública Interna ', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'932', N'Comisiones de la deuda pública externa', N'1', N' ', N'5.4.2.2', N'Comisiones de la Deuda Pública Externa ', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'941', N'Gastos de la deuda pública interna', N'1', N' ', N'5.4.3.1', N'Gastos de la Deuda Pública Interna ', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'942', N'Gastos de la deuda pública externa', N'1', N' ', N'5.4.3.2', N'Gastos de la Deuda Pública Externa ', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'951', N'Costos por cobertura de la deuda pública interna', N'1', N' ', N'5.4.4.1', N'Costo por Coberturas de la Deuda Pública Interna', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'952', N'Costos por cobertura de la deuda pública externa', N'1', N' ', N'5.4.4.2', N'Costo por Coberturas de la deuda Pública Externa', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'961', N'Apoyos a intermediarios financieros', N'1', N' ', N'5.4.5.1', N'Apoyos Financieros a Intermediarios ', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'962', N'Apoyos a ahorradores y deudores del Sistema Financiero Nacional', N'1', N' ', N'5.4.5.2', N'Apoyo Financieros a Ahorradores y Deudores del Sistema Financiero Nacional', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'112', N'Haberes', N'2', N' ', N'5.1.1.1', N'Remuneraciones al Personal de carácter Permanente ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'113', N'Sueldos base al personal permanente', N'2', N' ', N'5.1.1.1', N'Remuneraciones al Personal de carácter Permanente ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'114', N'Remuneraciones por adscripción laboral en el extranjero', N'2', N' ', N'5.1.1.1', N'Remuneraciones al Personal de carácter Permanente ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'121', N'Honorarios asimilables a salarios', N'2', N' ', N'5.1.1.2', N'Remuneraciones al Personal de carácter Transitorio ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'122', N'Sueldos base al personal eventual', N'2', N' ', N'5.1.1.2', N'Remuneraciones al Personal de carácter Transitorio ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'123', N'Retribuciones por servicios de carácter social', N'2', N' ', N'5.1.1.2', N'Remuneraciones al Personal de carácter Transitorio ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'124', N'Retribución a los representantes de los trabajadores y de los patrones en la Junta de Conciliación y Arbitraje', N'2', N' ', N'5.1.1.2', N'Remuneraciones al Personal de carácter Transitorio ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'131', N'Primas por años de servicios efectivos prestados', N'2', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'132', N'Primas de vacaciones, dominical y gratificación de fin de año', N'2', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'133', N'Horas extraordinarias', N'2', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'134', N'Compensaciones', N'2', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'135', N'Sobrehaberes', N'2', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'136', N'Asignaciones de técnico, de mando, por comisión, de vuelo y de técnico especial', N'2', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'137', N'Honorarios especiales', N'2', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'138', N'Participaciones por vigilancia en el cumplimiento de las leyes y custodia de valores', N'2', N' ', N'5.1.1.3', N'Remuneraciones Adicionales y Especiales ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'141', N'Aportaciones de seguridad social', N'2', N' ', N'5.1.1.4', N'Seguridad Social ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'142', N'Aportaciones a fondos de vivienda', N'2', N' ', N'5.1.1.4', N'Seguridad Social ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'143', N'Aportaciones al sistema para el retiro', N'2', N' ', N'5.1.1.4', N'Seguridad Social ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'144', N'Aportaciones para seguros', N'2', N' ', N'5.1.1.4', N'Seguridad Social ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'151', N'Cuotas para el fondo de ahorro y fondo de trabajo', N'2', N' ', N'5.1.1.5', N'Otras prestaciones sociales y económicas ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'152', N'Indemnizaciones', N'2', N' ', N'5.1.1.5', N'Otras prestaciones sociales y económicas ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'153', N'Prestaciones y haberes de retiro', N'2', N' ', N'5.1.1.5', N'Otras prestaciones sociales y económicas ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'154', N'Prestaciones contractuales', N'2', N' ', N'5.1.1.5', N'Otras prestaciones sociales y económicas ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'155', N'Apoyos a la capacitación de los servidores públicos', N'2', N' ', N'5.1.1.5', N'Otras prestaciones sociales y económicas ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'159', N'Otras prestaciones sociales y económicas', N'2', N' ', N'5.1.1.5', N'Otras prestaciones sociales y económicas ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'171', N'Estímulos', N'2', N' ', N'5.1.1.6', N'Pago de estímulos a servidores públicos ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'172', N'Recompensas', N'2', N' ', N'5.1.1.6', N'Pago de estímulos a servidores públicos ', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'211', N'Materiales, útiles y equipos menores de oficina', N'2', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'212', N'Materiales y útiles de impresión y reproducción', N'2', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'213', N'Material estadístico y geográfico', N'2', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'214', N'Materiales, útiles y equipos menores de tecnologías de la información y comunicaciones', N'2', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'215', N'Material impreso e información digital', N'2', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'216', N'Material de limpieza', N'2', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'217', N'Materiales y útiles de enseñanza', N'2', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'218', N'Materiales para el registro e identificación de bienes y personas', N'2', N' ', N'5.1.2.1', N'Materiales de Administración, Emisión de documentos y Artículos Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'221', N'Productos alimenticios para personas', N'2', N' ', N'5.1.2.2', N'Alimentos y Utensilios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'222', N'Productos alimenticios para animales', N'2', N' ', N'5.1.2.2', N'Alimentos y Utensilios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'223', N'Utensilios para el servicio de alimentación', N'2', N' ', N'5.1.2.2', N'Alimentos y Utensilios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'231', N'Productos alimenticios, agropecuarios y forestales adquiridos como materia prima', N'2', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'232', N'Insumos textiles adquiridos como materia prima', N'2', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'233', N'Productos de papel, cartón e impresos adquiridos como materia prima', N'2', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'234', N'Combustibles, lubricantes, aditivos, carbón y sus derivados adquiridos como materia prima', N'2', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'235', N'Productos químicos, farmacéuticos y de laboratorio adquiridos como materia prima', N'2', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'236', N'Productos metálicos y a base de minerales no metálicos adquiridos como materia prima', N'2', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'237', N'Productos de cuero, piel, plástico y hule adquiridos como materia prima', N'2', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'238', N'Mercancías adquiridas para su Comercialización', N'2', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'239', N'Otros productos adquiridos como materia prima', N'2', N' ', N'5.1.2.3', N'Materias Primas y Materiales de Producción y Comercialización ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'241', N'Productos minerales no metálicos', N'2', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'242', N'Cemento y productos de concreto', N'2', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'243', N'Cal, yeso y productos de yeso', N'2', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'244', N'Madera y productos de madera', N'2', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'245', N'Vidrio y productos de vidrio', N'2', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'246', N'Material eléctrico y electrónico', N'2', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'247', N'Artículos metálicos para la construcción', N'2', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'248', N'Materiales complementarios', N'2', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'249', N'Otros materiales y artículos de construcción y reparación', N'2', N' ', N'5.1.2.4', N'Materiales y Artículos de Construcción y de reparación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'251', N'Productos químicos básicos', N'2', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'252', N'Fertilizantes, pesticidas y otros agroquímicos', N'2', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'253', N'Medicinas y productos farmacéuticos', N'2', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'254', N'Materiales, accesorios y suministros médicos', N'2', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'255', N'Materiales, accesorios y suministros de laboratorio', N'2', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'256', N'Fibras sintéticas, hules, plásticos y derivados', N'2', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'259', N'Otros productos químicos', N'2', N' ', N'5.1.2.5', N'Productos Químicos, Farmacéuticos y de Laboratorio ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'261', N'Combustibles, lubricantes y aditivos', N'2', N' ', N'5.1.2.6', N'Combustibles, Lubricantes y Aditivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'262', N'Carbón y sus derivados', N'2', N' ', N'5.1.2.6', N'Combustibles, Lubricantes y Aditivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'271', N'Vestuario y uniformes', N'2', N' ', N'5.1.2.7', N'Vestuario, Blancos, Prendas de Protección y Artículos Deportivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'272', N'Prendas de seguridad y protección personal', N'2', N' ', N'5.1.2.7', N'Vestuario, Blancos, Prendas de Protección y Artículos Deportivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'273', N'Artículos deportivos', N'2', N' ', N'5.1.2.7', N'Vestuario, Blancos, Prendas de Protección y Artículos Deportivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'274', N'Productos textiles', N'2', N' ', N'5.1.2.7', N'Vestuario, Blancos, Prendas de Protección y Artículos Deportivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'275', N'Blancos y otros productos textiles, excepto prendas de vestir', N'2', N' ', N'5.1.2.7', N'Vestuario, Blancos, Prendas de Protección y Artículos Deportivos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'281', N'Sustancias y materiales explosivos', N'2', N' ', N'5.1.2.8', N'Materiales y suministros para Seguridad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'282', N'Materiales de seguridad pública', N'2', N' ', N'5.1.2.8', N'Materiales y suministros para Seguridad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'283', N'Prendas de protección para seguridad pública y nacional', N'2', N' ', N'5.1.2.8', N'Materiales y suministros para Seguridad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'291', N'Herramientas menores', N'2', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'292', N'Refacciones y accesorios menores de edificios', N'2', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'293', N'Refacciones y accesorios menores de mobiliario y equipo de administración, educacional y recreativo', N'2', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'294', N'Refacciones y accesorios menores de equipo de cómputo y tecnologías de la información', N'2', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'295', N'Refacciones y accesorios menores de equipo e instrumental médico y de laboratorio', N'2', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'296', N'Refacciones y accesorios menores de equipo de transporte', N'2', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'297', N'Refacciones y accesorios menores de equipo de defensa y seguridad', N'2', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'298', N'Refacciones y accesorios menores de maquinaria y otros equipos', N'2', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'299', N'Refacciones y accesorios menores otros bienes muebles', N'2', N' ', N'5.1.2.9', N'Herramientas, Refacciones y Accesorios menores ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'311', N'Energía eléctrica', N'2', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'312', N'Gas', N'2', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'313', N'Agua', N'2', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'314', N'Telefonía tradicional', N'2', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'315', N'Telefonía celular', N'2', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'316', N'Servicios de telecomunicaciones y satélites', N'2', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'317', N'Servicios de acceso de Internet, redes y procesamiento de información', N'2', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'318', N'Servicios postales y telegráficos', N'2', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'319', N'Servicios integrales y otros servicios', N'2', N' ', N'5.1.3.1', N'Servicios Básicos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'321', N'Arrendamiento de terrenos', N'2', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'322', N'Arrendamiento de edificios', N'2', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'323', N'Arrendamiento de mobiliario y equipo de administración, educacional y recreativo', N'2', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'324', N'Arrendamiento de equipo e instrumental médico y de laboratorio', N'2', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'325', N'Arrendamiento de equipo de transporte', N'2', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'326', N'Arrendamiento de maquinaria, otros equipos y herramientas', N'2', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'327', N'Arrendamiento de activos intangibles', N'2', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'329', N'Otros arrendamientos', N'2', N' ', N'5.1.3.2', N'Servicios de Arrendamiento ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'331', N'Servicios legales, de contabilidad, auditoría y relacionados', N'2', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'332', N'Servicios de diseño, arquitectura, ingeniería y actividades relacionadas', N'2', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'333', N'Servicios de consultoría administrativa, procesos, técnica y en tecnologías de la información', N'2', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'334', N'Servicios de capacitación ', N'2', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'335', N'Servicios de investigación científica y desarrollo', N'2', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'336', N'Servicios de apoyo administrativo, traducción, fotocopiado e impresión', N'2', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'337', N'Servicios de protección y seguridad', N'2', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'338', N'Servicios de vigilancia', N'2', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'339', N'Servicios profesionales, científicos y técnicos integrales', N'2', N' ', N'5.1.3.3', N'Servicios Profesionales, Científicos y Técnicos y Otros Servicios ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'341', N'Servicios financieros y bancarios', N'2', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'342', N'Servicios de cobranza, investigación crediticia y similar', N'2', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'343', N'Servicios de recaudación, traslado y custodia de valores', N'2', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'344', N'Seguros de responsabilidad patrimonial y fianzas', N'2', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'345', N'Seguro de bienes patrimoniales', N'2', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'346', N'Almacenaje, envase y embalaje', N'2', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'347', N'Fletes y maniobras', N'2', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'348', N'Comisiones por ventas', N'2', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'349', N'Servicios financieros, bancarios y Comerciales integrales', N'2', N' ', N'5.1.3.4', N'Servicios Financieros, Bancarios y Comerciales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'351', N'Conservación y mantenimiento menor de inmuebles', N'2', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'352', N'Instalación, reparación y mantenimiento de mobiliario y equipo de administración, educacional y recreativo', N'2', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'353', N'Instalación, reparación y mantenimiento de equipo de cómputo y tecnología de la información', N'2', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'354', N'Instalación, reparación y mantenimiento de equipo e instrumental médico y de laboratorio', N'2', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'355', N'Reparación y mantenimiento de equipo de transporte', N'2', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'356', N'Reparación y mantenimiento de equipo de defensa y seguridad', N'2', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'357', N'Instalación, reparación y mantenimiento de maquinaria, otros equipos y herramienta', N'2', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'358', N'Servicios de limpieza y manejo de desechos', N'2', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'359', N'Servicios de jardinería y fumigación', N'2', N' ', N'5.1.3.5', N'Servicios de Instalación, Reparación, Mantenimiento y Conservación ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'361', N'Difusión por radio, televisión y otros medios de mensajes sobre programas y actividades gubernamentales', N'2', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'362', N'Difusión por radio, televisión y otros medios de mensajes Comerciales para promover la venta de bienes o servicios', N'2', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'363', N'Servicios de creatividad, preproducción y producción de publicidad, excepto Internet', N'2', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'364', N'Servicios de revelado de fotografías', N'2', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'365', N'Servicios de la industria fílmica, del sonido y del video', N'2', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'366', N'Servicio de creación y difusión de contenido exclusivamente a través de Internet', N'2', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'369', N'Otros servicios de información', N'2', N' ', N'5.1.3.6', N'Servicios de Comunicación Social y Publicidad ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'371', N'Pasajes aéreos', N'2', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'372', N'Pasajes terrestres', N'2', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'373', N'Pasajes marítimos, lacustres y fluviales', N'2', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'374', N'Autotransporte', N'2', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'375', N'Viáticos en el país', N'2', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'376', N'Viáticos en el extranjero', N'2', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'377', N'Gastos de instalación y traslado de menaje', N'2', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'378', N'Servicios integrales de traslado y viáticos', N'2', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'379', N'Otros servicios de traslado y hospedaje', N'2', N' ', N'5.1.3.7', N'Servicios de Traslado y Viáticos ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'381', N'Gastos de ceremonial', N'2', N' ', N'5.1.3.8', N'Servicios Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'382', N'Gastos de orden social y cultural', N'2', N' ', N'5.1.3.8', N'Servicios Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'383', N'Congresos y convenciones', N'2', N' ', N'5.1.3.8', N'Servicios Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'384', N'Exposiciones', N'2', N' ', N'5.1.3.8', N'Servicios Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'385', N'Gastos de representación', N'2', N' ', N'5.1.3.8', N'Servicios Oficiales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'391', N'Servicios funerarios y de cementerios', N'2', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'392', N'Impuestos y derechos', N'2', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'393', N'Impuestos y derechos de importación', N'2', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'394', N'Sentencias y resoluciones judiciales', N'2', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'395', N'Penas, multas, accesorios y actualizaciones', N'2', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'396', N'Otros gastos por responsabilidades', N'2', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizDevengadoGastos] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'399', N'Otros servicios generales', N'2', N' ', N'5.1.3.9', N'Otros Servicios Generales ', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.1', N'Impuestos Sobre los Ingresos')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.1', N'Impuestos Sobre los Ingresos')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.1', N'Impuestos Sobre los Ingresos')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.1', N'Impuestos Sobre los Ingresos')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.2', N'Impuestos Sobre el Patrimonio')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.2', N'Impuestos Sobre el Patrimonio')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.2', N'Impuestos Sobre el Patrimonio')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.2', N'Impuestos Sobre el Patrimonio')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.3', N'Impuestos Sobre la Producción, el Consumo y las Transacciones')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.3', N'Impuestos Sobre la Producción, el Consumo y las Transacciones')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.3', N'Impuestos Sobre la Producción, el Consumo y las Transacciones')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.3', N'Impuestos Sobre la Producción, el Consumo y las Transacciones')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.4', N'Impuestos al Comercio Exterior ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.4', N'Impuestos al Comercio Exterior ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.4', N'Impuestos al Comercio Exterior ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.4', N'Impuestos al Comercio Exterior ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.5', N'Impuestos sobre Nóminas y Asimilables ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.5', N'Impuestos sobre Nóminas y Asimilables ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.5', N'Impuestos sobre Nóminas y Asimilables ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.5', N'Impuestos sobre Nóminas y Asimilables ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.6', N'Impuestos Ecológicos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.6', N'Impuestos Ecológicos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.6', N'Impuestos Ecológicos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.6', N'Impuestos Ecológicos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.7', N'Accesorios de Impuestos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.7', N'Accesorios de Impuestos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.7', N'Accesorios de Impuestos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.7', N'Accesorios de Impuestos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.9', N'Otros Impuestos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.9', N'Otros Impuestos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.9', N'Otros Impuestos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.1.9', N'Otros Impuestos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.9.1', N'Impuestos no Comprendidos en las Fracciones de la Ley de Ingresos Causados en Ejercicios Fiscales Anteriores Pendientes de Liquidación o Pago')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.9.1', N'Impuestos no Comprendidos en las Fracciones de la Ley de Ingresos Causados en Ejercicios Fiscales Anteriores Pendientes de Liquidación o Pago')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.9.1', N'Impuestos no Comprendidos en las Fracciones de la Ley de Ingresos Causados en Ejercicios Fiscales Anteriores Pendientes de Liquidación o Pago')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.9.1', N'Impuestos no Comprendidos en las Fracciones de la Ley de Ingresos Causados en Ejercicios Fiscales Anteriores Pendientes de Liquidación o Pago')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.1', N'Aportaciones para Fondos de Vivienda ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.1', N'Aportaciones para Fondos de Vivienda ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.1', N'Aportaciones para Fondos de Vivienda ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.1', N'Aportaciones para Fondos de Vivienda ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.2', N'Cuotas para el Seguro Social ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.2', N'Cuotas para el Seguro Social ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.2', N'Cuotas para el Seguro Social ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.2', N'Cuotas para el Seguro Social ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.3', N'Cuotas de Ahorro para el Retiro ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.3', N'Cuotas de Ahorro para el Retiro ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.3', N'Cuotas de Ahorro para el Retiro ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.3', N'Cuotas de Ahorro para el Retiro ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.9', N'Otras Cuotas y Aportaciones para la Seguridad Social ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.9', N'Otras Cuotas y Aportaciones para la Seguridad Social ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.9', N'Otras Cuotas y Aportaciones para la Seguridad Social ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.9', N'Otras Cuotas y Aportaciones para la Seguridad Social ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.4', N'Accesorios de Cuotas y Aportaciones de Seguridad Social ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.4', N'Accesorios de Cuotas y Aportaciones de Seguridad Social ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.4', N'Accesorios de Cuotas y Aportaciones de Seguridad Social ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.2.4', N'Accesorios de Cuotas y Aportaciones de Seguridad Social ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'31', N'Contribuciones de Mejoras por Obras Públicas', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.3.1', N'Contribuciones de Mejoras por Obras Públicas ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'39', N'Contribuciones de Mejoras no comprendidas en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.9.2', N'Contribuciones de Mejoras, Derechos, Productos y Aprovechamientos no comprendidos en las Fracciones de la ley de Ingresos Causados en ejercicios Fiscales anteriores pendientes de liquidación o pago')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'41', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.1', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'41', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.1', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'41', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.1', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'41', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.1', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'42', N'Derechos a los hidrocarburos', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.2', N'Derechos a los hidrocarburos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'42', N'Derechos a los hidrocarburos', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.2', N'Derechos a los hidrocarburos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'42', N'Derechos a los hidrocarburos', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.2', N'Derechos a los hidrocarburos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'42', N'Derechos a los hidrocarburos', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.2', N'Derechos a los hidrocarburos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'43', N'Derechos por prestación de servicios', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.3', N'Derechos por prestación de servicios ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'43', N'Derechos por prestación de servicios', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.3', N'Derechos por prestación de servicios ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'43', N'Derechos por prestación de servicios', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.3', N'Derechos por prestación de servicios ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'43', N'Derechos por prestación de servicios', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.3', N'Derechos por prestación de servicios ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'44', N'Otros Derechos', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.9', N'Otros Derechos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'44', N'Otros Derechos', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.9', N'Otros Derechos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'44', N'Otros Derechos', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.9', N'Otros Derechos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'44', N'Otros Derechos', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.9', N'Otros Derechos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'45', N'Accesorios', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.4', N'Accesorios de Derechos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'45', N'Accesorios', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.4', N'Accesorios de Derechos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'45', N'Accesorios', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.4', N'Accesorios de Derechos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'45', N'Accesorios', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.4.4', N'Accesorios de Derechos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'49', N'Derechos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago en término', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.9.2', N'Contribuciones de Mejoras, Derechos, Productos y Aprovechamientos no comprendidos en las Fracciones de la ley de Ingresos Causados en ejercicios Fiscales anteriores pendientes de liquidación o pago')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'49', N'Derechos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Convenio', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.9.2', N'Contribuciones de Mejoras, Derechos, Productos y Aprovechamientos no comprendidos en las Fracciones de la ley de Ingresos Causados en ejercicios Fiscales anteriores pendientes de liquidación o pago')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'51', N'Productos de tipo corriente', N'Requiere apertura CRI', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.5.1', N'Productos derivados del uso y aprovechamiento de bienes no sujetos a régimen de dominio público ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'51', N'Productos de tipo corriente', N'Requiere apertura CRI', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.5.2', N'Enajenación de bienes muebles no sujetos a ser inventariados ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'51', N'Productos de tipo corriente', N'Requiere apertura CRI', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.5.9', N'Otros productos que generan ingresos corrientes ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.3.1.', N'Terrenos')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.3.2', N'Viviendas')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital ', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.3.3', N'Edificios no Residenciales')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.3.9', N'Otros bienes Inmuebles')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'49', N'Derechos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago extemporáneo', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.9.2', N'Contribuciones de Mejoras, Derechos, Productos y Aprovechamientos no comprendidos en las Fracciones de la ley de Ingresos Causados en ejercicios Fiscales anteriores pendientes de liquidación o pago')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'49', N'Derechos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Resolución judicial CP', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.9.2', N'Contribuciones de Mejoras, Derechos, Productos y Aprovechamientos no comprendidos en las Fracciones de la ley de Ingresos Causados en ejercicios Fiscales anteriores pendientes de liquidación o pago')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital ', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.4.1', N'Mobiliario y Equipo de Administración ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.4.2', N'Mobiliario y Equipo Educacional y Recreativo ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.4.3', N'Equipo e Instrumental Médico y de Laboratorio ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.4.4', N'Equipo de Transporte ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.4.5', N'Equipo de Defensa y Seguridad')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.4.6', N'Maquinaria, Otros Equipos y Herramientas ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.4.7', N'Colecciones, Obras de Arte y Objetos Valiosos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.4.8', N'Activos Biológicos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.5.1', N'Software')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.5.2', N'Patentes, Marcas y Derechos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.5.3', N'Concesiones y Franquicias ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.5.4', N'Licencias ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'1.2.5.9', N'Otros Activos Intangibles')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'59', N'Productos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.9.2', N'Contribuciones de Mejoras, Derechos, Productos y Aprovechamientos no comprendidos en las Fracciones de la ley de Ingresos Causados en ejercicios Fiscales anteriores pendientes de liquidación o pago')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'61', N'Aprovechamientos de tipo corriente', N'Requiere apertura CRI', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.6.1', N'Incentivos derivados de la Colaboración Fiscal ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'61', N'Aprovechamientos de tipo corriente', N'Requiere apertura CRI', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.6.2', N'Multas ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'61', N'Aprovechamientos de tipo corriente', N'Requiere apertura CRI', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.6.3', N'Indemnizaciones ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'61', N'Aprovechamientos de tipo corriente', N'Requiere apertura CRI', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.6.4', N'Reintegros ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'61', N'Aprovechamientos de tipo corriente', N'Requiere apertura CRI', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.6.5', N'Aprovechamientos provenientes de obras públicas ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'61', N'Aprovechamientos de tipo corriente', N'Requiere apertura CRI', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.6.6', N'Aprovechamientos por Participaciones derivadas de la aplicación de leyes ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'61', N'Aprovechamientos de tipo corriente', N'Requiere apertura CRI', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.6.7', N'Aprovechamientos por Aportaciones ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'61', N'Aprovechamientos de tipo corriente', N'Requiere apertura CRI', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.6.8', N'Aprovechamientos por Cooperaciones ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'61', N'Aprovechamientos de tipo corriente', N'Requiere apertura CRI', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.6.9', N'Otros Aprovechamientos ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'69', N'Aprovechamientos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ', N'4.1.9.2', N'Contribuciones de Mejoras, Derechos, Productos y Aprovechamientos no comprendidos en las Fracciones de la ley de Ingresos Causados en ejercicios Fiscales anteriores pendientes de liquidación o pago')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'71', N'Ingresos por ventas de bienes y servicios de organismos descentralizados', N'', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'4.1.7.3', N'Ingresos por venta de bienes y servicios de organismos descentralizados ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'72', N'Ingresos de operación de entidades paraestatales empresariales ', N'', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'4.1.7.4', N'Ingresos de operación de Entidades Paraestatales empresariales y no financieras ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'73', N'Ingresos por ventas de bienes y servicios producidos en establecimientos del Gobierno Central', N'', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'4.1.7.2', N'Ingresos por venta de bienes y servicios producidos en establecimientos del gobierno ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'82', N'Aportaciones ', N'S/Origen', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'4.2.1.2', N'Aportaciones ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'83', N'Convenios', N'S/Origen', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'4.2.1.3', N'Convenios ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'81', N'Participaciones', N'S/Origen', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'4.2.1.1', N'Participaciones ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'91', N'Transferencias Internas y Asignaciones al Sector Público', N'S/Origen', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'4.2.2.1', N'Transferencias Internas y Asignacionesal Sector Público')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'92', N'Transferencias al Resto del Sector Público', N'S/Origen', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'4.2.2.2', N'Transferencias al Resto del Sector Público ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'93', N'Subsidios y Subvenciones', N'S/Origen', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'4.2.2.3', N'Subsidios y Subvenciones ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'94', N'Ayudas sociales ', N'S/Origen', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'4.2.2.4', N'Ayudas Sociales ')
GO
INSERT [dbo].[C_MatrizIngresosDevengados] ([CRI], [NombreCRI], [Caracteristicas], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'95', N'Pensiones y Jubilaciones ', N'', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ', N'4.2.2.5', N'Pensiones y Jubilaciones ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'11', N'Impuestos sobre los ingresos', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'12', N'Impuestos sobre el patrimonio', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'13', N'Impuestos sobre la producción, el consumo y las transacciones', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'14', N'Impuestos al comercio exterior', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'15', N'Impuestos sobre Nóminas y Asimilables', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'16', N'Impuestos Ecológicos', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'17', N'Accesorios', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'18', N'Otros Impuestos', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'19', N'Impuestos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'21', N'Aportaciones para Fondos de Vivienda', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'22', N'Cuotas para el Seguro Social', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'23', N'Cuotas de Ahorro para el Retiro', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'24', N'Otras Cuotas y Aportaciones para la seguridad social', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Pago en término', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Pago extemporáneo', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Convenio', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'25', N'Accesorios', N'Resolución judicial CP', N'En especie', N'1.1.9.3', N'Bienes Derivados de Embargos, Decomisos, Aseguramientos y Dación en Pago', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'31', N'Contribuciones de Mejoras por Obras Públicas', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'31', N'Contribuciones de Mejoras por Obras Públicas', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'39', N'Contribuciones de Mejoras no comprendidas en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'39', N'Contribuciones de Mejoras no comprendidas en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'41', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'41', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'41', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'41', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'41', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'41', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'41', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'41', N'Derechos por el uso, goce, aprovechamiento o explotación de bienes de dominio público', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'42', N'Derechos a los hidrocarburos', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'42', N'Derechos a los hidrocarburos', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'42', N'Derechos a los hidrocarburos', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'42', N'Derechos a los hidrocarburos', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'42', N'Derechos a los hidrocarburos', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'42', N'Derechos a los hidrocarburos', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'42', N'Derechos a los hidrocarburos', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'42', N'Derechos a los hidrocarburos', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'43', N'Derechos por prestación de servicios', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'43', N'Derechos por prestación de servicios', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'43', N'Derechos por prestación de servicios', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'43', N'Derechos por prestación de servicios', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'43', N'Derechos por prestación de servicios', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'43', N'Derechos por prestación de servicios', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'43', N'Derechos por prestación de servicios', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'43', N'Derechos por prestación de servicios', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'44', N'Otros Derechos', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'44', N'Otros Derechos', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'44', N'Otros Derechos', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'44', N'Otros Derechos', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'44', N'Otros Derechos', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'44', N'Otros Derechos', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'44', N'Otros Derechos', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'44', N'Otros Derechos', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'45', N'Accesorios', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'45', N'Accesorios', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'45', N'Accesorios', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'45', N'Accesorios', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'45', N'Accesorios', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'45', N'Accesorios', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'45', N'Accesorios', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'45', N'Accesorios', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'49', N'Derechos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'49', N'Derechos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'49', N'Derechos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago extemporáneo', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'49', N'Derechos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago extemporáneo', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'49', N'Derechos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Convenio', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'49', N'Derechos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Convenio', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'49', N'Derechos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Resolución judicial CP', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'49', N'Derechos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Resolución judicial CP', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'51', N'Productos de tipo corriente', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'51', N'Productos de tipo corriente', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'52', N'Productos de capital', N'Requiere apertura CRI', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'59', N'Productos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago en término', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'59', N'Productos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'Pago en término', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'61', N'Aprovechamientos de tipo corriente', N'Requiere apertura CRI', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'61', N'Aprovechamientos de tipo corriente', N'Requiere apertura CRI', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'69', N'Aprovechamientos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'69', N'Aprovechamientos no comprendidos en las fracciones de la Ley de Ingresos causadas en ejercicios fiscales anteriores pendientes de liquidación o pago', N'', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.4', N'Ingresos por Recuperar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'71', N'Ingresos por ventas de bienes y servicios de organismos descentralizados', N'', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'71', N'Ingresos por ventas de bienes y servicios de organismos descentralizados', N'', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'72', N'Ingresos de operación de entidades paraestatales empresariales ', N'', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'72', N'Ingresos de operación de entidades paraestatales empresariales ', N'', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'73', N'Ingresos por ventas de bienes y servicios producidos en establecimientos del Gobierno Central', N'', N'Caja', N'1.1.1.1', N'Efectivo ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'73', N'Ingresos por ventas de bienes y servicios producidos en establecimientos del Gobierno Central', N'', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'81', N'Participaciones', N'S/Origen', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'82', N'Aportaciones ', N'S/Origen', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'83', N'Convenios', N'S/Origen', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'91', N'Transferencias Internas y Asignaciones al Sector Público', N'S/Origen', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'92', N'Transferencias al Resto del Sector Público', N'S/Origen', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'93', N'Subsidios y Subvenciones', N'S/Origen', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'94', N'Ayudas sociales ', N'S/Origen', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'95', N'Pensiones y Jubilaciones ', N'S/Origen', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizIngresosRecaudados] ([CRI], [NombreCRI], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'96', N'Transferencias a Fideicomisos, mandatos y análogos', N'S/Origen', N'Banco Moned.Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'1.1.2.2', N'Cuentas por Cobrar a Corto Plazo ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'111', N'Dietas', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'111', N'Dietas', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'112', N'Haberes', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'112', N'Haberes', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'113', N'Sueldos base al personal permanente', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'113', N'Sueldos base al personal permanente', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'114', N'Remuneraciones por adscripción laboral en el extranjero', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'114', N'Remuneraciones por adscripción laboral en el extranjero', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'121', N'Honorarios asimilables a salarios', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'121', N'Honorarios asimilables a salarios', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'122', N'Sueldos base al personal eventual', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'122', N'Sueldos base al personal eventual', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'123', N'Retribuciones por servicios de carácter social', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'123', N'Retribuciones por servicios de carácter social', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'124', N'Retribución a los representantes de los trabajadores y de los patrones en la Junta de Conciliación y Arbitraje', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'124', N'Retribución a los representantes de los trabajadores y de los patrones en la Junta de Conciliación y Arbitraje', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'131', N'Primas por años de servicios efectivos prestados', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'131', N'Primas por años de servicios efectivos prestados', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'132', N'Primas de vacaciones, dominical y gratificación de fin de año', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'132', N'Primas de vacaciones, dominical y gratificación de fin de año', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'133', N'Horas extraordinarias', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'133', N'Horas extraordinarias', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'134', N'Compensaciones', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'134', N'Compensaciones', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'135', N'Sobrehaberes', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'135', N'Sobrehaberes', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'136', N'Asignaciones de técnico, de mando, por comisión, de vuelo y de técnico especial', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'136', N'Asignaciones de técnico, de mando, por comisión, de vuelo y de técnico especial', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'137', N'Honorarios especiales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'137', N'Honorarios especiales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'138', N'Participaciones por vigilancia en el cumplimiento de las leyes y custodia de valores', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'138', N'Participaciones por vigilancia en el cumplimiento de las leyes y custodia de valores', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'141', N'Aportaciones de seguridad social', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'141', N'Aportaciones de seguridad social', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'142', N'Aportaciones a fondos de vivienda', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'142', N'Aportaciones a fondos de vivienda', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'143', N'Aportaciones al sistema para el retiro', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'143', N'Aportaciones al sistema para el retiro', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'144', N'Aportaciones para seguros', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'144', N'Aportaciones para seguros', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'151', N'Cuotas para el fondo de ahorro y fondo de trabajo', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'151', N'Cuotas para el fondo de ahorro y fondo de trabajo', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'152', N'Indemnizaciones', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'152', N'Indemnizaciones', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'153', N'Prestaciones y haberes de retiro', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'153', N'Prestaciones y haberes de retiro', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'154', N'Prestaciones contractuales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'154', N'Prestaciones contractuales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'155', N'Apoyos a la capacitación de los servidores públicos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'155', N'Apoyos a la capacitación de los servidores públicos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'159', N'Otras prestaciones sociales y económicas', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'159', N'Otras prestaciones sociales y económicas', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'171', N'Estímulos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'171', N'Estímulos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'172', N'Recompensas', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'172', N'Recompensas', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.1', N'Servicios Personales por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'211', N'Materiales, útiles y equipos menores de oficina', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'211', N'Materiales, útiles y equipos menores de oficina', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'212', N'Materiales y útiles de impresión y reproducción', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'212', N'Materiales y útiles de impresión y reproducción', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'213', N'Material estadístico y geográfico', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'213', N'Material estadístico y geográfico', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'214', N'Materiales, útiles y equipos menores de tecnologías de la información y comunicaciones', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'214', N'Materiales, útiles y equipos menores de tecnologías de la información y comunicaciones', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'215', N'Material impreso e información digital', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'215', N'Material impreso e información digital', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'216', N'Material de limpieza', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'216', N'Material de limpieza', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'217', N'Materiales y útiles de enseñanza', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'217', N'Materiales y útiles de enseñanza', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'218', N'Materiales para el registro e identificación de bienes y personas', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'218', N'Materiales para el registro e identificación de bienes y personas', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'221', N'Productos alimenticios para personas', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'221', N'Productos alimenticios para personas', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'222', N'Productos alimenticios para animales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'222', N'Productos alimenticios para animales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'223', N'Utensilios para el servicio de alimentación', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'223', N'Utensilios para el servicio de alimentación', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'231', N'Productos alimenticios, agropecuarios y forestales adquiridos como materia prima', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'231', N'Productos alimenticios, agropecuarios y forestales adquiridos como materia prima', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'232', N'Insumos textiles adquiridos como materia prima', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'232', N'Insumos textiles adquiridos como materia prima', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'233', N'Productos de papel, cartón e impresos adquiridos como materia prima', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'233', N'Productos de papel, cartón e impresos adquiridos como materia prima', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'234', N'Combustibles, lubricantes, aditivos, carbón y sus derivados adquiridos como materia prima', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'234', N'Combustibles, lubricantes, aditivos, carbón y sus derivados adquiridos como materia prima', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'235', N'Productos químicos, farmacéuticos y de laboratorio adquiridos como materia prima', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'235', N'Productos químicos, farmacéuticos y de laboratorio adquiridos como materia prima', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'236', N'Productos metálicos y a base de minerales no metálicos adquiridos como materia prima', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'236', N'Productos metálicos y a base de minerales no metálicos adquiridos como materia prima', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'237', N'Productos de cuero, piel, plástico y hule adquiridos como materia prima', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'237', N'Productos de cuero, piel, plástico y hule adquiridos como materia prima', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'238', N'Mercancías adquiridas para su Comercialización', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'238', N'Mercancías adquiridas para su Comercialización', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'239', N'Otros productos adquiridos como materia prima', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'239', N'Otros productos adquiridos como materia prima', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'241', N'Productos minerales no metálicos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'241', N'Productos minerales no metálicos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'242', N'Cemento y productos de concreto', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'242', N'Cemento y productos de concreto', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'243', N'Cal, yeso y productos de yeso', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'243', N'Cal, yeso y productos de yeso', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'244', N'Madera y productos de madera', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'244', N'Madera y productos de madera', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'245', N'Vidrio y productos de vidrio', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'245', N'Vidrio y productos de vidrio', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'246', N'Material eléctrico y electrónico', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'246', N'Material eléctrico y electrónico', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'247', N'Artículos metálicos para la construcción', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'247', N'Artículos metálicos para la construcción', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'248', N'Materiales complementarios', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'248', N'Materiales complementarios', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'249', N'Otros materiales y artículos de construcción y reparación', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'249', N'Otros materiales y artículos de construcción y reparación', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'251', N'Productos químicos básicos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'251', N'Productos químicos básicos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'252', N'Fertilizantes, pesticidas y otros agroquímicos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'252', N'Fertilizantes, pesticidas y otros agroquímicos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'253', N'Medicinas y productos farmacéuticos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'253', N'Medicinas y productos farmacéuticos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'254', N'Materiales, accesorios y suministros médicos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'254', N'Materiales, accesorios y suministros médicos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'255', N'Materiales, accesorios y suministros de laboratorio', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'255', N'Materiales, accesorios y suministros de laboratorio', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'256', N'Fibras sintéticas, hules, plásticos y derivados', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'256', N'Fibras sintéticas, hules, plásticos y derivados', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'259', N'Otros productos químicos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'259', N'Otros productos químicos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'261', N'Combustibles, lubricantes y aditivos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'261', N'Combustibles, lubricantes y aditivos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'262', N'Carbón y sus derivados', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'262', N'Carbón y sus derivados', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'271', N'Vestuario y uniformes', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'271', N'Vestuario y uniformes', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'272', N'Prendas de seguridad y protección personal', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'272', N'Prendas de seguridad y protección personal', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'273', N'Artículos deportivos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'273', N'Artículos deportivos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'274', N'Productos textiles', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'274', N'Productos textiles', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'275', N'Blancos y otros productos textiles, excepto prendas de vestir', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'275', N'Blancos y otros productos textiles, excepto prendas de vestir', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'281', N'Sustancias y materiales explosivos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'281', N'Sustancias y materiales explosivos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'282', N'Materiales de seguridad pública', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'282', N'Materiales de seguridad pública', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'283', N'Prendas de protección para seguridad pública y nacional', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'283', N'Prendas de protección para seguridad pública y nacional', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'291', N'Herramientas menores', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'291', N'Herramientas menores', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'292', N'Refacciones y accesorios menores de edificios', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'292', N'Refacciones y accesorios menores de edificios', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'293', N'Refacciones y accesorios menores de mobiliario y equipo de administración, educacional y recreativo', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'293', N'Refacciones y accesorios menores de mobiliario y equipo de administración, educacional y recreativo', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'294', N'Refacciones y accesorios menores de equipo de cómputo y tecnologías de la información', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'294', N'Refacciones y accesorios menores de equipo de cómputo y tecnologías de la información', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'295', N'Refacciones y accesorios menores de equipo e instrumental médico y de laboratorio', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'295', N'Refacciones y accesorios menores de equipo e instrumental médico y de laboratorio', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'296', N'Refacciones y accesorios menores de equipo de transporte', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'296', N'Refacciones y accesorios menores de equipo de transporte', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'297', N'Refacciones y accesorios menores de equipo de defensa y seguridad', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'297', N'Refacciones y accesorios menores de equipo de defensa y seguridad', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'298', N'Refacciones y accesorios menores de maquinaria y otros equipos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'298', N'Refacciones y accesorios menores de maquinaria y otros equipos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'299', N'Refacciones y accesorios menores otros bienes muebles', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'299', N'Refacciones y accesorios menores otros bienes muebles', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'311', N'Energía eléctrica', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'311', N'Energía eléctrica', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'312', N'Gas', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'312', N'Gas', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'313', N'Agua', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'313', N'Agua', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'314', N'Telefonía tradicional', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'314', N'Telefonía tradicional', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'315', N'Telefonía celular', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'315', N'Telefonía celular', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'316', N'Servicios de telecomunicaciones y satélites', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'316', N'Servicios de telecomunicaciones y satélites', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'317', N'Servicios de acceso de Internet, redes y procesamiento de información', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'317', N'Servicios de acceso de Internet, redes y procesamiento de información', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'318', N'Servicios postales y telegráficos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'318', N'Servicios postales y telegráficos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'319', N'Servicios integrales y otros servicios', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'319', N'Servicios integrales y otros servicios', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'321', N'Arrendamiento de terrenos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'321', N'Arrendamiento de terrenos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'322', N'Arrendamiento de edificios', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'322', N'Arrendamiento de edificios', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'323', N'Arrendamiento de mobiliario y equipo de administración, educacional y recreativo', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'323', N'Arrendamiento de mobiliario y equipo de administración, educacional y recreativo', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'324', N'Arrendamiento de equipo e instrumental médico y de laboratorio', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'324', N'Arrendamiento de equipo e instrumental médico y de laboratorio', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'325', N'Arrendamiento de equipo de transporte', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'325', N'Arrendamiento de equipo de transporte', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'326', N'Arrendamiento de maquinaria, otros equipos y herramientas', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'326', N'Arrendamiento de maquinaria, otros equipos y herramientas', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'327', N'Arrendamiento de activos intangibles', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'327', N'Arrendamiento de activos intangibles', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'328', N'Arrendamiento financiero', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'328', N'Arrendamiento financiero', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'329', N'Otros arrendamientos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'329', N'Otros arrendamientos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'331', N'Servicios legales, de contabilidad, auditoría y relacionados', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'331', N'Servicios legales, de contabilidad, auditoría y relacionados', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'332', N'Servicios de diseño, arquitectura, ingeniería y actividades relacionadas', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'332', N'Servicios de diseño, arquitectura, ingeniería y actividades relacionadas', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'333', N'Servicios de consultoría administrativa, procesos, técnica y en tecnologías de la información', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'333', N'Servicios de consultoría administrativa, procesos, técnica y en tecnologías de la información', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'334', N'Servicios de capacitación ', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'334', N'Servicios de capacitación ', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'335', N'Servicios de investigación científica y desarrollo', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'335', N'Servicios de investigación científica y desarrollo', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'336', N'Servicios de apoyo administrativo, traducción, fotocopiado e impresión', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'336', N'Servicios de apoyo administrativo, traducción, fotocopiado e impresión', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'337', N'Servicios de protección y seguridad', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'337', N'Servicios de protección y seguridad', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'338', N'Servicios de vigilancia', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'338', N'Servicios de vigilancia', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'339', N'Servicios profesionales, científicos y técnicos integrales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'339', N'Servicios profesionales, científicos y técnicos integrales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'341', N'Servicios financieros y bancarios', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'341', N'Servicios financieros y bancarios', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'342', N'Servicios de cobranza, investigación crediticia y similar', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'342', N'Servicios de cobranza, investigación crediticia y similar', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'343', N'Servicios de recaudación, traslado y custodia de valores', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'343', N'Servicios de recaudación, traslado y custodia de valores', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'344', N'Seguros de responsabilidad patrimonial y fianzas', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'344', N'Seguros de responsabilidad patrimonial y fianzas', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'345', N'Seguro de bienes patrimoniales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'345', N'Seguro de bienes patrimoniales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'346', N'Almacenaje, envase y embalaje', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'346', N'Almacenaje, envase y embalaje', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'347', N'Fletes y maniobras', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'347', N'Fletes y maniobras', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'348', N'Comisiones por ventas', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'348', N'Comisiones por ventas', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'349', N'Servicios financieros, bancarios y Comerciales integrales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'349', N'Servicios financieros, bancarios y Comerciales integrales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'351', N'Conservación y mantenimiento menor de inmuebles', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'351', N'Conservación y mantenimiento menor de inmuebles', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'352', N'Instalación, reparación y mantenimiento de mobiliario y equipo de administración, educacional y recreativo', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'352', N'Instalación, reparación y mantenimiento de mobiliario y equipo de administración, educacional y recreativo', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'353', N'Instalación, reparación y mantenimiento de equipo de cómputo y tecnología de la información', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'353', N'Instalación, reparación y mantenimiento de equipo de cómputo y tecnología de la información', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'354', N'Instalación, reparación y mantenimiento de equipo e instrumental médico y de laboratorio', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'354', N'Instalación, reparación y mantenimiento de equipo e instrumental médico y de laboratorio', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'355', N'Reparación y mantenimiento de equipo de transporte', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'355', N'Reparación y mantenimiento de equipo de transporte', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'356', N'Reparación y mantenimiento de equipo de defensa y seguridad', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'356', N'Reparación y mantenimiento de equipo de defensa y seguridad', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'357', N'Instalación, reparación y mantenimiento de maquinaria, otros equipos y herramienta', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'357', N'Instalación, reparación y mantenimiento de maquinaria, otros equipos y herramienta', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'358', N'Servicios de limpieza y manejo de desechos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'358', N'Servicios de limpieza y manejo de desechos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'359', N'Servicios de jardinería y fumigación', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'359', N'Servicios de jardinería y fumigación', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'361', N'Difusión por radio, televisión y otros medios de mensajes sobre programas y actividades gubernamentales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'361', N'Difusión por radio, televisión y otros medios de mensajes sobre programas y actividades gubernamentales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'362', N'Difusión por radio, televisión y otros medios de mensajes Comerciales para promover la venta de bienes o servicios', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'362', N'Difusión por radio, televisión y otros medios de mensajes Comerciales para promover la venta de bienes o servicios', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'363', N'Servicios de creatividad, preproducción y producción de publicidad, excepto Internet', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'363', N'Servicios de creatividad, preproducción y producción de publicidad, excepto Internet', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'364', N'Servicios de revelado de fotografías', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'364', N'Servicios de revelado de fotografías', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'365', N'Servicios de la industria fílmica, del sonido y del video', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'365', N'Servicios de la industria fílmica, del sonido y del video', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'366', N'Servicio de creación y difusión de contenido exclusivamente a través de Internet', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'366', N'Servicio de creación y difusión de contenido exclusivamente a través de Internet', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'369', N'Otros servicios de información', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'369', N'Otros servicios de información', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'371', N'Pasajes aéreos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'371', N'Pasajes aéreos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'372', N'Pasajes terrestres', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'372', N'Pasajes terrestres', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'373', N'Pasajes marítimos, lacustres y fluviales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'373', N'Pasajes marítimos, lacustres y fluviales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'374', N'Autotransporte', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'374', N'Autotransporte', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'375', N'Viáticos en el país', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'375', N'Viáticos en el país', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'376', N'Viáticos en el extranjero', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'376', N'Viáticos en el extranjero', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'377', N'Gastos de instalación y traslado de menaje', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'377', N'Gastos de instalación y traslado de menaje', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'378', N'Servicios integrales de traslado y viáticos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'378', N'Servicios integrales de traslado y viáticos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'379', N'Otros servicios de traslado y hospedaje', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'379', N'Otros servicios de traslado y hospedaje', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'381', N'Gastos de ceremonial', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'381', N'Gastos de ceremonial', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'382', N'Gastos de orden social y cultural', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'382', N'Gastos de orden social y cultural', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'383', N'Congresos y convenciones', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'383', N'Congresos y convenciones', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'384', N'Exposiciones', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'384', N'Exposiciones', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'385', N'Gastos de representación', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'385', N'Gastos de representación', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'391', N'Servicios funerarios y de cementerios', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'391', N'Servicios funerarios y de cementerios', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'392', N'Impuestos y derechos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'392', N'Impuestos y derechos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'393', N'Impuestos y derechos de importación', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'393', N'Impuestos y derechos de importación', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'394', N'Sentencias y resoluciones judiciales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'394', N'Sentencias y resoluciones judiciales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'395', N'Penas, multas, accesorios y actualizaciones', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'395', N'Penas, multas, accesorios y actualizaciones', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'396', N'Otros gastos por responsabilidades', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'396', N'Otros gastos por responsabilidades', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'397', N'Utilidades', N'', N'', N'', N'', N'Partida adicionada DOF 02-01-2013', N'', N'')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'398', N'Impuestos sobre nóminas y otros que se deriven de una relación laboral', N'', N'', N'', N'', N'Partida adicionada DOF 02-01-2013', N'', N'')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'399', N'Otros servicios generales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'399', N'Otros servicios generales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'411', N'Asignaciones presupuestarias al Poder Ejecutivo', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'411', N'Asignaciones presupuestarias al Poder Ejecutivo', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'412', N'Asignaciones presupuestarias al Poder Legislativo', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'412', N'Asignaciones presupuestarias al Poder Legislativo', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'413', N'Asignaciones presupuestarias al Poder Judicial', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'413', N'Asignaciones presupuestarias al Poder Judicial', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'414', N'Asignaciones presupuestarias a Órganos Autónomos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'414', N'Asignaciones presupuestarias a Órganos Autónomos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'415', N'Transferencias internas otorgadas a entidades paraestatales no empresariales y no financieras', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'415', N'Transferencias internas otorgadas a entidades paraestatales no empresariales y no financieras', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'416', N'Transferencias internas otorgadas a entidades paraestatales empresariales y no financieras', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'416', N'Transferencias internas otorgadas a entidades paraestatales empresariales y no financieras', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'417', N'Transferencias internas otorgadas a fideicomisos públicos empresariales y no financieros', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'417', N'Transferencias internas otorgadas a fideicomisos públicos empresariales y no financieros', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'418', N'Transferencias internas otorgadas a instituciones paraestatales públicas financieras', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'418', N'Transferencias internas otorgadas a instituciones paraestatales públicas financieras', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'419', N'Transferencias internas otorgadas a fideicomisos públicos financieros', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'419', N'Transferencias internas otorgadas a fideicomisos públicos financieros', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'421', N'Transferencias otorgadas a entidades paraestatales no empresariales y no financieras', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'421', N'Transferencias otorgadas a entidades paraestatales no empresariales y no financieras', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'422', N'Transferencias otorgadas para entidades paraestatales empresariales y no financieras', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'422', N'Transferencias otorgadas para entidades paraestatales empresariales y no financieras', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'423', N'Transferencias otorgadas para instituciones paraestatales públicas financieras', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'423', N'Transferencias otorgadas para instituciones paraestatales públicas financieras', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'424', N'Transferencias otorgadas a entidades federativas y municipios', N'1', N'S / Origen', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'424', N'Transferencias otorgadas a entidades federativas y municipios', N'1', N'S / Origen', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'424', N'Transferencias otorgadas a entidades federativas y municipios', N'1', N'S / Origen', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'424', N'Transferencias otorgadas a entidades federativas y municipios', N'1', N'S / Origen', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'425', N'Transferencias a fideicomisos de entidades federativas y municipios', N'1', N'S / Origen', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'425', N'Transferencias a fideicomisos de entidades federativas y municipios', N'1', N'S / Origen', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'425', N'Transferencias a fideicomisos de entidades federativas y municipios', N'1', N'S / Origen', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'425', N'Transferencias a fideicomisos de entidades federativas y municipios', N'1', N'S / Origen', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'431', N'Subsidios a la producción', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'431', N'Subsidios a la producción', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'432', N'Subsidios a la distribución', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'432', N'Subsidios a la distribución', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'433', N'Subsidios a la inversión', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'433', N'Subsidios a la inversión', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'434', N'Subsidios a la prestación de servicios públicos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'434', N'Subsidios a la prestación de servicios públicos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'435', N'Subsidios para cubrir diferenciales de tasas de interés', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'435', N'Subsidios para cubrir diferenciales de tasas de interés', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'436', N'Subsidios a la vivienda', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'436', N'Subsidios a la vivienda', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'437', N'Subvenciones al consumo', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'437', N'Subvenciones al consumo', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'438', N'Subsidios a entidades federativas y municipios', N'', N'', N'', N'', N'Partida adicionada DOF 02-01-2013', N'', N'')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'439', N'Otros Subsidios', N'', N'', N'', N'', N'Partida adicionada DOF 02-01-2013', N'', N'')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'441', N'Ayudas sociales a personas', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'441', N'Ayudas sociales a personas', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'442', N'Becas y otras ayudas para programas de capacitación', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'442', N'Becas y otras ayudas para programas de capacitación', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'443', N'Ayudas sociales a instituciones de enseñanza', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'443', N'Ayudas sociales a instituciones de enseñanza', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'444', N'Ayudas sociales a actividades científicas o académicas', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'444', N'Ayudas sociales a actividades científicas o académicas', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'445', N'Ayudas sociales a instituciones sin fines de lucro', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'445', N'Ayudas sociales a instituciones sin fines de lucro', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'446', N'Ayudas sociales a cooperativas', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'446', N'Ayudas sociales a cooperativas', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'447', N'Ayudas sociales a entidades de interés público', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'447', N'Ayudas sociales a entidades de interés público', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'448', N'Ayudas por desastres naturales y otros siniestros', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'448', N'Ayudas por desastres naturales y otros siniestros', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'451', N'Pensiones ', N'4', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'451', N'Pensiones ', N'4', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'452', N'Jubilaciones', N'4', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'452', N'Jubilaciones', N'4', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'459', N'Otras Pensiones y jubilaciones', N'4', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'459', N'Otras Pensiones y jubilaciones', N'4', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'461', N'Transferencias a fideicomisos del Poder Ejecutivo', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'461', N'Transferencias a fideicomisos del Poder Ejecutivo', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'462', N'Transferencias a fideicomisos del Poder Legislativo', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'462', N'Transferencias a fideicomisos del Poder Legislativo', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'463', N'Transferencias a fideicomisos del Poder Judicial', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'463', N'Transferencias a fideicomisos del Poder Judicial', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'464', N'Transferencias a fideicomisos públicos de entidades paraestatales no empresariales y no financieras', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'464', N'Transferencias a fideicomisos públicos de entidades paraestatales no empresariales y no financieras', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'465', N'Transferencias a fideicomisos públicos de entidades paraestatales empresariales y no financieras', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'465', N'Transferencias a fideicomisos públicos de entidades paraestatales empresariales y no financieras', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'466', N'Transferencias a fideicomisos de instituciones públicas financieras', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'466', N'Transferencias a fideicomisos de instituciones públicas financieras', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'469', N'Otras transferencias a fideicomisos', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'469', N'Otras transferencias a fideicomisos', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'471', N'Transferencias por obligación de Ley', N'4', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'471', N'Transferencias por obligación de Ley', N'4', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'491', N'Transferencias para gobiernos extranjeros', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'491', N'Transferencias para gobiernos extranjeros', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'492', N'Transferencias para organismos internacionales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'492', N'Transferencias para organismos internacionales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'493', N'Transferencias para el sector privado externo', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'493', N'Transferencias para el sector privado externo', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'511', N'Muebles de oficina y estantería', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'511', N'Muebles de oficina y estantería', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'512', N'Muebles, excepto de oficina y estantería', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'512', N'Muebles, excepto de oficina y estantería', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'513', N'Bienes artísticos, culturales y científicos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'513', N'Bienes artísticos, culturales y científicos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'514', N'Objetos de valor', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'514', N'Objetos de valor', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'515', N'Equipo de cómputo y de tecnologías de la información', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'515', N'Equipo de cómputo y de tecnologías de la información', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'519', N'Otros mobiliarios y equipos de administración', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'519', N'Otros mobiliarios y equipos de administración', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'521', N'Equipos y aparatos audiovisuales', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'521', N'Equipos y aparatos audiovisuales', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'522', N'Aparatos deportivos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'522', N'Aparatos deportivos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'523', N'Cámaras Fotográficas y de video', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'523', N'Cámaras Fotográficas y de video', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'529', N'Otro mobiliario y equipo educacional y recreativo', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'529', N'Otro mobiliario y equipo educacional y recreativo', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'531', N'Equipo médico y de laboratorio', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'531', N'Equipo médico y de laboratorio', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'532', N'Instrumental médico y de laboratorio', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'532', N'Instrumental médico y de laboratorio', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'541', N'Automóviles y camiones', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'541', N'Automóviles y camiones', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'542', N'Carrocerías y remolques', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'542', N'Carrocerías y remolques', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'543', N'Equipo aeroespacial', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'543', N'Equipo aeroespacial', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'544', N'Equipo ferroviario', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'544', N'Equipo ferroviario', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'545', N'Embarcaciones', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'545', N'Embarcaciones', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'549', N'Otros equipos de transporte', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'549', N'Otros equipos de transporte', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'551', N'Equipo de defensa y seguridad', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'551', N'Equipo de defensa y seguridad', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'561', N'Maquinaria y equipo agropecuario', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'561', N'Maquinaria y equipo agropecuario', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'562', N'Maquinaria y equipo industrial', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'562', N'Maquinaria y equipo industrial', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'563', N'Maquinaria y equipo de construcción', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'563', N'Maquinaria y equipo de construcción', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'564', N'Sistemas de aire acondicionado, calefacción y de refrigeración industrial y Comercial', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'564', N'Sistemas de aire acondicionado, calefacción y de refrigeración industrial y Comercial', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'565', N'Equipo de comunicación y telecomunicación', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'565', N'Equipo de comunicación y telecomunicación', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'566', N'Equipos de Generación Eléctrica, Aparatos y Accesorios Eléctricos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'566', N'Equipos de Generación Eléctrica, Aparatos y Accesorios Eléctricos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'567', N'Herramientas y máquinas-herramienta', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'567', N'Herramientas y máquinas-herramienta', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'569', N'Otros equipos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'569', N'Otros equipos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'571', N'Bovinos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'571', N'Bovinos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'572', N'Porcinos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'572', N'Porcinos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'573', N'Aves', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'573', N'Aves', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'574', N'Ovinos y caprinos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'574', N'Ovinos y caprinos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'575', N'Peces y Acuicultura', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'575', N'Peces y Acuicultura', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'576', N'Equinos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'576', N'Equinos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'577', N'Especies menores y de zoológico', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'577', N'Especies menores y de zoológico', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'578', N'Árboles y plantas', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'578', N'Árboles y plantas', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'579', N'Otros activos biológicos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'579', N'Otros activos biológicos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'581', N'Terrenos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'581', N'Terrenos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'582', N'Viviendas', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'582', N'Viviendas', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'583', N'Edificios no residenciales', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'583', N'Edificios no residenciales', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'589', N'Otros bienes inmuebles', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'589', N'Otros bienes inmuebles', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'591', N'Software', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'591', N'Software', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'592', N'Patentes', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'592', N'Patentes', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'593', N'Marcas', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'593', N'Marcas', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'594', N'Derechos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'594', N'Derechos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'595', N'Concesiones', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'595', N'Concesiones', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'596', N'Franquicias', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'596', N'Franquicias', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'597', N'Licencias informáticas e intelectuales', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'597', N'Licencias informáticas e intelectuales', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'598', N'Licencias industriales, Comerciales y otras', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'598', N'Licencias industriales, Comerciales y otras', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'599', N'Otros activos intangibles', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'599', N'Otros activos intangibles', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2', N'Proveedores por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'611', N'Edificación habitacional', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'611', N'Edificación habitacional', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'612', N'Edificación no habitacional', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'612', N'Edificación no habitacional', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'613', N'Construcción de obras para el abastecimiento de agua, petróleo, gas, electricidad y telecomunicaciones', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'613', N'Construcción de obras para el abastecimiento de agua, petróleo, gas, electricidad y telecomunicaciones', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'614', N'División de terrenos y construcción de obras de urbanización', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'614', N'División de terrenos y construcción de obras de urbanización', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'615', N'Construcción de vías de comunicación', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'615', N'Construcción de vías de comunicación', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'616', N'Otras construcciones de ingeniería civil u obra pesada', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'616', N'Otras construcciones de ingeniería civil u obra pesada', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'617', N'Instalaciones y equipamiento en construcciones', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'617', N'Instalaciones y equipamiento en construcciones', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'619', N'Trabajos de acabados en edificaciones y otros trabajos especializados', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'619', N'Trabajos de acabados en edificaciones y otros trabajos especializados', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'621', N'Edificación habitacional', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'621', N'Edificación habitacional', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'622', N'Edificación no habitacional', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'622', N'Edificación no habitacional', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'623', N'Construcción de obras para el abastecimiento de agua, petróleo, gas, electricidad y telecomunicaciones', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'623', N'Construcción de obras para el abastecimiento de agua, petróleo, gas, electricidad y telecomunicaciones', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'624', N'División de terrenos y construcción de obras de urbanización', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'624', N'División de terrenos y construcción de obras de urbanización', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'625', N'Construcción de vías de comunicación', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'625', N'Construcción de vías de comunicación', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'626', N'Otras construcciones de ingeniería civil u obra pesada', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'626', N'Otras construcciones de ingeniería civil u obra pesada', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'627', N'Instalaciones y equipamiento en construcciones', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'627', N'Instalaciones y equipamiento en construcciones', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'629', N'Trabajos de acabados en edificaciones y otros trabajos especializados', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'629', N'Trabajos de acabados en edificaciones y otros trabajos especializados', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'631', N'Estudios, formulación y evaluación de proyectos productivos no incluidos en conceptos anteriores de este capítulo', N'2', N'S/cartera de Inversión', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'631', N'Estudios, formulación y evaluación de proyectos productivos no incluidos en conceptos anteriores de este capítulo', N'2', N'S/cartera de Inversión', N'Banco Moned.Nac.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'631', N'Estudios, formulación y evaluación de proyectos productivos no incluidos en conceptos anteriores de este capítulo', N'2', N'S/cartera de Inversión', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'631', N'Estudios, formulación y evaluación de proyectos productivos no incluidos en conceptos anteriores de este capítulo', N'2', N'S/cartera de Inversión', N'Banco Moned.Extr.', N'2.1.1.3', N'Contratistas por Obras Públicas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'721', N'Acciones y participaciones de capital en entidades paraestatales no empresariales y no financieras con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'721', N'Acciones y participaciones de capital en entidades paraestatales no empresariales y no financieras con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'722', N'Acciones y participaciones de capital en entidades paraestatales empresariales y no financieras con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'722', N'Acciones y participaciones de capital en entidades paraestatales empresariales y no financieras con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'723', N'Acciones y participaciones de capital en instituciones paraestatales públicas financieras con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'723', N'Acciones y participaciones de capital en instituciones paraestatales públicas financieras con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'724', N'Acciones y participaciones de capital en el sector privado con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'724', N'Acciones y participaciones de capital en el sector privado con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'725', N'Acciones y participaciones de capital en organismos internacionales con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'725', N'Acciones y participaciones de capital en organismos internacionales con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'726', N'Acciones y participaciones de capital en el sector externo con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'726', N'Acciones y participaciones de capital en el sector externo con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'727', N'Acciones y participaciones de capital en el sector público con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'727', N'Acciones y participaciones de capital en el sector público con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'728', N'Acciones y participaciones de capital en el sector privado con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'728', N'Acciones y participaciones de capital en el sector privado con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'729', N'Acciones y participaciones de capital en el sector externo con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'729', N'Acciones y participaciones de capital en el sector externo con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'731', N'Bonos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'731', N'Bonos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'732', N'Valores representativos de deuda adquiridos con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'732', N'Valores representativos de deuda adquiridos con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'733', N'Valores representativos de la deuda adquiridos con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'733', N'Valores representativos de la deuda adquiridos con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'734', N'Obligaciones negociables adquiridas con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'734', N'Obligaciones negociables adquiridas con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'735', N'Obligaciones negociables adquiridas con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'735', N'Obligaciones negociables adquiridas con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'739', N'Otros valores', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'739', N'Otros valores', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'741', N'Concesión de préstamos a entidades paraestatales no empresariales y no financieras con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'741', N'Concesión de préstamos a entidades paraestatales no empresariales y no financieras con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'742', N'Concesión de préstamos a entidades paraestatales empresariales y no financieras con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'742', N'Concesión de préstamos a entidades paraestatales empresariales y no financieras con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'743', N'Concesión de préstamos a instituciones paraestatales públicas financieras con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'743', N'Concesión de préstamos a instituciones paraestatales públicas financieras con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'744', N'Concesión de préstamos a entidades federativas y municipios con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'744', N'Concesión de préstamos a entidades federativas y municipios con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'745', N'Concesión de préstamos al sector privado con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'745', N'Concesión de préstamos al sector privado con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'746', N'Concesión de préstamos al sector externo con fines de política económica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'746', N'Concesión de préstamos al sector externo con fines de política económica', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'747', N'Concesión de préstamos al sector público con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'747', N'Concesión de préstamos al sector público con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'748', N'Concesión de préstamos al sector privado con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'748', N'Concesión de préstamos al sector privado con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'749', N'Concesión de préstamos al sector externo con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'749', N'Concesión de préstamos al sector externo con fines de gestión de liquidez', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'751', N'Inversiones en fideicomisos del Poder Ejecutivo', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'751', N'Inversiones en fideicomisos del Poder Ejecutivo', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'752', N'Inversiones en fideicomisos del Poder Legislativo', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'752', N'Inversiones en fideicomisos del Poder Legislativo', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'753', N'Inversiones en fideicomisos del Poder Judicial', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'753', N'Inversiones en fideicomisos del Poder Judicial', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'754', N'Inversiones en fideicomisos públicos no empresariales y no financieros', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'754', N'Inversiones en fideicomisos públicos no empresariales y no financieros', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'755', N'Inversiones en fideicomisos públicos empresariales y no financieros', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'755', N'Inversiones en fideicomisos públicos empresariales y no financieros', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'756', N'Inversiones en fideicomisos públicos financieros', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'756', N'Inversiones en fideicomisos públicos financieros', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'757', N'Inversiones en fideicomisos de entidades federativas', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'757', N'Inversiones en fideicomisos de entidades federativas', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'758', N'Inversiones en fideicomisos de municipios', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'758', N'Inversiones en fideicomisos de municipios', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'759', N'Otras inversiones en fideicomisos ', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'759', N'Otras inversiones en fideicomisos ', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.5', N'Transferencias Otorgadas por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'761', N'Depósitos a LP en Moneda Nacional', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'761', N'Depósitos a LP en Moneda Nacional', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'762', N'Depósitos a LP en Moneda Extranjera', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'762', N'Depósitos a LP en Moneda Extranjera', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.9', N'Otras Cuentas por Pagar a Corto Plazo ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'811', N'Fondo general de participaciones', N'5', N'', N'Banco Moned.Nac.', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'811', N'Fondo general de participaciones', N'5', N'', N'Banco Moned.Extr.', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'812', N'Fondo de fomento municipal', N'5', N'', N'Banco Moned.Nac.', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'812', N'Fondo de fomento municipal', N'5', N'', N'Banco Moned.Extr.', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'813', N'Participaciones de las entidades federativas a los municipios', N'5', N'', N'Banco Moned.Nac.', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'813', N'Participaciones de las entidades federativas a los municipios', N'5', N'', N'Banco Moned.Extr.', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'814', N'Otros conceptos participables de la Federación a entidades federativas', N'5', N'', N'Banco Moned.Nac.', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'814', N'Otros conceptos participables de la Federación a entidades federativas', N'5', N'', N'Banco Moned.Extr.', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'815', N'Otros conceptos participables de la Federación a municipios', N'5', N'', N'Banco Moned.Nac.', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'815', N'Otros conceptos participables de la Federación a municipios', N'5', N'', N'Banco Moned.Extr.', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'816', N'Convenios de colaboración administrativa', N'5', N'', N'Banco Moned.Nac.', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'816', N'Convenios de colaboración administrativa', N'5', N'', N'Banco Moned.Extr.', N'2.1.1.4', N'Participaciones y Aportaciones por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'921', N'Intereses de la deuda interna con instituciones de crédito', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'921', N'Intereses de la deuda interna con instituciones de crédito', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'922', N'Intereses derivados de la colocación de títulos y valores', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'922', N'Intereses derivados de la colocación de títulos y valores', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'923', N'Intereses por arrendamientos financieros nacionales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'923', N'Intereses por arrendamientos financieros nacionales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'924', N'Intereses de la deuda externa con instituciones de crédito', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'924', N'Intereses de la deuda externa con instituciones de crédito', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'925', N'Intereses de la deuda con organismos financieros Internacionales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'925', N'Intereses de la deuda con organismos financieros Internacionales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'926', N'Intereses de la deuda bilateral', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'926', N'Intereses de la deuda bilateral', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'927', N'Intereses derivados de la colocación de títulos y valores en el exterior', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'927', N'Intereses derivados de la colocación de títulos y valores en el exterior', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'928', N'Intereses por arrendamientos financieros internacionales', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'928', N'Intereses por arrendamientos financieros internacionales', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'931', N'Comisiones de la deuda pública interna', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'931', N'Comisiones de la deuda pública interna', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'932', N'Comisiones de la deuda pública externa', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'932', N'Comisiones de la deuda pública externa', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'941', N'Gastos de la deuda pública interna', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'941', N'Gastos de la deuda pública interna', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'942', N'Gastos de la deuda pública externa', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'942', N'Gastos de la deuda pública externa', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'951', N'Costos por cobertura de la deuda pública interna', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'951', N'Costos por cobertura de la deuda pública interna', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'952', N'Costos por cobertura de la deuda pública externa', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'952', N'Costos por cobertura de la deuda pública externa', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'961', N'Apoyos a intermediarios financieros', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'961', N'Apoyos a intermediarios financieros', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'962', N'Apoyos a ahorradores y deudores del Sistema Financiero Nacional', N'1', N'', N'Banco Moned.Nac.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'962', N'Apoyos a ahorradores y deudores del Sistema Financiero Nacional', N'1', N'', N'Banco Moned.Extr.', N'2.1.1.6', N'Intereses, Comisiones y Otros Gastos de la Deuda Pública por Pagar a Corto Plazo', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'112', N'Haberes', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.1', N'Remuneración por pagar al Personal de carácter permanente a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'113', N'Sueldos base al personal permanente', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.1', N'Remuneración por pagar al Personal de carácter permanente a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'114', N'Remuneraciones por adscripción laboral en el extranjero', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.1', N'Remuneración por pagar al Personal de carácter permanente a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'121', N'Honorarios asimilables a salarios', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.2', N'Remuneración por pagar al Personal de carácter transitorio a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'122', N'Sueldos base al personal eventual', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.2', N'Remuneración por pagar al Personal de carácter transitorio a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'123', N'Retribuciones por servicios de carácter social', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.2', N'Remuneración por pagar al Personal de carácter transitorio a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'124', N'Retribución a los representantes de los trabajadores y de los patrones en la Junta de Conciliación y Arbitraje', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.2', N'Remuneración por pagar al Personal de carácter transitorio a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'131', N'Primas por años de servicios efectivos prestados', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.3', N'Remuneraciones Adicionales y Especiales por Pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'132', N'Primas de vacaciones, dominical y gratificación de fin de año', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.3', N'Remuneraciones Adicionales y Especiales por Pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'133', N'Horas extraordinarias', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.3', N'Remuneraciones Adicionales y Especiales por Pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'134', N'Compensaciones', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.1.3', N'Remuneraciones Adicionales y Especiales por Pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'135', N'Sobrehaberes', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.1.3', N'Remuneraciones Adicionales y Especiales por Pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'136', N'Asignaciones de técnico, de mando, por comisión, de vuelo y de técnico especial', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.1.3', N'Remuneraciones Adicionales y Especiales por Pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'137', N'Honorarios especiales', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.1.3', N'Remuneraciones Adicionales y Especiales por Pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'138', N'Participaciones por vigilancia en el cumplimiento de las leyes y custodia de valores', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.3', N'Remuneraciones Adicionales y Especiales por Pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'141', N'Aportaciones de seguridad social', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.4', N'Seguridad Social y Seguros por pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'142', N'Aportaciones a fondos de vivienda', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.1.4', N'Seguridad Social y Seguros por pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'143', N'Aportaciones al sistema para el retiro', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.4', N'Seguridad Social y Seguros por pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'144', N'Aportaciones para seguros', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.1.4', N'Seguridad Social y Seguros por pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'151', N'Cuotas para el fondo de ahorro y fondo de trabajo', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.5', N'Otras prestaciones sociales y económicas por pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'152', N'Indemnizaciones', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.5', N'Otras prestaciones sociales y económicas por pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'153', N'Prestaciones y haberes de retiro', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.5', N'Otras prestaciones sociales y económicas por pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'154', N'Prestaciones contractuales', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.1.5', N'Otras prestaciones sociales y económicas por pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'155', N'Apoyos a la capacitación de los servidores públicos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.5', N'Otras prestaciones sociales y económicas por pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'159', N'Otras prestaciones sociales y económicas', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.1.5', N'Otras prestaciones sociales y económicas por pagar a CP', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'171', N'Estímulos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.1.6', N'Estímulos a servidores públicos por pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'172', N'Recompensas', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.1.6', N'Estímulos a servidores públicos por pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'211', N'Materiales, útiles y equipos menores de oficina', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'212', N'Materiales y útiles de impresión y reproducción', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'213', N'Material estadístico y geográfico', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'214', N'Materiales, útiles y equipos menores de tecnologías de la información y comunicaciones', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'215', N'Material impreso e información digital', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'216', N'Material de limpieza', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'217', N'Materiales y útiles de enseñanza', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'218', N'Materiales para el registro e identificación de bienes y personas', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'221', N'Productos alimenticios para personas', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'222', N'Productos alimenticios para animales', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'223', N'Utensilios para el servicio de alimentación', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'231', N'Productos alimenticios, agropecuarios y forestales adquiridos como materia prima', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'232', N'Insumos textiles adquiridos como materia prima', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'233', N'Productos de papel, cartón e impresos adquiridos como materia prima', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'234', N'Combustibles, lubricantes, aditivos, carbón y sus derivados adquiridos como materia prima', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'235', N'Productos químicos, farmacéuticos y de laboratorio adquiridos como materia prima', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'236', N'Productos metálicos y a base de minerales no metálicos adquiridos como materia prima', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'237', N'Productos de cuero, piel, plástico y hule adquiridos como materia prima', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'238', N'Mercancías adquiridas para su Comercialización', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'239', N'Otros productos adquiridos como materia prima', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'241', N'Productos minerales no metálicos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'242', N'Cemento y productos de concreto', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'243', N'Cal, yeso y productos de yeso', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'244', N'Madera y productos de madera', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'245', N'Vidrio y productos de vidrio', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'246', N'Material eléctrico y electrónico', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'247', N'Artículos metálicos para la construcción', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'248', N'Materiales complementarios', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'249', N'Otros materiales y artículos de construcción y reparación', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'251', N'Productos químicos básicos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'252', N'Fertilizantes, pesticidas y otros agroquímicos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'253', N'Medicinas y productos farmacéuticos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'254', N'Materiales, accesorios y suministros médicos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'255', N'Materiales, accesorios y suministros de laboratorio', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'256', N'Fibras sintéticas, hules, plásticos y derivados', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'259', N'Otros productos químicos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'261', N'Combustibles, lubricantes y aditivos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'262', N'Carbón y sus derivados', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'271', N'Vestuario y uniformes', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'272', N'Prendas de seguridad y protección personal', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'273', N'Artículos deportivos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'274', N'Productos textiles', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'275', N'Blancos y otros productos textiles, excepto prendas de vestir', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'281', N'Sustancias y materiales explosivos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'282', N'Materiales de seguridad pública', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'283', N'Prendas de protección para seguridad pública y nacional', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'291', N'Herramientas menores', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'292', N'Refacciones y accesorios menores de edificios', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'293', N'Refacciones y accesorios menores de mobiliario y equipo de administración, educacional y recreativo', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'294', N'Refacciones y accesorios menores de equipo de cómputo y tecnologías de la información', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'295', N'Refacciones y accesorios menores de equipo e instrumental médico y de laboratorio', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'296', N'Refacciones y accesorios menores de equipo de transporte', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'297', N'Refacciones y accesorios menores de equipo de defensa y seguridad', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'298', N'Refacciones y accesorios menores de maquinaria y otros equipos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'299', N'Refacciones y accesorios menores otros bienes muebles', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'311', N'Energía eléctrica', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'312', N'Gas', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'313', N'Agua', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'314', N'Telefonía tradicional', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'315', N'Telefonía celular', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'316', N'Servicios de telecomunicaciones y satélites', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'317', N'Servicios de acceso de Internet, redes y procesamiento de información', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'318', N'Servicios postales y telegráficos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'319', N'Servicios integrales y otros servicios', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'321', N'Arrendamiento de terrenos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'322', N'Arrendamiento de edificios', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'323', N'Arrendamiento de mobiliario y equipo de administración, educacional y recreativo', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'324', N'Arrendamiento de equipo e instrumental médico y de laboratorio', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'325', N'Arrendamiento de equipo de transporte', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'326', N'Arrendamiento de maquinaria, otros equipos y herramientas', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'327', N'Arrendamiento de activos intangibles', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'329', N'Otros arrendamientos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'331', N'Servicios legales, de contabilidad, auditoría y relacionados', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'332', N'Servicios de diseño, arquitectura, ingeniería y actividades relacionadas', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'333', N'Servicios de consultoría administrativa, procesos, técnica y en tecnologías de la información', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'334', N'Servicios de capacitación ', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'335', N'Servicios de investigación científica y desarrollo', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'336', N'Servicios de apoyo administrativo, traducción, fotocopiado e impresión', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'337', N'Servicios de protección y seguridad', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'338', N'Servicios de vigilancia', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'339', N'Servicios profesionales, científicos y técnicos integrales', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'341', N'Servicios financieros y bancarios', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'342', N'Servicios de cobranza, investigación crediticia y similar', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'343', N'Servicios de recaudación, traslado y custodia de valores', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'344', N'Seguros de responsabilidad patrimonial y fianzas', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'345', N'Seguro de bienes patrimoniales', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'346', N'Almacenaje, envase y embalaje', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'347', N'Fletes y maniobras', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'348', N'Comisiones por ventas', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'349', N'Servicios financieros, bancarios y Comerciales integrales', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'351', N'Conservación y mantenimiento menor de inmuebles', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'352', N'Instalación, reparación y mantenimiento de mobiliario y equipo de administración, educacional y recreativo', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'353', N'Instalación, reparación y mantenimiento de equipo de cómputo y tecnología de la información', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'354', N'Instalación, reparación y mantenimiento de equipo e instrumental médico y de laboratorio', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'355', N'Reparación y mantenimiento de equipo de transporte', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'356', N'Reparación y mantenimiento de equipo de defensa y seguridad', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'357', N'Instalación, reparación y mantenimiento de maquinaria, otros equipos y herramienta', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'358', N'Servicios de limpieza y manejo de desechos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'359', N'Servicios de jardinería y fumigación', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'361', N'Difusión por radio, televisión y otros medios de mensajes sobre programas y actividades gubernamentales', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'362', N'Difusión por radio, televisión y otros medios de mensajes Comerciales para promover la venta de bienes o servicios', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'363', N'Servicios de creatividad, preproducción y producción de publicidad, excepto Internet', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'364', N'Servicios de revelado de fotografías', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'365', N'Servicios de la industria fílmica, del sonido y del video', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'366', N'Servicio de creación y difusión de contenido exclusivamente a través de Internet', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'369', N'Otros servicios de información', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'371', N'Pasajes aéreos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'372', N'Pasajes terrestres', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'373', N'Pasajes marítimos, lacustres y fluviales', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'374', N'Autotransporte', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'375', N'Viáticos en el país', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'376', N'Viáticos en el extranjero', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'377', N'Gastos de instalación y traslado de menaje', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'378', N'Servicios integrales de traslado y viáticos', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'379', N'Otros servicios de traslado y hospedaje', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'381', N'Gastos de ceremonial', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'382', N'Gastos de orden social y cultural', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'383', N'Congresos y convenciones', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'384', N'Exposiciones', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'385', N'Gastos de representación', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'391', N'Servicios funerarios y de cementerios', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'392', N'Impuestos y derechos', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'393', N'Impuestos y derechos de importación', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'394', N'Sentencias y resoluciones judiciales', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'395', N'Penas, multas, accesorios y actualizaciones', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'396', N'Otros gastos por responsabilidades', N'2', N'', N'Banco Moned.Extr.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizPagadoGasto] ([COG], [NombreCOG], [TipoGasto], [Caracteristicas], [MedioPago], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'399', N'Otros servicios generales', N'2', N'', N'Banco Moned.Nac.', N'2.1.1.2.1', N'Deudas por Adquisición de Bienes y Contratación de Servicios por Pagar a CP ', N'1.1.1.2', N'Bancos/Tesorería ')
GO
INSERT [dbo].[C_MatrizRecaudadoIngresosSinDevengado] ([CRI], [NombreCRI], [MedioRecaudacion], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'81', N'Participaciones', N'Banco Moned. Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'4.2.1.1', N'Participaciones ')
GO
INSERT [dbo].[C_MatrizRecaudadoIngresosSinDevengado] ([CRI], [NombreCRI], [MedioRecaudacion], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'91', N'Transferencias Internas y Asignaciones al Sector Público', N'Banco Moned. Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'4.2.2.1', N'Transferencias Internas y Asignaciones al  Sector Público')
GO
INSERT [dbo].[C_MatrizRecaudadoIngresosSinDevengado] ([CRI], [NombreCRI], [MedioRecaudacion], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'92', N'Transferencias al Resto del Sector Público', N'Banco Moned. Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'4.2.2.2', N'Transferencias al Resto del Sector Público')
GO
INSERT [dbo].[C_MatrizRecaudadoIngresosSinDevengado] ([CRI], [NombreCRI], [MedioRecaudacion], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'93', N'Subsidios y Subvenciones', N'Banco Moned. Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'4.2.2.3', N'Subsidios y Subvenciones ')
GO
INSERT [dbo].[C_MatrizRecaudadoIngresosSinDevengado] ([CRI], [NombreCRI], [MedioRecaudacion], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'94', N'Ayudas sociales ', N'Banco Moned. Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'4.2.2.4', N'Ayudas Sociales ')
GO
INSERT [dbo].[C_MatrizRecaudadoIngresosSinDevengado] ([CRI], [NombreCRI], [MedioRecaudacion], [CuentaCargo], [NombreCuentaCargo], [CuentaAbono], [NombreCuentaAbono]) VALUES (N'95', N'Pensiones y Jubilaciones ', N'Banco Moned. Nac.', N'1.1.1.2', N'Bancos/Tesorería ', N'4.2.2.5', N'Pensiones y Jubilaciones ')
GO
