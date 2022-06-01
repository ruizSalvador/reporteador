/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoEmpleados]    Script Date: 12/12/2013 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CatalogoEmpleados]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CatalogoEmpleados]
GO


/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoEmpleados]    Script Date: 12/12/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_CatalogoEmpleados]
--@Fecha Datetime,
@Filtro varchar (max),
@Radio varchar(max),
@UR int,
@Depto int,
@FechaDel datetime,
@fechaAl datetime
as
DECLARE @Tabla TABLE (Numero int,Clave varchar(max),RFC varchar(max),Apaterno varchar(max),Amaterno varchar(max),Nombres varchar(max),Area varchar(max),Departamento varchar(max),Puesto varchar(max),fecha datetime)

If @Filtro = '(Ninguno)' and @Radio = 'Todos' begin
INSERT @Tabla
select  emp.NumeroEmpleado, emp.Clave, emp.Rfc, emp.ApellidoPaterno, emp.ApellidoMaterno, emp.Nombres, ar.Nombre as Area, depto.NombreDepartamento as Departamento, pue.Nombre as Puesto, Organismo 
from C_Empleados as emp
left join C_AreaResponsabilidad as ar on emp.IdAreaRespPresupuestal = ar.IdAreaResp
left join C_Departamentos as depto on emp.IdDepartamento = depto.IdDepartamento
left join C_Puestos as pue on emp.IdPuesto = pue.IdPuesto
END

If @Filtro = '(Ninguno)' and @Radio = 'Activos' begin
INSERT @Tabla
select  emp.NumeroEmpleado, emp.Clave, emp.Rfc, emp.ApellidoPaterno, emp.ApellidoMaterno, emp.Nombres, ar.Nombre as Area, depto.NombreDepartamento as Departamento, pue.Nombre as Puesto, Organismo 
from C_Empleados as emp
left join C_AreaResponsabilidad as ar on emp.IdAreaRespPresupuestal = ar.IdAreaResp
left join C_Departamentos as depto on emp.IdDepartamento = depto.IdDepartamento
left join C_Puestos as pue on emp.IdPuesto = pue.IdPuesto
where emp.Activo = 1
END

If @Filtro = '(Ninguno)' and @Radio = 'Inactivos' begin
INSERT @Tabla
select  emp.NumeroEmpleado, emp.Clave, emp.Rfc, emp.ApellidoPaterno, emp.ApellidoMaterno, emp.Nombres, ar.Nombre as Area, depto.NombreDepartamento as Departamento, pue.Nombre as Puesto, Organismo 
from C_Empleados as emp
left join C_AreaResponsabilidad as ar on emp.IdAreaRespPresupuestal = ar.IdAreaResp
left join C_Departamentos as depto on emp.IdDepartamento = depto.IdDepartamento
left join C_Puestos as pue on emp.IdPuesto = pue.IdPuesto
where emp.Activo = 0
END

If @Filtro = 'UR' and @Radio = 'Todos' begin
INSERT @Tabla
select  emp.NumeroEmpleado, emp.Clave, emp.Rfc, emp.ApellidoPaterno, emp.ApellidoMaterno, emp.Nombres, ar.Nombre as Area, depto.NombreDepartamento as Departamento, pue.Nombre as Puesto, Organismo 
from C_Empleados as emp
left join C_AreaResponsabilidad as ar on emp.IdAreaRespPresupuestal = ar.IdAreaResp
left join C_Departamentos as depto on emp.IdDepartamento = depto.IdDepartamento
left join C_Puestos as pue on emp.IdPuesto = pue.IdPuesto
where emp.IdAreaRespPresupuestal = @UR
END

If @Filtro = 'UR' and @Radio = 'Activos' begin
INSERT @Tabla
select  emp.NumeroEmpleado, emp.Clave, emp.Rfc, emp.ApellidoPaterno, emp.ApellidoMaterno, emp.Nombres, ar.Nombre as Area, depto.NombreDepartamento as Departamento, pue.Nombre as Puesto, Organismo 
from C_Empleados as emp
left join C_AreaResponsabilidad as ar on emp.IdAreaRespPresupuestal = ar.IdAreaResp
left join C_Departamentos as depto on emp.IdDepartamento = depto.IdDepartamento
left join C_Puestos as pue on emp.IdPuesto = pue.IdPuesto
where emp.IdAreaRespPresupuestal = @UR and emp.Activo = 1
END

If @Filtro = 'UR' and @Radio = 'Inactivos' begin
INSERT @Tabla
select  emp.NumeroEmpleado, emp.Clave, emp.Rfc, emp.ApellidoPaterno, emp.ApellidoMaterno, emp.Nombres, ar.Nombre as Area, depto.NombreDepartamento as Departamento, pue.Nombre as Puesto, Organismo 
from C_Empleados as emp
left join C_AreaResponsabilidad as ar on emp.IdAreaRespPresupuestal = ar.IdAreaResp
left join C_Departamentos as depto on emp.IdDepartamento = depto.IdDepartamento
left join C_Puestos as pue on emp.IdPuesto = pue.IdPuesto
where emp.IdAreaRespPresupuestal = @UR and emp.Activo = 0
END

If @Filtro = 'D' and @Radio = 'Todos' begin
INSERT @Tabla
select  emp.NumeroEmpleado, emp.Clave, emp.Rfc, emp.ApellidoPaterno, emp.ApellidoMaterno, emp.Nombres, ar.Nombre as Area, depto.NombreDepartamento as Departamento, pue.Nombre as Puesto, Organismo 
from C_Empleados as emp
left join C_AreaResponsabilidad as ar on emp.IdAreaRespPresupuestal = ar.IdAreaResp
left join C_Departamentos as depto on emp.IdDepartamento = depto.IdDepartamento
left join C_Puestos as pue on emp.IdPuesto = pue.IdPuesto
where emp.IdDepartamento = @Depto
END

If @Filtro = 'D' and @Radio = 'Activos' begin
INSERT @Tabla
select  emp.NumeroEmpleado, emp.Clave, emp.Rfc, emp.ApellidoPaterno, emp.ApellidoMaterno, emp.Nombres, ar.Nombre as Area, depto.NombreDepartamento as Departamento, pue.Nombre as Puesto, Organismo 
from C_Empleados as emp
left join C_AreaResponsabilidad as ar on emp.IdAreaRespPresupuestal = ar.IdAreaResp
left join C_Departamentos as depto on emp.IdDepartamento = depto.IdDepartamento
left join C_Puestos as pue on emp.IdPuesto = pue.IdPuesto
where emp.IdDepartamento = @Depto and emp.Activo = 1
END

If @Filtro = 'D' and @Radio = 'Inactivos' begin
INSERT @Tabla
select  emp.NumeroEmpleado, emp.Clave, emp.Rfc, emp.ApellidoPaterno, emp.ApellidoMaterno, emp.Nombres, ar.Nombre as Area, depto.NombreDepartamento as Departamento, pue.Nombre as Puesto, Organismo 
from C_Empleados as emp
left join C_AreaResponsabilidad as ar on emp.IdAreaRespPresupuestal = ar.IdAreaResp
left join C_Departamentos as depto on emp.IdDepartamento = depto.IdDepartamento
left join C_Puestos as pue on emp.IdPuesto = pue.IdPuesto
where emp.IdDepartamento = @Depto and emp.Activo = 0
END

If @Filtro = 'F' and @Radio = 'Todos' begin
INSERT @Tabla
select  emp.NumeroEmpleado, emp.Clave, emp.Rfc, emp.ApellidoPaterno, emp.ApellidoMaterno, emp.Nombres, ar.Nombre as Area, depto.NombreDepartamento as Departamento, pue.Nombre as Puesto, Organismo 
from C_Empleados as emp
left join C_AreaResponsabilidad as ar on emp.IdAreaRespPresupuestal = ar.IdAreaResp
left join C_Departamentos as depto on emp.IdDepartamento = depto.IdDepartamento
left join C_Puestos as pue on emp.IdPuesto = pue.IdPuesto
where emp.Organismo between @FechaDel and @fechaAl 
END

If @Filtro = 'F' and @Radio = 'Activos' begin
INSERT @Tabla
select  emp.NumeroEmpleado, emp.Clave, emp.Rfc, emp.ApellidoPaterno, emp.ApellidoMaterno, emp.Nombres, ar.Nombre as Area, depto.NombreDepartamento as Departamento, pue.Nombre as Puesto, Organismo 
from C_Empleados as emp
left join C_AreaResponsabilidad as ar on emp.IdAreaRespPresupuestal = ar.IdAreaResp
left join C_Departamentos as depto on emp.IdDepartamento = depto.IdDepartamento
left join C_Puestos as pue on emp.IdPuesto = pue.IdPuesto
where emp.Organismo between @FechaDel and @fechaAl 
      and emp.Activo = 1
END

If @Filtro = 'F' and @Radio = 'Inactivos' begin
INSERT @Tabla
select  emp.NumeroEmpleado, emp.Clave, emp.Rfc, emp.ApellidoPaterno, emp.ApellidoMaterno, emp.Nombres, ar.Nombre as Area, depto.NombreDepartamento as Departamento, pue.Nombre as Puesto, Organismo 
from C_Empleados as emp
left join C_AreaResponsabilidad as ar on emp.IdAreaRespPresupuestal = ar.IdAreaResp
left join C_Departamentos as depto on emp.IdDepartamento = depto.IdDepartamento
left join C_Puestos as pue on emp.IdPuesto = pue.IdPuesto
where emp.Organismo between @FechaDel and @fechaAl 
      and emp.Activo = 0
END

select * from @Tabla order by RFC

GO

EXEC SP_FirmasReporte 'Catálogo de Empleados'
GO