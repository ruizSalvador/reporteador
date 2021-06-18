/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_InteresesDeuda]    Script Date: 12/04/2014 12:39:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_InteresesDeuda]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_InteresesDeuda]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_InteresesDeuda]    Script Date: 12/04/2014 12:39:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_InteresesDeuda]
@MesInicio int, @MesFin Int, @Ejercicio int, @Mayor bit
AS
BEGIN

declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

declare @rpt as table (Numerocuenta varchar(max),NombreCuenta varchar(max), Abonos decimal(18,4),Cargos decimal(18,4),Grupo decimal(15,2), Grupo2 varchar(max))



if @Mayor=1 begin
insert into @rpt 
--select c_contable.NumeroCuenta,c_contable.NombreCuenta,SUM(T_SaldosInicialesCont.TotalAbonos)as Abonos, 
select c_contable.NumeroCuenta,c_contable.NombreCuenta,SUM(T_SaldosInicialesCont.TotalCargos)as Abonos, 
SUM(T_SaldosInicialesCont.TotalCargos) as Cargos,
1 as Grupo, 'de Créditos Bancarios' as Grupo2
 from T_SaldosInicialesCont 
join c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
 where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio
 --AND Substring(NumeroCuenta, 1,@Estructura1) in ('21160'+REPLICATE('0',@estructura1-5)) and  --DM Cambio a cuenta de Gasto
 AND Substring(NumeroCuenta, 1,@Estructura1) in ('54110'+REPLICATE('0',@estructura1-5)) and 
 SUBSTRING (numerocuenta, @Estructura1+2,LEN(numerocuenta))=@CerosEstructura
 group by NumeroCuenta, NombreCuenta
end
else begin
insert into @rpt 
--select c_contable.NumeroCuenta,c_contable.NombreCuenta,SUM(T_SaldosInicialesCont.TotalAbonos)as Abonos, 
select c_contable.NumeroCuenta,c_contable.NombreCuenta,SUM(T_SaldosInicialesCont.TotalCargos)as Abonos, 
SUM(T_SaldosInicialesCont.TotalCargos) as Cargos,
1 as Grupo, 'de Créditos Bancarios' as Grupo2
 from T_SaldosInicialesCont 
join c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
 where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio
-- AND Substring(NumeroCuenta, 1,@Estructura1) in ('21160'+REPLICATE('0',@estructura1-5)) and --DM Cambio a cuenta de Gasto
AND Substring(NumeroCuenta, 1,@Estructura1) in ('54110'+REPLICATE('0',@estructura1-5)) and 
 SUBSTRING (numerocuenta, @Estructura1+2,LEN(numerocuenta))<>@CerosEstructura
 group by NumeroCuenta, NombreCuenta
 end
 
 
 if @Mayor=1 begin
 insert into @rpt
 select c_contable.NumeroCuenta,c_contable.NombreCuenta,SUM(T_SaldosInicialesCont.TotalAbonos) as Abonos, 
SUM(T_SaldosInicialesCont.TotalCargos) as Cargos,
2 as Grupo, 'de Otros Instrumentos de Deuda' as Grupo2 
 from T_SaldosInicialesCont 
join c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
 where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio
 AND Substring(NumeroCuenta, 1,@Estructura1) in ('21520'+REPLICATE('0',@estructura1-5),'22420'+REPLICATE('0',@estructura1-5)) and 
 SUBSTRING (numerocuenta, @Estructura1+2,LEN(numerocuenta))=@CerosEstructura
 group by NumeroCuenta, NombreCuenta
 end
 else begin
insert into @rpt
 select c_contable.NumeroCuenta,c_contable.NombreCuenta,SUM(T_SaldosInicialesCont.TotalAbonos) as Abonos, 
SUM(T_SaldosInicialesCont.TotalCargos) as Cargos,
3 as Grupo , 'de Otros Instrumentos de Deuda' as Grupo2
 from T_SaldosInicialesCont 
join c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
 where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio
 AND Substring(NumeroCuenta, 1,@Estructura1) in ('21520'+REPLICATE('0',@estructura1-5),'22420'+REPLICATE('0',@estructura1-5)) and 
 SUBSTRING (numerocuenta, @Estructura1+2,LEN(numerocuenta))<>@CerosEstructura
 group by NumeroCuenta, NombreCuenta
 
 end
 
 --insert into @rpt Values('','Créditos Bancarios',null,null,0)
 --insert into @rpt Values('','Otros Instrumentos de Deuda',null,null,2.1)
 
 --insert into @rpt values('','Total de Intereses de Créditos Bancarios',isnull((select SUM(abonos) from @rpt where Grupo=1),0),isnull((select SUM(Cargos) from @rpt where Grupo=1),0),2, 'Créditos Bancarios')
 --insert into @rpt values('','Total de Intereses de Otros Instrumentos de Deuda',isnull((select SUM(abonos) from @rpt where Grupo=3),0),isnull((select SUM(Cargos) from @rpt where Grupo=3),0),4,'Otros Instrumentos de Deuda')
 --insert into @rpt values('','TOTAL',(select SUM(abonos) from @rpt where Grupo in (2,4)),(select SUM(Cargos) from @rpt where Grupo in (2,4)),5)
 
 

select * from @rpt order by Grupo  
END
GO


Exec SP_FirmasReporte 'Intereses de la Deuda'
GO
