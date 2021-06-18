/****** Object:  StoredProcedure [dbo].[SP_T_Nombramientos_ADD]    Script Date: 06/28/2013 17:35:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_T_Nombramientos_ADD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_T_Nombramientos_ADD]
GO

/****** Object:  StoredProcedure [dbo].[SP_T_Nombramientos_ADD]    Script Date: 06/28/2013 17:35:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 CREATE PROCEDURE [dbo].[SP_T_Nombramientos_ADD]
(
      @IdNombramiento as smallint,
      @Nombre as varchar(30),
      @MjsErrCode as int OUTPUT,                     -- Codigo de Error
      @MjsErrDescr as varchar(255)  OUTPUT           -- Descripcion del Error
)
AS
Begin Transaction
  INSERT INTO [dbo].[T_Nombramientos]  
  (
      IdNombramiento,
      Nombre
  )

VALUES  
(
      @IdNombramiento,
      @Nombre
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
  set @MjsErrDescr = 'Registro agregado: ' + @Nombre
  Commit
End

SET ANSI_NULLS ON


GO


