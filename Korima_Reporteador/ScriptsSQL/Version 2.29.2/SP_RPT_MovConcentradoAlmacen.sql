IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_MovConcentradoAlmacen]'))
DROP PROCEDURE [dbo].[SP_RPT_MovConcentradoAlmacen] 
Go
/****** Object:  StoredProcedure [dbo].[SP_RPT_MovConcentradoAlmacen]    Script Date: 21/08/2018 09:42:29 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_MovConcentradoAlmacen '20200501','20200531',2
CREATE PROCEDURE [dbo].[SP_RPT_MovConcentradoAlmacen] 
  
@FechaIni Datetime,
@FechaFin Datetime,
@IdAlmacen int

AS
BEGIN

DECLARE @Temp_D_Almacen AS TABLE(
IDAlm int,
IdGrupo int,
IdSubGrupo int,
IdProducto int,
Cvepartida int,
compras float,
salidas float
)

DECLARE @D_Almacen2 AS TABLE(
IDAlm int,
IdGrupo int,
IdSubGrupo int,
IdProducto int,
Cvepartida int,
compras float,
salidas float
)

DECLARE @Temp2 AS TABLE(
IDAlm int,
Cvepartida int,
corta varchar(200),
Descp varchar(250),
Compras decimal(18,2),
Salida decimal (18,2),
SaldoInicial decimal (18,2)
)

DECLARE @Saldos AS TABLE(
IDAlm int,
Cvepartida int,
corta varchar(200),
Descp varchar(250),
Compras decimal(18,2),
Salida decimal (18,2),
SaldoInicial decimal (18,2)
)

DECLARE @SUMSaldos AS TABLE(
IDAlm int,
Cvepartida int,
corta varchar(200),
Descp varchar(250),
Compras decimal(18,2),
Salida decimal (18,2),
SaldoInicial decimal (18,2),
SaldoFinal decimal (18,2)
)

DECLARE @Final AS TABLE(
IDAlm int,
Cvepartida int,
corta varchar(200),
Descp varchar(250),
Compras decimal(18,2),
Salida decimal (18,2),
SaldoInicial decimal (18,2),
SaldoFinal decimal (18,2)
)

DECLARE @Todo AS TABLE(
IDAlm int,
Cvepartida int,
corta varchar(200),
Descp varchar(250),
Compras decimal(18,2),
Salida decimal (18,2),
SaldoInicial decimal (18,2),
SaldoFinal decimal (18,2)
)

Insert into @Temp_D_Almacen
select 
DM.IdAlmacen,
DM.IdGrupo, DM.IdSubGrupo, DM.IdProducto,
(Select ClavePartida from c_maestro cmtro Where cmtro.IdGrupo = DM.IdGrupo and cmtro.IdSubGrupo = DM.IdSubGrupo and cmtro.IdCodigoProducto = DM.IdProducto) cvepartida,
(case when (Select TipoMov from T_MovimientosAlmacen Where T_MovimientosAlmacen.IdMovimiento = DM.IdMovimiento) = 'E' then ISNULL((cantidad*costo),0) else 0 end) as compras,
case (Select TipoMov from T_MovimientosAlmacen Where T_MovimientosAlmacen.IdMovimiento = DM.IdMovimiento)
when 'S' then (ISNULL(cantidad,0)*ISNULL(costo,0))  
 when 'A' then ISNULL((costo),0) end as salidas
from D_MovimientosAlmacen DM
where Fecha >= @FechaIni and Fecha <= @FechaFin
and IdAlmacen= ISNULL(@IdAlmacen,DM.IdAlmacen) 
order by cvepartida;

--Select * from @Temp_D_Almacen

Insert into @D_Almacen2
select 
DM.IdAlmacen,
DM.IdGrupo, DM.IdSubGrupo, DM.IdProducto,
(Select ClavePartida from c_maestro cmtro Where cmtro.IdGrupo = DM.IdGrupo and cmtro.IdSubGrupo = DM.IdSubGrupo and cmtro.IdCodigoProducto = DM.IdProducto) cvepartida,
(case when (Select TipoMov from T_MovimientosAlmacen Where T_MovimientosAlmacen.IdMovimiento = DM.IdMovimiento) = 'E' then ISNULL((cantidad*costo),0) else 0 end) as compras,
case (Select TipoMov from T_MovimientosAlmacen Where T_MovimientosAlmacen.IdMovimiento = DM.IdMovimiento)
when 'S' then (ISNULL(cantidad,0)*ISNULL(costo,0))  
 when 'A' then ISNULL((costo),0) end as salidas
from D_MovimientosAlmacen DM
--where Fecha >= @FechaIni and Fecha <= @FechaFin
where Fecha < @FechaIni
and IdAlmacen= ISNULL(@IdAlmacen,DM.IdAlmacen) 
order by cvepartida;


Insert Into @Temp2
select IdAlm, Cvepartida, substring(descripcionPartida,1,7) as corta, descripcionPartida as Descp, sum(compras) as Compras, sum(salidas) as Salida,
--tmp.IdGrupo, tmp.IdSubGrupo, tmp.IdProducto,
(SELECT SUM(
            CASE WHEN T.TipoMov = 'E' THEN ISNULL((D.Cantidad * D.Costo),0)
                 WHEN T.TipoMov = 'A' THEN ISNULL(-(D.Costo),0)
                 ELSE ((D.Cantidad * D.Costo) *-1 )
            END) AS 'CostoInicial'
 FROM T_MovimientosAlmacen T JOIN D_MovimientosAlmacen D
   ON T.IdMovimiento = D.IdMovimiento
 WHERE D.IdAlmacen = @IdAlmacen
  AND (D.IdGrupo = tmp.IdGrupo AND D.IdSubgrupo = tmp.IdSubGrupo AND D.IdProducto =tmp.IdProducto)
  AND T.TipoMov in ( 'E','S','A')
  AND T.Fecha < @FechaIni) as SaldoInicial 
from @Temp_D_Almacen tmp
INNER JOIN  c_partidaspres cpp on cpp.IdPartida = Cvepartida
group by idAlm, Cvepartida, descripcionPartida, tmp.IdGrupo, tmp.IdSubGrupo, tmp.IdProducto
order by Descp;

--Select * from @Temp2

Insert Into @Saldos
select IdAlm, Cvepartida, substring(descripcionPartida,1,7) as corta, descripcionPartida as Descp, sum(compras) as Compras, sum(salidas) as Salida,
--tmp.IdGrupo, tmp.IdSubGrupo, tmp.IdProducto,
(SELECT SUM(
            CASE WHEN T.TipoMov = 'E' THEN ISNULL((D.Cantidad * D.Costo),0)
                 WHEN T.TipoMov = 'A' THEN ISNULL(-(D.Costo),0)
                 ELSE ((D.Cantidad * D.Costo) *-1 )
            END) AS 'CostoInicial'
 FROM T_MovimientosAlmacen T JOIN D_MovimientosAlmacen D
   ON T.IdMovimiento = D.IdMovimiento
 WHERE D.IdAlmacen = @IdAlmacen
  AND (D.IdGrupo = tmp.IdGrupo AND D.IdSubgrupo = tmp.IdSubGrupo AND D.IdProducto =tmp.IdProducto)
  AND T.TipoMov in ( 'E','S','A')
  AND T.Fecha < @FechaIni) as SaldoInicial 
from @D_Almacen2 tmp
INNER JOIN  c_partidaspres cpp on cpp.IdPartida = Cvepartida
group by idAlm, Cvepartida, descripcionPartida, tmp.IdGrupo, tmp.IdSubGrupo, tmp.IdProducto
order by Descp;

Insert into @SUMSaldos
Select IdAlm, Cvepartida, corta, Descp, SUM(ISNULL(Compras,0)) as Compras, SUM(ISNULL(Salida,0)) as Salida, SUM(ISNULL(SaldoInicial,0)) as SaldoInicial, SUM(ISNULL(SaldoInicial,0))+SUM(ISNULL(Compras,0))-SUM(ISNULL(Salida,0)) as SaldoFinal
from @Saldos group by IdAlm, Cvepartida, corta, Descp


Insert into @Final
Select IdAlm, Cvepartida, corta, Descp, SUM(ISNULL(Compras,0)) as Compras, SUM(ISNULL(Salida,0)) as Salida, SUM(ISNULL(SaldoInicial,0)) as SaldoInicial, SUM(ISNULL(SaldoInicial,0))+SUM(ISNULL(Compras,0))-SUM(ISNULL(Salida,0)) as SaldoFinal
from @Temp2 group by IdAlm, Cvepartida, corta, Descp

--Update @Final set SaldoInicial = 
--update @Final 
--set a.SaldoInicial=isnull(b.SaldoInicial,0), a.SaldoFinal= ISNULL(b.SaldoInicial,0)+(ISNULL(a.Compras,0)-ISNULL(a.Salida,0))--, a.SaldoDeudor=b.SaldoDeudor , a.SaldoAcreedor=b.SaldoAcreedor 
--from @Final a
--RIGHT JOIN @SUMSaldos b
-- on a.Cvepartida=b.Cvepartida

--Select * from @SUMSaldos
--Select * from @Final

Insert into @Todo
 Select a.IDAlm, a.Cvepartida, a.corta, a.Descp, ISNULL(b.Compras,0) as Compras, ISNULL(b.Salida,0) as Salida, ISNULL(a.SaldoInicial,0) as SaldoInicial, ISNULL(a.SaldoInicial,0) + ISNULL(b.Compras,0) - ISNULL(b.Salida,0) as SaldoFinal
 from @SUMSaldos a
LEFT JOIN @Final b
 on a.Cvepartida=b.Cvepartida
 Where (ISNULL(b.Compras,0) +  ISNULL(b.Salida,0) + ISNULL(a.SaldoInicial,0) + ISNULL(a.SaldoFinal,0) )<>0
 Order by a.Cvepartida
 --Select * from @Final order by Cvepartida

 Insert into @Todo
 Select * from @Final Where Cvepartida not in (Select Cvepartida from @SUMSaldos)

 Select * from @Todo order by Cvepartida

END

GO
