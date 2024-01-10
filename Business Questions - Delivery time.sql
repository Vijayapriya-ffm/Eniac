/* 1.What’s the average time between the order being placed and the product being delivered? */
/* Average time taken for delivery - 12.5035 */
select avg(datediff(order_delivered_customer_date, order_purchase_timestamp)) as Timetakenfordelivery from orders;

/* 2.How many orders are delivered on time vs orders delivered with a delay? */
/* On Time	89810 Delayed	6666  Other	2965 */
select
	case 
		when datediff(order_delivered_customer_date, order_estimated_delivery_date) > 0 then 'Delayed'
        when datediff(order_delivered_customer_date, order_estimated_delivery_date) <= 0 then 'On Time'
			else  'Other'
	end as orderstatus, 
    count(*) as total
 from orders
 group by orderstatus;
 
 /* 3.Is there any pattern for delayed orders, e.g. big products being delayed more often?
 No pattern in delays, all type of orders are delayed */
 
 /* All data */
  select oi.order_id, count(*), sum(price) as orderPrice from order_items oi
			inner join orders o on o.order_id= oi.order_id
            Group by oi.order_id
            order by orderPrice desc;
            
/* data for delayed orders */
 select oi.order_id, count(*), sum(price) as orderPrice from order_items oi
			inner join orders o on o.order_id= oi.order_id
            where datediff(o.order_delivered_customer_date, o.order_estimated_delivery_date) > 0 
            Group by oi.order_id
            order by orderPrice desc;


 select oi.order_id, count(*), sum(price) as orderPrice,
	Case when sum(price) < 100 then 'Low Price'
			when sum(price) >= 100 and sum(price) < 500 then 'Mid Price'
			when sum(price) >=500 then 'High Price'
	end as orderCategory,
    case 
		when datediff(o.order_delivered_customer_date, o.order_estimated_delivery_date) > 0 then 'Delayed'
        when datediff(o.order_delivered_customer_date,o.order_estimated_delivery_date) <= 0 then 'On Time'
			else  'Other'
	end as orderstatus 
			from order_items oi
			inner join orders o on o.order_id= oi.order_id   
            Group by oi.order_id
            order by orderPrice desc; 

 
 