/****** Object:  Table [dbo].[T_TmpGenPolDevNom]    Script Date: 06/24/2014 09:31:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_TmpGenPolDevNom]') AND type in (N'U'))
DROP TABLE [dbo].[T_TmpGenPolDevNom]
GO
/****** Object:  Table [dbo].[T_TmpGenPolDevNom]    Script Date: 06/24/2014 09:31:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_TmpGenPolDevNom]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[T_TmpGenPolDevNom](
	[Tipo] [smallint] NOT NULL,
	[IdMovimiento] [int] NOT NULL,
	[Folio] [varchar](20) NULL,
	[Fecha] [date] NULL,
	[Descripcion] [varchar](255) NULL,
	[IdIngreso] [int] NULL,
 CONSTRAINT [PK_TmpGenPolDevNom] PRIMARY KEY CLUSTERED 
(
	[Tipo] ASC,
	[IdMovimiento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
