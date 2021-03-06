/****** Object:  StoredProcedure [dbo].[SP_RegeneraSaldosPresupuestalesxMesIngresos]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RegeneraSaldosPresupuestalesxMesIngresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RegeneraSaldosPresupuestalesxMesIngresos]
GO
/****** Object:  StoredProcedure [dbo].[SP_RegeneraSaldosPresupuestalesxMesIngresos]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Ing. Blanca Estela Rodríguez Ramos>
-- Create date: <17 Agosto 2016>
-- Description:	<SP para Regeneración de Saldos Presupuestales por mes y por mes - sello, de Ingresos>
-- =============================================
-- Exec SP_RegeneraSaldosPresupuestalesxMesIngresos 2020,2,0
CREATE PROCEDURE  [dbo].[SP_RegeneraSaldosPresupuestalesxMesIngresos]  

 @ejercicio int,
 @mes int,
 @IdSello int

AS

declare @idSelloPres int

declare @AbonosD decimal(21,2)
declare @AbonosR decimal(21,2)

declare @CargosD decimal(21,2)
declare @CargosR decimal(21,2)

declare @TotalD decimal(21,2)
declare @TotalR decimal(21,2)

declare @TotalDR decimal(21,2)



BEGIN

    -- ******* Para el caso de regeneración de Presupuesto por mes   ******************** ----
    
    If @IdSello = 0 
    begin

		-- ************* Actualizo en Cero los momentos presupuestales de acuerdo a los parámetros ************* ---------
	    
		Update T_PresupuestoFlujo set Devengado=0, Recaudado=0 where Ejercicio=@ejercicio and Mes=@mes 


		-- ************* Recorro Sellos de acuerdo al ejercicio.
		Declare CICLOPRINCIPAL cursor for		
		select IdPartidaGI  FROM c_partidasgastosingresos where Ejercicio= @ejercicio   
		OPEN CICLOPRINCIPAL
		FETCH NEXT FROM CICLOPRINCIPAL
		INTO @idSelloPres
		WHILE @@fetch_status = 0
		BEGIN

	
    -- ************* Afectación del Recaudado ************* ---------
    
					set @AbonosR = (Select sum(isnull(D_Polizas.importeabono,0)) as importeabono from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join c_partidasgastosingresos
					on c_partidasgastosingresos.idpartidaGI = d_polizas.idpartidadeflujo
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idpartidadeflujo=@idSelloPres and c_contable.numerocuenta like '815%'
					and T_Polizas.NoPoliza > 0					
					)

					set @CargosR = (Select sum(isnull(D_Polizas.importecargo,0)) as importecargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join c_partidasgastosingresos
					on c_partidasgastosingresos.idpartidaGI = d_polizas.idpartidadeflujo
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idpartidadeflujo=@idSelloPres and c_contable.numerocuenta like '815%'
					and T_Polizas.NoPoliza > 0					
					)

					set @TotalR = isnull(@AbonosR,0) - isnull(@CargosR,0)

							If exists (Select Recaudado from t_presupuestoflujo where  Ejercicio=@ejercicio and mes=@mes and  idpartida=@idSelloPres)                          
							begin 		
							     Update t_presupuestoflujo set Recaudado = @TotalR where Ejercicio=@ejercicio and mes=@mes and  idpartida=@idSelloPres
							end
							
							If not exists (Select Recaudado from t_presupuestoflujo where  Ejercicio=@ejercicio and mes=@mes and  idpartida=@idSelloPres)                          
							begin 
							   Insert into t_presupuestoflujo values (@ejercicio,@idSelloPres,@mes,0,0,0,0,0,@TotalR,0)
							end

	
   -- ************* Afectación del Devengado  ************* ---------
     -- ** Se pasa para abajo ya que se requiere considerar primero el Recaudado para obtener la diferencia del Por Recaudar

					set @AbonosD = (Select sum(isnull(D_Polizas.importeabono,0)) as importeabono from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join c_partidasgastosingresos
					on c_partidasgastosingresos.idpartidaGI = d_polizas.idpartidadeflujo
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idpartidadeflujo=@idSelloPres and c_contable.numerocuenta like '814%'
					and T_Polizas.NoPoliza > 0					
					)


					set @CargosD = (Select sum(isnull(D_Polizas.importecargo,0)) as importecargo from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join c_partidasgastosingresos
					on c_partidasgastosingresos.idpartidaGI = d_polizas.idpartidadeflujo
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idpartidadeflujo=@idSelloPres and c_contable.numerocuenta like '814%'
					and T_Polizas.NoPoliza > 0					
					)

					set @TotalD = isnull(@AbonosD,0) - isnull(@CargosD,0)

					set @TotalDR = @TotalR + @TotalD

							If exists (Select Devengado from t_presupuestoflujo where  Ejercicio=@ejercicio and mes=@mes and  idpartida=@idSelloPres)
							begin 		
							     Update t_presupuestoflujo set Devengado = @TotalDR where Ejercicio=@ejercicio and mes=@mes and  idpartida=@idSelloPres
							end
							
							If not exists (Select Devengado from t_presupuestoflujo where  Ejercicio=@ejercicio and mes=@mes and  idpartida=@idSelloPres)                          
							begin 
							   Insert into t_presupuestoflujo values (@ejercicio,@idSelloPres,@mes,0,0,0,0,@TotalDR,0,0)
							end


		FETCH NEXT FROM CICLOPRINCIPAL
		INTO	@idSelloPres
		END      
		CLOSE CICLOPRINCIPAL
		DEALLOCATE CICLOPRINCIPAL

    end
    
    -- ******* Para el caso de regeneración de Presupuesto por mes y Sello  ******************** ----
    
    If @IdSello > 0 
    begin

		-- ************* Actualizo en Cero los momentos presupuestales de acuerdo a los parámetros ************* ---------
	    
		Update T_PresupuestoFlujo set Devengado=0, Recaudado=0 where Ejercicio=@ejercicio and Mes=@mes and IdPartida = @IdSello
	    
	    

		-- ************* Recorro Sellos de acuerdo al ejercicio.
		Declare CICLOPRINCIPAL cursor for		
		select IdPartidaGI  FROM c_partidasgastosingresos where Ejercicio= @ejercicio  and IdPartidaGI = @IdSello 
		OPEN CICLOPRINCIPAL
		FETCH NEXT FROM CICLOPRINCIPAL
		INTO @idSelloPres
		WHILE @@fetch_status = 0
		BEGIN



    -- ************* Afectación del Devengado  ************* ---------
    
					set @AbonosD = (Select sum(isnull(D_Polizas.importeabono,0)) as importeabono from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join c_partidasgastosingresos
					on c_partidasgastosingresos.idpartidaGI = d_polizas.idpartidadeflujo
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idpartidadeflujo=@idSelloPres and c_contable.numerocuenta like '814%'
					and T_Polizas.NoPoliza > 0					
					)


							If exists (Select Devengado from t_presupuestoflujo where  Ejercicio=@ejercicio and mes=@mes and  idpartida=@idSelloPres)                          
							begin 		
							     Update t_presupuestoflujo set Devengado = isnull(@AbonosD,0) where Ejercicio=@ejercicio and mes=@mes and  idpartida=@idSelloPres
							end
							
							If not exists (Select Devengado from t_presupuestoflujo where  Ejercicio=@ejercicio and mes=@mes and  idpartida=@idSelloPres)                          
							begin 
							   Insert into t_presupuestoflujo values (@ejercicio,@idSelloPres,@mes,0,0,0,0,@AbonosD,0,0)
							end


    -- ************* Afectación del Recaudado ************* ---------
    
					set @AbonosR = (Select sum(isnull(D_Polizas.importeabono,0)) as ImporteAbono from D_Polizas
					inner join c_contable
					on d_polizas.IdCuentaContable = c_contable.idcuentacontable
					inner join c_partidasgastosingresos
					on c_partidasgastosingresos.idpartidaGI = d_polizas.idpartidadeflujo
					inner join T_Polizas
					on t_polizas.idpoliza = d_polizas.idpoliza
					where T_Polizas.ejercicio = @ejercicio and T_Polizas.periodo=@mes and d_polizas.idpartidadeflujo=@idSelloPres and c_contable.numerocuenta like '815%'
					and T_Polizas.NoPoliza > 0					
					)


							If exists (Select Recaudado from t_presupuestoflujo where  Ejercicio=@ejercicio and mes=@mes and  idpartida=@idSelloPres)                          
							begin 		
							     Update t_presupuestoflujo set Recaudado = isnull(@AbonosR,0) where Ejercicio=@ejercicio and mes=@mes and  idpartida=@idSelloPres
							end
							
							If not exists (Select Recaudado from t_presupuestoflujo where  Ejercicio=@ejercicio and mes=@mes and  idpartida=@idSelloPres)                          
							begin 
							   Insert into t_presupuestoflujo values (@ejercicio,@idSelloPres,@mes,0,0,0,0,0,@AbonosR,0)
							end
							
							
		FETCH NEXT FROM CICLOPRINCIPAL
		INTO	@idSelloPres
		END      
		CLOSE CICLOPRINCIPAL
		DEALLOCATE CICLOPRINCIPAL

    end    
    
END




EXEC SP_CFG_LogScripts '46.-Script_SP_RegeneraSaldosPresupuestalesxMes_Ingresos.sql','2.29.1'
