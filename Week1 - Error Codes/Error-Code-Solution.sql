-- 1
SELECT email_address, deleted_at
FROM dsv1069.users 
WHERE deleted_at IS NULL;

-- 2 
SELECT category, COUNT(DISTINCT id)
FROM dsv1069.items 
GROUP BY category;

-- 3
SELECT *
FROM dsv1069.users u JOIN dsv1069.orders o
ON u.id = o.user_id;

-- 4
SELECT COUNT(DISTINCT event_id) AS events
FROM dsv1069.events
WHERE event_name = 'view_item';

-- 5
SELECT COUNT(DISTINCT id)
FROM dsv1069.orders JOIN dsv1069.items 
ON orders.item_id = items.id;

-- 6 
SELECT users.id, MIN(orders.created_at) AS first_purchase_at,
  CASE 
  WHEN MIN(orders.created_at) IS NULL THEN 'NO'
  ELSE 'YES'
  END IF_ORDRED
FROM dsv1069.users LEFT JOIN dsv1069.orders
ON users.id = orders.user_id
GROUP BY users.id;

-- 7 -- have found the percentage of users viewed user profile from total users as I understood from the problem statement
-- this query does not match with the solution provided in course
SELECT 100 * (
  SELECT COUNT(DISTINCT users.id) 
  FROM dsv1069.users JOIN dsv1069.events 
  ON users.id = events.user_id
  WHERE events.event_name = 'view_user_profile') /
  (
  SELECT COUNT(DISTINCT id) 
  FROM dsv1069.users) as percentage
