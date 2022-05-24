/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_EstadoCambioSituacioFinancieraRangosHor]    Script Date: 01/21/2014 16:04:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_EstadoCambioSituacioFinancieraRangosHor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_EstadoCambioSituacioFinancieraRangosHor]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_EstadoCambioSituacioFinancieraRangosHor]    Script Date: 01/21/2014 16:04:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--exec SP_RPT_K2_EstadoCambioSituacioFinancieraRangosHor 2015,7,0,0,2015,1,3
CREATE PROCEDURE [dbo].[SP_RPT_K2_EstadoCambioSituacioFinancieraRangosHor]
@A�o int,
@Mes int,
@Miles bit,
@MostrarVacios bit,
@A�oAnterior int,
@MesAnterior int,
@Tipo int


AS
BEGIN
--

DECLARE  @Todo TABLE(
				NumeroCuenta varchar(max),
				NombreCuenta varchar(max),
				Mes int, 
				Year int, 
				NumeroCuentaAnt varchar(max), 
				MesAnt int,
				A�oAnt int,
				Nivel1 varchar(Max),
				Nivel2 varchar(Max),
				Saldo decimal(15,2),
				SaldoANT decimal(15,2),
				Orden1 int,
				Orden2 int, 
				Aplicacion decimal(15,2),
				Origen decimal(15,2)				 
				)

Insert Into @Todo
Exec SP_RPT_K2_Estado_Situacion_FinancieraRangos @A�o, @Mes, @Miles, @MostrarVacios, @A�oAnterior, @MesAnterior 

If @Tipo = 1
Begin
	Select * from @Todo Where NumeroCuenta like '1%'
End
If @Tipo = 2
Begin
	Select * from @Todo Where NumeroCuenta like '2%' or NumeroCuenta like '3%'
End
If @Tipo = 3
Begin
	Select Top 1 * from @Todo
End
END 

GO

EXEC SP_FirmasReporte 'Estado de Cambios en la Situaci�n Financiera por Periodos'
GO
