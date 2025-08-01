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
    CHECK (amount_paid>=0)
);

-- insert valid and invalid data into payments table

-- write a query to join users, bills, and payments to list: user, bill category, amount, payment date.

-- create a view showing all fully paid bills with user name and bill details

-- create a trigger stub to update is_paid = true in bills after payment is made.

--  add a check to ensure amount_paid <= bill.amount





