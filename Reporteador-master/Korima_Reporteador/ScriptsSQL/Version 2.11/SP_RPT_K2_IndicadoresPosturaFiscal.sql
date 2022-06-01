/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_IndicadoresPosturaFiscal]    Script Date: 12/03/2014 17:22:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_IndicadoresPosturaFiscal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_IndicadoresPosturaFiscal]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_IndicadoresPosturaFiscal]    Script Date: 12/03/2014 17:22:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_IndicadoresPosturaFiscal]
@MesInicio int, @MesFin int,@Ejercicio int
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
Insert into @Titulos Values('I. Ingresos Presupuestarios ( I=1+2 )',null,null,null,1,2)
Insert into @Titulos Values('1. Ingresos del Gobierno de la Entidad Federativa¹',null,null,null,1,3)
Insert into @Titulos Values('2. Ingresos del Sector Paraestatal¹',null,null,null,1,4)
Insert into @Titulos Values('',null,null,null,1,5)
Insert into @Titulos Values('II. Egresos Presupuestarios ( II=3+4 )',null,null,null,1,6)
Insert into @Titulos Values('3. Egresos del Gobierno de la Entidad Federativa²',null,null,null,1,7)
Insert into @Titulos Values('4. Egresos del Sector Paraestatal²',null,null,null,1,8)
Insert into @Titulos Values('',null,null,null,1,9)
Insert into @Titulos Values('III. Balance Presupuestario (Superavit o Deficit) (III=I-II)',null,null,null,1,10)

Insert into @Titulos Values('',null,null,null,2,11)
Insert into @Titulos Values('III. Balance Presupuestario (Superavit o Deficit) (III=I-II)',null,null,null,2,12)
Insert into @Titulos Values('',null,null,null,2,13)
Insert into @Titulos Values('IV. Intereses, Comisiones y Gastos de la Deuda',null,null,null,2,14)
Insert into @Titulos Values('',null,null,null,2,15)
Insert into @Titulos Values('     V. Balance Primario ( Superavit o Deficit ) ( V=III-IV )',null,null,null,2,16)
Insert into @Titulos Values('',null,null,null,2,17)

Insert into @Titulos Values('',null,null,null,3,18)
Insert into @Titulos Values('A. Financiamiento',null,null,null,3,19)
Insert into @Titulos Values('',null,null,null,3,20)
Insert into @Titulos Values('B. Amortizacion de la Deuda',null,null,null,3,21)
Insert into @Titulos Values('',null,null,null,3,22)
Insert into @Titulos Values('     C. Endeudamiento o Desendeudamiento (C=A-B)',null,null,null,3,23)
Insert into @Titulos Values('',null,null,null,3,24)


Declare @Valores as table (Orden decimal(15,2),Estimado decimal(18,4), Devengado decimal(18,4),Pagado decimal(18,4))

insert into @Valores
select 
3,
SUM(isnull(T_PresupuestoFlujo.Estimado,0)), Sum(isnull(T_PresupuestoFlujo.Devengado,0)),SUM(isnull(T_PresupuestoFlujo.Recaudado,0))
FROM T_PresupuestoFlujo 
JOIN C_PartidasGastosIngresos
ON T_PresupuestoFlujo.IdPartida= C_PartidasGastosIngresos.IdPartidaGI
WHERE T_PresupuestoFlujo.Ejercicio=@Ejercicio and (T_PresupuestoFlujo.Mes between @MesInicio and @MesFin) and 
len(C_PartidasGastosIngresos.Clave)>4 and substring(C_PartidasGastosIngresos.Clave,6,1) in('1','2','3','4','5','6','8') 

insert into @Valores
select 
4,
SUM(isnull(T_PresupuestoFlujo.Estimado,0)), Sum(isnull(T_PresupuestoFlujo.Devengado,0)),SUM(isnull(T_PresupuestoFlujo.Recaudado,0))
FROM T_PresupuestoFlujo 
JOIN C_PartidasGastosIngresos
ON T_PresupuestoFlujo.IdPartida= C_PartidasGastosIngresos.IdPartidaGI
WHERE T_PresupuestoFlujo.Ejercicio=@Ejercicio and (T_PresupuestoFlujo.Mes between @MesInicio and @MesFin) and 
len(C_PartidasGastosIngresos.Clave)>4 and substring(C_PartidasGastosIngresos.Clave,6,1) in('7','9') 

insert into @Valores
select 
7,
sum(isnull(T_PresupuestoNW.Autorizado,0)), sum(isnull(T_PresupuestoNW.Devengado,0)),SUM(isnull(T_PresupuestoNW.Pagado,0))
FROM T_PresupuestoNW 
JOIN t_sellospresupuestales
ON t_sellospresupuestales.IdSelloPresupuestal=T_PresupuestoNW.IdSelloPresupuestal
Where (T_PresupuestoNW.Mes between @MesInicio and @MesFin) and T_PresupuestoNW.Year=@Ejercicio and
SUBSTRING(convert(varchar(max),IdPartida),1,1) in ('1','2','3','5','6','7','8','9')

insert into @Valores
select 
8,
sum(isnull(T_PresupuestoNW.Autorizado,0)), sum(isnull(T_PresupuestoNW.Devengado,0)),SUM(isnull(T_PresupuestoNW.Pagado,0))
FROM T_PresupuestoNW 
JOIN t_sellospresupuestales
ON t_sellospresupuestales.IdSelloPresupuestal=T_PresupuestoNW.IdSelloPresupuestal
Where (T_PresupuestoNW.Mes between @MesInicio and @MesFin) and T_PresupuestoNW.Year=@Ejercicio and
SUBSTRING(convert(varchar(max),IdPartida),1,1) in ('4')

insert into @Valores
select 
14,
sum(isnull(T_SaldosInicialesCont.TotalAbonos,0)), 
sum(isnull(T_SaldosInicialesCont.TotalAbonos,0)), 
sum(isnull(T_SaldosInicialesCont.TotalCargos,0)) 
FROM T_SaldosInicialesCont 
JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio and NumeroCuenta in('541'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura,
'542'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura,'543'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)


insert into @Valores
select 
19,
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalCargos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio and (NumeroCuenta like ('811'+REPLICATE('0',@Estructura1-3)+'-01%') or NumeroCuenta like ('811'+REPLICATE('0',@Estructura1-3)+'-001%'))),0), 
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalCargos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio and (NumeroCuenta like ('814'+REPLICATE('0',@Estructura1-3)+'-01%') or NumeroCuenta like ('814'+REPLICATE('0',@Estructura1-3)+'-001%'))),0), 
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalAbonos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio and (NumeroCuenta like ('815'+REPLICATE('0',@Estructura1-3)+'-01%') or NumeroCuenta like ('815'+REPLICATE('0',@Estructura1-3)+'-001%'))),0)

insert into @Valores
select 
21,
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalAbonos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio and (NumeroCuenta like ('821'+REPLICATE('0',@Estructura1-3)+'-091%') Or NumeroCuenta like ('821'+REPLICATE('0',@Estructura1-3)+'-91%'))),0), 
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalAbonos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio and (NumeroCuenta like ('825'+REPLICATE('0',@Estructura1-3)+'-091%') Or NumeroCuenta like ('825'+REPLICATE('0',@Estructura1-3)+'-91%'))),0), 
isnull((Select sum(isnull(T_SaldosInicialesCont.TotalCargos,0)) From T_SaldosInicialesCont JOIN c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio and (NumeroCuenta like ('827'+REPLICATE('0',@Estructura1-3)+'-091%') Or NumeroCuenta like ('827'+REPLICATE('0',@Estructura1-3)+'-91%'))),0)
update @titulos set T.Estimado=V.Estimado, T.Devengado=V.Devengado,T.pagado=V.Pagado  
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

Select * from @Titulos 

END


GO


EXEC SP_FirmasReporte 'Indicadores de Postura Fiscal'
GO



--EXEC SP_RPT_K2_IndicadoresPosturaFiscal
--1,2,2015
