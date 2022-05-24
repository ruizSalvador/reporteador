/****** Object:  StoredProcedure [dbo].[SP_RPT_UltimosCostos]    Script Date: 12/04/2014 12:39:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_UltimosCostos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_UltimosCostos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_UltimosCostos]    Script Date: 12/04/2014 12:39:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_UltimosCostos]
@Fecha1 Datetime,
@Fecha2 Datetime


AS
BEGIN

DECLARE @Tabla1 TABLE( IdSubClase INT,IdCodigoProducto int, Fecha NVARCHAR(15))

SELECT C_Maestro.IdSubClase, 
       C_Maestro.IdCodigoProducto
       ,CONVERT(VARCHAR, T_RecepcionFacturas.HoraAuditoria, 105) Fecha
	   into #tabla1
  FROM D_RecepcionFacturas
   LEFT JOIN T_RecepcionFacturas ON T_RecepcionFacturas.IdRecepcionServicios=D_RecepcionFacturas.IdRecepcionServicios 
   LEFT JOIN D_Pedidos ON D_Pedidos.IdRenglonPedido=D_RecepcionFacturas.IdRenglonPedido
   LEFT JOIN C_Maestro ON C_Maestro.IdGrupo=D_Pedidos.IdGrupo AND C_Maestro.IdSubGrupo=D_Pedidos.IdSubGrupo AND C_Maestro.IdCodigoProducto=D_Pedidos.IdCodigoProducto
   inner join T_Pedidos ON T_Pedidos.IdPedido = D_Pedidos.IdPedido  
  WHERE D_RecepcionFacturas.IdRenglonOrden=0 and T_Pedidos.estatus <> 'N' AND T_Pedidos.Fecha>=@Fecha1  and T_Pedidos.Fecha<=@Fecha2
  group by C_Maestro.IdSubClase,C_Maestro.IdCodigoProducto,C_Maestro.DescripcionGenerica,T_RecepcionFacturas.HoraAuditoria
ORDER BY C_Maestro.IdSubClase,  C_Maestro.IdCodigoProducto


DECLARE @Tabla2 TABLE( IdSubClase INT,IdCodigoProducto int, Fecha NVARCHAR(15),Hora NVARCHAR(15),Descripcion NVARCHAR(150))

Insert into @Tabla2 
SELECT C_Maestro.IdSubClase, 
       C_Maestro.IdCodigoProducto
       ,CONVERT(VARCHAR, T_RecepcionFacturas.HoraAuditoria, 105) Fecha
       ,CONVERT(VARCHAR, T_RecepcionFacturas.HoraAuditoria, 108) Hora
	   ,C_Maestro.DescripcionGenerica
  FROM D_RecepcionFacturas
   LEFT JOIN T_RecepcionFacturas ON T_RecepcionFacturas.IdRecepcionServicios=D_RecepcionFacturas.IdRecepcionServicios 
   LEFT JOIN D_Pedidos ON D_Pedidos.IdRenglonPedido=D_RecepcionFacturas.IdRenglonPedido
   LEFT JOIN C_Maestro ON C_Maestro.IdGrupo=D_Pedidos.IdGrupo AND C_Maestro.IdSubGrupo=D_Pedidos.IdSubGrupo AND C_Maestro.IdCodigoProducto=D_Pedidos.IdCodigoProducto
   inner join T_Pedidos ON T_Pedidos.IdPedido = D_Pedidos.IdPedido  
  WHERE D_RecepcionFacturas.IdRenglonOrden=0 and T_Pedidos.estatus <> 'N' AND T_Pedidos.Fecha>=@Fecha1  and T_Pedidos.Fecha<=@Fecha2
  group by C_Maestro.IdSubClase,C_Maestro.IdCodigoProducto,C_Maestro.DescripcionGenerica,T_RecepcionFacturas.HoraAuditoria
ORDER BY C_Maestro.IdSubClase,  C_Maestro.IdCodigoProducto

Insert into @Tabla1
select IdSubClase,IdCodigoProducto,max(Fecha)
from #tabla1 as t1 group by t1.IdSubClase,t1.IdCodigoProducto


--select * from @Tabla1
--select * from @Tabla2 

--select T2.IdSubClase,T2.IdCodigoProducto,T2.Descripcion,T2.Fecha,max(T2.Hora) AS Hora
--from @Tabla2 T2 inner join @Tabla1 T1 on T1.Fecha= T2.Fecha and T1.IdSubClase=T2.IdSubClase AND T1.IdCodigoProducto=T2.IdCodigoProducto
--group by T2.IdSubClase,T2.IdCodigoProducto,T2.Descripcion,T2.Fecha
--order by T2.IdSubClase,T2.IdCodigoProducto


  SELECT distinct  C_Maestro.CodigoCambs --AS 'Código Interno' 
,C_Maestro.IdGrupo
,C_Maestro.IdSubGrupo
,C_Maestro.IdFamilia,
C_Maestro.IdSubClase,
C_Maestro.IdCodigoProducto
, T_RecepcionFacturas.HoraAuditoria
,CONVERT(VARCHAR, T_RecepcionFacturas.FechaFactura, 105) as Fecha
,CONVERT(VARCHAR, T_RecepcionFacturas.HoraAuditoria, 108) Hora
,C_Maestro.DescripcionGenerica AS Descripcion
,D_RecepcionFacturas.PrecioUnitario AS Precio
FROM D_RecepcionFacturas
LEFT JOIN T_RecepcionFacturas ON T_RecepcionFacturas.IdRecepcionServicios=D_RecepcionFacturas.IdRecepcionServicios
LEFT JOIN D_Pedidos ON D_Pedidos.IdRenglonPedido=D_RecepcionFacturas.IdRenglonPedido
LEFT JOIN C_Maestro ON C_Maestro.IdGrupo=D_Pedidos.IdGrupo AND C_Maestro.IdSubGrupo=D_Pedidos.IdSubGrupo AND C_Maestro.IdCodigoProducto=D_Pedidos.IdCodigoProducto
inner join T_Pedidos ON T_Pedidos.IdPedido = D_Pedidos.IdPedido  
inner join (
select T22.IdSubClase,T22.IdCodigoProducto,T22.Descripcion,T22.Fecha,max(T22.Hora) AS Hora
from @Tabla2 T22 inner join @Tabla1 T1 on T1.Fecha= T22.Fecha and T1.IdSubClase=T22.IdSubClase AND T1.IdCodigoProducto=T22.IdCodigoProducto
group by T22.IdSubClase,T22.IdCodigoProducto,T22.Descripcion,T22.Fecha
--order by T22.IdSubClase,T22.IdCodigoProducto
) as T2 ON 
           CONVERT(VARCHAR, T_RecepcionFacturas.FechaFactura, 105) =T2.Fecha 
       and 
	   CONVERT(VARCHAR, T_RecepcionFacturas.HoraAuditoria, 108)= CONVERT(VARCHAR, T2.Hora, 108) 
	   and 
	   T2.IdCodigoProducto=C_Maestro.IdCodigoProducto
	   and t2.IdSubClase=C_Maestro.IdSubClase
WHERE D_RecepcionFacturas.IdRenglonOrden=0 and T_Pedidos.estatus <> 'N' AND T_Pedidos.Fecha>=@Fecha1  and T_Pedidos.Fecha<=@Fecha2
GROUP BY 
 C_Maestro.CodigoCambs
,C_Maestro.IdGrupo
,C_Maestro.IdSubGrupo
,C_Maestro.IdFamilia,
C_Maestro.IdSubClase,
C_Maestro.IdCodigoProducto,
C_Maestro.DescripcionGenerica
,D_RecepcionFacturas.PrecioUnitario
,T_RecepcionFacturas.FechaFactura
,T_RecepcionFacturas.HoraAuditoria 
ORDER BY C_Maestro.IdSubClase,  C_Maestro.IdCodigoProducto,C_Maestro.DescripcionGenerica

 END
 GO

 Exec SP_FirmasReporte 'Reporte Últimos Costos'
 GO
--exec SP_RPT_UltimosCostos @Fecha1='2017-01-01 13:49:12',@Fecha2='2017-11-30 13:49:12.437'