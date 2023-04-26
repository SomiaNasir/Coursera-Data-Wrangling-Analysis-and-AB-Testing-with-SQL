---------------- Q1. Data Quality Check ----------------

--We are running an experiment at an item-level, which means all users who visit will see the same page, but the layout of different item pages may differ.
--Compare this table to the assignment events we captured for user_level_testing.
--Does this table have everything you need to compute metrics like 30-day view-binary?

SELECT 
  * 
FROM 
  dsv1069.final_assignments_qa;

-- ANS: No, date and time for event creation is not available so we cannot find 30-day view binary.

---------------- Q2. Reformat the Data ----------------

--Reformat the final_assignments_qa to look like the final_assignments table, filling in any missing values with a placeholder of the appropriate data type.

SELECT 
  item_id,
  test_a AS test_assignment,
  'test_a' AS test_number,
  CAST('2013-01-05 00:00:00' AS TIMESTAMP) AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT 
  item_id,
  test_b AS test_assignment,
  'test_b' AS test_number,
  CAST('2013-01-05 00:00:00' AS TIMESTAMP) AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT 
  item_id,
  test_c AS test_assignment,
  'test_c' AS test_number,
  CAST('2013-01-05 00:00:00' AS TIMESTAMP) AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT 
  item_id,
  test_d AS test_assignment,
  'test_d' AS test_number,
  CAST('2013-01-05 00:00:00' AS TIMESTAMP) AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT 
  item_id,
  test_e AS test_assignment,
  'test_e' AS test_number,
  CAST('2013-01-05 00:00:00' AS TIMESTAMP) AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT 
  item_id,
  test_f AS test_assignment,
  'test_f' AS test_number,
  CAST('2013-01-05 00:00:00' AS TIMESTAMP) AS test_start_date
FROM 
  dsv1069.final_assignments_qa;
 
---------------- Q3. Compute Order Binary ----------------

-- Use this table to 
-- compute order_binary for the 30 day window after the test_start_date
-- for the test named item_test_2 

SELECT 
  test_assignment,
  COUNT(DISTINCT item_id) AS total_items,
  SUM(order_binary_30d) AS items_ordered_30d
FROM
  (SELECT 
    assignments.item_id,
    test_assignment,
    MAX(CASE 
      WHEN DATE_PART('day', orders.created_at - assignments.test_start_date) BETWEEN 0 AND 30 THEN 1
      ELSE 0
    END) AS order_binary_30d
  FROM 
    dsv1069.final_assignments AS assignments
  LEFT JOIN 
    dsv1069.orders
  ON 
    orders.item_id = assignments.item_id 
  WHERE
   test_number = 'item_test_2'
  GROUP BY 
    assignments.item_id,
    test_assignment) AS ordered_30d
GROUP BY 
  test_assignment;

---------------- Q4. Compute View Item Metrics ----------------

-- Use this table to 
-- compute view_binary for the 30 day window after the test_start_date
-- for the test named item_test_2

SELECT 
  test_assignment,
  COUNT(DISTINCT item_id) AS total_items,
  SUM(viewed_binary_30d) AS items_viewed_30d
FROM
  (SELECT 
    assignments.item_id,
    test_assignment,
    MAX(CASE 
      WHEN DATE_PART('day', view.event_time - assignments.test_start_date) BETWEEN 0 AND 30 THEN 1
      ELSE 0
    END) AS viewed_binary_30d
  FROM 
    dsv1069.final_assignments AS assignments
  LEFT JOIN 
    dsv1069.view_item_events AS view
  ON 
    view.item_id = assignments.item_id 
  WHERE
   test_number = 'item_test_2'
  GROUP BY 
    assignments.item_id,
    test_assignment) AS viewed_30d
GROUP BY 
  test_assignment;

---------------- Q5. Compute lift and p-value ----------------

--Use the https://thumbtack.github.io/abba/demo/abba.html to compute the lifts in metrics and the p-values for the 
--binary metrics ( 30 day order binary and 30 day view binary) using a interval 95% confidence. 

--ITEMS ORDERED: p-value 0.80, Improvement -9.7% – 12% (1.4%)

--ITEMS VIEWED: p-value 0.30, Improvement -1.7% – 5.7% (2%)

--There is no significant improvement in treatment group as compared to control group for both ordered and viewed items.
--Due to high p-values, these are statistically insignificant. 
--P-value gives an idea of how confident we are that the two groups truly have different chances of success and 
--to be declared statistically significant, common thresholds are 5% and 1%.
