/****** Object:  StoredProcedure [dbo].[SP_Formato_Resguardo]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Formato_Resguardo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Formato_Resguardo]
GO
/****** Object:  StoredProcedure [dbo].[SP_Formato_Resguardo]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_Formato_Resguardo 11
CREATE PROCEDURE [dbo].[SP_Formato_Resguardo]

@IdEmpleado int

AS
BEGIN


  Select distinct 
 Nombres + ' ' + ApellidoPaterno + ' ' + ApellidoMaterno as Nombre,
 C_Puestos.Nombre as Puesto,
 NumeroEmpleado ,
 Etiqueta,
 NoSerie,
 Marca,
 Modelo,
Descripcion,
T_AltaActivos.Observaciones,
C_AreaResponsabilidad.Nombre as UR
 --NombreDepartamento,DescripcionTipoBien, T_AltaActivos.FolioAlta, D_Resguardos.Estatus      
  from T_AltaActivos      inner join T_Activos         
  on T_Activos.FolioAlta = T_AltaActivos.FolioAlta         
 Left Join C_TipoBien   ON C_TipoBien.IdTipoBien = T_Activos.IdTipoBien     
 Left Join D_Resguardos   ON D_Resguardos.NumeroEconomico = T_Activos.NumeroEconomico    
 Left Join T_Resguardos  ON T_Resguardos.FolioResguardo = D_Resguardos.FolioResguardo     
 Left Join C_Empleados  ON C_Empleados.NumeroEmpleado = T_Resguardos.NumeroEmpleadoDestino     
 Left Join C_Puestos  ON C_Puestos.IdPuesto = C_Empleados.IdPuesto
 Left Join C_AreaResponsabilidad ON C_AreaResponsabilidad.IdAreaResp = C_Empleados.IdAreaRespPresupuestal 
   where NumeroEmpleadoDestino = @IdEmpleado  


END

GO

EXEC SP_FirmasReporte 'Impresión de Resguardos'
GO
