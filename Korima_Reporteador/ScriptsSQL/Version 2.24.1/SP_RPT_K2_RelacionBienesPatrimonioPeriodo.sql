
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_RelacionBienesPatrimonioPeriodo]    Script Date: 10/25/2013 17:14:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_RelacionBienesPatrimonioPeriodo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_RelacionBienesPatrimonioPeriodo]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_RelacionBienesPatrimonioPeriodo]    Script Date: 10/25/2013 17:14:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_RelacionBienesPatrimonioPeriodo]
@mesInicio int,
@mesFin int,
@EjercicioInicio int,
@EjercicioFin int,
@General bit,
@Depreciacion bit
 
AS
Declare @tabla1 as table (NumeroEconomico varchar(max), Numero int, Descripcion varchar(max),Valor decimal(18,2), Fin decimal(18,2))
Declare @tabla2 as table (NumeroEconomico varchar(max), Descripcion varchar(max),Valor decimal(18,2))

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

Declare @sum as decimal (18,2)
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
	 convert(varchar(10),@mesfinal), 101) as date); --BR


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
--	Where T_AltaActivos.Importe>0 and T_Activos.FechaUA >=@dateini and T_Activos.FechaUA <=@datefin and T_Activos.Estatus <> 'B'
  Where T_AltaActivos.Importe>0 and T_AltaActivos.FechaAlta >=@dateini and T_AltaActivos.FechaAlta<=@datefin 
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

	
	--Insert into @Resultado
	--Exec SP_RPT_K2_BalanzaAcumulada @mesBal, @mesBal, @EjercicioFin,1,0,0,0,0,0,'','',0,0
	--Update @tabla1 set Fin = (Select SaldoDeudor from @Resultado where CuentaNumero = 1200000000)

IF @Depreciacion = 1
		 begin
			update @tabla1  set Valor= T.Valor-T2.Valor 
			FROM @Tabla1 T JOIN @tabla2 T2 ON T.Numero=T2.NumeroEconomico
			Insert into @Resultado
			Exec SP_RPT_K2_BalanzaAcumulada @mesBal, @mesBal, @EjercicioFin,1,0,0,0,0,0,'','',0,0
			Update @tabla1 set Fin = ISNULL((Select SaldoDeudor from @Resultado where CuentaNumero = 1200000000),0)
		 end
	 ELSE
		 begin
			 update @tabla1  set Valor= T.Valor-0
			 FROM @Tabla1 T JOIN @tabla2 T2 ON T.Numero=T2.NumeroEconomico
			 Set @sum  = (SELECT SUM(Valor) from @tabla1)
			 update @tabla1 set Fin = ISNULL(@sum,0)		 
		 end

			

	Select NumeroEconomico,Descripcion,Valor, Fin from @tabla1 
	Where Numero not in (select D_BajasActivos.NumeroEconomico from D_BajasActivos) 
	order by NumeroEconomico 
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
	Where T_AltaActivos.Importe>0 and T_Activos.Estatus <> 'B'  -- and T_Activos.FechaUA Between @dateini and @datefin


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
	IF @Depreciacion = 1
		 begin
			update @tabla1  set Valor= T.Valor-T2.Valor 
			FROM @Tabla1 T JOIN @tabla2 T2 ON T.Numero=T2.NumeroEconomico
			Insert into @Resultado
			Exec SP_RPT_K2_BalanzaAcumulada @mesBal, @mesBal, @EjercicioFin,1,0,0,0,0,0,'','',0,0
			Update @tabla1 set Fin = ISNULL((Select SaldoDeudor from @Resultado where CuentaNumero = 1200000000),0)
		 end
	 ELSE
		 begin
			 update @tabla1  set Valor= T.Valor-0
			 FROM @Tabla1 T JOIN @tabla2 T2 ON T.Numero=T2.NumeroEconomico
			 Set @sum = (SELECT SUM(Valor) from @tabla1)
			 update @tabla1 set Fin = ISNULL(@sum,0)	 
		 end

	Select NumeroEconomico,Descripcion,Valor, Fin from @tabla1 
	--Where Numero not in (select D_BajasActivos.NumeroEconomico from D_BajasActivos) 
	order by NumeroEconomico 
  End
--Select --distinct
--T_Activos.NumeroEconomico,
--T_Activos.Descripcion,
--isnull(T_Activos.CostoAdquisicion,0)- isnull(d_depreciaciones.costo,0) as Valor
--from T_Activos
--LEFT outer JOIN d_depreciaciones ON T_Activos.NumeroEconomico= d_depreciaciones.NumeroEconomico 
--LEFT outer JOIN T_Depreciaciones ON T_Depreciaciones.IdDepreciacion = D_Depreciaciones.IdDepreciacion
--LEFT outer JOIN T_AltaActivos ON T_AltaActivos.FolioAlta= T_Activos.FolioAlta 
--where T_Depreciaciones.Ano =@Ejercicio 
--and T_Depreciaciones.Mes=(Select MAX(T_Depreciaciones.Mes) from T_Depreciaciones where T_Depreciaciones.Ano=@Ejercicio) 
--and T_AltaActivos.Importe>0

GO

EXEC SP_FirmasReporte 'Relación de Bienes Muebles e Inmuebles'
GO
Exec SP_CFG_LogScripts 'SP_RPT_K2_RelacionBienesPatrimonioPeriodo'
GO
 --EXEC SP_RPT_K2_RelacionBienesPatrimonioPeriodo 1,3,1900,2016,1,0

 