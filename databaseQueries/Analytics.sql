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

