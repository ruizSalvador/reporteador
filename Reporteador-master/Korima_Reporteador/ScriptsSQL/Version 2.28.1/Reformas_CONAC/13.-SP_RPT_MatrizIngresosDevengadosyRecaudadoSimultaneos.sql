
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].SP_RPT_MatrizIngresosDevengadosyRecaudadoSimultaneos') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].SP_RPT_MatrizIngresosDevengadosyRecaudadoSimultaneos
GO
/****** Object:  StoredProcedure [dbo].SP_RPT_MatrizRecaudadoIngresosSinDevengado    Script Date: 11/12/2017 13:23:24 Luis Rojas ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- EXEC SP_RPT_MatrizIngresosDevengadosyRecaudadoSimultaneos
CREATE PROCEDURE [dbo].SP_RPT_MatrizIngresosDevengadosyRecaudadoSimultaneos

AS
BEGIN

Select * from C_MatrizIngresosDevengadosyRecaudadoSimultaneos

End
go 


--exec SP_RPT_MatrizIngresosDevengadosyRecaudadoSimultaneos