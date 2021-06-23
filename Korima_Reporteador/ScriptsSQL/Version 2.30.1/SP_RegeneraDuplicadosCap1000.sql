
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].SP_RegeneraDuplicadosCap1000') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].SP_RegeneraDuplicadosCap1000
GO

-- Exec SP_RegeneraDuplicadosCap1000 2021
CREATE PROCEDURE  [dbo].[SP_RegeneraDuplicadosCap1000]  

 @Ejercicio int

AS

Declare @tabla as table (
		IdSelloPresupuestal int
      ,IdPoliza int
      ,Importe decimal(18,2)
   )

Declare @Rows as table (
	  IdMov int,	  
	  IdSelloPresupuestal int,
	  IdMovimiento int,
      fecha datetime,
      IdPoliza int
   )

   Declare @Final as table (
	  IdMov int,	  
	  IdSelloPresupuestal int,
	  Periodo int,
      Mes int
      --IdPoliza int
   )

declare @IdMov integer
declare @IdMovMin integer
declare @IdMovMax integer
declare @IdMovimiento integer
declare @IdMovimientoFinal integer
declare @IdSelloPresupuestal integer
declare @IdSelloRegenera integer
declare @Periodo integer
declare @Mes integer
declare @IdPoliza integer
declare @fecha datetime
declare @fechafinal datetime
declare @Importe decimal(18,2)

BEGIN
SET NOCOUNT ON

Insert into @tabla
Select distinct IdSelloPresupuestal, IdPoliza, Importe from T_AfectacionPresupuesto
Where Periodo = @Ejercicio and IdPoliza > 0 and TipoAfectacion = 'C' and TipoMovimientoGenera='M' 
group by IdSelloPresupuestal, IdPoliza, Importe having count(IdMov) > 1
order by IdSelloPresupuestal


	Declare CICLOPRINCIPAL cursor for		
	select  IdSelloPresupuestal, IdPoliza, Importe from @tabla
	OPEN CICLOPRINCIPAL
	FETCH NEXT FROM CICLOPRINCIPAL
	INTO @IdSelloPresupuestal, @IdPoliza, @Importe 
	WHILE @@fetch_status = 0
	BEGIN
	

--------------------------------
	IF (Select ComprometerInicio from C_PartidasPres join T_SellosPresupuestales on T_SellosPresupuestales.IdPartida = C_PartidasPres.IdPartida Where T_SellosPresupuestales.IdSelloPresupuestal = @IdSelloPresupuestal) = 1
	BEGIN
	
	Insert into @Rows
	Select IdMov, IdSelloPresupuestal, IdMovimiento, Fecha, IdPoliza from T_AfectacionPresupuesto where IdSelloPresupuestal = @IdSelloPresupuestal and IdPoliza = @IdPoliza and Importe = @Importe
		
		if exists (select * from @Rows where IdMovimiento = 0)
		    BEGIN
			
  			        Declare CICLOAFECTA cursor for		
					Select IdMov, IdMovimiento, Fecha FROM @Rows 
					OPEN CICLOAFECTA
					FETCH NEXT FROM CICLOAFECTA
					INTO @IdMov, @IdMovimiento, @Fecha
					WHILE @@fetch_status = 0
					BEGIN
						set @IdMovMin = (Select min(IdMov) from @Rows)
						set @IdMovMax = (Select max(IdMov) from @Rows)
                       
                      IF @IdMovimiento > 0
					  set @IdMovimientoFinal = @IdMovimiento

					  IF @fecha is not null
					  set @fechafinal = @fecha

					
					FETCH NEXT FROM CICLOAFECTA
					INTO @IdMov, @IdMovimiento, @Fecha
					END      
					CLOSE CICLOAFECTA
					DEALLOCATE CICLOAFECTA
         
		
					  update T_AfectacionPresupuesto set Fecha = @fechafinal where IdMov = @IdMovMax
					  delete from T_AfectacionPresupuesto where IdMov = @IdMovMin
					  delete from @Rows

					 
					  Insert into @Final
					  Select  IdMov, IdSelloPresupuestal,Periodo,Mes from T_AfectacionPresupuesto where IdMov = @IdMovMax
	  
      
			END
   END
				delete from @Rows
--------------------------------	
							
	FETCH NEXT FROM CICLOPRINCIPAL
	INTO	@IdSelloPresupuestal,@IdPoliza,@Importe 
	END      
	CLOSE CICLOPRINCIPAL
	DEALLOCATE CICLOPRINCIPAL


					Declare CICLOREGENERA cursor for		
					select Periodo, Mes, IdSelloPresupuestal FROM @Final
					OPEN CICLOREGENERA
					FETCH NEXT FROM CICLOREGENERA
					INTO @Periodo, @Mes, @IdSelloRegenera 
					WHILE @@fetch_status = 0
					BEGIN
					

                         EXEC SP_RegeneraSaldosPresupuestalesxMes @Periodo, @Mes, @IdSelloRegenera
                      
					
					FETCH NEXT FROM CICLOREGENERA
					INTO	@Periodo, @Mes, @IdSelloRegenera 
					END      
					CLOSE CICLOREGENERA
					DEALLOCATE CICLOREGENERA
	
END