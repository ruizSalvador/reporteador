IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Gasto_Departamento]'))
DROP PROCEDURE [dbo].[SP_RPT_Gasto_Departamento] 
Go

/****** Object:  StoredProcedure [dbo].[SP_RPT_Gasto_Departamento]    Script Date: 21/08/2018 09:42:29 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Exec SP_RPT_Gasto_Departamento 1,1,2019,0,0,0,0
CREATE PROCEDURE [dbo].[SP_RPT_Gasto_Departamento] 
  
@Mes1 int,
@Mes2 int,
@Ejercicio1 int,
--@Ejercicio2 int,
@IdDepto1 int,
@IdDepto2 int,
@IdPartida1 int,
@IdPartida2 int

AS
BEGIN

DECLARE @Gastos AS TABLE (
IdSelloPresupuestal int,
IdDepartamento int,
Departamento VARCHAR(MAX),
Partida int,
UR varchar(100),
Proyecto varchar(100),
Programa varchar(100),
ClaveFF varchar(100),
FuenteF varchar(max),
Importe decimal (18,2)
)


Insert Into @Gastos
Select 
	T_SellosPresupuestales.IdSelloPresupuestal,
		--C_RamoPresupuestal.CLAVE as Clave1, C_RamoPresupuestal.DESCRIPCION AS Descripcion,
		C_Departamentos.IdDepartamento,
		C_Departamentos.NombreDepartamento as Departamento,
		C_PartidasPres.IdPartida as Partida, 
		C_AreaResponsabilidad.Clave as UR , 
		--C_AreaResponsabilidad.Nombre as URDescripcion, 
		C_EP_Ramo.Clave AS Proyecto, 
		--C_EP_Ramo.Nombre as DescripcionPrograma,
		(Select top 1 N1.Clave  FROM (Select * from C_EP_Ramo T1 where T1.id = C_EP_Ramo.Id and Nivel = 5) N5
		inner join
		(select * from C_EP_Ramo where  Nivel = 4) N4 ON N5.IdPadre = N4.Id 
		inner join
		(select * from C_EP_Ramo where  Nivel = 3) N3 ON N4.IdPadre = N3.Id
		inner join
		(select * from C_EP_Ramo where  Nivel = 2) N2 ON N3.IdPadre = N2.Id
		inner join
		(select * from C_EP_Ramo where  Nivel = 1) N1 ON N2.IdPadre = N1.Id)
		as Programa,
		--C_ProyectosInversion.CLAVE as Programa, 
		--C_ProyectosInversion.NOMBRE  as DescripcionProyecto,
		 --C_EP_Ramo.Id,  
		 --C_PartidasPres.IdPArtida  as Partida, 
		C_FuenteFinanciamiento.CLAVE as ClaveFF, 
		C_FuenteFinanciamiento.DESCRIPCION as FuenteF,
		sum(isnull(TP.Importe,0)) as Importe	 
		FROM T_afectacionPresupuesto TP LEFT JOIN T_SellosPresupuestales  ON T_SellosPresupuestales.IdSelloPresupuestal = TP.IdSelloPresupuestal
		LEFT JOIN C_RamoPresupuestal ON C_RamoPresupuestal.IDRAMOPRESUPUESTAL = T_SellosPresupuestales.IdRamoPresupuestal  
		LEFT JOIN C_PartidasPres ON  C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida 
		LEFT JOIN C_PartidasGenericasPres 
		ON  C_PartidasGenericasPres.IdPartidaGenerica  = C_PartidasPres.IdPartidaGenerica 
		LEFT JOIN dbo.C_Departamentos ON dbo.C_Departamentos.IdDepartamento =  T_SellosPresupuestales.IdDepartamento
		LEFT JOIN C_AreaResponsabilidad 
		ON (C_AreaResponsabilidad.IdAreaResp  = C_Departamentos.IdAreaResp)  and (C_AreaResponsabilidad.IdRamoPresupuestal = 
		C_RamoPresupuestal.IDRAMOPRESUPUESTAL) LEFT JOIN C_FuenteFinanciamiento  ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO  =
		T_SellosPresupuestales.IdFuenteFinanciamiento 
		LEFT JOIN C_EP_Ramo ON C_EP_Ramo.Id = T_SellosPresupuestales.IdProyecto 
		LEFT JOIN C_ConceptosNEP ON C_ConceptosNEP.IdConcepto = C_PartidasGenericasPres.IdConcepto  LEFT JOIN C_ProyectosInversion 
		ON C_ProyectosInversion.PROYECTO  = T_SellosPresupuestales.Proyecto
				
		where  (Mes BETWEEN @Mes1 and @Mes2) AND Periodo=@Ejercicio1 and TipoAfectacion= 'P' and TipoMovimientoGenera in ('C','G','N')
		AND (C_PartidasPres.IdPartida >= case when @IdPartida1 = 0 then C_PartidasPres.IdPartida else @IdPartida1 end and C_PartidasPres.IdPartida <= case when @IdPartida2 = 0 then C_PartidasPres.IdPartida else @IdPartida2 end )
		AND (C_Departamentos.IdDepartamento >= case when @IdDepto1 = 0 then C_Departamentos.IdDepartamento else @IdDepto1 end and  C_Departamentos.IdDepartamento <= case when @IdDepto2 = 0 then C_Departamentos.IdDepartamento else @IdDepto2 end )

		group by C_Departamentos.IdDepartamento, C_Departamentos.NombreDepartamento, C_PartidasPres.IdPartida, 
		C_AreaResponsabilidad.Clave, C_EP_Ramo.Clave, C_ProyectosInversion.CLAVE, C_FuenteFinanciamiento.DESCRIPCION,
		C_EP_Ramo.Id, C_FuenteFinanciamiento.CLAVE, T_SellosPresupuestales.IdSelloPresupuestal
		
		Order By C_Departamentos.IdDepartamento asc,C_PartidasPres.IdPartida

Select * from @Gastos Where Importe <> 0

END

GO


