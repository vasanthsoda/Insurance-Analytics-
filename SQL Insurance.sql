create database insurance;
use insurance;
select * from brokeragecsv;
select * from feescsv;
select * from invoicecsv;
select * from meetingcsv;
select * from individual_budgets;
select * from opportunity;
-- Total amount from invoice
select income_class,sum(amount) as Sum_of_Amount from invoicecsv where income_class in ('Cross Sell','New','Renewal') group by income_class order by income_class;
-- Total amount from brokerage
select income_class,sum(amount) Sum_of_Amount from brokeragecsv where income_class in ('Cross Sell','New','Renewal') group by income_class order by income_class;
-- Total amount from fees
select income_class,sum(amount) Sum_of_Amount from feescsv where income_class in ('Cross Sell','New','Renewal') group by income_class order by income_class;
-- Total amount from Budgets
select sum(`Cross sell budget`),sum(`New budget`),sum(`Renewal budget`) from individual_budgets;
-- Total amount of Achievement
create table Achievement as
select income_class,sum(amount) Total_Amount from
(select income_class,amount from brokeragecsv union all select income_class,amount from feescsv) as combined 
where income_class in ('Cross Sell','New','Renewal') group by income_class order by income_class;
select * from Achievement;

-- Cross sell Sum across Invoice,Achievement,Target
select
(select sum(amount) from invoicecsv where income_class='Cross sell') Invoice,
(select sum(Total_Amount) from Achievement where income_class='Cross sell') Achievement,
(select sum(`Cross sell budget`) Cross_sell_budget from individual_budgets) Target;
-- New Sum across Invoice,Achievement,Target
select(select sum(amount) from invoicecsv where income_class='New') Invoice,
(select sum(Total_Amount) from Achievement where income_class='New') Achievement,
(select sum(`New budget`) New_budget from individual_budgets) Target;
-- Renewal Sum across Invoice,Achievement,Target
select(select sum(amount) from invoicecsv where income_class='Renewal') Invoice,
(select sum(Total_Amount) from Achievement where income_class='Renewal') Achievement,
(select sum(`Renewal budget`) Renewal_budget from individual_budgets) Target;

-- Cross Sell Placed Ach%
select concat(round(((select sum(Total_Amount) from Achievement where income_class='Cross sell') / (select sum(`Cross sell budget`) from individual_budgets))*100,2),'%')
 Cross_Sell_Placed_Ach;
 -- New Placed Ach%
select concat(round(((select sum(Total_Amount) from Achievement where income_class='New') / (select sum(`New budget`) from individual_budgets))*100,2),'%')
New_Placed_Ach;
-- Renewal Placed Ach%
select concat(round(((select sum(Total_Amount) from Achievement where income_class='Renewal') / (select sum(`Renewal budget`) from individual_budgets))*100,2),'%')
Renewal_Placed_Ach;
-- Cross Sell Invoice Ach%
select concat(round(((select sum(Amount) from invoicecsv where income_class='Cross sell') / (select sum(`Cross sell budget`) from individual_budgets))*100,2),'%')
Cross_Sell_Invoice_Ach;
-- New Invoice Ach%
select concat(round(((select sum(Amount) from invoicecsv where income_class='New') / (select sum(`New budget`) from individual_budgets))*100,2),'%')
New_Invoice_Ach;
-- Renewal Invoice Ach%
select concat(round(((select sum(Amount) from invoicecsv where income_class='Renewal') / (select sum(`Renewal budget`) from individual_budgets))*100,2),'%')
Renewal_Invoice_Ach;
-- Yearly Meeting Count
select Meeting_Year,count(*) Meeting_Count
from (
    select year(str_to_date(meeting_date, '%d-%m-%Y')) Meeting_Year
    from meetingcsv) t
group by Meeting_Year
order by Meeting_Year;

-- No of meeting by Acc Exec
select Account_executive,count(meeting_date) as count_of_meetingdate from meetingcsv group by Account_executive order by count(meeting_date); 
-- No of Invoice by Acc Exec
SELECT employeename as AccountExecutive,income_class,COUNT(invoice_date) AS invoice_count
FROM invoicecsv GROUP BY income_class,employeename ORDER BY invoice_count DESC;
-- Total opportunities and Open opportunities
select count(stage) as Total_opportunities from opportunity;
select count(stage) as Total_Open_Opportunities from opportunity where stage in ('Propose Solution','Qualify Opportunity');
-- Stage funnel by revenue
Select stage, sum(revenue_amount) AS Amount from opportunity Group By stage
ORDER BY Amount DESC;
-- Top 4 Opportunity by revenue
SELECT opportunity_name,revenue_amount FROM opportunity ORDER BY revenue_amount desc LIMIT 4;
-- Top 5 Open-Opportunity
select opportunity_name,revenue_amount from opportunity where stage IN ('Propose Solution','Qualify Opportunity') order by revenue_amount desc limit 5;
-- Opportunity- productgroup
select product_group,count(opportunity_name) as Count_of_Opportunity_name from opportunity group by product_group order by count(opportunity_name) desc;


