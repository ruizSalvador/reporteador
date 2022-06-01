
/****** Object:  StoredProcedure [dbo].[SP_RPT__Relacion_DE_Adquisiciones_DE_Bienes_Muebles_E_Inmuebles]    Script Date: 09/18/2018 14:04:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT__Relacion_DE_Adquisiciones_DE_Bienes_Muebles_E_Inmuebles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT__Relacion_DE_Adquisiciones_DE_Bienes_Muebles_E_Inmuebles]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT__Relacion_DE_Adquisiciones_DE_Bienes_Muebles_E_Inmuebles]    Script Date: 09/18/2018 14:04:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Ing. Blanca Estela Rodríguez Ramos>
-- Create date: <Create 19 de Septiembre 2018>
-- Description:	<Procedimiento Almacenado para mostrar información de activos fijos y resguardos, en grupos por partida y tipo de bien.>
-- =============================================
-- exec SP_RPT__Relacion_DE_Adquisiciones_DE_Bienes_Muebles_E_Inmuebles 1,9,2018
CREATE PROCEDURE [dbo].[SP_RPT__Relacion_DE_Adquisiciones_DE_Bienes_Muebles_E_Inmuebles] 
	@MesInicio as int,
    @MesFin as int,
	@Ejercicio as int
	--@MostrarVacios as bit
AS
BEGIN



Select  1 as unidades, ta.numeroeconomico, csc.Idsubclase, substring(cc.NumeroCuenta,1,5) + '-' as numerocuenta , csg.NombreSubgrupo  as descripcionpartida,ta.codigogrupo, ta.codigosubgrupo, ta.codigoproducto, ct.descripciontipobien, ta.fechafactura, ta.factura, cp.razonsocial, ta.descripcion, ta.Modelo, ta.noserie, cu.Ubicacion, ta.CostoAdquisicion as importe  
from t_activos as ta
left join C_Maestro as cm on cm.IdGrupo = ta.CodigoGrupo and cm.idsubgrupo = ta.codigosubgrupo and cm.idcodigoproducto=ta.CodigoProducto 
left join c_subclases as csc on cm.idsubclase=csc.Idsubclase 
left join c_subgrupos as csg on ta.codigogrupo=csg.IdGrupo and ta.CodigoSubGrupo = csg.IdSubgrupo  
left join C_TipoBien as ct on ta.IdTipoBien = ct.idtipobien
left join C_proveedores as cp on ta.Idproveedor = cp.idproveedor
left join d_resguardos as dr on ta.numeroeconomico = dr.NumeroEconomico
left join C_UbicacionesFisicas as cu on dr.idubicacion = cu.idubicacion
left join r_ctascontxctesprovemp as rc on rc.IdTipoBien = ct.idtipobien and rc.idtipocuenta=ct.idcuentacontable
left join c_contable as cc on cc.idcuentacontable=rc.idcuentacontable
where ta.estatus in ('R','A') and annio=@Ejercicio   and month(fechafactura) >= @MesInicio and month(fechafactura) <= @MesFin    -- and dr.Estatus='A'
group by ta.numeroeconomico, csc.Idsubclase, cc.NumeroCuenta, csg.NombreSubgrupo , ta.codigogrupo, ta.codigosubgrupo, ta.codigoproducto, ct.descripciontipobien, ta.fechafactura, ta.factura, cp.razonsocial, ta.descripcion, ta.Modelo, ta.noserie,  cu.Ubicacion, ta.CostoAdquisicion  


EXEC SP_FirmasReporte 'RELACIÓN DE ADQUISICIONES DE BIENES MUEBLES E INMUEBLES' 

END
GO


