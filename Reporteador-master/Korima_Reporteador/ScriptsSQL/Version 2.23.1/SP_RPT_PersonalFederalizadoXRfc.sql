/****** Object:  StoredProcedure [dbo].[SP_RPT_PersonalFederalizadoXRfc]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_PersonalFederalizadoXRfc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_PersonalFederalizadoXRfc]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_PersonalFederalizadoXRfc]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_RPT_PersonalFederalizadoXRfc 1,7,'5',2,2016
CREATE PROCEDURE [dbo].[SP_RPT_PersonalFederalizadoXRfc]
@ClaveFF varchar(20),
@Periodo1 int,
@Periodo2 int,
--@Trimestre int,
@Ejercicio as int


AS
BEGIN

--DECLARE @MesInicio Int
--DECLARE @MesFin Int

--IF @Trimestre=1 BEGIN SET @MesInicio=1 SET @MesFin=3 END
--IF @Trimestre=2 BEGIN SET @MesInicio=4 SET @MesFin=6 END
--IF @Trimestre=3 BEGIN SET @MesInicio=7 SET @MesFin=9 END
--IF @Trimestre=4 BEGIN SET @MesInicio=10 SET @MesFin=12 END

	Select 
		(Select 'R ' + CAST((Select IdEstado from C_Estados Where NombreEstados = (Select EntidadFederativa from RPT_CFG_DatosEntes)) as varchar (50))) as Clave,
		Rfc,
		Curp,
		(Select ApellidoPaterno + '  '  + ApellidoMaterno + '  '  + Nombres) as Nombre,
		CP.ClavePago as ClavePlaza,
		CCP.Grupo as TipoCategoriaModelo,
		(Select CAST (TIN.Year AS VARCHAR(4)) + '-' + CAST (TIN.Quincena AS VARCHAR(4))) as Periodo,	
	    CASE
			WHEN  (TIN.Quincena/2) > 12 THEN NULL
		    WHEN TIN.Quincena  % 2 = 1 and (TIN.Quincena/2) <= 12
				THEN (select DATEADD(month,(select ceiling((SELECT CAST (TIN.Quincena  as float) / 2)))-1,DATEADD(year,@Ejercicio-1900,0)) )
			WHEN TIN.Quincena  % 2 != 1 and (TIN.Quincena/2) <= 12
				THEN (SELECT convert(datetime, (Select CAST(CAST(@Ejercicio AS VARCHAR(4)) + '-' + CAST((select ceiling((SELECT CAST (TIN.Quincena  as float) / 2))) AS VARCHAR(3)) + '-16' AS varchar(20))), 111))
		
		ELSE NULL
		END	as FechaInicial,
		  CASE
			 WHEN (TIN.Quincena/2) > 12 THEN NULL
		     WHEN TIN.Quincena % 2 = 1 and (TIN.Quincena/2) <= 12
			 THEN (SELECT convert(datetime,    (Select CAST(CAST(@Ejercicio AS VARCHAR(4)) + '-' + CAST((select ceiling((SELECT CAST (TIN.Quincena as float) / 2))) AS VARCHAR(3)) + '-15' AS varchar(20))), 111) )
			
		   WHEN TIN.Quincena  % 2 != 1 and (TIN.Quincena/2) <= 12
			THEN  (select DATEADD(day,-1,DATEADD(month,(select ceiling((SELECT CAST (TIN.Quincena as float) / 2))),DATEADD(year,@Ejercicio-1900,0))) )
			  ELSE NULL
			END as FechaFinal,
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
	AND (TIN.Quincena Between @Periodo1 and @Periodo2)
	AND TIN.Year = @Ejercicio
	Group by Rfc, Curp, Nombres, ApellidoPaterno, ApellidoMaterno, CP.ClavePago, CCP.Grupo, TIN.Year, TIN.Quincena, C_Empleados.NumeroEmpleado

END
GO

EXEC SP_FirmasReporte 'Personal Federalizado por Rfc FONE'
GO