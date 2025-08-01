SELECT rs.user_id
FROM reminder_settings rs
JOIN tasks t ON rs.user_id = t.user_id
WHERE t.due_date = CURRENT_DATE + rs.days_before_due;
