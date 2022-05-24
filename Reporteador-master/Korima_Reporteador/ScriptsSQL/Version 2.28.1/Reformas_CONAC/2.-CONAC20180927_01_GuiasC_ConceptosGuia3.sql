-- Cambios a Conceptos de Guías Contabilizadoras de Kórima 2 derivados de las reformas CONAC del 27-09-2018

-- VII.1.1 lista (no requiere cambio en cuentas)
UPDATE C_ConceptosGuia SET Concepto='Por la Ley de Ingresos Estimada' WHERE IdConcepto=2;
UPDATE C_ConceptosGuia SET Concepto='Por las modificaciones positivas a la estimación de la Ley de Ingresos' WHERE IdConcepto=3;
UPDATE C_ConceptosGuia SET Concepto='Por las modificaciones negativas a la estimación de la Ley de Ingresos' WHERE IdConcepto=4;
UPDATE C_ConceptosGuia SET Concepto='Por los ingresos devengados' WHERE IdConcepto=5;
UPDATE C_ConceptosGuia SET Concepto='Por los ingresos recaudados' WHERE IdConcepto=6;

-- II.1.1 lista 
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de impuestos, previamente recaudados en efectivo' WHERE IdConcepto=17;
UPDATE C_ConceptosGuia SET Concepto='Por la clasificación de ingresos devengados, previamente recaudados, por concepto de impuestos' WHERE IdConcepto=18;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado de impuestos determinables. 1' WHERE IdConcepto=19;
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo de impuestos determinables recibidos en la Tesorería y/o auxiliares de la misma. 1 y 2' WHERE IdConcepto=20;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de impuestos determinables, recaudados en efectivo' WHERE IdConcepto=21;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado y la recaudación en efectivo de impuestos autodeterminables, recibidos en la Tesorería y/o auxiliares de la misma' WHERE IdConcepto=22;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de impuestos autodeterminables, recaudados en efectivo' WHERE IdConcepto=23;
UPDATE C_ConceptosGuia SET Concepto='Por la autorización y el pago de la devolución de impuestos. 1' WHERE IdConcepto=24;
UPDATE C_ConceptosGuia SET Concepto='Por los impuestos compensados' WHERE IdConcepto=25;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado al formalizarse el convenio de pago en parcialidades o diferido de impuestos, incluye los accesorios determinados. 1' WHERE IdConcepto=26;
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo de parcialidades o pago diferido, derivada del convenio formalizado para pago de impuestos. 1 y 2' WHERE IdConcepto=27;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de parcialidades o pago diferido de impuestos, recaudados en efectivo' WHERE IdConcepto=28;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado al formalizarse la resolución judicial definitiva por incumplimiento de pago de impuestos, incluye los accesorios determinados' WHERE IdConcepto=29;
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo de la resolución judicial definitiva por incumplimiento de pago de impuestos' WHERE IdConcepto=30;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de impuestos recaudados en efectivo, por resolución judicial definitiva' WHERE IdConcepto=31;
UPDATE C_ConceptosGuia SET Concepto='Por el cobro en especie de la resolución judicial definitiva por impuestos. 1 y 2' WHERE IdConcepto=32;
-- Evento 33 sin cambio
UPDATE C_ConceptosGuia SET Concepto='Por el devengado por deudores morosos por incumplimiento de pago de impuestos, incluye los accesorios determinados. 1' WHERE IdConcepto=34;
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo por deudores morosos por incumplimiento de pago de impuestos. 1 y 2' WHERE IdConcepto=35;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de impuestos recaudados en efectivo, por deudores morosos por incumplimiento de pago' WHERE IdConcepto=36;

-- II.1.2 lista
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de cuotas y aportaciones de seguridad social, previamente recaudadas en efectivo' WHERE IdConcepto=38;
UPDATE C_ConceptosGuia SET Concepto='Por la clasificación de ingresos devengados, previamente recaudados, por concepto de cuotas y aportaciones de seguridad social' WHERE IdConcepto=39;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado de cuotas y aportaciones de seguridad social determinables. 1' WHERE IdConcepto=40;
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo de cuotas y aportaciones de seguridad social determinables, recibidas en la Tesorería y/o auxiliares de la misma. 1 y 2', IdDocumentoFuente=115 WHERE IdConcepto=41;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de cuotas y aportaciones de seguridad social determinables, recaudadas en efectivo' WHERE IdConcepto=42;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado y la recaudación en efectivo de cuotas y aportaciones de seguridad social autodeterminables, recibidas en la Tesorería y/o auxiliares de la misma' WHERE IdConcepto=43;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de cuotas y aportaciones de seguridad social autodeterminables, recaudadas en efectivo' WHERE IdConcepto=44;
UPDATE C_ConceptosGuia SET Concepto='Por la autorización y el pago de la devolución de cuotas y aportaciones de seguridad social. 1' WHERE IdConcepto=45;
UPDATE C_ConceptosGuia SET Concepto='Por las cuotas y aportaciones de seguridad social compensadas' WHERE IdConcepto=46;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado al formalizarse el convenio de pago en parcialidades o diferido de cuotas y aportaciones de seguridad social, incluye los accesorios determinados. 1' WHERE IdConcepto=47;
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo de parcialidades o pago diferido, derivada del convenio formalizado para pago de cuotas y aportaciones de seguridad social. 1 y 2' WHERE IdConcepto=48;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de parcialidades o pago diferido de cuotas y aportaciones de seguridad social, recaudadas en efectivo' WHERE IdConcepto=49;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado al formalizarse la resolución judicial definitiva por incumplimiento de pago de cuotas y aportaciones de seguridad social, incluye los accesorios determinados. 1' WHERE IdConcepto=50;
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo de la resolución judicial definitiva por incumplimiento de pago de cuotas y aportaciones de seguridad social. 1 y 2' WHERE IdConcepto=51;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de cuotas y aportaciones de seguridad social recaudadas en efectivo, por la resolución judicial definitiva' WHERE IdConcepto=52;
UPDATE C_ConceptosGuia SET Concepto='Por el cobro en especie de cuotas y aportaciones de seguridad social originada en la resolución judicial definitiva. 1 y 2' WHERE IdConcepto=53;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado por deudores morosos por incumplimiento de pago de cuotas y aportaciones de seguridad social, incluye los accesorios determinados. 1' WHERE IdConcepto=55;
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo por deudores morosos por incumplimiento de pago de cuotas y aportaciones de seguridad social. 1' WHERE IdConcepto=56;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de cuotas y aportaciones de seguridad social recaudadas en efectivo, por deudores morosos por incumplimiento de pago' WHERE IdConcepto=57;

-- II.1.3 lista
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de contribuciones de mejoras, previamente recaudadas en efectivo' WHERE IdConcepto=59; -- evento 2
UPDATE C_ConceptosGuia SET Concepto='Por la clasificación de ingresos devengados, previamente recaudados, por concepto de contribuciones de mejoras' WHERE IdConcepto=60;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado de contribuciones de mejoras determinables. 1' WHERE IdConcepto=61;
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo de contribuciones de mejoras determinables, recibidas en la Tesorería y/o auxiliares de la misma. 1 y 2' WHERE IdConcepto=62;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de contribuciones de mejoras determinables, recaudadas en efectivo' WHERE IdConcepto=63;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado y la recaudación en efectivo de contribuciones de mejoras autodeterminables, recibidas en la Tesorería y/o auxiliares de la misma' WHERE IdConcepto=64;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de contribuciones de mejoras autodeterminables, recaudadas en efectivo' WHERE IdConcepto=65;
UPDATE C_ConceptosGuia SET Concepto='Por la autorización y el pago de la devolución de contribuciones de mejoras. 1' WHERE IdConcepto=66;

-- II.1.4 lista
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de derechos, previamente recaudados en efectivo' WHERE IdConcepto=69;
UPDATE C_ConceptosGuia SET Concepto='Por la clasificación de ingresos devengados, previamente recaudados, por concepto de derechos' WHERE IdConcepto=70;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado de derechos determinables. 1' WHERE IdConcepto=71;
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo de derechos determinables, recibidos en la Tesorería y/o auxiliares de la misma. 1 y 2' WHERE IdConcepto=72;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de derechos determinables, recaudados en efectivo' WHERE IdConcepto=73;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado y la recaudación en efectivo de derechos autodeterminables, recibidos en la Tesorería y/o auxiliares de la misma' WHERE IdConcepto=74;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de derechos autodeterminables, recaudados en efectivo' WHERE IdConcepto=75;
UPDATE C_ConceptosGuia SET Concepto='Por la autorización y el pago de la devolución de derechos. 1' WHERE IdConcepto=76;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado al formalizarse el convenio de pago en parcialidades o diferido de derechos, incluye los accesorios determinados. 1' WHERE IdConcepto=78;
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo de parcialidades o pago diferido, derivada del convenio formalizado para pago de derechos. 1 y 2' WHERE IdConcepto=79;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de parcialidades o pago diferido de derechos, recaudados en efectivo' WHERE IdConcepto=80;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado al formalizarse la resolución judicial definitiva por incumplimiento de pago de derechos, incluye los accesorios determinados. 1' WHERE IdConcepto=81;
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo de la resolución judicial definitiva por incumplimiento de pago de derechos. 1 y 2' WHERE IdConcepto=82;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de derechos recaudados en efectivo, por la resolución judicial definitiva' WHERE IdConcepto=83;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado por deudores morosos por incumplimiento de pago de derechos, incluye los accesorios determinados. 1' WHERE IdConcepto=84;
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo por deudores morosos por incumplimiento de pago de derechos. 1' WHERE IdConcepto=85;
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de derechos recaudados en efectivo, por deudores morosos por incumplimiento de pago' WHERE IdConcepto=86;

-- II.1.5 -- Falta dar de alta eventos 11 y 12. Esta guía tiene eventos nuevos, revisar
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de productos, previamente recaudados en efectivo' WHERE IdGuia=6 AND Numero='02';
UPDATE C_ConceptosGuia SET Concepto='Por la clasificación de ingresos devengados, previamente recaudados, por concepto de Productos' WHERE IdGuia=6 AND Numero='03';
UPDATE C_ConceptosGuia SET Concepto='Por el devengado de productos determinables. 1' WHERE IdGuia=6 AND Numero='04';
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo de productos determinables, recibidos en la Tesorería y/o auxiliares de la misma. 1 y 2' WHERE IdGuia=6 AND Numero='05';
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de productos determinables, recaudados en efectivo' WHERE IdGuia=6 AND Numero='06';
UPDATE C_ConceptosGuia SET Concepto='Por el devengado y la recaudación en efectivo de productos autodeterminables, recibidos en la Tesorería y/o auxiliares de la misma' WHERE IdGuia=6 AND Numero='07';
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de productos autodeterminables, recaudados en efectivo' WHERE IdGuia=6 AND Numero='08';
UPDATE C_ConceptosGuia SET Concepto='Por la autorización y el pago de la devolución de productos' WHERE IdGuia=6 AND Numero='09';
UPDATE C_ConceptosGuia SET Concepto='Por los productos compensados' WHERE IdGuia=6 AND Numero='10';
-- cambio en frecuencia
UPDATE C_ConceptosGuia SET periodicidad='Frecuente' WHERE IdGuia=6 AND Numero='01';


-- II.1.6 lista
UPDATE C_ConceptosGuia SET Concepto='Por los ingresos por clasificar' WHERE IdGuia=7 AND Numero='01';
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de aprovechamientos, previamente recaudados en efectivo' WHERE IdGuia=7 AND Numero='02';
UPDATE C_ConceptosGuia SET Concepto='Por la clasificación de ingresos devengados, previamente recaudados, por concepto de aprovechamientos' WHERE IdGuia=7 AND Numero='03';
UPDATE C_ConceptosGuia SET Concepto='Por el devengado de aprovechamientos determinables. 1' WHERE IdGuia=7 AND Numero='04';
UPDATE C_ConceptosGuia SET Concepto='Por la recaudación en efectivo de aprovechamientos determinables, recibidos en la Tesorería y/o auxiliares de la misma. 1 y 2' WHERE IdGuia=7 AND Numero='05';
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de aprovechamientos determinables, recaudados en efectivo' WHERE IdGuia=7 AND Numero='06';
UPDATE C_ConceptosGuia SET Concepto='Por el devengado y la recaudación en efectivo de aprovechamientos autodeterminables, recibidos en la Tesorería y/o auxiliares de la misma' WHERE IdGuia=7 AND Numero='07';
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de aprovechamientos autodeterminables, recaudados en efectivo' WHERE IdGuia=7 AND Numero='08';
UPDATE C_ConceptosGuia SET Concepto='Por la autorización y el pago de la devolución de aprovechamientos' WHERE IdGuia=7 AND Numero='09';
UPDATE C_ConceptosGuia SET Concepto='Por los aprovechamientos compensados' WHERE IdGuia=7 AND Numero='10';
-- cambio de frecuencia
UPDATE C_ConceptosGuia SET periodicidad='Frecuente' WHERE IdGuia=7 AND Numero='10';

-- II.1.7 lista
UPDATE C_ConceptosGuia SET Concepto='Por el devengado al realizarse la venta de bienes y prestación de servicios, incluye Impuesto al Valor Agregado. 1 y 2' WHERE IdGuia=8 AND Numero='01';
UPDATE C_ConceptosGuia SET Concepto='Por el cobro de ingresos por venta de bienes y prestación de servicios. 1' WHERE IdGuia=8 AND Numero='02';
UPDATE C_ConceptosGuia SET Concepto='Por los depósitos en bancos de ingresos por venta de bienes y prestación de servicios, cobrados en efectivo' WHERE IdGuia=8 AND Numero='03';
UPDATE C_ConceptosGuia SET Concepto='Por la autorización y el pago de la devolución de los ingresos por venta de bienes y prestación de servicios. 1 y 2' WHERE IdGuia=8 AND Numero='04';

-- II.2.1 lista
-- Cambio de nombre de guía
UPDATE C_GuiaContable SET Nombre='Aprovechamientos patrimoniales por venta de bienes inmuebles, muebles e intangibles' WHERE Clave='II.2.1'
UPDATE C_ConceptosGuia SET Concepto='Por el devengado de aprovechamientos patrimoniales por venta de bienes inmuebles a su valor en libros y baja del bien. 1' WHERE IdGuia=10 AND Numero='01';
UPDATE C_ConceptosGuia SET Concepto='Por el devengado de aprovechamientos patrimoniales por venta de bienes inmuebles con pérdida y baja del bien. 1' WHERE IdGuia=10 AND Numero='02';
UPDATE C_ConceptosGuia SET Concepto='Por el devengado de aprovechamientos patrimoniales por venta de bienes inmuebles con utilidad y baja del bien. 1' WHERE IdGuia=10 AND Numero='03';
UPDATE C_ConceptosGuia SET Concepto='Por el cobro de aprovechamientos patrimoniales por venta de bienes inmuebles. 1' WHERE IdGuia=10 AND Numero='04';
UPDATE C_ConceptosGuia SET Concepto='Por el depósito en bancos de los ingresos de aprovechamientos patrimoniales por venta de bienes inmuebles recibidos en efectivo.' WHERE IdGuia=10 AND Numero='05';
DELETE FROM C_ConceptosGuia WHERE IdConcepto IN (136,137); -- Eliminación de eventos 6 y 7
DELETE FROM D_CuentasGuia WHERE IdConcepto IN (136,137); -- Eliminación de eventos 6 y 7


-- II.3.1 lista

-- III.1.6 (Detectado por BV)
UPDATE C_GuiaContable SET Nombre='Interés, Comisiones y Otros Gastos de la Deuda Pública' WHERE IdGuia=16;
-- V.1.4  (Detectado por BV)
UPDATE C_GuiaContable SET Nombre='Bienes Concesión' WHERE IdGuia=24;

-- VI.1.1 lista
-- Cambio de nombre y de clave de guía
UPDATE C_GuiaContable SET Nombre='Deuda Pública', Clave='VI.1.1' WHERE IdGuia=34;
DELETE FROM C_ConceptosGuia WHERE IdConcepto=333; -- Eliminación de evento 9
DELETE FROM D_CuentasGuia WHERE IdConcepto=333; -- Eliminación de evento 9
UPDATE C_ConceptosGuia SET Concepto='Por la emisión de títulos y valores de deuda pública interna y/o externa (financiamiento)' WHERE IdConcepto=325; -- Ev1 (BV)
UPDATE C_ConceptosGuia SET Concepto='Por la colocación de títulos y valores de deuda pública interna y/o externa' WHERE IdConcepto=326; -- Ev2 (BV)
UPDATE C_ConceptosGuia SET Concepto='Por la colocación de títulos y valores de la deuda pública interna a la par' WHERE IdConcepto=327; -- Ev3 (BV)
UPDATE C_ConceptosGuia SET Concepto='Registro de la colocación de títulos y valores de la deuda pública interna sobre la par' WHERE IdConcepto=328; -- Ev4 (BV)
UPDATE C_ConceptosGuia SET Concepto='Por la colocación de títulos y valores de la deuda pública interna bajo la par' WHERE IdConcepto=329; -- Ev5 (BV)
UPDATE C_ConceptosGuia SET Concepto='Por la colocación de títulos y valores de la deuda pública externa a la par' WHERE IdConcepto=330; -- Ev6 (BV)
UPDATE C_ConceptosGuia SET Concepto='Por la colocación de títulos y valores de la deuda pública externa sobre la par' WHERE IdConcepto=331; -- Ev7 (BV)
UPDATE C_ConceptosGuia SET Concepto='Por la colocación de títulos y valores de la deuda pública externa bajo la par' WHERE IdConcepto=332; -- Ev8 (BV)
UPDATE C_ConceptosGuia SET IdDocumentoFuente=93 WHERE IdConcepto=395;
UPDATE C_ConceptosGuia SET IdDocumentoFuente=106 WHERE IdConcepto IN (396, 397);
UPDATE C_ConceptosGuia SET Numero='09', Concepto='Por la porción de la deuda pública interna por la colocación de títulos y valores de largo plazo a corto plazo' WHERE IdConcepto=334; -- Antes Ev10
UPDATE C_ConceptosGuia SET Numero='10', Concepto='Por la porción de la deuda pública externa por la colocación de títulos y valores de largo plazo a corto plazo' WHERE IdConcepto=335; -- Antes Ev11
UPDATE C_ConceptosGuia SET Numero='11', Concepto='Por la obtención de préstamos considerados deuda pública interna y/o externa (financiamiento)' WHERE IdConcepto=336; -- Antes Ev12
UPDATE C_ConceptosGuia SET Numero='12', Concepto='Por el pago de préstamos considerados deuda pública interna y/o externa'  WHERE IdConcepto=337; -- Antes Ev13
UPDATE C_ConceptosGuia SET Numero='13', Concepto='Por el ingreso de fondos de la deuda pública interna y/o externa derivado de la obtención de préstamos'  WHERE IdConcepto=338; -- Antes Ev14
UPDATE C_ConceptosGuia SET Numero='14', Concepto='Por la porción de la deuda pública interna por los préstamos obtenidos de largo plazo a corto plazo', IdDocumentoFuente=28 WHERE IdConcepto=339; -- Antes Ev15
UPDATE C_ConceptosGuia SET Numero='15', Concepto='Por la porción de la deuda pública externa por los préstamos obtenidos de largo plazo a corto plazo', IdDocumentoFuente=28 WHERE IdConcepto=340; -- Antes Ev16
UPDATE C_ConceptosGuia SET Numero='16' WHERE IdConcepto=341; -- Antes Ev17
UPDATE C_ConceptosGuia SET Numero='17' WHERE IdConcepto=342; -- Antes Ev18
UPDATE C_ConceptosGuia SET Numero='18', Concepto='Por el decremento de la deuda pública externa derivado de la actualización por tipo de cambio' WHERE IdConcepto=394; -- Antes Ev19
UPDATE C_ConceptosGuia SET Numero='19', Concepto='Por el incremento de la deuda pública externa derivado de la actualización por tipo de cambio' WHERE IdConcepto=395; -- Antes Ev20
UPDATE C_ConceptosGuia SET Numero='20', Concepto='Por el decremento de la deuda pública interna derivado de la actualización de valores negociables' WHERE IdConcepto=396; -- Antes Ev21
UPDATE C_ConceptosGuia SET Numero='21', Concepto='Por el incremento de la deuda pública interna derivado de la actualización de valores negociables' WHERE IdConcepto=397; -- Antes Ev22

-- VI.2.1 lista

-- VI.3.1 lista
-- Cambio de clave de guía
UPDATE C_GuiaContable SET Clave='VI.3.1' WHERE IdGuia=35; -- no tiene cambios en Conceptos
UPDATE C_ConceptosGuia SET Numero='04' WHERE IdConcepto=346;
UPDATE C_ConceptosGuia SET Numero='05' WHERE IdConcepto=347;

-- VI.4.1 lista-- no tiene cambios en Conceptos, documentos, cuentas
-- Cambio de clave de guía
UPDATE C_GuiaContable SET Clave='VI.4.1' WHERE IdGuia=36; 

-- VI.5.1 Inversiones lista

-- VI.5.2 lista
-- Cambio de nombre y de clave de guía (de VI.5 a VI.5.2)
UPDATE C_GuiaContable SET Nombre='Inversiones en Fideicomisos, Mandatos y Contratos Análogos', Clave='VI.5.2' WHERE IdGuia=37;
UPDATE C_ConceptosGuia SET Concepto='Por el devengado y el pago de fideicomisos, mandatos y contratos análogos' WHERE IdConcepto=352; -- Ev1 (BV)

-- VI.5.3 lista

-- VII.1.1  (Detectado por BV)
UPDATE C_GuiaContable SET Nombre='Registros Presupuestario de la Ley de Ingresos' WHERE IdGuia=38;


-- VIII.1.1 lista
UPDATE C_ConceptosGuia SET Concepto='Por el registro al cierre del ejercicio por el traspaso del saldo de cuentas de ingresos' WHERE IdGuia=43 AND Numero=01;
UPDATE C_ConceptosGuia SET Concepto='Por el registro al cierre del ejercicio por el traspaso del saldo de cuentas de gastos' WHERE IdGuia=43 AND Numero=02;

-- VIII.1.3 lista
-- Cambio del evento 2 al 4 y renumeración
UPDATE C_ConceptosGuia SET Numero='04' WHERE IdConcepto=375
UPDATE C_ConceptosGuia SET Numero='02' WHERE IdConcepto=376
UPDATE C_ConceptosGuia SET Numero='03' WHERE IdConcepto=377
UPDATE C_ConceptosGuia SET Concepto='Asiento Final de los gastos durante el ejercicio –Determinación de Adeudos de Ejercicios Fiscales Anteriores-' WHERE IdGuia=45 AND Numero=09;
UPDATE C_ConceptosGuia SET Concepto='Cierre presupuestario del Ejercicio con Superávit Financiero' WHERE IdGuia=45 AND Numero=12;
UPDATE C_ConceptosGuia SET Concepto='Cierre presupuestario del Ejercicio con Déficit Financiero' WHERE IdGuia=45 AND Numero=13;


