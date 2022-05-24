IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_UltimosCostos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_UltimosCostos]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_UltimosCostos]    Script Date: 07/09/2018 12:39:10 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_UltimosCostos]
@Fecha1 Datetime,
@Fecha2 Datetime

AS
BEGIN

/*  Productos con el top en fecha hora */
DECLARE @Tabla1 TABLE( IdGrupo INT, IdSubGrupo INT, IdCodigoProducto int, Fecha datetime)
DECLARE @Tabla11 TABLE( IdGrupo INT, IdSubGrupo INT, IdCodigoProducto int, Fecha datetime)

Insert into @Tabla11
SELECT C_Maestro.IdGrupo, 
	   C_Maestro.IdSubGrupo, 
       C_Maestro.IdCodigoProducto
       ,T_RecepcionFacturas.HoraAuditoria  Fecha
  FROM D_RecepcionFacturas
   LEFT JOIN T_RecepcionFacturas ON T_RecepcionFacturas.IdRecepcionServicios=D_RecepcionFacturas.IdRecepcionServicios 
   LEFT JOIN D_Pedidos ON D_Pedidos.IdRenglonPedido=D_RecepcionFacturas.IdRenglonPedido
   LEFT JOIN C_Maestro ON C_Maestro.IdGrupo=D_Pedidos.IdGrupo AND C_Maestro.IdSubGrupo=D_Pedidos.IdSubGrupo AND C_Maestro.IdCodigoProducto=D_Pedidos.IdCodigoProducto
   inner join T_Pedidos ON T_Pedidos.IdPedido = D_Pedidos.IdPedido  
  WHERE D_RecepcionFacturas.IdRenglonOrden=0 and T_Pedidos.estatus <> 'C' AND T_Pedidos.Fecha>=@Fecha1  and T_Pedidos.Fecha<=@Fecha2
  group by C_Maestro.IdGrupo,C_Maestro.IdSubGrupo, C_Maestro.IdCodigoProducto,C_Maestro.DescripcionGenerica,T_RecepcionFacturas.HoraAuditoria
ORDER BY C_Maestro.IdGrupo,C_Maestro.IdSubGrupo, C_Maestro.IdCodigoProducto

Insert into @Tabla1
select IdGrupo, IdSubGrupo,IdCodigoProducto, max(Fecha)
from @tabla11 as t11 group by t11.IdGrupo, t11.IdSubGrupo, t11.IdCodigoProducto

DECLARE @Tabla2 TABLE( IdServ Int, fecAud datetime, IdGrupo INT, IdSubGrupo INT, IdCodigoProducto int)
Insert into @Tabla2
Select  T_RecepcionFacturas.IdRecepcionServicios, T_RecepcionFacturas.HoraAuditoria, idGrupo, idSubGrupo, IdCodigoProducto
from @tabla1 T1
inner join  T_RecepcionFacturas on  T_RecepcionFacturas.HoraAuditoria = T1.Fecha


DECLARE @Tabla3 TABLE( IdServ Int, fecAud datetime, IdRenglonPedido INT, PrecioUnitario float, IdGrupo INT, IdSubGrupo INT, IdCodigoProducto int)
Insert into @Tabla3
Select  D_RecepcionFacturas.idRecepcionServicios,T2.fecAud, D_RecepcionFacturas.IdRenglonPedido, D_RecepcionFacturas.Preciounitario, 
D_Pedidos.IdGrupo, D_Pedidos.IdSubgrupo, D_Pedidos.idCodigoProducto 
from @tabla2 T2
left join  D_RecepcionFacturas on  D_RecepcionFacturas.idRecepcionServicios = T2.IdServ
inner JOIN D_Pedidos ON D_Pedidos.IdRenglonPedido=D_RecepcionFacturas.IdRenglonPedido and 
D_Pedidos.idGrupo = T2.idGrupo and D_Pedidos.idSubGrupo = T2.idSubGrupo  and D_Pedidos.IdCodigoProducto= T2.IdCodigoProducto 


Select  C_Maestro.CodigoCambs, 
C_Maestro.IdGrupo,
C_Maestro.IdSubGrupo,
C_Maestro.IdFamilia,
C_Maestro.IdSubClase,
C_Maestro.IdCodigoProducto,
CONVERT(VARCHAR, FecAud, 105) as Fecha,
C_Maestro.DescripcionGenerica AS Descripcion,
PrecioUnitario as Precio
from @tabla3 T3
left join  C_maestro on  C_Maestro.IdGrupo=T3.IdGrupo AND C_Maestro.IdSubGrupo=T3.IdSubGrupo AND C_Maestro.IdCodigoProducto=T3.IdCodigoProducto
ORDER BY C_Maestro.IdGrupo,C_Maestro.IdSubGrupo,   C_Maestro.IdCodigoProducto,C_Maestro.DescripcionGenerica


 END
GO



