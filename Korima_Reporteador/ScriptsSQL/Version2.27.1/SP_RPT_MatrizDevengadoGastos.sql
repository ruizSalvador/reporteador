
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_MatrizDevengadoGastos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_MatrizDevengadoGastos]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_MatrizDevengadoGastos]    Script Date: 11/12/2017 13:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_RPT_MatrizDevengadoGastos]
--@Desc_Concepto varchar(max),
--@SaldoMayor int,
--@Ejercicio int

AS
BEGIN

Select * from C_MatrizDevengadoGastos

End
go 


--exec [SP_RPT_MatrizDevengadoGastos]