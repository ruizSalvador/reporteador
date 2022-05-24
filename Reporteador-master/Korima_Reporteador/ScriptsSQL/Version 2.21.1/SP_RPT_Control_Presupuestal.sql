/****** Object:  StoredProcedure [dbo].[SP_RPT_Control_Presupuestal]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Control_Presupuestal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Control_Presupuestal]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_Control_Presupuestal]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_Control_Presupuestal]

@MesIni int,
@MesFin int,
@Ejercicio int 

AS
Declare @SumAutorizado1 decimal (15,2)
Declare @SumEjercido1 decimal (15,2)
Declare @SumPorEjercer1 decimal (15,2)
Declare @SumAutorizado2 decimal (15,2)
Declare @SumEjercido2 decimal (15,2)
Declare @SumPorEjercer2 decimal (15,2)
Declare @SumAutorizado3 decimal (15,2)
Declare @SumEjercido3 decimal (15,2)
Declare @SumPorEjercer3 decimal (15,2)
Declare @SumAutorizado4 decimal (15,2)
Declare @SumEjercido4 decimal (15,2)
Declare @SumPorEjercer4 decimal (15,2)
Declare @SumAutorizado5 decimal (15,2)
Declare @SumEjercido5 decimal (15,2)
Declare @SumPorEjercer5 decimal (15,2)
Declare @SumAutorizado6 decimal (15,2)
Declare @SumEjercido6 decimal (15,2)
Declare @SumPorEjercer6 decimal (15,2)
Declare @SumAutorizado7 decimal (15,2)
Declare @SumEjercido7 decimal (15,2)
Declare @SumPorEjercer7 decimal (15,2)
Declare @SumAutorizado8 decimal (15,2)
Declare @SumEjercido8 decimal (15,2)
Declare @SumPorEjercer8 decimal (15,2)
Declare @SumAutorizado9 decimal (15,2)
Declare @SumEjercido9 decimal (15,2)
Declare @SumPorEjercer9 decimal (15,2)
Declare @TotalAutorizado decimal (15,2)
Declare @TotalEjercido decimal (15,2)
Declare @TotalPorEjercer decimal (15,2)


--Tabla de titulos 
Declare @RPT as table(
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
	WHERE T_PresupuestoNW.Mes >=@MesIni and T_PresupuestoNW.Mes <=@MesFin  and T_PresupuestoNW.Year =@Ejercicio and rctas.IdTipoCuenta = 55--and cpartida.IdPartida like '1%'
	GROUP BY ccon.NumeroCuenta, cpartida.IdPartida, cpartida.DescripcionPartida
	ORDER BY cpartida.IdPartida


	select @SumAutorizado1=(select SUM(Autorizado) from @RPT where Partida like '1%')
	select @SumEjercido1=(select SUM(Ejercido) from @RPT where Partida like '1%')
	select @SumPorEjercer1=(select SUM(PorEjercer) from @RPT where Partida like '1%')
	select @SumAutorizado2=(select SUM(Autorizado) from @RPT where Partida like '2%')
	select @SumEjercido2=(select SUM(Ejercido) from @RPT where Partida like '2%')
	select @SumPorEjercer2=(select SUM(PorEjercer) from @RPT where Partida like '2%')
	select @SumAutorizado3=(select SUM(Autorizado) from @RPT where Partida like '3%')
	select @SumEjercido3=(select SUM(Ejercido) from @RPT where Partida like '3%')
	select @SumPorEjercer3=(select SUM(PorEjercer) from @RPT where Partida like '3%')
	select @SumAutorizado4=(select SUM(Autorizado) from @RPT where Partida like '4%')
	select @SumEjercido4=(select SUM(Ejercido) from @RPT where Partida like '4%')
	select @SumPorEjercer4=(select SUM(PorEjercer) from @RPT where Partida like '4%')
	select @SumAutorizado5=(select SUM(Autorizado) from @RPT where Partida like '5%')
	select @SumEjercido5=(select SUM(Ejercido) from @RPT where Partida like '5%')
	select @SumPorEjercer5=(select SUM(PorEjercer) from @RPT where Partida like '5%')
	select @SumAutorizado6=(select SUM(Autorizado) from @RPT where Partida like '6%')
	select @SumEjercido6=(select SUM(Ejercido) from @RPT where Partida like '6%')
	select @SumPorEjercer6=(select SUM(PorEjercer) from @RPT where Partida like '6%')
	select @SumAutorizado7=(select SUM(Autorizado) from @RPT where Partida like '7%')
	select @SumEjercido7=(select SUM(Ejercido) from @RPT where Partida like '7%')
	select @SumPorEjercer7=(select SUM(PorEjercer) from @RPT where Partida like '7%')
	select @SumAutorizado8=(select SUM(Autorizado) from @RPT where Partida like '8%')
	select @SumEjercido8=(select SUM(Ejercido) from @RPT where Partida like '8%')
	select @SumPorEjercer8=(select SUM(PorEjercer) from @RPT where Partida like '8%')
	select @SumAutorizado9=(select SUM(Autorizado) from @RPT where Partida like '9%')
	select @SumEjercido9=(select SUM(Ejercido) from @RPT where Partida like '9%')
	select @SumPorEjercer9=(select SUM(PorEjercer) from @RPT where Partida like '9%')
	select @TotalAutorizado=(select SUM(Autorizado) from @RPT)
	select @TotalEjercido=(select SUM(Ejercido) from @RPT)
	select @TotalPorEjercer=(select SUM(PorEjercer) from @RPT)


INSERT INTO @RPTFinal
SELECT ccon.NumeroCuenta as Cuenta, 
	   cpartida.IdPartida as Partida,
	   cpartida.DescripcionPartida as Concepto,
	sum(isnull(Autorizado,0)) as Autorizado, 
	sum(isnull(Ejercido,0)) as Ejercido, 
	isnull((sum(Modificado) - sum(Comprometido)),0) as PorEjercer,
	0 as TotalAutorizado,
	0 as TotalEjercido,
	0 as TotalPorEjercer,
	0 as Negritas,
	1 as orden
	FROM t_presupuestoNW 
	inner join T_SellosPresupuestales as sellos
	ON t_presupuestoNW.IdSelloPresupuestal = sellos.IdSelloPresupuestal
	left join C_PartidasPres cpartida
	ON sellos.IdPartida = cpartida.IdPartida
	left join R_CtasContxCtesProvEmp rctas
	ON t_presupuestoNW.IdSelloPresupuestal = rctas.IdSelloPresupuestal
	left join C_Contable ccon
	ON ccon.IdCuentaContable = rctas.IdCuentaContable
	WHERE T_PresupuestoNW.Mes >=@MesIni and T_PresupuestoNW.Mes <=@MesFin  and T_PresupuestoNW.Year =@Ejercicio and rctas.IdTipoCuenta = 55 and cpartida.IdPartida like '1%'
	GROUP BY ccon.NumeroCuenta, cpartida.IdPartida, cpartida.DescripcionPartida
	UNION all
	
		Select '' AS Cuenta,
				null AS Partida,
				Case When  @SumAutorizado1 is not null and @SumEjercido1 is not null and  @SumPorEjercer1 is not null then
				'TOTAL CAPITULO 1000'
				else null 
				end AS Concepto,
				@SumAutorizado1 AS Autorizado,
				@SumEjercido1 AS Ejercido,
				@SumPorEjercer1 AS PorEjercer,
				0 as TotalAutorizado,
				0 as TotalEjercido,
				0 as TotalPorEjercer,
				1 as Negritas,
				2 as orden

	UNION all
	SELECT ccon.NumeroCuenta as Cuenta, 
	   cpartida.IdPartida as Partida,
	   cpartida.DescripcionPartida as Concepto,
	sum(isnull(Autorizado,0)) as Autorizado, 
	sum(isnull(Ejercido,0)) as Ejercido, 
	isnull((sum(Modificado) - sum(Comprometido)),0) as PorEjercer,
	0 as TotalAutorizado,
	0 as TotalEjercido,
	0 as TotalPorEjercer,
	0 as Negritas,
	3 as orden
	FROM t_presupuestoNW 
	inner join T_SellosPresupuestales as sellos
	ON t_presupuestoNW.IdSelloPresupuestal = sellos.IdSelloPresupuestal
	left join C_PartidasPres cpartida
	ON sellos.IdPartida = cpartida.IdPartida
	left join R_CtasContxCtesProvEmp rctas
	ON t_presupuestoNW.IdSelloPresupuestal = rctas.IdSelloPresupuestal
	left join C_Contable ccon
	ON ccon.IdCuentaContable = rctas.IdCuentaContable
	WHERE T_PresupuestoNW.Mes >=@MesIni and T_PresupuestoNW.Mes <=@MesFin  and T_PresupuestoNW.Year =@Ejercicio and rctas.IdTipoCuenta = 55 and cpartida.IdPartida like '2%'
	GROUP BY ccon.NumeroCuenta, cpartida.IdPartida, cpartida.DescripcionPartida 

	UNION all
	Select '' AS Cuenta,
			null AS Partida,
			Case When  @SumAutorizado2 is not null and @SumEjercido2 is not null  and  @SumPorEjercer2 is not null  then
				'TOTAL CAPITULO 2000'
				else null 
				end AS Concepto,
			@SumAutorizado2 AS Autorizado,
			@SumEjercido2 AS Ejercido,
			@SumPorEjercer2 AS PorEjercer,
			0 as TotalAutorizado,
			0 as TotalEjercido,
			0 as TotalPorEjercer,
			1 as Negritas,
			4 as orden

	UNION all
		SELECT ccon.NumeroCuenta as Cuenta, 
	   cpartida.IdPartida as Partida,
	   cpartida.DescripcionPartida as Concepto,
	sum(isnull(Autorizado,0)) as Autorizado, 
	sum(isnull(Ejercido,0)) as Ejercido, 
	isnull((sum(Modificado) - sum(Comprometido)),0) as PorEjercer,
	0 as TotalAutorizado,
	0 as TotalEjercido,
	0 as TotalPorEjercer,
	0 as Negritas,
	5 as orden
	FROM t_presupuestoNW 
	inner join T_SellosPresupuestales as sellos
	ON t_presupuestoNW.IdSelloPresupuestal = sellos.IdSelloPresupuestal
	left join C_PartidasPres cpartida
	ON sellos.IdPartida = cpartida.IdPartida
	left join R_CtasContxCtesProvEmp rctas
	ON t_presupuestoNW.IdSelloPresupuestal = rctas.IdSelloPresupuestal
	left join C_Contable ccon
	ON ccon.IdCuentaContable = rctas.IdCuentaContable
	WHERE T_PresupuestoNW.Mes >=@MesIni and T_PresupuestoNW.Mes <=@MesFin  and T_PresupuestoNW.Year =@Ejercicio and rctas.IdTipoCuenta = 55 and cpartida.IdPartida like '3%'
	GROUP BY ccon.NumeroCuenta, cpartida.IdPartida, cpartida.DescripcionPartida

	UNION all

	Select '' AS Cuenta,
			null AS Partida,
			Case When  @SumAutorizado3 is not null  and @SumEjercido3 is not null  and  @SumPorEjercer3 is not null  then
				'TOTAL CAPITULO 3000'
				else null 
				end AS Concepto,
			@SumAutorizado3 AS Autorizado,
			@SumEjercido3 AS Ejercido,
			@SumPorEjercer3 AS PorEjercer,
			0 as TotalAutorizado,
			0 as TotalEjercido,
			0 as TotalPorEjercer,
			1 as Negritas,
			6 as orden

	UNION all

	SELECT ccon.NumeroCuenta as Cuenta, 
	   cpartida.IdPartida as Partida,
	   cpartida.DescripcionPartida as Concepto,
	sum(isnull(Autorizado,0)) as Autorizado, 
	sum(isnull(Ejercido,0)) as Ejercido, 
	isnull((sum(Modificado) - sum(Comprometido)),0) as PorEjercer,
	0 as TotalAutorizado,
	0 as TotalEjercido,
	0 as TotalPorEjercer,
	0 as Negritas,
	7 as orden
	FROM t_presupuestoNW 
	inner join T_SellosPresupuestales as sellos
	ON t_presupuestoNW.IdSelloPresupuestal = sellos.IdSelloPresupuestal
	left join C_PartidasPres cpartida
	ON sellos.IdPartida = cpartida.IdPartida
	left join R_CtasContxCtesProvEmp rctas
	ON t_presupuestoNW.IdSelloPresupuestal = rctas.IdSelloPresupuestal
	left join C_Contable ccon
	ON ccon.IdCuentaContable = rctas.IdCuentaContable
	WHERE T_PresupuestoNW.Mes >=@MesIni and T_PresupuestoNW.Mes <=@MesFin  and T_PresupuestoNW.Year =@Ejercicio and rctas.IdTipoCuenta = 55 and cpartida.IdPartida like '4%'
	GROUP BY ccon.NumeroCuenta, cpartida.IdPartida, cpartida.DescripcionPartida

	UNION all

	Select '' AS Cuenta,
			null AS Partida,
			Case When  @SumAutorizado4 is not null  and @SumEjercido4 is not null  and  @SumPorEjercer4 is not null  then
				'TOTAL CAPITULO 4000'
				else null 
				end AS Concepto,
			@SumAutorizado4 AS Autorizado,
			@SumEjercido4 AS Ejercido,
			@SumPorEjercer4 AS PorEjercer,
			0 as TotalAutorizado,
			0 as TotalEjercido,
			0 as TotalPorEjercer,
			1 as Negritas,
			8 as orden

	UNION all

	SELECT ccon.NumeroCuenta as Cuenta, 
	   cpartida.IdPartida as Partida,
	   cpartida.DescripcionPartida as Concepto,
	sum(isnull(Autorizado,0)) as Autorizado, 
	sum(isnull(Ejercido,0)) as Ejercido, 
	isnull((sum(Modificado) - sum(Comprometido)),0) as PorEjercer,
	0 as TotalAutorizado,
	0 as TotalEjercido,
	0 as TotalPorEjercer,
	0 as Negritas,
	9 as orden
	FROM t_presupuestoNW 
	inner join T_SellosPresupuestales as sellos
	ON t_presupuestoNW.IdSelloPresupuestal = sellos.IdSelloPresupuestal
	left join C_PartidasPres cpartida
	ON sellos.IdPartida = cpartida.IdPartida
	left join R_CtasContxCtesProvEmp rctas
	ON t_presupuestoNW.IdSelloPresupuestal = rctas.IdSelloPresupuestal
	left join C_Contable ccon
	ON ccon.IdCuentaContable = rctas.IdCuentaContable
	WHERE T_PresupuestoNW.Mes >=@MesIni and T_PresupuestoNW.Mes <=@MesFin  and T_PresupuestoNW.Year =@Ejercicio and rctas.IdTipoCuenta = 55 and cpartida.IdPartida like '5%'
	GROUP BY ccon.NumeroCuenta, cpartida.IdPartida, cpartida.DescripcionPartida

	UNION all

	Select '' AS Cuenta,
			null AS Partida,
			Case When  @SumAutorizado5 is not null  and @SumEjercido5 is not null  and  @SumPorEjercer5 is not null  then
				'TOTAL CAPITULO 5000'
				else null 
				end AS Concepto,
			@SumAutorizado5 AS Autorizado,
			@SumEjercido5 AS Ejercido,
			@SumPorEjercer5 AS PorEjercer,
			0 as TotalAutorizado,
			0 as TotalEjercido,
			0 as TotalPorEjercer,
			1 as Negritas,
			10 as orden

	UNION all

	SELECT ccon.NumeroCuenta as Cuenta, 
	   cpartida.IdPartida as Partida,
	   cpartida.DescripcionPartida as Concepto,
	sum(isnull(Autorizado,0)) as Autorizado, 
	sum(isnull(Ejercido,0)) as Ejercido, 
	isnull((sum(Modificado) - sum(Comprometido)),0) as PorEjercer,
	0 as TotalAutorizado,
	0 as TotalEjercido,
	0 as TotalPorEjercer,
	0 as Negritas,
	11 as orden
	FROM t_presupuestoNW 
	inner join T_SellosPresupuestales as sellos
	ON t_presupuestoNW.IdSelloPresupuestal = sellos.IdSelloPresupuestal
	left join C_PartidasPres cpartida
	ON sellos.IdPartida = cpartida.IdPartida
	left join R_CtasContxCtesProvEmp rctas
	ON t_presupuestoNW.IdSelloPresupuestal = rctas.IdSelloPresupuestal
	left join C_Contable ccon
	ON ccon.IdCuentaContable = rctas.IdCuentaContable
	WHERE T_PresupuestoNW.Mes >=@MesIni and T_PresupuestoNW.Mes <=@MesFin  and T_PresupuestoNW.Year =@Ejercicio and rctas.IdTipoCuenta = 55 and cpartida.IdPartida like '6%'
	GROUP BY ccon.NumeroCuenta, cpartida.IdPartida, cpartida.DescripcionPartida 

	UNION all
	 
	 Select '' AS Cuenta,
			null AS Partida,
			Case When  @SumAutorizado6 is not null  and @SumEjercido6 is not null  and  @SumPorEjercer6 is not null  then
				'TOTAL CAPITULO 6000'
				else null 
				end AS Concepto,
			@SumAutorizado6 AS Autorizado,
			@SumEjercido6 AS Ejercido,
			@SumPorEjercer6 AS PorEjercer,
			0 as TotalAutorizado,
			0 as TotalEjercido,
			0 as TotalPorEjercer,
			1 as Negritas,
			12 as orden

	UNION all

	SELECT ccon.NumeroCuenta as Cuenta, 
	   cpartida.IdPartida as Partida,
	   cpartida.DescripcionPartida as Concepto,
	sum(isnull(Autorizado,0)) as Autorizado, 
	sum(isnull(Ejercido,0)) as Ejercido, 
	isnull((sum(Modificado) - sum(Comprometido)),0) as PorEjercer,
	0 as TotalAutorizado,
	0 as TotalEjercido,
	0 as TotalPorEjercer,
	0 as Negritas,
	13 as orden
	FROM t_presupuestoNW 
	inner join T_SellosPresupuestales as sellos
	ON t_presupuestoNW.IdSelloPresupuestal = sellos.IdSelloPresupuestal
	left join C_PartidasPres cpartida
	ON sellos.IdPartida = cpartida.IdPartida
	left join R_CtasContxCtesProvEmp rctas
	ON t_presupuestoNW.IdSelloPresupuestal = rctas.IdSelloPresupuestal
	left join C_Contable ccon
	ON ccon.IdCuentaContable = rctas.IdCuentaContable
	WHERE T_PresupuestoNW.Mes >=@MesIni and T_PresupuestoNW.Mes <=@MesFin  and T_PresupuestoNW.Year =@Ejercicio and rctas.IdTipoCuenta = 55 and cpartida.IdPartida like '7%'
	GROUP BY ccon.NumeroCuenta, cpartida.IdPartida, cpartida.DescripcionPartida 

	UNION all

	Select '' AS Cuenta,
			null AS Partida,
			Case When  @SumAutorizado7 is not null  and @SumEjercido7 is not null  and  @SumPorEjercer7 is not null  then
				'TOTAL CAPITULO 7000'
				else null 
				end AS Concepto,
			@SumAutorizado7 AS Autorizado,
			@SumEjercido7 AS Ejercido,
			@SumPorEjercer7 AS PorEjercer,
			0 as TotalAutorizado,
			0 as TotalEjercido,
			0 as TotalPorEjercer,
			1 as Negritas,
			14 as orden

	UNION all

	SELECT ccon.NumeroCuenta as Cuenta, 
	   cpartida.IdPartida as Partida,
	   cpartida.DescripcionPartida as Concepto,
	sum(isnull(Autorizado,0)) as Autorizado, 
	sum(isnull(Ejercido,0)) as Ejercido, 
	isnull((sum(Modificado) - sum(Comprometido)),0) as PorEjercer,
	0 as TotalAutorizado,
	0 as TotalEjercido,
	0 as TotalPorEjercer,
	0 as Negritas,
	15 as orden
	FROM t_presupuestoNW 
	inner join T_SellosPresupuestales as sellos
	ON t_presupuestoNW.IdSelloPresupuestal = sellos.IdSelloPresupuestal
	left join C_PartidasPres cpartida
	ON sellos.IdPartida = cpartida.IdPartida
	left join R_CtasContxCtesProvEmp rctas
	ON t_presupuestoNW.IdSelloPresupuestal = rctas.IdSelloPresupuestal
	left join C_Contable ccon
	ON ccon.IdCuentaContable = rctas.IdCuentaContable
	WHERE T_PresupuestoNW.Mes >=@MesIni and T_PresupuestoNW.Mes <=@MesFin  and T_PresupuestoNW.Year =@Ejercicio and rctas.IdTipoCuenta = 55 and cpartida.IdPartida like '8%'
	GROUP BY ccon.NumeroCuenta, cpartida.IdPartida, cpartida.DescripcionPartida 

	UNION all

	Select '' AS Cuenta,
			null AS Partida,
			Case When  @SumAutorizado8 is not null  and @SumEjercido8 is not null  and  @SumPorEjercer8 is not null  then
				'TOTAL CAPITULO 8000'
				else null 
				end AS Concepto,
			@SumAutorizado8 AS Autorizado,
			@SumEjercido8 AS Ejercido,
			@SumPorEjercer8 AS PorEjercer,
			0 as TotalAutorizado,
			0 as TotalEjercido,
			0 as TotalPorEjercer,
			1 as Negritas,
			16 as orden

	UNION all

	SELECT ccon.NumeroCuenta as Cuenta, 
	   cpartida.IdPartida as Partida,
	   cpartida.DescripcionPartida as Concepto,
	sum(isnull(Autorizado,0)) as Autorizado, 
	sum(isnull(Ejercido,0)) as Ejercido, 
	isnull((sum(Modificado) - sum(Comprometido)),0) as PorEjercer,
	0 as TotalAutorizado,
	0 as TotalEjercido,
	0 as TotalPorEjercer,
	0 as Negritas,
	17 as orden
	FROM t_presupuestoNW 
	inner join T_SellosPresupuestales as sellos
	ON t_presupuestoNW.IdSelloPresupuestal = sellos.IdSelloPresupuestal
	left join C_PartidasPres cpartida
	ON sellos.IdPartida = cpartida.IdPartida
	left join R_CtasContxCtesProvEmp rctas
	ON t_presupuestoNW.IdSelloPresupuestal = rctas.IdSelloPresupuestal
	left join C_Contable ccon
	ON ccon.IdCuentaContable = rctas.IdCuentaContable
	WHERE T_PresupuestoNW.Mes >=@MesIni and T_PresupuestoNW.Mes <=@MesFin  and T_PresupuestoNW.Year =@Ejercicio and rctas.IdTipoCuenta = 55 and cpartida.IdPartida like '9%'
	GROUP BY ccon.NumeroCuenta, cpartida.IdPartida, cpartida.DescripcionPartida 

	UNION all

	Select '' AS Cuenta,
			null AS Partida,
			Case When  @SumAutorizado9 is not null  and @SumEjercido9 is not null  and  @SumPorEjercer9 is not null  then
				'TOTAL CAPITULO 9000'
				else null 
				end AS Concepto,
			@SumAutorizado9 AS Autorizado,
			@SumEjercido9 AS Ejercido,
			@SumPorEjercer9 AS PorEjercer,
			0 as TotalAutorizado,
			0 as TotalEjercido,
			0 as TotalPorEjercer,
			1 as Negritas,
			18 as orden

	ORDER BY orden
	
	update @RPTFinal set TotalAutorizado=@TotalAutorizado
	update @RPTFinal set TotalEjercido=@TotalEjercido
	update @RPTFinal set TotalPorEjercer=@TotalPorEjercer

select * from @RPTFinal
GO

--exec SP_RPT_Control_Presupuestal 1,12,2015
