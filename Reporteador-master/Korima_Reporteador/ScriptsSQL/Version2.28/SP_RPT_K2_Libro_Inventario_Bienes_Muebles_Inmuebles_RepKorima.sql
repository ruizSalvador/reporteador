
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles_RepKorima]    Script Date: 10/23/2013 13:05:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles_RepKorima]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles_RepKorima]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles_RepKorima]    Script Date: 10/23/2013 13:05:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles_RepKorima]
@TipoBien varchar(max),
@Ejercicio Int,
@EjercicioFin Int,
@Periodo Int,
@PeriodoFin Int,
@EstatusBien varchar(max),
@EstadoBien varchar(max)
AS

-- Crear las fechas para el rango Del Al. Solicitado en el Bug. 929. amjm.
	DECLARE @dateini AS DATE;
	DECLARE @datefin AS DATE;
	DECLARE @datetemp AS DATE;
	Declare @diafinal as  int;

	If @PeriodoFin = 2 
	begin
	   set @diafinal = 28
	end

	If @PeriodoFin in (4,6,9,11) 
	begin
	   set @diafinal = 30
	end

	If @PeriodoFin in (1,3,5,7,8,10,12) 
	begin
	   set @diafinal = 31
	end

	set @dateini = cast(convert(datetime,convert(varchar(10),@Ejercicio) + '-' +
	 convert(varchar(10),@Periodo) + '-' +
	 convert(varchar(10),1), 101) as date);

	 set @datefin = cast(convert(datetime,convert(varchar(10),@EjercicioFin) + '-' +
	 convert(varchar(10),@PeriodoFin) + '-' +
	 convert(varchar(10),@diafinal), 101) as date); 

	 if @dateini > @datefin 
	 begin
		  set @datetemp = @dateini
		  set @dateini = @datefin
		  set @datefin = @datetemp
	 End

IF @EstadoBien <>'' BEGIN
SELECT @EstadoBien=
   CASE   
      WHEN @EstadoBien='Bueno' THEN 'B' 
      WHEN @EstadoBien='Regular' THEN 'R' 
	  WHEN @EstadoBien='Malo' THEN 'M' 
	  WHEN @EstadoBien='Nuevo' THEN 'N'
	   
	  WHEN @EstadoBien='Activo' THEN 'A' 
	  WHEN @EstadoBien='Donado' THEN 'D' 
	  WHEN @EstadoBien='Baja' THEN 'C' 
	  WHEN @EstadoBien='Pendiente de baja' THEN 'P' 
	  WHEN @EstadoBien='No localizado' THEN 'L' 
	  WHEN @EstadoBien='Todos' THEN 'T' 
   END   
END

--SELECT @EstadoBien

IF @TipoBien <>'' BEGIN
	IF @EstatusBien <>'' BEGIN
			IF @EstatusBien ='Activo' BEGIN
			 IF @EstadoBien <>'' AND @EstadoBien <>'T' BEGIN
				SELECT C_TipoBien.DescripcionTipoBien,
				cast(case
						 When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
						 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
				T_Activos.Descripcion,
				1 as Cantidad,
				T_Activos.CostoAdquisicion,
				C_Maestro.UnidadMedida, 
				T_Activos.CostoAdquisicion as Importe,
				T_Activos.FechaUA as Fecha
				 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		 ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END   
				FROM T_Activos
				JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
				JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
				left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja

				JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdTipoBien = T_Activos.IdTipoBien 
				Where  C_TipoBien.DescripcionTipoBien= @TipoBien AND (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin) AND T_Activos.Estatus='A' AND T_Activos.EstadoDelBien in(@EstadoBien)
				ORDER BY T_Activos.NumeroEconomico
			 END
			 ELSE BEGIN 
				SELECT C_TipoBien.DescripcionTipoBien,
				cast(case
						 When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
						 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
				T_Activos.Descripcion,
				1 as Cantidad,
				T_Activos.CostoAdquisicion,
				C_Maestro.UnidadMedida, 
				T_Activos.CostoAdquisicion as Importe,
				T_Activos.FechaUA as Fecha
				 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
				FROM T_Activos
				JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
				JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
				left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja

				JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdTipoBien = T_Activos.IdTipoBien 

				Where  C_TipoBien.DescripcionTipoBien= @TipoBien AND (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin) AND T_Activos.Estatus='A'
				ORDER BY T_Activos.NumeroEconomico
			 END
			END
			ELSE IF @EstatusBien ='Inactivo' BEGIN
			
			 IF @EstadoBien <>'' AND @EstadoBien <>'T' BEGIN
				SELECT C_TipoBien.DescripcionTipoBien,
				cast(case
						 When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
						 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
				T_Activos.Descripcion,
				1 as Cantidad,
				T_Activos.CostoAdquisicion,
				C_Maestro.UnidadMedida, 
				T_Activos.CostoAdquisicion as Importe,
				T_Activos.FechaUA as Fecha
				 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
				FROM T_Activos
				JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
				JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
				left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja

				JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdTipoBien = T_Activos.IdTipoBien 

				Where  C_TipoBien.DescripcionTipoBien= @TipoBien AND (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin) AND T_Activos.Estatus='B' and T_Activos.EstadoDelBien in (@EstadoBien)
				ORDER BY T_Activos.NumeroEconomico
			 END
			 ELSE BEGIN 
				SELECT C_TipoBien.DescripcionTipoBien,
				cast(case
						 When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
						 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
				T_Activos.Descripcion,
				1 as Cantidad,
				T_Activos.CostoAdquisicion,
				C_Maestro.UnidadMedida, 
				T_Activos.CostoAdquisicion as Importe,
				T_Activos.FechaUA as Fecha
				 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
				FROM T_Activos
				JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
				JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
				left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja
				JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdTipoBien = T_Activos.IdTipoBien 

				Where  C_TipoBien.DescripcionTipoBien= @TipoBien AND (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin) AND T_Activos.Estatus='B'
				ORDER BY T_Activos.NumeroEconomico
			 END
				
			END
			ELSE IF @EstatusBien ='Todos' BEGIN
				 IF @EstadoBien <>'' AND @EstadoBien <>'T' BEGIN
				SELECT C_TipoBien.DescripcionTipoBien,
				cast(case
						 When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
						 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
				T_Activos.Descripcion,
				1 as Cantidad,
				T_Activos.CostoAdquisicion,
				C_Maestro.UnidadMedida, 
				T_Activos.CostoAdquisicion as Importe,
				T_Activos.FechaUA as Fecha
				 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
				FROM T_Activos
				JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
				JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
				left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja
				JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdTipoBien = T_Activos.IdTipoBien 

				Where  C_TipoBien.DescripcionTipoBien= @TipoBien AND (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin) and T_Activos.EstadoDelBien in(@EstadoBien)
				ORDER BY T_Activos.NumeroEconomico
			 END
			 ELSE BEGIN 
				SELECT C_TipoBien.DescripcionTipoBien,
				cast(case
						 When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
						 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
				T_Activos.Descripcion,
				1 as Cantidad,
				T_Activos.CostoAdquisicion,
				C_Maestro.UnidadMedida, 
				T_Activos.CostoAdquisicion as Importe,
				T_Activos.FechaUA as Fecha
				 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
				FROM T_Activos
				JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
				JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
				left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja

				JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdTipoBien = T_Activos.IdTipoBien 

				Where  C_TipoBien.DescripcionTipoBien= @TipoBien AND (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin)
				ORDER BY T_Activos.NumeroEconomico
			 END
				
			END
			END
	ELSE IF @EstatusBien ='' BEGIN
	
			 IF @EstadoBien <>'' AND @EstadoBien <>'T' BEGIN
				SELECT C_TipoBien.DescripcionTipoBien,
				cast(case
						 When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
						 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
				T_Activos.Descripcion,
				1 as Cantidad,
				T_Activos.CostoAdquisicion,
				C_Maestro.UnidadMedida, 
				T_Activos.CostoAdquisicion as Importe,
				T_Activos.FechaUA as Fecha
				 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
				FROM T_Activos
				JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
				JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
				left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja

				JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdTipoBien = T_Activos.IdTipoBien 

				Where  C_TipoBien.DescripcionTipoBien= @TipoBien AND (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin) and T_Activos.EstadoDelBien in (@EstadoBien)
				ORDER BY T_Activos.NumeroEconomico
			 END
			 ELSE BEGIN 
				SELECT C_TipoBien.DescripcionTipoBien,
				cast(case
						 When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
						 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
				T_Activos.Descripcion,
				1 as Cantidad,
				T_Activos.CostoAdquisicion,
				C_Maestro.UnidadMedida, 
				T_Activos.CostoAdquisicion as Importe,
				T_Activos.FechaUA as Fecha
				 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
				FROM T_Activos
				JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
				JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
				left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja

				JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdTipoBien = T_Activos.IdTipoBien 

				Where  C_TipoBien.DescripcionTipoBien= @TipoBien AND (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin)
				ORDER BY T_Activos.NumeroEconomico
			 END
				
	 END
--SELECT C_TipoBien.DescripcionTipoBien,
--cast(case
--         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
--		 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
--T_Activos.Descripcion,
--1 as Cantidad,
--T_Activos.CostoAdquisicion,
--C_Maestro.UnidadMedida, 
--T_Activos.CostoAdquisicion as Importe,
--T_Activos.FechaUA as Fecha

--FROM T_Activos
--JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
--JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
--JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdTipoBien = T_Activos.IdTipoBien 

--Where  C_TipoBien.DescripcionTipoBien= @TipoBien AND YEAR(T_Activos.FechaUA)=@Ejercicio AND (MONTH(T_Activos.FechaUA )between 1 and @Periodo )
--ORDER BY T_Activos.NumeroEconomico
END

IF @TipoBien ='' BEGIN
	IF @EstatusBien ='' BEGIN
	 IF @EstadoBien ='' BEGIN
	 
	  SELECT C_TipoBien.DescripcionTipoBien,
         cast(case
         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
		 else convert(varchar (max), T_Activos.NumeroEconomico) 
		 end as varchar (max)) as NumeroEconomico,
         T_Activos.Descripcion,
         1 as Cantidad,
         T_Activos.CostoAdquisicion,
         C_Maestro.UnidadMedida, 
         T_Activos.CostoAdquisicion as Importe,
         T_Activos.FechaUA as Fecha
		 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
      FROM T_Activos
      JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
      JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 

	  	 left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja

      LEFT OUTER JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto 
	                            and C_Maestro.IdGrupo = T_Activos.CodigoGrupo 
								and  C_Maestro.IdSubGrupo = T_Activos.CodigoSubGrupo
      Where (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin)
      ORDER BY C_TipoBien.DescripcionTipoBien, T_Activos.NumeroEconomico	
    END

	 ELSE IF @EstadoBien <>'' AND @EstadoBien <>'T' BEGIN
	  
	  SELECT C_TipoBien.DescripcionTipoBien,
cast(case
         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
		 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
T_Activos.Descripcion,
1 as Cantidad,
T_Activos.CostoAdquisicion,
C_Maestro.UnidadMedida, 
T_Activos.CostoAdquisicion as Importe,
T_Activos.FechaUA as Fecha
, case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
FROM T_Activos
 JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
 JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
 
		 	  	 left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja


LEFT OUTER JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdGrupo = T_Activos.CodigoGrupo and  C_Maestro.IdSubGrupo = T_Activos.CodigoSubGrupo
Where (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin) and T_Activos.EstadoDelBien in (@EstadoBien)
ORDER BY C_TipoBien.DescripcionTipoBien, T_Activos.NumeroEconomico	
     END
	  
	  ELSE BEGIN 
				SELECT C_TipoBien.DescripcionTipoBien,
cast(case
         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
		 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
T_Activos.Descripcion,
1 as Cantidad,
T_Activos.CostoAdquisicion,
C_Maestro.UnidadMedida, 
T_Activos.CostoAdquisicion as Importe,
T_Activos.FechaUA as Fecha
 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
FROM T_Activos
 JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
 JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
 
		 	  	 left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja


LEFT OUTER JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdGrupo = T_Activos.CodigoGrupo and  C_Maestro.IdSubGrupo = T_Activos.CodigoSubGrupo
Where (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin)
ORDER BY C_TipoBien.DescripcionTipoBien, T_Activos.NumeroEconomico	
			 END
	END
    IF @EstatusBien <>'' BEGIN
	    IF @EstatusBien ='Activo' BEGIN
		IF @EstadoBien <>'' AND @EstadoBien <>'T' BEGIN
				SELECT C_TipoBien.DescripcionTipoBien,
		cast(case
		         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
				 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
		T_Activos.Descripcion,
		1 as Cantidad,
		T_Activos.CostoAdquisicion,
		C_Maestro.UnidadMedida, 
		T_Activos.CostoAdquisicion as Importe,
		T_Activos.FechaUA as Fecha
		 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
		FROM T_Activos
		 JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
		 JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
		 left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja

		LEFT OUTER JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdGrupo = T_Activos.CodigoGrupo and  C_Maestro.IdSubGrupo = T_Activos.CodigoSubGrupo
		Where (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin) AND T_Activos.Estatus='A' and T_Activos.EstadoDelBien in (@EstadoBien)
		ORDER BY C_TipoBien.DescripcionTipoBien, T_Activos.NumeroEconomico
			 END
			 ELSE BEGIN 
				SELECT C_TipoBien.DescripcionTipoBien,
		cast(case
		         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
				 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
		T_Activos.Descripcion,
		1 as Cantidad,
		T_Activos.CostoAdquisicion,
		C_Maestro.UnidadMedida, 
		T_Activos.CostoAdquisicion as Importe,
		T_Activos.FechaUA as Fecha
		 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
		FROM T_Activos
		 JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
		 JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
		 left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja
		LEFT OUTER JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdGrupo = T_Activos.CodigoGrupo and  C_Maestro.IdSubGrupo = T_Activos.CodigoSubGrupo
		Where (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin) AND T_Activos.Estatus='A'
		ORDER BY C_TipoBien.DescripcionTipoBien, T_Activos.NumeroEconomico
			 END
		END
		ELSE IF @EstatusBien ='Inactivo' BEGIN
		IF @EstadoBien <>'' AND @EstadoBien <>'T' BEGIN
				SELECT C_TipoBien.DescripcionTipoBien,
		cast(case
		         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
				 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
		T_Activos.Descripcion,
		1 as Cantidad,
		T_Activos.CostoAdquisicion,
		C_Maestro.UnidadMedida, 
		T_Activos.CostoAdquisicion as Importe,
		T_Activos.FechaUA as Fecha
		 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
		FROM T_Activos
		 JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
		 JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
		 left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja
		LEFT OUTER JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdGrupo = T_Activos.CodigoGrupo and  C_Maestro.IdSubGrupo = T_Activos.CodigoSubGrupo
		Where (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin) AND T_Activos.Estatus='B' and T_Activos.EstadoDelBien in (@EstadoBien)
		ORDER BY C_TipoBien.DescripcionTipoBien, T_Activos.NumeroEconomico 
			 END
			 ELSE BEGIN 
				SELECT C_TipoBien.DescripcionTipoBien,
		cast(case
		         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
				 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
		T_Activos.Descripcion,
		1 as Cantidad,
		T_Activos.CostoAdquisicion,
		C_Maestro.UnidadMedida, 
		T_Activos.CostoAdquisicion as Importe,
		T_Activos.FechaUA as Fecha
		 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
		FROM T_Activos
		 JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
		 JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
		 left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja

		LEFT OUTER JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdGrupo = T_Activos.CodigoGrupo and  C_Maestro.IdSubGrupo = T_Activos.CodigoSubGrupo
		Where (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin) AND T_Activos.Estatus='B'
		ORDER BY C_TipoBien.DescripcionTipoBien, T_Activos.NumeroEconomico 
			 END
		END
		ELSE IF @EstatusBien ='Todos' BEGIN
		IF @EstadoBien <>'' AND @EstadoBien <>'T' BEGIN
				SELECT C_TipoBien.DescripcionTipoBien,
		cast(case
		         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
				 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
		T_Activos.Descripcion,
		1 as Cantidad,
		T_Activos.CostoAdquisicion,
		C_Maestro.UnidadMedida, 
		T_Activos.CostoAdquisicion as Importe,
		T_Activos.FechaUA as Fecha
		 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
		FROM T_Activos
		 JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
		 JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
		 left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja

		LEFT OUTER JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdGrupo = T_Activos.CodigoGrupo and  C_Maestro.IdSubGrupo = T_Activos.CodigoSubGrupo
		Where (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin) and T_Activos.EstadoDelBien in (@EstadoBien)
		ORDER BY C_TipoBien.DescripcionTipoBien, T_Activos.NumeroEconomico
			 END
			 ELSE BEGIN 
				SELECT C_TipoBien.DescripcionTipoBien,
		cast(case
		         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
				 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
		T_Activos.Descripcion,
		1 as Cantidad,
		T_Activos.CostoAdquisicion,
		C_Maestro.UnidadMedida, 
		T_Activos.CostoAdquisicion as Importe,
		T_Activos.FechaUA as Fecha
		 , case when T_Activos.Estatus ='B' then 'Inactivo' 
		 else 'Activo'
		 end
		 as EstatusContable
		 ,T_BajaActivos.FechaBaja as FechaBaja 
		  ,EstadodelBien = CASE   EstadodelBien
						  WHEN 'B' THEN 'Bueno'
						  WHEN 'R' THEN 'Regular'
						  WHEN 'M'  THEN 'Malo'
						  WHEN 'N' THEN 'Nuevo'  
	   
						  WHEN 'A' THEN 'Activo'
						  WHEN 'D' THEN 'Donado'
						  WHEN 'C' THEN 'Baja'
						  WHEN 'P' THEN 'Pendiente de baja' 
						  WHEN 'L' THEN 'No localizado' 
						END 
		FROM T_Activos
		 JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
		 JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
		 left JOIN  D_BajasActivos on T_Activos.NumeroEconomico=D_BajasActivos.NumeroEconomico
		 left JOIN T_BajaActivos on T_BajaActivos.Folio= D_BajasActivos.FolioBaja

		LEFT OUTER JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdGrupo = T_Activos.CodigoGrupo and  C_Maestro.IdSubGrupo = T_Activos.CodigoSubGrupo
		Where (T_Activos.FechaUA >= @dateini AND T_Activos.FechaUA <= @datefin)
		ORDER BY C_TipoBien.DescripcionTipoBien, T_Activos.NumeroEconomico
			 END
		END
	END	

--SELECT C_TipoBien.DescripcionTipoBien,
--cast(case
--         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
--		 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
--T_Activos.Descripcion,
--1 as Cantidad,
--T_Activos.CostoAdquisicion,
--C_Maestro.UnidadMedida, 
--T_Activos.CostoAdquisicion as Importe,
--T_Activos.FechaUA as Fecha

--FROM T_Activos
-- JOIN T_AltaActivos ON T_Activos.FolioAlta= T_AltaActivos.FolioAlta 
-- JOIN C_TipoBien ON C_TipoBien.IdTipoBien= T_Activos.IdTipoBien 
--LEFT OUTER JOIN C_Maestro ON C_Maestro.IdCodigoProducto = T_Activos.CodigoProducto and C_Maestro.IdGrupo = T_Activos.CodigoGrupo and  C_Maestro.IdSubGrupo = T_Activos.CodigoSubGrupo
--Where YEAR(T_Activos.FechaUA)=@Ejercicio AND (MONTH(T_Activos.FechaUA ) between 1 and @Periodo )
--ORDER BY C_TipoBien.DescripcionTipoBien, T_Activos.NumeroEconomico
END
GO


EXEC SP_FirmasReporte 'Libro de Inventarios de Bienes Muebles e Inmuebles'
GO

--exec SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles_RepKorima @TipoBien=N'',@Ejercicio=2017,@Periodo=11,@EstatusBien=N'',@EstadoBien=N''
--exec SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles_RepKorima @TipoBien=N'Arqueológicos Bienes Muebles',@Ejercicio=2017,@Periodo=11,@EstatusBien=N'',@EstadoBien=N''
--exec SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles_RepKorima @TipoBien=N'Arqueológicos Bienes Muebles',@Ejercicio=2017,@Periodo=11,@EstatusBien=N'Activo',@EstadoBien=N''
--exec SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles_RepKorima @TipoBien=N'Arqueológicos Bienes Muebles',@Ejercicio=2017,@Periodo=11,@EstatusBien=N'Activo',@EstadoBien=N'Pendiente de baja'
--exec SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles_RepKorima @TipoBien=N'',@Ejercicio=2017,@Periodo=11,@EstatusBien=N'Activo',@EstadoBien=N'Todos'






















