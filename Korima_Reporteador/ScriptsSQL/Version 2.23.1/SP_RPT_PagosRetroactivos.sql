/****** Object:  StoredProcedure [dbo].[SP_RPT_PagosRetroactivos]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_PagosRetroactivos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_PagosRetroactivos]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_PagosRetroactivos]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_RPT_PagosRetroactivos '1','COMPENSACIONES FEBRERO 2016 TSQ',4,2016
CREATE PROCEDURE [dbo].[SP_RPT_PagosRetroactivos]
@ClaveFF varchar(20),
@Trimestre int,
@Ejercicio as int,
@Nomina varchar(max)

AS
BEGIN

DECLARE @MesInicio Int
DECLARE @MesFin Int

IF @Trimestre=1 BEGIN SET @MesInicio=1 SET @MesFin=3 END
IF @Trimestre=2 BEGIN SET @MesInicio=4 SET @MesFin=6 END
IF @Trimestre=3 BEGIN SET @MesInicio=7 SET @MesFin=9 END
IF @Trimestre=4 BEGIN SET @MesInicio=10 SET @MesFin=12 END

	Select 
		(Select 'R ' + CAST((Select IdEstado from C_Estados Where NombreEstados = (Select EntidadFederativa from RPT_CFG_DatosEntes)) as varchar (50))) as Clave,
		Rfc,
		Curp,
		(Select ApellidoPaterno + '  '  + ApellidoMaterno + '  '  + Nombres) as Nombre,
		CP.ClavePago as ClavePlaza,
		CCT.Clave as CCT,
		TIN.FechaPago as FechaCarga,
		TIN.FechaPago as FechaPago,
		(Select DATEADD(day, -58, TIN.FechaPago)) as LimiteRetroactividad,
		'' as PeriodoInicio,
		'' as PeriodoTermino,
		TEM.Inicio as FechaAlta,
		(Select TIN.Year + ' ' + TIN.Quincena) as Proceso,
		'' as DiasTranscurridos,
		(Select SUM(importe) from D_Nomina Where IdRenglonNomina in (Select IdRenglonNomina from D_NominaEmpleado where NumeroEmpleado = C_Empleados.NumeroEmpleado) and IdConceptoNomina in 
		(Select IdConceptoNomina from C_ConceptosNomina where Tipo = 'P' and IDFUENTEFINANCIAMIENTO = @ClaveFF)) as PercepcionesPagadas

	from C_Empleados
	LEFT JOIN T_EmpMov TEM
	ON C_Empleados.NumeroEmpleado = TEM.IdEmpleado
	LEFT JOIN T_EmpPlaza TEP
	ON TEM.IdPlaza = TEP.IdPlaza
	LEFT JOIN C_Plazas CP
	ON TEP.IdPlaza = CP.IdPlaza
	LEFT JOIN C_ClavesCentroTrabajo CCT
	ON CP.Idcct = CCT.Idcct
	LEFT JOIN C_ClasificacionPlazas CCP
	ON CP.IdclasPlazas = CCP.IdClasPlaza
	LEFT JOIN D_NominaEmpleado DNE
	ON C_Empleados.NumeroEmpleado = DNE.NumeroEmpleado
	LEFT JOIN D_Nomina DN
	ON DN.IdRenglonNomina = DNE.IdRenglonNomina
	LEFT JOIN T_ImportaNomina TIN
	ON TIN.IdNomina = DN.IdNomina
	LEFT JOIN C_ConceptosNomina CCN
	ON CCN.IdConceptoNomina = DN.IdConceptoNomina
	LEFT JOIN C_FuenteFinanciamiento CFF
	ON CFF.IdFuenteFinanciamiento = CCN.IdFuenteFinanciamiento
	WHERE CFF.Clave = @ClaveFF
	AND (MONTH(TIN.FechaPago) Between @MesInicio and @MesFin)
	AND YEAR(TIN.FechaPago) = @Ejercicio
	AND TIN.Observaciones = @Nomina
	Group by Rfc, Curp, Nombres, ApellidoPaterno, ApellidoMaterno, CP.ClavePago, CCT.Clave, TIN.FechaPago, TEM.Inicio,
			TIN.year, TIN.Quincena, C_Empleados.NumeroEmpleado


END
GO

EXEC SP_FirmasReporte 'Pagos Retroactivos FONE'
GO