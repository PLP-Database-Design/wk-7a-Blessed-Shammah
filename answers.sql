-- Question 1: Achieving 1NF (First Normal Form)
-- Create a new table to store the normalized data
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(50),
    Product VARCHAR(50)
);

-- Insert data into the new table by splitting the Products column
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', numbers.n), ',', -1)) AS Product
FROM ProductDetail
JOIN (
    -- Generate a sequence of numbers to handle multiple products
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3
) numbers
WHERE 
    numbers.n <= 1 + (LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')));

-- Question 2: Achieving 2NF (Second Normal Form)
-- Create a table for customer information (OrderID -> CustomerName)
CREATE TABLE Customer (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50)
);

-- Create a table for order details (OrderID, Product -> Quantity)
CREATE TABLE OrderDetails_2NF (
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Customer(OrderID)
);

-- Insert customer data into the Customer table (remove duplicates)
INSERT INTO Customer (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Insert order details into the new OrderDetails_2NF table
INSERT INTO OrderDetails_2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
