-- Cambios del 20141222
-- Creación de eventos faltantes en la Guía III.2.2

declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

DELETE FROM [C_ConceptosGuia] WHERE IdGuia=18 AND Numero IN ('.08a','.08b','14a','14b');
DECLARE @ConsecEv INT = (SELECT MAX (IdConcepto) FROM C_ConceptosGuia) 
INSERT INTO [dbo].[C_ConceptosGuia]
           ([IdConcepto],[IdGuia],[Numero],[Concepto],[Periodicidad],[IdDocumentoFuente],[CONAC],[IdTipoMovimiento],[Automatizado],[TipoMovimientoOperativoContable],[Orden],[CondicionRango1],[CondicionRango2],[Condicionante])
     VALUES
 (@ConsecEv+1,18,'.08a','Por el registro de la obra pública no capitalizable, al concluir la obra por el importe correspondiente a los recursos del mismo ejercicio','Frecuente',117,1,NULL,NULL,NULL,0,NULL,NULL,NULL)
,(@ConsecEv+2,18,'.08b','Por el registro de la obra pública no capitalizable, al concluir la obra por el importe correspondiente a los recursos de ejercicios anteriores','Frecuente',117,1,NULL,NULL,NULL,0,NULL,NULL,NULL)
,(@ConsecEv+3,18,'14a','Por el registro de la obra pública no capitalizable, al concluir la obra por el importe correspondiente a los recursos del mismo ejercicio','Frecuente',52,1,NULL,NULL,NULL,0,NULL,NULL,NULL)
,(@ConsecEv+4,18,'14b','Por el registro de la obra pública no capitalizable, al concluir la obra por el importe correspondiente a los recursos de ejercicios anteriores','Frecuente',52,1,NULL,NULL,NULL,0,NULL,NULL,NULL)
;

DECLARE @1808a INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=18 AND Numero='.08a');
DECLARE @1808b INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=18 AND Numero='.08b');
DECLARE @1814a INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=18 AND Numero='14a');
DECLARE @1814b INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=18 AND Numero='14b');
DELETE FROM D_CuentasGuia WHERE IdConcepto IN (@1808a,@1808b)
DECLARE @ConsecCtasG INT = (SELECT MAX (IdCuentasGuia) FROM D_CuentasGuia) 
INSERT INTO [dbo].[D_CuentasGuia]
           ([IdCuentasGuia],[IdConcepto],[IdCuenta],[Cuenta],[Numero],[TipoAfectacion],[TipoCuenta],[Observaciones])
     VALUES
 (@ConsecCtasG+1,@1808a,1649,'5611'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev08a
,(@ConsecCtasG+2,@1808a,86,'1234'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev08a
,(@ConsecCtasG+3,@1808a,88,'1235'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Requerido',NULL) -- Ev08a
,(@ConsecCtasG+4,@1808b,186,'322'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev08b
,(@ConsecCtasG+5,@1808b,86,'1234'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev08b
,(@ConsecCtasG+6,@1808b,88,'1235'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Requerido',NULL) -- Ev08b

,(@ConsecCtasG+7,@1814a,1649,'5611'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev14a
,(@ConsecCtasG+8,@1814a,86,'1234'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev14a
,(@ConsecCtasG+9,@1814a,88,'1235'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Requerido',NULL) -- Ev14a
,(@ConsecCtasG+10,@1814b,186,'322'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev14b
,(@ConsecCtasG+11,@1814b,86,'1234'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev14b
,(@ConsecCtasG+12,@1814b,88,'1235'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Requerido',NULL) -- Ev14b
;
