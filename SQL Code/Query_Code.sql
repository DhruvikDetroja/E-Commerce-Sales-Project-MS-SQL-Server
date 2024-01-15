use ecommerce;

select * from sales_data;

select * from state_codes;

----------------------------------------------------- Validating Data of PowerBI------------------------------------------------------------------------------------

-- 1st YTD Sales
select ROUND(SUM(sales_per_order),2) as Sales_YTD from sales_data where YEAR(order_date)='2022';

-- 2nd YTD Profit
select ROUND(SUM(profit_per_order),2) as Profit_YTD from sales_data where YEAR(order_date)='2022';

select FORMAT(ROUND(SUM(profit_per_order),2)/1000000,'N2') + 'M' as Profit_YTD from sales_data where YEAR(order_date)='2022';

--3rd YTD Quantity

select ROUND(SUM(order_quantity),2) as Quantity_YTD from sales_data where YEAR(order_date) = '2022'; 

--4th YTD Profit Margin

select ROUND(100*(SUM(profit_per_order))/SUM(sales_per_order),2) as Profit_Margin_YTD from sales_data where YEAR(order_date)='2022';

--5th PYTD Sales
	
select ROUND(SUM(sales_per_order),2) as Sales_PYTD from sales_data where YEAR(order_date) != '2022';

--6th PYTD Profit
select ROUND(SUM(profit_per_order),2) as Profit_PYTD from sales_data where YEAR(order_date)!='2022';

--7th PYTD Quantity

select ROUND(SUM(order_quantity),2) as Quantity_PYTD from sales_data where YEAR(order_date) != '2022'; 

--8th PYTD Profit Margin

select ROUND(100*(SUM(profit_per_order))/SUM(sales_per_order),2) as Profit_Margin_PYTD from sales_data where YEAR(order_date)!='2022';

--9th YoY Sales Growth

with YTD_Sales as
(select SUM(sales_per_order) as Sales_YTD from sales_data where YEAR(order_date)='2022'),
PYTD_Sales as 
(select SUM(sales_per_order) as Sales_PYTD from sales_data where YEAR(order_date) != '2022')
SELECT ROUND(100*(Sales_YTD - Sales_PYTD)/Sales_PYTD,2) from YTD_Sales,PYTD_Sales;

--10th YoY Profit Growth
with YTD_Profit as 
(SELECT SUM(profit_per_order) as Profit_YTD from sales_data where YEAR(order_date)='2022'),
PYTD_Profit as
(SELECT SUM(profit_per_order) as Profit_PYTD from sales_data where YEAR(order_date)!='2022')
SELECT ROUND(100*(Profit_YTD-Profit_PYTD)/Profit_PYTD,2) from YTD_Profit,PYTD_Profit;

--11th YoY Quantity Growth
with YTD_Quantity as
(select SUM(order_quantity) as Quantity_YTD from sales_data where YEAR(order_date) = '2022'),
PYTD_Quantity as
(select SUM(order_quantity) as Quantity_PYTD from sales_data where YEAR(order_date) != '2022')
SELECT ROUND(100.0*(Quantity_YTD-Quantity_PYTD)/Quantity_PYTD,2) from YTD_Quantity,PYTD_Quantity;

--12th YoY Profit Margin Growth
with YTD_Profit_Margin as
(select ROUND(100*(SUM(profit_per_order))/SUM(sales_per_order),2) as Profit_Margin_YTD from sales_data where YEAR(order_date)='2022'),
PYTD_Profit_Margin as 
(select ROUND(100*(SUM(profit_per_order))/SUM(sales_per_order),2) as Profit_Margin_PYTD from sales_data where YEAR(order_date)!='2022')
SELECT ROUND(100.0*(Profit_Margin_YTD-Profit_Margin_PYTD)/Profit_Margin_PYTD,2) from YTD_Profit_Margin,PYTD_Profit_Margin;

--13th Sales by Category 

select category_name,ROUND(SUM(sales_per_order),2) as YTD_Sales_by_category from sales_data where YEAR(order_date)='2022' group by category_name ;

select category_name,ROUND(SUM(sales_per_order),2) as PYTD_Sales_by_category from sales_data where YEAR(order_date)!='2022' group by category_name ;

with Category_YTD_Sales as
(select category_name,ROUND(SUM(sales_per_order),2) as YTD_Sales_by_category from sales_data where YEAR(order_date)='2022' group by category_name ),
Category_PYTD_Sales as
(select category_name,ROUND(SUM(sales_per_order),2) as PYTD_Sales_by_category from sales_data where YEAR(order_date)!='2022' group by category_name)
SELECT y.category_name,ROUND(100*(YTD_Sales_by_category-PYTD_Sales_by_category)/PYTD_Sales_by_category,2) as YoY_Growth  from Category_YTD_Sales y
join 
Category_PYTD_Sales p
on y.category_name = p.category_name ;


--14th Top 5 Products by Sales

select Top 5 product_name,ROUND(sum(sales_per_order),2) as YTD_Sales from sales_data where YEAR(order_date) ='2022' group by product_name order by YTD_Sales DESC;

--15th Bottom 5 Products by Sales

select Top 5 product_name,ROUND(sum(sales_per_order),2) as YTD_Sales from sales_data where YEAR(order_date) ='2022' group by product_name order by YTD_Sales;

--16th YTD Sales by Region 

DECLARE @total_sales_region DECIMAL(12,2);
select @total_sales_region = SUM(sales_per_order) from sales_data where YEAR(order_date)='2022';
select customer_region,ROUND(100*SUM(sales_per_order)/@total_sales_region,2) as YTD_Sales from sales_data where YEAR(order_date)='2022' group by customer_region;

--17th YTD Sales by Shipment

DECLARE @total_sales_shipment DECIMAL(12,2);
select @total_sales_shipment = SUM(sales_per_order) from sales_data where YEAR(order_date)='2022';
select shipping_type,ROUND(100*SUM(sales_per_order)/@total_sales_shipment,2) as YTD_Sales from sales_data where YEAR(order_date)='2022' group by shipping_type;


----------------------------------------------------------Main Query End----------------------------------------------------------------------------------------------

---------------------------------------------------------Checking Few Filtered Data Queries to confirm Results--------------------------------------------------------

--18th YTD Sales in March Month

select ROUND(SUM(sales_per_order),2) as March_YTD_Sales from sales_data where YEAR(order_date)='2022' and MONTH(order_date)=3;

--19th South Region Furniture Sales YTD

select ROUND(SUM(sales_per_order),2) as YTD_Furniture_Sales_South from sales_data where YEAR(order_date)='2022' 
group by customer_region,category_name 
having customer_region='South' and category_name = 'Furniture';

--20th Corporate Segment in East Region find top 5 product by YTD Sales

select Top 5 product_name,ROUND(SUM(sales_per_order),2) as YTD_Sales from sales_data
where YEAR(order_date)='2022'
group by product_name,customer_segment,customer_region
having customer_segment='Corporate' and customer_region ='East'
order by YTD_Sales desc;

-------------------------------------------------------DashBoard Data Verification Done -----------------------------------------------------------------------------
