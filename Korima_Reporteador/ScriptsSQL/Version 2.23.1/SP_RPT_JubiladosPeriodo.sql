/****** Object:  StoredProcedure [dbo].[SP_RPT_JubiladosPeriodo]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_JubiladosPeriodo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_JubiladosPeriodo]
GO
/****** Object:  StoredProcedure [dbo].SP_RPT_JubiladosPeriodo]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_RPT_JubiladosPeriodo 3,2016
CREATE PROCEDURE [dbo].[SP_RPT_JubiladosPeriodo]
--@ClaveFF varchar(20),
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
		Rfc,
		Curp,
		(Select ApellidoPaterno + '  '  + ApellidoMaterno + '  '  + Nombres) as Nombre,
		CCT.Clave as CCT,
		CP.ClavePago as ClavePlaza,	
		TEP.Inicio as FechaAlta,
		TEP.Termino as FechaBaja

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
	WHERE C_Empleados.Activo = 0
	AND (MONTH(TEP.Termino) Between @MesInicio and @MesFin)
	AND YEAR(TEP.Termino) = @Ejercicio
	AND  DATEDIFF(year, C_Empleados.Nacimiento, TEM.Termino) > 65
	Group by CP.ClavePago, C_Empleados.Rfc, C_Empleados.Curp, C_Empleados.ApellidoPaterno, 
	C_Empleados.ApellidoMaterno, C_Empleados.Nombres, CCT.Clave, TEP.Inicio, TEP.Termino

END
GO

EXEC SP_FirmasReporte 'Jubilados por Periodo FONE'
GO