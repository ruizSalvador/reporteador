
/****** Object:  StoredProcedure [dbo].[SP_C_Empleados_ADD]    Script Date: 04/09/2013 09:13:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_C_Empleados_ADD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_C_Empleados_ADD]
GO


/****** Object:  StoredProcedure [dbo].[SP_C_Empleados_ADD]    Script Date: 04/09/2013 09:13:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- |========================================================= 
-- | Author: Miguel A. Quintana Martinez 
-- | Mail: maqm800802@msn.com
-- | Create date: 14-Abr-2011
-- | Description: Agrega registro en tabla: C_Empleados
-- |=========================================================
 

 CREATE PROCEDURE [dbo].[SP_C_Empleados_ADD]
(
@NumeroEmpleado as int ,
@Clave as varchar(40) = Null,
@IdDepartamento as int = Null,
@IdPuesto as smallint = Null,
@ApellidoPaterno as varchar(40) = Null,
@ApellidoMaterno as varchar(40) = Null,
@Nombres as varchar(80) = Null,
@IdAreaRespPresupuestal as smallint = Null,
@Credencial as int = Null,
@Digito as tinyint = Null,
@IdCiudadNacimiento as int = Null,
@IdNacionalidad as int = Null,
@Curp as varchar(20) = Null,
@Rfc as varchar(13) = Null,
@Sexo as varchar(1) = Null,
@EstadoCivil as varchar(1) = Null,
@Nacimiento as datetime = Null,
@CedulaProfesional as varchar(20) = Null,
@Estatus as tinyint = Null,
@Gobierno as datetime = Null,
@Organismo as datetime = Null,
@Titulacion as datetime = Null,
@NSS as varchar(20) = Null,
@ISSSTE as varchar(50) = Null,
@Fonac as tinyint = Null,
@Pension as tinyint = Null,
@CedulaIV as varchar(20) = Null,
@Administrador as tinyint = Null,
@Personal as tinyint = Null,
@Abreviatura as varchar(15) = Null,
@PorHonorarios as tinyint = Null,
@Tarjetas as varchar(20) = Null,
@Eventual as tinyint = Null,
@Activo as tinyint = Null,
@Expediente as varchar(20) = Null,
@IdCiudadResidencia as int = Null,
@Prefijo as varchar(7) = Null,
@Imagen as int = Null,
@Observaciones as varchar(255) = Null,
@GrupoSanguineo as varchar(50) = Null,
@LugarReside as varchar(100) = Null,
@LugarNacio as varchar(100) = Null,
@FecAsignacionPlaza as datetime = Null,
@IdNombramiento as int = Null,
@MjsErrCode as int OUTPUT, -- Codigo de Error
@MjsErrDescr as varchar(255)  OUTPUT -- Descripcion del Error
)
AS
Begin Transaction

--- Busca el ID de ciudad o mas semejante en base a ciudad,edo.
Set @IdCiudadNacimiento = (Select Top 1 IdCiudad  FROM
[dbo].[VW_CiudadesxId] 
    Where
[NombreCompleto] like @LugarNacio)
------
Set @IdCiudadResidencia = (Select Top 1 IdCiudad  FROM
[dbo].[VW_CiudadesxId] 
Where
[NombreCompleto] like @LugarReside)

set @IdAreaRespPresupuestal= (Select top 1 IdAreaResp FROM 
C_Departamentos where IdDepartamento=@IdDepartamento) 

  INSERT INTO [dbo].[C_Empleados]
  (
NumeroEmpleado,
Clave,
IdDepartamento,
IdPuesto,
ApellidoPaterno,
ApellidoMaterno,
Nombres,
IdAreaRespPresupuestal,
Credencial,
Digito,
IdCiudadNacimiento,
IdNacionalidad,
Curp,
Rfc,
Sexo,
EstadoCivil,
Nacimiento,
CedulaProfesional,
Estatus,
Gobierno,
Organismo,
Titulacion,
NSS,
ISSSTE,
Fonac,
Pension,
CedulaIV,
Administrador,
Personal,
Abreviatura,
PorHonorarios,
Tarjetas,
Eventual,
Activo,
Expediente,
IdCiudadResidencia,
Prefijo,
Imagen ,
Observaciones
  )

VALUES  
(
@NumeroEmpleado,
@Clave,
@IdDepartamento,
@IdPuesto,
@ApellidoPaterno,
@ApellidoMaterno,
@Nombres,
@IdAreaRespPresupuestal,
@Credencial,
@Digito,
@IdCiudadNacimiento,
@IdNacionalidad,
@Curp,
@Rfc,
@Sexo,
@EstadoCivil,
@Nacimiento,
@CedulaProfesional,
@Estatus,
@Gobierno,
@Organismo,
@Titulacion,
@NSS,
@ISSSTE,
@Fonac,
@Pension,
@CedulaIV,
@Administrador,
@Personal,
@Abreviatura,
@PorHonorarios,
@Tarjetas,
@Eventual,
1,
@Expediente,
@IdCiudadResidencia,
@Prefijo,
@Imagen ,
@Observaciones
)
Delete t_empdatosadicionales Where  IdEmpleado = @NumeroEmpleado
INSERT INTO dbo.t_empdatosadicionales
(
IdEmpleado,
SP
)
VALUES
(
@NumeroEmpleado,
@GrupoSanguineo
)
-- Tabla de Plazas 
 If @PorHonorarios is null
 Begin
INSERT INTO dbo.[C_Plazas]
(
IdPlaza
,ClavePago
,IdNombramiento
,IdHorario
,Programa
,SubPrograma
,Ur
,Partida
,IdPuesto
,Horas
,NumeroPuesto
,IdServicio
,IdDepartamento
,Estatus
,TipoPlaza
)
VALUES
(
@NumeroEmpleado
,Null 
,@IdNombramiento 
,1
,Null
,Null
,Null
,Null
,@IdPuesto
,8
,@NumeroEmpleado
,1
,@IdDepartamento
,'Asignada'
,'Estatal'
)
--- Agregar Datos a Empleados Plazas
Declare @VarIdMovimientoAlta as Int
Set @VarIdMovimientoAlta = (SELECT TOP 1 [IdAltaPlaza]  FROM
[dbo].[T_ParametrosRH])
    
INSERT INTO dbo.[T_EmpPlaza]
(
   [IdEmpleado]
  ,[IdPlaza]
  ,[Inicio]
  ,[Termino]
  ,[IdPuesto]
  ,[Nivel]
  ,[IdCategoria]
  ,[Estatus]
  ,[IdMovimientoAlta]
  ,[IdMovimientoBaja]
)
VALUES
(
  @NumeroEmpleado
  ,@NumeroEmpleado
  ,@FecAsignacionPlaza
  ,Null
  ,@IdPuesto
  ,Null
  ,Null
  ,1
  ,@VarIdMovimientoAlta
  ,Null
)

------------------------------------

--- TABLA DE T_EMPMOV
Declare @VarIdIncidencia as Int
Set @VarIdIncidencia = (SELECT TOP 1      [IdAltaPlaza]
FROM [dbo].[T_ParametrosRH])

  
  INSERT INTO dbo.[T_EmpMov]
(
[IdMovPer]
  ,[Ejercicio]
  ,[IdEmpleado]
  ,[IdPlaza]
  ,[IdAutoriza]
  ,[IdResponsable]
  ,[Inicio]
  ,[Termino]
  ,[Lote]
  ,[IdIncidencia]
  ,[Quincena]
  ,[Numero]
  ,[Incremento]
  ,[TotalAcordado]
  ,[Efecto]
  ,[Incapacidad]
  ,[Dias]
  ,[FechaAutorizacion]
  ,[IdDesconcentrado]
  ,[IdMovExterno]
  ,[MotivoMovimiento]
)
VALUES
(
@NumeroEmpleado 
  ,YEAR(@FecAsignacionPlaza)
  ,@NumeroEmpleado
  ,@NumeroEmpleado
  ,1
  ,1
  ,@FecAsignacionPlaza
  ,@FecAsignacionPlaza
  ,YEAR(@FecAsignacionPlaza)
  ,@VarIdIncidencia
  ,Null
  ,Null
  ,Null
  ,Null
  ,@FecAsignacionPlaza
  ,Null
  ,Null
  ,@FecAsignacionPlaza
  ,Null
  ,Null
  ,'Alta de empleado'
)
End
------------------------------------
 /*   Control de Errores    */
Set @MjsErrCode = @@Error
if (@@Error <> 0)
 Begin
  set @MjsErrDescr = (select description from master.dbo.sysmessages
                   where   error = @@Error)
  Rollback
 End
Else
 Begin
  set @MjsErrDescr = 'Registro agregado: ' + @Nombres + ' ' +
@ApellidoPaterno + ' ' + @ApellidoMaterno
  Commit
 End

GO


