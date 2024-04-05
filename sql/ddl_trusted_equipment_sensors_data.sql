CREATE OR REPLACE TABLE trusted.tb_trusted_equipment_sensors_data AS (
  WITH transformed_equipament_failure_sensors AS (
    SELECT
      CASE
        WHEN status != 'WARNING' THEN PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', REPLACE(REPLACE(date, '[', ''), ']', '')) 
        WHEN status = 'WARNING' THEN PARSE_TIMESTAMP('%Y/%m/%d', REPLACE(REPLACE(date, '[', ''), ']', '')) 
      END AS info_date,
      status,
      REGEXP_EXTRACT(sensor, r'\[(\d+)\]') AS sensor_id_tefs,
      CAST(REPLACE(info2, ', vibration', '') AS FLOAT64) AS temperature,
      CASE
        WHEN info3 = 'err)' THEN NULL
        WHEN info3 != 'err)' THEN CAST(REPLACE(info3, ')', '') AS FLOAT64)
      END AS vibration
    FROM `liquid-optics-414518.raw.et_raw_equipment_failure_sensors`
  ),
  equipments_join AS (
    SELECT 
      ere.equipment_id
      ,ere.name
      ,ere.group_name
      ,eres.sensor_id
    FROM `liquid-optics-414518.raw.et_raw_equipment` AS ere
    JOIN `liquid-optics-414518.raw.et_raw_equipment_sensors` AS eres
    ON ere.equipment_id = eres.equipment_id
  )
    SELECT
      info_date
      ,status
      ,sensor_id_tefs AS sensor_id
      ,temperature
      ,vibration
      ,equipment_id
      ,name
      ,group_name
    FROM
      transformed_equipament_failure_sensors tefs
    JOIN
      equipments_join ej
    ON
      tefs.sensor_id_tefs = CAST(ej.sensor_id AS STRING)
);