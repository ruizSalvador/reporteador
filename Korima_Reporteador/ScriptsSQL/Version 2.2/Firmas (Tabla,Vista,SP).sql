
--INICIO MODIFICACION DE TABLA DE FIRMAS PARA SOPORTAR 12 FIRMAS 
/*IF EXISTS (SELECT 1 FROM SYSCOLUMNS
	WHERE id= OBJECT_ID ('T_Firmas') AND 
	(name = 'Nombre1' OR name = 'Puesto1' OR
	name = 'Nombre2' OR name = 'Puesto2' OR
	name = 'Nombre3' OR name = 'Puesto3' OR
	name = 'Nombre4' OR name = 'Puesto4' OR
	name = 'Nombre5' OR name = 'Puesto5'))
BEGIN
		ALTER TABLE T_Firmas 
		ALTER COLUMN Nombre1 VARCHAR(250); 
		ALTER TABLE T_Firmas 
		ALTER COLUMN Puesto1 VARCHAR(250);
		ALTER TABLE T_Firmas
		ALTER COLUMN Nombre2 VARCHAR(250);
		ALTER TABLE T_Firmas
		ALTER COLUMN Puesto2 VARCHAR(250);
		ALTER TABLE T_Firmas
		ALTER COLUMN Nombre3 VARCHAR(250);
		ALTER TABLE T_Firmas
		ALTER COLUMN Puesto3 VARCHAR(250);
		ALTER TABLE T_Firmas
		ALTER COLUMN Nombre4 VARCHAR(250);
		ALTER TABLE T_Firmas
		ALTER COLUMN Puesto4 VARCHAR(250);
		ALTER TABLE T_Firmas
		ALTER COLUMN Nombre5 VARCHAR(250);
		ALTER TABLE T_Firmas
		ALTER COLUMN Puesto5 VARCHAR(250);
END
GO
IF NOT EXISTS (SELECT 1 FROM SYSCOLUMNS
	WHERE id= OBJECT_ID ('T_Firmas') AND 
	(name = 'Nombre6' OR name = 'Puesto6' OR
	name = 'Nombre7' OR name = 'Puesto7' OR
	name = 'Nombre8' OR name = 'Puesto8' OR
	name = 'Nombre9' OR name = 'Puesto9' OR
	name = 'Nombre10' OR name = 'Puesto10' OR
	name = 'Nombre11' OR name = 'Puesto11' OR
	name = 'Nombre12' OR name = 'Puesto12'))
BEGIN
		ALTER TABLE T_Firmas ADD 
		Nombre6 VARCHAR(250), Puesto6 VARCHAR(250),
		Nombre7 VARCHAR(250), Puesto7 VARCHAR(250),
		Nombre8 VARCHAR(250), Puesto8 VARCHAR(250),
		Nombre9 VARCHAR(250), Puesto9 VARCHAR(250),
		Nombre10 VARCHAR(250), Puesto10 VARCHAR(250),
		Nombre11 VARCHAR(250), Puesto11 VARCHAR(250),
		Nombre12 VARCHAR(250), Puesto12 VARCHAR(250)
END
GO*/
--FIN MODIFICACION DE TABLA DE FIRMAS PARA SOPORTAR 12 FIRMAS 


--INICIO CREACION DE VISTA PARA FIRMAS
/****** Object:  View [dbo].[VW_RPT_K2_Firmas]    Script Date: 10/04/2012 09:40:31 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Firmas]'))
DROP VIEW [dbo].[VW_RPT_K2_Firmas]
GO
/****** Object:  View [dbo].[VW_RPT_K2_Firmas]    Script Date: 10/04/2012 09:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Firmas] as 
SELECT C_Formatos.Formato, C_Formatos.NombreOriginal,
T_Firmas.Nombre1 as Nombre1, T_Firmas.Puesto1 as Puesto1,
T_Firmas.Nombre2 as Nombre2, T_Firmas.Puesto2 as Puesto2,
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
T_Firmas.Nombre3 as Nombre1, T_Firmas.Puesto3 as Puesto1,
T_Firmas.Nombre4 as Nombre2, T_Firmas.Puesto4 as Puesto2,
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
T_Firmas.Nombre5 as Nombre1, T_Firmas.Puesto5 as Puesto1,
T_Firmas.Nombre6 as Nombre2, T_Firmas.Puesto6 as Puesto2,
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
T_Firmas.Nombre7 as Nombre1, T_Firmas.Puesto7 as Puesto1,
T_Firmas.Nombre8 as Nombre2, T_Firmas.Puesto8 as Puesto2,
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
T_Firmas.Nombre9 as Nombre1, T_Firmas.Puesto9 as Puesto1,
T_Firmas.Nombre10 as Nombre2, T_Firmas.Puesto10 as Puesto2,
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
T_Firmas.Nombre11 as Nombre1, T_Firmas.Puesto11 as Puesto1,
T_Firmas.Nombre12 as Nombre2, T_Firmas.Puesto12 as Puesto2,
6 as Orden
FROM C_Formatos  
JOIN T_Firmas ON
 C_Formatos.IdFormato = T_Firmas.IdFormato 
 where ((T_Firmas.Nombre11 <> '''' or T_Firmas.Puesto11 <> '''')
 or (T_Firmas.Nombre11 <> Null or T_Firmas.Puesto11  <> Null))
 or ((T_Firmas.Nombre12 <> '''' or T_Firmas.Puesto12 <> '''')
 OR (T_Firmas.Nombre12 <> Null or T_Firmas.Puesto12 <> Null))

GO

--FIN CREACION DE VISTA PARA FIRMAS

--INICIO CREACION DE PROCEDIMIENTO PARA INSERCION DE REGISTRO DE DOCUMENTO QUE MANEJA FIRMAS

/****** Object:  StoredProcedure [dbo].[SP_FirmasReporte]    Script Date: 10/24/2012 11:38:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_FirmasReporte]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_FirmasReporte]
GO
/****** Object:  StoredProcedure [dbo].[SP_FirmasReporte]    Script Date: 10/24/2012 11:38:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_FirmasReporte]
@NombreReporte varchar(255)
AS
Declare @Numero int
set @Numero = convert(int,(Select max(IdFormato) from C_Formatos))+1
begin try
if not exists ( select Formato from C_Formatos where Formato=@NombreReporte)
	begin
	 INSERT INTO 
	 C_Formatos (IdFormato,Formato,NombreOriginal,Utilizar)
	 --VALUES (convert(int,(Select max(IdFormato) from C_Formatos))+1,@NombreReporte,@NombreReporte,1)
	 VALUES (@Numero,@NombreReporte,@NombreReporte,1)
	end
	else
		begin
		UPDATE 
		C_Formatos SET Formato=@NombreReporte,NombreOriginal= @NombreReporte,Utilizar=1
	 where formato =@NombreReporte and NombreOriginal = @NombreReporte
		end
end try
 begin catch
 print 'Hubo un error al Insertar el registro para manejo de firmas'
 end catch

GO

--FIN CREACION DE PROCEDIMIENTO PARA INSERCION DE REGISTRO DE DOCUMENTO QUE MANEJA FIRMAS