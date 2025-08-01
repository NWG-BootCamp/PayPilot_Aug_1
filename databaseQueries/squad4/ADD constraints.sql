ALTER TABLE ReminderSettings
ADD CONSTRAINT chk_days_before_due
CHECK (days_before_due BETWEEN 1 AND 10);
