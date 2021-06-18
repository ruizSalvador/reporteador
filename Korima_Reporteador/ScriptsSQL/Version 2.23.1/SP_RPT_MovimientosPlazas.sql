/****** Object:  StoredProcedure [dbo].[SP_RPT_MovimientosPlazas]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_MovimientosPlazas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_MovimientosPlazas]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_MovimientosPlazas]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_RPT_MovimientosPlazas '8',1,2016
CREATE PROCEDURE [dbo].[SP_RPT_MovimientosPlazas]
@ClaveFF varchar(20),
@Trimestre int,
@Ejercicio as int


AS
BEGIN

EXEC SP_FirmasReporte 'Movimientos de Plazas FONE'
END
GO

