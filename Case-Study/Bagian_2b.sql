-- 1
WITH orderShip AS(
	SELECT ShipCountry, COUNT(*) AS num_orders
	FROM Orders
	GROUP BY ShipCountry
)

SELECT o.ShipCountry, os.num_orders, sum(o.Freight) as Total_Freight
FROM 
	[Northwind].[dbo].[Orders] o
	LEFT JOIN [Northwind].[dbo].[Shippers] s ON o.ShipVia = s.ShipperID
	LEFT JOIN orderShip os ON o.ShipCountry = os.ShipCountry

GROUP BY o.ShipCountry, os.num_orders
ORDER BY os.num_orders DESC, Total_Freight DESC;

-- 2
SELECT p.ProductName,
		SUM(od.Quantity) AS Quantity_Order, s.CompanyName, p.UnitsInStock, p.UnitsOnOrder, p.ReorderLevel , s.City
FROM 
	[Northwind].[dbo].[Orders] o
	LEFT JOIN [Northwind].[dbo].[Order Details] od ON o.OrderID = od.OrderID
	LEFT JOIN [Northwind].[dbo].[Products] p ON od.ProductID = p.ProductID
	LEFT JOIN [Northwind].[dbo].[Suppliers] s ON p.SupplierID = s.SupplierID


GROUP BY p.ProductName, s.CompanyName, p.UnitsInStock,p.UnitsOnOrder,p.ReorderLevel ,s.City
ORDER BY Quantity_Order DESC;
-- 3
SELECT o.EmployeeID, COUNT(*) AS Total_Order

FROM 
	[Northwind].[dbo].[Orders] o
	LEFT JOIN [Northwind].[dbo].[Employees] e ON o.EmployeeID = e.EmployeeID 

GROUP BY o.EmployeeID

