CREATE TABLE ReminderSettings (
    reminder_id VARCHAR2(50) PRIMARY KEY,
    user_id VARCHAR2(50),
    days_before_due NUMBER,
    reminder_frequency VARCHAR2(50),
    reminder_start_date DATE,
    custom_message VARCHAR2(255),
    notification_preference VARCHAR2(50),
    bill_id VARCHAR2(50),
    FOREIGN KEY (bill_id) REFERENCES Bills(bill_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


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


-- for giving reminders

SELECT rs.user_id
FROM reminder_settings rs
JOIN tasks t ON rs.user_id = t.user_id
WHERE t.due_date = CURRENT_DATE + rs.days_before_due;


-- Add a CHECK constraint to ensure days_before_due is between 1 and 10

ALTER TABLE ReminderSettings
ADD CONSTRAINT chk_days_before_due
CHECK (days_before_due BETWEEN 1 AND 10);
