/****** Object:  StoredProcedure [dbo].[SP_RPT_Control_Presupuestal]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Control_Presupuestal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Control_Presupuestal]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_Control_Presupuestal]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_Control_Presupuestal 1,12,2017,0,0,0,0
CREATE PROCEDURE [dbo].[SP_RPT_Control_Presupuestal]

@MesIni int,
@MesFin int,
@Ejercicio int,
@IdFF int,
@IdPartida int,
@IdPartidaFin int,
@IdCapitulo int

AS

Declare @RPT as table(
Cuenta varchar(max),
Capitulo int,
Partida int,
Concepto Varchar(max),
Autorizado decimal(18,4),
Ejercido decimal(18,4),
PorEjercer decimal(18,4),
TotalAutorizado decimal(18,4),
TotalEjercido decimal(18,4),
TotalPorEjercer decimal(18,4),
Negritas bit,
orden int)


Declare @RPTFinal as table(
Cuenta varchar(max),
Partida int,
Concepto Varchar(max),
Autorizado decimal(18,4),
Ejercido decimal(18,4),
PorEjercer decimal(18,4),
TotalAutorizado decimal(18,4),
TotalEjercido decimal(18,4),
TotalPorEjercer decimal(18,4),
Negritas bit,
orden int)


INSERT INTO @RPT
SELECT ccon.NumeroCuenta as Cuenta,
		CG.IdCapitulo as Capitulo,
	   cpartida.IdPartida as Partida,
	   cpartida.DescripcionPartida as Concepto,
	sum(isnull(Autorizado,0)) as Autorizado, 
	sum(isnull(Ejercido,0)) as Ejercido, 
	isnull((sum(Modificado) - sum(Comprometido)),0) as PorEjercer,
	0 as TotalAutorizado,
	0 as TotalEjercido,
	0 as TotalPorEjercer,
	0 as Negritas,
	cpartida.IdPartida as orden
	FROM t_presupuestoNW 
	inner join T_SellosPresupuestales as sellos
	ON t_presupuestoNW.IdSelloPresupuestal = sellos.IdSelloPresupuestal
	left join C_PartidasPres cpartida
	ON sellos.IdPartida = cpartida.IdPartida
	left join R_CtasContxCtesProvEmp rctas
	ON t_presupuestoNW.IdSelloPresupuestal = rctas.IdSelloPresupuestal
	left join C_Contable ccon
	ON ccon.IdCuentaContable = rctas.IdCuentaContable
	LEFT JOIN C_PartidasPres As CPP ON CPP.IdPartida = sellos.IdPartida
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CPP.IdConcepto
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
	WHERE T_PresupuestoNW.Mes >=@MesIni and T_PresupuestoNW.Mes <=@MesFin  and T_PresupuestoNW.Year =@Ejercicio and rctas.IdTipoCuenta = 55--and cpartida.IdPartida like '1%'
	AND sellos.IdFuenteFinanciamiento = CASE WHEN @IdFF = 0 THEN sellos.IdFuenteFinanciamiento ELSE @IdFF END
	AND sellos.IdPartida >= CASE WHEN @IdPartida = 0 THEN sellos.IdPartida ELSE @IdPartida END
	AND sellos.IdPartida <= CASE WHEN @IdPartidaFin = 0 THEN sellos.IdPartida ELSE @IdPartidaFin END
	AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END
	GROUP BY ccon.NumeroCuenta, cpartida.IdPartida, cpartida.DescripcionPartida, CG.IdCapitulo
	ORDER BY cpartida.IdPartida

select * from @RPT
GO

--Exec SP_RPT_Control_Presupuestal 1,12,2017,0,0,0
