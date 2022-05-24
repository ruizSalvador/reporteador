/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Personal_Honorarios]    Script Date: 11/07/2013 14:39:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Personal_Honorarios]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Personal_Honorarios]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Personal_Honorarios]    Script Date: 11/07/2013 14:39:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_Personal_Honorarios]

AS

SELECT 
C_Empleados.ApellidoPaterno + ' ' + C_Empleados.ApellidoMaterno+' ' + C_Empleados.Nombres AS Nombre,
C_Departamentos.NombreDepartamento,
C_Empleados.Clave,
CONVERT(VARCHAR(MAX),ROW_NUMBER()OVER(ORDER BY C_Empleados.Clave) )+' Click Aqui...'AS Notas4,
--T_EmpPlaza.Inicio,
CONVERT(VARCHAR(MAX),ROW_NUMBER()OVER(ORDER BY C_Empleados.Clave) )+' Click Aqui...'AS Notas1,
CONVERT(VARCHAR(MAX),ROW_NUMBER()OVER(ORDER BY C_Empleados.Clave) )+' Click Aqui...'AS Notas2,
CONVERT(VARCHAR(MAX),ROW_NUMBER()OVER(ORDER BY C_Empleados.Clave) )+' Click Aqui...'AS Notas3
FROM C_Empleados
LEFT OUTER JOIN C_Departamentos ON C_Departamentos.IdDepartamento=C_Empleados.IdDepartamento 
LEFT OUTER JOIN T_EmpPlaza ON T_EmpPlaza.IdEmpleado=C_Empleados.NumeroEmpleado 
WHERE C_Empleados.PorHonorarios=1
ORDER BY C_Empleados.Clave
GO

EXEC SP_FirmasReporte 'Personal por Honorarios'
GO
