/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ConciliacionIngresos]    Script Date: 12/01/2014 13:32:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_ConciliacionIngresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_ConciliacionIngresos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ConciliacionIngresos]    Script Date: 12/01/2014 13:32:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_K2_ConciliacionIngresos 1,3,2019
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
Insert into @titulos values ('814'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '1. Total de Ingresos Presupuestarios',null,1,0,1,Null)
Insert into @titulos values ('', '',null,0,0,1.1,Null)
Insert into @titulos values ('', '2. Más ingresos contables no presupuestarios',null,1,0,2,Null)
Insert into @titulos values ('431'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '2.1  Ingresos Financieros',0,0,1,3,Null)
Insert into @titulos values ('432'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '2.2  Incremento por variación de inventarios',0,0,1,4,Null)
Insert into @titulos values ('433'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '2.3  Disminución del exceso de estimaciones por pérdida o deterioro u obsolescencia',0,0,1,5,Null)
Insert into @titulos values ('434'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '2.4  Disminución del exceso de provisiones',0,0,1,6,Null)
Insert into @titulos values ('439'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '2.5  Otros ingresos y beneficios varios',0,0,1,7,Null)
Insert into @titulos values ('000'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '2.6  Otros ingresos contables no presupuestarios',0,0,1,8,Null)
Insert into @titulos values ('', '',null,0,0,8.1,Null)
Insert into @titulos values ('', '3. Menos ingresos presupuestarios no contables',null,1,0,9,Null)
--Insert into @titulos values ('415'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, 'Productos de capital',null,0,1,9,Null)
Insert into @titulos values ('62000', '3.1  Aprovechamientos Patrimoniales',0,0,1,10,Null)
Insert into @titulos values ('00000', '3.2  Ingresos derivados de financiamientos',0,0,1,11,Null)
Insert into @titulos values ('', '3.3  Otros Ingresos presupuestarios no contables',0,0,1,12,Null)
Insert into @titulos values ('', '',null,0,0,12.1,Null)
Insert into @titulos values ('', '4. Total de Ingresos Contables',null,1,0,13,Null)

Declare @valores as table (Cuenta varchar(max),Mes int, ejercicio int, TotalAbonos decimal(18,4))
Insert into @valores 
Select c_contable.NumeroCuenta,0,--T_SaldosInicialesCont.Mes,
 0,--T_SaldosInicialesCont.Year,
 SUM(isnull(T_SaldosInicialesCont.TotalAbonos,0)) 
 From T_SaldosInicialesCont 
join c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
 where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio
 Group by c_contable.NumeroCuenta

Declare @INGRESOS as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (18,2),
Total_Modificado decimal (18,2),
Total_Devengado decimal (18,2),
Total_Recaudado decimal (18,2),
PorRecaudar decimal (18,2),
PorcModificado decimal (18,2),
PorcDevengado decimal (18,2),
PorcRecaudado decimal (18,2),
SumaPorRecaudar decimal (18,2),
SumaEstimado decimal (18,2),
SumaModificado decimal (18,2),
SumaDevengado decimal (18,2),
SumaRecaudado decimal (18,2),
ResModificado decimal (18,2),
ResDevengado decimal (18,2),
ResRecaudado decimal (18,2),
Orden int,
--IdClasificacionGI smallint,
--IdClasificacionGIPadre smallint,
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
SumaAmpliacionesReducciones decimal (18,2),
SumaExcedentes decimal (18,2)
)


Insert into @INGRESOS
Exec SP_EstadoEjercicioIngresos_Rubro_Tipo_Clase @MesInicio,1,@MesFin,@Ejercicio,0,0
----------------------------------


update @titulos set t.Abonos = isnull(v.TotalAbonos,0) from @titulos t  join @valores v on v.Cuenta=t.numero

Update @titulos set Abonos = (Select SUM(Total_Devengado) from @INGRESOS Where Clave like '_0000') where Orden=1 --isnull(Abonos,0) where Orden=1
--update @titulos set Abonos=null where Orden=1
Update @titulos set Abonos=(select SUM(isnull(abonos,0)) from @titulos where substring(numero,1,4) in ('4310','4320','4330','4340','4390','4399')) where orden=2
--Update @titulos set Suma=(select SUM(isnull(abonos,0)) from @titulos where substring(numero,1,5) in ('41601','41600','41900')) where orden=9
update @titulos set Abonos= (Select Isnull(Total_Devengado,0) from @INGRESOS where Clave = '62000') Where Orden = 10
update @titulos set Abonos= (Select Isnull(Total_Devengado,0) from @INGRESOS where Clave = '00000') Where Orden = 11
Update @titulos set Abonos=(select SUM(isnull(abonos,0)) from @titulos where Orden in (10,11,12)) where orden=9

Update @titulos set Abonos=(select SUM(isnull(Abonos,0)) from @titulos where orden in (1,2))- 
(select SUM(isnull(Abonos,0)) from @titulos where orden in (9)) where orden=13
 
Update @titulos set nombre='     '+nombre from @titulos where Tab=1

select * from @titulos 

END

GO


EXEC SP_FirmasReporte 'Conciliacion entre los Ingresos Presupuestarios y Contables'
GO
Exec SP_CFG_LogScripts 'SP_RPT_K2_ConciliacionIngresos','2.29.2'
GO

