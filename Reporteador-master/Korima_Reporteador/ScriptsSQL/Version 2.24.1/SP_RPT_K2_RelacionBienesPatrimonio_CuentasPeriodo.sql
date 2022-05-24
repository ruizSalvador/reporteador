
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_RelacionBienesPatrimonio_CuentasPeriodo]    Script Date: 10/25/2013 17:14:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_RelacionBienesPatrimonio_CuentasPeriodo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_RelacionBienesPatrimonio_CuentasPeriodo]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_RelacionBienesPatrimonio_CuentasPeriodo]    Script Date: 10/25/2013 17:14:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_RelacionBienesPatrimonio_CuentasPeriodo]
@mesInicio int,
@mesFin int,
@EjercicioInicio int,
@EjercicioFin int,
@General bit,
@Depreciacion bit

AS
Declare @tabla1 as table (NumeroEconomico varchar(max), Numero int, Descripcion varchar(max),Valor decimal(15,2), Fin decimal(15,2))
Declare @tabla2 as table (NumeroEconomico varchar(max), Descripcion varchar(max),Valor decimal(15,2))
Declare @TablaTodos as table (
		   Total decimal (15,2)
		  ,NumeroCuenta varchar (255)
		  ,NombreCuenta varchar (255)
		  ,TotalBienes decimal (15,2)
		  ,Fin decimal (15,2)
		  ,Diferencia decimal (18,2)
		  )
DECLARE @totalBienes DECIMAL(15,2)

Declare @Resultado as table (
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo decimal (18,4), 
AbonosSinFlujo Decimal(18,4),
TotalCargos Decimal(18,4),
TotalAbonos Decimal(18,4),
SaldoDeudor  Decimal(18,4),
SaldoAcreedor  Decimal(18,4),
Afectable int,
Financiero int,
CuentaNumero bigint)

 Declare @sum as decimal(18,2)
 Declare @mesBal as int

	If @General = 1
		begin
			set @mesBal = (SELECT MONTH(GETDATE()))
		end
	Else
		begin
			set @mesBal = @mesFin
		end
      
if @General = 0
  Begin	
	DECLARE @dateini AS DATE;
	DECLARE @datefin AS DATE;
	Declare @mesfinal as  int;

	If @mesFin = 2 --BR
	begin
	   set @mesfinal = 28
	end

	If @mesFin in (4,6,9,11) --BR
	begin
	   set @mesfinal = 30
	end

	If @mesFin in (1,3,5,7,8,10,12) --BR
	begin
	   set @mesfinal = 31
	end
		

	set @dateini = cast(convert(datetime,convert(varchar(10),@EjercicioInicio) + '-' +
	 convert(varchar(10),@mesInicio) + '-' +
	 convert(varchar(10),1), 101) as date);

	 set @datefin = cast(convert(datetime,convert(varchar(10),@EjercicioFin) + '-' +
	 convert(varchar(10),@mesFin) + '-' +
	 convert(varchar(10),@mesfinal), 101) as date);

	insert @tabla1 
	select 
	cast(case
			 When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
			 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
	T_Activos.NumeroEconomico as Numero,
	T_Activos.Descripcion,
	isnull(T_Activos.CostoAdquisicion,0),
	0 as Fin
	from T_Activos
    JOIN T_AltaActivos ON T_AltaActivos.FolioAlta= T_Activos.FolioAlta 
--	where T_AltaActivos.Importe>0 and T_Activos.FechaUA >=@dateini and T_Activos.FechaUA <=@datefin and T_Activos.Estatus <> 'B'
    where T_AltaActivos.Importe>0 and T_AltaActivos.FechaAlta >=@dateini and T_AltaActivos.FechaAlta<=@datefin 
    and T_Activos.NumeroEconomico not in ( 
    Select NumeroEconomico From D_BajasActivos 
    Inner Join T_BajaActivos on D_BajasActivos.FolioBaja=T_BajaActivos.Folio
    where (FechaBaja>=@dateini and FechaBaja<=@datefin))

	insert @tabla2
	select 
	d_depreciaciones.NumeroEconomico,
	'' as descripcion,
	isnull(d_depreciaciones.costo,0)
	from d_depreciaciones
	JOIN T_Depreciaciones ON T_Depreciaciones.IdDepreciacion = D_Depreciaciones.IdDepreciacion
	where T_Depreciaciones.Ano <=@EjercicioFin
	and T_Depreciaciones.IdDepreciacion in (
    Select top 1 T_Depreciaciones.IdDepreciacion from t_Depreciaciones order by IdDepreciacion desc)
	--and T_Depreciaciones.Mes >=@mesInicio and T_Depreciaciones.Mes <=@mesFin

	--update @tabla1  set Valor= T.Valor-T2.Valor 
	--FROM @Tabla1 T JOIN @tabla2 T2 ON T.Numero=T2.NumeroEconomico
	IF @Depreciacion = 1
		 begin
			update @tabla1  set Valor= T.Valor-T2.Valor 
			FROM @Tabla1 T JOIN @tabla2 T2 ON T.Numero=T2.NumeroEconomico
			Insert into @Resultado
			Exec SP_RPT_K2_BalanzaAcumulada @mesBal, @mesBal, @EjercicioFin,1,0,0,0,0,0,'','',0,0
			Update @tabla1 set Fin = (Select SaldoDeudor from @Resultado where CuentaNumero = 1200000000)
		 end
	 ELSE
		 begin
			 update @tabla1  set Valor= T.Valor-0
			 FROM @Tabla1 T JOIN @tabla2 T2 ON T.Numero=T2.NumeroEconomico
			 Set @sum = (SELECT SUM(Valor) from @tabla1)
			 update @tabla1 set Fin = @sum		 
		 end
	--DECLARE @totalBienes DECIMAL(15,2)

	Select @totalBienes = SUM(Valor) from @tabla1 
	Where Numero not in (select D_BajasActivos.NumeroEconomico from D_BajasActivos) 
 
	-- BR comente y sustituí por código de abajo
	--Select SUM(saldos.TotalCargos) As Total, contable.NumeroCuenta, contable.nombreCuenta, isnull(@totalBienes,0) as TotalBienes
	-- From C_Contable contable  
	--	INNER JOIN T_SaldosInicialesCont saldos
	--		ON contable.IdCuentaContable = saldos.IdCuentaContable 
	--    Where  TipoCuenta <> 'X' 
	--    and contable.NumeroCuenta = '12350-00000' or contable.NumeroCuenta = '12360-00000'
	--   and saldos.Year = @Ejercicio and saldos.Mes Between @mesInicio and @mesFin
	--    GROUP BY contable.NumeroCuenta, contable.nombreCuenta



	Insert @TablaTodos 
	Select 0 As Total, contable.NumeroCuenta, contable.nombreCuenta, isnull(@totalBienes,0)as TotalBienes, 0 as Fin, 0 as Diferencia
		From C_Contable contable  
		Where  TipoCuenta <> 'X' 
		and NumeroCuenta = '12350-00000' or NumeroCuenta = '12360-00000' or NumeroCuenta = '123500-000000' or NumeroCuenta = '123600-000000'
		GROUP BY contable.NumeroCuenta, contable.nombreCuenta


	  --Update @TablaTodos set Total = (Select isnull(SUM(saldos.TotalCargos)- SUM(saldos.TotalAbonos),0) From C_Contable contable INNER JOIN T_SaldosInicialesCont saldos ON contable.IdCuentaContable = saldos.IdCuentaContable Where  TipoCuenta <> 'X' and contable.NumeroCuenta = '12350-00000' and saldos.Year = @EjercicioInicio and saldos.Mes Between @mesInicio and @mesFin) where NumeroCuenta= '12350-00000'
	  --Update @TablaTodos set Total = (Select isnull(SUM(saldos.TotalCargos)- SUM(saldos.TotalAbonos),0) From C_Contable contable INNER JOIN T_SaldosInicialesCont saldos ON contable.IdCuentaContable = saldos.IdCuentaContable Where  TipoCuenta <> 'X' and contable.NumeroCuenta = '12360-00000' and saldos.Year = @EjercicioInicio and saldos.Mes Between @mesInicio and @mesFin) where NumeroCuenta= '12360-00000'

	  Update @TablaTodos set Total = (Select isnull(SUM(saldos.TotalCargos)- SUM(saldos.TotalAbonos),0) From C_Contable contable INNER JOIN T_SaldosInicialesCont saldos ON contable.IdCuentaContable = saldos.IdCuentaContable Where  TipoCuenta <> 'X' and contable.NumeroCuenta = '12350-00000' and saldos.Year = @EjercicioFin and saldos.Mes Between @mesInicio and @mesFin) where NumeroCuenta= '12350-00000'
	  Update @TablaTodos set Total = (Select isnull(SUM(saldos.TotalCargos)- SUM(saldos.TotalAbonos),0) From C_Contable contable INNER JOIN T_SaldosInicialesCont saldos ON contable.IdCuentaContable = saldos.IdCuentaContable Where  TipoCuenta <> 'X' and contable.NumeroCuenta = '12360-00000' and saldos.Year = @EjercicioFin and saldos.Mes Between @mesInicio and @mesFin) where NumeroCuenta= '12360-00000'
  	  Update @TablaTodos set Fin = ISNULL((Select top 1 Fin from @tabla1),0)

	 
If @Depreciacion = 1
	 Begin
		Update @TablaTodos set Diferencia = ISNULL(((Select top 1 Fin from @tabla1) - ((Select Total from @TablaTodos where NumeroCuenta= '12350-00000')+(Select Total from @TablaTodos  where NumeroCuenta= '12360-00000'))),0)
	 End
  Else
  Begin 
	Update @TablaTodos set Diferencia = ISNULL((Select top 1 Fin from @tabla1),0)
  End		
		Select *
		from @TablaTodos 

  End
Else
 Begin
	insert @tabla1 
	select 
	cast(case
			 When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
			 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
	T_Activos.NumeroEconomico as Numero,
	T_Activos.Descripcion,
	isnull(T_Activos.CostoAdquisicion,0),
	0 as Fin
	from T_Activos
	JOIN T_AltaActivos ON T_AltaActivos.FolioAlta= T_Activos.FolioAlta 
	Where T_AltaActivos.Importe>0 and T_Activos.Estatus <> 'B' --and T_Activos.FechaUA Between @dateini and @datefin

	insert @tabla2
	select 
	d_depreciaciones.NumeroEconomico,
	''as descripcion,
	isnull(d_depreciaciones.costo,0)
	from d_depreciaciones
	where IdDepreciacion in (
    Select top 1 IdDepreciacion from t_Depreciaciones order by IdDepreciacion desc)

	--where T_Depreciaciones.Ano =@Ejercicio
	--and T_Depreciaciones.Mes Between @mesInicio and @mesFin

	--update @tabla1  set Valor= T.Valor-T2.Valor -- BR comentado temporal
	------------------update @tabla1  set Valor= T.Valor-0
	-------------------FROM @Tabla1 T JOIN @tabla2 T2 ON T.Numero=T2.NumeroEconomico
	IF @Depreciacion = 1
		 begin
			update @tabla1  set Valor= T.Valor-T2.Valor 
			FROM @Tabla1 T JOIN @tabla2 T2 ON T.Numero=T2.NumeroEconomico
			Insert into @Resultado
			Exec SP_RPT_K2_BalanzaAcumulada @mesBal, @mesBal, @EjercicioFin,1,0,0,0,0,0,'','',0,0
			Update @tabla1 set Fin = (Select SaldoDeudor from @Resultado where CuentaNumero = 1200000000)
		 end
	 ELSE
		 begin
			 update @tabla1  set Valor= T.Valor-0
			 FROM @Tabla1 T JOIN @tabla2 T2 ON T.Numero=T2.NumeroEconomico
			 Set @sum = (SELECT SUM(Valor) from @tabla1)
			 update @tabla1 set Fin = @sum		 
		 end

	--DECLARE @totalBienes DECIMAL(15,2)

	Select @totalBienes = SUM(Valor) from @tabla1 
	--Where Numero not in (select D_BajasActivos.NumeroEconomico from D_BajasActivos) 
 
	-- BR comente y sustituí por código de abajo
	--Select SUM(saldos.TotalCargos) As Total, contable.NumeroCuenta, contable.nombreCuenta, isnull(@totalBienes,0) as TotalBienes
	-- From C_Contable contable  
	--	INNER JOIN T_SaldosInicialesCont saldos
	--		ON contable.IdCuentaContable = saldos.IdCuentaContable 
	--    Where  TipoCuenta <> 'X' 
	--    and contable.NumeroCuenta = '12350-00000' or contable.NumeroCuenta = '12360-00000'
	--   and saldos.Year = @Ejercicio and saldos.Mes Between @mesInicio and @mesFin
	--    GROUP BY contable.NumeroCuenta, contable.nombreCuenta


	--Declare @TablaTodos as table (
	--	   Total decimal (15,2)
	--	  ,NumeroCuenta varchar (255)
	--	  ,NombreCuenta varchar (255)
	--	  ,TotalBienes decimal (15,2)
	--	  )
      
	Insert @TablaTodos 
	Select 0 As Total, contable.NumeroCuenta, contable.nombreCuenta, isnull(@totalBienes,0) as TotalBienes, 0 as Fin, 0 as Diferencia
		From C_Contable contable  
		Where  TipoCuenta <> 'X' 
		and NumeroCuenta = '12350-00000' or NumeroCuenta = '12360-00000' or NumeroCuenta = '123500-000000' or NumeroCuenta = '123600-000000'
		GROUP BY contable.NumeroCuenta, contable.nombreCuenta


	  Update @TablaTodos set Total = (Select isnull(SUM(saldos.TotalCargos)- SUM(saldos.TotalAbonos),0) From C_Contable contable INNER JOIN T_SaldosInicialesCont saldos ON contable.IdCuentaContable = saldos.IdCuentaContable Where  TipoCuenta <> 'X' and contable.NumeroCuenta = '12350-00000' ) where NumeroCuenta= '12350-00000'
	  Update @TablaTodos set Total = (Select isnull(SUM(saldos.TotalCargos)- SUM(saldos.TotalAbonos),0) From C_Contable contable INNER JOIN T_SaldosInicialesCont saldos ON contable.IdCuentaContable = saldos.IdCuentaContable Where  TipoCuenta <> 'X' and contable.NumeroCuenta = '12360-00000' ) where NumeroCuenta= '12360-00000'
	  Update @TablaTodos set Fin = ISNULL((Select top 1 Fin from @tabla1),0)
 
 If @Depreciacion = 1
	 Begin
		Update @TablaTodos set Diferencia = ISNULL(((Select top 1 Fin from @tabla1) - ((Select Total from @TablaTodos where NumeroCuenta= '12350-00000')+(Select Total from @TablaTodos  where NumeroCuenta= '12360-00000'))),0)
	 End
  Else
  Begin 
	Update @TablaTodos set Diferencia = ISNULL((Select top 1 Fin from @tabla1),0)
  End

		Select *
		from @TablaTodos 
 End
 GO

 Exec SP_CFG_LogScripts 'SP_RPT_K2_RelacionBienesPatrimonio_CuentasPeriodo'
 GO
  --EXEC SP_RPT_K2_RelacionBienesPatrimonio_CuentasPeriodo 1,1,2016,2016,0,0


