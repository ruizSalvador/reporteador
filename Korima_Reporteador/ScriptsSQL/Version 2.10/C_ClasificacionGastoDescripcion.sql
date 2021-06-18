UPDATE C_ClasificacionGasto SET Descripcion = 'Corriente' where Clave in('51000','61000')
UPDATE C_ClasificacionGasto SET Descripcion = 'Capital' where Clave in('52000','62000')
UPDATE C_TipoGasto SET NOMBRE = 'Amortización de la Deuda y Disminución de Pasivos' where Clave in('3')
