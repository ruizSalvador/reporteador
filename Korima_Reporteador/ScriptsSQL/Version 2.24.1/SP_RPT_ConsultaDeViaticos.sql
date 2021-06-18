/****** Object:  StoredProcedure [dbo].[SP_RPT_ConsultaDeViaticos]    Script Date: 10/26/2016 12:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ConsultaDeViaticos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_ConsultaDeViaticos]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_ConsultaDeViaticos]    Script Date: 10/26/2016 12:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RPT_ConsultaDeViaticos '20160101','20161231'
CREATE PROCEDURE [dbo].[SP_RPT_ConsultaDeViaticos] 

@FechaIni as Datetime,
@FechaFin as Datetime

AS
BEGIN

/*PRIMER SECCION DE LA CONSULTA SIRVE PARA CONCATENER LOS MUNICIPIOS VISITADOS*/
DECLARE @idsolicitudcheques AS int, @id as int, @dest as nvarchar(400)
DECLARE @nombres nvarchar(400)
DECLARE Solicitudes CURSOR FOR SELECT IdSolicitudCheques FROM T_SolicitudCheques WHERE IdTipoMovimiento = 397


	IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'Temp_Destinos')
		BEGIN
			DELETE FROM Temp_Destinos
		END
	ELSE
		BEGIN
			CREATE TABLE Temp_Destinos (id int, idsolicitudcheques int,  destinos nvarchar(400))
		END

	SET @id = 0

	OPEN Solicitudes

	FETCH NEXT FROM Solicitudes INTO @idsolicitudcheques

	WHILE @@fetch_status = 0

	BEGIN
	SET @id = @id + 1
			SELECT @nombres = coalesce(@nombres + ', ', '') + 
			CC.NombreCiudad
			FROM D_SolicitudViaticos as DSV INNER JOIN C_Ciudades CC ON DSV.IdCiudad = CC.IdCiudad
			INNER JOIN C_Municipios CM ON CC.IdMunicipio = CM.IdMunicipio
			INNER JOIN C_Estados CED ON CM.IdEstado = CED.IdEstado
			WHERE IdSolicitudCheques = @idsolicitudcheques;
			
	SET @dest = @nombres

	INSERT INTO Temp_Destinos values(@id, @idsolicitudcheques, @dest );

	SET @nombres = NULL

	FETCH NEXT FROM Solicitudes INTO @idsolicitudcheques

	END

	CLOSE Solicitudes

	DEALLOCATE Solicitudes

--GO

/*CONSULTA PARA OBTENER EL LISTADO DE VIATICOS*/
SELECT Year(Fecha) as 'Periodo',  Datename(mm,Fecha) as 'Mes',
	   'Servidor público' as 'Sujeto',
	   'auditor' as 'Clave',
	   'auditor' as 'Puesto',
	   'confianza' as 'Cargo',
	   Nombredepartamento as 'Area de adscripción',
	   Nombres as 'Nombres',
	   ApellidoPaterno as 'Apellido Paterno',
	   ApellidoMaterno as 'Apellido Materno',
	   'Visita de auditoria' as 'Acto de representación',
	   'Nacional' as 'Tipo de Viaje',
	   '1' as 'Acompañantes',
	   'NA' as 'Importe Acompañantes',
	   'México' as 'País',
	   'Jalisco' as 'Estado',
	   'Guadalajara' as 'Ciudad',
	   'México' as 'País Destino',
	   'Jalisco' as 'Estado Destino',
	    Destino as 'Ciudad destino',
	   'auditorias' as 'Motivo',
		CONVERT(VARCHAR(10), FechaInicial, 103) as 'Salida',
		CONVERT(VARCHAR(10), FechaFinal, 103) as 'Regreso',
		idpartida as 'ClavePartida',
		'viaticos' as 'Denominación',
		Total AS 'Ejercido erogado',
		ImporteComprobado as 'Total Ejercido erogado',
		(Total - ImporteComprobado) as 'No erogado',
		'NA' as 'Fecha entrega',
		'NA' as 'Hiper1',
		'NA' as 'Hiper2',
		'NA' as 'Hiper3',
		CONVERT(VARCHAR(10), Fecha, 103) as 'Fecha Validación',
		'Direccion General de Administración' as 'Area Responsable',
		'NA' as 'Agenda',
		ISNULL([ALIMENTACION],0.00) AS 'ALIMENTACION',
		ISNULL([HOSPEDAJE],0.00) AS 'HOSPEDAJE',
		ISNULL([TRASLADO],0.00) AS 'TRASLADO',
		ISNULL([COMBUSTIBLE],0.00) AS 'COMBUSTIBLE',
		ISNULL([PEAJES],0.00) AS 'PEAJES',
		ISNULL([PASAJES],0.00) AS 'PASAJES',
		ISNULL([OTROS],0.00) AS 'OTROS',
		'NA' as 'Resultados',
		Year(Fecha) as 'Año'
FROM (
		SELECT TV.Fecha AS 'Fecha',
		CE.Nombres, CE.ApellidoPaterno, CE.ApellidoMaterno,
		TSC.Observaciones as 'Motivo',
		DE.destinos AS 'Destino',
		Case SUBSTRING(DV.Observacion,1,6)
			WHEN 'ALIMEN' THEN 'ALIMENTACION'
			WHEN 'HOSPED' THEN 'HOSPEDAJE'
			WHEN 'TRASLA' THEN 'TRASLADO'
			WHEN 'COMBUS' THEN 'COMBUSTIBLE'
			WHEN 'PEAJES' THEN 'PEAJES'
			WHEN 'PASAJE' THEN 'PASAJES'
		ELSE
			'OTROS'	
		END AS 'Concepto',
		DV.Importe,
		TV.Total,
		TSC.FechaInicial,
		TSC.FechaFinal,
		TSC.IdPartida,
		TSC.ImporteComprobado,
		CD.NombreDepartamento
		FROM T_Viaticos TV
		INNER JOIN T_SolicitudCheques TSC ON TV.IdSolicitudChequesOriginal = TSC.IdSolicitudCheques
		INNER JOIN D_Viaticos DV ON TV.IdViaticos = DV.IdViatico
		INNER JOIN C_Empleados CE ON TSC.NumeroEmpleadoBenf = CE.NumeroEmpleado
		INNER JOIN C_Puestos CP ON CE.IdPuesto = CP.IdPuesto
		INNER JOIN C_Departamentos CD ON CE.IdDepartamento = CD.IdDepartamento
		INNER JOIN Temp_Destinos DE ON TSC.IdSolicitudCheques = DE.idsolicitudcheques
		WHERE TSC.IdTipoMovimiento = 397 and TV.Fecha BETWEEN  @FechaIni  AND @FechaFin  
) AS Viaticos 
PIVOT
(
SUM(Importe)
FOR Concepto IN ([ALIMENTACION], [HOSPEDAJE], [TRASLADO], [COMBUSTIBLE], [PEAJES], [PASAJES], [OTROS])
) AS PV_Viaticos
ORDER BY PV_Viaticos.Fecha
END


Exec SP_FirmasReporte 'Consulta de Viáticos'
GO
Exec SP_CFG_LogScripts 'SP_RPT_ConsultaDeViaticos'
GO