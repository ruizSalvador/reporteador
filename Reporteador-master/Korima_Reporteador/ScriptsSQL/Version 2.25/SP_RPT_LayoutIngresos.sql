/****** Object:  StoredProcedure [dbo].[SP_RPT_LayoutIngresos]    Script Date: 03/03/2017 10:26:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_LayoutIngresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_LayoutIngresos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_LayoutIngresos]    Script Date: 03/03/2017 10:26:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_LayoutIngresos '20171231',2016
Create Procedure [dbo].[SP_RPT_LayoutIngresos]
@date as datetime, @Ejercicio as int
AS

Declare @trimestre int
Declare @mes as int
set @mes = DATEPART(mm, @date)	
set @trimestre = DATEPART(QQ, @date)

Declare @Header as TABLE (
Campo1 varchar (2),
Campo2 int,
Campo3 varchar(100),
Campo4 int,
Campo5 int,
Campo6 int,
Campo7 int,
Campo8 decimal (15,2),
Campo9 decimal (15,2),
Campo10 decimal (15,2),
Campo11 decimal (15,2))

Declare @Detail as TABLE (
Campo1 int,
Campo2 varchar(4),
Campo3 varchar(2),
Campo4 varchar(100),
Campo5 decimal (15,2),
Campo6 decimal (15,2),
Campo7 decimal (15,2),
Campo8 decimal (15,2))

 INSERT INTO @Header
		  Select 'MI',
				    1,
(Select Clave From C_RamoPresupuestal Where IDRAMOPRESUPUESTAL = (Select top 1 IDRAMOPRESUPUESTAL From T_SellosPresupuestales)),
   @Ejercicio,
   @trimestre,
   @mes,
(Select count(IdPartidaGI) from C_PartidasGastosIngresos WHERE Ejercicio = @Ejercicio),
ISNULL((Select SUM(Ampliaciones) from T_PresupuestoFlujo TP Inner Join C_PartidasGastosIngresos CP ON  TP.IdPartida = CP.IdpartidaGI Where CP.Ejercicio = @Ejercicio AND TP.Ejercicio = @Ejercicio AND (Mes Between 1 and @mes)),0),
ISNULL((Select SUM(Reducciones) from T_PresupuestoFlujo TP Inner Join C_PartidasGastosIngresos CP ON  TP.IdPartida = CP.IdpartidaGI Where CP.Ejercicio = @Ejercicio AND TP.Ejercicio = @Ejercicio AND (Mes Between 1 and @mes)),0),
ISNULL((Select SUM(Devengado) from T_PresupuestoFlujo TP Inner Join C_PartidasGastosIngresos CP ON  TP.IdPartida = CP.IdpartidaGI Where CP.Ejercicio = @Ejercicio  AND TP.Ejercicio = @Ejercicio AND (Mes Between 1 and @mes)),0),
ISNULL((Select SUM(Recaudado) from T_PresupuestoFlujo TP Inner Join C_PartidasGastosIngresos CP ON  TP.IdPartida = CP.IdpartidaGI Where CP.Ejercicio = @Ejercicio  AND TP.Ejercicio = @Ejercicio AND (Mes Between 1 and @mes)),0)

Declare @IdPartida int
Declare @Clave varchar (50)
Declare @Descripcion varchar (max)


DECLARE Registros CURSOR FOR
SELECT IdPartidaGI, Clave, Descripcion
  from C_PartidasGastosIngresos where Ejercicio = @Ejercicio

OPEN Registros
	FETCH NEXT FROM Registros INTO  @IdPartida, @Clave, @Descripcion 
WHILE @@FETCH_STATUS = 0
		BEGIN
	INSERT INTO @Detail VALUES (
	2,
	SUBSTRING(@Clave,6,4), 
	SUBSTRING(@Clave,6,2),
	@Descripcion,
	ISNULL((Select SUM(Ampliaciones) from T_PresupuestoFlujo WHERE Ejercicio = @Ejercicio AND (Mes Between 1 and @mes) AND IdPartida = @IdPartida),0),
	ISNULL((Select SUM(Reducciones) from T_PresupuestoFlujo WHERE Ejercicio = @Ejercicio AND (Mes Between 1 and @mes) AND IdPartida = @IdPartida),0),
	ISNULL((Select SUM(Devengado) from T_PresupuestoFlujo WHERE Ejercicio = @Ejercicio AND (Mes Between 1 and @mes) AND IdPartida = @IdPartida),0),
	ISNULL((Select SUM(Recaudado) from T_PresupuestoFlujo WHERE Ejercicio = @Ejercicio AND (Mes Between 1 and @mes) AND IdPartida = @IdPartida),0)
	)			
     
   FETCH NEXT FROM Registros INTO @IdPartida, @Clave, @Descripcion  

	END
CLOSE Registros
DEALLOCATE Registros

Select  
Campo1 as F1,
Campo2 as F2,
Campo3 as F3,
CAST(Campo4 as varchar(4)) as F4,
CAST(Campo5 as varchar(1)) as F5,
CAST(Campo6 as varchar(2)) as F6,
CAST(Campo7 as varchar(200)) as F7,
Campo8 as F8,
Campo9 as F9,
Campo10 as F10,
Campo11 as F11 
from @Header

UNION ALL

Select
CAST(Campo1 as varchar(2)) as F1,
Campo2 as F2,
Campo3 as F3,
Campo4 as F4,
CAST(Campo5 as varchar(18)) as F5,
CAST(Campo6 as varchar(18)) as F6,
CAST(Campo7 as varchar(18)) as F7,
Campo8 as F8,
null as F9,
null as F10,
null as F11 
from @Detail
Order by F1 desc

GO

Exec SP_CFG_LogScripts 'SP_RPT_LayoutIngresos'
GO