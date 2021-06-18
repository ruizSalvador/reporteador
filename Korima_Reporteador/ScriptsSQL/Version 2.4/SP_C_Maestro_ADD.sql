
/****** Object:  StoredProcedure [dbo].[SP_C_Empleados_ADD]    Script Date: 04/09/2013 09:13:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_C_Maestro_ADD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_C_Maestro_ADD]
GO


/****** Object:  StoredProcedure [dbo].[SP_C_Empleados_ADD]    Script Date: 04/09/2013 09:13:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

GO
/****** Object:  StoredProcedure [dbo].[SP_C_Maestro_ADD]    Script Date: 06/27/2013 10:27:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_C_Maestro_ADD]
(
@IdGrupo as Int,
@IdSubGrupo as int,
@IdCodigoProducto as int,
@ClavePartida as int,
@TipoProducto as int,
@DescripcionGenerica as varchar(255),
@UnidadMedida as varchar(3),
@IdPresentacion as int,
@EstatusProducto as int,
@NoEntraAlmacen as int,
@CodigoCambs as varchar(20),
@IdTipoBien as int,
@StockMinimo as bigint,
@StockMaximo as bigint,
@IdFamilia as bigint,
@MjsErrCode as int OUTPUT, -- Codigo de Error
@MjsErrDescr as varchar(255)  OUTPUT -- Descripcion del Error
)
AS
Begin Transaction

Declare @IntExiste as int
Set @IntExiste = (Select count(IdGrupo)  from [C_Grupos] where
[C_Grupos].IdGrupo= @IdGrupo)

Declare @IntIdTipoBien as int
set @IntIdTipoBien=1
Set @IntIdTipoBien=CASE @TipoProducto WHEN 2 THEN (Select count(IdTipoBien)  from [C_TipoBien] where [C_TipoBien].IdTipoBien= @IdTipoBien) ELSE 1 END

If @IntExiste > 0 
Begin

	Declare @IdClaveTmp as int
	Set @IdClaveTmp = (select IdPartida  from c_partidaspres where ClavePartida = convert(varchar(7),@ClavePartida))
	  INSERT INTO [dbo].[C_Maestro]
	  (
	IdGrupo,
	IdSubGrupo,
	IdCodigoProducto,
	ClavePartida,
	TipoProducto,
	DescripcionGenerica,
	UnidadMedida,
	IdPresentacion,
	EstatusProducto,
	NoEntraAlmacen,
	CodigoCambs,
	IdTipoBien,
	StockMinimo,
	StockMaximo,
	IdFamilia
	  )

	VALUES  
	(
	@IdGrupo,
	@IdSubGrupo,
	@IdCodigoProducto,
	@IdClaveTmp,
	@TipoProducto,
	@DescripcionGenerica,
	@UnidadMedida,
	@IdPresentacion,
	1,
	@NoEntraAlmacen,
	@CodigoCambs ,
	@IdTipoBien,
	@StockMinimo,
	@StockMaximo,
	@IdFamilia
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
	  set @MjsErrDescr = 'Registro agregado: ' + @DescripcionGenerica
	  Commit
	End
End

