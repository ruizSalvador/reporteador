/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Plazas_Existentes]    Script Date: 11/07/2013 11:30:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Plazas_Existentes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Plazas_Existentes]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Plazas_Existentes]    Script Date: 11/07/2013 11:30:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_Plazas_Existentes]
@FechaInicio DATETIME,
@FechaFin DATETIME
AS
--------------------------

declare @Idnomina Int

set @Idnomina= 
(select TOP 1  T_ImportaNomina.IdNomina from T_ImportaNomina where 
(T_ImportaNomina.FechaPago between @FechaInicio and @FechaFin )
order by  T_ImportaNomina.fechapago desc)

DECLARE @TablaNomina table(NumeroEmpleado int,Importe decimal(15,2))

INSERT INTO @TablaNomina 
Select D_NominaEmpleado.NumeroEmpleado,D_NominaEmpleado.Importe from D_NominaEmpleado where IdRenglonNomina in 
(Select IdRenglonNomina from D_Nomina where IdNomina = @Idnomina  and IdConceptoNomina in
      (Select IdConceptoNomina from C_ConceptosNomina where IdPartida = 1131))  

--------------------------
declare @TablaPlazas as table (Nombre varchar(max),Curp varchar(max),Rfc varchar(max),TipoPlaza varchar(max),Horas int,NombreDepartamento varchar(max),Notas1 decimal (15,2),Origen varchar(max),Movimiento varchar(max),Contador int,Fecha Datetime)
insert into @TablaPlazas
--SELECT --distinct
--isnull(C_Empleados.ApellidoPaterno,'') + ' ' + isnull(C_Empleados.ApellidoMaterno,'')+' ' + isnull(C_Empleados.Nombres,'') AS Nombre,
--C_Empleados.Curp,
--C_Empleados.Rfc,
--T_Nombramientos.Nombre AS TipoPlaza,
--C_Plazas.Horas,
--C_Departamentos.NombreDepartamento,
--tbl.Importe as Notas1,
--C_Plazas.TipoPlaza as Origen,
--REPLACE(T_EmpMov.MotivoMovimiento,' de empleado','') +' '+CONVERT(VARCHAR(2),day(T_EmpMov.Inicio))+'/'+CONVERT(VARCHAR(2),MONTH(T_EmpMov.Inicio))+'/'+CONVERT(VARCHAR(4),YEAR(T_EmpMov.Inicio))AS Movimiento,
--1 as Contador
--FROM 
--T_EmpMov
--LEFT OUTER JOIN  C_Empleados ON
--C_Empleados.NumeroEmpleado=T_empMov.IdEmpleado
--LEFT OUTER JOIN C_Plazas ON
--C_Plazas.Idplaza= T_EmpMov.Idplaza
--LEFT OUTER JOIN T_Nombramientos
--ON T_Nombramientos.IdNombramiento = C_Plazas.IdNombramiento
--LEFT OUTER JOIN C_Departamentos 
--ON C_Departamentos.IdDepartamento = C_Plazas.IdDepartamento
SELECT 
isnull(C_Empleados.ApellidoPaterno,'') + ' ' + isnull(C_Empleados.ApellidoMaterno,'')+' ' + isnull(C_Empleados.Nombres,'') AS Nombre,
C_Empleados.Curp,
C_Empleados.Rfc,
T_Nombramientos.Nombre AS TipoPlaza,
C_Plazas.Horas,
C_Departamentos.NombreDepartamento,
tbl.Importe as Notas1,
C_Plazas.TipoPlaza as Origen,
'Alta '+CONVERT(VARCHAR(2),day(T_EmpPlaza.Inicio))+'/'+CONVERT(VARCHAR(2),MONTH(T_EmpPlaza.Inicio))+'/'+CONVERT(VARCHAR(4),YEAR(T_EmpPlaza.Inicio))AS Movimiento,
1 as Contador,
T_EmpPlaza.Inicio as Fecha
FROM 
C_Empleados 
LEFT  OUTER 
JOIN T_EmpPlaza ON C_Empleados.NumeroEmpleado=T_EmpPlaza.IdEmpleado
LEFT OUTER JOIN C_Plazas ON
C_Plazas.Idplaza= T_EmpPlaza.IdPlaza
LEFT OUTER JOIN T_Nombramientos
ON T_Nombramientos.IdNombramiento = C_Plazas.IdNombramiento
LEFT OUTER JOIN C_Departamentos 
ON C_Departamentos.IdDepartamento = C_Plazas.IdDepartamento


left outer JOIN @TablaNomina tbl ON tbl.NumeroEmpleado=C_Empleados.NumeroEmpleado
WHERE (T_EmpPlaza.Inicio BETWEEN @FechaInicio AND @FechaFin ) --or (T_EmpMov.Termino BETWEEN @FechaInicio AND @FechaFin)
And T_EmpPlaza.Inicio is not null 
--ORDER BY C_Empleados.ApellidoPaterno,
--T_EmpMov.Inicio,
--T_Nombramientos.Nombre

insert into @TablaPlazas
SELECT 
isnull(C_Empleados.ApellidoPaterno,'') + ' ' + isnull(C_Empleados.ApellidoMaterno,'')+' ' + isnull(C_Empleados.Nombres,'') AS Nombre,
C_Empleados.Curp,
C_Empleados.Rfc,
T_Nombramientos.Nombre AS TipoPlaza,
C_Plazas.Horas,
C_Departamentos.NombreDepartamento,
tbl.Importe as Notas1,
C_Plazas.TipoPlaza as Origen,
'Baja '+CONVERT(VARCHAR(2),day(T_EmpPlaza.Termino))+'/'+CONVERT(VARCHAR(2),MONTH(T_EmpPlaza.Termino))+'/'+CONVERT(VARCHAR(4),YEAR(T_EmpPlaza.Termino))AS Movimiento,
1 as Contador,
T_EmpPlaza.Termino as Fecha
FROM 
C_Empleados 
LEFT  OUTER 
JOIN T_EmpPlaza ON C_Empleados.NumeroEmpleado=T_EmpPlaza.IdEmpleado
LEFT OUTER JOIN C_Plazas ON
C_Plazas.Idplaza= T_EmpPlaza.IdPlaza
LEFT OUTER JOIN T_Nombramientos
ON T_Nombramientos.IdNombramiento = C_Plazas.IdNombramiento
LEFT OUTER JOIN C_Departamentos 
ON C_Departamentos.IdDepartamento = C_Plazas.IdDepartamento


left outer JOIN @TablaNomina tbl ON tbl.NumeroEmpleado=C_Empleados.NumeroEmpleado
WHERE (T_EmpPlaza.Termino BETWEEN @FechaInicio AND @FechaFin ) --or (T_EmpMov.Termino BETWEEN @FechaInicio AND @FechaFin)
and T_EmpPlaza.Termino is not null 
--ORDER BY C_Empleados.ApellidoPaterno,
--T_EmpMov.Inicio,
--T_Nombramientos.Nombre

select --distinct 
Nombre,Curp,Rfc,TipoPlaza,Horas,NombreDepartamento,Notas1,Origen,Movimiento,Contador, Fecha   from @TablaPlazas 
ORDER BY Nombre,Fecha,TipoPlaza 

GO

EXEC SP_FirmasReporte 'Plazas Existentes'
GO