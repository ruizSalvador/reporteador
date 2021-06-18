/****** Object:  Table [dbo].[T_SaldosInicialesContDay]    Script Date: 10/17/2016 09:24:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_SaldosInicialesContDay]') AND type in (N'U'))
DROP TABLE [dbo].[T_SaldosInicialesContDay]
GO
/****** Object:  Table [dbo].[T_SaldosInicialesContDay]   Script Date: 14/07/2017 01:02:41 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[T_SaldosInicialesContDay](
	[IdCuentaContable] [int] NOT NULL,
	[TotalCargos] [decimal](18, 2) NULL,
	[TotalAbonos] [decimal](18, 2) NULL,
	[CargosSinFlujo] [decimal](18, 2) NULL,
	[AbonosSinFlujo] [decimal](18, 2) NULL,
 CONSTRAINT [PK_T_SaldosInicialesContDay] PRIMARY KEY NONCLUSTERED 
(
	[IdCuentaContable] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


