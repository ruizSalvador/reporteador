
/****** Object:  View [dbo].[VW_RPT_K2_Firmas]    Script Date: 06/11/2015 09:53:05 a.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_RPT_K2_Firmas2] as 
SELECT C_Formatos.Formato, C_Formatos.NombreOriginal,
T_Firmas.Nombre1 as Nombre1, T_Firmas.Puesto1 as Puesto1, (Select Path+Archivo from T_Imagenes pt Where T_Firmas.Imagen = pt.Imagen) as Imagen1,
T_Firmas.Nombre2 as Nombre2, T_Firmas.Puesto2 as Puesto2, (Select Path+Archivo from T_Imagenes pt Where T_Firmas.Imagen2 = pt.Imagen) as Imagen2,
1 as Orden
FROM C_Formatos 
JOIN T_Firmas ON
 C_Formatos.IdFormato = T_Firmas.IdFormato 
where ((T_Firmas.Nombre1 <> '''' or T_Firmas.Puesto1 <> '''')
 or (T_Firmas.Nombre1 <> Null or T_Firmas.Puesto1  <> Null))
 or ((T_Firmas.Nombre2 <> '''' or T_Firmas.Puesto2 <> '''')
 OR (T_Firmas.Nombre2 <> Null or T_Firmas.Puesto2 <> Null))
 UNION
 SELECT C_Formatos.Formato, C_Formatos.NombreOriginal,
T_Firmas.Nombre3 as Nombre1, T_Firmas.Puesto3 as Puesto1, (Select Path+Archivo from T_Imagenes pt Where T_Firmas.Imagen3 = pt.Imagen) as Imagen1,
T_Firmas.Nombre4 as Nombre2, T_Firmas.Puesto4 as Puesto2, '' as Imagen2,
2 as Orden
FROM C_Formatos  
JOIN T_Firmas ON
 C_Formatos.IdFormato = T_Firmas.IdFormato 
  where ((T_Firmas.Nombre3 <> '''' or T_Firmas.Puesto3 <> '''')
 or (T_Firmas.Nombre3 <> Null or T_Firmas.Puesto3  <> Null))
 or ((T_Firmas.Nombre4 <> '''' or T_Firmas.Puesto4 <> '''')
 OR (T_Firmas.Nombre4 <> Null or T_Firmas.Puesto4 <> Null))
  UNION
 SELECT C_Formatos.Formato, C_Formatos.NombreOriginal,
T_Firmas.Nombre5 as Nombre1, T_Firmas.Puesto5 as Puesto1, '' as Imagen1,
T_Firmas.Nombre6 as Nombre2, T_Firmas.Puesto6 as Puesto2, '' as Imagen2,
3 as Orden
FROM C_Formatos  
JOIN T_Firmas ON
 C_Formatos.IdFormato = T_Firmas.IdFormato 
  where ((T_Firmas.Nombre5 <> '''' or T_Firmas.Puesto5 <> '''')
 or (T_Firmas.Nombre5 <> Null or T_Firmas.Puesto5  <> Null))
 or ((T_Firmas.Nombre6 <> '''' or T_Firmas.Puesto6 <> '''')
 OR (T_Firmas.Nombre6 <> Null or T_Firmas.Puesto6 <> Null))
  UNION
 SELECT C_Formatos.Formato, C_Formatos.NombreOriginal,
T_Firmas.Nombre7 as Nombre1, T_Firmas.Puesto7 as Puesto1, '' as Imagen1,
T_Firmas.Nombre8 as Nombre2, T_Firmas.Puesto8 as Puesto2, '' as Imagen2,
4 as Orden
FROM C_Formatos  
JOIN T_Firmas ON
 C_Formatos.IdFormato = T_Firmas.IdFormato 
 where ((T_Firmas.Nombre7 <> '''' or T_Firmas.Puesto7 <> '''')
 or (T_Firmas.Nombre7 <> Null or T_Firmas.Puesto7  <> Null))
 or ((T_Firmas.Nombre8 <> '''' or T_Firmas.Puesto8 <> '''')
 OR (T_Firmas.Nombre8 <> Null or T_Firmas.Puesto8 <> Null))
  UNION
 SELECT C_Formatos.Formato, C_Formatos.NombreOriginal,
T_Firmas.Nombre9 as Nombre1, T_Firmas.Puesto9 as Puesto1, '' as Imagen1,
T_Firmas.Nombre10 as Nombre2, T_Firmas.Puesto10 as Puesto2, '' as Imagen2,
5 as Orden
FROM C_Formatos  
JOIN T_Firmas ON
 C_Formatos.IdFormato = T_Firmas.IdFormato 
 where ((T_Firmas.Nombre9 <> '''' or T_Firmas.Puesto9 <> '''')
 or (T_Firmas.Nombre9 <> Null or T_Firmas.Puesto9  <> Null))
 or ((T_Firmas.Nombre10 <> '''' or T_Firmas.Puesto10 <> '''')
 OR (T_Firmas.Nombre10 <> Null or T_Firmas.Puesto10 <> Null))
  UNION
 SELECT C_Formatos.Formato, C_Formatos.NombreOriginal,
T_Firmas.Nombre11 as Nombre1, T_Firmas.Puesto11 as Puesto1, '' as Imagen1,
T_Firmas.Nombre12 as Nombre2, T_Firmas.Puesto12 as Puesto2, '' as Imagen2,
6 as Orden
FROM C_Formatos  
JOIN T_Firmas ON
 C_Formatos.IdFormato = T_Firmas.IdFormato 
 where ((T_Firmas.Nombre11 <> '''' or T_Firmas.Puesto11 <> '''')
 or (T_Firmas.Nombre11 <> Null or T_Firmas.Puesto11  <> Null))
 or ((T_Firmas.Nombre12 <> '''' or T_Firmas.Puesto12 <> '''')
 OR (T_Firmas.Nombre12 <> Null or T_Firmas.Puesto12 <> Null))

GO


