
/****** Object:  StoredProcedure [dbo].[SP_RPT_PolizasFuenteFinanciamiento]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_PolizasFuenteFinanciamiento]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_PolizasFuenteFinanciamiento]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_PolizasFuenteFinanciamiento]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_PolizasFuenteFinanciamiento] 


@Periodo  as int,  
@Ejercicio as int,
@ClaveFF as varchar(6)

AS
BEGIN

 Declare @tabla as table (
		Fecha datetime
      ,Consecutivo varchar(max)
      ,NoPoliza bigint
      ,TipoPoliza varchar (max)
	  ,CuentaPresupuestal varchar (max)
	  ,Debe decimal (18,2)
	  ,Haber decimal (18,2)
	  ,IdSello int
	  ,Sello varchar (max)
	  ,CuentaContable varchar (100)
	  ,NombreContable varchar(max)
	  ,FuenteFinanciamiento varchar (20)
	  ,NoEvento int
 )

 Declare @tabla2 as table (
		Fecha datetime
      ,Consecutivo varchar(max)
      ,NoPoliza bigint
      ,TipoPoliza varchar (max)
	  ,CuentaPresupuestal varchar (max)
	  ,Debe decimal (18,2)
	  ,Haber decimal (18,2)
	  ,IdSello int
	  ,Sello varchar (max)
	  ,CuentaContable varchar (100)
	  ,NombreContable varchar(max)
	  ,FuenteFinanciamiento varchar (20)
	  ,NoEvento int
 )


 Insert Into @tabla
 Select TP.Fecha,
 TP.IdPoliza as Consecutivo,
  NoPoliza,
  CASE TipoPoliza
	  WHEN 'D' THEN 'Diario'
	  WHEN 'E' THEN 'Egresos'
	  WHEN 'I' THEN 'Ingresos'
  ELSE 'Otro'
  END as TipoPoliza,
  DP.IdCuentaContable as Cuenta,
  DP.ImporteCargo as Debe,
  DP.ImporteAbono as Haber,
  DP.IdSelloPresupuestal as IdSello,
  TS.Sello as Sello,
  CC.NumeroCuenta as CuentaContable,
  CC.NombreCuenta as NombreContable,
  CF.Clave as FuenteFinanciamiento,
  0 as NoEvento from T_Polizas TP
  INNER JOIN D_Polizas DP
  ON TP.IdPoliza = DP.IdPoliza
  INNER JOIN C_Contable CC
  ON DP.IdCuentaContable = CC.IdCuentaContable
  INNER JOIN T_SellosPresupuestales TS
  ON DP.IdSelloPresupuestal = TS.IdSelloPresupuestal
  INNER JOIN C_FuenteFinanciamiento CF
  ON TS.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento
 Where NoPoliza > 0 AND YEAR(TP.Fecha) = @Ejercicio AND MONTH(TP.Fecha) = @Periodo



  Insert into @tabla2
 Select TP.Fecha,
 TP.IdPoliza as Consecutivo,
  NoPoliza,
  CASE TipoPoliza
	  WHEN 'D' THEN 'Diario'
	  WHEN 'E' THEN 'Egresos'
	  WHEN 'I' THEN 'Ingresos'
  ELSE 'Otro'
  END as TipoPoliza,
  DP.IdCuentaContable as Cuenta,
  DP.ImporteCargo as Debe,
  DP.ImporteAbono as Haber,
  DP.IdSelloPresupuestal as IdSello,
  TS.Sello as Sello,
  CC.NumeroCuenta as CuentaContable,
  CC.NombreCuenta as NombreContable,
  CF.Clave as FuenteFinanciamiento,
  0 as NoEvento from T_Polizas TP
  INNER JOIN D_Polizas DP
  ON TP.IdPoliza = DP.IdPoliza
  INNER JOIN C_Contable CC
  ON DP.IdCuentaContable = CC.IdCuentaContable
  LEFT JOIN T_SellosPresupuestales TS
  ON DP.IdSelloPresupuestal = TS.IdSelloPresupuestal
  LEFT JOIN C_FuenteFinanciamiento CF
  ON TS.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento
  Where NoPoliza > 0 AND YEAR(TP.Fecha) = @Ejercicio AND MONTH(TP.Fecha) = @Periodo AND TP.IdPoliza In (Select Consecutivo from @tabla
 Where FuenteFinanciamiento = @ClaveFF)


 Select * from @tabla2
 order by NoPoliza, Consecutivo
END



--exec [SP_RPT_PolizasFuenteFinanciamiento]  7,2015,'4'


