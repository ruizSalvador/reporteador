/****** Object:  StoredProcedure [dbo].[SP_RPT_ConsultaDeViaticos]    Script Date: 10/26/2016 12:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ConsultaDeViaticos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_ConsultaDeViaticos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_ConsultaDeViaticos]    Script Date: 10/26/2016 12:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC SP_RPT_ConsultaDeViaticos '20200101','20201231'
CREATE PROCEDURE [dbo].[SP_RPT_ConsultaDeViaticos] 

@FechaIni as Datetime,
@FechaFin as Datetime

AS
BEGIN

/*PRIMER SECCION DE LA CONSULTA SIRVE PARA CONCATENER LOS MUNICIPIOS VISITADOS*/
DECLARE @idsolicitudcheques AS int, @id as int, @dest as nvarchar(400)
DECLARE @nombres nvarchar(400)
DECLARE @edo nvarchar(200)
DECLARE Solicitudes CURSOR FOR SELECT IdSolicitudCheques FROM T_SolicitudCheques WHERE IdTipoMovimiento = 397



	IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'Temp_Destinos')
		BEGIN
			DELETE FROM Temp_Destinos
			
		END
	ELSE
		BEGIN
			CREATE TABLE Temp_Destinos (id int, idsolicitudcheques int,  destinos nvarchar(400), edo varchar(200))
		END

	SET @id = 0

	OPEN Solicitudes

	FETCH NEXT FROM Solicitudes INTO @idsolicitudcheques

	WHILE @@fetch_status = 0

	BEGIN
	SET @id = @id + 1
			SELECT @nombres = coalesce(@nombres + ', ', '') + 
			CC.NombreCiudad, @edo = CED.NombreEstados
			FROM D_SolicitudViaticos as DSV INNER JOIN C_Ciudades CC ON DSV.IdCiudad = CC.IdCiudad
			INNER JOIN C_Municipios CM ON CC.IdMunicipio = CM.IdMunicipio
			INNER JOIN C_Estados CED ON CM.IdEstado = CED.IdEstado
			WHERE IdSolicitudCheques = @idsolicitudcheques;
			
	SET @dest = @nombres

	INSERT INTO Temp_Destinos values(@id, @idsolicitudcheques, @dest, @edo );

	SET @nombres = NULL

	FETCH NEXT FROM Solicitudes INTO @idsolicitudcheques

	END

	CLOSE Solicitudes

	DEALLOCATE Solicitudes

--GO


/*CONSULTA PARA OBTENER EL LISTADO DE VIATICOS*/
SELECT Year(Fecha) as 'Periodo',  Datename(mm,Fecha) as 'Mes',
	   'Servidor p�blico' as 'Sujeto',
	   --'auditor' as 'Clave',
	   Clave,
	   --'auditor' as 'Puesto',
	   Puesto,
	   --'confianza' as 'Cargo',
	   Cargo,
	   Nombredepartamento as 'Area de adscripci�n',
	   Nombres as 'Nombres',
	   ApellidoPaterno as 'Apellido Paterno',
	   ApellidoMaterno as 'Apellido Materno',
	   Acto_Rep as 'Acto de representaci�n',
	   'Nacional' as 'Tipo de Viaje',
	   '1' as 'Acompa�antes',
	   'NA' as 'Importe Acompa�antes',
	   'M�xico' as 'Pa�s',
	   (Select top 1 EntidadFederativa from RPT_CFG_DatosEntes) as 'Estado',
	   (Select top 1 Ciudad from RPT_CFG_DatosEntes) as 'Ciudad',
	   'M�xico' as 'Pa�s Destino',
	   cd_Destino as 'Estado Destino',
	    Destino as 'Ciudad destino',
	   --'auditorias' as 'Motivo',
	   Motivo,
		CONVERT(VARCHAR(10), FechaInicial, 103) as 'Salida',
		CONVERT(VARCHAR(10), FechaFinal, 103) as 'Regreso',
		idpartida as 'ClavePartida',
		'viaticos' as 'Denominaci�n',
		Total AS 'Ejercido erogado',
		ImporteComprobado as 'Total Ejercido erogado',
		(Total - ImporteComprobado) as 'No erogado',
		--'NA' as 'Fecha entrega',
		Fecha_Entrega as 'Fecha entrega',
		'NA' as 'Hiper1',
		'NA' as 'Hiper2',
		'NA' as 'Hiper3',
		CONVERT(VARCHAR(10), Fecha, 103) as 'Fecha Validaci�n',
		'Departamento de Tesorer�a' as 'Area Responsable',
		'NA' as 'Agenda',
		ISNULL([ALIMENTACION],0.00) AS 'ALIMENTACION',
		ISNULL([HOSPEDAJE],0.00) AS 'HOSPEDAJE',
		ISNULL([TRASLADO],0.00) AS 'TRASLADO',
		ISNULL([COMBUSTIBLE],0.00) AS 'COMBUSTIBLE',
		ISNULL([PEAJES],0.00) AS 'PEAJES',
		ISNULL([PASAJES],0.00) AS 'PASAJES',
		ISNULL([OTROS],0.00) AS 'OTROS',
		'NA' as 'Resultados',
		Year(Fecha) as 'A�o'
FROM (
		SELECT TV.Fecha AS 'Fecha',
		CE.Nombres, CE.ApellidoPaterno, CE.ApellidoMaterno,
		TN.Nombre as 'Clave',
		CPU.Nombre as 'Puesto',
		CPC.Nombre as 'Cargo',
		TSC.Observaciones as 'Acto_Rep',
		TV.Justificacion as 'Motivo',
		DE.destinos AS 'Destino',
		DE.edo AS 'cd_Destino',
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
		CD.NombreDepartamento,
		(Select top 1 FechaEntrega from T_Cheques where T_Cheques.IdSolicitudCheque = TSC.IdSolicitudCheques) as 'Fecha_Entrega'
		FROM T_Viaticos TV
		INNER JOIN T_SolicitudCheques TSC ON TV.IdSolicitudChequesOriginal = TSC.IdSolicitudCheques
		INNER JOIN D_Viaticos DV ON TV.IdViaticos = DV.IdViatico
		INNER JOIN C_Empleados CE ON TSC.NumeroEmpleadoBenf = CE.NumeroEmpleado
		INNER JOIN C_Puestos CP ON CE.IdPuesto = CP.IdPuesto
		INNER JOIN C_Departamentos CD ON CE.IdDepartamento = CD.IdDepartamento
		INNER JOIN Temp_Destinos DE ON TSC.IdSolicitudCheques = DE.idsolicitudcheques

		--INNER JOIN C_Empleados CEV ON TV.NumeroEmpleado = CEV.NumeroEmpleado
		LEFT JOIN T_EmpPlaza TEP ON TV.NumeroEmpleado = TEP.IdEmpleado
	    LEFT JOIN C_Plazas CPL ON CPL.IdPlaza = TEP.IdPlaza
		LEFT JOIN T_Nombramientos TN ON TN.IdNombramiento = CPL.IdNombramiento
		LEFT JOIN C_Puestos CPU ON CPU.IdPuesto = CPL.IdPuesto 
		LEFT JOIN C_PuestoCategoria CPC ON CPC.IdCategoria = TEP.IdCategoria
		WHERE TSC.IdTipoMovimiento = 397 and TV.Fecha BETWEEN  @FechaIni  AND @FechaFin  
) AS Viaticos 
PIVOT
(
SUM(Importe)
FOR Concepto IN ([ALIMENTACION], [HOSPEDAJE], [TRASLADO], [COMBUSTIBLE], [PEAJES], [PASAJES], [OTROS])
) AS PV_Viaticos
ORDER BY PV_Viaticos.Fecha
END


Exec SP_FirmasReporte 'Consulta de Vi�ticos'
GO
Exec SP_CFG_LogScripts 'SP_RPT_ConsultaDeViaticos','2.31'
GO