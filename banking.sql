drop database if exists banking;
CREATE DATABASE banking;
USE banking;

drop table if exists Regions;
drop table if exists Branches;
drop table if exists Customers;
drop table if exists Transactions;


CREATE TABLE Regions (
    RegionID INT AUTO_INCREMENT PRIMARY KEY,
    RegionName VARCHAR(100) NOT NULL
);

CREATE TABLE Branches (
    BranchID INT AUTO_INCREMENT PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    RegionID INT,
    FOREIGN KEY (RegionID) REFERENCES Regions(RegionID)
);

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    BranchID INT,
    AccountNumber VARCHAR(20) NOT NULL UNIQUE,
    Balance DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

CREATE TABLE Transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    TransactionType ENUM('NEFT', 'RTGS', 'UPI', 'CASH_WITHDRAWAL') NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Success', 'Failure') NOT NULL,
    Remarks VARCHAR(255),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Regions (RegionName) VALUES 
('North Region'), 
('South Region'), 
('East Region'), 
('West Region');

INSERT INTO Branches (BranchName, Address, RegionID) VALUES 
('Main Branch', 'Surat', 1),
('Secondary Branch', 'Ankleshwar', 2);

INSERT INTO Customers (Name, Address, BranchID, AccountNumber, Balance) VALUES 
('Pratik', 'Sardar Bhawan B', 1, 'AC001', 1000.00),
('Krishna', 'Kalam Bhawan B', 2, 'AC002', 500.00);

CREATE INDEX idx_customer_id ON Customers(CustomerID);
CREATE INDEX idx_branch_id ON Branches(BranchID);
CREATE INDEX idx_transaction_type ON Transactions(TransactionType);
CREATE INDEX idx_timestamp ON Transactions(Timestamp);

DELIMITER //

CREATE FUNCTION cash_withdrawal(p_customer_id INT, p_amount DECIMAL(10, 2))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE v_balance DECIMAL(10, 2);
    DECLARE v_message VARCHAR(50);

    SELECT Balance INTO v_balance
    FROM Customers
    WHERE CustomerID = p_customer_id;

    IF v_balance IS NULL THEN
        SET v_message = 'Customer Not Found';
    ELSE
        IF v_balance >= p_amount THEN
            UPDATE Customers
            SET Balance = Balance - p_amount
            WHERE CustomerID = p_customer_id;
            INSERT INTO Transactions (CustomerID, TransactionType, Amount, Status, Remarks)
            VALUES (p_customer_id, 'CASH_WITHDRAWAL', p_amount, 'Success', 'Withdrawal Successful');

            SET v_message = 'Withdrawal Successful';
        ELSE
            SET v_message = 'Insufficient Balance';

            INSERT INTO Transactions (CustomerID, TransactionType, Amount, Status, Remarks)
            VALUES (p_customer_id, 'CASH_WITHDRAWAL', p_amount, 'Failure', 'Insufficient Balance');
        END IF;
    END IF;

    RETURN v_message;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_six_month_transactions(IN cust_id INT)
BEGIN
	select * from Transactions
	where CustomerID = cust_id AND Timestamp >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
	order by Timestamp DESC;
END //

DELIMITER ;

