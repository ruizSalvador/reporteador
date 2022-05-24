/****** Object:  StoredProcedure [dbo].[SP_RPT_FoliosNoTramitados]    Script Date: 14-04-2021 15:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_FoliosNoTramitados]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_FoliosNoTramitados]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_FoliosNoTramitados]    Script Date: 14-04-2021 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<>
-- Create date: <14-04-2021>
-- Description:	<Folios COBACH>
-- =============================================

-- Exec SP_RPT_FoliosNoTramitados 2020
CREATE PROCEDURE  [dbo].[SP_RPT_FoliosNoTramitados]  

@Ejercicio int

AS

BEGIN

Declare @min int
Declare @max int

Select @min = min(Folio) , @max = max(Folio) From T_Pedidos Where Periodo = @Ejercicio

Declare @tmp as table (LostId int, Tipo varchar(50))

While @min <= @max
Begin 
	If not exists(Select * From T_Pedidos Where Folio = @min and Periodo = @Ejercicio)
	Insert Into @tmp Values (@min,'Orden de Compra')
	set @min = @min + 1
End

Select @min = min(Folio), @max = max(Folio) From T_OrdenServicio Where Periodo = @Ejercicio

While @min <= @max
Begin 
	If not exists(Select * From T_OrdenServicio Where Folio = @min and Periodo = @Ejercicio)
	Insert Into @tmp Values (@min,'Orden de Servicio')
	Set @min = @min + 1
End


Select * From @tmp

END

Exec SP_CFG_LogScripts 'SP_RPT_FoliosNoTramitados','2.30.1'
GO