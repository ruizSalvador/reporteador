/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_ADD]    Script Date: 02/28/2014 13:09:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CFG_DatosEntes_ADD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CFG_DatosEntes_ADD]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_CFG_DatosEntes_ADD]    Script Date: 02/28/2014 13:09:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
=======================================================================================================
Autor:		Ing. Miguel Angel Quintana Martínez
Elaboro:	Ing. Benjamín Meléndez
Reviso:		
Aprobó:		

Fecha:		2012-06-04
Descripción:Insertar nuevos registros para el Catalogo de RPT_CFG_DatosEntes
.......................................................................................................
Aviso de Propiedad: Este Procedimiento almacenado así como todo su contenido es propiedad intelectual 
                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
					parcial así como su modificación por personal distinto al designado por Korima. 
					Korima 2011
=======================================================================================================
|Versión  |Fecha      |Responsable         |Descripción de Cambio 
-------------------------------------------------------------------------------------------------------
| 1.0	  |2011.11.30 |Miguel Quintana     |Creación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2012.06.04 |Benjamín Meléndez   |Adecuación de procedimiento.
-------------------------------------------------------------------------------------------------------
| 1.0     |2014.02.28 |Enrique Hernandez   |Nuevo Campo Entidad Federativa.
=======================================================================================================
*/
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
	@EntidadFederativa as varchar(max),    --Campo Agregado EHM
	@OperacionID as Int  OUTPUT,
    @MjsErrCode as Int OUTPUT,			   -- Codigo de Error
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
			---Armar mensaje de operación exitosa
			Set @MjsErrDescr = 'Se agrego con éxito'
			Set @OperacionID = @@Identity
			Commit
		
				
	 End


GO


