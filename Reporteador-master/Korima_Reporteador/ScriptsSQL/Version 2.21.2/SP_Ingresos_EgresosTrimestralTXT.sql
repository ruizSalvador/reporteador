/****** Object:  StoredProcedure [dbo].[SP_Ingresos_EgresosTrimestralTXT]    Script Date: 07/23/2014 09:45:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Ingresos_EgresosTrimestralTXT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Ingresos_EgresosTrimestralTXT]
GO

/****** Object:  StoredProcedure [dbo].[SP_Ingresos_EgresosTrimestralTXT]    Script Date: 03/10/2014 09:45:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--exec SP_Ingresos_EgresosTrimestralTXT 1,2015,3
CREATE PROCEDURE [dbo].[SP_Ingresos_EgresosTrimestralTXT]
@Trimestre smallint,
@Ejercicio int,
@Tipo int
AS
Declare @mes1 as int
Declare @mes2 as int
Declare @Fecha1 as varchar(20) 
Declare @Fecha2 as varchar(20) 

IF @Trimestre = 1
Begin
	set @mes1 = 1
	set @mes2 = 3
	set @Fecha1 = @Ejercicio + '0' + @mes1 + '01'
	set @Fecha2 = @Ejercicio + '0' + @mes2 + '31'
End

IF @Trimestre = 2
Begin
	set @mes1 = 4
	set @mes2 = 6
	set @Fecha1 = @Ejercicio + '0' + @mes1 + '01'
	set @Fecha2 = @Ejercicio + '0' + @mes2 + '30'
End

IF @Trimestre = 3
Begin
	set @mes1 = 7
	set @mes2 = 9
	set @Fecha1 = @Ejercicio + '0' + @mes1 + '01'
	set @Fecha2 = @Ejercicio + '0' + @mes2 + '30'
End

IF @Trimestre = 4
Begin
	set @mes1 = 10
	set @mes2 = 12
	set @Fecha1 = @Ejercicio + @mes1 + '01'
	set @Fecha2 = @Ejercicio + @mes2 + '31'
End

BEGIN

If @Tipo = 1
	Begin
		Select IdPartida, SUM(Modificado)Modificado, SUM(Pagado)Pagado from T_PresupuestoNW tp
		INNER JOIN T_SellosPresupuestales ts
		ON tp.IdSelloPresupuestal = ts.IdSelloPresupuestal
		WHere tp.Mes Between @mes1 and @mes2  and Year = @Ejercicio
		Group by IdPartida
		Order by IdPartida
	End

If @Tipo = 2
	Begin
		Select Clave, SUM(Modificado) Modificado, SUM(Recaudado) Recaudado From T_PresupuestoFlujo tp
		INNER JOIN  C_PartidasGastosIngresos cp
		ON tp.IdPartida = cp.IdPartidaGI
		Where tp.Mes Between @mes1 and @mes2 and tp.Ejercicio = @Ejercicio
		Group by Clave
		Order by Clave
	End

If @Tipo = 3
	Begin
		Select (Select COUNT(IdDefMeta) from T_DefinicionMetas Where Afectable = 1 and Ejercicio = @Ejercicio) as Programadas, (Select COUNT(Avance) from T_SeguimientoMeta Where Avance >= 100 and Fecha >=@Fecha1 and Fecha <=@Fecha2) as Cumplidas	
	End
END