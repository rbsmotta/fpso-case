-- Qual nome do equipamento teve mais falhas?
  WITH fails_by_equipment AS(
    SELECT 
      COUNT(status) AS count_of_errors
      ,name
    FROM `liquid-optics-414518.trusted.tb_trusted_equipment_sensors_data`
    WHERE status = 'ERROR'
    GROUP BY name
  )
  SELECT
    count_of_errors
    ,name
  FROM
    fails_by_equipment
  ORDER BY
    count_of_errors DESC
  LIMIT 1