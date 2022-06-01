
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Auxiliar_DIOT]    Script Date: 07/22/2013 15:39:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Auxiliar_DIOT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Auxiliar_DIOT]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Auxiliar_DIOT]    Script Date: 07/22/2013 15:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Exec SP_RPT_K2_Auxiliar_DIOT 2,2020,0
CREATE PROCEDURE [dbo].[SP_RPT_K2_Auxiliar_DIOT] 
@mes as int, 
@Ejercicio as int,
@IdProv as int  

--##------------------------------------------16%--------------------------------------------------##

AS
DECLARE @ACT_IVA16 AS TABLE (Tipo varchar(10),IdProveedor INT, RFC varchar(50), RazonSocial varchar(250), Tasa float, IVA Decimal(18,2), Importe Decimal(18,2), IdPedido int, Fecha datetime, Poliza Varchar(MAX), IdPoliza Varchar(MAX))  
INSERT INTO @ACT_IVA16  
SELECT 'OC' as Tipo, 
--D_Pedidos.IdPedido, 
T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa, 
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM  D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido = T_Pedidos.IdPedido INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecepcionFacturas.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Pedidos.IdRenglonPedido = D_RecepFac.IdRenglonPedido INNER JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_Pedidos.PorcIva Between 15.01 and 16.99)
--AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Pedidos.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza,TC.Fecha, T_Pedidos.IdPedido
,T_Pedidos.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL 

SELECT 'OC-A' as Tipo, 
T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa, 
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM  D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor 
INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque =T_Pedidos.IdSolicitudChequesAnticipo 
WHERE (D_Pedidos.PorcIva Between 15.01 and 16.99)
--AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Pedidos.IdProveedor, CP.RFC, CP.RazonSocial, T_Pedidos.IdPedido, TC.Fecha, TC.IdChequesAgrupador, TC.FolioCheque, TC.Status,
TC.IdCheques

UNION ALL

SELECT 'OC-C' as Tipo, 
--D_Pedidos.IdPedido, 
T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa, 
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM  D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido = T_Pedidos.IdPedido INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecepcionFacturas.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Pedidos.IdRenglonPedido = D_RecepFac.IdRenglonPedido INNER JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_Pedidos.PorcIva Between 15.01 and 16.99)
--AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador <> 0 
AND TC.Status in ('L')
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Pedidos.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza,TC.Fecha, T_Pedidos.IdPedido
,T_Pedidos.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'OS' as Tipo, 
T_Ord.IdProveedor,
CP.RFC,
CP.RazonSocial, 
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecFac.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Ord.IdRenglonOrden = D_RecepFac.IdRenglonOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio 
 (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio) 
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND (D_Ord.PorcIva Between 15.01 and 16.99)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, TC.Fecha, T_Ord.IdOrden
,T_Ord.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'OS-A' as Tipo, 
T_Ord.IdProveedor,
CP.RFC,
CP.RazonSocial, 
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque =T_Ord.IdSolicitudChequesAnticipo 
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND (D_Ord.PorcIva Between 15.01 and 16.99)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, CP.RFC, CP.RazonSocial, T_Ord.IdOrden, TC.Fecha, TC.IdChequesAgrupador, TC.FolioCheque, TC.Status,
TC.IdCheques

UNION ALL

SELECT 'OS-C' as Tipo, 
T_Ord.IdProveedor,
CP.RFC,
CP.RazonSocial, 
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecFac.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Ord.IdRenglonOrden = D_RecepFac.IdRenglonOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio) 
AND TC.IdChequesAgrupador <> 0 
AND TC.Status in ('L')
AND (D_Ord.PorcIva Between 15.01 and 16.99)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, TC.Fecha, T_Ord.IdOrden
,T_Ord.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'V' as Tipo, D_Viaticos.IdProveedor, CP.RFC, CP.RazonSocial, 
IVA_PORC as Tasa, 
16 AS 'IVA', 
D_Viaticos.Importe AS Importe, 
--Justificacion, Referencia,
T_Viaticos.IdViaticos,
TPol.Fecha,
CONCAT(TPol.TipoPoliza,' ',TPol.Periodo,' ',TPol.NoPoliza) AS Poliza, TPol.IdPoliza
FROM T_Viaticos INNER JOIN D_Viaticos 
ON T_Viaticos.IdViaticos = D_Viaticos.IdViatico
LEFT JOIN C_Proveedores CP
  ON D_Viaticos.IdProveedor = CP.IdProveedor 
INNER JOIN T_Polizas TPol
ON T_Viaticos.IdPoliza = TPol.IdPoliza
Where (MONTH(T_Viaticos.Fecha) = @mes AND YEAR(T_Viaticos.Fecha) = @Ejercicio)  
AND (D_Viaticos.IVA_PORC Between 15.01 and 16.99)
AND T_Viaticos.Estatus = 'A'
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
--GROUP BY D_Viaticos.IdProveedor, TPol.Periodo, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, T_Viaticos.IdViaticos, TPol.Fecha
ORDER BY IdProveedor

--#---------------------------------------------------8%-------------------------------------------

DECLARE @ACT_IVA8 AS TABLE (Tipo varchar(10),IdProveedor INT, RFC varchar(50), RazonSocial varchar(250),Tasa float, IVA Decimal(18,2), Importe Decimal(18,2), IdPedido int, Fecha datetime, Poliza Varchar(MAX), IdPoliza Varchar(MAX))  
INSERT INTO @ACT_IVA8 
SELECT 'OC', T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa,
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
--SUM(CONVERT(Decimal(18,2),(TC.ImporteCheque/1.08))) AS 'SubTotal', Concepto, ConceptoPago
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido = T_Pedidos.IdPedido INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecepcionFacturas.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Pedidos.IdRenglonPedido = D_RecepFac.IdRenglonPedido INNER JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques  TC 
ON TC.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques 
INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_Pedidos.PorcIva Between 7.01 and 8.99)
-- AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Pedidos.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza,TC.Fecha, T_Pedidos.IdPedido
,T_Pedidos.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

-- GROUP BY T_Pedidos.IdProveedor, TC.ImporteCheque

UNION ALL 

SELECT 'OC-A' as Tipo, 
--D_Pedidos.IdPedido, 
T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa, 
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM  D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor
INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque =T_Pedidos.IdSolicitudChequesAnticipo 
WHERE (D_Pedidos.PorcIva Between 7.01 and 8.99)
--AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Pedidos.IdProveedor, CP.RFC, CP.RazonSocial, T_Pedidos.IdPedido, TC.Fecha, TC.IdChequesAgrupador, TC.FolioCheque, TC.Status,
TC.IdCheques

UNION ALL

SELECT 'OC-C', T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa,
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
--SUM(CONVERT(Decimal(18,2),(TC.ImporteCheque/1.08))) AS 'SubTotal', Concepto, ConceptoPago
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido = T_Pedidos.IdPedido INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecepcionFacturas.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Pedidos.IdRenglonPedido = D_RecepFac.IdRenglonPedido INNER JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques  TC 
ON TC.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_Pedidos.PorcIva Between 7.01 and 8.99)

 --AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador <> 0 
AND TC.Status in ('L')
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Pedidos.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza,TC.Fecha, T_Pedidos.IdPedido
,T_Pedidos.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL


SELECT 'OS',T_Ord.IdProveedor,
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
 T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecFac.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Ord.IdRenglonOrden = D_RecepFac.IdRenglonOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND (D_Ord.PorcIva Between 7.01 and 8.99)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, TC.Fecha, T_Ord.IdOrden
,T_Ord.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'OS-A' as Tipo, 
T_Ord.IdProveedor,
CP.RFC,
CP.RazonSocial, 
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque =T_Ord.IdSolicitudChequesAnticipo 
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND (D_Ord.PorcIva Between 7.01 and 8.99)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, CP.RFC, CP.RazonSocial, T_Ord.IdOrden, TC.Fecha, TC.IdChequesAgrupador, TC.FolioCheque, TC.Status,
TC.IdCheques

UNION ALL

SELECT 'OS-C' as Tipo, 
T_Ord.IdProveedor,
CP.RFC,
CP.RazonSocial, 
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecFac.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Ord.IdRenglonOrden = D_RecepFac.IdRenglonOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio) 
AND TC.IdChequesAgrupador <> 0 
AND TC.Status in ('L')
AND (D_Ord.PorcIva Between 7.01 and 8.99)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, TC.Fecha, T_Ord.IdOrden
,T_Ord.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'V' as Tipo, D_Viaticos.IdProveedor, CP.RFC, CP.RazonSocial, 
IVA_PORC as Tasa, 
8 AS 'IVA', 
D_Viaticos.Importe AS Importe, 
--Justificacion, Referencia,
T_Viaticos.IdViaticos,
TPol.Fecha,
CONCAT(TPol.TipoPoliza,' ',TPol.Periodo,' ',TPol.NoPoliza) AS Poliza, TPol.IdPoliza
FROM T_Viaticos INNER JOIN D_Viaticos 
ON T_Viaticos.IdViaticos = D_Viaticos.IdViatico
LEFT JOIN C_Proveedores CP
  ON D_Viaticos.IdProveedor = CP.IdProveedor 
INNER JOIN T_Polizas TPol
ON T_Viaticos.IdPoliza = TPol.IdPoliza
Where (MONTH(T_Viaticos.Fecha) = @mes AND YEAR(T_Viaticos.Fecha) = @Ejercicio)  
AND (D_Viaticos.IVA_PORC Between 7.01 and 8.99)
AND T_Viaticos.Estatus = 'A'
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
--GROUP BY D_Viaticos.IdProveedor, TPol.Periodo, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, T_Viaticos.IdViaticos, TPol.Fecha
ORDER BY IdProveedor


-----------------------------*************0%*********************--------------------------------
DECLARE @ACT_IVA0 AS TABLE (Tipo varchar(10),IdProveedor INT, RFC varchar(50), RazonSocial varchar(250),Tasa float, IVA Decimal(18,2), Importe Decimal(18,2), IdPedido int, Fecha datetime, Poliza Varchar(MAX), IdPoliza Varchar(MAX))  
INSERT INTO @ACT_IVA0 
SELECT 'OC', T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa,
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
 T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido = T_Pedidos.IdPedido INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecepcionFacturas.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Pedidos.IdRenglonPedido = D_RecepFac.IdRenglonPedido INNER JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques TC 
ON TC.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_Pedidos.PorcIva = 0 and D_Pedidos.TipoIVA = 2)
 --AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Pedidos.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza,TC.Fecha, T_Pedidos.IdPedido
,T_Pedidos.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC,CP,RazonSocial

-- GROUP BY T_Pedidos.IdProveedor, T_Cheques.ImporteCheque

UNION ALL 

SELECT 'OC-A' as Tipo, 
--D_Pedidos.IdPedido, 
T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa, 
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM  D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor
INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque =T_Pedidos.IdSolicitudChequesAnticipo 
WHERE (D_Pedidos.PorcIva = 0 and D_Pedidos.TipoIVA = 2)
--AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
--Group by T_Pedidos.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza,TC.Fecha, T_Pedidos.IdPedido
--,T_Pedidos.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial
Group by T_Pedidos.IdProveedor, CP.RFC, CP.RazonSocial, T_Pedidos.IdPedido, TC.Fecha, TC.IdChequesAgrupador, TC.FolioCheque, TC.Status,
TC.IdCheques

UNION ALL

SELECT 'OC-C', T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa,
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
--SUM(CONVERT(Decimal(18,2),(TC.ImporteCheque/1.08))) AS 'SubTotal', Concepto, ConceptoPago
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido = T_Pedidos.IdPedido INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecepcionFacturas.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Pedidos.IdRenglonPedido = D_RecepFac.IdRenglonPedido INNER JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques  TC 
ON TC.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_Pedidos.PorcIva = 0 and D_Pedidos.TipoIVA = 2)

 --AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador <> 0 
AND TC.Status in ('L')
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Pedidos.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza,TC.Fecha, T_Pedidos.IdPedido
,T_Pedidos.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'OS',T_Ord.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecFac.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Ord.IdRenglonOrden = D_RecepFac.IdRenglonOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques TC   
ON TC.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND (D_Ord.PorcIva = 0 and D_Ord.TipoIVA = 2)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, TC.Fecha, T_Ord.IdOrden
,T_Ord.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'OS-A' as Tipo, 
T_Ord.IdProveedor,
CP.RFC,
CP.RazonSocial, 
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque =T_Ord.IdSolicitudChequesAnticipo 
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND (D_Ord.PorcIva = 0 and D_Ord.TipoIVA = 2)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, CP.RFC, CP.RazonSocial, T_Ord.IdOrden, TC.Fecha, TC.IdChequesAgrupador, TC.FolioCheque, TC.Status,
TC.IdCheques

UNION ALL

SELECT 'OS-C' as Tipo, 
T_Ord.IdProveedor,
CP.RFC,
CP.RazonSocial, 
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecFac.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Ord.IdRenglonOrden = D_RecepFac.IdRenglonOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio 
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND TC.IdChequesAgrupador <> 0 
AND TC.Status in ('L')
AND (D_Ord.PorcIva = 0 and D_Ord.TipoIVA = 2)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, TC.Fecha, T_Ord.IdOrden
,T_Ord.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'V' as Tipo, D_Viaticos.IdProveedor, CP.RFC, CP.RazonSocial, 
IVA_PORC as Tasa, 
0 AS 'IVA', 
D_Viaticos.Importe AS Importe, 
--Justificacion, Referencia,
T_Viaticos.IdViaticos,
TPol.Fecha,
CONCAT(TPol.TipoPoliza,' ',TPol.Periodo,' ',TPol.NoPoliza) AS Poliza, TPol.IdPoliza
FROM T_Viaticos INNER JOIN D_Viaticos 
ON T_Viaticos.IdViaticos = D_Viaticos.IdViatico
LEFT JOIN C_Proveedores CP
  ON D_Viaticos.IdProveedor = CP.IdProveedor 
INNER JOIN T_Polizas TPol
ON T_Viaticos.IdPoliza = TPol.IdPoliza
Where (MONTH(T_Viaticos.Fecha) = @mes AND YEAR(T_Viaticos.Fecha) = @Ejercicio)  
AND (D_Viaticos.IVA_PORC = 0 and D_Viaticos.IdTipoIVA = 2)
AND T_Viaticos.Estatus = 'A'
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
--GROUP BY D_Viaticos.IdProveedor, TPol.Periodo, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, T_Viaticos.IdViaticos, TPol.Fecha
ORDER BY IdProveedor




-----------------------------**********************************---------------------------------
-----------------------------*************Exento*********************--------------------------------
DECLARE @ACT_IVAExento AS TABLE (Tipo varchar(10),IdProveedor INT,RFC varchar(50), RazonSocial varchar(250), Tasa float, IVA Decimal(18,2), Importe Decimal(18,2), IdPedido int, Fecha datetime, Poliza Varchar(MAX), IdPoliza Varchar(MAX))  
INSERT INTO @ACT_IVAExento 
SELECT 'OC', T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa,
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido = T_Pedidos.IdPedido INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecepcionFacturas.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Pedidos.IdRenglonPedido = D_RecepFac.IdRenglonPedido INNER JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques TC   
ON TC.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_Pedidos.PorcIva = 0 and D_Pedidos.TipoIVA = 3)
-- AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Pedidos.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza,TC.Fecha, T_Pedidos.IdPedido
,T_Pedidos.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

-- GROUP BY T_Pedidos.IdProveedor, T_Cheques.ImporteCheque

UNION ALL 


SELECT 'OC-A' as Tipo, 
--D_Pedidos.IdPedido, 
T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa, 
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM  D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor 
INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque =T_Pedidos.IdSolicitudChequesAnticipo 
WHERE (D_Pedidos.PorcIva = 0 and D_Pedidos.TipoIVA = 3)
--AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
--Group by T_Pedidos.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza,TC.Fecha, T_Pedidos.IdPedido
--,T_Pedidos.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial
Group by T_Pedidos.IdProveedor, CP.RFC, CP.RazonSocial, T_Pedidos.IdPedido, TC.Fecha, TC.IdChequesAgrupador, TC.FolioCheque, TC.Status,
TC.IdCheques

UNION ALL

SELECT 'OC-C', T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa,
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
--SUM(CONVERT(Decimal(18,2),(TC.ImporteCheque/1.08))) AS 'SubTotal', Concepto, ConceptoPago
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido = T_Pedidos.IdPedido INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecepcionFacturas.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Pedidos.IdRenglonPedido = D_RecepFac.IdRenglonPedido INNER JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques  TC 
ON TC.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_Pedidos.PorcIva = 0 and D_Pedidos.TipoIVA = 3)

 --AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador <> 0 
AND TC.Status in ('L')
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Pedidos.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza,TC.Fecha, T_Pedidos.IdPedido
,T_Pedidos.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'OS',T_Ord.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecFac.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Ord.IdRenglonOrden = D_RecepFac.IdRenglonOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND (D_Ord.PorcIva = 0 and D_Ord.TipoIVA = 3)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, TC.Fecha, T_Ord.IdOrden
,T_Ord.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'OS-A' as Tipo, 
T_Ord.IdProveedor,
CP.RFC,
CP.RazonSocial, 
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque =T_Ord.IdSolicitudChequesAnticipo 
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND (D_Ord.PorcIva = 0 and D_Ord.TipoIVA = 3)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, CP.RFC, CP.RazonSocial, T_Ord.IdOrden, TC.Fecha, TC.IdChequesAgrupador, TC.FolioCheque, TC.Status,
TC.IdCheques

UNION ALL

SELECT 'OS-C' as Tipo, 
T_Ord.IdProveedor,
CP.RFC,
CP.RazonSocial, 
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecFac.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Ord.IdRenglonOrden = D_RecepFac.IdRenglonOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio 
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND TC.IdChequesAgrupador <> 0 
AND TC.Status in ('L')
AND (D_Ord.PorcIva = 0 and D_Ord.TipoIVA = 3)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, TC.Fecha, T_Ord.IdOrden
,T_Ord.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'V' as Tipo, D_Viaticos.IdProveedor, CP.RFC, CP.RazonSocial, 
IVA_PORC as Tasa, 
0 AS 'IVA', 
D_Viaticos.Importe AS Importe, 
--Justificacion, Referencia,
T_Viaticos.IdViaticos,
TPol.Fecha,
CONCAT(TPol.TipoPoliza,' ',TPol.Periodo,' ',TPol.NoPoliza) AS Poliza, TPol.IdPoliza
FROM T_Viaticos INNER JOIN D_Viaticos 
ON T_Viaticos.IdViaticos = D_Viaticos.IdViatico
LEFT JOIN C_Proveedores CP
  ON D_Viaticos.IdProveedor = CP.IdProveedor 
INNER JOIN T_Polizas TPol
ON T_Viaticos.IdPoliza = TPol.IdPoliza
Where (MONTH(T_Viaticos.Fecha) = @mes AND YEAR(T_Viaticos.Fecha) = @Ejercicio)  
AND (D_Viaticos.IVA_PORC = 0 and D_Viaticos.IdTipoIVA = 3)
AND T_Viaticos.Estatus = 'A'
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
--GROUP BY D_Viaticos.IdProveedor, TPol.Periodo, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, T_Viaticos.IdViaticos, TPol.Fecha
ORDER BY IdProveedor  


-----------------------------**********************************---------------------------------
-----------------------------***********Otros******************---------------------------------

DECLARE @ACT_IVAOtros AS TABLE (Tipo varchar(10),IdProveedor INT, RFC varchar(50), RazonSocial varchar(250),Tasa float, IVA Decimal(18,2), Importe Decimal(18,2), IdPedido int, Fecha datetime, Poliza Varchar(MAX), IdPoliza Varchar(MAX))  
INSERT INTO @ACT_IVAOtros 
SELECT 'OC', T_Pedidos.IdProveedor,
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa,
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido = T_Pedidos.IdPedido INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecepcionFacturas.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Pedidos.IdRenglonPedido = D_RecepFac.IdRenglonPedido INNER JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_Pedidos.PorcIva not Between 7.01 and 8.99) and (D_Pedidos.PorcIva  not Between 15.01 and 16.99) and (D_Pedidos.PorcIva <>0)
-- AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Pedidos.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza,TC.Fecha, T_Pedidos.IdPedido
,T_Pedidos.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

-- GROUP BY T_Pedidos.IdProveedor, T_Cheques.ImporteCheque

UNION ALL 

SELECT 'OC-A' as Tipo, 
--D_Pedidos.IdPedido, 
T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa, 
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM  D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor
INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque =T_Pedidos.IdSolicitudChequesAnticipo 
WHERE (D_Pedidos.PorcIva not Between 7.01 and 8.99) and (D_Pedidos.PorcIva  not Between 15.01 and 16.99) and (D_Pedidos.PorcIva <>0)
--AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
--Group by T_Pedidos.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza,TC.Fecha, T_Pedidos.IdPedido
--,T_Pedidos.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial
Group by T_Pedidos.IdProveedor, CP.RFC, CP.RazonSocial, T_Pedidos.IdPedido, TC.Fecha, TC.IdChequesAgrupador, TC.FolioCheque, TC.Status,
TC.IdCheques

UNION ALL

SELECT 'OC-C', T_Pedidos.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa,
SUM((D_Pedidos.IVA)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) AS 'IVA', 
--SUM(CONVERT(Decimal(18,2),(TC.ImporteCheque/1.08))) AS 'SubTotal', Concepto, ConceptoPago
SUM((D_Pedidos.Importe)*((1*TC.Importecheque)/T_Pedidos.TotalGral)) as Importe,
T_Pedidos.IdPedido,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = D_Pedidos.IdPedido 
LEFT JOIN C_Proveedores CP
    ON T_Pedidos.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido = T_Pedidos.IdPedido INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecepcionFacturas.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Pedidos.IdRenglonPedido = D_RecepFac.IdRenglonPedido INNER JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques  TC 
ON TC.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_Pedidos.PorcIva not Between 7.01 and 8.99) and (D_Pedidos.PorcIva  not Between 15.01 and 16.99) and (D_Pedidos.PorcIva <>0)

 --AND T_Pedidos.TipodeCambio = 0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)  
AND TC.IdChequesAgrupador <> 0 
AND TC.Status in ('L')
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Pedidos.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza,TC.Fecha, T_Pedidos.IdPedido
,T_Pedidos.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'OS',T_Ord.IdProveedor, 
CP.RFC,
CP.RazonSocial,
AVG(PorcIva) as Tasa,
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecFac.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Ord.IdRenglonOrden = D_RecepFac.IdRenglonOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques TC 
ON TC.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND (D_Ord.PorcIva not Between 7.01 and 8.99) and (D_Ord.PorcIva  not Between 15.01 and 16.99) and (D_Ord.PorcIva <>0)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, TC.Fecha, T_Ord.IdOrden
,T_Ord.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'OS-A' as Tipo, 
T_Ord.IdProveedor,
CP.RFC,
CP.RazonSocial, 
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque =T_Ord.IdSolicitudChequesAnticipo 
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio)
AND (D_Ord.PorcIva not Between 7.01 and 8.99) and (D_Ord.PorcIva  not Between 15.01 and 16.99) and (D_Ord.PorcIva <>0)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, CP.RFC, CP.RazonSocial, T_Ord.IdOrden, TC.Fecha, TC.IdChequesAgrupador, TC.FolioCheque, TC.Status,
TC.IdCheques

UNION ALL

SELECT 'OS-C' as Tipo, 
T_Ord.IdProveedor,
CP.RFC,
CP.RazonSocial, 
AVG(PorcIva) as Tasa, 
SUM((D_Ord.IVA)*((1*TC.Importecheque)/T_Ord.TotalGral)) AS 'IVA', 
SUM((D_Ord.Importe)*((1*TC.Importecheque)/T_Ord.TotalGral)) as Importe,
T_Ord.IdOrden,
TC.Fecha,
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable, 
CASE 
	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
ELSE	
(Select T_Polizas.IdPoliza from  T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS IdPoliza
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
LEFT JOIN C_Proveedores CP
    ON T_Ord.IdProveedor = CP.IdProveedor
INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN D_RecepcionFacturas D_RecepFac
ON T_RecFac.IdRecepcionServicios = D_RecepFac.IdRecepcionServicios 
	AND D_Ord.IdRenglonOrden = D_RecepFac.IdRenglonOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques TC  
ON TC.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio
(MONTH(TC.Fecha) = @mes and YEAR(TC.Fecha) = @Ejercicio) 
AND TC.IdChequesAgrupador <> 0 
AND TC.Status in ('L')
AND (D_Ord.PorcIva not Between 7.01 and 8.99) and (D_Ord.PorcIva  not Between 15.01 and 16.99) and (D_Ord.PorcIva <>0)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
Group by T_Ord.IdProveedor, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, TC.Fecha, T_Ord.IdOrden
,T_Ord.TotalGral, TC.ImporteCheque, TC.IdChequesAgrupador, TC.IdCheques, TC.FolioCheque, TC.Status, CP.RFC, CP.RazonSocial

UNION ALL

SELECT 'V' as Tipo, D_Viaticos.IdProveedor, CP.RFC, CP.RazonSocial, 
IVA_PORC as Tasa, 
0 AS 'IVA', 
D_Viaticos.Importe AS Importe, 
--Justificacion, Referencia,
T_Viaticos.IdViaticos,
TPol.Fecha,
CONCAT(TPol.TipoPoliza,' ',TPol.Periodo,' ',TPol.NoPoliza) AS Poliza, TPol.IdPoliza
FROM T_Viaticos INNER JOIN D_Viaticos 
ON T_Viaticos.IdViaticos = D_Viaticos.IdViatico
LEFT JOIN C_Proveedores CP
  ON D_Viaticos.IdProveedor = CP.IdProveedor 
INNER JOIN T_Polizas TPol
ON T_Viaticos.IdPoliza = TPol.IdPoliza
Where (MONTH(T_Viaticos.Fecha) = @mes AND YEAR(T_Viaticos.Fecha) = @Ejercicio)  
AND (D_Viaticos.IVA_PORC not Between 7.01 and 8.99) and (D_Viaticos.IVA_PORC  not Between 15.01 and 16.99) and (D_Viaticos.IVA_PORC != 0)
AND T_Viaticos.Estatus = 'A'
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
--GROUP BY D_Viaticos.IdProveedor, TPol.Periodo, TPol.Periodo, TPol.NoPoliza, TPol.IdPoliza, T_Viaticos.IdViaticos, TPol.Fecha
ORDER BY IdProveedor  


Select
CASE WHEN A.RazonSocial IS NOT NULL THEN A.RazonSocial
	 WHEN B.RazonSocial IS NOT NULL THEN B.RazonSocial
	 WHEN C.RazonSocial IS NOT NULL THEN C.RazonSocial
	 WHEN D.RazonSocial IS NOT NULL THEN D.RazonSocial
	 WHEN E.RazonSocial IS NOT NULL THEN E.RazonSocial
	 ELSE A.RazonSocial 
END as RazonSocial,
CASE WHEN A.RFC IS NOT NULL THEN A.RFC
	 WHEN B.RFC IS NOT NULL THEN B.RFC
	 WHEN C.RFC IS NOT NULL THEN C.RFC
	 WHEN D.RFC IS NOT NULL THEN D.RFC
	 WHEN E.RFC IS NOT NULL THEN E.RFC
	 ELSE A.RFC 
END as RFC,
CASE WHEN A.Poliza IS NOT NULL THEN A.Poliza
	 WHEN B.Poliza IS NOT NULL THEN B.Poliza
	 WHEN C.Poliza IS NOT NULL THEN C.Poliza
	 WHEN D.Poliza IS NOT NULL THEN D.Poliza
	 WHEN E.Poliza IS NOT NULL THEN E.Poliza
	 ELSE A.Poliza 
END as Poliza,
CASE WHEN A.Fecha IS NOT NULL THEN A.Fecha
	 WHEN B.Fecha IS NOT NULL THEN B.Fecha
	 WHEN C.Fecha IS NOT NULL THEN C.Fecha
	 WHEN D.Fecha IS NOT NULL THEN D.Fecha
	 WHEN E.Fecha IS NOT NULL THEN E.Fecha
	 ELSE A.Fecha 
END as Fecha,
	   A.Tipo as Tipo16,   A.IdProveedor as IdProveedor16,   ISNULL(A.Tasa,0) as Tasa16,   ISNULL(A.IVA,0) as IVA16,   ISNULL(A.Importe,0) as Importe16,   A.IdPedido as IdPedido16,   A.Fecha as Fecha16,   A.Poliza as Poliza16,   A.IdPoliza as IdPoliza16,   A.RFC as RFC16,   A.RazonSocial as RazonSocial16, 
	   B.Tipo as Tipo8,    B.IdProveedor as IdProveedor8,    ISNULL(B.Tasa,0) as Tasa8,    ISNULL(B.IVA,0) as IVA8,    ISNULL(B.Importe,0) as Importe8,    B.IdPedido as IdPedido8,    B.Fecha as Fecha8,    B.Poliza as Poliza8,    B.IdPoliza as IdPoliza8,    B.RFC as RFC8,    B.RazonSocial as RazonSocial8, 
	   C.Tipo as Tipo0,    C.IdProveedor as IdProveedor0,    ISNULL(C.Tasa,0) as Tasa0,    ISNULL(C.IVA,0) as IVA0,    ISNULL(C.Importe,0) as Importe0,    C.IdPedido as IdPedido0,    C.Fecha as Fecha0,    C.Poliza as Poliza0,    C.IdPoliza as IdPoliza0,    C.RFC as RFC0,    C.RazonSocial as RazonSocial0,
	   D.Tipo as TipoExc,  D.IdProveedor as IdProveedorExc,  ISNULL(D.Tasa,0) as TasaExc,  ISNULL(D.IVA,0) as IVAExc,  ISNULL(D.Importe,0) as ImporteExc,  D.IdPedido as IdPedidoExc,  D.Fecha as FechaExc,  D.Poliza as PolizaExc,  D.IdPoliza as IdPolizaExc,  D.RFC as RFCExc,  D.RazonSocial as RazonSocialExc,
	   E.Tipo as TipoOtro, E.IdProveedor as IdProveedorOtro, ISNULL(E.Tasa,0) as TasaOtro, ISNULL(E.IVA,0) as IVAOtro, ISNULL(E.Importe,0) as ImporteOtro, E.IdPedido as IdPedidoOtro, E.Fecha as FechaOtro, E.Poliza as PolizaOtro, E.IdPoliza as IdPolizaOtro, E.RFC as RFCOtro, E.RazonSocial as RazonSocialOtro,
	   ISNULL(A.IVA,0) + ISNULL(B.IVA,0) + ISNULL(C.IVA,0) + ISNULL(D.IVA,0) + ISNULL(E.IVA,0) as TotalIVA
from @ACT_IVA16 A full JOIN @ACT_IVA8 B ON A.IdPedido = B.IdPedido AND A.IdPoliza = B.IdPoliza
	full JOIN @ACT_IVA0 C ON A.IdPedido = C.IdPedido AND A.IdPoliza = C.IdPoliza
	full JOIN @ACT_IVAExento D ON A.IdPedido = D.IdPedido AND A.IdPoliza = D.IdPoliza
	full JOIN @ACT_IVAOtros E ON A.IdPedido = E. IdPedido AND A.IdPoliza = E.IdPoliza

GO
--Exec SP_RPT_K2_Auxiliar_DIOT 8,2020,0

Exec SP_CFG_LogScripts 'SP_RPT_K2_Auxiliar_DIOT','2.30'
GO