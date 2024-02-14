create database main_table;

use main_table;

select * from main_table;

select count(invoice_id) from main_table;

select count(distinct invoice_id) from main_table;


create table dim_customers (
customer_id int primary key not null auto_increment,
Gender varchar (15));

select * from dim_customers;

insert into dim_customers (Gender)(
select distinct gender from main_table);

create table dim_product(
product_id int primary key not null auto_increment,
product_code varchar(15) not null,
product_line varchar (50) not null) auto_increment=100;

select * from dim_product;

insert into dim_product (product_code,product_line)
(select distinct product_code ,product_line from main_table order by product_code);



create table dim_location(
Branch_id int primary key not null auto_increment,
Branch varchar(10) not null,
city varchar (25) not null) auto_increment = 500;

select * from dim_location;

insert into dim_location (Branch,city)
(select distinct branch, city from main_table order by Branch);

drop table dim_location;

create table fact_table as select * from main_table;

select * from fact_table;

Alter table fact_table
add column Branch_id int after Branch,
add column Customer_id int after Gender,
add column Product_id int after Product_code;


update fact_table set Branch_id = (select branch_id  from dim_location where dim_location.branch =fact_table.branch);

set SQL_safe_updates = 0;

update fact_table set customer_Id = (select customer_id  from dim_customers where dim_customers.Gender =fact_table.Gender);

update fact_table set product_id = (select product_id  from dim_product where dim_product.product_code =fact_table.product_code);

alter table fact_table
drop column Branch,
drop column city,
drop column Gender,
drop column Product_code,
drop column product_line;

select * from fact_table order by Invoice_id;

select f.Invoice_id,b.city,b.branch from fact_table as f
join dim_location as b 
where b.branch_id = f.branch_id;

