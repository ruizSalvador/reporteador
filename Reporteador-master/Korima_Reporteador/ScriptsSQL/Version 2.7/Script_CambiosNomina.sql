---Agregar Campo e Índice para C_ConceptosNomina

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, syscolumns SC
WHERE SO.id = SC.id
and SO.name = 'C_ConceptosNomina'
and SC.name = 'IdCategoriaProgramatica')

ALTER TABLE C_ConceptosNomina ADD IdCategoriaProgramatica smallint
GO

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, sysindexes SC
WHERE SO.id = SC.id
and SO.name = 'C_ConceptosNomina'
and SC.name = 'FK_CategoriaProgramatica')

CREATE INDEX FK_CategoriaProgramatica
ON C_ConceptosNomina (IdCategoriaProgramatica)
GO

---Agregar  Índices para T_SellosPresupuestales

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, sysindexes SC
WHERE SO.id = SC.id
and SO.name = 'T_SellosPresupuestales'
and SC.name = 'Ak_PartidaAreaCP')

CREATE INDEX Ak_PartidaAreaCP
ON T_SellosPresupuestales (IdPartida, IdAreaResp , LYear , IdProyecto )
GO

IF NOT EXISTS (
SELECT SC.name
FROM sysobjects SO, sysindexes SC
WHERE SO.id = SC.id
and SO.name = 'T_SellosPresupuestales'
and SC.name = 'Ak_PartidaAreaFFCP')

CREATE INDEX Ak_PartidaAreaFFCP
ON T_SellosPresupuestales (IdPartida, IdAreaResp, LYear, IdFuenteFinanciamiento, IdProyecto)
GO
