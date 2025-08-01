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



-- Add a CHECK constraint to ensure days_before_due is between 1 and 10

ALTER TABLE ReminderSettings
ADD CONSTRAINT chk_days_before_due
CHECK (days_before_due BETWEEN 1 AND 10);



-- Sample Users
INSERT INTO Users (user_id, email, password, name, phone)
VALUES
('U1', 'user1@example.com', 'pass1', 'User One', '9876543210'),
('U2', 'user2@example.com', 'pass2', 'User Two', '9876543211'),
('U3', 'user3@example.com', 'pass3', 'User Three', '9876543212');

-- Sample Bills
INSERT INTO Bills (bill_id, bill_name, due_date, amount, user_id)
VALUES
('B1', 'Electricity Bill', CURRENT_DATE + 3, 1000, 'U1'),
('B2', 'Water Bill', CURRENT_DATE + 5, 500, 'U2'),
('B3', 'Internet Bill', CURRENT_DATE + 1, 800, 'U3');

-- Sample ReminderSettings
INSERT INTO ReminderSettings (reminder_id, user_id, days_before_due, reminder_frequency, reminder_start_date, custom_message, notification_preference, bill_id)
VALUES
('R1', 'U1', 3, 'Once', CURRENT_DATE, 'Pay Electricity Bill', 'Email', 'B1'),
('R2', 'U2', 5, 'Once', CURRENT_DATE, 'Pay Water Bill', 'SMS', 'B2'),
('R3', 'U3', 2, 'Once', CURRENT_DATE, 'Pay Internet Bill', 'Push', 'B3');

-- who will be reminded today
SELECT 
    u.user_id,
    u.name,
    u.email,
    b.bill_name,
    b.due_date,
    rs.custom_message,
    rs.notification_preference
FROM 
    ReminderSettings rs
JOIN 
    Bills b ON rs.bill_id = b.bill_id
JOIN 
    Users u ON rs.user_id = u.user_id
WHERE 
    TRUNC(b.due_date) - rs.days_before_due = TRUNC(CURRENT_DATE);



