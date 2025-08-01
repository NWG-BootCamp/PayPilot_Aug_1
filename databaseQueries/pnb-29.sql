--task->nested query to show users who have never paid any bill.
-- SALONI
SELECT name, email
FROM users
WHERE user_id NOT IN (
    SELECT DISTINCT user_id
    FROM bills
    WHERE is_paid = TRUE
);
