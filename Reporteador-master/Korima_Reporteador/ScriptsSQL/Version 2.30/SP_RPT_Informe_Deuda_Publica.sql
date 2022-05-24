/****** Object:  StoredProcedure [dbo].[SP_RPT_Informe_Deuda_Publica]    Script Date: 03/03/2017 10:26:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Informe_Deuda_Publica]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Informe_Deuda_Publica]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_Informe_Deuda_Publica]    Script Date: 03/03/2017 10:26:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_Informe_Deuda_Publica 1,12,2020
Create Procedure [dbo].[SP_RPT_Informe_Deuda_Publica]
@MesInicio as int, 
@MesFin as int,
@Ejercicio int

AS



GO
