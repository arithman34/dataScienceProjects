select * from SuperstoreProject..Superstore

--a. How many rows are there in the dataset?
select count(*) from SuperstoreProject..Superstore

--b. What are the unique ship modes in the dataset?
select distinct ShipMode as ship_mode from SuperstoreProject..Superstore;

--c. How many different countries are present in the dataset?
select count(distinct country) as no_countries from SuperstoreProject..Superstore

--d. What is the total sales amount for all the orders?
select sum(Sales) as total_sales from SuperstoreProject..Superstore

--e. What is the average profit per order?
select avg(Profit) as average_profit from SuperstoreProject..Superstore

--f. How many orders were placed in each region?
select region, count(*) AS NumberOfOrders from SuperstoreProject..Superstore group by region;

--g. What is the most common category and sub-category of products sold?
select top 1 category, subcategory, count(*) as frequency from SuperstoreProject..Superstore 
group by category, subcategory
order by frequency desc

--h. How many customers are there in each segment?
select Segment, count(distinct CustomerID) as no_customers
from SuperstoreProject..Superstore
group by Segment

--i. What is the total quantity sold for each product?
select ProductID, ProductName, sum(Quantity) as TotalQuantitySold
from SuperstoreProject..Superstore
group by ProductID, ProductName

--j. Which city has the highest average discount applied?
select top 1 City, avg(Discount) as AverageDiscount
from SuperstoreProject..Superstore
group by City
order by AverageDiscount desc

--k. How many customers have placed more than one order?
select count(*) as totalCustomersithMoreThanOneOrder
from (
select CustomerID, CustomerName, count(*) as NumberOfOrders
from SuperstoreProject..Superstore
group by CustomerID, CustomerName
having count(*) > 1
) as customerOrders

--l. What is the average time taken for shipping for each ship mode?
select ShipMode, avg(datediff(day, convert(nvarchar(255), OrderDate, 103), ShipDate)) as averageShippingTime
from SuperstoreProject..Superstore
group by ShipMode

--m. Identify the top 5 customers with the highest total sales.
select top 5 CustomerID, CustomerName, sum(Sales) as TotalSales
from SuperstoreProject..Superstore
group by CustomerID, CustomerName
order by TotalSales desc;

--n. Which product category has the highest average discount?
select top 1 Category, avg(discount) as averageDiscount
from SuperstoreProject..Superstore
group by Category
order by averageDiscount desc

--o. Calculate the profit percentage for each order (profit as a percentage of sales).
select OrderID, Sales, Profit, (Profit / Sales) * 100 as profitPercentage
from SuperstoreProject..Superstore;

--p. Identify the top 10 most profitable products.
select top 10 ProductID, ProductName, sum(Profit) as totalProfit
from SuperstoreProject..Superstore
group by ProductID, ProductName
order by totalProfit desc

--q. Calculate the average sales and profit for each category in each region.
select region, category, avg(sales) as averageSales, avg(profit) as averageProfit
from SuperstoreProject..Superstore
group by region, category

--r. Identify the customers with the highest lifetime value (total sales across all orders).
select top 3 customerID, customerName, sum(sales) as totalSales
from SuperstoreProject..Superstore
group by customerID, CustomerName
order by totalSales desc

--s. Calculate the percentage contribution of each product to total sales.
select productID, productName, sum(sales) as totalSales, sum(sales) / (select sum(sales) from SuperstoreProject..Superstore) * 100 as percentageContribution
from SuperstoreProject..Superstore
group by ProductID, ProductName
order by percentageContribution desc

--t. Determine the average shipping time for each category of products.
select category, avg(datediff(day, convert(nvarchar(255), OrderDate, 103), shipdate)) as averageShippingTime
from SuperstoreProject..Superstore
group by category
