-- Quantidade média de falhas por grupo de equipamentos, ordenada pelo número de falhas em ordem ascendente?
WITH fails_by_group AS (
  SELECT 
    COUNT(status) AS count_of_errors,
    group_name
  FROM `liquid-optics-414518.trusted.tb_trusted_equipment_sensors_data`
  WHERE status = 'ERROR'
  GROUP BY group_name
),
sum_total_of_errors AS (
  SELECT
    SUM(count_of_errors) AS sum_total
  FROM fails_by_group
)
SELECT
  f.count_of_errors / s.sum_total AS error_ratio,
  f.group_name
FROM
  fails_by_group f
JOIN
  sum_total_of_errors s
ON
  1=1
ORDER BY error_ratio ASC