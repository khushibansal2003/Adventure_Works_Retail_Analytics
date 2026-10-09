-- =========================================================
-- ADVENTURE WORKS RETAIL ANALYTICS
-- DATA WAREHOUSE SCHEMA
-- =========================================================

-- Create database
CREATE DATABASE IF NOT EXISTS adventure_works_dw;

USE adventure_works_dw;


-- =========================================================
-- 1. DIMENSION TABLE: CUSTOMER
-- =========================================================

DROP TABLE IF EXISTS DimCustomer;

CREATE TABLE DimCustomer (
    CustomerKey INT PRIMARY KEY,
    GeographyKey INT,
    CustomerName VARCHAR(150),
    BirthDate DATE,
    MaritalStatus VARCHAR(10),
    Gender VARCHAR(10),
    EmailAddress VARCHAR(150),
    YearlyIncome DECIMAL(15,2),
    Education VARCHAR(100),
    Occupation VARCHAR(100),
    HouseOwnerFlag VARCHAR(10),
    Address VARCHAR(255),
    FirstPurchaseDate DATE
);


-- =========================================================
-- 2. DIMENSION TABLE: PRODUCT
-- =========================================================

DROP TABLE IF EXISTS DimProduct;

CREATE TABLE DimProduct (
    ProductKey INT PRIMARY KEY,
    ProductSubcategoryKey INT,
    Product VARCHAR(150),
    Color VARCHAR(50),
    Model VARCHAR(100),
    Subcategory VARCHAR(100),
    Category VARCHAR(100)
);


-- =========================================================
-- 3. DIMENSION TABLE: GEOGRAPHY
-- =========================================================

DROP TABLE IF EXISTS DimGeography;

CREATE TABLE DimGeography (
    GeographyKey INT PRIMARY KEY,
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    PostalCode VARCHAR(20),
    SalesTerritoryKey INT
);


-- =========================================================
-- 4. DIMENSION TABLE: SALES TERRITORY
-- =========================================================

DROP TABLE IF EXISTS DimSalesTerritory;

CREATE TABLE DimSalesTerritory (
    SalesTerritoryKey INT PRIMARY KEY,
    SalesTerritoryRegion VARCHAR(100),
    SalesTerritoryCountry VARCHAR(100),
    SalesTerritoryGroup VARCHAR(100)
);


-- =========================================================
-- 5. DIMENSION TABLE: RESELLER
-- =========================================================

DROP TABLE IF EXISTS DimReseller;

CREATE TABLE DimReseller (
    ResellerKey INT PRIMARY KEY,
    GeographyKey INT,
    BusinessType VARCHAR(100),
    ResellerName VARCHAR(150)
);


-- =========================================================
-- 6. DIMENSION TABLE: EMPLOYEE
-- =========================================================

DROP TABLE IF EXISTS DimEmployee;

CREATE TABLE DimEmployee (
    EmployeeKey INT PRIMARY KEY,
    ParentEmployeeKey INT,
    SalesTerritoryKey INT,
    EmployeeName VARCHAR(150),
    Title VARCHAR(150),
    EmailAddress VARCHAR(150),
    DepartmentName VARCHAR(100),
    HireDate DATE,
    BirthDate DATE
);


-- =========================================================
-- 7. FACT TABLE: INTERNET SALES
-- =========================================================

DROP TABLE IF EXISTS FactInternetSales;

CREATE TABLE FactInternetSales (
    ProductKey INT,
    CustomerKey INT,
    SalesTerritoryKey INT,
    SalesOrderNumber VARCHAR(30),
    SalesOrderLineNumber INT,
    DiscountAmount DECIMAL(15,2),
    TotalProductCost DECIMAL(15,2),
    SalesAmount DECIMAL(15,2),
    Freight DECIMAL(15,2),
    CarrierTrackingNumber VARCHAR(100),
    OrderDate DATE,
    DueDate DATE,
    ShipDate DATE,

    PRIMARY KEY (
        SalesOrderNumber,
        SalesOrderLineNumber
    )
);


-- =========================================================
-- 8. FACT TABLE: RESELLER SALES
-- =========================================================

DROP TABLE IF EXISTS FactResellerSales;

CREATE TABLE FactResellerSales (
    ProductKey INT,
    ResellerKey INT,
    EmployeeKey INT,
    SalesTerritoryKey INT,
    SalesOrderNumber VARCHAR(30),
    SalesOrderLineNumber INT,
    DiscountAmount DECIMAL(15,2),
    TotalProductCost DECIMAL(15,2),
    SalesAmount DECIMAL(15,2),
    Freight DECIMAL(15,2),
    CarrierTrackingNumber VARCHAR(100),
    OrderDate DATE,
    DueDate DATE,
    ShipDate DATE,

    PRIMARY KEY (
        SalesOrderNumber,
        SalesOrderLineNumber
    )
);


-- =========================================================
-- VERIFY TABLES
-- =========================================================

SHOW TABLES;