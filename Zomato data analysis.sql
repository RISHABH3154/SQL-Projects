create database Zomato;
use zomato;
DROP TABLE IF EXISTS goldusers_signup;
CREATE TABLE goldusers_signup (userid INTEGER, gold_signup_date DATE); 

INSERT INTO goldusers_signup (userid, gold_signup_date) 
VALUES 
    (1, '2017-09-22'),
    (3, '2017-04-21');

DROP TABLE IF EXISTS users;
CREATE TABLE users (userid INTEGER, signup_date DATE); 

INSERT INTO users (userid, signup_date) 
VALUES 
    (1, '2014-09-02'),
    (2, '2015-01-15'),
    (3, '2014-04-11');

DROP TABLE IF EXISTS sale;
CREATE TABLE sale (userid INTEGER, created_date DATE, product_id INTEGER); 

INSERT INTO sale (userid, created_date, product_id) 
VALUES 
    (1, '2017-04-19', 2),
    (3, '2019-12-18', 1),
    (2, '2020-07-20', 3),
    (1, '2019-10-23', 2),
    (1, '2018-03-19', 3),
    (3, '2016-12-20', 2),
    (1, '2016-11-09', 1),
    (1, '2016-05-20', 3),
    (2, '2017-09-24', 1),
    (1, '2017-03-11', 2),
    (1, '2016-03-11', 1),
    (3, '2016-11-10', 1),
    (3, '2017-12-07', 2),
    (3, '2016-12-15', 2),
    (2, '2017-11-08', 2),
    (2, '2018-09-10', 3);

DROP TABLE IF EXISTS product;
CREATE TABLE product (product_id INTEGER, product_name TEXT, price INTEGER); 

INSERT INTO product (product_id, product_name, price) 
VALUES
    (1, 'p1', 980),
    (2, 'p2', 870),
    (3, 'p3', 330);
    
select * from sale;
select * from product;
select * from goldusers_signup;
select * from users;


-- ques1 (What is the total amount each customer spent on Zomato?)
select s.userid as Id , sum(p.price) as total
from sale s
join product p on s.product_id = p.product_id
group by s.userid
order by total desc;

-- ques2 How many days has each customer visited Zomato?
select userid , count(distinct created_date) from sale
group by userid;

-- ques3  What is the first product purchased by each customer after signup? 
with new_cte as (
select userid, 
row_number() over(partition by userid order by created_date) as num, product_id
from sale
)
select userid , product_id from new_cte
where num =1;

-- ques 4 What is the most purchased item on the menu and how many times it is 
-- purchased by all customers?
select userid , count(product_id) from sale where product_id = ( 
select product_id from sale
group by userid , product_id
order by count(product_id) desc
limit 1
)
group by userid;

-- QUES 5.Which item is favourite for each customer?
with cte as ( 
select userid, product_id,
rank() over(partition by userid order by count(product_id) desc) as num from sale
group by userid, product_id
order by product_id desc
) 
select userid, product_id as fav from cte 
where num = 1;

-- ques 6.Which item was first purchased by a customer after becoming gold member?

with cte as(
select s.userid, s.created_date, s.product_id, gs.gold_signup_date from sale s
inner join goldusers_signup gs on s.userid = gs.userid and created_date > gold_signup_date
order by created_date
)
select 