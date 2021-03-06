
/****** Object:  StoredProcedure [dbo].[dbo].[SP_RPT_MovimientosProducto]   Script Date: 03/08/2018 10:45:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_MovimientosProducto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_MovimientosProducto]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_MovimientosProducto]    Script Date: 22/08/2018 05:56:47 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_MovimientosProducto '20170101','20190830',1,2,15136,2,25,2558
--Exec SP_RPT_MovimientosProducto '20180101','20180830',1,'5070'
CREATE PROCEDURE [dbo].[SP_RPT_MovimientosProducto] 
  
@FechaIni as Datetime,
@FechaFin as Datetime,
@IdAlmacen as int,
@CodigoInterno as varchar(250),
@TipoMovimiento as varchar(250),
@IdCodigoProducto   as int,
@IdGrupo as int,
@IdSubGrupo as int


--@IdGrupo int,
--@IdSubGrupo int,
--@IdProducto int

AS
BEGIN

declare @Total as float

 Declare @tabla as table (
      IdAlmacen int
      ,IdGrupo int
      ,IdSubgrupo int
	  ,IdProducto int
	  ,Renglon int
	  ,TipoMov varchar(250)
	  ,Cantidad int
	  ,CostoUnitario Decimal(20,2)
	  ,Fecha  Datetime
 )

 IF @TipoMovimiento !='0'
 Begin
        

Declare @Movproducto as TABLE(
Fecha DATETIME,
Folio int,
TipoMov VARCHAR(1),
DescripcionTipoMovimiento VARCHAR(max),
Cantidad float,
Costo float,
Importe float,
DescripcionGenerica varchar(255),
CodigoCambs varchar(200)
)

		   IF @TipoMovimiento ='TodasLasEntradas'
	       Begin
            
		insert INTO @Movproducto 
		(Fecha,Folio,TipoMov,DescripcionTipoMovimiento ,Cantidad ,Costo ,Importe ,DescripcionGenerica ,CodigoCambs)(Select convert(date,CONVERT(varchar(10), T_MovimientosAlmacen.Fecha, 103),103) as Fecha, 
            Folio, T_MovimientosAlmacen.TipoMov,
            C_TipoMovAlmacen.DescripcionTipoMovimiento, D_MovimientosAlmacen.Cantidad, 
            D_MovimientosAlmacen.Costo, (D_MovimientosAlmacen.Cantidad * D_MovimientosAlmacen.Costo) as Importe,
            C_Maestro.DescripcionGenerica,
			C_Maestro.CodigoCambs
            from T_MovimientosAlmacen 
	        Inner Join D_MovimientosAlmacen On 
		    T_MovimientosAlmacen.IdMovimiento = D_MovimientosAlmacen.IdMovimiento
	        Inner Join C_TipoMovAlmacen On
		    T_MovimientosAlmacen.IdTipoMov = C_TipoMovAlmacen.IdTipoMovimiento
	        Inner Join C_Maestro On
		    C_Maestro.IdGrupo = D_MovimientosAlmacen.IdGrupo and C_Maestro.IdSubgrupo = D_MovimientosAlmacen.IdSubGrupo
		    and C_Maestro.IdCodigoProducto = D_MovimientosAlmacen.IdProducto
			Where T_MovimientosAlmacen.Fecha >= @FechaIni 
			and T_MovimientosAlmacen.Fecha <= @FechaFin
	        and T_MovimientosAlmacen.TipoMov IN ('E','S') 
			and T_MovimientosAlmacen.IdAlmacen = @IdAlmacen
	       -- and C_Maestro.CodigoCambs =	@CodigoInterno
			and T_MovimientosAlmacen.TipoMov  = 'E'
		    and C_Maestro.IdGrupo =   @IdGrupo 
			and C_Maestro.IdSubGrupo = @IdSubGrupo 
			and C_Maestro.IdCodigoProducto =  @IdCodigoProducto 
	        --and C_TipoMovAlmacen.DescripcionTipoMovimiento =    @TipoMovimiento
		    --and C_TipoMovAlmacen.DescripcionTipoMovimiento =    'POR INICIALIZACION'
	        --order by Fecha, TipoMov)
			)
			--set @Total = (select sum(Importe) from @Movproducto )

			--insert @Movproducto (importe)values(@Total)

			

			
	        SELECT 
			Fecha,
            Folio,
            TipoMov,
            DescripcionTipoMovimiento ,
            Cantidad ,
            Costo ,
             Importe ,
            DescripcionGenerica ,
            CodigoCambs 
			FROM @Movproducto 
			order by Fecha, TipoMov
	       -- Else

	       End

		   IF @TipoMovimiento ='TodasLasSalidas'
	       Begin
          insert INTO @Movproducto 
		 (Fecha,Folio,TipoMov,DescripcionTipoMovimiento ,Cantidad ,Costo ,Importe ,DescripcionGenerica ,CodigoCambs) (  Select convert(date,CONVERT(varchar(10), T_MovimientosAlmacen.Fecha, 103),103) as Fecha, 
            Folio, T_MovimientosAlmacen.TipoMov,
            C_TipoMovAlmacen.DescripcionTipoMovimiento, D_MovimientosAlmacen.Cantidad, 
            D_MovimientosAlmacen.Costo, (D_MovimientosAlmacen.Cantidad * D_MovimientosAlmacen.Costo) as Importe,
            C_Maestro.DescripcionGenerica,
			C_Maestro.CodigoCambs
            from T_MovimientosAlmacen 
	        Inner Join D_MovimientosAlmacen On 
		    T_MovimientosAlmacen.IdMovimiento = D_MovimientosAlmacen.IdMovimiento
	        Inner Join C_TipoMovAlmacen On
		    T_MovimientosAlmacen.IdTipoMov = C_TipoMovAlmacen.IdTipoMovimiento
	        Inner Join C_Maestro On
		    C_Maestro.IdGrupo = D_MovimientosAlmacen.IdGrupo and C_Maestro.IdSubgrupo = D_MovimientosAlmacen.IdSubGrupo
		    and C_Maestro.IdCodigoProducto = D_MovimientosAlmacen.IdProducto
	        Where T_MovimientosAlmacen.Fecha >= @FechaIni 
			and T_MovimientosAlmacen.Fecha <= @FechaFin
	        and T_MovimientosAlmacen.TipoMov IN ('E','S') 
			and T_MovimientosAlmacen.IdAlmacen = @IdAlmacen
	        --and C_Maestro.CodigoCambs =	@CodigoInterno
			and T_MovimientosAlmacen.TipoMov  = 'S'
			and C_Maestro.IdGrupo =   @IdGrupo 
			and C_Maestro.IdSubGrupo = @IdSubGrupo 
			and C_Maestro.IdCodigoProducto =  @IdCodigoProducto 
	        --and C_TipoMovAlmacen.DescripcionTipoMovimiento =    @TipoMovimiento
		    --and C_TipoMovAlmacen.DescripcionTipoMovimiento =    'POR INICIALIZACION'
	       -- order by Fecha, TipoMov
			)
			--set @Total = (select sum(Importe) from @Movproducto )

			--insert @Movproducto (importe)values(@Total)

	        SELECT 
			Fecha,
            Folio,
            TipoMov,
            DescripcionTipoMovimiento ,
            Cantidad ,
            Costo ,
             Importe ,
            DescripcionGenerica ,
            CodigoCambs 
			FROM @Movproducto
			order by Fecha, TipoMov
			--SELECT * FROM @Movproducto 
	        --and IdGrupo = @IdGrupo and IdSubGrupo = @IdSubGrupo and IdProducto = @IdProducto
	       -- Else

	       End
		   

		     IF @TipoMovimiento !='TodasLasEntradas' OR @TipoMovimiento != 'TodasLasEntradas'
	       Begin
		   insert INTO @Movproducto (Fecha,Folio,TipoMov,DescripcionTipoMovimiento ,Cantidad ,Costo ,Importe ,DescripcionGenerica ) 
		 (Select convert(date,CONVERT(varchar(10), T_MovimientosAlmacen.Fecha, 103),103) as Fecha, 
            Folio, T_MovimientosAlmacen.TipoMov,
            C_TipoMovAlmacen.DescripcionTipoMovimiento, D_MovimientosAlmacen.Cantidad, 
            D_MovimientosAlmacen.Costo, (D_MovimientosAlmacen.Cantidad * D_MovimientosAlmacen.Costo) as Importe,
            C_Maestro.DescripcionGenerica
            from T_MovimientosAlmacen 
	        Inner Join D_MovimientosAlmacen On 
		    T_MovimientosAlmacen.IdMovimiento = D_MovimientosAlmacen.IdMovimiento
	        Inner Join C_TipoMovAlmacen On
		    T_MovimientosAlmacen.IdTipoMov = C_TipoMovAlmacen.IdTipoMovimiento
	        Inner Join C_Maestro On
		    C_Maestro.IdGrupo = D_MovimientosAlmacen.IdGrupo and C_Maestro.IdSubgrupo = D_MovimientosAlmacen.IdSubGrupo
		    and C_Maestro.IdCodigoProducto = D_MovimientosAlmacen.IdProducto
	        Where T_MovimientosAlmacen.Fecha >= @FechaIni and T_MovimientosAlmacen.Fecha <= @FechaFin
	        and T_MovimientosAlmacen.TipoMov IN ('E','S') and T_MovimientosAlmacen.IdAlmacen = @IdAlmacen
	        --and C_Maestro.CodigoCambs =	@CodigoInterno
	        and C_TipoMovAlmacen.DescripcionTipoMovimiento =    @TipoMovimiento
			and C_Maestro.IdGrupo =   @IdGrupo 
			and C_Maestro.IdSubGrupo = @IdSubGrupo 
			and C_Maestro.IdCodigoProducto =  @IdCodigoProducto 
		    --and C_TipoMovAlmacen.DescripcionTipoMovimiento =    'POR INICIALIZACION'
	       )
		   --set @Total = (select sum(Importe) from @Movproducto )
		   --insert @Movproducto (importe)values(@Total)

		   SELECT 
			Fecha,
            Folio,
            TipoMov,
            DescripcionTipoMovimiento ,
            Cantidad ,
            Costo ,
             Importe ,
            DescripcionGenerica ,
            CodigoCambs 
			FROM @Movproducto
			order by Fecha, TipoMov
	       -- SELECT * FROM @Movproducto
		   -- order by Fecha, TipoMov
	        --and IdGrupo = @IdGrupo and IdSubGrupo = @IdSubGrupo and IdProducto = @IdProducto
	       -- Else

	       End




	
END

else
BEGIN
    IF @TipoMovimiento ='0'
	BEGIN

     insert INTO @Movproducto 
		 (Fecha,Folio,TipoMov,DescripcionTipoMovimiento ,Cantidad ,Costo ,Importe ,DescripcionGenerica) 
		 ( Select convert(date,CONVERT(varchar(10), T_MovimientosAlmacen.Fecha, 103),103) as Fecha, 
     Folio, T_MovimientosAlmacen.TipoMov,
     C_TipoMovAlmacen.DescripcionTipoMovimiento, D_MovimientosAlmacen.Cantidad, 
     D_MovimientosAlmacen.Costo, (D_MovimientosAlmacen.Cantidad * D_MovimientosAlmacen.Costo) as Importe,
     C_Maestro.DescripcionGenerica
     from T_MovimientosAlmacen 
	Inner Join D_MovimientosAlmacen On 
		T_MovimientosAlmacen.IdMovimiento = D_MovimientosAlmacen.IdMovimiento
	Inner Join C_TipoMovAlmacen On
		T_MovimientosAlmacen.IdTipoMov = C_TipoMovAlmacen.IdTipoMovimiento
	Inner Join C_Maestro On
		C_Maestro.IdGrupo = D_MovimientosAlmacen.IdGrupo and C_Maestro.IdSubgrupo = D_MovimientosAlmacen.IdSubGrupo
		and C_Maestro.IdCodigoProducto = D_MovimientosAlmacen.IdProducto
	Where T_MovimientosAlmacen.Fecha >= @FechaIni 
	and T_MovimientosAlmacen.Fecha <= @FechaFin
	and T_MovimientosAlmacen.TipoMov IN ('E','S') 
	and T_MovimientosAlmacen.IdAlmacen = @IdAlmacen
	--and C_Maestro.CodigoCambs =	@CodigoInterno
	and C_Maestro.IdGrupo =   @IdGrupo 
	and C_Maestro.IdSubGrupo = @IdSubGrupo 
	and C_Maestro.IdCodigoProducto =  @IdCodigoProducto)
	--set @Total = (select sum(Importe) from @Movproducto )
	-- insert @Movproducto (importe)values(@Total)
	 SELECT 
			Fecha,
            Folio,
            TipoMov,
            DescripcionTipoMovimiento ,
            Cantidad ,
            Costo ,
               Importe ,
            DescripcionGenerica ,
            CodigoCambs 
			FROM @Movproducto
	       -- SELECT * FROM @Movproducto
	order by Fecha, TipoMov
	END


END

END

EXEC SP_FirmasReporte 'Movimientos de Producto'

GO

Exec SP_CFG_LogScripts 'SP_RPT_MovimientosProducto','2.29'
GO
