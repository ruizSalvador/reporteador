
/****** Object:  View [dbo].[VW_RPT_K2_Firmas3]    Script Date: 09/19/2012 12:52:38 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Firmas3]'))
DROP VIEW [dbo].[VW_RPT_K2_Firmas3]
GO

/****** Object:  View [dbo].[VW_RPT_K2_Firmas3]    Script Date: 09/19/2012 12:52:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Firmas3] as 
SELECT C_Formatos.Formato, C_Formatos.NombreOriginal,
T_Firmas.Nombre1 as Nombre1, T_Firmas.Puesto1 as Puesto1, (Select Path+Archivo from T_Imagenes pt Where T_Firmas.Imagen = pt.Imagen) as Imagen1,
T_Firmas.Nombre2 as Nombre2, T_Firmas.Puesto2 as Puesto2, (Select Path+Archivo from T_Imagenes pt Where T_Firmas.Imagen2 = pt.Imagen) as Imagen2,
T_Firmas.Nombre3 as Nombre3, T_Firmas.Puesto3 as Puesto3, (Select Path+Archivo from T_Imagenes pt Where T_Firmas.Imagen3 = pt.Imagen) as Imagen3,
1 as Orden
FROM C_Formatos 
JOIN T_Firmas ON
 C_Formatos.IdFormato = T_Firmas.IdFormato 
where ((T_Firmas.Nombre1 <> '''' or T_Firmas.Puesto1 <> '''')
 or (T_Firmas.Nombre1 <> Null or T_Firmas.Puesto1  <> Null))
 or ((T_Firmas.Nombre2 <> '''' or T_Firmas.Puesto2 <> '''')
 OR (T_Firmas.Nombre2 <> Null or T_Firmas.Puesto2 <> Null))

 GO