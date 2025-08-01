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
