/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ConciliacionEgresos]    Script Date: 12/01/2014 13:57:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_ConciliacionEgresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_ConciliacionEgresos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ConciliacionEgresos]    Script Date: 12/01/2014 13:57:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_ConciliacionEgresos]
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

Declare @titulos as table(Numero varchar(max), Nombre varchar(max), Cargos decimal(18,4),Negritas bit, Tab bit,Orden decimal(15,2), Suma decimal (18,4))
insert into @titulos values ('825'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '1. Total de egresos (presupuestarios)',null,1,0,1,null)
insert into @titulos values ('', '',null,0,0,1.1,null)
insert into @titulos values ('', '2. Menos egresos presupuestarios no contables',null,1,0,2,null)
insert into @titulos values ('1241'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 'Mobiliario y equipo de administracion',null,0,1,3,null)
insert into @titulos values ('1242'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 'Mobiliario y equipo educacional y recreativo',null,0,1,4,null)
insert into @titulos values ('1243'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 'Equipo e instrumental médico y de laboratorio',null,0,1,5,null)
insert into @titulos values ('1244'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 'Vehiculos y equipos de transporte',null,0,1,6,null)
insert into @titulos values ('1245'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 'Equipo de Defensa y seguridad',null,0,1,7,null)
insert into @titulos values ('1246'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 'Maquinaria, otros equipo y herramientas',null,0,1,8,null)
insert into @titulos values ('1248'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 'Activos biológicos',null,0,1,9,null)
insert into @titulos values ('123'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Bienes inmuebles',null,0,1,10,null)
insert into @titulos values ('125'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Activos intangibles',null,0,1,11,null)
insert into @titulos values ('1235'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 'Obra pública en bienes propios',null,0,1,12,null)
insert into @titulos values ('1214'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 'Acciones y participaciones de capital',null,0,1,13,null)
insert into @titulos values ('1212'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 'Compra de titulos y valores',null,0,1,14,null)
insert into @titulos values ('1213'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 'Inversiones en fideicomisos, mandatos y otros análogos',null,0,1,15,null)
insert into @titulos values ('552'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Provisiones para contingencias y otras erogaciones especiales',null,0,1,16,null)
insert into @titulos values ('213'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Amortización de la deuda publica',null,0,1,17,null)
insert into @titulos values ('93'+REPLICATE('0',@Estructura1-2)+'-'+@CerosEstructura, 'Adeudos de ejercicios fiscales anteriores (ADEFAS)',null,0,1,18,null)
insert into @titulos values ('55'+REPLICATE('0',@Estructura1-2)+'-'+@CerosEstructura, 'Otros Egresos Presupuestales No Contables',null,0,0,19,null)
insert into @titulos values ('', '',null,0,0,19.1,null)

insert into @titulos values ('', '3. Más gastos contables no presupuestales',null,1,0,20,null)
insert into @titulos values ('551'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Estimaciones, depreciaciones, deterioros, obsolescencia y amortizaciones',null,0,1,21,null)
insert into @titulos values ('552'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Provisiones',null,0,1,22,null)
insert into @titulos values ('553'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Disminución de inventarios',null,0,1,23,null)
insert into @titulos values ('554'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Aumento por insuficiencia de estimaciones por pérdida o deterioro u obsolescencia',null,0,1,24,null)
insert into @titulos values ('555'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Aumento por insuficiencia de provisiones',null,0,1,25,null)
insert into @titulos values ('559'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Otros Gastos',null,0,1,26,null)
insert into @titulos values ('5599'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 'Otros Gastos Contables No Presupuestales',null,0,0,27,null)
insert into @titulos values ('', '',null,0,0,27.1,null)
insert into @titulos values ('', '4. Total de Gasto Contable (4 = 1 - 2 + 3 )',null,1,0,28,null)

declare @valores as table (Cuenta varchar(max),Mes int, ejercicio int, TotalCargos decimal(18,4))
insert into @valores 
select c_contable.NumeroCuenta,0,--T_SaldosInicialesCont.Mes,
 0,--T_SaldosInicialesCont.Year,
 isnull(SUM(T_SaldosInicialesCont.TotalCargos),0) 
 from T_SaldosInicialesCont 
join c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
 where (T_SaldosInicialesCont.Mes between @MesInicio and @MesFin) and T_SaldosInicialesCont.Year =@Ejercicio
 group by NumeroCuenta

update @titulos set t.Cargos = isnull(v.TotalCargos,0) from @titulos t  join @valores v on v.Cuenta=t.numero

Update @titulos set suma = isnull(Cargos,0) where Orden=1
update @titulos set Cargos=null where Orden=1
Update @titulos set Suma=(select SUM(isnull(cargos,0)) from @titulos where Orden between 3 and 19 ) where orden=2
Update @titulos set Suma=(select SUM(isnull(cargos,0)) from @titulos where Orden between 21 and 27) where orden=20
Update @titulos set Suma=
((select SUM(isnull(Suma,0)) from @titulos where orden in (1)) -
(select SUM(isnull(Suma,0)) from @titulos where orden in (2))) +
(select SUM(isnull(Suma,0)) from @titulos where orden in (20))
where orden=28

Update @titulos set nombre='     '+nombre from @titulos where Tab=1
 

select * from @titulos 

END

GO

EXEC SP_FirmasReporte 'Conciliacion entre los Egresos Presupuestarios y Gastos Contables'
GO
