-- 1
SELECT date(paid_at) AS day, 
  COUNT(DISTINCT invoice_id) AS orders
FROM dsv1069.orders
GROUP BY date(paid_at)

-- 2
SELECT *
FROM dsv1069.dates_rollup
LEFT JOIN dsv1069.orders
ON CAST(orders.paid_at AS date) = dates_rollup.date

-- 3
SELECT dates_rollup.date, 
  COUNT(DISTINCT orders.invoice_id) AS orders
FROM dsv1069.dates_rollup
LEFT JOIN dsv1069.orders
ON CAST(orders.paid_at AS date) = dates_rollup.date
GROUP BY dates_rollup.date

-- 4, 5
SELECT dates_rollup.date,
  COUNT(DISTINCT orders.invoice_id) AS orders
FROM dsv1069.dates_rollup
LEFT JOIN dsv1069.orders
ON CAST(orders.paid_at AS date) > dates_rollup.d7_ago
AND CAST(orders.paid_at AS date) <= dates_rollup.date
GROUP BY dates_rollup.date
