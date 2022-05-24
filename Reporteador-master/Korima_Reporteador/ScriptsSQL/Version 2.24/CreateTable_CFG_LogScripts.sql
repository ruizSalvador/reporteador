/****** Object:  Table [dbo].[CFG_LogScripts]    Script Date: 10/17/2016 09:24:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CFG_LogScripts]') AND type in (N'U'))
DROP TABLE [dbo].[CFG_LogScripts]
GO
/****** Object:  Table [dbo].[CFG_LogScripts]    Script Date: 10/17/2016 09:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CFG_LogScripts]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[CFG_LogScripts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ScriptName] [varchar](100) NOT NULL,
	[ExecDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CFG_LogScripts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

SET ANSI_PADDING OFF
GO


