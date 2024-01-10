use magist;

/* 1. How many months of data are included in the magist database? - 25 */ 
  SELECT period_diff(
  EXTRACT(YEAR_MONTH FROM max(order_purchase_timestamp)), 
  EXTRACT(YEAR_MONTH FROM min(order_purchase_timestamp))) as totalmonths 
  from orders;
  
 /* 2. How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers? */

/* Total sellers - 3095 */
select count(seller_id) from sellers;

/* Tech sellers  - 403 */
select Count(distinct(oi.seller_id)) from order_items oi 
		inner join products p  on p.product_id = oi.product_id    
where p.product_category_name 
		in ('pcs','telefonia','informatica_acessorios','consoles_games','pc_gamer'); 
  
/* Percentage of Tech sellers - 13.0210 */  
select ((select Count(distinct(oi.seller_id)) from order_items oi 
		inner join products p  on p.product_id = oi.product_id    
where p.product_category_name 
		in ('pcs','telefonia','informatica_acessorios','consoles_games','pc_gamer') )/
        (select count(seller_id) from sellers) * 100 ) as TechSellers;

/* Tech sellers
pcs						computers
telefonia 				telephony
informatica_acessorios	computers_accessories
consoles_games			consoles_games
pc_gamer				pc_gamer */


/* 3. What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers? */

/* Total amount earned by all - 1617596.1471691132 */
select sum(price) from order_items;

/* Total amount earned by tech sellers - 2982848.56412673 */
select sum(oi.price) from order_items oi
	inner join products p  on p.product_id = oi.product_id    
	where p.product_category_name 
		in ('pcs','telefonia','informatica_acessorios','consoles_games','pc_gamer'); 


/* 4. Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?*/

/* Average monthly income of all sellers - 175.6593693275652 */
  SELECT sum(price)/((SELECT period_diff(
  EXTRACT(YEAR_MONTH FROM max(order_purchase_timestamp)), 
  EXTRACT(YEAR_MONTH FROM min(order_purchase_timestamp))) from orders) *
  (select count(seller_id) from sellers)) as Avg_Monthly_Income_PerSeller
 from order_items;
 
 /* Average monthly income of all sellers - 175.6593693275652 */
SELECT sum(price)/((SELECT period_diff(
  EXTRACT(YEAR_MONTH FROM max(order_purchase_timestamp)), 
  EXTRACT(YEAR_MONTH FROM min(order_purchase_timestamp))) from orders) *
  (count(distinct(seller_id)))) as Avg_Monthly_Income_PerSeller
 from order_items;
 
 -- without including month - 4391.48423318913
  SELECT sum(price)/count(distinct(seller_id)) as Avg_Monthly_Income_PerSeller
 from order_items;

/* Average monthly income of tech sellers - 20.905927588615356 */ 
-- sum of the price / no of months of data * no of tech sellers

 SELECT sum(price)/((SELECT period_diff(
  EXTRACT(YEAR_MONTH FROM max(order_purchase_timestamp)), 
  EXTRACT(YEAR_MONTH FROM min(order_purchase_timestamp))) from orders) *
  (select count(seller_id) from sellers)) as Avg_Monthly_Income_PerTechSeller
 from order_items oi
	inner join products p on oi.product_id = p.product_id 
where p.product_category_name 
		in ('pcs','telefonia','informatica_acessorios','consoles_games','pc_gamer');  
	
/* Average monthly income of tech sellers - 4013.886221263308 */ 
-- sum of the price /  no of tech sellers - WITHOUT INCLUDING MONTH
 SELECT sum(oi.price)/count(distinct(oi.seller_id)) as Avg_Monthly_Income_PerTechSeller
 from order_items oi
inner join products p on oi.product_id = p.product_id 
where p.product_category_name 
		in ('pcs','telefonia','informatica_acessorios','consoles_games','pc_gamer');  
