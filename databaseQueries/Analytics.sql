-- task-> Write a query to show total due amount per user. Group by user.
-- RITHIK
SELECT
    u.name AS "User Name",
    SUM(b.amount - NVL(p.total_paid_per_bill, 0)) AS "Total Due Amount"
FROM
    users u
INNER JOIN
    bills b ON u.user_id = b.user_id
LEFT JOIN
    (
        SELECT
            bill_id,
            SUM(amount_paid) AS total_paid_per_bill
        FROM
            payments
        GROUP BY
            bill_id
    ) p ON b.bill_id = p.bill_id
GROUP BY
    u.name
ORDER BY
    "Total Due Amount" DESC;

--task->nested query to show users who have never paid any bill.
-- SALONI
SELECT name, email
FROM users
WHERE user_id NOT IN (
    SELECT DISTINCT user_id
    FROM bills
    WHERE is_paid = 1
);
--task->Index creation on due date.
--Shivam

CREATE INDEX due_date_idx ON bill(due_date);

-- HOW AN INDEX ON DUE_DATE OPTIMIZES PERFORMANCE --
-- 1. Enables faster lookups based on due_date. For example, when fetching records 
--    from the past few days to send reminders, the index allows quick access without scanning the entire table.
-- 2. Improves the efficiency of range queries, making it faster to retrieve records 
--    where due_date falls within a specified range.
-- 3. Speeds up queries that sort results by due_date, as the index maintains the column values 
--    in sorted order, reducing or eliminating the need for an additional sort operation.
