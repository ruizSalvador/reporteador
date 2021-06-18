
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SP_InterfazContPaqI]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_InterfazContPaqI]
GO



CREATE PROCEDURE [dbo].[SP_InterfazContPaqI]

 @Ejercicio as int,
 @Periodo as int,
 @TipoPoliza as char,
 @Opcion as int 

AS
BEGIN
	

		
	IF @Opcion=1   --TOTAL PLAN DE CUENTAS
	BEGIN
				
			Update C_Contable Set Financiero = 0

			--Cuentas de titulo
			Update C_Contable Set Financiero = 3 where Nivel = 0

			--Cuentas de Subtitulo
			Update C_Contable Set Financiero = 4 where Nivel = 1 and Financiero <> 3


			--Cuentas de Mayor
			Update C_Contable Set Financiero = 1 where Nivel = 2 and Financiero Not In (3,4)
			and IdCuentaContable > 10


			--Cuentas que no aplica
			Update C_Contable Set Financiero = 2 where Financiero Not In (1, 3,4)
			and IdCuentaContable > 10
			
	
	     Select Count(NumeroCuenta) as Total  from c_contable  where numerocuenta<>''
	     
	END
	
	IF @Opcion=2    --PLAN DE CUENTAS
	BEGIN
	
		 Select replace(replace(NumeroCuenta,'-','' ),' ','') as Codigo,left(NombreCuenta,49) as NombreCuenta,Fecha,Utilizar as Baja,Afectable ,
	            replace(replace(CuentaAcumulacion,'-',''),' ','') as CodigoCuentaAcumula,  TipoCuenta ,financiero as CuentaDe,0 as segmentodeNeg,
	            1 as Moneda, 0 as DigitoAgrupador 
        from c_contable 
        where numerocuenta<>'' and IdCuentaContable > 10   order by codigo  
        
	END
	
	IF @Opcion=3  --TOTAL POLIZA TODAS
	BEGIN
	
					--Recalcula totales de Cuentas
			DECLARE @DPolizas AS TABLE(IdPoliza int,ImporteCargo decimal(15,2),ImporteAbono decimal(15,2))
			INSERT INTO @DPolizas SELECT IdPoliza,SUM(ImporteCargo),SUM(ImporteCargo)FROM D_Polizas GROUP BY IdPoliza

			UPDATE T_Polizas SET T_Polizas.TotalAbonos= T.ImporteAbono, T_Polizas.TotalCargos= T.ImporteCargo
			FROM T_Polizas JOIN @DPolizas T ON T_Polizas.IdPoliza=T.IdPoliza 
			
				--Asigna el tipo de movimiento
				UPDATE D_Polizas SET D_Polizas.iva=1 where (D_Polizas.ImporteCargo<>0 and D_Polizas.iva=0)
				UPDATE D_Polizas SET D_Polizas.iva=2 where (D_Polizas.ImporteAbono<>0 and D_Polizas.iva=0)
				
		Select Count(IdPoliza) as Total  from T_Polizas where Ejercicio= @Ejercicio And Periodo=@Periodo and NoPoliza>0
	END
	
	IF @Opcion=4  --POLIZA TODAS
	BEGIN
	
					--Recalcula totales de Cuentas
			DECLARE @DPolizas1 AS TABLE(IdPoliza int,ImporteCargo decimal(15,2),ImporteAbono decimal(15,2))
			INSERT INTO @DPolizas1 SELECT IdPoliza,SUM(ImporteCargo),SUM(ImporteCargo)FROM D_Polizas GROUP BY IdPoliza

			UPDATE T_Polizas SET T_Polizas.TotalAbonos= T.ImporteAbono, T_Polizas.TotalCargos= T.ImporteCargo
			FROM T_Polizas JOIN @DPolizas1 T ON T_Polizas.IdPoliza=T.IdPoliza 
			
				--Asigna el tipo de movimiento
				UPDATE D_Polizas SET D_Polizas.iva=1 where (D_Polizas.ImporteCargo<>0 and D_Polizas.iva=0)
				UPDATE D_Polizas SET D_Polizas.iva=2 where (D_Polizas.ImporteAbono<>0 and D_Polizas.iva=0)
				
		select idpoliza,Fecha,tipoPoliza,NoPoliza,afectarpresupuesto as clase,left(concepto,99) as concepto from T_Polizas
        Where  Ejercicio= @Ejercicio And Periodo= @Periodo and  NoPoliza>0
		
	END	
	
	IF @Opcion=5  --TOTAL TIPO POLIZA 
					--Recalcula totales de Cuentas
			DECLARE @DPolizas2 AS TABLE(IdPoliza int,ImporteCargo decimal(15,2),ImporteAbono decimal(15,2))
			INSERT INTO @DPolizas2 SELECT IdPoliza,SUM(ImporteCargo),SUM(ImporteCargo)FROM D_Polizas GROUP BY IdPoliza

			UPDATE T_Polizas SET T_Polizas.TotalAbonos= T.ImporteAbono, T_Polizas.TotalCargos= T.ImporteCargo
			FROM T_Polizas JOIN @DPolizas2 T ON T_Polizas.IdPoliza=T.IdPoliza 
			
				--Asigna el tipo de movimiento
				UPDATE D_Polizas SET D_Polizas.iva=1 where (D_Polizas.ImporteCargo<>0 and D_Polizas.iva=0)
				UPDATE D_Polizas SET D_Polizas.iva=2 where (D_Polizas.ImporteAbono<>0 and D_Polizas.iva=0)BEGIN
	
	
		Select Count(IdPoliza) as Total  from T_Polizas where Ejercicio= @Ejercicio And Periodo=@Periodo And TipoPoliza=@TipoPoliza and NoPoliza>0
	END
	
	IF @Opcion=6  --TIPO POLIZA 
	BEGIN
	
					--Recalcula totales de Cuentas
			DECLARE @DPolizas3 AS TABLE(IdPoliza int,ImporteCargo decimal(15,2),ImporteAbono decimal(15,2))
			INSERT INTO @DPolizas3 SELECT IdPoliza,SUM(ImporteCargo),SUM(ImporteCargo)FROM D_Polizas GROUP BY IdPoliza

			UPDATE T_Polizas SET T_Polizas.TotalAbonos= T.ImporteAbono, T_Polizas.TotalCargos= T.ImporteCargo
			FROM T_Polizas JOIN @DPolizas3 T ON T_Polizas.IdPoliza=T.IdPoliza 
			
				--Asigna el tipo de movimiento
				UPDATE D_Polizas SET D_Polizas.iva=1 where (D_Polizas.ImporteCargo<>0 and D_Polizas.iva=0)
				UPDATE D_Polizas SET D_Polizas.iva=2 where (D_Polizas.ImporteAbono<>0 and D_Polizas.iva=0)
				
		select idpoliza,Fecha,tipoPoliza,NoPoliza,afectarpresupuesto as clase,left(concepto,99) as concepto from T_Polizas
        Where  Ejercicio= @Ejercicio And Periodo= @Periodo And TipoPoliza=@TipoPoliza and NoPoliza>0
	
	END	
	
END