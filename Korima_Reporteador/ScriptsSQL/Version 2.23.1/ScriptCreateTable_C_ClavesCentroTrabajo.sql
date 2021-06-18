

/****** Object:  Table [dbo].[C_ClavesCentroTrabajo]    Script Date: 08/04/2016 12:09:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ClavesCentroTrabajo]') AND type in (N'U'))
DROP TABLE [dbo].[C_ClavesCentroTrabajo]
GO


/****** Object:  Table [dbo].[C_ClavesCentroTrabajo]    Script Date: 08/04/2016 12:09:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[C_ClavesCentroTrabajo](
	[Idcct] [int] NOT NULL,
	[Clave] [varchar](30) NULL,
	[Descripcion] [varchar](150) NULL,
 CONSTRAINT [PK_CCT] PRIMARY KEY CLUSTERED 
(
	[Idcct] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


