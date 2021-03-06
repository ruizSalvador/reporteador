

/****** Object:  StoredProcedure [dbo].[SP_Catalogo_de_Sellos_Presupuestales]   Script Date: 03/08/2018 10:45:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Catalogo_de_Sellos_Presupuestales]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Catalogo_de_Sellos_Presupuestales]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Raygoza Ochoa
-- Create date: 03/08/2018
-- Description:	Muestra contenido de la tabla de t_sellospresupuestales
-- =============================================
CREATE PROCEDURE [dbo].[SP_Catalogo_de_Sellos_Presupuestales]
	-- Add the parameters for the stored procedure here
	@Ejercicio as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select 
	T_SellosPresupuestales.IdSelloPresupuestal,
	T_SellosPresupuestales.Sello, 
	T_SellosPresupuestales.LYear, 
	T_SellosPresupuestales.IdPartida ,
	/*T_SellosPresupuestales.IdAreaResp,
	C_AreaResponsabilidad.Nombre */
	C_AreaResponsabilidad.Nombre as IdAreaResp,
	--T_SellosPresupuestales.IdAreaResp +  C_AreaResponsabilidad.Nombre as IdAreaResp ,
	--'1-Instituto Estatal de Cancerologia DR. Arturo Beltran Ortega' as IdAreaResp,
	--T_SellosPresupuestales.IdAreaResp  ,
	--C_AreaResponsabilidad.Nombre 
	'1-Instituto Estatal de Cancerologia DR. Arturo Beltran Ortega' as nombre


	from 
	T_SellosPresupuestales  
	INNER JOIN  
	C_AreaResponsabilidad
	ON 
	C_AreaResponsabilidad.IdAreaResp = T_SellosPresupuestales.IdAreaResp
	WHERE 
	LYear =  @Ejercicio

	 
	
EXEC SP_FirmasReporte 'Catalogo de Sellos Presupuestales'
END

GO
