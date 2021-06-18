/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ConciliacionIngresos]    Script Date: 12/01/2014 13:32:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_ConciliacionIngresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_ConciliacionIngresos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ConciliacionIngresos]    Script Date: 12/01/2014 13:32:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_ConciliacionIngresos]
@MesInicio int,
@MesFin int,
@Ejercicio int
AS
BEGIN
declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

Declare @titulos as table(Numero varchar(max), Nombre varchar(max), Abonos decimal(18,4),Negritas bit, Tab bit,Orden decimal(15,2),Suma decimal(18,4))
insert into @titulos values ('814'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '1. Ingresos Presupuestarios',null,1,0,1,Null)
insert into @titulos values ('', '',null,0,0,1.1,Null)
insert into @titulos values ('', '2. Más ingresos contables no presupuestarios',null,1,0,2,Null)
insert into @titulos values ('432'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Incremento por variacion de inventarios',null,0,1,3,Null)
insert into @titulos values ('433'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Disminucion del exceso de estimaciones por perdida o deterioro u obsolescencia',null,0,1,4,Null)
insert into @titulos values ('434'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Disminucion del exceso de provisiones',null,0,1,5,Null)
insert into @titulos values ('439'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Otros ingresos y beneficios varios',null,0,1,6,Null)
insert into @titulos values ('4399'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 'Otros ingresos contables no presupuestarios',null,0,0,7,Null)
insert into @titulos values ('', '',null,0,0,7.1,Null)
insert into @titulos values ('', '3. Menos ingresos presupuestarios no contables',null,1,0,8,Null)
insert into @titulos values ('415'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Productos de capital',null,0,1,9,Null)
insert into @titulos values ('41601'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura, 'Aprovechamientos Capital',null,0,1,10,Null)
insert into @titulos values ('416'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Ingresos derivados de financiamientos',null,0,1,11,Null)
insert into @titulos values ('419'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Otros Ingresos presupuestarios no contables',null,0,0,12,Null)
insert into @titulos values ('', '',null,0,0,12.1,Null)
insert into @titulos values ('', '4. Ingresos Contables ( 4= 1 + 2 - 3)',null,1,0,13,Null)

declare @valores as table (Cuenta varchar(max),Mes int, ejercicio int, TotalAbonos decimal(18,4))
insert into @valores 
select c_contable.NumeroCuenta,0,--T_SaldosInicialesCont.Mes,
 0,--T_SaldosInicialesCont.Year,
 isnull(SUM(T_SaldosInicialesCont.TotalAbonos),0) 
 from T_SaldosInicialesCont 
join c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
 where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio
 Group by c_contable.NumeroCuenta

update @titulos set t.Abonos = isnull(v.TotalAbonos,0) from @titulos t  join @valores v on v.Cuenta=t.numero

Update @titulos set suma = isnull(Abonos,0) where Orden=1
update @titulos set Abonos=null where Orden=1
Update @titulos set Suma=(select SUM(isnull(abonos,0)) from @titulos where substring(numero,1,4) in ('4320','4330','4340','4390','4399')) where orden=2
Update @titulos set Suma=(select SUM(isnull(abonos,0)) from @titulos where substring(numero,1,5) in ('41500','41601','41600','49900')) where orden=8
Update @titulos set Suma=(select SUM(isnull(Suma,0)) from @titulos where orden in (1,2))- 
(select SUM(isnull(Suma,0)) from @titulos where orden in (8)) where orden=13
 
Update @titulos set nombre='     '+nombre from @titulos where Tab=1

select * from @titulos 

END

GO


EXEC SP_FirmasReporte 'Conciliacion entre los Ingresos Presupuestarios y Contables'
GO

