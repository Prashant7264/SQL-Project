/* Logistics and supply chanin management*/

create database logisticsManagement;
use logisticsManagement;
show databases;

-- creating tables for logistics database and insert the data
-- 1. table for products and inserting the data

create table products(
productID int primary key,
productname varchar(100),
category varchar(50),
unitprice decimal(10,2)
);
insert into products values (1, 'Smartphone', 'Electronics', 150000.00),
       (2, 'Laptop', 'Electronics', 100000.00),
       (3, 'Headphones', 'Accessories', 1500.00),
       (4, 'Smartwatch', 'Accessories', 5000.00),
       (5, 'Bluetooth Speaker', 'Electronics', 2000.00);
select * from products;

select * from products where  productname like 's%';

-- 2. create table for warehouse and insert the data
create table warehouse(
warehouseID int primary key,
warehousename varchar(100),
location varchar(100)
); 
insert into warehouse values(1,'warehouse 1','America');
insert into warehouse values(2,'warehouse 2','Germany');
insert into warehouse values(3,'warehouse 3','Dubai');

select * from warehouse;

-- 3. create table for inventory and insert the data
create table inventory(
productID int,
warehouseID int,
Quantityonhand int,
primary key (productID, warehouseID),
foreign key (productID) references products(productID),
foreign key (warehouseID) references warehouse(warehouseID)
);
insert into inventory values(1,1,100);
insert into inventory values(1,2,50);
insert into inventory values(1,3,10);
insert into inventory values(2,1,60);
insert into inventory values(2,2,500);
insert into inventory values(2,3,70);
insert into inventory values(3,1,30);
insert into inventory values(3,2,10);
insert into inventory values(3,3,80);
insert into inventory values(4,1,10);
insert into inventory values(4,2,60);
insert into inventory values(4,3,55);
insert into inventory values(5,1,200);
insert into inventory values(5,2,20);
insert into inventory values(5,3,0);

select * from inventory;
select ProductID
from invento
join warehouse,inventory
using(productID);

-- 4.create order table and insert the data
create table orders (
orderID int primary key,
orderdate date,
customerID int,
productID int,
Quantityordered int,
oreder_status varchar(25),
foreign key (productID) references products(productID)
);
-- spelling misatke in column name so changed the column name
alter table orders change column oreder_status orderstatus varchar(25);

insert into orders values(1,'2024-08-01',101,1,10,'shipped');
insert into orders values(2,'2024-08-02',102,2,50,'pending');
insert into orders values(3,'2024-08-03',103,3,100,'processing');
insert into orders values(4,'2024-08-04',104,4,5,'shipped');
insert into orders values(5,'2024-08-05',105,5,25,'pending');
insert into orders values(6,'2024-07-11',101,1,60,'shipped');
insert into orders values(7,'2024-07-12',102,2,80,'pending');
insert into orders values(8,'2024-07-13',103,3,30,'processing');
insert into orders values(9,'2024-07-14',104,4,5,'shipped');
insert into orders values(10,'2024-07-15',105,5,25,'pending');

select* from orders;

-- 5. create supplier table and inset the data

create table supplier(
supplierID int primary key,
suppliername varchar(100),
contact_info varchar(100)
);

insert into supplier values(1,'supplier A','supplier1@gmail.com');
insert into supplier values(2,'supplier B','supplier2@gmail.com');
insert into supplier values(3,'supplier C','supplier3@gmail.com');

select * from supplier;

-- count of tables in logistics
show tables;

-- 1.interlinking the tables
select 
p.productID,
p.productname,
i.warehouseID,
i.Quantityonhand,
o.Quantityordered,
o.orderID,
o.orderstatus
from orders o
join products p on o.productID = p.productID
join inventory i on p.productID = i.productID
order by p.productname,i.warehouseID;

-- 2. complex view
create view join_view as select p.productID,p.productname,o.orderID,o.orderdate,o.orderstatus
from products p
inner join orders o
using(productID);

select * from join_view;

 -- 3. Procedure

 delimiter //
create procedure getdata()
begin
select * from warehouse, inventory;
end//

call getdata();

-- 4. function
-- for total prodcut value
select productname,Quantityonhand,unitprice, (p.unitprice * i.Quantityonhand) as Total_price
from products p
join inventory i
using(productID);

-- Each product total value by quantity and price

Create table product_data(productname varchar(100),cat enum('Electronics','Accessories'),unitprice decimal(10,2),Qty int );
 insert into product_data values ('Smartphone', 'Electronics', 150000.00,50),
       ('Laptop', 'Electronics', 100000.00,65),
       ('Headphones', 'Accessories', 1500.00,85),
       ('Smartwatch', 'Accessories', 5000.00,37),
       ('Bluetooth Speaker', 'Electronics', 2000.00,98);

select * from product_data;       
       
delimiter //
create function Total_Price_product_data(unitprice decimal(10,2),Qty int)
returns decimal(10,2)
deterministic
begin
declare Total_price_product decimal(10,2);
set Total_price_product = unitprice * Qty;
return Total_price_product;
end //

select productname,unitprice,Qty,Total_price_product(unitprice,Qty)
as Total_price_product from product_data;


-- 5.Trigger Function

insert into product_data values ('TV',NULL,null,null);
select *from product_data;
drop table product_data_2;

show triggers;
drop trigger if exists product_data_after_insert;

create table product_data_log(productname varchar(100),unitprice decimal(10,2),Qty varchar(50));

DELIMITER //

CREATE TRIGGER product_data_after_insert
AFTER INSERT ON product_data
FOR EACH ROW
BEGIN
    INSERT INTO product_data_log (productname, unitprice, Qty)
    VALUES (NEW.productname, NEW.unitprice, NEW.Qty);
END //

insert into product_data values ('remote',NULL,null,null);

select * from product_data_log;