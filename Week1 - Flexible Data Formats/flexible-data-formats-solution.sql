--1 
SELECT event_id, event_time, user_id, platform,
  parameter_name, parameter_value
FROM dsv1069.events 
WHERE event_name = 'view_item'

--2
SELECT event_id,
  event_time, user_id,
  platform,
  (CASE 
  WHEN parameter_name = 'item_id' THEN CAST(parameter_value AS INT)
  ELSE NULL 
  END) AS item_id,
  (CASE 
  WHEN parameter_name = 'referrer' THEN parameter_value
  ELSE NULL 
  END) AS referrer
FROM dsv1069.events 
WHERE event_name = 'view_item'
ORDER BY event_id

-- 3
SELECT event_id,
  event_time, user_id,
  platform,
  MAX(CASE 
  WHEN parameter_name = 'item_id' THEN CAST(parameter_value AS INT)
  ELSE NULL 
  END) AS item_id,
  MAX(CASE 
  WHEN parameter_name = 'referrer' THEN parameter_value
  ELSE NULL 
  END) AS referrer
FROM dsv1069.events 
WHERE event_name = 'view_item'
GROUP BY event_id, event_time, user_id, platform
ORDER BY event_id
