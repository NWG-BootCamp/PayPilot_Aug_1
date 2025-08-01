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

-- Insert sample bills for users (assuming all due in August 2025)
DELETE FROM Bills; -- Clear existing data if any
DELETE FROM Payments; -- insert will not make sense if bills are not there
INSERT INTO Bills VALUES ('B001', 'Electricity Bill', 'Utilities', TO_DATE('2025-08-05','YYYY-MM-DD'), 1200, 'Monthly', NULL, NULL, 1, 0, NULL, 'U001');
INSERT INTO Bills VALUES ('B002', 'Water Bill', 'Utilities', TO_DATE('2025-08-07','YYYY-MM-DD'), 800, 'Monthly', NULL, NULL, 1, 0, NULL, 'U002');
INSERT INTO Bills VALUES ('B003', 'Gas Bill', 'Utilities', TO_DATE('2025-08-03','YYYY-MM-DD'), 600, 'Monthly', NULL, NULL, 1, 0, NULL, 'U00');

-- Insert reminders: user gets reminded a fixed number of days before due date
INSERT INTO ReminderSettings VALUES ('R001', 'U001', 4, 'Once', TO_DATE('2025-07-25','YYYY-MM-DD'), 'Pay your bill soon!', 'Email', 'B001');
INSERT INTO ReminderSettings VALUES ('R002', 'U002', 6, 'Once', TO_DATE('2025-07-30','YYYY-MM-DD'), 'Water bill due!', 'SMS', 'B002');
INSERT INTO ReminderSettings VALUES ('R003', 'U003', 2, 'Once', TO_DATE('2025-07-20','YYYY-MM-DD'), 'Remember gas bill!', 'App', 'B003');
 -- to give reminders today 
SELECT
    u.user_id,
    u.name,
    u.email,
    r.reminder_id,
    b.bill_id,
    b.bill_name,
    b.due_date,
    r.days_before_due,
    TO_CHAR(b.due_date - r.days_before_due, 'YYYY-MM-DD') AS reminder_date,
    r.notification_preference
FROM
    ReminderSettings r
    JOIN Bills b ON r.bill_id = b.bill_id
    JOIN Users u ON r.user_id = u.user_id
WHERE
    TO_DATE('2025-08-01', 'YYYY-MM-DD') = (b.due_date - r.days_before_due)
    AND r.reminder_start_date <= TO_DATE('2025-08-01', 'YYYY-MM-DD');

-- Create a procedure to print all users who need reminders for bills due in 3 days.
CREATE OR REPLACE PROCEDURE Send_Reminders_For_3_Days_Left AS
BEGIN
    FOR rec IN (
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
            rs.days_before_due = 3
            AND TRUNC(b.due_date) - rs.days_before_due = TRUNC(SYSDATE)
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Reminder for User: ' || rec.name || ' Email: ' || rec.email);
        DBMS_OUTPUT.PUT_LINE('Bill: ' || rec.bill_name || ' Due Date: ' || TO_CHAR(rec.due_date, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Message: ' || rec.custom_message);
        DBMS_OUTPUT.PUT_LINE('Notification Method: ' || rec.notification_preference);
        DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    END LOOP;
END;
/

-- To run the procedure
BEGIN
    Send_Reminders_For_3_Days_Left;
END;
/

