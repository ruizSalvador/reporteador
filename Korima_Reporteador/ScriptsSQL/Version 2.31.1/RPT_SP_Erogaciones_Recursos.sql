/****** Object:  StoredProcedure [dbo].[RPT_SP_Erogaciones_Recursos]    Script Date: 02/01/2017 11:41:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_Erogaciones_Recursos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_Erogaciones_Recursos]
GO
                                        
/****** Object:  StoredProcedure [dbo].[RPT_SP_Erogaciones_Recursos]    Script Date: 02/01/2017 11:45:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
 -- Exec RPT_SP_Erogaciones_Recursos 2021,1,6,0
CREATE PROCEDURE [dbo].[RPT_SP_Erogaciones_Recursos]	


@Periodo int,
@Periodo2 int,
@Ejercicio int,
@IdFF int

AS
BEGIN


Declare @Rpt as TABLE(
IdClave int,
Clave varchar(max),
Descripcion varchar (255),

[0] decimal (15,2),
[1] decimal (15,2),
[2] decimal (15,2),
[3] decimal (15,2),
[4] decimal (15,2),
[5] decimal (15,2),
[6] decimal (15,2),
[7] decimal (15,2),
[8] decimal (15,2),
[9] decimal (15,2),
[10] decimal (15,2),
[11] decimal (15,2),
[12] decimal (15,2)
)

Insert into @Rpt
Select  IdCapitulo, NumeroCuenta, NombreCuenta,
 ISNULL([0],0) ,ISNULL([1],0), ISNULL([2],0), ISNULL([3],0),ISNULL([4],0),ISNULL([5],0),ISNULL([6],0),ISNULL([7],0),ISNULL([8],0),ISNULL([9],0),ISNULL([10],0),ISNULL([11],0),ISNULL([12],0)
From (

Select CG.IdCapitulo,  CC.NombreCuenta, CC.NumeroCuenta, MONTH(T_Polizas.Fecha) as Mes, SUM(D_Polizas.ImporteCargo) As Importe
		from T_Polizas JOIN D_Polizas 
		On T_Polizas.IdPoliza = D_Polizas.IdPoliza
		LEFT JOIN T_SellosPresupuestales TS
		On D_Polizas.IdSelloPresupuestal = TS.IdSelloPresupuestal
		LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida 
		LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto 
		LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo 
		LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO 
		 JOIN VW_C_Contable as CC ON CC.IdCuentaContable = D_Polizas.IdCuentaContable and LEFT(CC.iNumeroCuenta,1) = 5

		where YEAR(T_Polizas.Fecha) = @Ejercicio  
		AND (MONTH(T_Polizas.Fecha) BETWEEN  @Periodo AND @Periodo2)
		AND FF.IDFUENTEFINANCIAMIENTO = CASE WHEN @IdFF = 0 THEN FF.IDFUENTEFINANCIAMIENTO ELSE @IdFF END
		group by CG.IdCapitulo, 
		CC.NombreCuenta, 
		CC.NumeroCuenta, 
		MONTH(T_Polizas.Fecha) 
		--CC.iNumeroCuenta


 ) as p
	PIVOT 
	( 
		sum(Importe) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable
		

	Select * from @Rpt	Order by IdClave

END

EXEC SP_FirmasReporte 'Erogaciones de Recursos Recibidos'
GO