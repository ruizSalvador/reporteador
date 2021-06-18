/****** Object:  StoredProcedure [dbo].[SP_RPT_GastosXComprobar_FondosRevolventes]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_GastosXComprobar_FondosRevolventes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_GastosXComprobar_FondosRevolventes]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_GastosXComprobar_FondosRevolventes]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_GastosXComprobar_FondosRevolventes 1,7,2016,0
CREATE PROCEDURE [dbo].[SP_RPT_GastosXComprobar_FondosRevolventes] 

@Periodo as int,
@Periodo2 as int,  
@Ejercicio as int,
@Tipo as int

AS
BEGIN

 Declare @tabla as table (
		IdViatico int
      ,NombreFondo varchar(max)
      ,Periodo int
      ,Folio int
	  ,FolioDesconcentrado int
	  ,NumeroEmpleado int
	  ,IdDepartamento int
	  ,ApellidoPaterno varchar(100)
	  ,Nombres varchar (100)
	  ,Fecha Datetime
	  ,Estatus varchar (20)
	  ,FolioPorTipo int
	  ,Total decimal(18,2)
 )

 
 Insert Into @tabla
 Select TV.IdViaticos, 
 CASE WHEN CFR.NombreFondo Is NULL THEN 'Viáticos/GxC'
	ELSE CFR.NombreFondo
	END as NombreFondo, 
	TV.Periodo, 
	TV.Folio, TV.FolioDesconcentrado, TV.NumeroEmpleado,  
	IdDepartamento, ApellidoPaterno, Nombres, TV.Fecha, 
	CASE TV.Estatus
	WHEN 'C' THEN 'Capturado'
	WHEN 'R' THEN 'Rechazado'
	WHEN 'A' THEN 'Afectado'
	WHEN 'N' THEN 'Cancelado'
	WHEN 'V' THEN 'Revisado'
	ELSE 'N/A'
	END as Estatus, 
	TS.FolioPorTipo, TV.Total
	FROM T_Viaticos TV
	LEFT JOIN T_SolicitudCheques TS
	ON TS.IdSolicitudCheques = TV.IdSolicitudChequesOriginal 
	LEFT JOIN C_FondosRevolventes CFR
	ON CFR.IDFONDOROTATORIO = TV.CajaChica
	INNER JOIN C_Empleados CE
	ON CE.NumeroEmpleado = TV.NumeroEmpleado
	Where YEAR(TV.Fecha) = @Ejercicio and (Month(TV.Fecha) Between @Periodo and @Periodo2)
	Order by Folio

	If @Tipo = 0
	Begin
		Select * from @tabla
	End

	If @Tipo = 1
	Begin
		Select * from @tabla where NombreFondo = 'Viáticos/GxC'
	End

	If @Tipo = 2
	Begin
		Select * from @tabla where NombreFondo != 'Viáticos/GxC'
	End

END






