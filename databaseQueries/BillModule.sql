--1. Create bills table with bill_id, user_id, amount, category, due_date, is_paid.
--2. user_id is a foreign key.
--3. Add a unique constraint so that a user cannot have more than one bill with same due_date & category.
CREATE TABLE Bills (
    bill_id VARCHAR2(50) PRIMARY KEY,
    bill_name VARCHAR2(100),
    bill_category VARCHAR2(50),
    due_date DATE,
    amount FLOAT,
    reminder_frequency VARCHAR2(50),
    attachment VARCHAR2(255),
    notes VARCHAR2(255),
    is_recurring NUMBER(1) CHECK (is_recurring IN (0, 1)),
    is_paid NUMBER(1) CHECK (is_paid IN (0, 1)),      
    overdue_days NUMBER(3),
    user_id VARCHAR2(50),
    CONSTRAINT uq_user_due_cat UNIQUE (user_id, due_date, bill_category)
);

--4. Insert 5 bills: include 2 categories (electricity, rent) and future/past due dates.
INSERT INTO Bills VALUES (
    'B001', 'Ichigo Kurosaki', 'rent', TO_DATE('2025-07-28', 'YYYY-MM-DD'), 12000,
    'monthly', NULL, 'Paid in advance', 0, 1, 0, 'U001'
);

INSERT INTO Bills VALUES (
    'B002', 'Tanjiro', 'rent', TO_DATE('2025-08-05', 'YYYY-MM-DD'), 12000,
    'monthly', NULL, 'To be paid soon', 1, 0, 0, 'U001'
);

INSERT INTO Bills VALUES (
    'B003', 'Levi', 'electricity', TO_DATE('2025-07-30', 'YYYY-MM-DD'), 2500,
    'monthly', NULL, 'Late payment expected', 1, 0, 2, 'U002'
);

INSERT INTO Bills VALUES (
    'B004', 'Artyom', 'electricity', TO_DATE('2025-08-02', 'YYYY-MM-DD'), 2700,
    'monthly', NULL, 'Regular bill', 1, 0, 0, 'U003'
);

INSERT INTO Bills VALUES (
    'B005', 'Eren', 'rent', TO_DATE('2025-08-03', 'YYYY-MM-DD'), 12000,
    'monthly', NULL, 'Test entry', 0, 0, 1, 'U003'
);

--5. Write query to get all unpaid bills due within 5 days.
SELECT *
FROM Bills
WHERE is_paid = 0
AND due_date BETWEEN TRUNC(SYSDATE) AND TRUNC(SYSDATE) + 5;

--6. Write a query to join users and bills and display user name, bill category, and due date.
select 
    u.name, 
    b.bill_category, 
    b.due_date 
from users u join Bills b 
on u.user_id=b.user_id;

--7. Create a derived column late_fee in a view, calculated as 10% of amount if is_paid = false and due_date 
CREATE OR REPLACE VIEW bills_with_late_fee AS
SELECT 
    b.*, 
    CASE 
        WHEN b.is_paid = 0 AND b.due_date < SYSDATE 
        THEN ROUND(b.amount * 0.10, 2)
        ELSE 0.00
    END AS late_fee
FROM bills b;
