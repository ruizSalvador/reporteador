IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'UQ_IdOrigen_IdDestino') AND type in (N'UQ'))
	ALTER TABLE [dbo].[C_TraspasosBancarios] DROP CONSTRAINT [UQ_IdOrigen_IdDestino]
GO

/****** Object:  Index [UQ_IdOrigen_IdDestino]    Script Date: 07/06/2016 12:14:33 p.m. ******/
ALTER TABLE [dbo].[C_TraspasosBancarios] ADD  CONSTRAINT [UQ_IdOrigen_IdDestino] UNIQUE NONCLUSTERED 
(
	[IdCuentaBancariaOrigen] ASC,
	[IdCuentaBancariaDestino] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


