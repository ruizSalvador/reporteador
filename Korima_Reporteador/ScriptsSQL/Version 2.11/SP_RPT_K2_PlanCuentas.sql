/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_PlanCuentas]    Script Date: 01/18/2013 10:30:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_PlanCuentas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_PlanCuentas]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_PlanCuentas]    Script Date: 01/18/2013 10:30:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_PlanCuentas]
@TipoCuenta varchar(25),
@Afectable tinyint,
@Mayor varchar(25),
@NumeroCuenta varchar (30),
@MuestraHijos bit,
@MuestaPadres bit,
@Activo tinyint,
@NumeroCuentaFin varchar (30),
@NumeroCuentaInicio varchar(30)
--@Ejercicio

as
-- variables para manejo de rango de cuentas
Declare @CuentaInicio bigint
declare @CuentaFin bigint
set @CuentaInicio= CONVERT(bigint,REPLACE(@NumeroCuentaInicio,'-',''))
set @CuentaFin= CONVERT(bigint,REPLACE(@NumeroCuentaFin,'-',''))



Declare @Consulta nvarchar(max),
--Variables para mostrar padres
 @nivel int,
 @nivelHijos int,
 @idnivel8 int,
 @idnivel7 int,
 @idnivel6 int,
 @idnivel5 int,
 @idnivel4 int,
 @idnivel3 int,
 @idnivel2 int,
 @idnivel1 int,
 @idnivel0 int,
 --Variables para mostrar Hijos
 @strnivel varchar(30),
  --Variables para Tipos de cuentas
  @Tipo1 varchar(1),
  @Tipo2 varchar(1),
  @Tipo3 varchar(1),
  @Tipo4 varchar(1),
  @Tipo5 varchar(1),
  @Tipo6 varchar(1),
  @Tipo7 varchar(1),
  @Tipo8 varchar(1),
  @Tipo9 varchar(1),
  @Tipo10 varchar(1),
  @Tipo11 varchar(1),
  --Variables para Mayor
  @Mayor1 varchar(1),
  @Mayor2 varchar(1),
  @Mayor3 varchar(1),
  @Mayor4 varchar(1)
  set @Tipo1= SUBSTRING(@TipoCuenta,1,1)
  set @Tipo2= SUBSTRING(@TipoCuenta,2,1)
  set @Tipo3= SUBSTRING(@TipoCuenta,3,1)
  set @Tipo4= SUBSTRING(@TipoCuenta,4,1)
  set @Tipo5= SUBSTRING(@TipoCuenta,5,1)
  set @Tipo6= SUBSTRING(@TipoCuenta,6,1)
  set @Tipo7= SUBSTRING(@TipoCuenta,7,1)
  set @Tipo8= SUBSTRING(@TipoCuenta,8,1)
  set @Tipo9= SUBSTRING(@TipoCuenta,9,1)
  set @Tipo10= SUBSTRING(@TipoCuenta,10,1)
  set @Tipo11= SUBSTRING(@TipoCuenta,11,1)
  set @Mayor1= SUBSTRING(@Mayor,1,1)
  set @Mayor2= SUBSTRING(@Mayor,2,1)
  set @Mayor3= SUBSTRING(@Mayor,3,1)
  set @Mayor4= SUBSTRING(@Mayor,4,1)
  
 set @nivel= (select  nivel from C_Contable where NumeroCuenta=@NumeroCuenta )
 set @nivelhijos= (select  nivel from C_Contable where NumeroCuenta=@NumeroCuenta )+1


 
  If @Nivel=8
 begin
 set @idnivel8=(Select idcuentacontable from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel7=(Select IdCuentaAfectacion  from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel6=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel7)
 set @idnivel5=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel6)
 set @idnivel4=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel5)
  set @idnivel3=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel4)
  set @idnivel2=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel3)
  set @idnivel1=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel2)
  set @idnivel0=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel1)
 end
 
    If @Nivel=7
 begin
 set @idnivel7=(Select idcuentacontable from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel6=(Select IdCuentaAfectacion  from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel5=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel6)
 set @idnivel4=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel5)
 set @idnivel3=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel4)
  set @idnivel2=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel3)
  set @idnivel1=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel2)
  set @idnivel0=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel1)
 end
 
    If @Nivel=6
 begin
 set @idnivel6=(Select idcuentacontable from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel5=(Select IdCuentaAfectacion  from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel4=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel5)
 set @idnivel3=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel4)
 set @idnivel2=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel3)
  set @idnivel1=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel2)
  set @idnivel0=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel1)
 end
 
   If @Nivel=5
 begin
 set @idnivel5=(Select idcuentacontable from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel4=(Select IdCuentaAfectacion  from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel3=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel4)
 set @idnivel2=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel3)
 set @idnivel1=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel2)
  set @idnivel0=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel1)
 end
 
  If @Nivel=4
 begin
 set @idnivel4=(Select idcuentacontable from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel3=(Select IdCuentaAfectacion  from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel2=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel3)
 set @idnivel1=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel2)
 set @idnivel0=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel1)
 end
 If @Nivel=3
 begin
 set @idnivel3=(Select idcuentacontable from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel2=(Select IdCuentaAfectacion  from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel1=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel2)
 set @idnivel0=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel1)
 end
  If @Nivel=2
 begin
 set @idnivel2=(Select idcuentacontable from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel1=(Select IdCuentaAfectacion  from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel0=(Select idcuentaafectacion from C_Contable where IdCuentaContable=@idnivel1)
 end
  If @Nivel=1
 begin
 set @idnivel1=(Select idcuentacontable from c_Contable where Numerocuenta=@NumeroCuenta)
 set @idnivel0=(Select IdCuentaAfectacion  from c_Contable where Numerocuenta=@NumeroCuenta)
 end
  If @Nivel=0
 begin
 set @idnivel0=(Select idcuentacontable from c_Contable where Numerocuenta=@NumeroCuenta)
 end

set @Consulta = 'select IdCuentaContable,Nivel ,NumeroCuenta,NombreCuenta , CuentaAcumulacion ,TipoCuenta,
case tipocuenta 
       when ''A'' then ''Activo Deudora''
       when ''B'' then ''Activo Acreedora''
       when ''C'' then ''Pasivo Deudora''
      when ''D'' then ''Pasivo Acreedora''
      when ''E'' then ''Patrimonio Dedudora''
      when ''F'' then ''Patrimonio Acreedora''
      when ''G'' then ''Resultados Deudora''
      when ''H'' then ''Resultados Acreedora''
      when ''I'' then ''Orden Deudora''
      when ''J'' then ''Orden Acreedora''
      when ''X'' then ''Control''
else ''No Identificada''
end as TipoCuentaNombre,
Afectable,
case Afectable  
       when 1 then ''Afectable''
      when 0 then ''No Afectable''
end as AfectableNombre,
Utilizar,
Financiero,
case Financiero  
       when 1 then ''Cuenta de Mayor Si''
      when 2 then ''Cuenta de Mayor No''
      when 3 then ''Cuenta de titulo''
      when 4 then ''Cuenta de subtitulo''
else ''No Identificada''
end as FinancieroNombre
from C_Contable   
Where IdCuentaContable > 10
'
If @Activo <> 3
begin
set @Consulta =@Consulta+ ' and Utilizar ='+convert(varchar(max),@Activo)
end

If @Afectable <> 3
begin
set @Consulta =@Consulta+ ' and Afectable ='+convert(varchar(max),@Afectable)
end

If @Mayor <> ''
begin
set @Consulta =@Consulta+ ' and (Financiero = '
if @Mayor1 <>''
set @Consulta =@Consulta+ convert (Varchar(1),@mayor1)
if @Mayor2 <>''
set @Consulta =@Consulta+' or Financiero = '+convert (Varchar(1), @mayor2)
if @Mayor3 <>''
set @Consulta =@Consulta+' or Financiero = '+ convert (Varchar(1),@mayor3)
if @Mayor4 <>'' begin
set @Consulta =@Consulta+' or Financiero = '+ convert (Varchar(1),@mayor4)
end
set @Consulta =@Consulta+')'
end

If @TipoCuenta  <> ''
begin
set @Consulta =@Consulta+ ' and TipoCuenta in ('
If @tipo1 <>''
set @Consulta =@Consulta+ quotename(@tipo1,'''')+''
If @tipo2 <>''
set @Consulta =@Consulta+','+ quotename(@tipo2,'''')+''
If @tipo3 <>''
set @Consulta =@Consulta+','+ quotename(@tipo3,'''')+''
If @tipo4 <>''
set @Consulta =@Consulta+','+ quotename(@tipo4,'''')+''
If @tipo5 <>''
set @Consulta =@Consulta+','+ quotename(@tipo5,'''')+''
If @tipo6 <>''
set @Consulta =@Consulta+','+ quotename(@tipo6,'''')+''
If @tipo7 <>''
set @Consulta =@Consulta+','+ quotename(@tipo7,'''')+''
If @tipo8 <>''
set @Consulta =@Consulta+','+ quotename(@tipo8,'''')+''
If @tipo9 <>''
set @Consulta =@Consulta+','+ quotename(@tipo9,'''')+''
If @tipo10 <>''
set @Consulta =@Consulta+','+ quotename(@tipo10,'''')+''
If @tipo11 <>''
set @Consulta =@Consulta+','+ quotename(@tipo11,'''')+''
set @Consulta =@Consulta+')'
end

if @NumeroCuenta<>'' and @MuestaPadres=0 and @MuestraHijos=0
begin
set @Consulta =@Consulta+' and NumeroCuenta = '+QUOTENAME(@NumeroCuenta,'''')+''
end

if (@NumeroCuentaInicio <> '' and @NumeroCuentaFin <> '')
begin
set @Consulta =@Consulta+' and CONVERT(bigint,REPLACE(NumeroCuenta,''-'','''')) Between '+convert(varchar(max),@CuentaInicio) +' AND '+convert(varchar(max),@CuentaFin)
end

if @NumeroCuenta<>'' and @MuestaPadres=1 and @MuestraHijos=0
begin
set @Consulta =@Consulta+' and idcuentacontable in ('
  if @idnivel0 is not null
  set @Consulta =@Consulta +convert(varchar(max),@idnivel0)
  if @idnivel1 is not null
  set @Consulta =@Consulta +','+convert(varchar(max),@idnivel1)
  if @idnivel2 is not null
  set @Consulta =@Consulta+','+convert(varchar(max),@idnivel2)
    if @idnivel3 is not null
  set @Consulta =@Consulta+','+convert(varchar(max),@idnivel3)
    if @idnivel4 is not null
 set @Consulta =@Consulta+','+convert(varchar(max),@idnivel4)
   if @idnivel5 is not null
  set @Consulta =@Consulta+','+convert(varchar(max),@idnivel5)
    if @idnivel6 is not null
  set @Consulta =@Consulta+','+convert(varchar(max),@idnivel6)
    if @idnivel7 is not null
  set @Consulta =@Consulta+','+convert(varchar(max),@idnivel7)
    if @idnivel8 is not null
  set @Consulta =@Consulta+','+convert(varchar(max),@idnivel8)
  set @Consulta =@Consulta+')'
end

if @NumeroCuenta<>'' and @MuestaPadres=0 and @MuestraHijos=1
begin
set @strnivel= substring(@numerocuenta,1,@nivelHijos)
set @Consulta =@Consulta+' and NumeroCuenta like' + quotename(@strnivel+'%','''')+''
end

if @NumeroCuenta<>'' and @MuestaPadres=1 and @MuestraHijos=1
begin
set @strnivel= substring(@numerocuenta,1,@nivelHijos)
set @Consulta =@Consulta+' and NumeroCuenta like' + quotename(@strnivel+'%','''')+''+
' or  idcuentacontable in ('
  if @idnivel0 is not null
  set @Consulta =@Consulta +convert(varchar(max),@idnivel0)
  if @idnivel1 is not null
  set @Consulta =@Consulta +','+convert(varchar(max),@idnivel1)
  if @idnivel2 is not null
  set @Consulta =@Consulta+','+convert(varchar(max),@idnivel2)
    if @idnivel3 is not null
  set @Consulta =@Consulta+','+convert(varchar(max),@idnivel3)
    if @idnivel4 is not null
 set @Consulta =@Consulta+','+convert(varchar(max),@idnivel4)
   if @idnivel5 is not null
  set @Consulta =@Consulta+','+convert(varchar(max),@idnivel5)
    if @idnivel6 is not null
  set @Consulta =@Consulta+','+convert(varchar(max),@idnivel6)
    if @idnivel7 is not null
  set @Consulta =@Consulta+','+convert(varchar(max),@idnivel7)
    if @idnivel8 is not null
  set @Consulta =@Consulta+','+convert(varchar(max),@idnivel8)
  set @Consulta =@Consulta+')'
end

set @consulta = @consulta + ' order by NumeroCuenta'
--print @consulta
exec (@Consulta) 
GO

--UPDATE C_Menu SET Utilizar=1 WHERE IdMenu in(1073,1162,1165)
--GO

exec SP_FirmasReporte 'Catálogo Plan de Cuentas'
GO




