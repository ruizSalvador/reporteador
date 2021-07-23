/****** Object:  StoredProcedure [dbo].[SP_RPT_InformeAnaliticoObligacionesDifFinanciamientos]    Script Date: 01/21/2014 16:04:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_InformeAnaliticoObligacionesDifFinanciamientos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_InformeAnaliticoObligacionesDifFinanciamientos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_InformeAnaliticoObligacionesDifFinanciamientos]    Script Date: 01/21/2014 16:04:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SP_RPT_InformeAnaliticoObligacionesDifFinanciamientos 1,1,2016
CREATE PROCEDURE [dbo].[SP_RPT_InformeAnaliticoObligacionesDifFinanciamientos]
@Mes1 int,
@Mes2 int,
@Ejercicio int
--@MostrarVacios int

AS
BEGIN
DECLARE  @Titulos as TABLE(
				Concepto varchar(max),
				FechaContrato Date,
				FechaInicio Date,
				FechaVencimiento Date, 
				MontoInversion Decimal(18,2), 
				PlazoPactado varchar (150),
				MontoPromedio Decimal(18,2),
				MontoPromedio2 Decimal(18,2),
				MontoPagado Decimal(18,2),
				MontoPagado2 Decimal(18,2),
				SaldoPendiente Decimal (18,2),
				Negritas int,
				Grupo int 
				)

INSERT INTO @Titulos  values ('A. Asociaciones Público Privadas',GETDATE(),GETDATE(),GETDATE(),0,0,0,0,0,0,0,1,1)
INSERT INTO @Titulos  values ('(APP'+char(39) +'s) (A=a+b+c+d)',GETDATE(),GETDATE(),GETDATE(),0,0,0,0,0,0,0,0,1)
INSERT INTO @Titulos  values ('a) APP 1',GETDATE(),GETDATE(),GETDATE(),0,0,0,0,0,0,0,0,1)
INSERT INTO @Titulos  values ('b) APP 2',GETDATE(),GETDATE(),GETDATE(),0,0,0,0,0,0,0,0,1)
INSERT INTO @Titulos  values ('c) APP 3',GETDATE(),GETDATE(),GETDATE(),0,0,0,0,0,0,0,0,1)
INSERT INTO @Titulos  values ('d) APP 4',GETDATE(),GETDATE(),GETDATE(),0,0,0,0,0,0,0,0,1)
INSERT INTO @Titulos  values ('B. Otros Instrumentos (B=a+b+c+d)',GETDATE(),GETDATE(),GETDATE(),0,0,0,0,0,0,0,1,1)
INSERT INTO @Titulos  values ('a) Otros Instrumentos 1',GETDATE(),GETDATE(),GETDATE(),0,0,0,0,0,0,0,0,1)
INSERT INTO @Titulos  values ('b) Otros Instrumentos 2',GETDATE(),GETDATE(),GETDATE(),0,0,0,0,0,0,0,0,1)
INSERT INTO @Titulos  values ('c) Otros Instrumentos 3',GETDATE(),GETDATE(),GETDATE(),0,0,0,0,0,0,0,0,1)
INSERT INTO @Titulos  values ('d) Otros Instrumento 4',GETDATE(),GETDATE(),GETDATE(),0,0,0,0,0,0,0,0,1)
INSERT INTO @Titulos  values ('C. Total de Obligaciones Diferentes de Financiamiento',GETDATE(),GETDATE(),GETDATE(),0,0,0,0,0,0,0,1,1)


Select * from @Titulos
END

EXEC SP_FirmasReporte 'LDF Informe Analitico de Obligaciones Diferentes de Financiamientos'
GO

Exec SP_CFG_LogScripts 'SP_RPT_InformeAnaliticoObligacionesDifFinanciamientos','2.31'
GO