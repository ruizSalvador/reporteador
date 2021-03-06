-- Cambios a Documentos Fuente de Guías Contabilizadoras de Kórima 2 derivados de las reformas CONAC del 27-09-2018
-- Guías reformadas: 4, 6, 13, 17, 19, 20, 27, 36, 38, 42, 49, 55, 57, 58, 59, 66, 68, 74, 87, 89, 90, 93, 95, 105, 106, 107,108,109,110,111,112,113,114,115

-- VII.1.1 
UPDATE C_DocumentosFuente SET Nombre='Ley de Ingresos Estimada o documento equivalente' WHERE IdDocumentoFuente=66;
UPDATE C_DocumentosFuente SET Nombre='Oficio de adecuación de la Ley de Ingresos Estimada o documento equivalente' WHERE IdDocumentoFuente=68;
UPDATE C_DocumentosFuente SET Nombre='Formato de pago autorizado, recibo oficial, estado de cuenta bancario o documento equivalente' WHERE IdDocumentoFuente=58;
-- II.1.1
UPDATE C_DocumentosFuente SET Nombre='Corte de caja, estado de cuenta bancario o documento equivalente' WHERE IdDocumentoFuente=38;
UPDATE C_DocumentosFuente SET Nombre='Copia de ficha de depósito, estado de cuenta bancario o documento equivalente' WHERE IdDocumentoFuente=57;
UPDATE C_DocumentosFuente SET Nombre='Formato de pago autorizado, recibo oficial, estado de cuenta bancario o documento equivalente' WHERE IdDocumentoFuente=59;
UPDATE C_DocumentosFuente SET Nombre='Autorización de la devolución por la autoridad correspondiente, oficio de autorización de pago de devolución de ingresos, copia del cheque, transferencia bancaria o documento equivalente' WHERE IdDocumentoFuente=6;
UPDATE C_DocumentosFuente SET Nombre='Oficio de autorización de recepción de bienes embargados o documento equivalente' WHERE IdDocumentoFuente=74;
UPDATE C_DocumentosFuente SET Nombre='Documento emitido por la autoridad competente' WHERE IdDocumentoFuente=42;
-- II.1.2
UPDATE C_DocumentosFuente SET Nombre='Resumen de distribución de Ingresos de la oficina recaudadora o documento equivalente' WHERE IdDocumentoFuente=95;
-- II.1.3 ok
-- II.1.4 ok
-- II.1.5 ok
-- II.1.6 ok
-- II.1.7
UPDATE C_DocumentosFuente SET Nombre='Contrato de compra-venta, comprobante fiscal o documento equivalente' WHERE IdDocumentoFuente=55;
UPDATE C_DocumentosFuente SET Nombre='Autorización de la devolución, copia del cheque, transferencia bancaria o documento equivalente' WHERE IdDocumentoFuente=7;
-- II.1.8
UPDATE C_DocumentosFuente SET Nombre='Estado de cuenta, transferencia bancaria o documento equivalente' WHERE IdDocumentoFuente=49;
UPDATE C_DocumentosFuente SET Nombre='Recibo oficial, estado de cuenta bancario o documento equivalente' WHERE IdDocumentoFuente=87;
UPDATE C_DocumentosFuente SET Nombre='Constancia de participaciones o documento equivalente' WHERE IdDocumentoFuente=19;
UPDATE C_DocumentosFuente SET Nombre='Copia del cheque, transferencia bancaria o documento equivalente' WHERE IdDocumentoFuente=4;
UPDATE C_DocumentosFuente SET Nombre='Recibo de cobro conforme al Calendario de pagos o documento equivalente' WHERE IdDocumentoFuente=13;
UPDATE C_DocumentosFuente SET Nombre='Convenio o documento equivalente' WHERE IdDocumentoFuente=36;


-- II.2.1
UPDATE C_DocumentosFuente SET Nombre='Recibo oficial, copia de ficha de depósito, transferencia bancaria o documento equivalente' WHERE IdDocumentoFuente=89;
-- VI.1.1
UPDATE C_DocumentosFuente SET Nombre='Contrato o documento equivalente' WHERE IdDocumentoFuente=20;
UPDATE C_DocumentosFuente SET Nombre='Valor de moneda publicado en Diario Oficial de la Federación, reporte operativo de la Tesorería o documento equivalente' WHERE IdDocumentoFuente=93;
UPDATE C_DocumentosFuente SET Nombre='Información del Banco de México o agente financiero, o documento equivalente' WHERE IdDocumentoFuente=90;
UPDATE C_DocumentosFuente SET Nombre='Contrato de Crédito o documento equivalente' WHERE IdDocumentoFuente=27;
UPDATE C_DocumentosFuente SET Nombre='Copia del cheque, copia de ficha de depósito, transferencia bancaria o documento equivalente' WHERE IdDocumentoFuente=17;

DELETE FROM C_DocumentosFuente WHERE IdDocumentoFuente IN (106,115,116,117);
INSERT INTO [dbo].[C_DocumentosFuente]
           ([IdDocumentoFuente], [Nombre])
     VALUES
 (106,'Importe del valor negociable publicado en Diario Oficial de la Federación, reporte operativo de la Tesorería o documento equivalente') -- Para VI.1.1 Ev20, Ev21
,(115,'Autorización de la devolución por la autoridad fiscal correspondiente, oficio de autorización de pago de devolución de ingresos, copia del cheque, transferencia bancaria o documento equivalente')
,(116,'Evidencia documental del valor actualizado')
,(117,'Documento soporte de la conclusión de la obra.')
;





-- VI.3.1
UPDATE C_DocumentosFuente SET Nombre='Cheque y/o transferencia bancaria' WHERE IdDocumentoFuente=105;