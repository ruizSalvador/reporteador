
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].SP_RPT_MatrizIngresosRecaudados') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].SP_RPT_MatrizIngresosRecaudados
GO
/****** Object:  StoredProcedure [dbo].SP_RPT_MatrizIngresosRecaudados    Script Date: 11/12/2017 13:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].SP_RPT_MatrizIngresosRecaudados
--@Desc_Concepto varchar(max),
--@SaldoMayor int,
--@Ejercicio int

AS
BEGIN

Select * from C_MatrizIngresosRecaudados

End
go 


--exec SP_RPT_MatrizIngresosRecaudados