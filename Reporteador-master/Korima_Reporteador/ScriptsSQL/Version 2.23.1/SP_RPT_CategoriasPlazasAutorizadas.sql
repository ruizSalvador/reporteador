/****** Object:  StoredProcedure [dbo].[SP_RPT_CategoriasPlazasAutorizadas]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CategoriasPlazasAutorizadas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].SP_RPT_CategoriasPlazasAutorizadas
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CategoriasPlazasAutorizadas]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_RPT_CategoriasPlazasAutorizadas '6',2,2010
CREATE PROCEDURE [dbo].[SP_RPT_CategoriasPlazasAutorizadas]
@ClaveFF varchar(20),
@Trimestre int,
@Ejercicio as int


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
		'Federal' as OrigenPresupuestal,
		CP.ClavePago as ClavePlaza,		
		'' as ZonaEconomica,
		CPT.NivelPuesto as NivelPuesto,
		'' as TipoContratacion,
		7 as CodigoConceptoPago,
		'' as MontoMensualPlaza,
		'' as MontoMensualHora,
		'' as NoHoras

	from C_Empleados
	LEFT JOIN T_EmpMov TEM
	ON C_Empleados.NumeroEmpleado = TEM.IdEmpleado
	LEFT JOIN T_EmpPlaza TEP
	ON TEM.IdPlaza = TEP.IdPlaza
	LEFT JOIN C_Plazas CP
	ON TEP.IdPlaza = CP.IdPlaza
	LEFT JOIN C_ClavesCentroTrabajo CCT
	ON CP.Idcct = CCT.Idcct
	LEFT JOIN D_NominaEmpleado DNE
	ON C_Empleados.NumeroEmpleado = DNE.NumeroEmpleado
	LEFT JOIN D_Nomina DN
	ON DN.IdRenglonNomina = DNE.IdRenglonNomina
	LEFT JOIN C_Puestos CPT
	ON CPT.IdPuesto = C_Empleados.IdPuesto
	LEFT JOIN C_ConceptosNomina CCN
	ON CCN.IdConceptoNomina = DN.IdConceptoNomina
	LEFT JOIN C_FuenteFinanciamiento CFF
	ON CFF.IdFuenteFinanciamiento = CCN.IdFuenteFinanciamiento
	WHERE CFF.Clave = @ClaveFF
	AND (MONTH(TEP.Inicio) Between @MesInicio and @MesFin)
	AND YEAR(TEP.Inicio) = @Ejercicio

END
GO

EXEC SP_FirmasReporte 'Analítico de Categorías Plazas Autorizadas con su Tabulador FONE'
GO