ALTER TABLE C_ClasificadorGeograficoPresupuestal DROP CONSTRAINT PK__C_ClasificadorGe__25918339

ALTER TABLE C_ClasificadorGeograficoPresupuestal
ALTER COLUMN IdClasificadorGeografico INT NOT NULL

ALTER TABLE C_ClasificadorGeograficoPresupuestal
ALTER COLUMN IdClasificadorGeograficoPadre INT

ALTER TABLE C_ClasificadorGeograficoPresupuestal ADD CONSTRAINT PK__C_ClasificadorGe__25918339 PRIMARY KEY (IdClasificadorGeografico)