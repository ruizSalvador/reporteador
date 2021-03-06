/****** Object:  Table [dbo].[C_SubClases]    Script Date: 12/09/2013 14:54:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_SubClases]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[C_SubClases](
	[IdSubClase] [int] NULL,
	[NombreSubClase] [varchar](50) NULL,
	[IdGrupo] [int] NULL,
	[IdSubGrupo] [int] NULL,
	[IdFamilia] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[C_Maestro]') 
         AND name = 'IdSubClase'
)BEGIN
ALTER TABLE C_Maestro
        ADD IdSubClase Int
END
GO

Update C_Maestro Set IdSubClase=0 where IdSubClase is null
GO
