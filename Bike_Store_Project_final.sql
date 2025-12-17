-- birinchi table ni yaratib oldim 
create table StagingCustomers(
Customer_id int PRIMARY KEY,
first_name VARCHAR(100),
last_name VARCHAR(100),
phone VARCHAR(20),
email VARCHAR(100),
street VARCHAR(100),
city VARCHAR(100),
state VARCHAR(100),
zip_code VARCHAR(20)
);
-- birinchi table uchun bulk insert qildim 
 
BULK INSERT StagingCustomers
FROM 'F:\Arslonbek\DataAnalytics\proyektlarim\SQL course project\customers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
--ikkinchi table yaratib oldim 
drop table StagingOrders
CREATE TABLE StagingOrders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_status VARCHAR(100),
    order_date DATETIME,
    required_date DATETIME,
    shipped_date VARCHAR(50) NULL,
	store_id int,
	staff_id int
);
-- Ikkinchi table uchun bulk insert qilib oldim ( FK larni olib tashladim )
BULK INSERT StagingOrders 
FROM 'F:\Arslonbek\DataAnalytics\proyektlarim\SQL course project\orders.csv'
with (
	fieldterminator = ',',
	rowterminator ='\n',
	firstrow = 2,
	CODEPAGE = '65001',   
    KEEPNULLS             
	);

------------------------ALTER TABLE StagingOrders
------------------------ALTER COLUMN shipped_date DATETIME NULL;

------------------------UPDATE StagingOrders
------------------------SET shipped_date = TRY_CAST(shipped_date AS DATETIME);
--Uchinchi table ni yaratdim (FK hali o'natilmadi)
 
 create table StagingStaffs(
 staff_id int PRIMARY KEY,
 first_name VARCHAR(100),
 last_name VARCHAR(100),
 email VARCHAR(100),
 phone VARCHAR(20),
 active VARCHAR(50),
 store_id int,
 manager_id VARCHAR(10) NULL
 );

 --uchinchi tablega bulk insert qildim 
 BULK INSERT StagingStaffs
 FROM  'F:\Arslonbek\DataAnalytics\proyektlarim\SQL course project\staffs.csv'
 with(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2,
	CODEPAGE = '65001',   
    KEEPNULLS      
	)

--tortinchi table create qilaman (FK hali o'rnatilmadi)
create table StagingStores(
	store_id int PRIMARY KEY,
	store_name VARCHAR(50),
	phone VARCHAR(20),
	email VARCHAR(100),
	street VARCHAR(100),
	city VARCHAR(100),
	state VARCHAR(100),
	zip_code VARCHAR(20)
);
--tortinchi table bulk insert qilaman
BULK INSERT StagingStores
FROM  'F:\Arslonbek\DataAnalytics\proyektlarim\SQL course project\stores.csv'
WITH(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR ='\n',
	FIRSTROW = 2,
	CODEPAGE = '65001',   
    KEEPNULLS      
);
drop table StagingOrder_items
--beshinchi table ni create qilaman (PK va FK lar hali ornatilamagan)
create table StagingOrder_items(
order_id int,
item_id int,
product_id int,
quantity int,
list_price DECIMAL (10,2),
discount DECIMAL(5, 2)
);
--Beshinchi table uchun bulk insert qilaman
BULK INSERT StagingOrder_items
FROM  'F:\Arslonbek\DataAnalytics\proyektlarim\SQL course project\order_items.csv'
WITH(
	FIELDTERMINATOR =',',
	ROWTERMINATOR = '\n',
	FIRSTROW =2,
	CODEPAGE = '65001',
	KEEPNULLs
	);
	--Oltinchi staging table ni create qilaman 
	create table StagingCategories(
	categoty_id int,
	category_name VARCHAR(50)
	);
--Oltinchi table uchun bulk insert qilaman
BULK INSERT StagingCategories
FROM 'F:\Arslonbek\DataAnalytics\proyektlarim\SQL course project\categories.csv'
WITH (
	FIELDTERMINATOR =',',
	ROWTERMINATOR ='\n',
	FIRSTROW = 2,
	CODEPAGE = '65001',
	KEEPNULLS 
	);

 
--Yettinchi Satging table create qilaman
create table StagingProducts(
product_id int,
product_name VARCHAR(100),
brand_id int,
category_id int,
model_year int,
list_price DECIMAL (10,2)
);
--Yettinchi table uchun bulk insert qilaman
BULK INSERT StagingProducts
FROM 'F:\Arslonbek\DataAnalytics\proyektlarim\SQL course project\products.csv'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR ='\n',
	FIRSTROW = 2,
	CODEPAGE = '65001',
	KEEPNULLS
	);
--Sakkizinchi Staging tableni create qilaman
create table StagingStocks (
strore_id int,
product_id int,
quantity int
);

--Sakkizinchi table uchun bulk insert qilaman
BULK INSERT StagingStocks
FROM 'F:\Arslonbek\DataAnalytics\proyektlarim\SQL course project\stocks.csv'
WITH(
	FIELDTERMINATOR =',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2,
	CODEPAGE = '65001',
	KEEPNULLS
	);

--Toqqizinchi Staging table yarataman 
create table StagingBrand(
brand_id int,
brand_name VARCHAR(100)
);
--Toqqizinchi table uchun bulk insert qilaman
BULK INSERT StagingBrand
FROM 'F:\Arslonbek\DataAnalytics\proyektlarim\SQL course project\brands.csv'
WITH (
	FIELDTERMINATOR =',',
	ROWTERMINATOR ='\n',
	FIRSTROW =2,
	CODEPAGE ='65001',
	KEEPNULLS
	);


---barcha table lar yaratildi 
---Barcha tablelar uchun bulk insert qilindi 
---Keyingi bosqich
--Duplicate va noto‘g‘ri ma’lumotlarni tozalash:
--1.Customer jadvali uchun 
SELECT customer_id, COUNT(*) 
FROM StagingCustomers
GROUP BY customer_id
HAVING COUNT(*) > 1;
--yuq ekan 

--2. Order_item jadvali uchun 
SELECT item_id, COUNT(*) 
FROM StagingOrder_items
GROUP BY item_id
HAVING COUNT(*) > 1; 
--bor ekan 

--3. SatgingBrand table uchun 
Select brand_id, Count(*)
FROM StagingBrand
Group by brand_id
having Count(*) >1
--yuq ekan

--4.StagingCategories uchun 
select category_id, COUNT(*)
from StagingCategories 
group by Category_id
having count(*)>1
 --yuq ekan 

 --5. StagingOrders uchun duplicatlar 
 select order_id, COUNT(*)
 FROM StagingOrders
 group by order_id
 having COUNT(*)>1
 --yuq ekan 
 
 --6. Prdoducts  table uchun 
 select product_id, COUNT(*)
 from StagingProducts
 group by product_id
 having COUNT(*)>1
 --yuq ekan 

 --7. Staffs table uchun duplicate lar 
 select staff_id, COUNT(*)
 from StagingStaffs
 group by staff_id
 having COUNT(*)>1
 --yuq ekan 

 --8.Stocks table uchun 
 select store_id, COUNT(*)
 from StagingStocks
 group by store_id
 having COUNT(*)>1
 --bor ekan

  --9.Stores table uchun 
 select store_id, COUNT(*)
 from StagingStores
 group by store_id
 having COUNT(*)>1
 --yuq ekan
 
 --Order_items_final table yaratdim 
CREATE TABLE Order_items_Final(
    order_id INT,
    item_id INT,
    product_id INT,
    quantity INT,
    list_price VARCHAR(50),
    discount DECIMAL(5,2)
);
--Staging_Order_items dan duplicatlarni tozalab insert qildim 
 WITH cte AS (
					SELECT *,
					ROW_NUMBER() OVER(PARTITION BY item_id ORDER BY item_id) AS rn
					FROM StagingOrder_items
)

INSERT INTO Order_items_Final (order_id, item_id, product_id, quantity, list_price, discount)
SELECT order_id, item_id, product_id, quantity, list_price, discount
FROM cte
WHERE rn = 1;  
-- duplicate satrlar tashlandi

--Customer_Final yaratildi va duplikatlarsiz
create table Customers_final(
Customer_id int PRIMARY KEY,
first_name VARCHAR(100),
last_name VARCHAR(100),
phone VARCHAR(20),
email VARCHAR(100),
street VARCHAR(100),
city VARCHAR(100),
state VARCHAR(100),
zip_code VARCHAR(20)
);
 WITH cte AS (
					SELECT *,
					ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY customer_id) AS rn
					FROM StagingCustomers
)

INSERT INTO Customers_Final (customer_id, first_name, last_name, phone, email, street, city, state, zip_code)
SELECT customer_id, first_name, last_name, phone, email, street, city, state, zip_code
FROM cte
WHERE rn = 1;

 
--Orders_final yaratamiz va duplikatlarsiz
CREATE TABLE Orders_final (
    order_id INT,
    customer_id INT,
    order_status VARCHAR(100),
    order_date DATETIME,
    required_date DATETIME,
    shipped_date VARCHAR(50) NULL,
	store_id int,
	staff_id int
);
 WITH cte AS (
					SELECT *,
					ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY  order_id) AS rn
					FROM StagingOrders
)

INSERT INTO Orders_final (order_id, customer_id,  order_status, order_date, required_date, shipped_date, store_id, staff_id)
SELECT order_id, customer_id,  order_status,order_date, required_date, shipped_date, store_id, staff_id
FROM cte
WHERE rn = 1;

--Staffs_final tableni yarataman va duplikatlarsiz insert qilaman 

 create table Staffs_final (
 staff_id int PRIMARY KEY,
 first_name VARCHAR(100),
 last_name VARCHAR(100),
 email VARCHAR(100),
 phone VARCHAR(20),
 active VARCHAR(50),
 store_id int,
 manager_id VARCHAR(10) NULL
 );
  WITH cte AS (
					SELECT *,
					ROW_NUMBER() OVER(PARTITION BY staff_id ORDER BY  staff_id) AS rn
					FROM StagingStaffs 
)

INSERT INTO Staffs_final (staff_id, first_name,  last_name, email, phone, active, store_id, manager_id)
SELECT staff_id, first_name,  last_name, email, phone, active, store_id, manager_id 
FROM cte
WHERE rn = 1;

--StagingStore ning final tableini yarataman va duplikatlarsiz insert qilaman
create table Stores_final (
	store_id int PRIMARY KEY,
	store_name VARCHAR(50),
	phone VARCHAR(20),
	email VARCHAR(100),
	street VARCHAR(100),
	city VARCHAR(100),
	state VARCHAR(100),
	zip_code VARCHAR(20)
);

  WITH cte AS (
					SELECT *,
					ROW_NUMBER() OVER(PARTITION BY store_id ORDER BY  store_id) AS rn
					FROM StagingStores
)

INSERT INTO Stores_final (store_id, store_name,  phone, email, street, city, state, zip_code)
SELECT store_id, store_name,  phone, email, street, city, state, zip_code
FROM cte
WHERE rn = 1;

--Staging Ctaegories table final table qilamiz va duplikatlarsiz insert qilamiz
 
create table Categories_final(
category_id int,
category_name VARCHAR(50)
);
  WITH cte AS (
					SELECT *,
					ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY  category_id) AS rn
					FROM StagingCategories
)

INSERT INTO Categories_final (category_id, category_name )
SELECT category_id, category_name 
FROM cte
WHERE rn = 1;


--Products table ni final table ga aylantiraman va duplikatlarsiz insert qilaman
create table Products_final(
product_id int,
product_name VARCHAR(100),
brand_id int,
category_id int,
model_year int,
list_price DECIMAL (10,2)
);
  WITH cte AS (
					SELECT *,
					ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY  product_id) AS rn
					FROM StagingProducts
)

INSERT INTO Products_final (product_id, product_name, brand_id, category_id, model_year, list_price )
SELECT product_id, product_name, brand_id, category_id, model_year, list_price 
FROM cte
WHERE rn = 1;

--Stock_final table yarataman va duplikatlarsiz insert qilaman
 
create table Stocks_final (
store_id int,
product_id int,
quantity int
);

with cte as (
						select *,
						row_number() over(partition by store_id ORDER BY store_id) as rn
						from StagingStocks
)
INSERT INTO Stocks_final (store_id, product_id, quantity)
SELECT store_id, product_id, quantity
FROM cte
WHERE rn = 1;

--Brand table uchun final table yarataman va duplikatlarsiz insert qilaman
create table Brand_final(
brand_id int,
brand_name VARCHAR(100)
);
with cte as (
					select *,
					ROW_NUMBER() over(partition by brand_id ORDER BY brand_id ) as rn
					from StagingBrand
)
INSERT INTO Brand_final (brand_id, brand_name)
select brand_id, brand_name 
from cte 
where rn = 1;

--Endi har bir table lar uchun PK  larni belgilab chiqaman 

--1. demak Customers_final table da PK bor 
--ALTER TABLE Customers_final
--ADD CONSTRAINT PK_Customers_final 
--PRIMARY KEY (customer_id);

--2. Order_items_Final table uchun PK yaratmizz
ALTER TABLE Order_items_Final
ADD CONSTRAINT PK_Order_items_Final
PRIMARY KEY (order_id);

 ALTER TABLE Order_items_Final
ALTER COLUMN order_id INT NOT NULL;

ALTER TABLE Order_items_Final
ADD CONSTRAINT PK_Order_items_Final
PRIMARY KEY (order_id, item_id);

ALTER TABLE Order_items_Final
ADD CONSTRAINT PK_Order_items_Final
PRIMARY KEY (item_id);

DELETE FROM Order_items_Final
WHERE order_id IS NULL OR item_id IS NULL;

UPDATE Order_items_Final
SET item_id = ROW_NUMBER() OVER (ORDER BY order_id)
WHERE item_id IS NULL

ALTER TABLE Order_items_Final
ALTER COLUMN order_id INT NOT NULL;

ALTER TABLE Order_items_Final
ALTER COLUMN item_id INT NOT NULL;

 
 --3. Orders_final uchun PK tayyorlaymiz
 ALTER TABLE Orders_final
ALTER COLUMN order_id INT NOT NULL;

 ALTER TABLE Orders_final
ADD CONSTRAINT PK_Orders_final
PRIMARY KEY (order_id);

--4. Staffs_final table uchun PK yaratmiz (lekin avval yaratgan ekanman)
ALTER TABLE Staffs_final
ALTER COLUMN staff_id INT NOT NULL;

 ALTER TABLE Staffs_final
ADD CONSTRAINT PK_Staffs_final
PRIMARY KEY (staff_id);

--5.  Stores_final uchun avval yaratilgan ekan 

--6. Catgories_final uchun PK yaratmiz 
ALTER TABLE Categories_final
ALTER COLUMN category_id INT NOT NULL;

 ALTER TABLE Categories_final
ADD CONSTRAINT PK_Categories_final
PRIMARY KEY (category_id);

--7. Products table uchun PK yaratmiz 
ALTER TABLE Products_final
ALTER COLUMN product_id INT NOT NULL;

 ALTER TABLE Products_final
ADD CONSTRAINT PK_Products_final
PRIMARY KEY (product_id);

--8. Stocks table uchun PK belglaymiz
ALTER TABLE Stocks_final
ALTER COLUMN store_id INT NOT NULL;

 ALTER TABLE Stocks_final
ADD CONSTRAINT PK_Stocks_final
PRIMARY KEY (store_id);
 
--9. Brand_final uchun Pk yaratmiz
ALTER TABLE Brand_final
ALTER COLUMN brand_id INT NOT NULL;

 ALTER TABLE Brand_final
ADD CONSTRAINT PK_Brand_final
PRIMARY KEY (brand_id);
 
 --Endi har bir table lar uchun FK larni belgilab chiqamiz

--1. Orders_Final tablega FK o'rnatamiz
 ALTER TABLE Orders_Final
ADD CONSTRAINT FK_Orders_Customers 
FOREIGN KEY (customer_id) REFERENCES Customers_Final(customer_id);

--2. Orders_Finalda store_id FK qilib belgilaymiz
 ALTER TABLE Orders_Final
ADD CONSTRAINT FK_Orders_Stores
FOREIGN KEY (store_id) REFERENCES Stores_Final(store_id);
 
 --3. Orders_Finaldagi staff_id ni FK qilib belgilaymiz 
  ALTER TABLE Orders_Final
ADD CONSTRAINT FK_Orders_Staffs
FOREIGN KEY (staff_id) REFERENCES Staffs_Final(staff_id);
 
 --4. Order_items dagi order_id ni FK qilib belgilaymiz
   ALTER TABLE Order_items_Final
ADD CONSTRAINT FK_Orders_items_Orders
FOREIGN KEY (order_id) REFERENCES Orders_Final(order_id);

--5. Order_items dagi product_id ni FK qilib belgilaymiz
 ALTER TABLE Order_items_Final
ADD CONSTRAINT FK_Orders_items_Products
FOREIGN KEY (product_id) REFERENCES Products_Final(product_id);

--6. Stocks_final dagi store_id FK qilib belgilayman 

 ALTER TABLE Stocks_Final
ADD CONSTRAINT FK_Stocks_final_Stores
FOREIGN KEY (store_id) REFERENCES Stores_final(store_id);

--7. Stocks_final dagi product_id FK qilib belgilayman
 ALTER TABLE Stocks_Final
ADD CONSTRAINT FK_Stocks_final_Products
FOREIGN KEY (product_id) REFERENCES Products_final(product_id);

--8. Products_table dagi category_id FK qilib belgilaymiz
 ALTER TABLE Products_Final
ADD CONSTRAINT FK_Products_final_Category
FOREIGN KEY (category_id) REFERENCES Categories_final(category_id);

--9. Products dagi brand_ id FK qilib belgilaymiz
 ALTER TABLE Products_Final
ADD CONSTRAINT FK_Products_final_Brand
FOREIGN KEY (brand_id) REFERENCES Brand_final(brand_id);

--10. Staffs dagi store_id ni FK qilib belgilaymiz
 ALTER TABLE Staffs_Final
ADD CONSTRAINT FK_Staffs_final_Store
FOREIGN KEY (store_id) REFERENCES Stores_final(store_id);

--11. Staffs dagi MAnager_id Fk qilib belgilayman
 ALTER TABLE Staffs_Final
ADD CONSTRAINT FK_Staffs_final_Staffs
FOREIGN KEY (manager_id) REFERENCES Staffs_final(staff_id);


--endi SCHEMA larni yaratib tablelarni ichiga joylashtiraman
create SCHEMA Sales;
create SCHEMA Production;

ALTER SCHEMA Sales TRANSFER dbo.Customers_final;
ALTER SCHEMA Sales TRANSFER dbo.Orders_final;
ALTER SCHEMA Sales TRANSFER dbo.Staffs_final;
ALTER SCHEMA Sales TRANSFER dbo.Stores_final;
ALTER SCHEMA Sales TRANSFER dbo.Order_items_final;

ALTER SCHEMA Production TRANSFER dbo.Categories_final;
ALTER SCHEMA Production TRANSFER dbo.Products_final;
ALTER SCHEMA Production  TRANSFER dbo.Stocks_final;
ALTER SCHEMA Production TRANSFER dbo.Brand_final;

--View larni yaratishni boshlaymiz
SELECT * FROM Sales.Orders_final as o-- buyurtmalar 
select * from Sales.Order_Items_final oi--mahsulotlar
select * from  Sales.Stores_final s-- magazin haqida 
--##########1-vw_MagazinSavdosiOrtachaSummalari ni yaratdim 
CREATE VIEW vw_MagazinSavdosiOrtachaSummalari AS
						SELECT 
								s.store_id as Magazin_id,
								s.store_name as Magazin_nomi,
								sum(oi.quantity * CAST(oi.list_price AS DECIMAL(10,2))) as Foyda,
								count(Distinct o.order_id) as BuyutmalarSoni,
								avg(oi.quantity * CAST(oi.list_price AS DECIMAL(10,2))) as MagazinOrtachaSavdosi
						FROM Sales.Orders_final as o
						join Sales.Order_items_final as oi on o.order_id = oi.order_id
						join Sales.Stores_final as s on o.store_id = s.store_id
						GROUP BY s.store_id, s.store_name

 --endi shu vw_MagazinSavdosiOrtachaSummasi dan foydalanaman
  --1.  Barchasini ko'rish uchun 
 select * from vw_MagazinSavdosiOrtachaSummasi 
 --2. Faqat magazin_id va Ortacha summasini ko'rish uchun 
 select 
 Magazin_id, MagazinOrtachaSavdosi 
 from vw_MagazinSavdosiOrtachaSummalari
 --3. 1000 dan kop daromad qilgan magazinlar uchun 
 select * from vw_MagazinSavdosiOrtachaSummalari
 where MagazinOrtachasavdosi>1000
 --4. Teskari tartiblash uchun 
 select * from vw_MagazinSavdosiOrtachaSummalari
 order by MagazinOrtachaSavdosi 

 --###########2. VW yaratamiz
 --vw_TopSellingProducts: Mahsulotlarni jami savdo miqdoriga ko‘ra tartiblash (reytinglash)”
 select * from Sales.Order_items_Final as oi
 select * from Production.Products_final as p

 CREATE VIEW vw_MahsulotSavdosiReytinglari as
							 SELECT 
									p.product_id as mahsulot_id,
									p.product_name as mahsulot_nomi,
									sum(oi.quantity * CAST(oi.list_price AS DECIMAL(10,2))) as JamiSavdo,
									 RANK() OVER (ORDER BY SUM(oi.quantity * CAST(oi.list_price AS DECIMAL(10,2))) DESC) AS SavdoReytingi
							FROM Sales.Order_items_final AS oi
							JOIN Production.Products_final AS p ON oi.product_id = p.product_id
							GROUP BY p.product_id, p.product_name;

 --endi 2-vw_MahsulotlarSavdosiReytingi dan foydalanamiz 
 --1. Barcha mahsulotlarni ko'ramiz 
 select * from vw_MahsulotSavdosiReytinglari

 --2. Faqat top 3 ta mahsulotni chiqaramiz 
 select TOP 3 mahsulot_id,
		 mahsulot_nomi,
		 JamiSavdo,
		 SavdoReytingi
 from vw_MahsulotSavdosiReytinglari

 --3. Faqat ayrim mahsulotlarni qidirish
 select * from vw_MahsulotSavdosiReytinglari
 where mahsulot_nomi LIKE '%Electra%'

 --4. Savdo Reytingi bo'yicha saralash
 select * from vw_MahsulotSavdosiReytinglari
 order by SavdoReytingi DESC

--########## 3-VW  vw_OmbordagiMahsulotlar yaratamiz

select * from [Sales].[Stores_final] as s
select * from [Production].[Products_final] as p
select * from [Production].[Stocks_final] as  o

CREATE VIEW vw_OmbordagiMahsulotlar as 
					SELECT 
								s.store_id as magazin_id,
								s.store_name as magazin_nomi,
								p.product_id as mahsulot_id,
								p.product_name as mahsuot_nomi,
								o.quantity as ombordagi_soni
					FROM [Production].[Stocks_final] as  o
					JOIN [Production].[Products_final] as p on o.product_id = p.product_id
					JOIN [Sales].[Stores_final] as s on s.store_id = o.store_id
 
 -- vw_OmbordagiMahsulotlar bilan ishlash 
 --1. barcha mahsulotlarni koramiz
 select * from vw_OmbordagiMahsulotlar

 --2. Faqat malumo magazinlarni ko'ramiz 
 select * from vw_OmbordagiMahsulotlar
 where magazin_id = 3

 --3. kam qolgan mahsulotlarni ko'ramiz
 select * from vw_OmbordagiMahsulotlar
 where ombordagi_soni <15

 --4. Ombordagi mahsulotlarni zahirasi boyicha saralash 
 select * from vw_OmbordagiMahsulotlar
 order by ombordagi_soni DESC

 --###### 4-View ni yaratamiz vw_MintqaviyTrendlar
 select * from [Sales].[Orders_final] as b 
 select * from [Sales].[Stores_final] as m
 select * from [Sales].[Order_items_Final] as oi

 
create View vw_MintaqaviyTrendlar as
					SELECT 
								m.store_id AS magazin_id,
								m.store_name AS magazin_nomi,
								m.street AS magazin_kochasi,
								m.city AS magazin_shahar,
								m.state AS magazin_davlat,
								COALESCE(SUM(CAST(oi.quantity AS DECIMAL(10,2)) * CAST(oi.list_price AS DECIMAL(10,2))),0) AS Foydasi
					FROM [Sales].[Stores_final] AS m
					LEFT JOIN [Sales].[Orders_final] AS b ON m.store_id = b.store_id
					LEFT JOIN [Sales].[Order_items_Final] AS oi ON b.order_id = oi.order_id
					GROUP BY m.store_id, m.store_name, m.street, m.city, m.state;

--Endi bu view bilan quyidagi ishlarni bajaramiz 
--1. barcha mintaqalarni boyicha korish 
select * from vw_MintaqaviyTrendlar
 --2. Faqat ma'lum regionlar korish uchun3
 select * from vw_MintaqaviyTrendlar
 where magazin_shahar = 'Rowlett'
 --3. Daromadi boyicha saralash 
 select * from vw_MintaqaviyTrendlar
 order by Foydasi desc
 
 --#######5. view ni yaratamiz 
 CREATE VIEW vw_XodimlarSamaradorligi  AS
SELECT 
    s.staff_id as xodim_id,
    s.first_name + ' ' + s.last_name AS xodim_ismi,
    COUNT(DISTINCT o.order_id) AS olingan_buyurtmalar,
    SUM(CAST(oi.quantity AS DECIMAL(10,2)) * CAST(oi.list_price AS DECIMAL(10,2))) AS Olingan_foydasi
FROM Sales.Orders_final AS o
JOIN Sales.Order_items_final AS oi ON o.order_id = oi.order_id
JOIN Sales.Staffs_final AS s ON o.staff_id = s.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name;

--Endi shu view bilan quyidagi  amallarni bajaramiz 
-- Barcha xodimlar bo‘yicha natija
SELECT *
FROM vw_XodimlarSamaradorligi;

-- Eng samarali xodim (daromad bo‘yicha)
SELECT TOP 1 *
FROM vw_XodimlarSamaradorligi
ORDER BY Olingan_foydasi DESC;

-- Eng ko‘p buyurtma qilgan xodim
SELECT TOP 1 *
FROM VW_XODIMLARSAMARADORLIGI
ORDER BY OLINGAN_BUYURTMALAR DESC;


 --####### 6. vw_MahsulotKategoriyasiBoyichaSotuvlar ni yaratamiz
select * from [Sales].[Order_items_Final]
select * from [Production].[Products_final]
select * from [Production].[Categories_final]
 
 CREATE VIEW vw_MahsulotKategoriyasiBoyichaSotuvlar AS
						SELECT 
										c.category_id as kategoriya_id,
										c.category_name as kategoriya,
										SUM(oi.quantity) AS SotuvHajmi,
										SUM(CAST(oi.quantity AS DECIMAL(10,2)) * CAST(oi.list_price AS DECIMAL(10,2))) AS Foydasi
						FROM Sales.Order_items_final AS oi
						JOIN Production.Products_final AS p ON oi.product_id = p.product_id
						JOIN Production.Categories_final AS c ON p.category_id = c.category_id
						GROUP BY c.category_id, c.category_name;


 -- Endi shi view bilan bajariladiga amallar 
 --1. Barcha Mahsulot kategoriyasi boyicha sotuvlarni korish
 select * from vw_MahsulotKategoriyasiBoyichaSotuvlar

 --2. Eng kop sotilgan kategoriyani korish uchun 
 select TOP 1 * from vw_MahsulotKategoriyasiBoyichaSotuvlar
 order by  Foydasi DESC 

 --3. Foydasi boyicha saralash 
 select * from vw_MahsulotKategoriyasiBoyichaSotuvlar
 order by Foydasi DESC

 --########STORAGE PROCEDURE LARGA OTAMIZ
 --1. sp_CalculateStoreKPI
 Drop Procedure sp_MagazinKPI_hisobla
 create procedure sp_MagazinKPI_hisobla
    @storeid int
as
begin
    select 
    s.store_name as magazin_nomi,
    count(distinct o.order_id) as jami_buyurtmalar,
    sum(cast(oi.quantity as decimal(10,2)) * cast(oi.list_price as decimal(10,2))) as jami_foyda,
    COALESCE(avg(cast(oi.quantity as decimal(10,2)) * cast(oi.list_price as decimal(10,2))), 0) as buyrtmalar_ortacha_qiymati
	from sales.orders_final as o
    join sales.order_items_final as oi on o.order_id = oi.order_id
    join sales.stores_final as s on o.store_id = s.store_id
    where s.store_id = @storeid
    group by s.store_name;
end;
EXEC sp_MagazinKPI_hisobla @StoreID = 2;


--#######2- sp_QolganMahsulotlarRoyhati  yaratamiz
--sp 10 tadan kam mahsulotlar uchun ishlab chiqilgan 
create procedure sp_QolganMahsulotlarRoyhati
AS
begin
    select 
        s.store_id,
        s.store_name,
        p.product_id,
        p.product_name,
        o.quantity AS StockQuantity
    from Production.Stocks_final AS o
    join Production.Products_final AS p ON o.product_id = p.product_id
    join Sales.Stores_final AS s ON o.store_id = s.store_id
    where o.quantity <= 10   
    order by s.store_id, o.quantity ASC;
end;
exec sp_QolganMahsulotlarRoyhati

--###### 3- sp_YillarBoyichaTaqqosla degab sp  ni yaratamiz 
CREATE PROCEDURE sp_YillarBoyichaTaqqosla
    @Year1 INT,
    @Year2 INT
AS
BEGIN
    SELECT 
        YEAR(o.order_date) AS sotuv_yili,
        COUNT(DISTINCT o.order_id) AS jami_buyurtmalar,
        SUM(CAST(oi.quantity AS DECIMAL(10,2)) * CAST(oi.list_price AS DECIMAL(10,2))) AS jami_foyda,
        AVG(CAST(oi.quantity AS DECIMAL(10,2)) * CAST(oi.list_price AS DECIMAL(10,2))) AS BuyurtmaningOrtachaQiymati
    FROM Sales.Orders_final AS o
    JOIN Sales.Order_items_final AS oi ON o.order_id = oi.order_id
    WHERE YEAR(o.order_date) IN (@Year1, @Year2)
    GROUP BY YEAR(o.order_date);
END;

exec sp_YillarBoyichaTaqqosla @YEAR1= 2016, @YEAR2 = 2018

--##########4. Oxirgi  sp_MijozXarajatlari yaratamiz
CREATE PROCEDURE sp_MijozXarajatlari
    @CustomerID INT
AS
BEGIN
    -- Jami buyurtmalar va sarf
    SELECT 
        c.customer_id as mijoz_id,
        c.first_name + ' ' + c.last_name AS Mijoz_ismi,
        COUNT(DISTINCT o.order_id) AS Jami_buyurtmalar,
        SUM(CAST(oi.quantity AS DECIMAL(10,2)) * CAST(oi.list_price AS DECIMAL(10,2))) AS Jam_xarajatlar
    FROM Sales.Customers_final AS c
    LEFT JOIN Sales.Orders_final AS o ON c.customer_id = o.customer_id
    LEFT JOIN Sales.Order_items_final AS oi ON o.order_id = oi.order_id
    WHERE c.customer_id = @CustomerID
    GROUP BY c.customer_id, c.first_name, c.last_name;

    -- Eng ko‘p sotib olingan mahsulotlar bo'yicha
    SELECT TOP 5
        p.product_id as mahsulot_id,
        p.product_name as mahsulot_nomi,
        SUM(oi.quantity) AS Sotib_olingan_miqdor
    FROM Sales.Order_items_final AS oi
    JOIN Sales.Orders_final AS o ON oi.order_id = o.order_id
    JOIN Production.Products_final AS p ON oi.product_id = p.product_id
    WHERE o.customer_id = @CustomerID
    GROUP BY p.product_id, p.product_name
    ORDER BY Sotib_olingan_miqdor DESC;
END;

exec sp_Mijozxarajatlari @CustomerID = 3;

--###########################################################################
--1 KPI Total Revenue	Company-wide performance
select SUM(Foyda) AS TotalRevenue
from vw_MagazinSavdosiOrtachaSummasi;

--2. KPI   Ortacha_buyurtma_qiymati 
SELECT 
    AVG(Foyda) AS Ortacha_buyurtma_qiymati 
FROM  vw_MagazinSavdosiOrtachaSummasi;

 
--3. KPI 
select 
p.product_id,
p.product_name,
sum(oi.quantity) as jami_sotilgan,
avg(s.quantity) as orta_ombor_zapasi,
case 
		when avg(s.quantity) = 0 then 0
		else sum(oi.quantity) / avg(s.quantity)
		end as inventoryturnover
from production.products_final p
left join sales.order_items_final oi on oi.product_id = p.product_id
left join production.stocks_final s on s.product_id = p.product_id
group by p.product_id, p.product_name;


--4.KPI 
CREATE PROCEDURE sp_ProductReturnRate
AS
BEGIN
    SELECT 
        O.ProductID,
        SUM(O.Quantity) AS TotalSold,
        SUM(ISNULL(R.Quantity, 0)) AS TotalReturned,
        (SUM(ISNULL(R.Quantity, 0)) * 1.0 / SUM(O.Quantity)) * 100 AS ReturnRatePercent
    FROM OrderItems O
    LEFT JOIN Returns R
        ON O.ProductID = R.ProductID
    GROUP BY O.ProductID;
END;

--5.KPI
SELECT 
    magazin_id,
    magazin_nomi,
    Foydasi AS Revenue
FROM vw_MintaqaviyTrendlar
ORDER BY Foydasi DESC;

--6. KPI 

SELECT 
c.category_id as kategoriya_id,
c.category_name as kategoriya,
SUM(oi.quantity) AS SotuvHajmi,
SUM(CAST(oi.quantity AS DECIMAL(10,2)) * CAST(oi.list_price AS DECIMAL(10,2))) AS Foydasi
FROM Sales.Order_items_final AS oi
JOIN Production.Products_final AS p ON oi.product_id = p.product_id
JOIN Production.Categories_final AS c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name;

--yoki 
 select * from vw_MahsulotKategoriyasiBoyichaSotuvlar  

 --KPI 
 SELECT
    b.brand_name AS Brend,
    SUM(cast(oi.quantity as decimal(10,2)) * cast(oi.list_price as decimal(10,2))) AS JamiSavdo
FROM Sales.Order_items_final AS oi
JOIN Production.Products_final AS p 
    ON oi.product_id = p.product_id
JOIN Production.Brand_final AS b
    ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY JamiSavdo DESC;

--KPI

SELECT
    st.staff_id AS Xodim_id,
    st.first_name + ' ' + st.last_name AS Xodim_ismi,
    SUM(cast(oi.quantity as decimal(10,2)) * cast(oi.list_price as decimal(10,2))) AS JamiTushum
FROM Sales.Order_items_final AS oi
JOIN Sales.Orders_final AS o 
    ON oi.order_id = o.order_id
JOIN Sales.Staffs_final AS st 
    ON st.staff_id = o.staff_id
GROUP BY st.staff_id, st.first_name, st.last_name
ORDER BY JamiTushum DESC;

--yoki
select  * from vw_XodimlarSamaradorligi



