

/****** Object:  StoredProcedure [dbo].[SP_CierrePresupuestal]    Script Date: 12/28/2012 10:41:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CierrePresupuestal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_CierrePresupuestal]
GO
/****** Object:  StoredProcedure [dbo].[SP_CierrePresupuestal]    Script Date: 12/28/2012 10:41:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_CierrePresupuestal '20201231',1,2020
CREATE PROCEDURE [dbo].[SP_CierrePresupuestal]
 
 @Fecha as varchar(20),
 @IdUsuario as bigint,
 @Ejercicio as int
 	
AS


--set @Fecha =  convert(datetime, @Fecha);




BEGIN TRY

BEGIN TRAN
BEGIN
declare @IdCuentaContable integer
			declare @IdCuentaContableB integer
			declare @NumeroCuenta varchar(30)
			declare @NombreCuenta varchar(255)
			declare @TipoCuenta varchar(1)
			declare @SaldoDeudor decimal(15,2)
			declare @SaldoAcreedor decimal(15,2)
			Declare @IdPoliza bigint
			Declare @NoPoliza bigint
			Declare @IdDPoliza bigint
			Declare @ConceptoPoliza varchar(120)
			Declare @TotalSaldoCargos decimal(15,2)
			Declare @TotalSaldoAbonos decimal(15,2)
			Declare @Total decimal(15,2)
			Declare @IdGuia bigint
			Declare @IDConcepto bigint
			Declare @TipoPoliza varchar(10)
			Declare @NRightCuenta varchar(6)
			Declare @RightCuenta varchar(6)
			Declare @NLeftCuenta varchar(6)
			Declare @Afectable bit
			Declare @Tabla81200 Table (IdCuentaContable bigint, NumeroCuenta varchar(30),Total decimal(15,2) ,RightCuenta varchar(6),Opcion bigint)
			Declare @Tabla82200 Table (IdCuentaContable bigint, NumeroCuenta varchar(30) ,Total decimal(15,2),RightCuenta varchar(6), Opcion bigint)
			Declare @Total81300 decimal(15,2)
			Declare @Total81200 decimal(15,2)
			Declare @EstIzq int
			Declare @EstDer int
			Declare @IdCuentaContableTemp integer
			
			
			--Obtengo Estructura Contable
			SELECT @EstIzq=Left(VALOR,1)  , @EstDer=RIGHT(Valor,1)  FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'
			
			--BM INICIO
			--Variable de tabla temporal
			DECLARE @Tabla TABLE(IdCuenta INT)
			
			--Se insertan en la tabla temporal los id de cuentas contables no encontrados en el año de la fecha y el mes 13.
			INSERT INTO @Tabla 
			SELECT IdCuentaContable FROM  C_Contable 
			WHERE IdCuentaContable NOT IN (SELECT IdCuentaContable FROM T_SaldosInicialesCont WHERE [Year]=@Ejercicio AND Mes=13)
			
			--Se Inserta en saldos iniciales los id de cuentas que no existian en el mes 13 y en el año de la fecha con valores en cero.
			INSERT INTO T_SaldosInicialesCont (IdCuentaContable,[Year],Mes,TotalCargos ,TotalAbonos ,CargosSinFlujo ,AbonosSinFlujo )
			SELECT T.IdCuenta,@Ejercicio,13,0,0,0,0 FROM @Tabla T
			--BM FIN

--Evento 01
Declare CICLOPRINCIPAL cursor for
									
					Select C_Contable.IdCuentaContable,NumeroCuenta, NombreCuenta, 
						  CargosSinFlujo, AbonosSinFlujo,right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta, Afectable
					From C_Contable, T_SaldosInicialesCont 
					Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
					And Mes = 13 And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
					NumeroCuenta LIKE '814%' And Afectable = 1
					Order By NumeroCuenta
					
					set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),13)  -- BR 20170403 Para que tome el consecutivo del mes 13					
					Select @NoPoliza=consecutivo + 1 from T_Consecutivos WHERE Tipo = @TipoPoliza
					select top 1 @IdPoliza=IdPoliza + 1  from T_Polizas order by IdPoliza desc
					select top 1 @IdDPoliza=Iddpoliza from D_Polizas order by IdDPoliza desc
					Set @ConceptoPoliza='Ley de Ingresos devengada no recaudada'
					set @TotalSaldoAbonos=0
					set @TotalSaldoCargos=0
					set @IDConcepto=374
					set @IdGuia=45
					set @Total81200=0
					
					--INSERTAR DATOS EN D_POLIZAS
							 INSERT INTO T_Polizas(idpoliza,IdCheque,idtipomovimiento,TipoPoliza,Ejercicio,Periodo,NoPoliza,Fecha,Status,Concepto,TotalCargos,TotalAbonos,idusuario,FechaAuditoria,HoraAuditoria,idguia,idconcepto )
							 VALUES (@IdPoliza,0,@IDConcepto,'D',@Ejercicio ,13,@NoPoliza,@Fecha,'C',@ConceptoPoliza,@SaldoDeudor,@SaldoAcreedor,@IdUsuario,@Fecha,@Fecha,@IdGuia,@IDConcepto)
					
							OPEN CICLOPRINCIPAL
							FETCH NEXT FROM CICLOPRINCIPAL
							INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@SaldoAcreedor,@NRightCuenta,@Afectable
							WHILE @@fetch_status = 0
							BEGIN
	
										--OBTENER ID DE NUMEROS DE CUENTA A INSERTAR EN LA POLIZA
										
										Select @IdCuentaContableB=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,3) like '812' and right(replace(NumeroCuenta,' ',''),@EstDer )=@NRightCuenta

										--INSERTO MOVIMIENTO PARA CUENTAS 
										
										IF @Afectable=1 and @IdCuentaContableB>0 
										BEGIN
										
												 --INSERTAR EN TABLA TEMPORAL DE 81200
													INSERT INTO @Tabla81200(IdCuentaContable,NumeroCuenta,Total,RightCuenta ,Opcion) 
													Values(@IdCuentaContableB,@NumeroCuenta, @SaldoAcreedor, @NRightCuenta ,1)
										
											IF @SaldoAcreedor<0 OR @SaldoAcreedor>0
											BEGIN
													SET @IdDPoliza=@IdDPoliza + 1
												
													--INSERTAR DATOS EN T_POLIZAS
													 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
													 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,@SaldoAcreedor,0,1,' ',0,0 )
													Set @TotalSaldoCargos =@TotalSaldoCargos + @SaldoAcreedor
													
													Set @Total81200 = @Total81200 + @SaldoAcreedor
																																							
													Set @IdDPoliza = @IdDPoliza +1
												
													--INSERTAR DATOS EN T_POLIZAS81200
													 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo,IdSelloPresupuestal )
													 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContableB,0,@SaldoAcreedor,1,' ',0,0 )
													 
													 set @TotalSaldoAbonos=@TotalSaldoAbonos + @SaldoAcreedor
													 													 
													
													 
											END		 
										END
																			
							 FETCH NEXT FROM CICLOPRINCIPAL
							 INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@SaldoAcreedor,@NRightCuenta,@Afectable
							 END      
							CLOSE CICLOPRINCIPAL
  							DEALLOCATE CICLOPRINCIPAL
  							  							
  							UPDATE T_Polizas SET TotalCargos=@TotalSaldoCargos , TotalAbonos=@TotalSaldoAbonos WHERE IdPoliza=@IdPoliza
  							UPDATE T_Consecutivos SET Consecutivo=@NoPoliza  WHERE Tipo = @TipoPoliza
  							INSERT INTO R_PolizaGuia values(@idpoliza,@IdGuia,@IDConcepto)


--Evento 02
Set @IdCuentaContableB =0
				Set @NumeroCuenta= ''
				Set @NombreCuenta=''
				Set @TipoCuenta=''
				Set @Afectable=0
				Set @SaldoDeudor =0
				Set @SaldoAcreedor =0
  				Set @TotalSaldoCargos = 0
				Set @TotalSaldoAbonos = 0
				Set @TipoPoliza=''
				Set @NoPoliza=0
				Set @IdPoliza=0
				Set @IdDPoliza=0
				Set @ConceptoPoliza=''
				Set @IDConcepto=0
				Set @IdGuia=0
				Set @Total=0
					--Obtengo Estructura Contable
	SELECT @EstIzq=Left(VALOR,1)  , @EstDer=RIGHT(Valor,1)  FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'
				
  				Declare CICLOPRINCIPAL cursor for
										
						
								Select C_Contable.IdCuentaContable,NumeroCuenta, NombreCuenta, 
									  SUM(TotalAbonos) as TotalAbonos,Afectable, right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta
								From C_Contable, T_SaldosInicialesCont 
								Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
								And (mes between 1 and 12) And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
								 NumeroCuenta LIKE '813%' And Afectable = 1
								 Group by C_Contable.IdCuentaContable, C_Contable.NumeroCuenta, C_Contable.NombreCuenta, C_Contable.Afectable
								Order By NumeroCuenta
								
																
								--obtendo id y numero de poliza 
								set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),13)  -- BR 20170403 Para que tomé el consecutivo del mes 13									 
								Select @NoPoliza=consecutivo + 1 from T_Consecutivos WHERE Tipo = @TipoPoliza
								select top 1 @IdPoliza=IdPoliza + 1  from T_Polizas order by IdPoliza desc
								select top 1 @IdDPoliza=Iddpoliza from D_Polizas order by IdDPoliza desc
								Set @ConceptoPoliza='Traspaso al cierre del ejercicio de las modificaciones negativas a la Ley de Ingresos.'
								set @IDConcepto=376
								set @IdGuia=45
								
								--INSERTAR DATOS EN D_POLIZAS
										 INSERT INTO T_Polizas(idpoliza,IdCheque,idtipomovimiento,TipoPoliza,Ejercicio,Periodo,NoPoliza,Fecha,Status,Concepto,TotalCargos,TotalAbonos,idusuario,FechaAuditoria,HoraAuditoria,idguia,idconcepto )
										 VALUES (@IdPoliza,0,@IDConcepto,'D',year(@Fecha) ,13 ,@NoPoliza,@Fecha,'C',@ConceptoPoliza,@SaldoDeudor,@SaldoAcreedor,@IdUsuario,@Fecha,@Fecha,@IdGuia,@IDConcepto)
								
										OPEN CICLOPRINCIPAL
										FETCH NEXT FROM CICLOPRINCIPAL
										INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@Afectable,@RightCuenta
										WHILE @@fetch_status = 0
										BEGIN
				
														--OBTENER ID DE NUMEROS DE CUENTA A INSERTAR EN LA POLIZA
													
										      Select @IdCuentaContableB=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,3)='812' and right(replace(NumeroCuenta,' ',''),@EstDer)=@RightCuenta
													IF @Afectable=1 and @IdCuentaContableB>0 
													BEGIN
													
														IF  @SaldoDeudor<0 OR @SaldoDeudor>0
														BEGIN
																	--INSERTO MOVIMIENTO PARA CUENTAS 
																	SET @IdDPoliza=@IdDPoliza + 1
														
																	--INSERTAR DATOS EN T_POLIZAS81200
																	 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
																	 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,@SaldoDeudor,0,1,' ',0,0 )
																	
																	   set @TotalSaldoCargos=@TotalSaldoCargos + @SaldoDeudor
																	  

																	  --DM Insertando 81200
																	   --INSERTAR EN TABLA TEMPORAL DE 81200
																	   Select @IdCuentaContableTemp =  IdCuentaContable from @Tabla81200 Where IdCuentaContable=@IdCuentaContableB
																	   if @IdCuentaContableTemp = 0 begin
																			INSERT INTO @Tabla81200(IdCuentaContable,NumeroCuenta,Total,RightCuenta ,Opcion) 
																				Values(@IdCuentaContableB,@NumeroCuenta, @SaldoAcreedor, @NRightCuenta ,1)
																		end
																		else
																		begin
																			UPDATE @Tabla81200 SET Total=Total + @SaldoDeudor  Where IdCuentaContable=@IdCuentaContableB
																		end
	
																	
																		
																												
																	Set @IdDPoliza = @IdDPoliza +1
																
																	--INSERTAR DATOS EN T_POLIZAS81300
																	 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo,IdSelloPresupuestal )
																	 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContableB,0,@SaldoDeudor,1,'t ',0,0 )
																	 Set @TotalSaldoAbonos =@TotalSaldoAbonos+ @SaldoDeudor
																	set @IdCuentaContableB=0
															END
													END
																						
										 FETCH NEXT FROM CICLOPRINCIPAL
										 INTO  @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@Afectable,@RightCuenta
										 END      
										CLOSE CICLOPRINCIPAL
  										DEALLOCATE CICLOPRINCIPAL
			  							
  										UPDATE T_Polizas SET TotalCargos=@TotalSaldoCargos, TotalAbonos=@TotalSaldoAbonos WHERE IdPoliza=@IdPoliza
  										UPDATE T_Consecutivos SET Consecutivo=@NoPoliza  WHERE Tipo = @TipoPoliza
  										INSERT INTO R_PolizaGuia values(@idpoliza,@IdGuia,@IDConcepto)
	
		--FIN Ley de ingresos por ejecutar no devengada

--Evento 03

Set @IdCuentaContableB =0
			Set @NumeroCuenta= ''
		    Set @NombreCuenta=''
			Set @TipoCuenta=''
			Set @Afectable=0
			Set @SaldoDeudor =0
			Set @SaldoAcreedor =0
  			Set @TotalSaldoCargos = 0
			Set @TotalSaldoAbonos = 0
			Set @TipoPoliza=''
			Set @NoPoliza=0
			Set @IdPoliza=0
			Set @IdDPoliza=0
			Set @ConceptoPoliza=''
			Set @IDConcepto=0
			Set @IdGuia=0
			Set @Total=0
		--Obtengo Estructura Contable
	SELECT @EstIzq=Left(VALOR,1)  , @EstDer=RIGHT(Valor,1)  FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'		
			
  			Declare CICLOPRINCIPAL cursor for
									

								Select C_Contable.IdCuentaContable,NumeroCuenta, NombreCuenta, 
									  SUM(TotalCargos) as TotalCargos,Afectable, right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta
								From C_Contable, T_SaldosInicialesCont 
								Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
								And (mes between 1 and 12) And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
								 NumeroCuenta LIKE '813%' And Afectable = 1
								 Group by C_Contable.IdCuentaContable, C_Contable.NumeroCuenta, C_Contable.NombreCuenta, C_Contable.Afectable
								Order By NumeroCuenta
							
							--obtendo id y numero de poliza 
						    set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),13)  -- BR 20170403 Para que tomé el consecutivo del mes 13								  
							Select @NoPoliza=consecutivo + 1 from T_Consecutivos WHERE Tipo = @TipoPoliza
							select top 1 @IdPoliza=IdPoliza + 1  from T_Polizas order by IdPoliza desc
							select top 1 @IdDPoliza=Iddpoliza from D_Polizas order by IdDPoliza desc
							Set @ConceptoPoliza='Traspaso al cierre del ejercicio de las modificaciones positivas a la Ley de Ingresos.'
							set @IDConcepto=377
							set @IdGuia=45
							
							--INSERTAR DATOS EN D_POLIZAS
									 INSERT INTO T_Polizas(idpoliza,IdCheque,idtipomovimiento,TipoPoliza,Ejercicio,Periodo,NoPoliza,Fecha,Status,Concepto,TotalCargos,TotalAbonos,idusuario,FechaAuditoria,HoraAuditoria,idguia,idconcepto )
									 VALUES (@IdPoliza,0,@IDConcepto,'D',@Ejercicio ,13,@NoPoliza,@Fecha,'C',@ConceptoPoliza,@SaldoDeudor,@SaldoAcreedor,@IdUsuario,@Fecha,@Fecha,@IdGuia,@IDConcepto)
							
									OPEN CICLOPRINCIPAL
									FETCH NEXT FROM CICLOPRINCIPAL
									INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@Afectable,@RightCuenta
									WHILE @@fetch_status = 0
									BEGIN
			
													--OBTENER ID DE NUMEROS DE CUENTA A INSERTAR EN LA POLIZA
												
												Select @IdCuentaContableB=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,3)='812' and right(replace(NumeroCuenta,' ',''),@EstDer)=@RightCuenta

												IF @Afectable=1 and @IdCuentaContableB>0 
												BEGIN
												
													IF @SaldoDeudor<0 OR @SaldoDeudor>0
													BEGIN
															--INSERTO MOVIMIENTO PARA CUENTAS 
															SET @IdDPoliza=@IdDPoliza + 1
																													
															--INSERTAR DATOS EN T_POLIZAS81200
															 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
															 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,0,@SaldoDeudor,1,' ',0,0 )
															Set @TotalSaldoAbonos =@TotalSaldoAbonos+ @SaldoDeudor
															
																	 --INSERTAR EN TABLA TEMPORAL DE 81200
																	UPDATE @Tabla81200 SET Total=Total - @SaldoDeudor  Where IdCuentaContable=@IdCuentaContableB --DM 20160113
																	--UPDATE @Tabla81200 SET Total=Total + @SaldoDeudor  Where IdCuentaContable=@IdCuentaContableB 
																					
																																																																									
															Set @IdDPoliza = @IdDPoliza +1
														
															--INSERTAR DATOS EN T_POLIZAS81300
															 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo,IdSelloPresupuestal )
															 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContableB,@SaldoDeudor,0,1,' ',0,0 )
															 
															 set @TotalSaldoCargos=@TotalSaldoCargos + @SaldoDeudor
															 set @IdCuentaContableB=0
														 
													END	 
												END
																						
									 FETCH NEXT FROM CICLOPRINCIPAL
									 INTO  @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@Afectable,@RightCuenta
									 END      
									CLOSE CICLOPRINCIPAL
  									DEALLOCATE CICLOPRINCIPAL
		  							
		  							
  									UPDATE T_Polizas SET TotalCargos=@TotalSaldoCargos, TotalAbonos=@TotalSaldoAbonos WHERE IdPoliza=@IdPoliza
  									UPDATE T_Consecutivos SET Consecutivo=@NoPoliza  WHERE Tipo = @TipoPoliza
  									INSERT INTO R_PolizaGuia values(@idpoliza,@IdGuia,@IDConcepto)


--EVENTO 04
  	--LEY DE INGRESOS PARA EJECUTAR NO DEVENGADA 
  			Set @IdCuentaContableB =0
			Set @NumeroCuenta= ''
		    Set @NombreCuenta=''
			Set @TipoCuenta=''
			Set @Afectable=0
			Set @SaldoDeudor =0
			Set @SaldoAcreedor =0
  			Set @TotalSaldoCargos = 0
			Set @TotalSaldoAbonos = 0
			Set @TipoPoliza=''
			Set @NoPoliza=0
			Set @IdPoliza=0
			Set @IdDPoliza=0
			Set @ConceptoPoliza=''
			Set @IDConcepto=0
			Set @IdGuia=0
			Set @Total=0
	        Set @EstIzq =0
			Set @EstDer=0
			set @IdCuentaContableB=0
	--Obtengo Estructura Contable
	SELECT @EstIzq=Left(VALOR,1)  , @EstDer=RIGHT(Valor,1)  FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'

Declare @BalPRECierreING as Table (NumeroCuenta varchar(50),IdCuentaContable int, CargosSinFlujo decimal(18,2), AbonosSinFlujo decimal(18,2), ImporteCargo decimal(18,2), ImporteAbono decimal(18,2), NCuenta varchar(50), Afectable int)
Insert into @BalPRECierreING
Select NumeroCuenta, C_Contable.IdCuentaContable, 
						 CargosSinFlujo, AbonosSinFlujo,
						 0,0,
						 right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta, Afectable
					From C_Contable, T_SaldosInicialesCont 
					Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
					And Mes = 13 And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
					--LEFT(NumeroCuenta,@EstIzq)='81200' + replicate ('0',(@EstIzq - len('81200'))) 
					NumeroCuenta LIKE '812%' And Afectable = 1
					AND (CargosSinFlujo + AbonosSinFlujo != 0)
					Order By NumeroCuenta

Declare @PolAnterioresING as Table (NumeroCuenta varchar(50),IdCuentaContable int, CargosSinFlujo decimal(18,2), AbonosSinFlujo decimal(18,2), ImporteCargo decimal(18,2), ImporteAbono decimal(18,2))

Insert into @PolAnterioresING
Select C_Contable.NumeroCuenta,
D_Polizas.IdCuentaContable, CargosSinFlujo, AbonosSinFlujo, SUM(D_Polizas.ImporteCargo) as ImporteCargo, SUM(D_Polizas.ImporteAbono) as ImporteAbono  
from D_Polizas 
LEFT Join C_Contable on  C_Contable.IdCuentaContable = D_Polizas.IdCuentaContable
JOIN T_SaldosInicialesCont ON D_Polizas.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable and Year = @Ejercicio and Mes = 13
where 
 IdPoliza in (Select IdPoliza from T_Polizas where Ejercicio = @Ejercicio and Periodo = 13)
--AND LEFT(NumeroCuenta,@EstIzq)='81200'
AND LEFT(NumeroCuenta,3)='812'
Group by C_Contable.NumeroCuenta, D_Polizas.IdCuentaContable, T_SaldosInicialesCont.CargosSinFlujo, T_SaldosInicialesCont.AbonosSinFlujo
order by C_Contable.NumeroCuenta


Update  Bal set Bal.ImporteCargo = Pol.ImporteCargo, Bal.ImporteAbono = Pol.ImporteAbono
From @BalPRECierreING Bal JOIN @PolAnterioresING Pol ON Bal.IdCuentaContable = Pol.IdCuentaContable

Insert Into @BalPRECierreING
Select NumeroCuenta,IdCuentaContable,CargosSinFlujo,AbonosSinFlujo,ImporteCargo,ImporteAbono,right(replace(NumeroCuenta,' ',''),@EstDer),1 from @PolAnterioresING
Where IdCuentaContable not in (Select IdCuentaContable from @BalPRECierreING)



	
  	Declare CICLOPRINCIPAL cursor for
							
					

					Select IdCuentaContable,NumeroCuenta,'',  
						 CargosSinFlujo, AbonosSinFlujo + ImporteAbono - ImporteCargo,
						 NCuenta, Afectable
					From @BalPRECierreING
					Order By NumeroCuenta
					
					--obtendo id y numero de poliza  
					set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),13)  -- BR 20170403 Para que tomé el consecutivo del mes 13						
					Select @NoPoliza=consecutivo + 1 from T_Consecutivos WHERE Tipo = @TipoPoliza
					select top 1 @IdPoliza=IdPoliza + 1  from T_Polizas order by IdPoliza desc
					select top 1 @IdDPoliza=Iddpoliza from D_Polizas order by IdDPoliza desc
					Set @ConceptoPoliza='Ley de ingresos por ejecutar no devengada'
					set @IDConcepto=375
					set @IdGuia=45

					---**************************************************
					--set @SaldoDeudor = (Select (ImporteAbono- ImporteCargo) + AbonosSinFlujo from @BalPRECierreING Where IdCuentaContable = @IdCuentaContable)
					
					--INSERTAR DATOS EN D_POLIZAS
							 INSERT INTO T_Polizas(idpoliza,IdCheque,idtipomovimiento,TipoPoliza,Ejercicio,Periodo,NoPoliza,Fecha,Status,Concepto,TotalCargos,TotalAbonos,idusuario,FechaAuditoria,HoraAuditoria,idguia,idconcepto )
							 VALUES (@IdPoliza,0,@IDConcepto,'D',@Ejercicio,13,@NoPoliza,@Fecha,'C',@ConceptoPoliza,@SaldoDeudor,@SaldoAcreedor,@IdUsuario,@Fecha,@Fecha,@IdGuia,@IDConcepto)
					
							OPEN CICLOPRINCIPAL
							FETCH NEXT FROM CICLOPRINCIPAL
							INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@SaldoAcreedor,@NRightCuenta,@Afectable
							WHILE @@fetch_status = 0
							BEGIN
	
										--OBTENER ID DE NUMEROS DE CUENTA A INSERTAR EN LA POLIZA
										
							Select top 1 @IdCuentaContableB=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,3)='811' and right(replace(NumeroCuenta,' ',''),@EstDer)=@NRightCuenta

										--Obtengo Total Recabado de la cuenta 81200
										
										Select @Total=Total from @Tabla81200 Where IdCuentaContable=@IdCuentaContable
										--INSERTO MOVIMIENTO PARA CUENTAS 
																				
										IF @IdCuentaContableB>0 AND @Afectable=1
										BEGIN
										
											--Sumo Valor Recolectado 81200
											--set @SaldoAcreedor=@SaldoAcreedor + @Total
											--set @SaldoAcreedor=@SaldoAcreedor - @Total --!DM 20160113
											
											IF @SaldoAcreedor<0 OR @SaldoAcreedor>0
											BEGIN
												SET @IdDPoliza=@IdDPoliza + 1
																						
													--INSERTAR DATOS EN T_POLIZAS81200
													--DM Quitar
												
													 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
													 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,@SaldoAcreedor,0,1,' ',0,0 )
													Set @TotalSaldoCargos =@TotalSaldoCargos + @SaldoAcreedor
													
																								
													Set @IdDPoliza = @IdDPoliza +1
												
													--INSERTAR DATOS EN T_POLIZAS81100
													 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo,IdSelloPresupuestal )
													 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContableB,0,@SaldoAcreedor,1,' ',0,0 )
													 
													 set @IdCuentaContableB=0
													 set @TotalSaldoAbonos=@TotalSaldoAbonos + @SaldoAcreedor
													 
													
											END 
											
																
											 Set @Total=0
										END
												
																				
							 FETCH NEXT FROM CICLOPRINCIPAL
							 INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@SaldoAcreedor,@NRightCuenta,@Afectable
							 END      
							CLOSE CICLOPRINCIPAL
  							DEALLOCATE CICLOPRINCIPAL
  							
  							UPDATE T_Polizas SET TotalCargos=@TotalSaldoCargos, TotalAbonos=@TotalSaldoAbonos WHERE IdPoliza=@IdPoliza
  							UPDATE T_Consecutivos SET Consecutivo=@NoPoliza  WHERE Tipo = @TipoPoliza
  							INSERT INTO R_PolizaGuia values(@idpoliza,@IdGuia,@IDConcepto)

		--FIN Ley de ingresos por ejecutar no devengada
  	
 --

   		INSERT into @Tabla82200	Select C_Contable.IdCuentaContable,NumeroCuenta, 
						 0,right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta, Afectable
					From C_Contable, T_SaldosInicialesCont 
					Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
					And Mes = 13 And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
					--LEFT(NumeroCuenta,@EstIzq)='82200' + replicate ('0',(@EstIzq - len('82200')))
					NumeroCuenta LIKE '822%' And Afectable = 1
					Order By NumeroCuenta


 Declare @Total82200 decimal(15,2)
	Declare @Total82300 decimal(15,2)
 --EVENTO 06
  	
  	--Presupuesto de egresos Comprometido no devengado
  	Set @IdCuentaContableB =0
	Set @NumeroCuenta= ''
	Set @NombreCuenta=''
	Set @TipoCuenta=''
	Set @Afectable=0
	Set @SaldoDeudor =0
	Set @SaldoAcreedor =0
  	Set @TotalSaldoCargos = 0
	Set @TotalSaldoAbonos = 0
	Set @TipoPoliza=''
	Set @NoPoliza=0
	Set @IdPoliza=0
	Set @IdDPoliza=0
	Set @ConceptoPoliza=''
	Set @IDConcepto=0
	Set @IdGuia=0
	Set @Total=0
	SET @RightCuenta =''
	
  	Declare CICLOPRINCIPAL cursor for
							
					Select C_Contable.IdCuentaContable,NumeroCuenta, NombreCuenta, 
						  CargosSinFlujo, AbonosSinFlujo,right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta, Afectable
					From C_Contable, T_SaldosInicialesCont 
					Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
					And Mes = 13 And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
					--LEFT(NumeroCuenta,@EstIzq)='82400' + replicate ('0',(@EstIzq - len('82400')))
					NumeroCuenta LIKE '824%' And Afectable = 1
					Order By NumeroCuenta
					
					
					--obtendo id y numero de poliza 
			        --set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),month(@Fecha)) -- BR 20170403 lo comenté y sustituí por línea de abajo
					set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),13)  -- BR 20170403 Para que tomé el consecutivo del mes 13						
					Select @NoPoliza=consecutivo + 1 from T_Consecutivos WHERE Tipo = @TipoPoliza
					select top 1 @IdPoliza=IdPoliza + 1  from T_Polizas order by IdPoliza desc
					select top 1 @IdDPoliza=Iddpoliza from D_Polizas order by IdDPoliza desc
					Set @ConceptoPoliza='Presupuesto de egresos Comprometido no devengado'
					set @IDConcepto=379
					set @IdGuia=45
					
					--INSERTAR DATOS EN D_POLIZAS
							 INSERT INTO T_Polizas(idpoliza,IdCheque,idtipomovimiento,TipoPoliza,Ejercicio,Periodo,NoPoliza,Fecha,Status,Concepto,TotalCargos,TotalAbonos,idusuario,FechaAuditoria,HoraAuditoria,idguia,idconcepto )
							 VALUES (@IdPoliza,0,@IDConcepto,'D',@Ejercicio,13,@NoPoliza,@Fecha,'C',@ConceptoPoliza,@SaldoDeudor,@SaldoAcreedor,@IdUsuario,@Fecha,@Fecha,@IdGuia,@IDConcepto)
					
							OPEN CICLOPRINCIPAL
							FETCH NEXT FROM CICLOPRINCIPAL
							INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@SaldoAcreedor,@RightCuenta,@Afectable
							WHILE @@fetch_status = 0
							BEGIN
	
											--OBTENER ID DE NUMEROS DE CUENTA A INSERTAR EN LA POLIZA
										
										--Select @IdCuentaContableB=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)='82200' + replicate ('0',(@EstIzq - len('82200')))  and right(replace(NumeroCuenta,' ',''),@EstDer)=@RightCuenta
							Select @IdCuentaContableB=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,3)='822' and right(replace(NumeroCuenta,' ',''),@EstDer)=@RightCuenta
	
										--INSERTO MOVIMIENTO PARA CUENTAS 
										
										
										IF @Afectable=1 and @IdCuentaContableB>0 
										BEGIN
											IF @SaldoDeudor<0 OR @SaldoDeudor>0
											BEGIN
														SET @IdDPoliza=@IdDPoliza + 1
																								
														--INSERTAR DATOS EN T_POLIZAS82200
														 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
														 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContableB,@SaldoDeudor,0,1,' ',0,0 )
														Set @TotalSaldoCargos =@TotalSaldoCargos + @SaldoDeudor
																								
													Set @IdDPoliza = @IdDPoliza +1
													
														--INSERTAR DATOS EN T_POLIZAS82400
														 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo,IdSelloPresupuestal )
														 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,0,@SaldoDeudor,1,' ',0,0 )
														 
														 set @TotalSaldoAbonos=@TotalSaldoAbonos + @SaldoDeudor
														 
													 													 
													 --INSERTAR EN TABLA TEMPORAL DE 82200
													UPDATE @Tabla82200 SET Total=@SaldoDeudor WHERE IdCuentaContable=@IdCuentaContableB
														 
												 END
										END
										
																				
							 FETCH NEXT FROM CICLOPRINCIPAL
							 INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@SaldoAcreedor,@RightCuenta,@Afectable
							 END      
							CLOSE CICLOPRINCIPAL
  							DEALLOCATE CICLOPRINCIPAL
  							
  							
  							UPDATE T_Polizas SET TotalCargos=@TotalSaldoCargos, TotalAbonos=@TotalSaldoAbonos WHERE IdPoliza=@IdPoliza
  							UPDATE T_Consecutivos SET Consecutivo=@NoPoliza  WHERE Tipo = @TipoPoliza
  							INSERT INTO R_PolizaGuia values(@idpoliza,@IdGuia,@IDConcepto)

	--Evento 07

	--Traspaso al cierre del ejercicio de las modificaciones negativas al Presupuesto aprobado.
  				Set @IdCuentaContableB =0
				Set @NumeroCuenta= ''
				Set @NombreCuenta=''
				Set @TipoCuenta=''
				Set @Afectable=0
				Set @SaldoDeudor =0
				Set @SaldoAcreedor =0
  				Set @TotalSaldoCargos = 0
				Set @TotalSaldoAbonos = 0
				Set @TipoPoliza=''
				Set @NoPoliza=0
				Set @IdPoliza=0
				Set @IdDPoliza=0
				Set @ConceptoPoliza=''
				Set @IDConcepto=0
				Set @IdGuia=0
				Set @Total=0
				
  				Declare CICLOPRINCIPAL cursor for
										

								Select C_Contable.IdCuentaContable,NumeroCuenta, NombreCuenta, 
									  SUM(TotalCargos) as TotalCargos,Afectable, right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta
								From C_Contable, T_SaldosInicialesCont 
								Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
								And (mes between 1 and 12) And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
								 --LEFT(NumeroCuenta,@EstIzq)='82300'  + replicate ('0',(@EstIzq - len('82300'))) AND Afectable = 1
								 NumeroCuenta LIKE '823%' And Afectable = 1
								 Group by C_Contable.IdCuentaContable, C_Contable.NumeroCuenta, C_Contable.NombreCuenta, C_Contable.Afectable
								Order By NumeroCuenta
								
								--obtendo id y numero de poliza 
								--set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),month(@Fecha)) -- BR 20170403 lo comenté y sustituí por línea de abajo
								set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),13)  -- BR 20170403 Para que tomé el consecutivo del mes 13									
								Select @NoPoliza=consecutivo + 1 from T_Consecutivos WHERE Tipo = @TipoPoliza
								select top 1 @IdPoliza=IdPoliza + 1  from T_Polizas order by IdPoliza desc
								select top 1 @IdDPoliza=Iddpoliza from D_Polizas order by IdDPoliza desc
								Set @ConceptoPoliza='Traspaso al cierre del ejercicio de las modificaciones negativas al Presupuesto aprobado.'
								set @IDConcepto=380
								set @IdGuia=45
								
								--INSERTAR DATOS EN D_POLIZAS
										 INSERT INTO T_Polizas(idpoliza,IdCheque,idtipomovimiento,TipoPoliza,Ejercicio,Periodo,NoPoliza,Fecha,Status,Concepto,TotalCargos,TotalAbonos,idusuario,FechaAuditoria,HoraAuditoria,idguia,idconcepto )
										 VALUES (@IdPoliza,0,@IDConcepto,'D',@Ejercicio,13,@NoPoliza,@Fecha,'C',@ConceptoPoliza,@SaldoDeudor,@SaldoAcreedor,@IdUsuario,@Fecha,@Fecha,@IdGuia,@IDConcepto)
								
										OPEN CICLOPRINCIPAL
										FETCH NEXT FROM CICLOPRINCIPAL
										INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@Afectable,@RightCuenta
										WHILE @@fetch_status = 0
										BEGIN
				
														--OBTENER ID DE NUMEROS DE CUENTA A INSERTAR EN LA POLIZA
													
													--Select @IdCuentaContableB=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)='82200' + replicate ('0',(@EstIzq - len('82200'))) and right(replace(NumeroCuenta,' ',''),@EstDer)=@RightCuenta
												Select @IdCuentaContableB=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,3)='822' and right(replace(NumeroCuenta,' ',''),@EstDer)=@RightCuenta
											
													IF @Afectable=1 --and @IdCuentaContableB>0 
													BEGIN
													
														IF 1=1--@SaldoDeudor<0 OR @SaldoDeudor>0
														BEGIN
																--INSERTO MOVIMIENTO PARA CUENTAS 
																	SET @IdDPoliza=@IdDPoliza + 1
																	
															
																--INSERTAR DATOS EN T_POLIZAS82200
																 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
																 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContableB,@SaldoDeudor,0,1,' ',0,0 )
																
																set @TotalSaldoCargos=@TotalSaldoCargos + @SaldoDeudor
																											
																Set @IdDPoliza = @IdDPoliza +1
															
																--INSERTAR DATOS EN T_POLIZAS82300
																 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo,IdSelloPresupuestal )
																 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,0,@SaldoDeudor,1,' ',0,0 )
																 Set @TotalSaldoAbonos =@TotalSaldoAbonos+ @SaldoDeudor
																 																 
																 --INSERTAR EN TABLA TEMPORAL DE 82200
																UPDATE @Tabla82200 SET Total=Total + @SaldoDeudor Where IdCuentaContable=@IdCuentaContableB

														 END
															 
													END
													
																							
										 FETCH NEXT FROM CICLOPRINCIPAL
										 INTO  @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@Afectable,@RightCuenta
										 END      
										CLOSE CICLOPRINCIPAL
  										DEALLOCATE CICLOPRINCIPAL
			  							
			  							
  										UPDATE T_Polizas SET TotalCargos=@TotalSaldoCargos, TotalAbonos=@TotalSaldoAbonos WHERE IdPoliza=@IdPoliza
  										UPDATE T_Consecutivos SET Consecutivo=@NoPoliza  WHERE Tipo = @TipoPoliza
  										INSERT INTO R_PolizaGuia values(@idpoliza,@IdGuia,@IDConcepto)

--EVENTO 08
	--Select '2'
  	  					--Traspaso al cierre del ejercicio de las modificaciones positivas al Presupuesto aprobado
  					Set @IdCuentaContableB =0
					Set @NumeroCuenta= ''
					Set @NombreCuenta=''
					Set @TipoCuenta=''
					Set @Afectable=0
					Set @SaldoDeudor =0
					Set @SaldoAcreedor =0
  					Set @TotalSaldoCargos = 0
					Set @TotalSaldoAbonos = 0
					Set @TipoPoliza=''
					Set @NoPoliza=0
					Set @IdPoliza=0
					Set @IdDPoliza=0
					Set @ConceptoPoliza=''
					Set @IDConcepto=0
					Set @IdGuia=0
					Set @Total=0
					
  					Declare CICLOPRINCIPAL cursor for
											

								Select C_Contable.IdCuentaContable,NumeroCuenta, NombreCuenta, 
									  --SUM(TotalCargos) as TotalCargos,Afectable, right(replace(NumeroCuenta,' ',''),5) as NCuenta
									  SUM(TotalAbonos) as TotalAbonos,Afectable, right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta
								From C_Contable, T_SaldosInicialesCont 
								Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
								And (mes between 1 and 12) And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
								-- LEFT(NumeroCuenta,@EstIzq)='82300'  + replicate ('0',(@EstIzq - len('82300'))) AND Afectable = 1
								NumeroCuenta LIKE '823%' And Afectable = 1
								 Group by C_Contable.IdCuentaContable, C_Contable.NumeroCuenta, C_Contable.NombreCuenta, C_Contable.Afectable
								Order By NumeroCuenta
									
									--obtendo id y numero de poliza 
									--set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),month(@Fecha)) -- BR 20170403 lo comenté y sustituí por línea de abajo
									set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),13)  -- BR 20170403 Para que tomé el consecutivo del mes 13										
									Select @NoPoliza=consecutivo + 1 from T_Consecutivos WHERE Tipo = @TipoPoliza
									select top 1 @IdPoliza=IdPoliza + 1  from T_Polizas order by IdPoliza desc
									select top 1 @IdDPoliza=Iddpoliza from D_Polizas order by IdDPoliza desc
									Set @ConceptoPoliza='Traspaso al cierre del ejercicio de las modificaciones positivas al Presupuesto aprobado'
									set @IDConcepto=381
									set @IdGuia=45
									
									--INSERTAR DATOS EN D_POLIZAS
											 INSERT INTO T_Polizas(idpoliza,IdCheque,idtipomovimiento,TipoPoliza,Ejercicio,Periodo,NoPoliza,Fecha,Status,Concepto,TotalCargos,TotalAbonos,idusuario,FechaAuditoria,HoraAuditoria,idguia,idconcepto )
											 VALUES (@IdPoliza,0,@IDConcepto,'D',@Ejercicio,13,@NoPoliza,@Fecha,'C',@ConceptoPoliza,@SaldoDeudor,@SaldoAcreedor,@IdUsuario,@Fecha,@Fecha,@IdGuia,@IDConcepto)
									
											OPEN CICLOPRINCIPAL
											FETCH NEXT FROM CICLOPRINCIPAL
											INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@Afectable,@RightCuenta
											WHILE @@fetch_status = 0
											BEGIN
					
															--OBTENER ID DE NUMEROS DE CUENTA A INSERTAR EN LA POLIZA
														
														--Select @IdCuentaContableB=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)='82200' + replicate ('0',(@EstIzq - len('82200')))  and right(replace(NumeroCuenta,' ',''),@EstDer)=@RightCuenta
														Select @IdCuentaContableB=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,3)='822' and right(replace(NumeroCuenta,' ',''),@EstDer)=@RightCuenta

														IF @Afectable=1 --and @IdCuentaContableB>0 
														BEGIN
														
																IF  1=1--@SaldoDeudor<0 OR @SaldoDeudor>0
																BEGIN
																			--INSERTO MOVIMIENTO PARA CUENTAS 
																			SET @IdDPoliza=@IdDPoliza + 1
																		
																		
																			--INSERTAR DATOS EN T_POLIZAS82200
																			 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
																			 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContableB,0,@SaldoDeudor,1,' ',0,0 )
																			 Set @TotalSaldoAbonos =@TotalSaldoAbonos+ @SaldoDeudor
																			 
																														
																			Set @IdDPoliza = @IdDPoliza +1
																		
																			--INSERTAR DATOS EN T_POLIZAS82300
																			 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo,IdSelloPresupuestal )
																			 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,@SaldoDeudor,0,1,' ',0,0 )
																			set @TotalSaldoCargos=@TotalSaldoCargos + @SaldoDeudor
																			
																			
																			 --INSERTAR EN TABLA TEMPORAL DE 82200
																			UPDATE @Tabla82200 SET Total=Total - @SaldoDeudor   Where IdCuentaContable=@IdCuentaContableB

																	
																	END
														END
														
																								
											 FETCH NEXT FROM CICLOPRINCIPAL
											 INTO  @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@Afectable,@RightCuenta
											 END      
											CLOSE CICLOPRINCIPAL
  											DEALLOCATE CICLOPRINCIPAL
				  							
				  							
  											UPDATE T_Polizas SET TotalCargos=@TotalSaldoCargos, TotalAbonos=@TotalSaldoAbonos WHERE IdPoliza=@IdPoliza
  											UPDATE T_Consecutivos SET Consecutivo=@NoPoliza  WHERE Tipo = @TipoPoliza
  											INSERT INTO R_PolizaGuia values(@idpoliza,@IdGuia,@IDConcepto)
			  	
		  	
	--EVENTO 05	
--INICIA PROCESO PARA CUENTAS 82200 Presupuesto de egresos por ejercer no Comprometido

			
			
			SET @IdCuentaContable =0
			SET @IdCuentaContableB =0
			SET @NumeroCuenta =''
			SET @NombreCuenta=''
			SET @TipoCuenta =''
			SET @SaldoDeudor =0
			SET @SaldoAcreedor =0
			SET @IdPoliza =0
			SET @NoPoliza =0
			SET @IdDPoliza =0
			SET @ConceptoPoliza=''
			SET @TotalSaldoCargos=0
			SET @TotalSaldoAbonos =0
			SET @Total =0
			SET @IdGuia =0
			SET @IDConcepto =0
			SET @TipoPoliza =''
			SET @NRightCuenta =''
			SET @RightCuenta =''
			SET @NLeftCuenta =''
			SET @Afectable =0
			
			--Declare @Tabla82200 Table (IdCuentaContable bigint, NumeroCuenta varchar(30) ,Total decimal(15,2),RightCuenta varchar(6), Opcion bigint)
			SET @EstIzq =0
			SET @EstDer =0
						--Obtengo Estructura Contable
			SELECT @EstIzq=Left(VALOR,1)  , @EstDer=RIGHT(Valor,1)  FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'
--------------------------------------------------------------------------------------------------------------------------------------
Declare @BalPRECierreEGR as Table (NumeroCuenta varchar(50),IdCuentaContable int, CargosSinFlujo decimal(18,2), AbonosSinFlujo decimal(18,2), ImporteCargo decimal(18,2), ImporteAbono decimal(18,2), NCuenta varchar(50), Afectable int)
Insert into @BalPRECierreEGR
Select NumeroCuenta, C_Contable.IdCuentaContable, 
						 CargosSinFlujo, AbonosSinFlujo,
						 0,0,
						 right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta, Afectable
					From C_Contable, T_SaldosInicialesCont 
					Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
					And Mes = 13 And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
					--LEFT(NumeroCuenta,@EstIzq)='82200' + replicate ('0',(@EstIzq - len('82200')))
					NumeroCuenta LIKE '822%' And Afectable = 1
					AND (CargosSinFlujo + AbonosSinFlujo != 0)
					Order By NumeroCuenta

Declare @PolAnterioresEGR as Table (NumeroCuenta varchar(50),IdCuentaContable int, CargosSinFlujo decimal(18,2), AbonosSinFlujo decimal(18,2), ImporteCargo decimal(18,2), ImporteAbono decimal(18,2))

Insert into @PolAnterioresEGR
Select C_Contable.NumeroCuenta,
D_Polizas.IdCuentaContable, CargosSinFlujo, AbonosSinFlujo, SUM(D_Polizas.ImporteCargo) as ImporteCargo, SUM(D_Polizas.ImporteAbono) as ImporteAbono  
from D_Polizas 
LEFT Join C_Contable on  C_Contable.IdCuentaContable = D_Polizas.IdCuentaContable
JOIN T_SaldosInicialesCont ON D_Polizas.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable and Year = @Ejercicio and Mes = 13
where 
 IdPoliza in (Select IdPoliza from T_Polizas where Ejercicio = @Ejercicio and Periodo = 13)
--AND LEFT(NumeroCuenta,@EstIzq)='82200'
AND LEFT(NumeroCuenta,3)='822'
Group by C_Contable.NumeroCuenta, D_Polizas.IdCuentaContable, T_SaldosInicialesCont.CargosSinFlujo, T_SaldosInicialesCont.AbonosSinFlujo
order by C_Contable.NumeroCuenta


Update  Bal set Bal.ImporteCargo = Pol.ImporteCargo, Bal.ImporteAbono = Pol.ImporteAbono
From @BalPRECierreEGR Bal JOIN @PolAnterioresEGR Pol ON Bal.IdCuentaContable = Pol.IdCuentaContable

Insert Into @BalPRECierreEGR
Select NumeroCuenta,IdCuentaContable,CargosSinFlujo,AbonosSinFlujo,ImporteCargo,ImporteAbono,right(replace(NumeroCuenta,' ',''),@EstDer),1 from @PolAnterioresEGR
Where IdCuentaContable not in (Select IdCuentaContable from @BalPRECierreEGR)


-----------------------------------------------------------------------------------------------------------------------------------------
			


			
			Declare CICLOPRINCIPAL cursor for
									
					Select IdCuentaContable,NumeroCuenta,'',  
						 CargosSinFlujo + ImporteCargo-ImporteAbono, 0,
						 NCuenta, Afectable
					From @BalPRECierreEGR
					Order By NumeroCuenta
					
					--obtendo id y numero de poliza 
			        --set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),month(@Fecha)) -- BR 20170403 lo comenté y sustituí por línea de abajo
					set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),13)  -- BR 20170403 Para que tomé el consecutivo del mes 13						
					Select @NoPoliza=consecutivo + 1 from T_Consecutivos WHERE Tipo = @TipoPoliza
					select top 1 @IdPoliza=IdPoliza + 1  from T_Polizas order by IdPoliza desc
					select top 1 @IdDPoliza=Iddpoliza from D_Polizas order by IdDPoliza desc
					Set @ConceptoPoliza='Presupuesto de egresos por ejercer no Comprometido'
					set @TotalSaldoAbonos=0
					set @TotalSaldoCargos=0
					set @IDConcepto=378
					set @IdGuia=45
					set @Total82200=0
					
					--INSERTAR DATOS EN D_POLIZAS
							 INSERT INTO T_Polizas(idpoliza,IdCheque,idtipomovimiento,TipoPoliza,Ejercicio,Periodo,NoPoliza,Fecha,Status,Concepto,TotalCargos,TotalAbonos,idusuario,FechaAuditoria,HoraAuditoria,idguia,idconcepto )
							 VALUES (@IdPoliza,0,@IDConcepto,'D',@Ejercicio,13,@NoPoliza,@Fecha,'C',@ConceptoPoliza,@SaldoDeudor,@SaldoAcreedor,@IdUsuario,@Fecha,@Fecha,@IdGuia,@IDConcepto)
					
							OPEN CICLOPRINCIPAL
							FETCH NEXT FROM CICLOPRINCIPAL
							INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@SaldoAcreedor,@RightCuenta,@Afectable
							WHILE @@fetch_status = 0
							BEGIN
	
										--OBTENER ID DE NUMEROS DE CUENTA A INSERTAR EN LA POLIZA
										
										--Select @IdCuentaContableB=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)='82100' + replicate ('0',(@EstIzq - len('82100')))  and right(replace(NumeroCuenta,' ',''),@EstDer)=@RightCuenta
										Select @IdCuentaContableB=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,3)='821' and right(replace(NumeroCuenta,' ',''),@EstDer)=@RightCuenta

										--Obtengo Total Recabado de la cuenta 82200
										Select @Total=Total from @Tabla82200 Where IdCuentaContable=@IdCuentaContable
										
										--INSERTO MOVIMIENTO PARA CUENTAS 
										
										
										IF @Afectable=1 and @IdCuentaContableB>0 
										BEGIN										 
										
										 
											IF @SaldoDeudor<0 OR @SaldoDeudor>0
											BEGIN
													SET @IdDPoliza=@IdDPoliza + 1
												
													
													
													--INSERTAR DATOS EN T_POLIZAS 82100
													 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
													 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContableB,@SaldoDeudor,0,1,' ',0,0 )
													Set @TotalSaldoCargos =@TotalSaldoCargos + @SaldoDeudor
													
													--INSERTAR EN TABLA TEMPORAL DE 82200
													INSERT INTO @Tabla82200(IdCuentaContable,NumeroCuenta,Total,RightCuenta ,Opcion) 
													Values(@IdCuentaContableB,@NumeroCuenta, @SaldoDeudor , @NRightCuenta ,1)
													
																						
													Set @IdDPoliza = @IdDPoliza +1
												
													--INSERTAR DATOS EN T_POLIZAS82200
													 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo,IdSelloPresupuestal )
													 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,0,@SaldoDeudor,1,' ',0,0 )
													 Set @Total82200=@Total82200+ @SaldoDeudor
													 set @TotalSaldoAbonos=@TotalSaldoAbonos + @SaldoDeudor
													 
													 
											 END
											 
											 Set @Total=0
										END
								
																				
							 FETCH NEXT FROM CICLOPRINCIPAL
							 INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@SaldoAcreedor,@RightCuenta,@Afectable
							 END      
							CLOSE CICLOPRINCIPAL
  							DEALLOCATE CICLOPRINCIPAL
  							  							
  							UPDATE T_Polizas SET TotalCargos=@TotalSaldoCargos , TotalAbonos=@TotalSaldoAbonos WHERE IdPoliza=@IdPoliza
  							UPDATE T_Consecutivos SET Consecutivo=@NoPoliza  WHERE Tipo = @TipoPoliza
  							INSERT INTO R_PolizaGuia values(@idpoliza,@IdGuia,@IDConcepto)


--EVENTO 09
 --INICIA PROCESO  Asiento Final de los gastos durante el ejercicio (Determinación de Adeudos de Ejercicios Fiscales Anteriores)
 
			Declare @Total93000 as decimal(15,2)
			SET @Total93000 =0
			SET @IdCuentaContable =0
			SET @IdCuentaContableB =0
			SET @NumeroCuenta=''
			SET @NombreCuenta =''
			SET @TipoCuenta =''
			SET @SaldoDeudor =0
			SET @SaldoAcreedor =0
			SET @IdPoliza =0
			SET @NoPoliza =0
			SET @IdDPoliza =0
			SET @ConceptoPoliza =''
			SET @TotalSaldoCargos =0
			SET @TotalSaldoAbonos =0
			SET @Total =0
			SET @IdGuia =0
			SET @IDConcepto =0
			SET @TipoPoliza =''
			SET @NRightCuenta =''
			SET @RightCuenta =''
			SET @NLeftCuenta =''
			SET @Afectable =0
			SET @EstIzq=0
			SET @EstDer =0
			
			--Obtengo Estructura Contable
			SELECT @EstIzq=Left(VALOR,1)  , @EstDer=RIGHT(Valor,1)  FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'
	
					
			Declare CICLOPRINCIPAL cursor for
									
				Select C_Contable.IdCuentaContable,NumeroCuenta, NombreCuenta, 
						  CargosSinFlujo, AbonosSinFlujo,right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta, Afectable
					From C_Contable, T_SaldosInicialesCont 
					Where ( C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
					And Mes = 13 And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
					--LEFT(NumeroCuenta,@EstIzq)='82500' +  replicate ('0',(@EstIzq - len('82500'))) ) OR  ( C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
					LEFT(NumeroCuenta,3)='825' ) OR  ( C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
					And Mes = 13 And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
					--LEFT(NumeroCuenta,@EstIzq)='82600' +  replicate ('0',(@EstIzq - len('82600'))) )
					LEFT(NumeroCuenta,3)='826'  )
					Order By NumeroCuenta
					
					--obtendo id y numero de poliza 
			        --set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),month(@Fecha)) -- BR 20170403 lo comenté y sustituí por línea de abajo
					set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),13)  -- BR 20170403 Para que tomé el consecutivo del mes 13						
					Select @NoPoliza=consecutivo + 1 from T_Consecutivos WHERE Tipo = @TipoPoliza
					select top 1 @IdPoliza=IdPoliza + 1  from T_Polizas order by IdPoliza desc
					select top 1 @IdDPoliza=Iddpoliza from D_Polizas order by IdDPoliza desc
					Set @ConceptoPoliza='Asiento Final de los gastos durante el ejercicio (Determinación de Adeudos de Ejercicios Fiscales Anteriores)'
					set @TotalSaldoAbonos=0
					set @TotalSaldoCargos=0
					set @IDConcepto=382
					set @IdGuia=45
										
					--INSERTAR DATOS EN D_POLIZAS
							 INSERT INTO T_Polizas(idpoliza,IdCheque,idtipomovimiento,TipoPoliza,Ejercicio,Periodo,NoPoliza,Fecha,Status,Concepto,TotalCargos,TotalAbonos,idusuario,FechaAuditoria,HoraAuditoria,idguia,idconcepto )
							 VALUES (@IdPoliza,0,@IDConcepto,'D',@Ejercicio,13,@NoPoliza,@Fecha,'C',@ConceptoPoliza,@SaldoDeudor,@SaldoAcreedor,@IdUsuario,@Fecha,@Fecha,@IdGuia,@IDConcepto)
					
							OPEN CICLOPRINCIPAL
							FETCH NEXT FROM CICLOPRINCIPAL
							INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@SaldoAcreedor,@NRightCuenta,@Afectable
							WHILE @@fetch_status = 0
							BEGIN
											
										--INSERTO MOVIMIENTO PARA CUENTAS 
										
										
										IF @Afectable=1 and @SaldoDeudor<>0
										BEGIN
										
										SET @IdDPoliza=@IdDPoliza + 1
										
											--INSERTAR DATOS EN T_POLIZAS
											 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
											 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,0,@SaldoDeudor,1,' ',0,0 )
											Set @TotalSaldoCargos =@TotalSaldoCargos + @SaldoDeudor
											Set @TotalSaldoAbonos =@TotalSaldoCargos + @SaldoDeudor
										END
																		
							 FETCH NEXT FROM CICLOPRINCIPAL
							 INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@SaldoAcreedor,@NRightCuenta,@Afectable
							 END      
							CLOSE CICLOPRINCIPAL
  							DEALLOCATE CICLOPRINCIPAL
  							
  							
  							Select @IdCuentaContable=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)='93000' +  replicate ('0',(@EstIzq - len('93000')))
  							Set @IdDPoliza = @IdDPoliza +1
  							--INSERTO MOVIMIENTO DETALLE DE POLIZA DE CUENTA 93000
  								 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
								 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,@TotalSaldoCargos,0,1,' ',0,0 )
  							
  							SET @Total93000=@TotalSaldoCargos
  							
  							UPDATE T_Polizas SET TotalCargos=@TotalSaldoCargos , TotalAbonos=@TotalSaldoAbonos WHERE IdPoliza=@IdPoliza
  							UPDATE T_Consecutivos SET Consecutivo=@NoPoliza  WHERE Tipo = @TipoPoliza
  							INSERT INTO R_PolizaGuia values(@idpoliza,@IdGuia,@IDConcepto)


	--EVENTO 10 y 11
 
 --INICIA PROCESO PARA CUENTAS 81500 Y 82700

			
			Declare @ConceptoPolizaB varchar(120)
			
			Declare @IDConceptoB bigint
			
			Declare @Total81500 decimal(15,2)
			Declare @Total82700 decimal(15,2)
			Declare @Diferencia decimal (15,2)
			SET @EstIzq =0
			SET @EstDer =0
			
			--Obtengo Estructura Contable
			SELECT @EstIzq=Left(VALOR,1)  , @EstDer=RIGHT(Valor,1)  FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'
			
			Declare CICLOPRINCIPAL cursor for
									
					Select C_Contable.IdCuentaContable,NumeroCuenta, NombreCuenta, 
						  CargosSinFlujo, AbonosSinFlujo,right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta, Afectable
					From C_Contable, T_SaldosInicialesCont 
					Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
					And Mes = 13 And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
					--LEFT(NumeroCuenta,@EstIzq)='81500' + replicate ('0',(@EstIzq - len('81500'))) 
					LEFT(NumeroCuenta,3)='815'
					OR
					C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
					And Mes =13 And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
					--LEFT(NumeroCuenta,@EstIzq)='82700' + replicate ('0',(@EstIzq - len('82700'))) 
					LEFT(NumeroCuenta,3)='827'
					Order By NumeroCuenta
					
					--obtendo id y numero de poliza 
			        --set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),month(@Fecha)) -- BR 20170403 lo comenté y sustituí por línea de abajo
					set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),13)  -- BR 20170403 Para que tomé el consecutivo del mes 13						
					Select @NoPoliza=consecutivo + 1 from T_Consecutivos WHERE Tipo = @TipoPoliza
					select top 1 @IdPoliza=IdPoliza + 1  from T_Polizas order by IdPoliza desc
					select top 1 @IdDPoliza=Iddpoliza from D_Polizas order by IdDPoliza desc
					Set @ConceptoPoliza='Asiento Final de acuerdo con la Ley de Presupuesto (Superávit Financiero)'
					Set @ConceptoPolizaB='Asiento Final de acuerdo con la Ley de Presupuesto (Déficit Financiero)'
					set @TotalSaldoAbonos=0
					set @TotalSaldoCargos=0
					set @IDConcepto=383
					set @IDConceptoB=384
					set @IdGuia=45
					set @Total81500=0
					set @Total82700=0
					set @Diferencia=0
					
					--INSERTAR DATOS EN D_POLIZAS
							 INSERT INTO T_Polizas(idpoliza,IdCheque,idtipomovimiento,TipoPoliza,Ejercicio,Periodo,NoPoliza,Fecha,Status,Concepto,TotalCargos,TotalAbonos,idusuario,FechaAuditoria,HoraAuditoria,idguia,idconcepto )
							 VALUES (@IdPoliza,0,@IDConcepto,'D',@Ejercicio,13,@NoPoliza,@Fecha,'C',@ConceptoPoliza,@SaldoDeudor,@SaldoAcreedor,@IdUsuario,@Fecha,@Fecha,@IdGuia,@IDConcepto)
					
							OPEN CICLOPRINCIPAL
							FETCH NEXT FROM CICLOPRINCIPAL
							INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@SaldoAcreedor,@NRightCuenta,@Afectable
							WHILE @@fetch_status = 0
							BEGIN
										--INSERTO MOVIMIENTO PARA CUENTAS 
																				
										IF @Afectable=1 
										BEGIN
											--IF LEFT(@NumeroCuenta,@EstIzq)= '81500' + replicate ('0',(@EstIzq - len('81500')))
											IF LEFT(@NumeroCuenta,3)= '815'
											BEGIN
												--CUENTAS 81500
												IF @SaldoAcreedor<0 OR @SaldoAcreedor>0
												BEGIN
														SET @IdDPoliza=@IdDPoliza + 1
													
														--INSERTAR DATOS EN T_POLIZAS
														 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
														 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,@SaldoAcreedor,0,1,' ',0,0 )
														Set @TotalSaldoCargos =@TotalSaldoCargos + @SaldoAcreedor
														set @Total81500=@TotalSaldoCargos
												END	
											END	
											
											--IF LEFT(@NumeroCuenta,@EstIzq)= '82700' + replicate ('0',(@EstIzq - len('82700')))
											IF LEFT(@NumeroCuenta,3)= '827'
											BEGIN	
												--CUENTAS 82700
												IF @SaldoDeudor<0 OR @SaldoDeudor>0
												BEGIN
														SET @IdDPoliza=@IdDPoliza + 1
													
														--INSERTAR DATOS EN T_POLIZAS
														 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
														 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,0,@SaldoDeudor,1,' ',0,0 )
														set @TotalSaldoAbonos=@TotalSaldoAbonos + @SaldoDeudor
														set @Total82700 = @TotalSaldoAbonos
												END		
											END 
										END
																			
							 FETCH NEXT FROM CICLOPRINCIPAL
							 INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@SaldoAcreedor,@NRightCuenta,@Afectable
							 END      
							CLOSE CICLOPRINCIPAL
  							DEALLOCATE CICLOPRINCIPAL
  							
  							--SELECCIONO EVENTO FINAL 
  							Set @Diferencia= @Total81500-@Total82700- @Total93000
  							  							
  							IF @Diferencia < 0 
  							BEGIN
  								
  								SET @IdDPoliza=@IdDPoliza + 1
  								--SET @SaldoDeudor= @Diferencia * -1 
  								SET @SaldoDeudor= @Diferencia --- @Total93000
  								SET @SaldoDeudor = @SaldoDeudor * -1 
  								
								
								--Select @IdCuentaContable=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)= '92000' + replicate ('0',(@EstIzq - len('92000')))  And Right(NumeroCuenta,@EstDer)='00000' + replicate ('0',(@EstDer - len('00000')))
								Select @IdCuentaContable=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)= '92000' + replicate ('0',(@EstIzq - len('92000')))  And Right(NumeroCuenta,@EstDer)='00000' + replicate ('0',(@EstDer - len('00000')))

													
									--INSERTAR DATOS EN T_POLIZAS Evento 11
									INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
								    VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,@SaldoDeudor,0,1,' ',0,0 )
									set @TotalSaldoCargos=@TotalSaldoCargos + @SaldoDeudor
									set @Total82700 = @TotalSaldoCargos
								
								--#######CAMBIO NUEVO GUIA EVENTO 11
								SET @IdDPoliza=@IdDPoliza + 1
  								SET @SaldoAcreedor= @Total93000
  									
								--Select @IdCuentaContable=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)= '93000' + replicate ('0',(@EstIzq - len('93000')))  And Right(NumeroCuenta,@EstDer)='00000' + replicate ('0',(@EstDer - len('00000')))
  			   					  Select @IdCuentaContable=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)= '93000' + replicate ('0',(@EstIzq - len('93000')))  And Right(NumeroCuenta,@EstDer)='00000' + replicate ('0',(@EstDer - len('00000')))
	
  								--######INSERTAR DATOS  EN T_POLIZAS
									INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
								    VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,0,@SaldoAcreedor,1,' ',0,0 )
									set @TotalSaldoAbonos =@TotalSaldoAbonos + @SaldoAcreedor
									  								
  							
  							END
  							ELSE
  							BEGIN
  								SET @IdDPoliza=@IdDPoliza + 1
								SET @SaldoAcreedor=@Diferencia
								
								SET @SaldoAcreedor = @SaldoAcreedor --- @Total93000
								
								--Select @IdCuentaContable=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)= '91000' + replicate ('0',(@EstIzq - len('91000')))  And Right(NumeroCuenta,@EstDer)='00000' + replicate ('0',(@EstDer - len('00000')))
								Select @IdCuentaContable=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)= '91000' + replicate ('0',(@EstIzq - len('91000'))) and  Right(NumeroCuenta,@EstDer)='00000' + replicate ('0',(@EstDer - len('00000')))

								
									--INSERTAR DATOS EN T_POLIZAS Evento 10 
									 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
									 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,0,@SaldoAcreedor,1,' ',0,0 )
									--Set @TotalSaldoCargos =@TotalSaldoCargos + @SaldoAcreedor
									Set @TotalSaldoAbonos =@TotalSaldoAbonos + @SaldoAcreedor
									set @Total81500=@TotalSaldoCargos
  							
  							--#######CAMBIO NUEVO GUIA EVENTO 10
  							
  								SET @IdDPoliza=@IdDPoliza + 1
								SET @SaldoAcreedor= @Total93000
								
								--Select @IdCuentaContable=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)= '93000' + replicate ('0',(@EstIzq - len('93000')))  And Right(NumeroCuenta,@EstDer)='00000' + replicate ('0',(@EstDer - len('00000')))
								Select @IdCuentaContable=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)= '93000' + replicate ('0',(@EstIzq - len('93000')))  And Right(NumeroCuenta,@EstDer)='00000' + replicate ('0',(@EstDer - len('00000')))

								
									--INSERTAR DATOS EN T_POLIZAS Evento 10
									 INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
									 VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,0,@SaldoAcreedor,1,' ',0,0 )
									Set @TotalSaldoAbonos =@TotalSaldoAbonos + @SaldoAcreedor
									
									
  							
  							
  							END
  							
  							IF @Diferencia > 0 
  							BEGIN  							
  								UPDATE T_Polizas SET TotalCargos=@TotalSaldoCargos , TotalAbonos=@TotalSaldoAbonos WHERE IdPoliza=@IdPoliza
  							END
  							ELSE
  							BEGIN
  								UPDATE T_Polizas SET TotalCargos=@TotalSaldoCargos , TotalAbonos=@TotalSaldoAbonos ,Concepto=@ConceptoPolizaB WHERE IdPoliza=@IdPoliza
  								SET @IDConcepto=@IDConceptoB
  							END
  							
  							UPDATE T_Consecutivos SET Consecutivo=@NoPoliza  WHERE Tipo = @TipoPoliza
  							INSERT INTO R_PolizaGuia values(@idpoliza,@IdGuia,@IDConcepto)
  	--#############################################################		
	

	--EVENTO 12 Y 13
 
 
 --Obtengo Estructura Contable
 Declare @SaldoDeudor82100 as decimal(15,2)
 Declare @SaldoDeudor82200 as decimal(15,2)
 Declare @SaldoDeudor91000 as decimal(15,2)
 Declare @SaldoAcreedor81100 as decimal(15,2)
 Declare @SaldoAcreedor81200 as decimal(15,2)
 Declare @SaldoAcreedor92000 as decimal(15,2)
 Declare @Tabla81100R Table (IdCuentaContable bigint, NumeroCuenta varchar(30),Total decimal(15,2),RightCuenta varchar(6),Afectable int)
 Declare @Tabla82100R Table (IdCuentaContable bigint, NumeroCuenta varchar(30) ,Total decimal(15,2),RightCuenta varchar(6), Afectable int)
 Declare @Total81100R decimal(15,2)
Declare @Total82100R decimal(15,2)

 
SELECT @EstIzq=Left(VALOR,1)  , @EstDer=RIGHT(Valor,1)  FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'

BEGIN--Proceso para obtener montos de 82100 R

		 Declare CICLOPRINCIPAL cursor for
					
						--Tabla Evento 05 @BalPRECierreEGR	
						
					
				Select D_Polizas.IdCuentaContable,
				C_Contable.NumeroCuenta, '',				 
				AbonosSinFlujo + (SUM(D_Polizas.ImporteAbono) - SUM(D_Polizas.ImporteCargo)) as Total,
				right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta, Afectable
				from D_Polizas 
				LEFT Join C_Contable on  C_Contable.IdCuentaContable = D_Polizas.IdCuentaContable
				JOIN T_SaldosInicialesCont ON D_Polizas.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable and Year = @Ejercicio and Mes = 13
				where
				 IdPoliza in (Select IdPoliza from T_Polizas where Ejercicio = @Ejercicio and Periodo = 13)
				--AND LEFT(NumeroCuenta,@EstIzq)='82100'
				AND LEFT(NumeroCuenta,3)='821'
				Group by C_Contable.NumeroCuenta, D_Polizas.IdCuentaContable, T_SaldosInicialesCont.CargosSinFlujo, T_SaldosInicialesCont.AbonosSinFlujo, C_Contable.Afectable
				order by C_Contable.NumeroCuenta


					OPEN CICLOPRINCIPAL
					FETCH NEXT FROM CICLOPRINCIPAL
					INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoAcreedor,@NRightCuenta,@Afectable
					WHILE @@fetch_status = 0
					BEGIN
									
							Set @IdCuentaContableB=0
							Set @Total=0
							Set	@SaldoDeudor82200 = 0 	
							Declare @SaldoInicial82100 as decimal(18,2) = 0
									
							--Select	@SaldoDeudor82200=CargosSinFlujo,@IdCuentaContableB=C_Contable.IdCuentaContable
							Select	@SaldoInicial82100=AbonosSinFlujo,@IdCuentaContableB=C_Contable.IdCuentaContable
							From C_Contable, T_SaldosInicialesCont 
							Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
							And Mes = 13 And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
							--LEFT(NumeroCuenta,@EstIzq)='82100' + replicate ('0',(@EstIzq - len('82100'))) and right(replace(NumeroCuenta,' ',''),@EstDer )=@NRightCuenta
							LEFT(NumeroCuenta,3)='821' and right(replace(NumeroCuenta,' ',''),@EstDer )=@NRightCuenta		
							--Obtengo Total Recabado de la cuenta 82200
							--Select @Total=Total from @Tabla82200 Where IdCuentaContable=@IdCuentaContableB
					
							--DM !20150319
							INSERT INTO @Tabla82100R(IdCuentaContable,NumeroCuenta,Total,RightCuenta,Afectable ) 
							Values(@IdCuentaContable,@NumeroCuenta, @SaldoAcreedor, @NRightCuenta, @Afectable )
							--Values(@IdCuentaContable,@NumeroCuenta, @SaldoAcreedor-@SaldoDeudor82200-@Total , @NRightCuenta, @Afectable )
							--INSERT INTO @Tabla82100R(IdCuentaContable,NumeroCuenta,Total,RightCuenta,Afectable ) 
							--Values(@IdCuentaContable,@NumeroCuenta, @SaldoAcreedor-@SaldoDeudor82200-@Total , @NRightCuenta, @Afectable )
								
							--Select	@NumeroCuenta, @SaldoAcreedor,@SaldoDeudor82200,@Total 
								
								
							Set @IdCuentaContableB=0
							Set @Total=0
													
					
					 FETCH NEXT FROM CICLOPRINCIPAL
					 INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoAcreedor,@NRightCuenta,@Afectable
					 END      
					CLOSE CICLOPRINCIPAL
  					DEALLOCATE CICLOPRINCIPAL

		Insert into @Tabla82100R
	Select  C_Contable.IdCuentaContable, NumeroCuenta,
						 AbonosSinFlujo,
						 right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta, Afectable
					From C_Contable, T_SaldosInicialesCont 
					Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable and C_Contable.IdCuentaContable not in (Select IdCuentaContable from @Tabla82100R)
					And Mes = 13 And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
					--LEFT(NumeroCuenta,@EstIzq)='82100' + replicate ('0',(@EstIzq - len('82100'))) 
					LEFT(NumeroCuenta,3)='821'
					AND (CargosSinFlujo + AbonosSinFlujo != 0)
					Order By NumeroCuenta
  				
	--Select * from @Tabla82100R		
END--Proceso para obtener montos de 82100 R


BEGIN--Proceso para obtener montos de 81100 R

		 Declare CICLOPRINCIPAL cursor for
					
					--Tabla Evento 04 @BalPRECierreING

							Select D_Polizas.IdCuentaContable,
				C_Contable.NumeroCuenta, '',				 
				CargosSinFlujo + (SUM(D_Polizas.ImporteCargo) - SUM(D_Polizas.ImporteAbono)) as Total,
				right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta, Afectable
				from D_Polizas 
				LEFT Join C_Contable on  C_Contable.IdCuentaContable = D_Polizas.IdCuentaContable
				JOIN T_SaldosInicialesCont ON D_Polizas.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable and Year = @Ejercicio and Mes = 13
				where 
				 IdPoliza in (Select IdPoliza from T_Polizas where Ejercicio = @Ejercicio and Periodo = 13)
				--AND LEFT(NumeroCuenta,@EstIzq)='81100'
				AND LEFT(NumeroCuenta,3)='811'
				Group by C_Contable.NumeroCuenta, D_Polizas.IdCuentaContable, T_SaldosInicialesCont.CargosSinFlujo, T_SaldosInicialesCont.AbonosSinFlujo, C_Contable.Afectable
				order by C_Contable.NumeroCuenta


					OPEN CICLOPRINCIPAL
					FETCH NEXT FROM CICLOPRINCIPAL
					INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@NRightCuenta,@Afectable
					WHILE @@fetch_status = 0
					BEGIN
							
							Set @IdCuentaContableB=0
							Set @Total=0		
									
							Declare @SaldoInicial81100 as decimal(18,2) = 0
									
							--Select	@SaldoDeudor82200=CargosSinFlujo,@IdCuentaContableB=C_Contable.IdCuentaContable
							Select	@SaldoInicial81100=CargosSinFlujo,@IdCuentaContableB=C_Contable.IdCuentaContable
							From C_Contable, T_SaldosInicialesCont 
							Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
							And Mes = 13 And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
							--LEFT(NumeroCuenta,@EstIzq)='81100' + replicate ('0',(@EstIzq - len('81100'))) and right(replace(NumeroCuenta,' ',''),@EstDer )=@NRightCuenta
	                        LEFT(NumeroCuenta,3)='811' and right(replace(NumeroCuenta,' ',''),@EstDer )=@NRightCuenta				

						  --Obtengo Total Recabado de la cuenta 81200
							Select @Total=Total from @Tabla81200 Where IdCuentaContable=@IdCuentaContableB
					
							--DM !20150318
							INSERT INTO @Tabla81100R(IdCuentaContable,NumeroCuenta,Total,RightCuenta,Afectable )
							Values(@IdCuentaContable,@NumeroCuenta, @SaldoDeudor, @NRightCuenta , @Afectable)
							--Values(@IdCuentaContable,@NumeroCuenta, @SaldoDeudor-@SaldoAcreedor81200 -@Total , @NRightCuenta , @Afectable)
							--INSERT INTO @Tabla81100R(IdCuentaContable,NumeroCuenta,Total,RightCuenta,Afectable ) 
							--Values(@IdCuentaContable,@NumeroCuenta, @SaldoDeudor-@SaldoAcreedor81200 +@Total , @NRightCuenta , @Afectable)
												
					
							Set @IdCuentaContableB=0
							Set @Total=0	
					
					 FETCH NEXT FROM CICLOPRINCIPAL
					 INTO @IdCuentaContable,@NumeroCuenta,@NombreCuenta,@SaldoDeudor,@NRightCuenta,@Afectable
					 END      
					CLOSE CICLOPRINCIPAL
  					DEALLOCATE CICLOPRINCIPAL

	Insert into @Tabla81100R
	Select  C_Contable.IdCuentaContable, NumeroCuenta,
						 CargosSinFlujo,
						 right(replace(NumeroCuenta,' ',''),@EstDer) as NCuenta, Afectable
					From C_Contable, T_SaldosInicialesCont 
					Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable and C_Contable.IdCuentaContable not in (Select IdCuentaContable from @Tabla81100R)
					And Mes = 13 And [Year] = @Ejercicio And TipoCuenta <> 'X' And 
					--LEFT(NumeroCuenta,@EstIzq)='81100' + replicate ('0',(@EstIzq - len('81100'))) 
					LEFT(NumeroCuenta,3)='811'
					AND (CargosSinFlujo + AbonosSinFlujo != 0)
					Order By NumeroCuenta
  		--Select * from @Tabla81100R			
END--Proceso para obtener montos de 81100 R



BEGIN --PROCESO GENERAL DE ENCABEZADO Y DETALLADO DE POLIZA PARA EVENTO 12 Y 13

--obtendo id y numero de poliza 

				    --set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),month(@Fecha)) -- BR 20170403 lo comenté y sustituí por línea de abajo
					set @TipoPoliza='POLD' + convert(varchar(4),year(@Fecha)) + convert(varchar(2),13)  -- BR 20170403 Para que tomé el consecutivo del mes 13						
					Select @NoPoliza=consecutivo + 1 from T_Consecutivos WHERE Tipo = @TipoPoliza
					select top 1 @IdPoliza=IdPoliza + 1  from T_Polizas order by IdPoliza desc
					select top 1 @IdDPoliza=Iddpoliza from D_Polizas order by IdDPoliza desc
					Set @ConceptoPoliza='Cierre del Ejercicio con Superávit'
					Set @ConceptoPolizaB='Cierre del Ejercicio con Déficit'
					set @TotalSaldoAbonos=0
					set @TotalSaldoCargos=0
					set @IDConcepto=385
					set @IDConceptoB=386
					set @IdGuia=45
					set @Total81500=0
					set @Total82700=0
					
					
				
					
					--INSERTAR DATOS EN D_POLIZAS
							 INSERT INTO T_Polizas(idpoliza,IdCheque,idtipomovimiento,TipoPoliza,Ejercicio,Periodo,NoPoliza,Fecha,Status,Concepto,TotalCargos,TotalAbonos,idusuario,FechaAuditoria,HoraAuditoria,idguia,idconcepto )
							 VALUES (@IdPoliza,0,@IDConcepto,'D',@Ejercicio,13,@NoPoliza,@Fecha,'C',@ConceptoPoliza,@SaldoDeudor,@SaldoAcreedor,@IdUsuario,@Fecha,@Fecha,@IdGuia,@IDConcepto)
					
					
					
  								Declare CICLOPRINCIPAL cursor for
  								
  								select IdCuentaContable,NumeroCuenta,Total,RightCuenta,Afectable from @Tabla82100R 
  								
  								OPEN CICLOPRINCIPAL
								FETCH NEXT FROM CICLOPRINCIPAL
								INTO @IdCuentaContable,@NumeroCuenta,@Total,@NRightCuenta,@Afectable
								WHILE @@fetch_status = 0
								BEGIN
								
									IF @Afectable=1 
									BEGIN
									
										IF @Total>0 OR @Total<0
										BEGIN
										
  										--INSERTAR DATOS EN D_POLIZAS Evento 13 82100
  										SET @IdDPoliza=@IdDPoliza + 1
	  									
										INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
										VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,@Total,0,1,' ',0,0 )
										set @TotalSaldoCargos=@TotalSaldoCargos + @Total
										
										END
									END
									
								 FETCH NEXT FROM CICLOPRINCIPAL
								 INTO @IdCuentaContable,@NumeroCuenta,@Total,@NRightCuenta,@Afectable
								 END      
								CLOSE CICLOPRINCIPAL
  								DEALLOCATE CICLOPRINCIPAL	
  								
									--INSERTAR DATOS EN D_POLIZAS Evento 13 81100
								Declare CICLOPRINCIPAL cursor for
  								
  								select IdCuentaContable,NumeroCuenta,Total,RightCuenta,Afectable from @Tabla81100R 
  								
  								OPEN CICLOPRINCIPAL
								FETCH NEXT FROM CICLOPRINCIPAL
								INTO @IdCuentaContable,@NumeroCuenta,@Total,@NRightCuenta,@Afectable
								WHILE @@fetch_status = 0
								BEGIN
								
									IF @Afectable=1 
									BEGIN		
										IF @Total>0 OR @Total<0
										BEGIN	
										
											SET @IdDPoliza=@IdDPoliza + 1				
											
											INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
											VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,0,@Total ,1,' ',0,0 )
											set @TotalSaldoAbonos=@TotalSaldoAbonos + @Total
									
										END
									
									END
								 FETCH NEXT FROM CICLOPRINCIPAL
								 INTO @IdCuentaContable,@NumeroCuenta,@Total,@NRightCuenta,@Afectable
								 END      
								CLOSE CICLOPRINCIPAL
  								DEALLOCATE CICLOPRINCIPAL		
									
								
END --FIN PROCESO GENERAL DE ENCABEZADO Y DETALLADO DE POLIZA PARA EVENTO 12 Y 13								
								
	BEGIN --PROCESO DE INSERCION DE CUENTA 91000 O 92000 EVENTO 12 Y 13								
								
						
							--IF @Diferencia < 0 
							IF (@TotalSaldoCargos-@TotalSaldoAbonos) > 0 
  							BEGIN	
  							
  							
  								Select @IdCuentaContable=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)= '92000' + replicate ('0',(@EstIzq - len('92000'))) and  Right(NumeroCuenta,@EstDer)='00000' + replicate ('0',(@EstDer - len('00000')))
	
					  				
					  				SET @SaldoAcreedor92000= @TotalSaldoCargos-@TotalSaldoAbonos
					  								
									--INSERTAR DATOS EN T_POLIZAS Evento 13 92000
																			
									SET @IdDPoliza=@IdDPoliza + 1				
									
									INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
								    VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,0,@SaldoAcreedor92000 ,1,' ',0,0 )
									set @TotalSaldoAbonos=@TotalSaldoAbonos + @SaldoAcreedor92000
									
									
									UPDATE T_Polizas SET TotalCargos=@TotalSaldoCargos , TotalAbonos=@TotalSaldoAbonos ,Concepto=@ConceptoPolizaB WHERE IdPoliza=@IdPoliza
  									SET @IDConcepto=@IDConceptoB
  							  							
  									UPDATE T_Consecutivos SET Consecutivo=@NoPoliza  WHERE Tipo = @TipoPoliza
  									INSERT INTO R_PolizaGuia values(@idpoliza,@IdGuia,@IDConcepto)
  							
  							
  							END
  							ELSE
  							BEGIN
  							
  									Select @IdCuentaContable=IdCuentaContable from C_Contable where LEFT(NumeroCuenta,@EstIzq)= '91000' + replicate ('0',(@EstIzq - len('91000'))) and  Right(NumeroCuenta,@EstDer)='00000' + replicate ('0',(@EstDer - len('00000')))
	
					  				SET @SaldoDeudor91000= @TotalSaldoAbonos-@TotalSaldoCargos
									
  									--INSERTAR DATOS EN T_POLIZAS Evento 13 91000
									
									SET @IdDPoliza=@IdDPoliza + 1				
									
									INSERT INTO D_Polizas(IdDPoliza,IdPoliza,IdCuentaContable,ImporteCargo,ImporteAbono,iva,referencia,IdPartidaDeFlujo, IdSelloPresupuestal )
								    VALUES (@IdDPoliza,@IdPoliza,@IdCuentaContable,@SaldoDeudor91000,0 ,1,' ',0,0 )
									set @TotalSaldoCargos=@TotalSaldoCargos + @SaldoDeudor91000
  							
  									UPDATE T_Polizas SET TotalCargos=@TotalSaldoCargos , TotalAbonos=@TotalSaldoAbonos WHERE IdPoliza=@IdPoliza
  									UPDATE T_Consecutivos SET Consecutivo=@NoPoliza  WHERE Tipo = @TipoPoliza
  									INSERT INTO R_PolizaGuia values(@idpoliza,@IdGuia,@IDConcepto)
	  						
  							END
  							
 END --PROCESO DE INSERCION DE CUENTA 91000 O 92000 EVENTO 12 Y 13									
  	END --EVENTO 12 Y 13						
  
	COMMIT TRAN
 
  	END TRY

BEGIN CATCH

    /* Hay un error, deshacemos los cambios*/

   ROLLBACK TRAN -- O solo ROLLBACK

    PRINT 'Se ha producido un error!'

END CATCH						