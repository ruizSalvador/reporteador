/****** Object:  StoredProcedure [dbo].[SP_RPT_IngresosXRecaudar]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_IngresosXRecaudar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_IngresosXRecaudar]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_IngresosXRecaudar]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_IngresosXRecaudar 1,7,2016
CREATE PROCEDURE [dbo].[SP_RPT_IngresosXRecaudar] 
  
@Periodo as int,
@Periodo2 as int,
@Ejercicio as int

AS
BEGIN

Declare @tablaPorRecaudar as table (
		Folio int
      ,Fecha Datetime
      ,RazonSocial varchar (100)
      ,TotalFacturado Decimal(18,2)
	  ,Estatus varchar(20)
	  ,FechaCancelacion Datetime
	  ,Pagado varchar (20)
	  ,PuntoIngreso varchar (50)
	  ,NoPoliza varchar(10)
	  
 )

 
 
	 Insert into @tablaPorRecaudar
	 Select Folio, TF.Fecha, CC.RazonSocial, TotalFacturado, 
	 CASE TF.Status
	  WHEN 'C' THEN 'Capturado'
	  WHEN 'I' THEN 'Impreso'
	  WHEN 'N' THEN 'Cancelado'
	  WHEN 'G' THEN 'No Generada'
	  ELSE 'Refactura'
	  END as Estatus,  
	 FechaCancelacion,
	 CASE
	 WHEN (TotalFacturado= ImporteNotasCredito + ImportePagado) THEN 'PAGADO'
	 WHEN (ImportePagado + ImporteNotasCredito = 0) THEN 'NO'
	 ELSE 'PARCIAL' 
	 END as Pagado,
	 Origen, 
	 CAST(TP.TipoPoliza as varchar(10)) + ' '  + CAST(TP.Periodo as varchar (5)) + ' ' + CAST(TP.NoPoliza as varchar (50)) as NoPoliza
	 From T_Facturas TF
	 LEFT JOIN C_Clientes CC
	 ON TF.IdCliente = CC.IdCliente
	 LEFT JOIN C_PuntosIngreso CPI
	 ON TF.IdPuntoIngreso = CPI.IdPunto
	 LEFT JOIN T_Polizas TP
	 ON TF.IdPoliza = TP.IdPoliza
	 Where YEAR(TF.Fecha)=@Ejercicio and (MONTH(TF.Fecha) Between @Periodo and @Periodo2)

	 Select * from @tablaPorRecaudar


END