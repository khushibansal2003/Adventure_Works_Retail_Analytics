USE adventure_works_dw;


-- =========================================================
-- 1. SALES TERRITORY PERFORMANCE
-- =========================================================

SELECT
    st.SalesTerritoryRegion AS Sales_Territory,

    ROUND(SUM(s.SalesAmount), 2) AS Total_Sales,

    COUNT(DISTINCT s.SalesOrderNumber) AS Total_Orders,

    ROUND(
        SUM(s.SalesAmount) /
        COUNT(DISTINCT s.SalesOrderNumber),
        2
    ) AS Average_Order_Value

FROM
(
    SELECT
        SalesTerritoryKey,
        SalesOrderNumber,
        SalesAmount
    FROM FactInternetSales

    UNION ALL

    SELECT
        SalesTerritoryKey,
        SalesOrderNumber,
        SalesAmount
    FROM FactResellerSales
) s

INNER JOIN DimSalesTerritory st
    ON s.SalesTerritoryKey = st.SalesTerritoryKey

GROUP BY
    st.SalesTerritoryRegion

ORDER BY
    Total_Sales DESC;


-- =========================================================
-- 2. CUSTOMER SEGMENTATION
-- OCCUPATION + ANNUAL INCOME
-- =========================================================

SELECT

    c.Occupation,

    CASE
        WHEN c.YearlyIncome < 30000
            THEN 'Below 30K'

        WHEN c.YearlyIncome < 60000
            THEN '30K - 60K'

        WHEN c.YearlyIncome < 100000
            THEN '60K - 100K'

        ELSE '100K+'
    END AS Income_Segment,

    COUNT(DISTINCT c.CustomerKey) AS Customers,

    ROUND(
        SUM(s.SalesAmount),
        2
    ) AS Total_Sales,

    ROUND(
        SUM(s.SalesAmount) /
        COUNT(DISTINCT c.CustomerKey),
        2
    ) AS Average_Sales_Per_Customer

FROM FactInternetSales s

INNER JOIN DimCustomer c
    ON s.CustomerKey = c.CustomerKey

GROUP BY
    c.Occupation,
    Income_Segment

ORDER BY
    Average_Sales_Per_Customer DESC;


-- =========================================================
-- 3. AGE GROUP ANALYSIS
-- CUSTOMERS UNDER 50
-- =========================================================

SELECT

    CASE

        WHEN TIMESTAMPDIFF(
            YEAR, c.BirthDate, '2014-12-31'
        ) < 25
            THEN 'Under 25'

        WHEN TIMESTAMPDIFF(
            YEAR, c.BirthDate, '2014-12-31'
        ) BETWEEN 25 AND 29
            THEN '25-29'

        WHEN TIMESTAMPDIFF(
            YEAR, c.BirthDate, '2014-12-31'
        ) BETWEEN 30 AND 34
            THEN '30-34'

        WHEN TIMESTAMPDIFF(
            YEAR, c.BirthDate, '2014-12-31'
        ) BETWEEN 35 AND 39
            THEN '35-39'

        WHEN TIMESTAMPDIFF(
            YEAR, c.BirthDate, '2014-12-31'
        ) BETWEEN 40 AND 44
            THEN '40-44'

        WHEN TIMESTAMPDIFF(
            YEAR, c.BirthDate, '2014-12-31'
        ) BETWEEN 45 AND 49
            THEN '45-49'

    END AS Age_Group,

    COUNT(DISTINCT c.CustomerKey) AS Customers,

    ROUND(
        SUM(s.SalesAmount),
        2
    ) AS Total_Sales,

    ROUND(
        SUM(s.SalesAmount) /
        COUNT(DISTINCT c.CustomerKey),
        2
    ) AS Average_Sales_Per_Customer

FROM FactInternetSales s

INNER JOIN DimCustomer c
    ON s.CustomerKey = c.CustomerKey

WHERE
    TIMESTAMPDIFF(
        YEAR, c.BirthDate, '2014-12-31'
    ) < 50

GROUP BY
    Age_Group

ORDER BY
    Average_Sales_Per_Customer DESC;


-- =========================================================
-- 4. PRODUCT CATEGORY PERFORMANCE
-- =========================================================

SELECT

    p.Category,

    p.Subcategory,

    ROUND(
        SUM(s.SalesAmount),
        2
    ) AS Total_Sales

FROM FactInternetSales s

INNER JOIN DimProduct p
    ON s.ProductKey = p.ProductKey

GROUP BY
    p.Category,
    p.Subcategory

ORDER BY
    Total_Sales DESC;