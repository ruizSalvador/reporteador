IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'Temp_Destinos')
		BEGIN
			DELETE FROM Temp_Destinos
			
		END
	ELSE
		BEGIN
			CREATE TABLE Temp_Destinos (id int, idsolicitudcheques int,  destinos nvarchar(400), edo varchar(200))
		END
		GO

if not exists(Select * from INFORMATION_SCHEMA.COLUMNS WHere
TABLE_NAME = 'Temp_Destinos' AND COLUMN_NAME = 'edo')
BEGIN
ALTER TABLE Temp_Destinos
ADD edo varchar(200) null
END
GO