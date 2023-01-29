-- No. 1
SELECT DATEPART(MONTH, OrderDate) AS Month, COUNT(DISTINCT CustomerID) AS Total_Cust_Order
FROM [Northwind].[dbo].[Orders]
WHERE OrderDate BETWEEN '1997-01-01 00:00:00' AND '1997-12-31 23:59:59'
GROUP BY DATEPART(MONTH, OrderDate)
ORDER BY Month;

-- No. 2
SELECT *
FROM [Northwind].[dbo].[Employees]
WHERE Title = 'Sales Representative';

-- No. 3
SELECT TOP (5) p.ProductName,
		SUM(od.Quantity) AS Quantity_Order
FROM 
	[Northwind].[dbo].[Orders] o
	LEFT JOIN [Northwind].[dbo].[Order Details] od ON o.OrderID = od.OrderID
	LEFT JOIN [Northwind].[dbo].[Products] p ON od.ProductID = p.ProductID


WHERE 
	OrderDate BETWEEN '1997-01-01 00:00:00' AND '1997-01-31 23:59:59'

GROUP BY p.ProductName
ORDER BY Quantity_Order DESC;

-- No. 4
SELECT c.CompanyName
FROM 
	[Northwind].[dbo].[Orders] o
	LEFT JOIN [Northwind].[dbo].[Order Details] od ON o.OrderID = od.OrderID
	LEFT JOIN [Northwind].[dbo].[Products] p ON od.ProductID = p.ProductID
	LEFT JOIN [Northwind].[dbo].[Customers] c ON o.CustomerID = c.CustomerID

WHERE 
	OrderDate BETWEEN '1997-06-01 00:00:00' AND '1997-06-30 23:59:59'
	AND p.ProductName ='Chai';

-- No. 5

SELECT	SUM(CASE WHEN sale <= 100 THEN 1 ELSE 0 END) AS sumOrderID_x1,
		SUM(CASE WHEN sale > 100 AND sale <= 250 THEN 1 ELSE 0 END) AS sumOrderID_x2,
		SUM(CASE WHEN sale > 250 AND sale <= 500 THEN 1 ELSE 0 END) AS sumOrderID_x3,
		SUM(CASE WHEN sale > 500 THEN 1 ELSE 0 END) AS sumOrderID_x4
FROM
(SELECT OrderID, UnitPrice*Quantity as sale
FROM [Order Details]) sub

-- No. 6

SELECT c.CompanyName, sum(od.quantity) as total
FROM 
	[Northwind].[dbo].[Orders] o
	LEFT JOIN [Northwind].[dbo].[Order Details] od ON o.OrderID = od.OrderID
	LEFT JOIN [Northwind].[dbo].[Customers] c ON o.CustomerID = c.CustomerID

WHERE 
	OrderDate BETWEEN '1997-01-01 00:00:00' AND '1997-01-31 23:59:59'

GROUP BY c.CompanyName
HAVING SUM(od.quantity) > 500
ORDER BY total desc

-- No. 7

with sales AS(
	SELECT OrderID, ProductID, (UnitPrice*Quantity)*(1-Discount) as sale
	FROM [Order Details]
),
specProduct AS(
	SELECT ProductID, ProductName
	FROM [Products]
)
SELECT distinct TOP (5) DATEPART(MONTH, OrderDate) AS Month, sp.ProductName, s.sale
FROM 
	[Northwind].[dbo].[Orders] o
	LEFT JOIN sales s ON o.OrderID = s.OrderID
	LEFT JOIN specProduct sp ON s.ProductID = sp.ProductID
WHERE 
	OrderDate BETWEEN '1997-01-01 00:00:00' AND '1997-12-31 23:59:59'
GROUP BY DATEPART(MONTH, OrderDate), sp.ProductName, s.sale
ORDER BY Month, s.sale DESC

-- No. 8

CREATE VIEW ordersview
AS
SELECT od.OrderID, od.ProductID, p.ProductName, od.UnitPrice, od.Quantity, od.Discount, (od.UnitPrice*(1-od.Discount)) AS harga_setelah_diskon
FROM [Order Details] od,[Products] p
WHERE od.ProductID = p.ProductID;

SELECT * FROM ordersview;

-- No. 9 

CREATE PROCEDURE Invoice(@CustomerID nvarchar(10))
AS
BEGIN
SELECT	
		o.CustomerID, 
		c.CompanyName,
		o.OrderID,
		OrderDate,
		o.RequiredDate,
		o.ShippedDate
FROM 
	[Northwind].[dbo].[Orders] o
	LEFT JOIN [Northwind].[dbo].[Customers] c ON o.CustomerID = c.CustomerID
WHERE o.CustomerID = @CustomerID


END
EXEC Invoice @CustomerID = 'DUMON';


