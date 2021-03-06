
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Comprobacion_DIOT]    Script Date: 07/22/2013 15:39:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Comprobacion_DIOT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Comprobacion_DIOT]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Comprobacion_DIOT]    Script Date: 07/22/2013 15:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_Comprobacion_DIOT] 
@mes as int, @Ejercicio as int  

--##-----16%--##

AS
DECLARE @ACT_IVA16 AS TABLE (IdProveedor INT, PorcIVA INT, IVA Decimal(18,2), Importe Decimal(18,2),Concepto Varchar(MAX), ConceptoPago Varchar(MAX), Poliza Varchar(MAX), IdPoliza Varchar(MAX))  
INSERT INTO @ACT_IVA16  
SELECT T_Pedidos.IdProveedor, PorcIva, CONVERT(Decimal(18,2),(D_RecepFac.Importe * 0.16)) AS 'IVA', 
CONVERT(Decimal(18,2), D_RecepFac.Importe) AS 'SubTotal', T_SolicitudCheques.Concepto, ConceptoPago,
CONCAT('E ',TPol.Periodo,' ',TPol.NoPoliza) AS Poliza, TPol.IdPoliza
FROM  D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido INNER JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido = T_Pedidos.IdPedido INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecepcionFacturas.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Pedidos.IdRenglonPedido = D_RecepFac.IdRenglonPedido INNER JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE D_Pedidos.PorcIva = 16 AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)  
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
GROUP BY T_Pedidos.IdProveedor, PorcIva, T_SolicitudCheques.Concepto, ConceptoPago, D_RecepFac.Importe,
CONCAT('E ',TPol.Periodo,' ',TPol.NoPoliza), TPol.IdPoliza
-- GROUP BY T_Pedidos.IdProveedor, T_Cheques.ImporteCheque
UNION ALL 
SELECT T_Ord.IdProveedor, PorcIva, CONVERT(Decimal(18,2),(D_RecepFac.Importe * 0.16)) AS 'IVA', 
CONVERT(Decimal(18,2), D_RecepFac.Importe) AS 'SubTotal', T_SolCheq.Concepto, ConceptoPago,
CONCAT('E ',TPol.Periodo,' ',TPol.NoPoliza) AS Poliza, TPol.IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecFac.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Ord.IdRenglonOrden = D_RecepFac.IdRenglonOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio 
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND D_Ord.PorcIva = 16
UNION ALL
SELECT D_Viaticos.IdProveedor, IVA_PORC, CONVERT(Decimal(18,2),(D_Viaticos.Importe) * (0.16)) AS 'IVA', 
CONVERT(Decimal(18,2),(D_Viaticos.Importe)) AS 'SubTotal', Justificacion, Referencia,
CONCAT('E ',TPol.Periodo,' ',TPol.NoPoliza) AS Poliza, TPol.IdPoliza
FROM T_Viaticos INNER JOIN D_Viaticos 
ON T_Viaticos.IdViaticos = D_Viaticos.IdViatico INNER JOIN T_Polizas TPol
ON T_Viaticos.IdPoliza = TPol.IdPoliza
Where (MONTH(T_Viaticos.Fecha) = @mes AND YEAR(T_Viaticos.Fecha) = @Ejercicio)  
AND D_Viaticos.IVA_PORC = 16 AND T_Viaticos.Estatus = 'A'
ORDER BY IdProveedor, Subtotal;

--#---------8%

DECLARE @ACT_IVA8 AS TABLE (IdProveedor INT, PorcIVA INT, IVA Decimal(18,2), Importe Decimal(18,2),Concepto Varchar(MAX), ConceptoPago Varchar(MAX), Poliza Varchar(MAX), IdPoliza Varchar(MAX))  
INSERT INTO @ACT_IVA8 
SELECT T_Pedidos.IdProveedor, PorcIva, CONVERT(Decimal(18,2),(D_RecepFac.Importe)*(0.08)) AS 'IVA', 
--SUM(CONVERT(Decimal(18,2),(T_Cheques.ImporteCheque/1.08))) AS 'SubTotal', Concepto, ConceptoPago
CONVERT(Decimal(18,2), D_RecepFac.Importe) AS 'SubTotal', T_SolicitudCheques.Concepto, ConceptoPago,
CONCAT('E ',TPol.Periodo,' ',TPol.NoPoliza) AS Poliza, TPol.IdPoliza
FROM D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido INNER JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido = T_Pedidos.IdPedido INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecepcionFacturas.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Pedidos.IdRenglonPedido = D_RecepFac.IdRenglonPedido INNER JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE D_Pedidos.PorcIva = 8 AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)  
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
GROUP BY T_Pedidos.IdProveedor, T_Pedidos.IdPedido , PorcIva, T_SolicitudCheques.Concepto, ConceptoPago, D_RecepFac.Importe,
CONCAT('E ',TPol.Periodo,' ',TPol.NoPoliza), TPol.IdPoliza
-- GROUP BY T_Pedidos.IdProveedor, T_Cheques.ImporteCheque
UNION ALL 
SELECT T_Ord.IdProveedor, PorcIva, CONVERT(Decimal(18,2),(D_RecepFac.Importe) * (0.08)) AS 'IVA', 
CONVERT(Decimal(18,2),(D_RecepFac.Importe)) AS 'SubTotal', T_SolCheq.Concepto, ConceptoPago,
CONCAT('E ',TPol.Periodo,' ',TPol.NoPoliza), TPol.IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecFac.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Ord.IdRenglonOrden = D_RecepFac.IdRenglonOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND D_Ord.PorcIva = 8
UNION ALL
SELECT D_Viaticos.IdProveedor, IVA_PORC, CONVERT(Decimal(18,2),(D_Viaticos.Importe)*(0.08)) AS 'IVA', 
CONVERT(Decimal(18,2),D_Viaticos.Importe) AS 'SubTotal', Justificacion, Referencia,
CONCAT('E ',TPol.Periodo,' ',TPol.NoPoliza) AS Poliza, TPol.IdPoliza
FROM T_Viaticos INNER JOIN D_Viaticos 
ON T_Viaticos.IdViaticos = D_Viaticos.IdViatico INNER JOIN T_Polizas TPol
ON T_Viaticos.IdPoliza = TPol.IdPoliza
Where (MONTH(T_Viaticos.Fecha) = @mes AND YEAR(T_Viaticos.Fecha)=@Ejercicio)  
AND D_Viaticos.IVA_PORC = 8 AND T_Viaticos.Estatus = 'A'
ORDER BY IdProveedor, SubTotal;

/*
SELECT * 
FROM @ACT_IVA8 IVA8 FULL JOIN @ACT_IVA16 IVA16
ON /*IVA8.IdProveedor = IVA16.IdProveedor AND*/ IVA8.ConceptoPago = IVA16.ConceptoPago
--WHERE (IVA16.IdProveedor = 18 OR IVA8.IdProveedor = 18) -- AND IVA16.IdProveedor IS NULL OR IVA8.Idproveedor IS NULL;


SELECT Prov.IdProveedor, Prov.RazonSocial, RFC, IVA16.Importe,IVA8.ConceptoPago,IVA16.ConceptoPago,
CASE WHEN IVA8.PorcIVA = 8 THEN IVA8.Importe WHEN IVA16.PorcIVA = 16 THEN IVA16.Importe ELSE 0 END AS 'Importe_1',
IIF((IVA8.PorcIVA = 8), IVA8.Importe, IVA16.Importe)--, IIF((IVA16.PorcIVA = 16), IVA16.Importe, IVA8.Importe) AS 'Importe_2'
FROM C_Proveedores Prov FULL JOIN @ACT_IVA8 IVA8 
ON Prov.IdProveedor = IVA8.IdProveedor  
FULL JOIN @ACT_IVA16 IVA16
ON Prov.IdProveedor = IVA16.IdProveedor AND IVA16.ConceptoPago = IVA8.ConceptoPago
WHERE (IVA16.IdProveedor = 18 OR IVA8.IdProveedor = 18)
--GROUP BY IVA8.ConceptoPago, IVA16.ConceptoPago;
--CASE WHEN IVA8.ConceptoPago != IVA16.ConceptoPago THEN IVA8.Importe WHEN IVA16.ConceptoPago != IVA8.ConceptoPago THEN 'OPT2' ELSE 'EXIT' END;
--GROUP BY IVA8.ConceptoPago,IVA16.ConceptoPago,IVA8.PorcIVA, IVA16.PorcIVA, Prov.IdProveedor,Prov.RazonSocial, RFC, IVA8.Importe, IVA16.Importe;
--WHERE IVA8.IdProveedor = 18 AND IVA16.IdProveedor = 18;*/


--#--------19

DECLARE @ACT_IVA19 AS TABLE (IdProveedor INT, PorcIVA INT, IVA Decimal(18,2), Importe Decimal(18,2),Concepto Varchar(MAX), ConceptoPago Varchar(MAX),Poliza Varchar(MAX), IdPoliza Varchar(MAX))  
INSERT INTO @ACT_IVA19 
SELECT T_Pedidos.IdProveedor, PorcIva, CONVERT(Decimal(18,2),(D_RecepFac.Importe)*(0.00)) AS 'IVA', 
CONVERT(Decimal(18,2),(D_RecepFac.Importe)) AS 'SubTotal', T_SolicitudCheques.Concepto, ConceptoPago,
CONCAT('E ',TPol.Periodo,' ',TPol.NoPoliza) AS Poliza, TPol.IdPoliza
FROM  D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido INNER JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido = T_Pedidos.IdPedido INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecepcionFacturas.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Pedidos.IdRenglonPedido = D_RecepFac.IdRenglonPedido INNER JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_pedidos.TipoIva in (2,0) AND D_pedidos.PorcIva=0) 
AND (MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha)=@Ejercicio)  
-- AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
-- GROUP BY T_Pedidos.IdProveedor, T_Cheques.ImporteCheque
UNION ALL 
SELECT T_Ord.IdProveedor, PorcIva, CONVERT(Decimal(18,2),(D_RecepFac.Importe)*(0.00)) AS 'IVA', 
CONVERT(Decimal(18,2), D_RecepFac.Importe) AS 'SubTotal', T_SolCheq.Concepto, ConceptoPago,
CONCAT('E ',TPol.Periodo,' ',TPol.NoPoliza) AS Poliza, TPol.IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecFac.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Ord.IdRenglonOrden = D_RecepFac.IdRenglonOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio 
AND D_Ord.PorcIva = 0;


SELECT -- CASE NacionalExtanjero WHEN 'N' THEN '04' WHEN 'E' THEN '05' WHEN 'G' THEN '15' ELSE '04' END AS 'Tipo de Tercero',
Prov.IdProveedor,
Prov.RazonSocial,
RFC,
--isnull(convert(varchar(max),sum(Campo8.Importe)),0) AS 'Valor Actividades 16%'
ISNULL(Campo8.PorcIVA,0) AS 'PorcIVA16',
ISNULL(Campo8.Importe,0) AS 'Valor_Actividades_16',
ISNULL(Campo8.IVA,0) AS 'IVA_16',
ISNULL((Campo8.IVA + Campo8.Importe),0) AS 'TOTAL_16',
-- ISNULL(Campo8.Poliza,'') AS 'Poliza',
ISNULL(Campo13.PorcIVA,0)AS 'PorcIVA8',
ISNULL(Campo13.Importe,0) AS 'Act_estimulo_region_norte',
ISNULL(Campo13.IVA,0) AS 'IVA_8',
ISNULL((Campo13.IVA + Campo13.Importe),0) AS 'TOTAL_8',
-- ISNULL(Campo13.Poliza,'') AS 'Poliza',
ISNULL(Campo19.Importe,0) AS 'No_acred_import_11_y_10',
ISNULL(Campo19.IVA,0) AS 'IVA_10',
ISNULL((Campo19.IVA + Campo19.Importe),0) AS 'TOTAL_10',
	CASE WHEN Campo8.Poliza != '' THEN ISNULL(Campo8.Poliza,'') 
	WHEN Campo13.Poliza != '' THEN ISNULL(Campo13.Poliza,'') ELSE ISNULL(Campo19.Poliza,'') END AS 'Poliza'
FROM C_Proveedores Prov LEFT JOIN C_PaisesDIOT Paises
ON Paises.Clave=Prov.Cargo LEFT JOIN @ACT_IVA16 Campo8
ON Prov.IdProveedor = Campo8.IdProveedor LEFT JOIN @ACT_IVA8 Campo13
ON Prov.IdProveedor = Campo13.IdProveedor LEFT JOIN @ACT_IVA19 Campo19
ON Prov.IdProveedor = Campo19.IdProveedor 
WHERE TipoProveedor in ('P', 'C') and  RFC <>'' AND Campo8.Importe > 0 OR Campo13.Importe > 0 OR Campo19.Importe > 0
ORDER BY IdProveedor, RFC, Poliza;