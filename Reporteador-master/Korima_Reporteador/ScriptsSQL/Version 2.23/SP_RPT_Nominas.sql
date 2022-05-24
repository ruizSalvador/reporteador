/****** Object:  StoredProcedure [dbo].[SP_RPT_Nominas]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Nominas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Nominas]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_Nominas]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_Nominas 1,7,2016
CREATE PROCEDURE [dbo].[SP_RPT_Nominas] 
  
@Periodo as int,
@Periodo2 as int,
@Ejercicio as int

AS
BEGIN

 Declare @tabla as table (
		IdNomina int
      ,Year int
      ,Quincena int
      ,NoNomina int
	  ,Importe Decimal(18,2)
	  ,FechaPago Datetime
	  ,Ejercicio int
	  ,Periodo int
	  ,TipoPoliza varchar(10)
	  ,NoPoliza int
	  ,Observaciones varchar(max)
	  ,Tipo varchar (50)
	  ,FolioPorTipo int
	  ,FechaProgramacion Datetime
	  ,Beneficiario varchar (max)
	  ,ImporteSol Decimal (18,2)
	  ,Poliza varchar (max)
	  ,FolioCheque int
 )

 
 Insert Into @tabla
 Select TIN.IdNomina, TIN.Year, Quincena, NoNomina, TIN.Importe, TIN.FechaPago, 
		TP.Ejercicio, TP.Periodo, TP.TipoPoliza, TP.NoPoliza,
		TIN.Observaciones, 
		CASE RNSOL.Tipo
		WHEN 'N' THEN 'Pago de Nómina'
		WHEN 'T' THEN 'Pago de Terceros'
		END AS Tipo, 
		TSC.FolioPorTipo, 
		TSC.FechaProgramacion, TSC.Beneficiario, TSC.Importe as ImporteSol,
		CAST(Quincena as varchar(10)) + ' '  + TipoPoliza + ' ' + CAST(NoPoliza as varchar (50)) as Poliza,
		TC.FolioCheque 
	FROM T_ImportaNomina TIN
	LEFT JOIN T_Polizas TP
	ON TIN.IdPoliza = TP.IdPoliza
	LEFT JOIN R_NominaSolEgresos RNSOL
	ON TIN.IdNomina = RNSOL.IdNomina
	LEFT JOIN T_SolicitudCheques TSC
	ON TSC.IdSolicitudCheques = RNSOL.IdSolicitudCheques
	LEFT JOIN T_Cheques TC
	ON TC.IdSolicitudCheque = TSC.IdSolicitudCheques
	Where TIN.Year = @Ejercicio and (Month(TIN.FechaPago) Between @Periodo and @Periodo2)
	order by  TIN.IdNomina

	Select  * from @tabla
END






