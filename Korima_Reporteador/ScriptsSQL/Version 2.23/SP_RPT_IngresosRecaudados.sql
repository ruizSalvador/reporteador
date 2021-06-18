/****** Object:  StoredProcedure [dbo].[SP_RPT_IngresosRecaudados]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_IngresosRecaudados]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_IngresosRecaudados]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_IngresosRecaudados]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_IngresosRecaudados 1,12,2016
CREATE PROCEDURE [dbo].[SP_RPT_IngresosRecaudados] 
  
@Periodo as int,
@Periodo2 as int,
@Ejercicio as int


AS
BEGIN


 Declare @tablaRecaudados as table (
		Folio int
      ,Fecha Datetime
      ,FecDeposito Datetime
      ,Beneficiario varchar(100)
	  ,GranTotal Decimal (18,2)
	  ,Estatus varchar (20)
	  ,FechaCancelacion Datetime
	  ,Poliza varchar(10)
	  ,Codigo varchar(100)
	  ,Concepto varchar (max)
	  ,PuntoIngreso varchar (50)

	  
 )



	 Insert into @tablaRecaudados
	  Select TRC.Folio, TRC.Fecha, FecDeposito, Beneficiario, GranTotal, 
	  CASE TRC.Status
	  WHEN 'C' THEN 'Capturado'
	  WHEN 'I' THEN 'Impreso'
	  WHEN 'N' THEN 'Cancelado'
	  WHEN 'D' THEN 'Devuelto'
	  ELSE 'N/A'
	  END as Estatus, 
	 FechaCancelacion, 
	 CAST(TipoPoliza as varchar(10)) + ' '  + CAST(TP.Periodo as varchar (5)) + ' ' + CAST(NoPoliza as varchar (50)) as Poliza, 
	 TOB.Codigo, TRC.Concepto, Origen 
	 
	 From T_RecibosCaja TRC
	 LEFT JOIN T_Polizas TP
	 ON TP.IdPoliza = TRC.IdPoliza
	 LEFT JOIN C_PuntosIngreso CPI
	 ON TRC.IdPuntoIngreso = CPI.IdPunto
	 LEFT JOIN T_Obras TOB
	 ON TRC.IdObra = TOB.Obra
	 Where YEAR(TRC.Fecha)=@Ejercicio and (MONTH(TRC.Fecha) Between @Periodo and @Periodo2)

	 Select * from @tablaRecaudados
 
END