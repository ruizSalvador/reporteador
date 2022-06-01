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

Select CodigoCambs,C_Maestro.IdGrupo,C_Maestro.IdFamilia,C_Maestro.IdSubGrupo,
C_Maestro.IdSubClase,C_Maestro.IdCodigoProducto,Fecha,DescripcionGenerica as Descripcion,D_Pedidos.Importe as Precio
From D_Pedidos 
inner join C_Maestro
on D_Pedidos.IdGrupo=C_Maestro.IdGrupo and D_Pedidos.IdSubGrupo=C_Maestro.IdSubGrupo
and D_Pedidos.IdCodigoProducto=C_Maestro.IdCodigoProducto
inner join T_Pedidos
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido
where T_Pedidos.estatus <> 'N' AND
T_Pedidos.Fecha>=@Fecha1  and T_Pedidos.Fecha<=@Fecha2
Order by Fecha desc

 END
 GO

 Exec SP_FirmasReporte 'Reporte Últimos Costos'
 GO