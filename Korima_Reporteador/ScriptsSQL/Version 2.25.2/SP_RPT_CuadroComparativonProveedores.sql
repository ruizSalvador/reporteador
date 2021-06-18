/****** Object:  StoredProcedure [dbo].[SP_RPT_CuadroComparativonProveedores]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CuadroComparativonProveedores]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CuadroComparativonProveedores]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CuadroComparativonProveedores]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_RPT_CuadroComparativonProveedores 134
CREATE PROCEDURE [dbo].[SP_RPT_CuadroComparativonProveedores]

@IdCotizacion int

AS
BEGIN

CREATE TABLE #Todo (
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

	Insert into #Todo
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


DECLARE @cols AS NVARCHAR(MAX),
        @query AS NVARCHAR(MAX),
		@query2 AS VARCHAR(MAX);

SET @cols = STUFF((SELECT distinct ',' + QUOTENAME(c.RazonSocial) 
            FROM #Todo c
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

set @query = 'SELECT DescripcionGenerica, Cantidad, ' + @cols + ' from 
            (
                select DescripcionGenerica, Cantidad
                    , Importe
                    , RazonSocial
                from #Todo 
           ) x
            pivot 
            (
                 max(Importe)
                for RazonSocial in (' + @cols + ')
            ) p ORDER BY DescripcionGenerica'
			
Execute(@query)

Drop Table #Todo

END
GO