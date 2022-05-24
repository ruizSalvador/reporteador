/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Estado_Situacion_FinancieraV1_1Periodos]    Script Date: 01/21/2014 16:04:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CreaCuentaAutomaticas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_CreaCuentaAutomaticas]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--exec SP_RPT_K2_Estado_Situacion_FinancieraV1_1Periodos 2015,2015,4,4,0,1,1
CREATE PROCEDURE [dbo].[SP_CreaCuentaAutomaticas]
AS
BEGIN--Procedimiento
--#################################################################################################################################################
-- CREAR CUENTAS AUTOMATICAS--

declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

Declare @tabla1 as table(
[IdCuentaContable] int,
	[IdPartidaGI] smallint,
	[NumeroCuenta] varchar(30),
	[NombreCuenta] varchar (255),
	[IdCuentaAfectacion] int,
	[CuentaAcumulacion] varchar(30),
	[TipoCuenta] varchar (1),
	[Afectable] tinyint,
	[Nivel] smallint,
	[Alta] smallint,
	[Exportada] tinyint,
	[Financiero] smallint,
	[AfectaDisponibilidad] smallint,
	[IdSelloPresupuestal] int,
	[IdCuentaContableMayor] int,
	[Utilizar] tinyint,
	[Armonizado] tinyint,
	[Observaciones] varchar(1000),
	[SuSaldoRepresenta] varchar(5000),
	[Descripcion] varchar(2000),
	[Fecha] datetime,
	[SaldarCierreEjercicio] tinyint,
	[CrearSubcuentasAutomaticas] tinyint,
	[FechaAuditoria] datetime,
	[HoraAuditoria] datetime,
	[IdUsuarioModifica] int
)

Declare @tabla2 as table(
 [IdCuentaContable] int,
	[IdPartidaGI] smallint,
	[NumeroCuenta] varchar(30),
	[NombreCuenta] varchar (255),
	[IdCuentaAfectacion] int,
	[CuentaAcumulacion] varchar(30),
	[TipoCuenta] varchar (1),
	[Afectable] tinyint,
	[Nivel] smallint,
	[Alta] smallint,
	[Exportada] tinyint,
	[Financiero] smallint,
	[AfectaDisponibilidad] smallint,
	[IdSelloPresupuestal] int,
	[IdCuentaContableMayor] int,
	[Utilizar] tinyint,
	[Armonizado] tinyint,
	[Observaciones] varchar(1000),
	[SuSaldoRepresenta] varchar(5000),
	[Descripcion] varchar(2000),
	[Fecha] datetime,
	[SaldarCierreEjercicio] tinyint,
	[CrearSubcuentasAutomaticas] tinyint,
	[FechaAuditoria] datetime,
	[HoraAuditoria] datetime,
	[IdUsuarioModifica] int
)

Declare @tabla3 as table(
[IdCuentaContable] int,
	[IdPartidaGI] smallint,
	[NumeroCuenta] varchar(30),
	[NombreCuenta] varchar (255),
	[IdCuentaAfectacion] int,
	[CuentaAcumulacion] varchar(30),
	[TipoCuenta] varchar (1),
	[Afectable] tinyint,
	[Nivel] smallint,
	[Alta] smallint,
	[Exportada] tinyint,
	[Financiero] smallint,
	[AfectaDisponibilidad] smallint,
	[IdSelloPresupuestal] int,
	[IdCuentaContableMayor] int,
	[Utilizar] tinyint,
	[Armonizado] tinyint,
	[Observaciones] varchar(1000),
	[SuSaldoRepresenta] varchar(5000),
	[Descripcion] varchar(2000),
	[Fecha] datetime,
	[SaldarCierreEjercicio] tinyint,
	[CrearSubcuentasAutomaticas] tinyint,
	[FechaAuditoria] datetime,
	[HoraAuditoria] datetime,
	[IdUsuarioModifica] int
)

-----------------------------------81400-81200---------------
Insert into @tabla1
Select * from C_Contable Where NumeroCuenta like '8140%'

Insert into @tabla2
Select * from C_Contable Where NumeroCuenta like '8120%'



Declare @IdCuentaContable as int
Declare	@IdPartidaGIas smallint
Declare	@NumeroCuenta as varchar(30)
Declare	@NombreCuenta as varchar (255)
Declare	@IdCuentaAfectacion as int
Declare	@CuentaAcumulacion as varchar(30)
Declare	@TipoCuenta varchar (2)
Declare	@Afectable as tinyint
Declare	@Nivel as smallint
Declare	@Alta as smallint
Declare @Exportada as tinyint
Declare	@Financiero smallint
Declare	@AfectaDisponibilidad as smallint
Declare	@IdSelloPresupuestal int
Declare	@IdCuentaContableMayor as int
Declare @Utilizar as tinyint
Declare	@Armonizado as tinyint
Declare @Observaciones varchar(1000)
Declare	@SuSaldoRepresenta varchar(5000)
Declare	@Descripcion varchar(2000)
Declare	@Fecha datetime
Declare	@SaldarCierreEjercicio as tinyint
Declare	@CrearSubcuentasAutomaticas as tinyint
Declare	@FechaAuditoria as datetime
Declare	@HoraAuditoria datetime
Declare	@IdUsuarioModifica int
	
DECLARE Registros CURSOR FOR
SELECT t1.*
  FROM @tabla1 t1
 WHERE SUBSTRING(t1.NumeroCuenta,@Estructura1+2,@Estructura2) NOT IN (SELECT SUBSTRING(t2.NumeroCuenta,@Estructura1+2,@Estructura2)
                          FROM @tabla2 t2)
OPEN Registros
	FETCH NEXT FROM Registros INTO  @IdCuentaContable, @IdPartidaGIas, @NumeroCuenta, @NombreCuenta, @IdCuentaAfectacion, 
	 @CuentaAcumulacion, @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
	 @Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
	 @Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
	 @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica 
	WHILE @@FETCH_STATUS = 0
		BEGIN
	
				 INSERT INTO [dbo].[C_Contable]  VALUES ((select MAX(IdCuentaContable) from C_Contable) +1, @IdPartidaGIas, (SELECT REPLACE(@NumeroCuenta,'814','812')), @NombreCuenta, (Select IdCuentaContable from C_Contable Where NumeroCuenta = ('812'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)), 
			(Select Replace(@CuentaAcumulacion,'814','812')), @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
			@Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
			@Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
		    @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica)			
   
   
		   FETCH NEXT FROM Registros INTO @IdCuentaContable, @IdPartidaGIas, @NumeroCuenta, @NombreCuenta, @IdCuentaAfectacion, 
		 @CuentaAcumulacion, @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
		 @Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
		 @Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
		 @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica 

		END
CLOSE Registros
DEALLOCATE Registros

--------------------------------------------81300-81200------------------------------------------------------------------------
Delete from @tabla1
Delete from @tabla2

Insert into @tabla1
Select * from C_Contable Where NumeroCuenta like '8130%'

Insert into @tabla2
Select * from C_Contable Where NumeroCuenta like '8120%'


DECLARE Registros2 CURSOR FOR
SELECT t1.*
  FROM @tabla1 t1
 WHERE SUBSTRING(t1.NumeroCuenta,@Estructura1+2,@Estructura2) NOT IN (SELECT SUBSTRING(t2.NumeroCuenta,@Estructura1+2,@Estructura2)
                          FROM @tabla2 t2)
OPEN Registros2
	FETCH NEXT FROM Registros2 INTO  @IdCuentaContable, @IdPartidaGIas, @NumeroCuenta, @NombreCuenta, @IdCuentaAfectacion, 
	 @CuentaAcumulacion, @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
	 @Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
	 @Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
	 @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica 
	WHILE @@FETCH_STATUS = 0
		BEGIN
	
				 INSERT INTO [dbo].[C_Contable]  VALUES ((select MAX(IdCuentaContable) from C_Contable) +1, @IdPartidaGIas, (SELECT REPLACE(@NumeroCuenta,'813','812')), @NombreCuenta, (Select IdCuentaContable from C_Contable Where NumeroCuenta = ('812'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)), 
			(Select Replace(@CuentaAcumulacion,'813','812')), @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
			@Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
			@Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
		    @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica)			
   
   
		   FETCH NEXT FROM Registros2 INTO @IdCuentaContable, @IdPartidaGIas, @NumeroCuenta, @NombreCuenta, @IdCuentaAfectacion, 
		 @CuentaAcumulacion, @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
		 @Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
		 @Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
		 @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica 

		END
CLOSE Registros2
DEALLOCATE Registros2

--Select * from @tabla3
---------------------------------------------------------------
-----------------------------------81200-81100------------------------------------------------------------
Delete from @tabla1
Delete from @tabla2

Insert into @tabla1
Select * from C_Contable Where NumeroCuenta like '8120%'

Insert into @tabla2
Select * from C_Contable Where NumeroCuenta like '8110%'

DECLARE Registros3 CURSOR FOR
SELECT t1.*
  FROM @tabla1 t1
 WHERE SUBSTRING(t1.NumeroCuenta,@Estructura1+2,@Estructura2) NOT IN (SELECT SUBSTRING(t2.NumeroCuenta,@Estructura1+2,@Estructura2)
                          FROM @tabla2 t2)
OPEN Registros3
	FETCH NEXT FROM Registros3 INTO  @IdCuentaContable, @IdPartidaGIas, @NumeroCuenta, @NombreCuenta, @IdCuentaAfectacion, 
	 @CuentaAcumulacion, @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
	 @Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
	 @Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
	 @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica 
	WHILE @@FETCH_STATUS = 0
		BEGIN
	
				 INSERT INTO [dbo].[C_Contable]  VALUES ((select MAX(IdCuentaContable) from C_Contable) +1, @IdPartidaGIas, (SELECT REPLACE(@NumeroCuenta,'812','811')), @NombreCuenta, (Select IdCuentaContable from C_Contable Where NumeroCuenta = ('811'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)), 
			(Select Replace(@CuentaAcumulacion,'812','811')), @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
			@Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
			@Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
		    @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica)			
   
   
		   FETCH NEXT FROM Registros3 INTO @IdCuentaContable, @IdPartidaGIas, @NumeroCuenta, @NombreCuenta, @IdCuentaAfectacion, 
		 @CuentaAcumulacion, @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
		 @Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
		 @Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
		 @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica 

		END
CLOSE Registros3
DEALLOCATE Registros3
---------------------------------------------------------------
-----------------------------------------82400-82200--------------------------
Delete from @tabla1
Delete from @tabla2

Insert into @tabla1
Select * from C_Contable Where NumeroCuenta like '8240%'

Insert into @tabla2
Select * from C_Contable Where NumeroCuenta like '8220%'

DECLARE Registros4 CURSOR FOR
SELECT t1.*
  FROM @tabla1 t1
 WHERE SUBSTRING(t1.NumeroCuenta,@Estructura1+2,@Estructura2) NOT IN (SELECT SUBSTRING(t2.NumeroCuenta,@Estructura1+2,@Estructura2)
                          FROM @tabla2 t2)
OPEN Registros4
	FETCH NEXT FROM Registros4 INTO  @IdCuentaContable, @IdPartidaGIas, @NumeroCuenta, @NombreCuenta, @IdCuentaAfectacion, 
	 @CuentaAcumulacion, @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
	 @Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
	 @Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
	 @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica 
	WHILE @@FETCH_STATUS = 0
		BEGIN
	
				 INSERT INTO [dbo].[C_Contable]  VALUES ((select MAX(IdCuentaContable) from C_Contable) +1, @IdPartidaGIas, (SELECT REPLACE(@NumeroCuenta,'824','822')), @NombreCuenta, (Select IdCuentaContable from C_Contable Where NumeroCuenta = ('822'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)), 
			(Select Replace(@CuentaAcumulacion,'824','822')), @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
			@Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
			@Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
		    @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica)			
   
   
		   FETCH NEXT FROM Registros4 INTO @IdCuentaContable, @IdPartidaGIas, @NumeroCuenta, @NombreCuenta, @IdCuentaAfectacion, 
		 @CuentaAcumulacion, @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
		 @Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
		 @Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
		 @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica 

		END
CLOSE Registros4
DEALLOCATE Registros4

---------------------------------------------------82300-82200--------------------------
Delete from @tabla1
Delete from @tabla2

Insert into @tabla1
Select * from C_Contable Where NumeroCuenta like '8230%'

Insert into @tabla2
Select * from C_Contable Where NumeroCuenta like '8220%'

DECLARE Registros5 CURSOR FOR
SELECT t1.*
  FROM @tabla1 t1
 WHERE SUBSTRING(t1.NumeroCuenta,@Estructura1+2,@Estructura2) NOT IN (SELECT SUBSTRING(t2.NumeroCuenta,@Estructura1+2,@Estructura2)
                          FROM @tabla2 t2)
OPEN Registros5
	FETCH NEXT FROM Registros5 INTO  @IdCuentaContable, @IdPartidaGIas, @NumeroCuenta, @NombreCuenta, @IdCuentaAfectacion, 
	 @CuentaAcumulacion, @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
	 @Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
	 @Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
	 @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica 
	WHILE @@FETCH_STATUS = 0
		BEGIN
	
				 INSERT INTO [dbo].[C_Contable]  VALUES ((select MAX(IdCuentaContable) from C_Contable) +1, @IdPartidaGIas, (SELECT REPLACE(@NumeroCuenta,'823','822')), @NombreCuenta, (Select IdCuentaContable from C_Contable Where NumeroCuenta = ('822'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)), 
			(Select Replace(@CuentaAcumulacion,'823','822')), @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
			@Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
			@Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
		    @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica)			
   
   
		   FETCH NEXT FROM Registros5 INTO @IdCuentaContable, @IdPartidaGIas, @NumeroCuenta, @NombreCuenta, @IdCuentaAfectacion, 
		 @CuentaAcumulacion, @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
		 @Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
		 @Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
		 @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica 

		END
CLOSE Registros5
DEALLOCATE Registros5

-----------------------------------------82200-82100--------------------------
Delete from @tabla1
Delete from @tabla2

Insert into @tabla1
Select * from C_Contable Where NumeroCuenta like '8220%'

Insert into @tabla2
Select * from C_Contable Where NumeroCuenta like '8210%'

DECLARE Registros6 CURSOR FOR
SELECT t1.*
  FROM @tabla1 t1
 WHERE SUBSTRING(t1.NumeroCuenta,@Estructura1+2,@Estructura2) NOT IN (SELECT SUBSTRING(t2.NumeroCuenta,@Estructura1+2,@Estructura2)
                          FROM @tabla2 t2)
OPEN Registros6
	FETCH NEXT FROM Registros6 INTO  @IdCuentaContable, @IdPartidaGIas, @NumeroCuenta, @NombreCuenta, @IdCuentaAfectacion, 
	 @CuentaAcumulacion, @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
	 @Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
	 @Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
	 @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica 
	WHILE @@FETCH_STATUS = 0
		BEGIN
	
				 INSERT INTO [dbo].[C_Contable]  VALUES ((select MAX(IdCuentaContable) from C_Contable) +1, @IdPartidaGIas, (SELECT REPLACE(@NumeroCuenta,'822','821')), @NombreCuenta, (Select IdCuentaContable from C_Contable Where NumeroCuenta = ('821'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)), 
			(Select Replace(@CuentaAcumulacion,'822','821')), @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
			@Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
			@Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
		    @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica)			
   
   
		   FETCH NEXT FROM Registros6 INTO @IdCuentaContable, @IdPartidaGIas, @NumeroCuenta, @NombreCuenta, @IdCuentaAfectacion, 
		 @CuentaAcumulacion, @TipoCuenta, @Afectable, @Nivel, @Alta, @Exportada, 
		 @Financiero, @AfectaDisponibilidad, @IdSelloPresupuestal, @IdCuentaContableMayor, 
		 @Utilizar, @Armonizado, @Observaciones, @SuSaldoRepresenta, @Descripcion, @Fecha, 
		 @SaldarCierreEjercicio, @CrearSubcuentasAutomaticas, @FechaAuditoria, @HoraAuditoria, @IdUsuarioModifica 

		END
CLOSE Registros6
DEALLOCATE Registros6


Update C_Contable Set TipoCuenta = 'I' where NumeroCuenta like '814%'
Update C_Contable Set TipoCuenta = 'J' where NumeroCuenta like '812%'
Update C_Contable Set TipoCuenta = 'J' where NumeroCuenta like '813%'
Update C_Contable Set TipoCuenta = 'J' where NumeroCuenta like '814%'


Update C_Contable Set TipoCuenta = 'J' where NumeroCuenta like '821%'
Update C_Contable Set TipoCuenta = 'I' where NumeroCuenta like '822%'
Update C_Contable Set TipoCuenta = 'I' where NumeroCuenta like '823%'
Update C_Contable Set TipoCuenta = 'I' where NumeroCuenta like '824%'

--#################################################################################################################################################

END --procedimiento

GO