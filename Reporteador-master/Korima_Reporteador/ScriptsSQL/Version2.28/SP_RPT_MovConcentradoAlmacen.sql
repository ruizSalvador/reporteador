IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_MovConcentradoAlmacen]'))
DROP PROCEDURE [dbo].[SP_RPT_MovConcentradoAlmacen] 
Go

/****** Object:  StoredProcedure [dbo].[SP_RPT_MovConcentradoAlmacen]    Script Date: 21/08/2018 09:42:29 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Exec SP_RPT_MovConcentradoAlmacen '20180101','20180821',3
CREATE PROCEDURE [dbo].[SP_RPT_MovConcentradoAlmacen] 
  
@FechaIni Datetime,
@FechaFin Datetime,
@IdAlmacen int

AS
BEGIN

DECLARE @Temp_D_Almacen AS TABLE(
IDAlm int,
Cvepartida int,
compras decimal (15,2),
salidas decimal (15,2)
)

insert into @Temp_D_Almacen
select 
DM.IdAlmacen,
(Select ClavePartida from c_maestro cmtro Where cmtro.IdGrupo = DM.IdGrupo and cmtro.IdSubGrupo = DM.IdSubGrupo and cmtro.IdCodigoProducto = DM.IdProducto) cvepartida,
(case when (Select TipoMov from T_MovimientosAlmacen Where T_MovimientosAlmacen.IdMovimiento = DM.IdMovimiento) = 'E' then (cantidad*costo) else 0 end) as compras,
(case when (Select TipoMov from T_MovimientosAlmacen Where T_MovimientosAlmacen.IdMovimiento = DM.IdMovimiento) = 'S' then (cantidad*costo) else 0 end) as salidas
from D_MovimientosAlmacen DM
where Fecha >= @FechaIni and Fecha <= @FechaFin
and IdAlmacen= ISNULL(@IdAlmacen,DM.IdAlmacen) 
order by cvepartida;

select IdAlm, Cvepartida, substring(descripcionPartida,1,7) as corta, descripcionPartida as Descp, sum(compras) as Compras, sum(salidas) as Salida 
from @Temp_D_Almacen
INNER JOIN  c_partidaspres cpp on cpp.IdPartida = Cvepartida
group by idAlm, Cvepartida, descripcionPartida
order by Descp;

END

GO
