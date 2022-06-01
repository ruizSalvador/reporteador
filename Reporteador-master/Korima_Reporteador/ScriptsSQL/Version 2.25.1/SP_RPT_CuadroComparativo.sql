/****** Object:  StoredProcedure [dbo].[SP_RPT_CuadroComparativo]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CuadroComparativo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CuadroComparativo]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CuadroComparativo]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_RPT_CuadroComparativo 137
CREATE PROCEDURE [dbo].[SP_RPT_CuadroComparativo]

@IdCotizacion int

AS
BEGIN

DECLARE @Todo as table (
	Fecha Datetime,
	Cantidad float,
	CostoUnitario Decimal (18,2),
	Importe Decimal (18,2),
	IVA Decimal (18,2),
	TotalGral Decimal (18,2),
	IdCodigoProducto varchar(max),
	DescripcionGenerica varchar(max),
	RazonSocial Varchar(max),
	Orden int
	)

	DECLARE @Data1 as table (
	Fecha Datetime,
	Cantidad float,
	CostoUnitario Decimal (18,2),
	Importe Decimal (18,2),
	IVA Decimal (18,2),
	TotalGral Decimal (18,2),
	IdCodigoProducto varchar(max),
	DescripcionGenerica varchar(max),
	RazonSocial Varchar(max),
	Orden int
	)

	DECLARE @Data2 as table (
	Fecha Datetime,
	Cantidad float,
	CostoUnitario Decimal (18,2),
	Importe Decimal (18,2),
	IVA Decimal (18,2),
	TotalGral Decimal (18,2),
	IdCodigoProducto varchar(max),
	DescripcionGenerica varchar(max),
	RazonSocial Varchar(max),
	Orden int
	)

	DECLARE @Data3 as table (
	Fecha Datetime,
	Cantidad float,
	CostoUnitario Decimal (18,2),
	Importe Decimal (18,2),
	IVA Decimal (18,2),
	TotalGral Decimal (18,2),
	IdCodigoProducto varchar(max),
	DescripcionGenerica varchar(max),
	RazonSocial Varchar(max),
	Orden int
	)

	DECLARE @Data4 as table (
	Fecha Datetime,
	Cantidad float,
	CostoUnitario Decimal (18,2),
	Importe Decimal (18,2),
	IVA Decimal (18,2),
	TotalGral Decimal (18,2),
	IdCodigoProducto varchar(max),
	DescripcionGenerica varchar(max),
	RazonSocial Varchar(max),
	Orden int
	)

	DECLARE @Data5 as table (
	Fecha Datetime,
	Cantidad float,
	CostoUnitario Decimal (18,2),
	Importe Decimal (18,2),
	IVA Decimal (18,2),
	TotalGral Decimal (18,2),
	IdCodigoProducto varchar(max),
	DescripcionGenerica varchar(max),
	RazonSocial Varchar(max),
	Orden int
	)

	DECLARE @Data6 as table (
	Fecha Datetime,
	Cantidad float,
	CostoUnitario Decimal (18,2),
	Importe Decimal (18,2),
	IVA Decimal (18,2),
	TotalGral Decimal (18,2),
	IdCodigoProducto varchar(max),
	DescripcionGenerica varchar(max),
	RazonSocial Varchar(max),
	Orden int
	)
	DECLARE @Data7 as table (
	Fecha Datetime,
	Cantidad float,
	CostoUnitario Decimal (18,2),
	Importe Decimal (18,2),
	IVA Decimal (18,2),
	TotalGral Decimal (18,2),
	IdCodigoProducto varchar(max),
	DescripcionGenerica varchar(max),
	RazonSocial Varchar(max),
	Orden int
	)



Insert into @Todo
Select TC.Fecha, Cantidad, CostoUnitario, Importe, DC.IVA, (Importe + DC.IVA) as TotalGral, CM.IdCodigoProducto, DescripcionGenerica, RazonSocial,
DENSE_RANK() OVER (ORDER BY [RazonSocial]) as Orden 
from T_Cotizaciones TC
LEFT JOIN T_CotizacionesProv TCPR
ON TC.IdCotizacion = TCPR.IdCotizacion
LEFT JOIN D_Cotizaciones DC
ON TCPR.IdCotizacionProv = DC.IdCotizacion
LEFT JOIN C_Proveedores CP
ON CP.IdProveedor = TCPR.IdProveedor
LEFT JOIN C_Maestro CM
ON DC.IdCodigoProducto = CM.IdCodigoProducto and DC.IdGrupo = CM.IdGrupo and DC.IdSubgrupo = CM.IdSubgrupo
Where TC.IdCotizacion = @IdCotizacion
Order by RazonSocial

Insert Into @Data1
Select * from @Todo Where Orden = 1

Insert Into @Data2
Select * from @Todo Where Orden = 2

Insert Into @Data3
Select * from @Todo Where Orden = 3

Insert Into @Data4
Select * from @Todo Where Orden = 4

Insert Into @Data5
Select * from @Todo Where Orden = 5

Insert Into @Data6
Select * from @Todo Where Orden = 6

Insert Into @Data7
Select * from @Todo Where Orden = 7

Select
	   D1.Fecha as Fecha,
	   D1.DescripcionGenerica as DG1,
	   D1.Cantidad as SOL1,
	   D1.RazonSocial as RS1,
	   D1.CostoUnitario as  PU1,
	   D1.Importe as IMP1,
	   D1.IVA as IVA1,
	   D1.TotalGral TOT1,
	   D2.RazonSocial as RS2,
	   D2.CostoUnitario as  PU2,
	   D2.Importe as IMP2,
	   D2.IVA as IVA2,
	   D2.TotalGral TOT2,
	   D3.RazonSocial as RS3,
	   D3.CostoUnitario as  PU3,
	   D3.Importe as IMP3,
	   D3.IVA as IVA3,
	   D3.TotalGral as TOT3,
	   D4.RazonSocial as RS4,
	   D4.CostoUnitario as  PU4,
	   D4.Importe as IMP4,
	   D4.IVA as IVA4,
	   D4.TotalGral as TOT4,
	   D5.RazonSocial as RS5,
	   D5.CostoUnitario as  PU5,
	   D5.Importe as IMP5,
	   D5.IVA as IVA5,
	   D5.TotalGral as TOT5,
	   D6.RazonSocial as RS6,
	   D6.CostoUnitario as  PU6,
	   D6.Importe as IMP6,
	   D6.IVA as IVA6,
	   D6.TotalGral as TOT6,
	   D7.RazonSocial as RS7,
	   D7.CostoUnitario as PU7,
	   D7.Importe as IMP7,
	   D7.IVA as IVA7,
	   D7.TotalGral as TOT7

	   FROM @Data1 D1
	   LEFT JOIN @Data2 D2
	   ON D1.IdCodigoProducto = D2.IdCodigoProducto
	   LEFT JOIN @Data3 D3
	   ON D1.IdCodigoProducto = D3.IdCodigoProducto
	   LEFT JOIN @Data4 D4
	   ON D1.IdCodigoProducto = D4.IdCodigoProducto
	   LEFT JOIN @Data5 D5
	   ON D1.IdCodigoProducto = D5.IdCodigoProducto
	   LEFT JOIN @Data6 D6
	   ON D1.IdCodigoProducto = D6.IdCodigoProducto
	   LEFT JOIN @Data7 D7
	   ON D1.IdCodigoProducto = D7.IdCodigoProducto

END
GO


EXEC SP_FirmasReporte 'Cuadro Comparativo'
GO

Exec SP_CFG_LogScripts 'SP_RPT_CuadroComparativo'
GO