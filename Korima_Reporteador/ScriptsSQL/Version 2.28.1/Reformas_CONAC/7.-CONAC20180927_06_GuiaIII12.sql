-- Cambios del 20141222
-- Creación de eventos faltantes en la Guía III.2.1

declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

DELETE FROM [C_ConceptosGuia] WHERE IdGuia=17 AND Numero IN ('04','05','06');
DECLARE @ConsecEv INT = (SELECT MAX (IdConcepto) FROM C_ConceptosGuia) 
INSERT INTO [dbo].[C_ConceptosGuia]
           ([IdConcepto],[IdGuia],[Numero],[Concepto],[Periodicidad],[IdDocumentoFuente],[CONAC],[IdTipoMovimiento],[Automatizado],[TipoMovimientoOperativoContable],[Orden],[CondicionRango1],[CondicionRango2],[Condicionante])
     VALUES
 (@ConsecEv+1,17,'04','Por el incremento del valor de los bienes derivado de la actualización por revaluación','Eventual',116,1,14,NULL,NULL,0,NULL,NULL,NULL)
,(@ConsecEv+2,17,'05','Por el decremento del valor de los bienes derivado de la actualización por revaluación.','Eventual',116,1,14,NULL,NULL,0,NULL,NULL,NULL)
,(@ConsecEv+3,17,'06','Por la baja de bienes derivado por pérdida, obsolescencia, deterioro, extravío, robo o siniestro, entre otros.','Eventual',116,1,14,NULL,NULL,0,NULL,NULL,NULL)
;

DECLARE @1704 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=17 AND Numero='04');
DECLARE @1705 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=17 AND Numero='05');
DECLARE @1706 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=17 AND Numero='06');
DELETE FROM D_CuentasGuia WHERE IdConcepto IN (@1704,@1705,@1706)
DECLARE @ConsecCtasG INT = (SELECT MAX (IdCuentasGuia) FROM D_CuentasGuia) 
INSERT INTO [dbo].[D_CuentasGuia]
           ([IdCuentasGuia],[IdConcepto],[IdCuenta],[Cuenta],[Numero],[TipoAfectacion],[TipoCuenta],[Observaciones])
     VALUES
 (@ConsecCtasG+1,@1704,84,'1231'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Opcional',NULL) -- Ev04
,(@ConsecCtasG+2,@1704,1004,'3231'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev04
,(@ConsecCtasG+3,@1704,860,'1232'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Cargo','Opcional',NULL) -- Ev04
,(@ConsecCtasG+4,@1704,393,'1233'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Cargo','Opcional',NULL) -- Ev04
,(@ConsecCtasG+5,@1704,86,'1234'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Cargo','Opcional',NULL) -- Ev04
,(@ConsecCtasG+6,@1705,1004,'3231'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev05
,(@ConsecCtasG+7,@1705,84,'1231'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Opcional',NULL) -- Ev05
,(@ConsecCtasG+8,@1705,860,'1232'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional',NULL) -- Ev05
,(@ConsecCtasG+9,@1705,393,'1233'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional',NULL) -- Ev05
,(@ConsecCtasG+10,@1705,86,'1234'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional',NULL) -- Ev05
,(@ConsecCtasG+11,@1706,1651,'5518'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev06
,(@ConsecCtasG+12,@1706,84,'1231'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Opcional',NULL) -- Ev06
,(@ConsecCtasG+13,@1706,860,'1232'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional',NULL) -- Ev06
,(@ConsecCtasG+14,@1706,393,'1233'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional',NULL) -- Ev06
,(@ConsecCtasG+15,@1706,86,'1234'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional',NULL) -- Ev06
,(@ConsecCtasG+16,@1706,1004,'3231'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,5,'Cargo','Requerido',NULL) -- Ev06
,(@ConsecCtasG+17,@1706,1004,'3231'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,5,'Abono','Requerido',NULL) -- Ev06
;
