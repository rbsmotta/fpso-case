-- Classifique os sensores que apresentam o maior número de erros por nome de equipamento em um grupo de equipamentos.
WITH fails_by_equipment AS(
  SELECT 
    COUNT(status) AS count_of_sensors_errors
    ,sensor_id
    ,name
    ,group_name
  FROM `liquid-optics-414518.trusted.tb_trusted_equipment_sensors_data`
  WHERE status = 'ERROR'
  GROUP BY sensor_id, name, group_name
)
, rn_cta AS(
  SELECT 
    *
    ,ROW_NUMBER() OVER (PARTITION BY name ORDER BY count_of_sensors_errors DESC) as sensor_rank 
  FROM fails_by_equipment
), rn_cta2 AS(
  SELECT 
    rn_cta.count_of_sensors_errors
    ,name as equipment_name
    ,group_name
    ,ROW_NUMBER() OVER (PARTITION BY group_name ORDER BY count_of_sensors_errors DESC) as group_rank 
  FROM rn_cta
)
SELECT
  rn_cta2.count_of_sensors_errors
  ,rn_cta2.equipment_name
  ,group_name
FROM
  rn_cta2
WHERE group_rank < 2