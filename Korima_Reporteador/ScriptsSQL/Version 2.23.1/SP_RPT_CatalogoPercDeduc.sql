/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoPercDeduc]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CatalogoPercDeduc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CatalogoPercDeduc]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoPercDeduc]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_RPT_CatalogoPercDeduc '6',1,2016
CREATE PROCEDURE [dbo].[SP_RPT_CatalogoPercDeduc]
@ClaveFF varchar(20),
@Trimestre int,
@Ejercicio as int


AS
BEGIN
DECLARE @MesInicio Int
DECLARE @MesFin Int

IF @Trimestre=1 BEGIN SET @MesInicio=1 SET @MesFin=3 END
IF @Trimestre=2 BEGIN SET @MesInicio=4 SET @MesFin=6 END
IF @Trimestre=3 BEGIN SET @MesInicio=7 SET @MesFin=9 END
IF @Trimestre=4 BEGIN SET @MesInicio=10 SET @MesFin=12 END

	Select 
		(Select 'R ' + CAST((Select IdEstado from C_Estados Where NombreEstados = (Select EntidadFederativa from RPT_CFG_DatosEntes)) as varchar (50))) as Clave,
		Case 	CCN.Tipo 
			When 'D' THEN 'Deducciones'
			When 'P' THEN 'Percepciones'
	    End as GrupoConcepto,
		CCN.ClaveArchivo as ClaveConcepto,
		CCN.Descripcion as Descripcion,
		CPP.ClavePArtida as PartidaR33,
		(select DATEADD(month,@MesInicio-1,DATEADD(year,@Ejercicio-1900,0))) as FechaDel,
		(select DATEADD(day,-1,DATEADD(month,@MesFin,DATEADD(year,@Ejercicio-1900,0)))) as FechaAl,
		CCN.Tipo

	From C_ConceptosNomina CCN
	LEFT JOIN C_PartidasPres CPP
	ON CPP.IdPartida = CCN.IdPartida
	LEFT JOIN C_FuenteFinanciamiento CFF
	ON CFF.IdFuenteFinanciamiento = CCN.IdFuenteFinanciamiento
	Where CCN.Tipo in ('P','D')
	AND CFF.Clave = @ClaveFF
	Order by CCN.Tipo desc

END
GO

EXEC SP_FirmasReporte 'Catálogo de Percepciones y Deducciones FONE'
GO