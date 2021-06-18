/****** Object:  StoredProcedure [dbo].[SP_C_Proveedores_ADD]    Script Date: 04/08/2013 13:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_C_Proveedores_ADD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_C_Proveedores_ADD]
GO

/****** Object:  StoredProcedure [dbo].[SP_C_Proveedores_ADD]    Script Date: 04/08/2013 13:49:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- |========================================================= 
-- | Author: Miguel A. Quintana Martinez 
-- | Mail: maqm800802@msn.com
-- | Create date: 14-Abr-2011
-- | Description: Agrega registro en tabla: C_Proveedores
-- |=========================================================


CREATE PROCEDURE [dbo].[SP_C_Proveedores_ADD]
(
      @IdProveedor as smallint  ,
      @RazonSocial as varchar(120)   ,
      @Domicilio as varchar(255)= Null,
      @Colonia as varchar(60)= Null,
      @CP as int= 0,
      @RFC as varchar(50)= Null,
      @TipoProveedor as varchar(50)= Null,
      @NacionalExtanjero as varchar(50)= Null,
      @TipoContribuyente as varchar(50)= Null,
      @Representante as varchar(60)= Null,
      @CURP as varchar(99)=Null,
      @MjsErrCode as int OUTPUT,                     -- Codigo de Error
      @MjsErrDescr as varchar(255)  OUTPUT           -- Descripcion del Error
)
      

AS
Begin Transaction
  INSERT INTO [dbo].[C_Proveedores]
  (
      IdProveedor,
      Clave,
      IdTipoProveedor ,
      IdCiudad,
      RazonSocial,
      Domicilio,
      Colonia,
      CP,
      RFC,
      TipoProveedor,
      NacionalExtanjero,
      TipoContribuyente,
      Representante,
      CURP,
      [Opt_02],
         [Opt_01]
  )

VALUES  
      (
      @IdProveedor,
      '',
      0,
      0,
      @RazonSocial,
      @Domicilio,
      @Colonia,
      @CP,
      @RFC,
      @TipoProveedor,
      @NacionalExtanjero,
      @TipoContribuyente,
      @Representante,
      @CURP,
      1,
         1
      )


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
  set @MjsErrDescr = 'Registro agregado: ' + @RazonSocial
  Commit
End




GO


