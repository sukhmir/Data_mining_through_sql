SELECT * FROM module_project.onlineretail_final_2;
use module_project;
#•	What is the distribution of order values across all customers in the dataset?
SELECT CustomerID,AVG(Quantity*UnitPrice) AS Averageoforders,MAX(Quantity*UnitPrice) AS maximumofOrders ,MIN(Quantity*UnitPrice) AS MinimumofOrders
FROM onlineretail_final_2 GROUP BY CustomerID;


#•	How many unique products has each customer purchased?
SELECT CustomerID, COUNT(DISTINCT Description) AS UniqueProductsPurchased
FROM onlineretail_final_2
GROUP BY CustomerID;
#•	Which customers have only made a single purchase from the company?
SELECT 
    CustomerID,COUNT(DISTINCT InvoiceNo) AS customers_single_purchase
FROM
    onlineretail_final_2
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) = 1
    AND COUNT(*) = 1;
    
#•	Which products are most commonly purchased together by customers in the dataset?
SELECT t1.Description AS Product1, t2.Description AS Product2, COUNT(*) AS Frequency
FROM onlineretail_final_2 t1
JOIN onlineretail_final_2 t2 ON t1.CustomerID = t2.CustomerID AND t1.InvoiceNo = t2.InvoiceNo AND t1.Description < t2.Description
WHERE t1.Description IS NOT NULL AND t2.Description IS NOT NULL
GROUP BY t1.Description, t2.Description
ORDER BY Frequency DESC
LIMIT 15;


SELECT CustomerID, MAX(Quantity) AS most_common_purchased
FROM onlineretail_final_2
GROUP BY CustomerID;
#Advance queries
#Group customers into segments based on their purchase frequency, such as high, medium, and low frequency customers. This can help you identify your most loyal customers and those who need more attention
         
SELECT
    CustomerID,
    SUM(CASE WHEN InvoiceCount >= 50 THEN 1 ELSE 0 END) AS HighFrequency,
    SUM(CASE WHEN InvoiceCount >= 10 AND InvoiceCount < 50 THEN 1 ELSE 0 END) AS MediumFrequency,
    SUM(CASE WHEN InvoiceCount < 10 THEN 1 ELSE 0 END) AS LowFrequency,
    InvoiceCount
FROM (
    SELECT
        CustomerID,
        COUNT(InvoiceNo) AS InvoiceCount
    FROM
       onlineretail_final_2
    GROUP BY
        CustomerID
) AS PurchaseFrequency
GROUP BY
    CustomerID
ORDER BY InvoiceCount desc
LIMIT 100;

 #Calculate the average order value for each country to identify where your most valuable customers are located.
SELECT Country,AVG(TotalAmount) As AverageOrderValue FROM 
(SELECT Country,InvoiceNO,SUM(Quantity*UnitPrice) AS TotalAmount 
FROM onlineretail_final_2
GROUP BY Country,InvoiceNo) AS OrderTotal 
GROUP BY Country
ORDER BY AverageOrderValue DESC;
 #Identify customers who haven't made a purchase in a specific period (e.g., last 6 months) to assess churn.
SELECT CustomerID, SUM(Quantity) AS TotalQuantity
FROM onlineretail_final_2
WHERE Quantity = 0 AND InvoiceDate >= DATE_SUB('2010-12-01 08:26:00', INTERVAL 6 MONTH)
GROUP BY CustomerID;
#4. Product Affinity Analysis
#Determine which products are often purchased together by calculating the correlation between product purchases.

WITH ProductPairs AS (
    SELECT
        a.Description AS Product1,
        b.Description AS Product2,
        COUNT(*) AS Occurrences
    FROM
        onlineretail_final_2 a
    JOIN
        onlineretail_final_2 b ON a.InvoiceNo = b.InvoiceNo
                          AND a.Description < b.Description
    WHERE
        a.Description IS NOT NULL
        AND b.Description IS NOT NULL
    GROUP BY
        a.Description, b.Description
)
SELECT
    Product1,
    Product2,
    Occurrences
FROM
    ProductPairs
ORDER BY
    Occurrences DESC
LIMIT 15;


#5. Time-based Analysis
#Explore trends in customer behavior over time, such as monthly or quarterly sales patterns.
SELECT CustomerID, QUARTER(InvoiceDate) AS 4_Monthly, SUM(Quantity * UnitPrice) AS total_sales
FROM onlineretail_final_2
WHERE QUARTER(InvoiceDate)
GROUP BY CustomerID, QUARTER(InvoiceDate);









 