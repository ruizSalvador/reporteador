  
  
/*  
=======================================================================================================  
Autor:  Ing. Miguel Angel Quintana Martínez  
Elaboro: Ing. Benjamín Meléndez Gómez  
Reviso:    
Aprobó:    
  
Fecha:  2012-06-04  
Descripción:Actualizar registros en el Catalogo de RPT_CFG_DatosEntes  
.......................................................................................................  
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual   
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o   
     parcial así como su modificación por personal distinto al designado por Korima.   
     Korima 2011  
=======================================================================================================  
|Versión  |Fecha      |Responsable         |Descripción de Cambio   
-------------------------------------------------------------------------------------------------------  
| 1.0   |2011.11.30 |Miguel Quintana     |Creación de procedimiento.  
-------------------------------------------------------------------------------------------------------  
| 1.0     |2012.06.04 |Benjamín Meléndez     |Adecuación de procedimiento.  
-------------------------------------------------------------------------------------------------------  
| 1.0     |2014.02.28 |Enrique Hernandez   |Nuevo Campo Entidad Federativa.  
-------------------------------------------------------------------------------------------------------  
| 1.1     |2017.07.21 |Karim Zavala  |Nuevo Campo Logo Ente Secundario.  
=======================================================================================================  
*/  
 /****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_UPD]  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CFG_DatosEntes_UPD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CFG_DatosEntes_UPD]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_UPD]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
create Procedure [dbo].[SP_RPT_CFG_DatosEntes_UPD]  
(  
 @Id as int,  
 @Nombre as nvarchar(100),  
 @ClaveSistema as nvarchar(100),  
 @Domicilio as nvarchar (250),  
 @Ciudad as nvarchar(250),  
 @RFC as nvarchar (20),  
 @Telefonos as nvarchar(20),  
 @Texto as nvarchar (1000),  
 @LogoEnte as image,  
 @LogoKorima as image,  
 @LogoEnteSecundario as image,  
 @EntidadFederativa as varchar(max),    --Campo Agregado EHM  
 @MjsErrCode as Int OUTPUT,      -- Codigo de Error  
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error  
)  
AS  
Begin Transaction  
 --- Actualizar Registro  
 UPDATE [dbo].RPT_CFG_DatosEntes  
  SET  Nombre =@Nombre  
   ,ClaveSistema  =@ClaveSistema  
   ,Domicilio=@Domicilio  
   ,Ciudad=@Ciudad  
   ,RFC=@RFC  
   ,Telefonos=@Telefonos  
   ,Texto=@Texto  
   ,LogoEnte=@LogoEnte  
   ,LogoKorima=@LogoKorima  
   ,LogoEnteSecundario=@LogoEnteSecundario  
   ,LastUpdate=GETDATE()  
   ,EntidadFederativa=@EntidadFederativa    --Campo Agregado EHM  
  WHERE ID = @ID   
      
 /*==============================================================================================  
 Control de Errores  
 ==============================================================================================*/  
 Set @MjsErrCode = @@Error  
 If (@@Error <> 0)  
  Begin  
   Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error)  
   Rollback  
  End  
 Else  
  Begin  
   ---Armar mensaje de operación exitosa  
   Set @MjsErrDescr = 'Se modifico con éxito'  
      
   Commit  
  End  
  
  