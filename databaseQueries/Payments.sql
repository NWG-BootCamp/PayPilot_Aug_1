-- create payments table
CREATE TABLE payments (
    payment_id VARCHAR2(50) PRIMARY KEY,
    payment_date DATE NOT NULL,
    payment_mode VARCHAR2(100),
    payer_account_number VARCHAR2(100),
    amount_paid NUMBER(10, 2),
    status VARCHAR2(100),
    bill_id VARCHAR2(50) NOT NULL,
    user_id VARCHAR2(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (bill_id) REFERENCES bills(bill_id),
    CONSTRAINT chk_amount_paid CHECK (amount_paid>=0)
);

-- insert valid and invalid data into payments table
-- ✅ VALID INSERT
-- Matches B003 (amount = 2500), user_id = 'U002'
INSERT INTO payments (
    payment_id,
    payment_date,
    payment_mode,
    user_id,
    payer_account_number,
    amount_paid,
    status,
    bill_id
) VALUES (
    'P001',
    TO_DATE('2025-08-01', 'YYYY-MM-DD'),
    'Credit Card',
    'U002',
    '9876543210',
    2500.00,
    'Completed',
    'B003'
);

-- ❌ INVALID INSERT
-- bill_id = 'B999' does not exist
INSERT INTO payments (
    payment_id,
    payment_date,
    payment_mode,
    user_id,
    payer_account_number,
    amount_paid,
    status,
    bill_id
) VALUES (
    'P002',
    TO_DATE('2025-08-01', 'YYYY-MM-DD'),
    'Net Banking',
    'U001',
    '1234567890',
    1200.00,
    'Pending',
    'B999'
);

-- ❌ INVALID INSERT
-- user_id = 'U999' does not exist
INSERT INTO payments (
    payment_id,
    payment_date,
    payment_mode,
    user_id,
    payer_account_number,
    amount_paid,
    status,
    bill_id
) VALUES (
    'P003',
    TO_DATE('2025-08-01', 'YYYY-MM-DD'),
    'UPI',
    'U999',
    '1122334455',
    1200.00,
    'Failed',
    'B001'
);

-- ❌ INVALID INSERT
-- amount_paid = -500 (violates CHECK amount_paid >= 0)
INSERT INTO payments (
    payment_id,
    payment_date,
    payment_mode,
    user_id,
    payer_account_number,
    amount_paid,
    status,
    bill_id
) VALUES (
    'P004',
    TO_DATE('2025-08-01', 'YYYY-MM-DD'),
    'Cash',
    'U001',
    '0000111122',
    -500.00,
    'Failed',
    'B001'
);

-- ❌ INVALID INSERT
-- amount_paid = 13000 > bill amount = 12000 for B001 (violates trigger)
INSERT INTO payments (
    payment_id,
    payment_date,
    payment_mode,
    user_id,
    payer_account_number,
    amount_paid,
    status,
    bill_id
) VALUES (
    'P005',
    TO_DATE('2025-08-01', 'YYYY-MM-DD'),
    'Debit Card',
    'U001',
    '9999888877',
    13000.00,
    'Failed',
    'B001'
);

-- write a query to join users, bills, and payments to list: user, bill category, amount, payment date.

-- create a view showing all fully paid bills with user name and bill details

-- create a trigger stub to update is_paid = true in bills after payment is made.

--  add a check to ensure amount_paid <= bill.amount





