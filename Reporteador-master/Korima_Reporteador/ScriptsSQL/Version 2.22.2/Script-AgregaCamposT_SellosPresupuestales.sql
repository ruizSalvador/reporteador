---Agregar Campos en T_SellosPresupuestales

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'T_SellosPresupuestales'
and SC.name = 'IdDepartamento')

ALTER TABLE T_SellosPresupuestales ADD IdDepartamento int
GO

---Agregar Campos en T_SellosPresupuestales

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'T_SellosPresupuestales'
and SC.name = 'IdNivelAdicional1')

ALTER TABLE T_SellosPresupuestales ADD IdNivelAdicional1 int
GO

---Agregar Campos en T_SellosPresupuestales

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'T_SellosPresupuestales'
and SC.name = 'IdNivelAdicional2')

ALTER TABLE T_SellosPresupuestales ADD IdNivelAdicional2 int
GO

---Agregar Campos en T_SellosPresupuestales

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'T_SellosPresupuestales'
and SC.name = 'IdNivelAdicional3')

ALTER TABLE T_SellosPresupuestales ADD IdNivelAdicional3 int
GO


--Borrar Indice si existe
IF EXISTS (SELECT * FROM SYSINDEXES WHERE NAME='Ak_Sello')
BEGIN
   DROP INDEX Ak_Sello ON dbo.T_SellosPresupuestales
END
GO


--Cambiar longitud de campo 
ALTER TABLE T_SellosPresupuestales ALTER COLUMN Sello varchar(80)
go

--Crear indices
CREATE NONCLUSTERED INDEX Ak_Sello ON dbo.T_SellosPresupuestales
	(
	Sello
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


If not exists (Select * from T_EstructuraProgramatica where Nivel  = 15)
begin 

     INSERT INTO [dbo].[T_EstructuraProgramatica]
           ([Nivel]
           ,[Descripcion]
           ,[FormaSello]
           ,[MostrarObra]
           ,[MostrarAdmin]
           ,[OrigenRecurso]
           ,[CuentaBancaria]
           ,[Separador]
           ,[Inicio]
           ,[Posiciones])
     VALUES
           (15,'Departamento',12,0,0,0,0,'-',null,null)
end

GO

