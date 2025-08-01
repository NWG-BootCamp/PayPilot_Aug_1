-- Sample reminder_settings table
-- reminder_id | user_id | days_before_due

INSERT INTO reminder_settings (reminder_id, user_id, days_before_due) VALUES
(1, 101, 3),
(2, 102, 5),
(3, 103, 2);


-- Sample tasks table: user_id | due_date

INSERT INTO tasks (user_id, due_date) VALUES
(101, CURRENT_DATE + INTERVAL '3 day'),  -- should be reminded today
(102, CURRENT_DATE + INTERVAL '5 day'),  -- should be reminded today
(103, CURRENT_DATE + INTERVAL '1 day');  -- NOT reminded today
