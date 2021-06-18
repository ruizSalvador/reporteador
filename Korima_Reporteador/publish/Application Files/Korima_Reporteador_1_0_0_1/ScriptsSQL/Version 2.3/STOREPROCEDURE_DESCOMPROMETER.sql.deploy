/****** Object:  StoredProcedure [dbo].[SP_Descomprometer]    Script Date: 07/15/2013 12:53:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Descomprometer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Descomprometer]
GO

/****** Object:  StoredProcedure [dbo].[SP_Descomprometer]    Script Date: 07/15/2013 12:53:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[SP_Descomprometer]

 @FechaInicial as datetime,
 @FechaFinal as datetime,
 @Opcion as int,
 @Id as int,
 @Tipo as int ,
 @Monto as money,
 @IdSello as int
 	
AS
BEGIN
--set @FechaInicial= convert(datetime,@fechainicial,103)
--set @FechaFinal = convert(datetime,@FechaFinal,103)
		
	IF @Opcion=1   --INFORMACION INICIAL DE GRID
	Begin
		
				SELECT     dbo.T_Pedidos.IdPedido as ID, dbo.T_Pedidos.Folio, dbo.T_Pedidos.Fecha, CONVERT(VARCHAR(30), CONVERT(MONEY, dbo.T_Pedidos.TotalGral), 1) as Total,
						  dbo.C_Proveedores.RazonSocial AS Proveedor, 'O.C.' AS Tipo,  1 as TipoID 
				FROM         dbo.T_Pedidos INNER JOIN
									  dbo.C_Proveedores ON dbo.T_Pedidos.IdProveedor = dbo.C_Proveedores.IdProveedor
				WHERE  dbo.T_Pedidos.Fecha BETWEEN @FechaInicial AND  @FechaFinal					  
				UNION 
				SELECT     dbo.T_OrdenServicio.IdOrden AS ID, dbo.T_OrdenServicio.Folio, dbo.T_OrdenServicio.Fecha, CONVERT(VARCHAR(30), CONVERT(MONEY, dbo.T_OrdenServicio.TotalGral), 1) AS Total, 
									  dbo.C_Proveedores.RazonSocial AS Proveedor, 'O.S.' AS Tipo, 2 as TipoID 
				FROM         dbo.T_OrdenServicio INNER JOIN
									  dbo.C_Proveedores ON dbo.T_OrdenServicio.IdProveedor = dbo.C_Proveedores.IdProveedor                      
   				WHERE dbo.T_OrdenServicio.Fecha BETWEEN @FechaInicial AND @FechaFinal
	END
	
	IF @Opcion=2  --AFECTACION DE DATOS
	Begin
	
		
			
			IF @Tipo=2  --AFECTACION ORDEN DE SERVICIO
			BEGIN
				Declare @TFecha as datetime
				Declare @TPeriodo as int
				Declare @Mes as int
				Declare @TotalOS as float
				Declare @ProrrateoOS as float
				Declare @ProrrateoOSFinal as float
				Declare @PorIVaOS as float
				
				Select @TotalOS= TotalGral,@PorIVaOS=(IVA_PORC/100) + 1,  @TPeriodo=Periodo, @TFecha=Fecha,@Mes=CONVERT(SMALLINT,MONTH(Fecha)) from T_OrdenServicio where IdOrden=@Id
				Set @ProrrateoOS= @Monto * 1 /@TotalOS
				Set @ProrrateoOSFinal = @ProrrateoOS
				
				--INICIA PROCESO DE GUARDADO EN BD PARA ORDENES DE SERVICIO
							declare @IdOrden integer
							declare @IdRenglonOrden integer
							declare @IdSelloPresupuestal	integer		
							Declare @MontoDOServicio float
							Declare @MontoDOFinal float
							Declare @IdAfectacionPresupuestoOS int
							Declare CICLOPRINCIPAL cursor for
									
									select IdOrden,IdRenglonOrden,Importe,IdSelloPresupuestal FROM D_OrdenServicio where IdOrden=@Id
									OPEN CICLOPRINCIPAL
									FETCH NEXT FROM CICLOPRINCIPAL
	  								INTO @IdOrden,@IdRenglonORden,@MontoDOServicio,@IdSelloPresupuestal
									WHILE @@fetch_status = 0
									BEGIN
												--INSERTO MOVIMIENTO DE PRORRATEO EN AFECTACIONPRESUPUESTO
												Set @IdAfectacionPresupuestoOS = 0
												Set @MontoDOFinal=0
												Set @MontoDOFinal=ROUND((@MontoDOServicio * @ProrrateoOSFinal) * -1,2)
												Set @MontoDOFinal= @MontoDOFinal * @PorIVaOS
																						
												select  top 1 @IdAfectacionPresupuestoOS=idmov + 1 from T_AfectacionPresupuesto order by IdMov desc
												
												insert into T_AfectacionPresupuesto(IdMov,IdSelloPresupuestal,Periodo,Mes,TipoAfectacion,Importe,TipoMovimientoGenera,
																					IdMovimiento,Fecha,Estatus,IdObra,IdContrato,IdPoliza,IdPartidaGI,Cancelacion)
																			Values(@IdAfectacionPresupuestoOS,@IdSelloPresupuestal,@TPeriodo,@Mes,'C',@MontoDOFinal,'S',
																					@Id,@TFecha,'D',0,0,0,0,1)
																					
												--ACTUALIZO T_PRESUPUESTONW
												UPDATE T_PresupuestoNW set Comprometido=isnull(Comprometido,0) + @MontoDOFinal WHERE IdSelloPresupuestal=@IdSelloPresupuestal 
												AND Year=@TPeriodo AND Mes=@Mes
												
												UPDATE T_PresupuestoNW set Comprometido=isnull(Comprometido,0) + @MontoDOFinal WHERE IdSelloPresupuestal=@IdSelloPresupuestal 
												AND Year=@TPeriodo AND Mes=0											

							 
								 FETCH NEXT FROM CICLOPRINCIPAL
								 INTO	@IdOrden,@IdRenglonORden,@MontoDOServicio,@IdSelloPresupuestal
								 END      
								CLOSE CICLOPRINCIPAL
								DEALLOCATE CICLOPRINCIPAL
		
			END
			
				
			IF @Tipo =1 --AFECTACION ORDEN DE COMPRA
			BEGIN
					
						Declare @OCFecha as datetime
						Declare @OCPeriodo as int
						Declare @OCMes as int
						Declare @TotalOC as float
						Declare @ProrrateoOC as float
						Declare @ProrrateoOCFinal as float
						Declare @PorIVaOC as float
						
						Select @TotalOC= TotalGral,@PorIVaOC=(IVA_PORC/100)+1, @OCPeriodo=Periodo, @OCFecha=Fecha,@OCMes=CONVERT(SMALLINT,MONTH(Fecha)) from T_Pedidos where IdPedido=@Id
						Set @ProrrateoOC= @Monto * 1 /@TotalOC
						Set @ProrrateoOCFinal = @ProrrateoOC
						
						--INICIA PROCESO DE GUARDADO EN BD PARA ORDENES DE COMPRA
									declare @IdPedido integer
									declare @IdRenglonPedido integer
									declare @IdSelloPresupuestalOC	integer		
									Declare @MontoDOServicioOC decimal(12,2)
									Declare @MontoDOFinalOC decimal(12,2)
									Declare @IdAfectacionPresupuestoOC int
									Declare CICLOPRINCIPAL cursor for
											
											select IdPedido,IdRenglonPedido,Importe,IdSelloPresupuestal from D_pedidos where IdPedido=@Id
											OPEN CICLOPRINCIPAL
											FETCH NEXT FROM CICLOPRINCIPAL
	  										INTO @IdPedido,@IdRenglonPedido,@MontoDOServicioOC,@IdSelloPresupuestalOC
											WHILE @@fetch_status = 0
											BEGIN
														--INSERTO MOVIMIENTO DE PRORRATEO EN AFECTACIONPRESUPUESTO
														Set @IdAfectacionPresupuestoOC = 0
														Set @MontoDOFinalOC=0
														Set @MontoDOFinalOC= Round((@MontoDOServicioOC * @ProrrateoOCFinal) * -1,2)
														set	@MontoDOFinalOC = @MontoDOFinalOC * @PorIVaOC
																								
														select  top 1 @IdAfectacionPresupuestoOC=idmov + 1 from T_AfectacionPresupuesto order by IdMov desc
														
														insert into T_AfectacionPresupuesto(IdMov,IdSelloPresupuestal,Periodo,Mes,TipoAfectacion,Importe,TipoMovimientoGenera,
																							IdMovimiento,Fecha,Estatus,IdObra,IdContrato,IdPoliza,IdPartidaGI,Cancelacion)
																					Values(@IdAfectacionPresupuestoOC,@IdSelloPresupuestalOC,@OCPeriodo,@OCMes,'C',@MontoDOFinalOC,'P',
																							@Id,@OCFecha,'D',0,0,0,0,1)
																							
														--ACTUALIZO T_PRESUPUESTONW
														UPDATE T_PresupuestoNW set Comprometido=isnull(Comprometido,0) + @MontoDOFinalOC WHERE IdSelloPresupuestal=@IdSelloPresupuestalOC 
														AND Year=@OCPeriodo AND Mes=@OCMes
														
														UPDATE T_PresupuestoNW set Comprometido=isnull(Comprometido,0) + @MontoDOFinalOC WHERE IdSelloPresupuestal=@IdSelloPresupuestalOC 
														AND Year=@OCPeriodo AND Mes=0											

									 
										 FETCH NEXT FROM CICLOPRINCIPAL
										 INTO @IdPedido,@IdRenglonPedido,@MontoDOServicioOC,@IdSelloPresupuestalOC
										 END      
										CLOSE CICLOPRINCIPAL
										DEALLOCATE CICLOPRINCIPAL
					END
	END
	
	IF @Opcion=3   --INFORMACION INICIAL DE GRID PARA DESCOMPROMETER POR SELLO
	Begin
			IF @Tipo =1 --ORDEN DE COMPRA
			BEGIN
			
					DECLARE @TMP_ORDENCOMPRAXSELLO TABLE(Sello varchar(60), Importe Decimal(11,2),Iva Decimal(11,2) , Total decimal(11,2) , TotalEnc decimal(11,2), IvaEnc decimal(11,2) , IdPedido int, IdSelloPresupuestal int)
					INSERT INTO @TMP_ORDENCOMPRAXSELLO
					SELECT     dbo.T_SellosPresupuestales.Sello, SUM(dbo.D_Pedidos.Importe) AS Importe, SUM(dbo.D_Pedidos.Importe) * (dbo.T_Pedidos.IVA_PORC/ 100) AS Iva, SUM(dbo.D_Pedidos.Importe) 
										  +  SUM(dbo.D_Pedidos.Importe) * (dbo.T_Pedidos.IVA_PORC/ 100) AS Total, dbo.T_Pedidos.TotalGral AS TotalEnc, dbo.T_Pedidos.IVA AS IVaEnc, dbo.T_Pedidos.IdPedido,dbo.T_SellosPresupuestales.IdSelloPresupuestal
					FROM         dbo.T_Pedidos INNER JOIN
										  dbo.D_Pedidos ON dbo.T_Pedidos.IdPedido = dbo.D_Pedidos.IdPedido INNER JOIN
										  dbo.T_SellosPresupuestales ON dbo.D_Pedidos.IdSelloPresupuestal = dbo.T_SellosPresupuestales.IdSelloPresupuestal
					WHERE     (dbo.T_Pedidos.IdPedido = @Id)
					GROUP BY dbo.T_SellosPresupuestales.Sello, dbo.T_Pedidos.TotalGral, dbo.T_Pedidos.IVA, dbo.T_Pedidos.IdPedido,dbo.T_SellosPresupuestales.IdSelloPresupuestal,dbo.T_Pedidos.IVA_PORC
			
						
					DECLARE @DEVENGADOCOMPRAS TABLE (IdRecepcionServicios int, IdPedido int,  IdSelloPresupuestal int,Total Decimal(11,2))
					INSERT INTO @DEVENGADOCOMPRAS
					SELECT     TOP (100) PERCENT dbo.T_RecepcionFacturas.IdRecepcionServicios, dbo.T_RecepcionFacturas.IdPedido, 
										  dbo.D_RecepcionFacturas.IdSelloPresupuestal, SUM(dbo.D_RecepcionFacturas.Importe) + SUM(dbo.D_RecepcionFacturas.Importe) 
										  * SUM(dbo.T_RecepcionFacturas.IVA) / SUM(dbo.T_RecepcionFacturas.SubTotal) AS Total
					FROM         dbo.T_RecepcionFacturas INNER JOIN
										  dbo.D_RecepcionFacturas ON dbo.T_RecepcionFacturas.IdRecepcionServicios = dbo.D_RecepcionFacturas.IdRecepcionServicios
					WHERE     Estatus <> 'N' and (IdPedido > 0 or IdOrden > 0 or IdContrato > 0)  and DifFecha = 1 and IdViaticos = 0 AND (dbo.T_RecepcionFacturas.IdPedido = @Id)
					GROUP BY dbo.T_RecepcionFacturas.IdRecepcionServicios, dbo.T_RecepcionFacturas.IdPedido, 
										  dbo.D_RecepcionFacturas.IdSelloPresupuestal
					ORDER BY dbo.D_RecepcionFacturas.IdSelloPresupuestal
			
					
					SELECT    ORDENCOMPRAXSELLO.Sello, ORDENCOMPRAXSELLO.Importe, ORDENCOMPRAXSELLO.Iva, ORDENCOMPRAXSELLO.Total, ORDENCOMPRAXSELLO.TotalEnc, ORDENCOMPRAXSELLO.IvaEnc , ORDENCOMPRAXSELLO.IdPedido , ORDENCOMPRAXSELLO.IdSelloPresupuestal,
							ORDENCOMPRAXSELLO.Total- isnull(DEVENGADOCOMPRAS.Total,0) as  Disponible_a_Descomprometer 
					FROM         @DEVENGADOCOMPRAS DEVENGADOCOMPRAS  RIGHT OUTER JOIN
                      @TMP_ORDENCOMPRAXSELLO ORDENCOMPRAXSELLO ON DEVENGADOCOMPRAS.IdSelloPresupuestal = ORDENCOMPRAXSELLO.IdSelloPresupuestal
			
						
			
			END
			IF @Tipo = 2 --ORDEN DE SERVICIO
			BEGIN
			
					DECLARE @TMP_ORDENSERVICIOXSELLO TABLE(Sello varchar(60), Importe Decimal(11,2),Iva Decimal(11,2) , Total decimal(11,2) , TotalEnc decimal(11,2), IvaEnc decimal(11,2) , IdPedido int, IdSelloPresupuestal int)

					INSERT INTO @TMP_ORDENSERVICIOXSELLO
					SELECT     dbo.T_SellosPresupuestales.Sello, SUM(dbo.D_OrdenServicio.Importe) AS Importe, SUM(dbo.D_OrdenServicio.Importe) * (dbo.T_OrdenServicio.IVA_PORC / 100) 
										  AS Iva, SUM(dbo.D_OrdenServicio.Importe) + SUM(dbo.D_OrdenServicio.Importe) * (dbo.T_OrdenServicio.IVA_PORC / 100) AS Total, 
										  dbo.T_OrdenServicio.TotalGral AS TotalEnc, dbo.T_OrdenServicio.IVA AS IVaEnc, dbo.T_OrdenServicio.IdOrden,dbo.T_SellosPresupuestales.IdSelloPresupuestal
					FROM         dbo.T_OrdenServicio INNER JOIN
										  dbo.D_OrdenServicio ON dbo.T_OrdenServicio.IdOrden = dbo.D_OrdenServicio.IdOrden INNER JOIN
										  dbo.T_SellosPresupuestales ON dbo.D_OrdenServicio.IdSelloPresupuestal = dbo.T_SellosPresupuestales.IdSelloPresupuestal
					WHERE     (dbo.T_OrdenServicio.IdOrden = @Id)
					GROUP BY dbo.T_SellosPresupuestales.Sello, dbo.T_OrdenServicio.TotalGral, dbo.T_OrdenServicio.IVA, dbo.T_OrdenServicio.IdOrden, dbo.T_OrdenServicio.IVA_PORC,dbo.T_SellosPresupuestales.IdSelloPresupuestal
			
					
					DECLARE @DEVENGADOSERVICIOS TABLE (IdRecepcionServicios int,  IdOrden int, IdSelloPresupuestal int,Total Decimal(11,2))
					INSERT INTO @DEVENGADOSERVICIOS
					SELECT     TOP (100) PERCENT dbo.T_RecepcionFacturas.IdRecepcionServicios,  dbo.T_RecepcionFacturas.IdOrden, 
										  dbo.D_RecepcionFacturas.IdSelloPresupuestal, SUM(dbo.D_RecepcionFacturas.Importe) + SUM(dbo.D_RecepcionFacturas.Importe) 
										  * SUM(dbo.T_RecepcionFacturas.IVA) / SUM(dbo.T_RecepcionFacturas.SubTotal) AS Total
					FROM         dbo.T_RecepcionFacturas INNER JOIN
										  dbo.D_RecepcionFacturas ON dbo.T_RecepcionFacturas.IdRecepcionServicios = dbo.D_RecepcionFacturas.IdRecepcionServicios
					WHERE     Estatus <> 'N' and (IdPedido > 0 or IdOrden > 0 or IdContrato > 0)  and DifFecha = 1 and IdViaticos = 0 and dbo.T_RecepcionFacturas.IdOrden=@Id
					GROUP BY dbo.T_RecepcionFacturas.IdRecepcionServicios,  dbo.T_RecepcionFacturas.IdOrden, 
										  dbo.D_RecepcionFacturas.IdSelloPresupuestal
					ORDER BY dbo.D_RecepcionFacturas.IdSelloPresupuestal
					
						
					SELECT   ORDENSERVICIOXSELLO.Sello, ORDENSERVICIOXSELLO.Importe, ORDENSERVICIOXSELLO.Iva, ORDENSERVICIOXSELLO.Total, ORDENSERVICIOXSELLO.TotalEnc, ORDENSERVICIOXSELLO.IvaEnc , ORDENSERVICIOXSELLO.IdPedido , ORDENSERVICIOXSELLO.IdSelloPresupuestal,
							ORDENSERVICIOXSELLO.Total - isnull(DEVENGADOSERVICIOS.Total,0) as Disponible_a_Descomprometer 
					FROM        @DEVENGADOSERVICIOS  DEVENGADOSERVICIOS  RIGHT OUTER JOIN
                      @TMP_ORDENSERVICIOXSELLO ORDENSERVICIOXSELLO ON DEVENGADOSERVICIOS.IdSelloPresupuestal = ORDENSERVICIOXSELLO.IdSelloPresupuestal
								
		
			END
	End
	
	
	IF @Opcion=4  ----AFECTACION DE DATOS PARA DESCOMPROMETER POR SELLO  ############EN ESTA SECCION SE UTILIZA LA VARIABLE @FechaInicial = @FechaModificada por USuario
	Begin
			IF @Tipo =1 --ORDEN DE COMPRA
			BEGIN
					Declare @O_CFecha as datetime
					Declare @O_CPeriodo as int
					Declare @O_CMes as int
						
					Set @O_CFecha = @FechaInicial
					Set @O_CPeriodo = CONVERT(BIGINT,YEAR(@FechaInicial))
					Set @O_CMes= CONVERT(BIGINT,MONTH(@FechaInicial))	
						
					--Select @O_CPeriodo=Periodo, @O_CFecha=Fecha,@O_CMes=CONVERT(SMALLINT,MONTH(Fecha)) from T_Pedidos where IdPedido=@Id

					Set @Monto = @Monto * -1
					
					select  top 1 @IdAfectacionPresupuestoOC=idmov + 1 from T_AfectacionPresupuesto order by IdMov desc
												
					insert into T_AfectacionPresupuesto(IdMov,IdSelloPresupuestal,Periodo,Mes,TipoAfectacion,Importe,TipoMovimientoGenera,
														IdMovimiento,Fecha,Estatus,IdObra,IdContrato,IdPoliza,IdPartidaGI,Cancelacion)
					Values(@IdAfectacionPresupuestoOC,@IdSello,@O_CPeriodo,@O_CMes,'C',@Monto,'P',@Id,@O_CFecha,'D',0,0,0,0,1)
																							
					--ACTUALIZO T_PRESUPUESTONW
					UPDATE T_PresupuestoNW set Comprometido=isnull(Comprometido,0) + @Monto WHERE IdSelloPresupuestal=@IdSello
					AND Year=@O_CPeriodo AND Mes=@O_CMes
														
					UPDATE T_PresupuestoNW set Comprometido=isnull(Comprometido,0) + @Monto WHERE IdSelloPresupuestal=@IdSello
					AND Year=@O_CPeriodo AND Mes=0											
	
			END
			
			IF @Tipo = 2 --ORDEN DE SERVICIO
			BEGIN
					
					
				Declare @OSFecha as datetime
				Declare @OSPeriodo as int
				Declare @OSMes as int
				
				Set @OSFecha=@FechaInicial
				set @OSPeriodo =CONVERT(BIGINT,YEAR(@FechaInicial))
				Set @OSMes = CONVERT(INT,MONTH(@FechaInicial)) 
				
				
			  	--Select  @OSPeriodo=Periodo, @OSFecha=Fecha,@OSMes=CONVERT(SMALLINT,MONTH(Fecha)) from T_OrdenServicio where IdOrden=@Id
                
                Set @Monto = @Monto * -1
					
					select  top 1 @IdAfectacionPresupuestoOS=idmov + 1 from T_AfectacionPresupuesto order by IdMov desc
												
					insert into T_AfectacionPresupuesto(IdMov,IdSelloPresupuestal,Periodo,Mes,TipoAfectacion,Importe,TipoMovimientoGenera,
														IdMovimiento,Fecha,Estatus,IdObra,IdContrato,IdPoliza,IdPartidaGI,Cancelacion)
					Values(@IdAfectacionPresupuestoOS,@IdSello,@OSPeriodo,@OSMes,'C',@Monto,'S',@Id,@OSFecha,'D',0,0,0,0,1)
					
																					
												--ACTUALIZO T_PRESUPUESTONW
					UPDATE T_PresupuestoNW set Comprometido=isnull(Comprometido,0) + @Monto WHERE IdSelloPresupuestal=@IdSello 
					AND Year=@OSPeriodo AND Mes=@OSMes
												
					UPDATE T_PresupuestoNW set Comprometido=isnull(Comprometido,0) + @Monto WHERE IdSelloPresupuestal=@IdSello
					AND Year=@OSPeriodo AND Mes=0											

					
								
			END
	End
	
--Capitulo 1000
IF @Opcion=5   --INFORMACION INICIAL DE GRID
begin
Declare @IdMov Int
 Declare @IdSelloPresupuestal5 Int
 Declare @Periodo5 smallint
 Declare @Mes5 smallint
 Declare @TipoAfectacion5 varchar(1)
 Declare @Importe decimal(13,2)
 Declare @TipoMovimientoGenera varchar(1)
 Declare @IdMovimiento int
 Declare @Fecha datetime
 Declare @Estatus varchar(1)
 Declare @IdObra int
 Declare @IdContrato int
 Declare @IdPoliza int
 Declare @IdPartidaGI int
 Declare @UnicoHora int
 Declare @Cancelacion tinyint
 Declare @AnualMensual Varchar(1)
 
 Select @AnualMensual = CandadoPresupuestal from T_ParametrosSIAP
 
if (@Tipo =0)
begin
if @AnualMensual ='M'
	Begin
		SELECT Afec.IdSelloPresupuestal
		,Sello.Sello
		,Afec.Mes
		,Afec.Periodo
		,sum(Afec.Importe) as Comprometido
      ,isnull(((sum(Afec.Importe)- isnull((select sum(T_PresupuestoNW.Devengado) from T_PresupuestoNW where 
      T_PresupuestoNW.Mes=afec.mes and T_PresupuestoNW.Year=Afec.Periodo 
      and T_PresupuestoNW.IdSelloPresupuestal=Afec.IdSelloPresupuestal 
      ),0)) ),0) as DesComprometer--,
      --Afec.IdMov
  FROM  T_AfectacionPresupuesto Afec 
  INNER JOIN T_SellosPresupuestales Sello ON Afec.IdSelloPresupuestal = Sello.IdSelloPresupuestal 
  WHERE Afec.TipoAfectacion = 'C' 
  AND Afec.TipoMovimientoGenera= 'M'
  AND Afec.Periodo=Year(@FechaInicial)
  Group By Afec.IdSelloPresupuestal,Afec.Periodo,Afec.Mes,
  Sello.sello--,Afec.IdMov 
  ORDER BY Afec.IdSelloPresupuestal,Afec.Periodo,Afec.Mes 
  
  end
  if @AnualMensual='A'
  begin
   SELECT distinct T_AfectacionPresupuesto.IdSelloPresupuestal
		,Sello.Sello
		,'Anual' as Mes
		,T_PresupuestoNW.Year
		,T_PresupuestoNW.Comprometido as Comprometido,
      isnull(T_PresupuestoNW.Comprometido,0) -isnull(T_PresupuestoNW.Devengado,0) as DesComprometer
  FROM  T_AfectacionPresupuesto
  INNER JOIN T_SellosPresupuestales Sello ON T_AfectacionPresupuesto.IdSelloPresupuestal = Sello.IdSelloPresupuestal 
  JOIN T_PresupuestoNW ON T_PresupuestoNW.IdSelloPresupuestal= T_AfectacionPresupuesto.IdSelloPresupuestal 
  WHERE T_AfectacionPresupuesto.TipoAfectacion = 'C' 
  AND T_AfectacionPresupuesto.TipoMovimientoGenera= 'M'
  AND T_PresupuestoNW.year=Year(@FechaInicial)
  AND T_PresupuestoNW.mes= 0
  --Group By T_AfectacionPresupuesto.IdSelloPresupuestal,T_PresupuestoNW.year,T_PresupuestoNW.Mes,
  --Sello.Sello
  ORDER BY T_AfectacionPresupuesto.IdSelloPresupuestal
  end
  end--if tipo 0
  
  
  
  IF @Tipo=1 --Insert
  BEGIN
 if @AnualMensual='M'
 begin
 
 Select top 1 @IdMov=IdMov,
		@IdSelloPresupuestal5 = IdSelloPresupuestal,
		@Periodo5=Periodo,
		@Mes5=Mes,
		@TipoAfectacion5=TipoAfectacion,
		@Importe=Importe,
		@TipoMovimientoGenera=TipoMovimientoGenera,
		@IdMovimiento=IdMovimiento,
		@Fecha=Fecha,
		@Estatus=Estatus,
		@IdObra=IdObra,
		@IdContrato=IdContrato,
		@IdPoliza=IdPoliza,
		@IdPartidaGI=IdPartidaGI,
		@UnicoHora=UnicoHora,
		@Cancelacion=Cancelacion
		From T_AfectacionPresupuesto
		Where IdSelloPresupuestal=@IdSello
		and Mes= MONTH(@FechaFinal)
		AND Periodo= YEAR(@FechaFinal)
  
  set @IdMov= (Select MAX(IdMov)+1 from T_AfectacionPresupuesto)
  
  INSERT INTO [T_AfectacionPresupuesto]
           ([IdMov]
           ,[IdSelloPresupuestal]
           ,[Periodo]
           ,[Mes]
           ,[TipoAfectacion]
           ,[Importe]
           ,[TipoMovimientoGenera]
           ,[IdMovimiento]
           ,[Fecha]
           ,[Estatus]
           ,[IdObra]
           ,[IdContrato]
           ,[IdPoliza]
           ,[IdPartidaGI]
           ,[UnicoHora]
           ,[Cancelacion])
           Values(
        @IdMov,
        @IdSelloPresupuestal5,
		Year(@FechaFinal),--nuevo periodo
		month(@FechaFinal),--nuevo mes
		'C',
		(@Monto*-1),--Nuevo monto
		'M',
		@IdMovimiento,
		@FechaInicial,--nueva fecha
		'',
		0,
		0,
		0,
		0,
		@UnicoHora,
		0
           
           )
          
        --Mes de afectacion   
        UPDATE T_PresupuestoNW
        set comprometido= comprometido- @Monto
        Where IdSelloPresupuestal=@Idsello --@IdSelloPresupuestal5 
        and Mes =MONTH(@FechaFinal)
        and year = YEAR(@FechaFinal)
        -- Mes Cero (anual)
        UPDATE T_PresupuestoNW
        set comprometido= comprometido- @Monto
        Where IdSelloPresupuestal=@Idsello--@IdSelloPresupuestal5 
        and Mes =0
        and year = YEAR(@FechaFinal)
        
  end
  if @AnualMensual='A'
  begin
  Select top 1 @IdMov=IdMov,
		@IdSelloPresupuestal5 = IdSelloPresupuestal,
		@Periodo5=Periodo,
		@Mes5=Mes,
		@TipoAfectacion5=TipoAfectacion,
		@Importe=Importe,
		@TipoMovimientoGenera=TipoMovimientoGenera,
		@IdMovimiento=IdMovimiento,
		@Fecha=Fecha,
		@Estatus=Estatus,
		@IdObra=IdObra,
		@IdContrato=IdContrato,
		@IdPoliza=IdPoliza,
		@IdPartidaGI=IdPartidaGI,
		@UnicoHora=UnicoHora,
		@Cancelacion=Cancelacion
		From T_AfectacionPresupuesto
		Where IdSelloPresupuestal=@IdSello
		and Mes= MONTH(@FechaInicial)
		AND Periodo= YEAR(@FechaInicial)
  
  set @IdMov= (Select MAX(IdMov)+1 from T_AfectacionPresupuesto)
  
  INSERT INTO [T_AfectacionPresupuesto]
           ([IdMov]
           ,[IdSelloPresupuestal]
           ,[Periodo]
           ,[Mes]
           ,[TipoAfectacion]
           ,[Importe]
           ,[TipoMovimientoGenera]
           ,[IdMovimiento]
           ,[Fecha]
           ,[Estatus]
           ,[IdObra]
           ,[IdContrato]
           ,[IdPoliza]
           ,[IdPartidaGI]
           ,[UnicoHora]
           ,[Cancelacion])
           Values(
        @IdMov,
        @IdSelloPresupuestal5,
		Year(@FechaInicial),--nuevo periodo
		month(@FechaInicial),--nuevo mes
		'C',
		(@Monto*-1),--Nuevo monto
		'M',
		@IdMovimiento,
		@FechaInicial,--nueva fecha
		'',
		0,
		0,
		0,
		0,
		@UnicoHora,
		0
           
           )
          
        --Mes de afectacion   
        UPDATE T_PresupuestoNW
        set comprometido= comprometido- @Monto
        Where IdSelloPresupuestal=@Idsello 
        and Mes =MONTH(@FechaInicial)
        and year = YEAR(@FechaInicial)
        -- Mes Cero (anual)
        UPDATE T_PresupuestoNW
        set comprometido= comprometido- @Monto
        Where IdSelloPresupuestal=@Idsello
        and Mes =0
        and year = YEAR(@FechaFinal)
  
  end
  
  END 
  
END --IF opcion 5

END

GO


