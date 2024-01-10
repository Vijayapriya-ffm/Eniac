/* 1. What categories of tech products does Magist have? */

/* Tech sellers
pcs						computers
telefonia 				telephony
informatica_acessorios	computers_accessories
consoles_games			consoles_games
pc_gamer				pc_gamer */

/* 2. How many products of these tech categories have been sold (within the time window of the database snapshot)? 
What percentage does that represent from the overall number of products sold? */

-- Total products sold - 112650
select Count(*) totalproductssold from order_items;

-- Total Tech products sold - 13721
select Count(*) techproductssold from order_items oi
	inner join products p on p.product_id = oi.product_id
 where p.product_category_name 
		in ('pcs','telefonia','informatica_acessorios','consoles_games','pc_gamer');  

-- % of tech products sold - 12.1802
select ((
select Count(*) techproductssold from order_items oi
	inner join products p on p.product_id = oi.product_id
 where p.product_category_name 
		in ('pcs','telefonia','informatica_acessorios','consoles_games','pc_gamer'))/
        (select Count(*) totalproductssold from order_items) * 100)
 as techProdPercentage ;


/* 3. What’s the average price of the products being sold? */
-- 120.65373902991884
select avg(price) as avgPrice from order_items;

/* 4. Are expensive tech products popular?  No its not popular, its very insignificant value */
/*	9444	Low Price
	3774	Mid Price
	503		High Price */
    
select count(*) as ProductCount, 
	Case 
			when oi.price < 100 then 'Low Price'
			when oi.price >= 100 and oi.price < 500 then 'Mid Price'
			when oi.price >=500 then 'High Price'
            Else 'Others'
	end as ProdPriceCategory
 from order_items oi
	inner join products p on p.product_id = oi.product_id  
     where p.product_category_name 
		in ('pcs','telefonia','informatica_acessorios','consoles_games','pc_gamer')
        group by ProdPriceCategory; 
    

-- % of High end tech products of all prodcuts sold - 0.4465      
Select ((
	select count(*) as highEndProdCount
	from order_items oi
	inner join products p on p.product_id = oi.product_id  
    where p.product_category_name 
		in ('pcs','telefonia','informatica_acessorios','consoles_games','pc_gamer') 
        and oi.price >= 500)/
        (select Count(*) totalproductssold from order_items) * 100) as HighEndTechProdPercentage;    
    
-- % of High end tech products of all tech products sold - 3.6659        
Select ((
	select count(*) as highEndProdCount
	from order_items oi
	inner join products p on p.product_id = oi.product_id  
    where p.product_category_name 
		in ('pcs','telefonia','informatica_acessorios','consoles_games','pc_gamer') 
        and oi.price >= 500)/
        (select Count(*) techproductssold from order_items oi
			inner join products p on p.product_id = oi.product_id
			where p.product_category_name 
			in ('pcs','telefonia','informatica_acessorios','consoles_games','pc_gamer')) * 100) as HighEndTechProdPercentage;