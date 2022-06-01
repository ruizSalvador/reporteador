UPDATE T_PresupuestoFlujo
   SET Modificado = (select SUM(t2.Estimado+t2.Ampliaciones+t2.Reducciones)
                   FROM T_PresupuestoFlujo AS t2
                  WHERE t1.Ejercicio = t2.Ejercicio
                  and t1.Mes = t2.Mes
                  AND t1.IdPartida = t2.IdPartida)
  FROM T_PresupuestoFlujo AS t1
