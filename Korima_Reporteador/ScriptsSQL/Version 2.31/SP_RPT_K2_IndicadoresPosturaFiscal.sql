/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_IndicadoresPosturaFiscal]    Script Date: 12/03/2014 17:22:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_IndicadoresPosturaFiscal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_IndicadoresPosturaFiscal]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_IndicadoresPosturaFiscal]    Script Date: 12/03/2014 17:22:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- EXEC SP_RPT_K2_IndicadoresPosturaFiscal 1,9,2021,0
CREATE PROCEDURE [dbo].[SP_RPT_K2_IndicadoresPosturaFiscal]
@MesInicio int, 
@MesFin int,
@Ejercicio int
,@Paraestatal bit

AS
BEGIN
declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)


declare @Titulos as table (Concepto varchar(max),Estimado decimal(18,4), Devengado decimal(18,4),Pagado decimal(18,4), Grupo Int, Orden Decimal(15,2))

Insert into @Titulos Values('',null,null,null,1,1)
Insert into @Titulos Values('I. Ingresos Presupuestarios',null,null,null,1,2)
Insert into @Titulos Values('1. Ingresos del Gobierno de la Entidad Federativa',null,null,null,1,3)
Insert into @Titulos Values('2. Ingresos del Sector Paraestatal',null,null,null,1,4)
Insert into @Titulos Values('',null,null,null,1,5)
Insert into @Titulos Values('II. Egresos Presupuestarios',null,null,null,1,6)
Insert into @Titulos Values('3. Egresos del Gobierno de la Entidad Federativa',null,null,null,1,7)
Insert into @Titulos Values('4. Egresos del Sector Paraestatal',null,null,null,1,8)
Insert into @Titulos Values('',null,null,null,1,9)
Insert into @Titulos Values('III. Balance Presupuestario (Superávit o Déficit) (III=I-II)',null,null,null,1,10)

Insert into @Titulos Values('',null,null,null,2,11)
Insert into @Titulos Values('III. Balance Presupuestario (Superávit o Dáficit)',null,null,null,2,12)
Insert into @Titulos Values('',null,null,null,2,13)
Insert into @Titulos Values('IV. Intereses, Comisiones y Gastos de la Deuda',null,null,null,2,14)
Insert into @Titulos Values('',null,null,null,2,15)
Insert into @Titulos Values('V. Balance Primario ( Superávit o Déficit ) ( V=III+IV )',null,null,null,2,16)
Insert into @Titulos Values('',null,null,null,2,17)

Insert into @Titulos Values('',null,null,null,3,18)
Insert into @Titulos Values('A. Financiamiento',null,null,null,3,19)
Insert into @Titulos Values('',null,null,null,3,20)
Insert into @Titulos Values('B. Amortizacion de la Deuda',null,null,null,3,21)
Insert into @Titulos Values('',null,null,null,3,22)
Insert into @Titulos Values('C. Financiamiento Neto  (C=A-B)',null,null,null,3,23)
Insert into @Titulos Values('',null,null,null,3,24)

Declare @PresFlujo3 as Decimal (18,4) = (select 
SUM(isnull(T_PresupuestoFlujo.Estimado,0))
FROM T_PresupuestoFlujo 
JOIN C_PartidasGastosIngresos
ON T_PresupuestoFlujo.IdPartida= C_PartidasGastosIngresos.IdPartidaGI
JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento
WHERE T_PresupuestoFlujo.Ejercicio=@Ejercicio and (T_PresupuestoFlujo.Mes = 0) and 
len(C_PartidasGastosIngresos.Clave)>4 and substring(C_PartidasGastosIngresos.Clave,6,1) in('1','2','3','4','5','6','8')
and substring(C_FuenteFinanciamiento.Clave,1,2) not in('12','13')
)

Declare @PresFlujo4 as Decimal (18,4) = (select 
SUM(isnull(T_PresupuestoFlujo.Estimado,0))
FROM T_PresupuestoFlujo 
JOIN C_PartidasGastosIngresos
ON T_PresupuestoFlujo.IdPartida= C_PartidasGastosIngresos.IdPartidaGI
WHERE T_PresupuestoFlujo.Ejercicio=@Ejercicio and (T_PresupuestoFlujo.Mes = 0) and 
len(C_PartidasGastosIngresos.Clave)>4 and substring(C_PartidasGastosIngresos.Clave,6,1) in('7','9'))

--Declare @Estimado19 as Decimal (18,4) = (select 
--SUM(isnull(T_PresupuestoFlujo.Estimado,0))
--FROM T_PresupuestoFlujo JOIN C_PartidasGastosIngresos ON T_PresupuestoFlujo.IdPartida= C_PartidasGastosIngresos.IdPartidaGI
--JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento
--WHERE T_PresupuestoFlujo.Ejercicio=2021 and (T_PresupuestoFlujo.Mes = 0) and 
--len(C_PartidasGastosIngresos.Clave)>4 and substring(C_FuenteFinanciamiento.Clave,1,2) in('12','13'))

Declare @PresNw7 as Decimal (18,4) = (select 
sum(isnull(T_PresupuestoNW.Autorizado,0))
FROM T_PresupuestoNW 
JOIN t_sellospresupuestales
ON t_sellospresupuestales.IdSelloPresupuestal=T_PresupuestoNW.IdSelloPresupuestal
Where (T_PresupuestoNW.Mes = 0) and T_PresupuestoNW.Year=@Ejercicio and
SUBSTRING(convert(varchar(max),IdPartida),1,1) in ('1','2','3','5','6','7','8'))

Declare @PresNw8 as Decimal (18,4) = (select 
sum(isnull(T_PresupuestoNW.Autorizado,0))
FROM T_PresupuestoNW 
JOIN t_sellospresupuestales
ON t_sellospresupuestales.IdSelloPresupuestal=T_PresupuestoNW.IdSelloPresupuestal
Where (T_PresupuestoNW.Mes = 0) and T_PresupuestoNW.Year=@Ejercicio and
SUBSTRING(convert(varchar(max),IdPartida),1,1) in ('4'))

Declare @SaldosCont14 as Decimal (18,4) = (select 
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalCargos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes Between 1 and 12) and Year =@Ejercicio and (NumeroCuenta like ('821'+REPLICATE('0',@Estructura1-3)+'-09211%') or NumeroCuenta like ('821'+REPLICATE('0',@Estructura1-3)+'-009211%'))
and (NumeroCuenta like ('821'+REPLICATE('0',@Estructura1-3)+'-09311%') or NumeroCuenta like ('821'+REPLICATE('0',@Estructura1-3)+'-009311%'))
and (NumeroCuenta like ('821'+REPLICATE('0',@Estructura1-3)+'-09411%') or NumeroCuenta like ('821'+REPLICATE('0',@Estructura1-3)+'-009411%'))
and (NumeroCuenta like ('821'+REPLICATE('0',@Estructura1-3)+'-09511%') or NumeroCuenta like ('821'+REPLICATE('0',@Estructura1-3)+'-009511%'))
),0))

Declare @SaldosCont14_Dev as Decimal (18,4) = (select 
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalCargos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes Between 1 and 12) and Year =@Ejercicio and (NumeroCuenta like ('825'+REPLICATE('0',@Estructura1-3)+'-09211%') or NumeroCuenta like ('825'+REPLICATE('0',@Estructura1-3)+'-009211%'))
and (NumeroCuenta like ('825'+REPLICATE('0',@Estructura1-3)+'-09311%') or NumeroCuenta like ('825'+REPLICATE('0',@Estructura1-3)+'-009311%'))
and (NumeroCuenta like ('825'+REPLICATE('0',@Estructura1-3)+'-09411%') or NumeroCuenta like ('825'+REPLICATE('0',@Estructura1-3)+'-009411%'))
and (NumeroCuenta like ('825'+REPLICATE('0',@Estructura1-3)+'-09511%') or NumeroCuenta like ('825'+REPLICATE('0',@Estructura1-3)+'-009511%'))
),0))

Declare @SaldosCont19 as Decimal (18,4) = (select 
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalCargos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes Between 1 and 12) and Year =@Ejercicio and (NumeroCuenta like ('811'+REPLICATE('0',@Estructura1-3)+'-01%') or NumeroCuenta like ('811'+REPLICATE('0',@Estructura1-3)+'-001%'))),0))

Declare @SaldosCont21 as Decimal (18,4) = (select 
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalAbonos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes Between 1 and 12) and Year =@Ejercicio and (NumeroCuenta like ('821'+REPLICATE('0',@Estructura1-3)+'-091%') Or NumeroCuenta like ('821'+REPLICATE('0',@Estructura1-3)+'-91%'))),0))


Declare @Valores as table (Orden decimal(15,2),Estimado decimal(18,4), Devengado decimal(18,4),Pagado decimal(18,4))

insert into @Valores
select 
3,
@PresFlujo3, Sum(isnull(T_PresupuestoFlujo.Devengado,0)),SUM(isnull(T_PresupuestoFlujo.Recaudado,0))
FROM T_PresupuestoFlujo 
JOIN C_PartidasGastosIngresos
ON T_PresupuestoFlujo.IdPartida= C_PartidasGastosIngresos.IdPartidaGI
JOIN C_FuenteFinanciamiento ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento
WHERE T_PresupuestoFlujo.Ejercicio=@Ejercicio and (T_PresupuestoFlujo.Mes between @MesInicio and @MesFin) and 
len(C_PartidasGastosIngresos.Clave)>4 and substring(C_PartidasGastosIngresos.Clave,6,1) in('1','2','3','4','5','6','8') 
AND substring(C_FuenteFinanciamiento.Clave,1,2) not in('12','13')

insert into @Valores
select 
4,
@PresFlujo4, Sum(isnull(T_PresupuestoFlujo.Devengado,0)),SUM(isnull(T_PresupuestoFlujo.Recaudado,0))
FROM T_PresupuestoFlujo 
JOIN C_PartidasGastosIngresos
ON T_PresupuestoFlujo.IdPartida= C_PartidasGastosIngresos.IdPartidaGI
WHERE T_PresupuestoFlujo.Ejercicio=@Ejercicio and (T_PresupuestoFlujo.Mes between @MesInicio and @MesFin) and 
len(C_PartidasGastosIngresos.Clave)>4 and substring(C_PartidasGastosIngresos.Clave,6,1) in('7','9') 

insert into @Valores
select 
7,
@PresNw7, sum(isnull(T_PresupuestoNW.Devengado,0)),SUM(isnull(T_PresupuestoNW.Pagado,0))
FROM T_PresupuestoNW 
JOIN t_sellospresupuestales
ON t_sellospresupuestales.IdSelloPresupuestal=T_PresupuestoNW.IdSelloPresupuestal
Where (T_PresupuestoNW.Mes between @MesInicio and @MesFin) and T_PresupuestoNW.Year=@Ejercicio and
SUBSTRING(convert(varchar(max),IdPartida),1,1) in ('1','2','3','5','6','7','8')

insert into @Valores
select 
8,
@PresNw8, sum(isnull(T_PresupuestoNW.Devengado,0)),SUM(isnull(T_PresupuestoNW.Pagado,0))
FROM T_PresupuestoNW 
JOIN t_sellospresupuestales
ON t_sellospresupuestales.IdSelloPresupuestal=T_PresupuestoNW.IdSelloPresupuestal
Where (T_PresupuestoNW.Mes between @MesInicio and @MesFin) and T_PresupuestoNW.Year=@Ejercicio and
SUBSTRING(convert(varchar(max),IdPartida),1,1) in ('4')

insert into @Valores
select 
14,
@SaldosCont14, 
@SaldosCont14_Dev, 
sum(isnull(T_SaldosInicialesCont.TotalCargos,0)) 
FROM T_SaldosInicialesCont 
JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio and NumeroCuenta in('541'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura,
'542'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura,'543'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '544'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)


insert into @Valores
select 
19,
@SaldosCont19, 
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalCargos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio and (NumeroCuenta like ('814'+REPLICATE('0',@Estructura1-3)+'-01%') or NumeroCuenta like ('814'+REPLICATE('0',@Estructura1-3)+'-001%'))),0), 
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalAbonos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio and (NumeroCuenta like ('815'+REPLICATE('0',@Estructura1-3)+'-01%') or NumeroCuenta like ('815'+REPLICATE('0',@Estructura1-3)+'-001%'))),0)

insert into @Valores
select 
21,
@SaldosCont21, 
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalAbonos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio and (NumeroCuenta like ('825'+REPLICATE('0',@Estructura1-3)+'-091%') Or NumeroCuenta like ('825'+REPLICATE('0',@Estructura1-3)+'-91%'))),0), 
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalCargos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio and (NumeroCuenta like ('827'+REPLICATE('0',@Estructura1-3)+'-091%') Or NumeroCuenta like ('827'+REPLICATE('0',@Estructura1-3)+'-91%'))),0)

--Select * from @Valores
--Select @PresFlujo3
--Select @PresFlujo4

update @titulos set T.Estimado= ISNULL(V.Estimado,0), T.Devengado= ISNULL(V.Devengado,0), T.pagado= ISNULL(V.Pagado,0)  
from @Titulos T JOIN @Valores V on V.Orden=T.Orden 

update @Titulos set  Estimado = (select sum(isnull(Estimado,0)) from @Titulos where Orden in (3,4)), 
Devengado=(select sum(isnull(Devengado,0)) from @Titulos where Orden in (3,4)), 
Pagado=(select sum(isnull(pagado,0)) from @titulos where Orden in (3,4)) 
where Orden =2

update @Titulos set  Estimado = (select SUM(isnull(Estimado,0)) from @Titulos where Orden in (7,8)), 
Devengado=(select sum(isnull(Devengado,0)) from @Titulos where Orden in (7,8)), 
Pagado=(select sum(isnull(pagado,0)) from @titulos where Orden in (7,8)) 
where Orden in (6)


update @Titulos set Estimado=((Select isnull(Estimado,0) from @titulos where Orden =2)-(Select isnull(Estimado,0) from @titulos where Orden =6) ),
Devengado= ((Select isnull(Devengado,0) from @titulos where Orden =2)-(Select isnull(Devengado,0) from @titulos where Orden =6)),
Pagado= ((Select isnull(Pagado,0) from @titulos where Orden =2)-(Select isnull(Pagado,0) from @titulos where Orden =6))
where orden in (10,12)


update @Titulos set Estimado=((Select isnull(Estimado,0) from @titulos where Orden =12)-(Select isnull(Estimado,0) from @titulos where Orden =14) ),
Devengado= ((Select isnull(Devengado,0) from @titulos where Orden =12)-(Select isnull(Devengado,0) from @titulos where Orden =14)),
Pagado= ((Select isnull(Pagado,0) from @titulos where Orden =12)-(Select isnull(Pagado,0) from @titulos where Orden =14))
where orden =16


update @Titulos set Estimado=((Select isnull(Estimado,0) from @titulos where Orden =19)-(Select isnull(Estimado,0) from @titulos where Orden =21) ),
Devengado= ((Select isnull(Devengado,0) from @titulos where Orden =19)-(Select isnull(Devengado,0) from @titulos where Orden =21)),
Pagado= ((Select isnull(Pagado,0) from @titulos where Orden =19)-(Select isnull(Pagado,0) from @titulos where Orden =21))
where orden =23

If @Paraestatal = 1
BEGIN

	UPDATE @Titulos set
	Estimado = (Select isnull(Estimado,0) from @titulos where Orden =3),
	Devengado = (Select isnull(Devengado,0) from @titulos where Orden =3),
	Pagado = (Select isnull(Pagado,0) from @titulos where Orden =3)
	Where Orden = 4

	UPDATE @Titulos set
	Estimado = (Select isnull(Estimado,0) from @titulos where Orden =7),
	Devengado = (Select isnull(Devengado,0) from @titulos where Orden =7),
	Pagado = (Select isnull(Pagado,0) from @titulos where Orden =7)
	Where Orden = 8

	UPDATE @Titulos set
	Estimado = 0,
	Devengado = 0,
	Pagado = 0
	Where Orden = 3

	UPDATE @Titulos set
	Estimado = 0,
	Devengado = 0,
	Pagado = 0
	Where Orden = 7

END

Select * from @Titulos 

END


GO


EXEC SP_FirmasReporte 'Indicadores de Postura Fiscal'
GO
Exec SP_CFG_LogScripts 'SP_RPT_K2_IndicadoresPosturaFiscal','2.31'
GO


--EXEC SP_RPT_K2_IndicadoresPosturaFiscal
--1,2,2015
