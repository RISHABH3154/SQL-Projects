create database practice;
use practice;

CREATE TABLE caseprac (
    customer_id INT,
    amount DECIMAL(10, 2),
    mode VARCHAR(20),
    date DATE
);

INSERT INTO caseprac (customer_id, amount, mode, date) VALUES
    (101, 500.00, 'credit card', '2023-10-15'),
    (102, 250.50, 'cash', '2023-10-16'),
    (103, 1200.75, 'online transfer', '2023-10-18'),
    (104, 800.25, 'credit card', '2023-10-19'),
    (105, 350.60, 'cash', '2023-10-20');

select customer_id , amount ,
case 
when amount > 700 then 'expensive product'
when amount>251 then 'moderate product'
else 'Inexpensive product'
end as productStatus
from caseprac;

select customer_id , 
case amount 
when 500 then 'good'
when 250.5 then 'bad'
when 1200.75 then 'ok'
end as paymentStatus
from caseprac;


with my_cte as(
select mode , max(amount) as highest_price, sum(amount) as total
from payment 
group by mode
)
select payment.*, my.highest_price, my.total
from payment 
join my_cte customer
on payment.customer_id = customer.customer_id
order by payment.customer_id;


-- CREATE FUNCTION GetProductPrice
-- (
--     @amount INT
-- )
-- RETURNS DECIMAL(10, 2)
-- AS
-- BEGIN
--     DECLARE @Price DECIMAL(10, 2);
--     SELECT @Price = Price FROM Products WHERE ProductID = @ProductID;
--     RETURN @Price;
-- END;

-- select dbo.add_10(100);


create procedure test
as
select *
from caseprac

exec test