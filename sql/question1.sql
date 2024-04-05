-- Quantidade total de falhas de equipamento que ocorreram?
  WITH fails_by_equipment AS(
    SELECT 
      COUNT(status) AS count_of_errors
      ,equipment_id
    FROM `liquid-optics-414518.trusted.tb_trusted_equipment_sensors_data`
    WHERE status = 'ERROR'
    GROUP BY equipment_id
  )
  SELECT 
    SUM(count_of_errors) AS total_equipments_fails
  FROM 
    fails_by_equipment