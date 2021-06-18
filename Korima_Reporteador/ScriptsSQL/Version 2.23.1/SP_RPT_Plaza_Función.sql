/****** Object:  StoredProcedure [dbo].[SP_RPT_Plaza_Función]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Plaza_Función]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Plaza_Función]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_Plaza_Función]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_RPT_Plaza_Función '03',4,2016
CREATE PROCEDURE [dbo].[SP_RPT_Plaza_Función]

@ClaveFF varchar(20),
@Trimestre int,
@Ejercicio as int


AS
BEGIN

DECLARE @MesInicio Int
DECLARE @MesFin Int
DECLARE @DateTrim1 Datetime

IF @Trimestre=1 BEGIN SET @MesInicio=1 SET @MesFin=3 END
IF @Trimestre=2 BEGIN SET @MesInicio=4 SET @MesFin=6 END
IF @Trimestre=3 BEGIN SET @MesInicio=7 SET @MesFin=9 END
IF @Trimestre=4 BEGIN SET @MesInicio=10 SET @MesFin=12 END

SET @DateTrim1 = (select DATEADD(month,@MesInicio-1,DATEADD(year,@Ejercicio-1900,0)))

	Select 
		(Select 'R ' + CAST((Select IdEstado from C_Estados Where NombreEstados = (Select EntidadFederativa from RPT_CFG_DatosEntes)) as varchar (50))) as Clave,
		Rfc,
		Curp,
		(Select ApellidoPaterno + '  '  + ApellidoMaterno + '  '  + Nombres) as Nombre,
		CCT.Clave as CCT,
		CASE 
		  WHEN CP.IdclasPlazas  in (1,2) THEN 1 
		  ELSE 0 END as PlazasAdmvo,
		0 as HorasAdmvo,
		CASE 
		  WHEN CP.IdclasPlazas  in (3,4,5) THEN 1 
		  ELSE 0 END as PlazasDocente,
		0 as HorasDocente,
		CASE 
		  WHEN CP.IdclasPlazas in (6) THEN 1 
		  ELSE 0 END as PlazasMando,
		0 as HorasMando,
		1 as TotalPlazas,
		0 as TotalHoras,
		(Select SUM(importe) from D_Nomina Where IdRenglonNomina in (Select IdRenglonNomina from D_NominaEmpleado where NumeroEmpleado = C_Empleados.NumeroEmpleado) and IdConceptoNomina in 
		(Select IdConceptoNomina from C_ConceptosNomina where Tipo = 'P' and IDFUENTEFINANCIAMIENTO = @ClaveFF)) as PercepcionesPagadas


	from C_Empleados
	LEFT JOIN T_EmpMov TEM
	ON C_Empleados.NumeroEmpleado = TEM.IdEmpleado
	LEFT JOIN T_EmpPlaza TEP----
	ON C_Empleados.NumeroEmpleado = TEP.IdEmpleado
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
	WHERE TEP.Termino is null
	OR (TEP.Termino < @DateTrim1) 
	OR CFF.Clave = @ClaveFF
	Group by Rfc, Curp, CCT.Clave, CCP.Grupo, Nombres, ApellidoPaterno, ApellidoMaterno, C_Empleados.NumeroEmpleado, CP.IdclasPlazas,
	 DNE.NumeroEmpleado, CP.ClavePago
END
GO

EXEC SP_FirmasReporte 'Plaza Función FONE'
GO