-- ========================================
-- CREATE PAYMENTS TABLE
-- ========================================
CREATE TABLE payments (
    payment_id           VARCHAR2(50) PRIMARY KEY,
    payment_date         DATE NOT NULL,
    payment_mode         VARCHAR2(100),
    payer_account_number VARCHAR2(100),
    amount_paid          NUMBER(10, 2),
    status               VARCHAR2(100),
    bill_id              VARCHAR2(50) NOT NULL,
    user_id              VARCHAR2(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (bill_id) REFERENCES bills(bill_id),
    CONSTRAINT chk_amount_paid CHECK (amount_paid >= 0)
);

-- ========================================
-- VALID INSERT
-- Matches B003 (amount = 2500), user_id = 'U002', payment made before due date
-- ========================================
INSERT INTO payments (
    payment_id,
    payment_date,
    payment_mode,
    payer_account_number,
    amount_paid,
    status,
    bill_id,
    user_id
) VALUES (
    'P001',
    TO_DATE('2025-07-28', 'YYYY-MM-DD'),
    'Credit Card',
    '1111222233',
    2500.00,
    'Completed',
    'B003',
    'U002'
);

-- ========================================
-- INVALID INSERT
-- bill_id = 'B999' does not exist
-- ========================================
INSERT INTO payments (
    payment_id,
    payment_date,
    payment_mode,
    payer_account_number,
    amount_paid,
    status,
    bill_id,
    user_id
) VALUES (
    'P002',
    TO_DATE('2025-08-01', 'YYYY-MM-DD'),
    'Net Banking',
    '1234567890',
    1200.00,
    'Pending',
    'B999',
    'U001'
);

-- ========================================
-- INVALID INSERT
-- user_id = 'U999' does not exist
-- ========================================
INSERT INTO payments (
    payment_id,
    payment_date,
    payment_mode,
    payer_account_number,
    amount_paid,
    status,
    bill_id,
    user_id
) VALUES (
    'P003',
    TO_DATE('2025-08-01', 'YYYY-MM-DD'),
    'UPI',
    '1122334455',
    1200.00,
    'Failed',
    'B001',
    'U999'
);

-- ========================================
-- INVALID INSERT
-- amount_paid = -500 (violates CHECK constraint)
-- ========================================
INSERT INTO payments (
    payment_id,
    payment_date,
    payment_mode,
    payer_account_number,
    amount_paid,
    status,
    bill_id,
    user_id
) VALUES (
    'P004',
    TO_DATE('2025-08-01', 'YYYY-MM-DD'),
    'Cash',
    '1234567890',
    -500.00,
    'Failed',
    'B001',
    'U001'
);

-- ========================================
--  INVALID INSERT
-- amount_paid = 13000 > bill amount = 12000 for B001 (violates trigger/business rule)
-- ========================================
INSERT INTO payments (
    payment_id,
    payment_date,
    payment_mode,
    payer_account_number,
    amount_paid,
    status,
    bill_id,
    user_id
) VALUES (
    'P005',
    TO_DATE('2025-08-01', 'YYYY-MM-DD'),
    'Debit Card',
    '1234567890',
    13000.00,
    'Failed',
    'B001',
    'U001'
);


-- write a query to join users, bills, and payments to list: user, bill category, amount, payment date.

SELECT 
    u.name AS user_name,
    b.bill_category,
    b.amount,
    p.payment_date
FROM 
    users u
JOIN 
    bills b ON u.user_id = b.user_id
JOIN 
    payments p ON b.bill_id = p.bill_id;


-- create a view showing all fully paid bills with user name and bill details

CREATE OR REPLACE VIEW fully_paid_bills AS
SELECT
  u.name,
  b.bill_id,
  b.bill_category,
  b.amount,
  p.amount_paid,
  p.payment_date
FROM bills b
JOIN users u ON b.user_id = u.user_id
JOIN payments p ON b.bill_id = p.bill_id
WHERE b.is_paid = 1;


-- create a trigger stub to update is_paid = true in bills after payment is made.

CREATE OR REPLACE TRIGGER trg_update_bill_status_after_payment
AFTER INSERT ON payments
FOR EACH ROW
DECLARE
    v_total_paid  NUMBER := 0;
    v_bill_amount NUMBER := 0;
BEGIN

    SELECT NVL(SUM(amount_paid), 0)
    INTO v_total_paid
    FROM payments
    WHERE bill_id = :NEW.bill_id;


    SELECT amount
    INTO v_bill_amount
    FROM bills
    WHERE bill_id = :NEW.bill_id;


    IF v_total_paid >= v_bill_amount THEN
        UPDATE bills
        SET is_paid = 1
        WHERE bill_id = :NEW.bill_id;
    END IF;
END;
/

--  add a check to ensure amount_paid <= bill.amount

CREATE OR REPLACE TRIGGER trg_check_payment_amount
BEFORE INSERT OR UPDATE ON payments
FOR EACH ROW
DECLARE
    v_bill_amount NUMBER(10,2);
BEGIN
    SELECT amount INTO v_bill_amount FROM bills WHERE bill_id = :NEW.bill_id;

    IF :NEW.amount_paid > v_bill_amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Payment amount cannot be greater than bill amount.');
    END IF;
END;
/




