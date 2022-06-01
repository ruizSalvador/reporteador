  
  
/*  
=======================================================================================================  
Autor:  Ing. Miguel Angel Quintana Mart�nez  
Elaboro: Ing. Benjam�n Mel�ndez  
Reviso:    
Aprob�:    
  
Fecha:  2012-06-04  
Descripci�n:Insertar nuevos registros para el Catalogo de RPT_CFG_DatosEntes  
.......................................................................................................  
Aviso de Propiedad: Este Procedimiento almacenado as� como todo su contenido es propiedad intelectual   
                    de Korima Sistemas de Gesti�n SAPI de CV queda prohibida su reproducci�n total o   
     parcial as� como su modificaci�n por personal distinto al designado por Korima.   
     Korima 2011  
=======================================================================================================  
|Versi�n  |Fecha      |Responsable         |Descripci�n de Cambio   
-------------------------------------------------------------------------------------------------------  
| 1.0   |2011.11.30 |Miguel Quintana     |Creaci�n de procedimiento.  
-------------------------------------------------------------------------------------------------------  
| 1.0     |2012.06.04 |Benjam�n Mel�ndez   |Adecuaci�n de procedimiento.  
-------------------------------------------------------------------------------------------------------  
| 1.0     |2014.02.28 |Enrique Hernandez   |Nuevo Campo Entidad Federativa.  
-------------------------------------------------------------------------------------------------------  
| 1.1     |2017.07.21 |Karim Zavala  |Nuevo Campo Logo Ente Secundario.  
=======================================================================================================  
*/  
 /****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_ADD] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CFG_DatosEntes_ADD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CFG_DatosEntes_ADD]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_ADD]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
CREATE Procedure [dbo].[SP_RPT_CFG_DatosEntes_ADD]  
(  
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
 @OperacionID as Int  OUTPUT,  
    @MjsErrCode as Int OUTPUT,      -- Codigo de Error  
    @MjsErrDescr as varchar(255)  OUTPUT   -- Descripcion del Error  
)  
AS  
Begin Transaction  
 --- Insertar Registro  
 INSERT INTO [dbo].RPT_CFG_DatosEntes   
    (  
        [Nombre]  
     ,[ClaveSistema]  
       ,[Domicilio]  
       ,[Ciudad]  
       ,[RFC]  
       ,[Telefonos]  
       ,[Texto]  
       ,[LogoEnte]  
       ,[LogoKorima]  
       ,[LastUpdate]  
       ,[EntidadFederativa]    --Campo Agregado EHM  
	   ,[LogoEnteSecundario] 
    )  
    VALUES  
    (  
     @Nombre  
       ,@ClaveSistema  
       ,@Domicilio  
       ,@Ciudad  
       ,@RFC  
       ,@Telefonos  
       ,@Texto  
       ,@LogoEnte  
       ,@LogoKorima  
       ,GETDATE()  
       ,@EntidadFederativa     --Campo Agregado EHM 
	   ,@LogoEnteSecundario   
    )  
  
 /*==============================================================================================  
 Control de Errores  
 ==============================================================================================*/  
 Set @MjsErrCode = @@Error  
 If (@@Error <> 0)  
  Begin  
   Set @MjsErrDescr = (Select Description From Master.dbo.sysmessages Where error = @@Error And msglangid = 3082)  
   Rollback  
  End  
 Else  
  Begin  
   ---Armar mensaje de operaci�n exitosa  
   Set @MjsErrDescr = 'Se agrego con �xito'  
   Set @OperacionID = @@Identity  
   Commit  
    
      
  End  
  
  