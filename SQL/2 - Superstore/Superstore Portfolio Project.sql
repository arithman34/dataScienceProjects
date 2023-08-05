select * from PortfolioProjects..Superstore

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Data Cleaning

-- Standardise the order date column
alter table PortfolioProjects..Superstore
add OrderDateConverted date

update PortfolioProjects..Superstore
set OrderDateConverted = convert(date, orderDate)

-- Standardise the ship date column
alter table PortfolioProjects..Superstore
add ShipDateConverted date

update PortfolioProjects..Superstore
set ShipDateConverted = convert(date, shipDate)

alter table PortfolioProjects..Superstore
drop column orderDate, shipDate

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Data Analysis

--a. How many rows are there in the dataset?
select count(*) from PortfolioProjects..Superstore

--b. What are the unique ship modes in the dataset?
select distinct ShipMode as ship_mode from PortfolioProjects..Superstore;

--c. How many different countries are present in the dataset?
select count(distinct country) as no_countries from PortfolioProjects..Superstore

--d. What is the total sales amount for all the orders?
select sum(Sales) as total_sales from PortfolioProjects..Superstore

--e. What is the average profit per order?
select avg(Profit) as average_profit from PortfolioProjects..Superstore

--f. How many orders were placed in each region?
select region, count(*) AS NumberOfOrders from PortfolioProjects..Superstore group by region;

--g. What is the most common category and sub-category of products sold?
select top 1 category, subcategory, count(*) as frequency from PortfolioProjects..Superstore 
group by category, subcategory
order by frequency desc

--h. How many customers are there in each segment?
select Segment, count(distinct CustomerID) as no_customers
from PortfolioProjects..Superstore
group by Segment

--i. What is the total quantity sold for each product?
select ProductID, ProductName, sum(Quantity) as TotalQuantitySold
from PortfolioProjects..Superstore
group by ProductID, ProductName

--j. Which city has the highest average discount applied?
select top 1 City, avg(Discount) as AverageDiscount
from PortfolioProjects..Superstore
group by City
order by AverageDiscount desc

--k. How many customers have placed more than one order?
select count(*) as totalCustomersithMoreThanOneOrder
from (
select CustomerID, CustomerName, count(*) as NumberOfOrders
from PortfolioProjects..Superstore
group by CustomerID, CustomerName
having count(*) > 1
) as customerOrders

--l. What is the average time taken for shipping for each ship mode?
select ShipMode, avg(datediff(day, OrderDateConverted, ShipDateConverted)) as averageShippingTime
from PortfolioProjects..Superstore
group by ShipMode

--m. Identify the top 5 customers with the highest total sales.
select top 5 CustomerID, CustomerName, sum(Sales) as TotalSales
from PortfolioProjects..Superstore
group by CustomerID, CustomerName
order by TotalSales desc;

--n. Which product category has the highest average discount?
select top 1 Category, avg(discount) as averageDiscount
from PortfolioProjects..Superstore
group by Category
order by averageDiscount desc

--o. Calculate the profit percentage for each order (profit as a percentage of sales).
select OrderID, Sales, Profit, (Profit / Sales) * 100 as profitPercentage
from PortfolioProjects..Superstore;

--p. Identify the top 10 most profitable products.
select top 10 ProductID, ProductName, sum(Profit) as totalProfit
from PortfolioProjects..Superstore
group by ProductID, ProductName
order by totalProfit desc

--q. Calculate the average sales and profit for each category in each region.
select region, category, avg(sales) as averageSales, avg(profit) as averageProfit
from PortfolioProjects..Superstore
group by region, category

--r. Identify the customers with the highest lifetime value (total sales across all orders).
select top 3 customerID, customerName, sum(sales) as totalSales
from PortfolioProjects..Superstore
group by customerID, CustomerName
order by totalSales desc

--s. Calculate the percentage contribution of each product to total sales.
select productID, productName, sum(sales) as totalSales, sum(sales) / (select sum(sales) from PortfolioProjects..Superstore) * 100 as percentageContribution
from PortfolioProjects..Superstore
group by ProductID, ProductName
order by percentageContribution desc

--t. Determine the average shipping time for each category of products.
select category, avg(datediff(day, OrderDateConverted, ShipDateConverted)) as averageShippingTime
from PortfolioProjects..Superstore
group by category

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Tableau

--1. What are the top 10 customers with the highest lifetime value (total sales)?

select top 10 CustomerID, CustomerName, sum(Sales) as TotalSales
from PortfolioProjects..Superstore
group by CustomerID, CustomerName
order by TotalSales desc

--2. What is the trend of sales and profit over time?

select datefromparts(year(orderDateConverted), month(orderDateConverted), 1) AS salesMonth, sum(Sales) as totalSales, sum(Profit) as totalProfits
from PortfolioProjects..Superstore
group by datefromparts(year(orderDateConverted), month(orderDateConverted), 1)
order by salesMonth

--3. What is the percentage of sales contributed by each product category to the total sales?

select Category, sum(Sales) * 100.0 / (select sum(Sales) from PortfolioProjects..Superstore) as SalesPercentage
from PortfolioProjects..Superstore
group by Category
order by SalesPercentage desc

--4. What are the percentage contribution of sales for each state?

select State, sum(Sales) * 100.0 / (select sum(Sales) from PortfolioProjects..Superstore) as SalesPercentage
from PortfolioProjects..Superstore
group by state
order by SalesPercentage desc

--5. Top 10 products percentage contribution to total sales.

select top 10 productID, productName, sum(sales) as totalSales, sum(sales) / (select sum(sales) from PortfolioProjects..Superstore) * 100 as percentageContribution
from PortfolioProjects..Superstore
group by ProductID, ProductName
order by percentageContribution desc

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- # How this can answer business problems or help a business out.

--Data Analysis Report: Impactful Insights for Business Growth

--Introduction:
--This data analysis report delves into valuable insights extracted from our sales dataset using SQL queries and visualizations in Tableau. 
--By evaluating the data, we aim to address key business problems and provide actionable recommendations to enhance overall business growth.

--1. Top 10 Customers with the Highest Lifetime Value:
--Identifying our top 10 customers with the highest lifetime value is essential for focusing our efforts on the most valuable client base. 
--These loyal customers significantly contribute to our total sales, making them crucial for sustaining revenue growth. The report presents 
--a detailed list of the top 10 customers along with their respective total sales. Furthermore, visual representations highlight their 
--significant contributions to our overall sales.

--2. Trend of Sales and Profit Over Time:
--Analysing the trend of sales and profit over time allows us to better understand our historical performance. By visualising the sales and
--profit data across different time periods, we can identify seasonal patterns, growth trends, and areas that require attention.

--3. Percentage of Sales Contributed by Each Product Category:
--Gaining insights into the percentage of sales contributed by each product category enables us to prioritise resources and marketing efforts.
--The report showcases this data in pie charts or bar charts, emphasising the most significant revenue-generating categories. This information
--is instrumental in identifying potential areas for expansion and improvement.

--4. Percentage Contribution of Sales for Each State:
--Understanding the percentage contribution of sales for each state helps us focus on regions that drive the most revenue. The report visually
--represents this data in maps, providing a clear view of the sales distribution across different states. Such insights help optimise sales 
--strategies and allocate resources more effectively. Alternatively, more attention to marketing can be placed on the states that are currently
--lacking but have a potential for significant growth.

--5. Top 10 Products' Percentage Contribution to Total Sales:
--Identifying the top 10 products with the highest percentage contribution to total sales is crucial for effective inventory management and 
--targeted marketing efforts. The report presents this data in bar charts, emphasising the most profitable products and their impact on our
--overall revenue.

--Conclusion:
--This data analysis report provides actionable insights that can address our business challenges and drive strategic decisions. By 
--understanding our top customers, monitoring sales and profit trends, optimising product offerings, and focusing on revenue-generating 
--regions and products, we can streamline operations and enhance overall business performance. Embracing these insights will undoubtedly 
--contribute to our growth and success in the market.

-- Tableau data visualisation can be found at the link below:
--https://public.tableau.com/app/profile/arif.othman/viz/SuperstoreDashboard_16909170279860/Dashboard1
