IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].SP_RegeneraSaldosPresupuestalesxMes') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].SP_RegeneraSaldosPresupuestalesxMes
GO
-- =============================================
-- Author:		<Ing. Blanca Estela Rodríguez Ramos>
-- Create date: <17 Agosto 2016>
-- Description:	<SP para Regeneración de Saldos Presupuestales de Egresos por mes y por mes - sello>
-- =============================================
-- Author:		PRodriguez
-- Modify Date: 20191113
-- Description: Restar las devoluciones
-- =============================================
-- Author:		PRodriguez
-- Modify Date: 20200129
-- Description: Se agrega protección contra valores nulos en calculo de importes (Campos:  ISNULL(T_Polizas.IdPolizaCancelacion,0))
-- =============================================
-- Author:		PRodriguez
-- Modify Date: 20200812
-- Description: Se agrega validación para omitir los registros de afectación presupuestal con poliza -1. Bug KOR-252
-- =============================================
-- Author:		PRodriguez
-- Modify Date: 2021-06-21
-- Description: Se agrega validación para no se guarde valor nulo en el campo del comprometido Bug KOR-512
-- =============================================

-- Exec SP_RegeneraSaldosPresupuestalesxMes 2021,1,0
CREATE PROCEDURE  [dbo].[SP_RegeneraSaldosPresupuestalesxMes]  

 @ejercicio int,
 @mes int,
 @IdSello int

AS

declare @idSelloPres int
declare @idPartida int
declare @TipoCancelacion int

declare @ImporteTemp decimal(21,2)
declare @CargosC decimal(21,2)
declare @CargosD decimal(21,2)
declare @CargosE decimal(21,2)
declare @CargosP decimal(21,2)

declare @AbonosC decimal(21,2)
declare @AbonosD decimal(21,2)
declare @AbonosE decimal(21,2)
declare @AbonosP decimal(21,2)

-- @PRodriguez 20191113 B0560
Declare @DevolucionesC decimal(21,2)
Declare @DevolucionesD decimal(21,2)
Declare @DevolucionesE decimal(21,2)
Declare @DevolucionesP decimal(21,2)
-- @PRodriguez 20191113 B0560


BEGIN

    -- ******* Para el caso de regeneración de Presupuesto por mes   ******************** ----
 Set @TipoCancelacion = (Select IDCATALOGO from T_ParametrosContables where NOMBREPARAMETRO like 'CANCELACION POLIZAS EN NEGATIVO')

 if @TipoCancelacion =  1	--Pólizas canceladas en negativo
 begin 
 	   
    If @IdSello = 0 
    begin

		-- ************* Actualizo en Cero los momentos presupuestales de acuerdo a los parámetros ************* ---------
	    
		Update T_PresupuestoNW set Comprometido=0, Devengado=0, Ejercido=0, Pagado=0  where YEAR=@ejercicio and mes=@mes 
	    	    
		-- ************* Recorro Sellos de acuerdo al ejercicio.
		Declare CICLOPRINCIPAL cursor for		
		Select IdSelloPresupuestal,IdPartida FROM T_SellosPresupuestales where LYear= @ejercicio  
		OPEN CICLOPRINCIPAL
		FETCH NEXT FROM CICLOPRINCIPAL
		INTO @idSelloPres, @IdPartida
		WHILE @@fetch_status = 0
		BEGIN

		---- ************* Afectación del Comprometido ************* ---------
			if ((@IdPartida > 2000 and @IdPartida < 9999) or (@IdPartida > 20000 and @IdPartida < 99999)
				or (@IdPartida > 200000 and @IdPartida < 999999))
				begin

				Exec Presupuesto_Autorizado_Ejercicio_Mes_Sello @ejercicio,@mes,@idSelloPres

					set @CargosC = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '824%'
					and T_Polizas.NoPoliza > 0	
					AND T_Polizas.IdPoliza NOT IN (SELECT distinct nc.IdPoliza FROM T_NotaCredito nc INNER JOIN  T_Polizas tp  ON nc.IdPoliza = tp.IdPoliza) -- Omite NC --@PRodriguez 20191114 B0560				
					)
							SET @CargosC = ISNULL(@CargosC,0.00) --@PRodriguez 20210621 KOR-512

							If exists (Select Comprometido from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Comprometido = @CargosC where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Comprometido from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,@CargosC,0,0,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end					
					 -- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
					 IF EXISTS(SELECT 1 
					            FROM T_AfectacionPresupuesto 
					            WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'C' AND TipoMovimientoGenera = 'W') )
				     BEGIN					      
						  SELECT  @DevolucionesC = SUM(Importe) 
					      FROM T_AfectacionPresupuesto 
					      WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'C' AND TipoMovimientoGenera = 'W')
								AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

						  SET @DevolucionesC = ISNULL(@DevolucionesC,0.00) --@PRodriguez 20210621 KOR-512

						  Update T_PresupuestoNW set Comprometido = (Comprometido + @DevolucionesC) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
					 END
					 -- Quitar las devoluciones  -- @PRodriguez 20191113 B0560

				end
				else --Capitulo 1000, cambia la forma de la obtención del comprometido
					begin						
						------------------------------------------------------------
						Exec Presupuesto_Autorizado_Ejercicio_Mes_Sello @ejercicio,@mes,@idSelloPres
						
						-- Para considerar las pólizas que no vienen de un proceso administrativo
						set @CargosC = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
						inner join c_contable
						on d_polizas.IdCuentaContable = c_contable.idcuentacontable
						inner join T_Sellospresupuestales
						on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
						inner join T_Polizas
						on t_polizas.idpoliza = d_polizas.idpoliza
						where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '824%'
						and T_Polizas.NoPoliza > 0 and T_Polizas.IdPoliza Not in (Select IdPoliza from T_AfectacionPresupuesto where TipoAfectacion = 'C' AND Mes=@mes  And Periodo = @ejercicio )
						)
							SET @CargosC = ISNULL(@CargosC,0.00) --@PRodriguez 20210621 KOR-512

							If exists (Select Comprometido from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Comprometido = @CargosC where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Comprometido from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,@CargosC,0,0,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end

					-- Para considerar la regeneración del capitulo 1000 desde un proceso administrativo
							set @ImporteTemp = (Select Comprometido from T_PresupuestoNW where Year = @ejercicio and Mes = @mes and IdSelloPresupuestal = @idSelloPres)
							
							set @CargosC = (isnull(@ImporteTemp,0) + ISNULL((Select sum(ISNULL(importe,0)) from T_AfectacionPresupuesto
								where TipoAfectacion = 'C' and (TipoMovimientoGenera = 'M' OR TipoMovimientoGenera = 'S') 
								and Periodo = @ejercicio and Mes = @mes and IdSelloPresupuestal = @idSelloPres AND (IdPoliza > 0) ) ,0)   ) -- @PRodriguez 20200812 KOR-252

							SET @CargosC = ISNULL(@CargosC,0.00) --@PRodriguez 20210621 KOR-512

							Update T_PresupuestoNW set Comprometido = @CargosC where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres

						-------------------------------------------------------------
					end
    -- ************* Afectación del Devengado  ************* ---------
    
					set @CargosD = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '825%'
					and T_Polizas.NoPoliza > 0
					)


							If exists (Select Devengado from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Devengado = @CargosD where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Devengado from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,0,@CargosD,0,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end

							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'D' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesD = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'D' AND TipoMovimientoGenera = 'W')
							      AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								Update T_PresupuestoNW set Devengado = (Devengado + @DevolucionesD) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560


    -- ************* Afectación del Ejercido  ************* ---------
    
					set @CargosE = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '826%'
					and T_Polizas.NoPoliza > 0					
					)


							If exists (Select Ejercido from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Ejercido = @CargosE where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Ejercido from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,0,0,@CargosE,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end


							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'E' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesE = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'E' AND TipoMovimientoGenera = 'W')
								  AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								Update T_PresupuestoNW set Ejercido = (Ejercido + @DevolucionesE) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560


	
    -- ************* Afectación del Pagado  ************* ---------
    
					set @CargosP = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '827%'
					and T_Polizas.NoPoliza > 0					
					)


							If exists (Select Pagado from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Pagado = @CargosP where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Pagado from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,0,0,0,@CargosP,0,0,0,0,0,0,0,0,0,0,null,null)
							end

							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'P' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesP = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'P' AND TipoMovimientoGenera = 'W')
							      AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								Update T_PresupuestoNW set Pagado = (Pagado + @DevolucionesP) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560


		FETCH NEXT FROM CICLOPRINCIPAL
		INTO	@idSelloPres, @IdPartida
		END      
		CLOSE CICLOPRINCIPAL
		DEALLOCATE CICLOPRINCIPAL

    end
    
    -- ******* Para el caso de regeneración de Presupuesto por mes y Sello  ******************** ----    
    If @IdSello > 0 
    begin
		-- ************* Actualizo en Cero los momentos presupuestales de acuerdo a los parámetros ************* ---------	    
		Update T_PresupuestoNW set Comprometido=0, Devengado=0, Ejercido=0, Pagado=0  where YEAR=@ejercicio and mes=@mes and IdSelloPresupuestal = @IdSello	    	   
		-- ************* Recorro Sellos de acuerdo al ejercicio.
		Declare CICLOPRINCIPAL cursor for		
		select  IdSelloPresupuestal,IdPartida FROM T_SellosPresupuestales where LYear= @ejercicio and IdSelloPresupuestal = @IdSello 			
		OPEN CICLOPRINCIPAL
		FETCH NEXT FROM CICLOPRINCIPAL
		INTO @idSelloPres, @IdPartida
		WHILE @@fetch_status = 0
		BEGIN

		---- ************* Afectación del Comprometido ************* ---------
				if ((@IdPartida > 2000 and @IdPartida < 9999) or (@IdPartida > 20000 and @IdPartida < 99999)
					or (@IdPartida > 200000 and @IdPartida < 999999))
				begin	

					Exec Presupuesto_Autorizado_Ejercicio_Mes_Sello @ejercicio,@mes,@idSelloPres

					set @CargosC = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '824%'					
					and T_Polizas.NoPoliza > 0 
					AND T_Polizas.IdPoliza NOT IN (SELECT distinct nc.IdPoliza FROM T_NotaCredito nc INNER JOIN  T_Polizas tp  ON nc.IdPoliza = tp.IdPoliza) -- Omite NC --@PRodriguez 20191114 B0560
					)

							SET @CargosC = ISNULL(@CargosC,0.00) --@PRodriguez 20210621 KOR-512

							If exists (Select Comprometido from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 	
							     Update T_PresupuestoNW set Comprometido = @CargosC where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Comprometido from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,@CargosC,0,0,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end

							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'C' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesC = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'C' AND TipoMovimientoGenera = 'W')
								  AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								SET @DevolucionesC = ISNULL(@DevolucionesC,0.00) --@PRodriguez 20210621 KOR-512

								Update T_PresupuestoNW set Comprometido = (Comprometido + @DevolucionesC) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
				end
				else --Capitulo 1000, cambia la forma de la obtención del comprometido
					begin						
						------------------------------------------------------------
						Exec Presupuesto_Autorizado_Ejercicio_Mes_Sello @ejercicio,@mes,@idSelloPres

						-- Para considerar las pólizas que no vienen de un proceso administrativo
						set @CargosC = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
						inner join c_contable
						on d_polizas.IdCuentaContable = c_contable.idcuentacontable
						inner join T_Sellospresupuestales
						on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
						inner join T_Polizas
						on t_polizas.idpoliza = d_polizas.idpoliza
						where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '824%'
						and T_Polizas.NoPoliza > 0 and T_Polizas.IdPoliza Not in (Select IdPoliza from T_AfectacionPresupuesto where TipoAfectacion = 'C' AND Mes=@mes  And Periodo = @ejercicio )
						)
							SET @CargosC = ISNULL(@CargosC,0.00) --@PRodriguez 20210621 KOR-512
							If exists (Select Comprometido from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Comprometido = @CargosC where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Comprometido from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,@CargosC,0,0,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end

					-- Para considerar la regeneración del capitulo 1000 desde un proceso administrativo
							set @ImporteTemp = (Select Comprometido from T_PresupuestoNW where Year = @ejercicio and Mes = @mes and IdSelloPresupuestal = @idSelloPres)
							
							set @CargosC = (isnull(@ImporteTemp,0) + ISNULL((Select sum(ISNULL(importe,0)) from T_AfectacionPresupuesto
								where TipoAfectacion = 'C' and (TipoMovimientoGenera = 'M' OR TipoMovimientoGenera = 'S') 
								and Periodo = @ejercicio and Mes = @mes and IdSelloPresupuestal = @idSelloPres  AND (IdPoliza > 0) ),0) ) --@PRodriguez 20200812 KOR-252

							Update T_PresupuestoNW set Comprometido = @CargosC where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres

						-------------------------------------------------------------
					end



    -- ************* Afectación del Devengado  ************* ---------
    
					set @CargosD = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '825%'	
					and T_Polizas.NoPoliza > 0				
					)


							If exists (Select Devengado from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Devengado = @CargosD where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Devengado from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,0,@CargosD,0,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end

							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'D' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesD = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'D' AND TipoMovimientoGenera = 'W')
								  AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								Update T_PresupuestoNW set Devengado = (Devengado + @DevolucionesD) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560


    -- ************* Afectación del Ejercido  ************* ---------
    
					set @CargosE = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '826%'
					and T_Polizas.NoPoliza > 0					
					)


							If exists (Select Ejercido from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Ejercido = @CargosE where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Ejercido from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,0,0,@CargosE,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end

							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'E' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesE = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'E' AND TipoMovimientoGenera = 'W')
								 AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								Update T_PresupuestoNW set Ejercido = (Ejercido + @DevolucionesE) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560

	
    -- ************* Afectación del Pagado  ************* ---------
    
					set @CargosP = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '827%'
					and T_Polizas.NoPoliza > 0					
					)


							If exists (Select Pagado from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Pagado = @CargosP where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Pagado from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,0,0,0,@CargosP,0,0,0,0,0,0,0,0,0,0,null,null)
							end

							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'P' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesP = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'P' AND TipoMovimientoGenera = 'W')
								  AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								Update T_PresupuestoNW set Pagado = (Pagado + @DevolucionesP) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560


		FETCH NEXT FROM CICLOPRINCIPAL
		INTO	@idSelloPres,@idPartida
		END      
		CLOSE CICLOPRINCIPAL
		DEALLOCATE CICLOPRINCIPAL

    end    
 End
 Else	--**************--Pólizas canceladas en sentido inverso***************************************************************
  Begin
 --------------
 If @IdSello = 0 
    begin

		-- ************* Actualizo en Cero los momentos presupuestales de acuerdo a los parámetros ************* ---------
	    
		Update T_PresupuestoNW set Comprometido=0, Devengado=0, Ejercido=0, Pagado=0  where YEAR=@ejercicio and mes=@mes 
	    	    
		-- ************* Recorro Sellos de acuerdo al ejercicio.
		Declare CICLOPRINCIPAL cursor for		
		Select IdSelloPresupuestal,IdPartida FROM T_SellosPresupuestales where LYear= @ejercicio  
		OPEN CICLOPRINCIPAL
		FETCH NEXT FROM CICLOPRINCIPAL
		INTO @idSelloPres, @IdPartida
		WHILE @@fetch_status = 0
		BEGIN

		---- ************* Afectación del Comprometido ************* ---------
			if ((@IdPartida > 2000 and @IdPartida < 9999) or (@IdPartida > 20000 and @IdPartida < 99999)
				or (@IdPartida > 200000 and @IdPartida < 999999))
				begin

					Exec Presupuesto_Autorizado_Ejercicio_Mes_Sello @ejercicio,@mes,@idSelloPres

					set @CargosC = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '824%'
					and T_Polizas.NoPoliza > 0 and ISNULL(T_Polizas.IdPolizaCancelacion,0) = 0 and C_TipoMovPolizas.CancelaManual = 0
					
					)

					SET @CargosC = ISNULL(@CargosC,0.00) --@PRodriguez 20210621 KOR-512

					set @AbonosC = (Select isnull(sum(D_Polizas.importeabono),0) as importeabono from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '824%'
					and T_Polizas.NoPoliza > 0 and (ISNULL(T_Polizas.IdPolizaCancelacion,0) = 1 or C_TipoMovPolizas.CancelaManual = 1)
					)

					SET @AbonosC = ISNULL(@AbonosC,0.00) --@PRodriguez 20210621 KOR-512

							If exists (Select Comprometido from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Comprometido = (@CargosC - @AbonosC) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Comprometido from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,@CargosC - @AbonosC,0,0,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end

							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'C' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesC = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'C' AND TipoMovimientoGenera = 'W')
								  AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								SET @DevolucionesC = ISNULL(@DevolucionesC,0.00) --@PRodriguez 20210621 KOR-512

								Update T_PresupuestoNW set Comprometido = (Comprometido + @DevolucionesC) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560

				
				end
				else --Capitulo 1000, cambia la forma de la obtención del comprometido
					begin						
						------------------------------------------------------------
						Exec Presupuesto_Autorizado_Ejercicio_Mes_Sello @ejercicio,@mes,@idSelloPres

						-- Para considerar las pólizas que no vienen de un proceso administrativo
						set @CargosC = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
						inner join c_contable
						on d_polizas.IdCuentaContable = c_contable.idcuentacontable
						inner join T_Sellospresupuestales
						on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
						inner join T_Polizas
						on t_polizas.idpoliza = d_polizas.idpoliza
						where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '824%'
						and T_Polizas.NoPoliza > 0 and T_Polizas.IdPoliza Not in (Select IdPoliza from T_AfectacionPresupuesto where TipoAfectacion = 'C' AND Mes=@mes  And Periodo = @ejercicio )
						)
							SET @CargosC = ISNULL(@CargosC,0.00) --@PRodriguez 20210621 KOR-512

							If exists (Select Comprometido from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Comprometido = @CargosC where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Comprometido from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,@CargosC,0,0,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end

					-- Para considerar la regeneración del capitulo 1000 desde un proceso administrativo
							set @ImporteTemp = (Select Comprometido from T_PresupuestoNW where Year = @ejercicio and Mes = @mes and IdSelloPresupuestal = @idSelloPres)
							
							SET @ImporteTemp = ISNULL(@ImporteTemp,0.00) --@PRodriguez 20210621 KOR-512

							set @CargosC = (isnull(@ImporteTemp,0) + ISNULL((Select sum(ISNULL(importe,0)) from T_AfectacionPresupuesto
								where TipoAfectacion = 'C' and (TipoMovimientoGenera = 'M' OR TipoMovimientoGenera = 'S')
								and Periodo = @ejercicio and Mes = @mes and IdSelloPresupuestal = @idSelloPres AND (IdPoliza > 0)  ),0) ) --@PRodriguez 20200812 KOR-252

							SET @CargosC = ISNULL(@CargosC,0.00) --@PRodriguez 20210621 KOR-512

							Update T_PresupuestoNW set Comprometido = @CargosC where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres

						-------------------------------------------------------------
					end
    -- ************* Afectación del Devengado  ************* ---------
    
					set @CargosD = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '825%'
					and T_Polizas.NoPoliza > 0 and ISNULL(T_Polizas.IdPolizaCancelacion,0) = 0 and C_TipoMovPolizas.CancelaManual = 0
					)

					set @AbonosD = (Select isnull(sum(D_Polizas.importeabono),0) as importeabono from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '825%'
					and T_Polizas.NoPoliza > 0 and (ISNULL(T_Polizas.IdPolizaCancelacion,0) = 1 or C_TipoMovPolizas.CancelaManual = 1)
					)

							If exists (Select Devengado from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Devengado = (@CargosD - @AbonosD) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Devengado from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,0,@CargosD-@AbonosD,0,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end


							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'D' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesD = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'D' AND TipoMovimientoGenera = 'W')
								  AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								Update T_PresupuestoNW set Devengado = (Devengado + @DevolucionesD) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560


    -- ************* Afectación del Ejercido  ************* ---------
    
					set @CargosE = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '826%'
					and T_Polizas.NoPoliza > 0 and ISNULL(T_Polizas.IdPolizaCancelacion,0) = 0 and C_TipoMovPolizas.CancelaManual = 0					
					)

					set @AbonosE = (Select isnull(sum(D_Polizas.importeabono),0) as importeabono from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '826%'
					and T_Polizas.NoPoliza > 0 and (ISNULL(T_Polizas.IdPolizaCancelacion,0) = 1 or C_TipoMovPolizas.CancelaManual = 1)
					)

							If exists (Select Ejercido from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Ejercido = (@CargosE - @AbonosE) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Ejercido from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,0,0,@CargosE-@AbonosE,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end

							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'E' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesE = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'E' AND TipoMovimientoGenera = 'W')
								 AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								Update T_PresupuestoNW set Ejercido = (Ejercido + @DevolucionesE) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							
								
    -- ************* Afectación del Pagado  ************* ---------
    
					set @CargosP = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '827%'
					and T_Polizas.NoPoliza > 0 and ISNULL(T_Polizas.IdPolizaCancelacion,0) = 0 and C_TipoMovPolizas.CancelaManual = 0
					)


					set @AbonosP = (Select isnull(sum(D_Polizas.importeabono),0) as importeabono from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '827%'
					and T_Polizas.NoPoliza > 0 and (ISNULL(T_Polizas.IdPolizaCancelacion,0) = 1 or C_TipoMovPolizas.CancelaManual = 1)
					)


							If exists (Select Pagado from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Pagado = (@CargosP - @AbonosP) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Pagado from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,0,0,0,@CargosP-@AbonosP,0,0,0,0,0,0,0,0,0,0,null,null)
							end


							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'P' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesP = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'P' AND TipoMovimientoGenera = 'W')
								  AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								Update T_PresupuestoNW set Pagado = (Pagado + @DevolucionesP) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560


		FETCH NEXT FROM CICLOPRINCIPAL
		INTO	@idSelloPres, @IdPartida
		END      
		CLOSE CICLOPRINCIPAL
		DEALLOCATE CICLOPRINCIPAL

    end
    
    -- ******* Para el caso de regeneración de Presupuesto por mes y Sello  ******************** ----
    
    If @IdSello > 0 
    begin

		-- ************* Actualizo en Cero los momentos presupuestales de acuerdo a los parámetros ************* ---------
	    
		Update T_PresupuestoNW set Comprometido=0, Devengado=0, Ejercido=0, Pagado=0  where YEAR=@ejercicio and mes=@mes and IdSelloPresupuestal = @IdSello
	    
	    

		-- ************* Recorro Sellos de acuerdo al ejercicio.
		Declare CICLOPRINCIPAL cursor for		
		select  IdSelloPresupuestal,IdPartida FROM T_SellosPresupuestales where LYear= @ejercicio and IdSelloPresupuestal = @IdSello 			
		OPEN CICLOPRINCIPAL
		FETCH NEXT FROM CICLOPRINCIPAL
		INTO @idSelloPres, @IdPartida
		WHILE @@fetch_status = 0
		BEGIN

		---- ************* Afectación del Comprometido ************* ---------
				if ((@IdPartida > 2000 and @IdPartida < 9999) or (@IdPartida > 20000 and @IdPartida < 99999)
					or (@IdPartida > 200000 and @IdPartida < 999999))
				begin
				
					Exec Presupuesto_Autorizado_Ejercicio_Mes_Sello @ejercicio,@mes,@idSelloPres

					set @CargosC = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '824%'
					and T_Polizas.NoPoliza > 0 and ISNULL(T_Polizas.IdPolizaCancelacion,0) = 0 and C_TipoMovPolizas.CancelaManual = 0
					)
					SET @CargosC = ISNULL(@CargosC,0.00) --@PRodriguez 20210621 KOR-512

					set @AbonosC = (Select isnull(sum(D_Polizas.importeabono),0) as importeabono from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '824%'
					and T_Polizas.NoPoliza > 0 and (ISNULL(T_Polizas.IdPolizaCancelacion,0) = 1 or C_TipoMovPolizas.CancelaManual = 1)
					)
					SET @AbonosC = ISNULL(@AbonosC,0.00) --@PRodriguez 20210621 KOR-512

							If exists (Select Comprometido from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Comprometido = (@CargosC - @AbonosC) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Comprometido from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,@CargosC - @AbonosC,0,0,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end

							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'C' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesC = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'C' AND TipoMovimientoGenera = 'W')
								  AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								SET @DevolucionesC = ISNULL(@DevolucionesC,0.00) --@PRodriguez 20210621 KOR-512

								Update T_PresupuestoNW set Comprometido = (Comprometido + @DevolucionesC) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560

				end
				else --Capitulo 1000, cambia la forma de la obtención del comprometido
					begin						
						------------------------------------------------------------
						Exec Presupuesto_Autorizado_Ejercicio_Mes_Sello @ejercicio,@mes,@idSelloPres

						-- Para considerar las pólizas que no vienen de un proceso administrativo
						set @CargosC = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
						inner join c_contable
						on d_polizas.IdCuentaContable = c_contable.idcuentacontable
						inner join T_Sellospresupuestales
						on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
						inner join T_Polizas
						on t_polizas.idpoliza = d_polizas.idpoliza
						where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '824%'
						and T_Polizas.NoPoliza > 0 and T_Polizas.IdPoliza Not in (Select IdPoliza from T_AfectacionPresupuesto where TipoAfectacion = 'C' AND Mes=@mes  And Periodo = @ejercicio )
						)
							SET @CargosC = ISNULL(@CargosC,0.00) --@PRodriguez 20210621 KOR-512
							If exists (Select Comprometido from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Comprometido = @CargosC where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Comprometido from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,@CargosC,0,0,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end

					-- Para considerar la regeneración del capitulo 1000 desde un proceso administrativo
							set @ImporteTemp = (Select Comprometido from T_PresupuestoNW where Year = @ejercicio and Mes = @mes and IdSelloPresupuestal = @idSelloPres)

							SET @ImporteTemp = ISNULL(@ImporteTemp,0.00) --@PRodriguez 20210621 KOR-512

							set @CargosC = (isnull(@ImporteTemp,0) + ISNULL((Select sum(ISNULL(importe,0)) from T_AfectacionPresupuesto
								where TipoAfectacion = 'C' and (TipoMovimientoGenera = 'M' OR TipoMovimientoGenera = 'S') 
								and Periodo = @ejercicio and Mes = @mes and IdSelloPresupuestal = @idSelloPres AND (IdPoliza > 0) ) ,0) )

							SET @CargosC = ISNULL(@CargosC,0.00) --@PRodriguez 20210621 KOR-512

							Update T_PresupuestoNW set Comprometido = @CargosC where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres

						-------------------------------------------------------------
					end



    -- ************* Afectación del Devengado  ************* ---------
    
					set @CargosD = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '825%'
					and T_Polizas.NoPoliza > 0 and ISNULL(T_Polizas.IdPolizaCancelacion,0) = 0 and C_TipoMovPolizas.CancelaManual = 0
					)

					set @AbonosD = (Select isnull(sum(D_Polizas.importeabono),0) as importeabono from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '825%'
					and T_Polizas.NoPoliza > 0 and (ISNULL(T_Polizas.IdPolizaCancelacion,0) = 1 or C_TipoMovPolizas.CancelaManual = 1)
					)

							If exists (Select Devengado from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Devengado = (@CargosD - @AbonosD) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Devengado from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,0,@CargosD-@AbonosD,0,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end

							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'D' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesD = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'D' AND TipoMovimientoGenera = 'W')
								  AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								Update T_PresupuestoNW set Devengado = (Devengado + @DevolucionesD) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560


    -- ************* Afectación del Ejercido  ************* ---------
    
					set @CargosE = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '826%'
					and T_Polizas.NoPoliza > 0 and ISNULL(T_Polizas.IdPolizaCancelacion,0) = 0 and C_TipoMovPolizas.CancelaManual = 0
					)

					set @AbonosE = (Select isnull(sum(D_Polizas.importeabono),0) as importeabono from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '826%'
					and T_Polizas.NoPoliza > 0 and (ISNULL(T_Polizas.IdPolizaCancelacion,0) = 1 or C_TipoMovPolizas.CancelaManual = 1)
					)

							If exists (Select Ejercido from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Ejercido = (@CargosE - @AbonosE) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Ejercido from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,0,0,@CargosE-@AbonosE,0,0,0,0,0,0,0,0,0,0,0,null,null)
							end


							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'E' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesE = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'E' AND TipoMovimientoGenera = 'W')
								  AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								Update T_PresupuestoNW set Ejercido = (Ejercido + @DevolucionesE) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560

	
    -- ************* Afectación del Pagado  ************* ---------
    
					set @CargosP = (Select sum(isnull(D_Polizas.importecargo,0)) as ImporteCargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '827%'
					and T_Polizas.NoPoliza > 0 and ISNULL(T_Polizas.IdPolizaCancelacion,0) = 0 and C_TipoMovPolizas.CancelaManual = 0
					)


					set @AbonosP = (Select isnull(sum(D_Polizas.importeabono),0) as importeabono from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join T_Sellospresupuestales
					on T_Sellospresupuestales.idsellopresupuestal = d_polizas.idsellopresupuestal
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					inner join C_TipoMovPolizas
					on t_polizas.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idsellopresupuestal=@idSelloPres and c_contable.numerocuenta like '827%'
					and T_Polizas.NoPoliza > 0 and (ISNULL(T_Polizas.IdPolizaCancelacion,0) = 1 or C_TipoMovPolizas.CancelaManual = 1)
					)


							If exists (Select Pagado from T_PresupuestoNW where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 		
							     Update T_PresupuestoNW set Pagado = (@CargosP - @AbonosP) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							end
							
							If not exists (Select Pagado from t_presupuestonw where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres)                          
							begin 
							   Insert into T_PresupuestoNW values (@idSelloPres,@ejercicio,@mes,0,0,0,0,0,0,@CargosP-@AbonosP,0,0,0,0,0,0,0,0,0,0,null,null)
							end

							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560
							IF EXISTS(SELECT 1 
									  FROM T_AfectacionPresupuesto 
									   WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'P' AND TipoMovimientoGenera = 'W') )
							BEGIN
								SELECT  @DevolucionesP = SUM(Importe) 
								FROM T_AfectacionPresupuesto 
								WHERE Periodo = @ejercicio AND Mes = @mes AND IdSelloPresupuestal = @idSelloPres AND (TipoAfectacion = 'P' AND TipoMovimientoGenera = 'W')
								  AND IdMovimiento in (SELECT IdNotaCredito FROM T_NotaCredito WHERE Total != 0.0)

								Update T_PresupuestoNW set Pagado = (Pagado + @DevolucionesP) where  year=@ejercicio and mes=@mes and  idsellopresupuestal=@idSelloPres
							END
							-- Quitar las devoluciones  -- @PRodriguez 20191113 B0560

		FETCH NEXT FROM CICLOPRINCIPAL
		INTO	@idSelloPres,@idPartida
		END      
		CLOSE CICLOPRINCIPAL
		DEALLOCATE CICLOPRINCIPAL

    end    

  End
 ---------------  
END


GO


Exec SP_CFG_LogScripts 'SP_RegeneraSaldosPresupuestalesxMes','2.30.1'
GO