--1.	Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) to
--designate SalesOrders that occurred within the period ‘7/28/2008’ and ‘7/29/2014’

select soh.SalesOrderID,soh.ShipDate
from Sales.SalesOrderHeader  soh inner join  Sales.SalesOrderDetail sod   on soh.SalesOrderID=sod.SalesOrderID
where sod.ModifiedDate between '7/28/2008' and '7/29/2014'



--2.	Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)

select pp.ProductID,pp.Name ,pp.StandardCost
from Production.Product pp   inner join Production.ProductCostHistory pch on  pp.ProductID=pch.ProductID
where pch.StandardCost<110




--3.	Display ProductID, Name if its weight is unknown
select pp.ProductID,pp.Name
from Production.Product pp   
where pp.Weight IS  NULL



--4.	 Display all Products with a Silver, Black, or Red Color

SELECT pp.Color,pp.ProductID,pp.Name
FROM Production.Product pp
WHERE pp.Color in('black','red','silver')


---5.	 Display any Product with a Name starting with the letter B

SELECT pp.Name,pp.ProductID
FROM Production.Product pp
WHERE pp.Name LIKE'b%'

	 --Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.Store table  in a newly created table named [store_Archive]

create table  storeArchive(
rowguid uniqueidentifier,
name nvarchar(50),
sealespersonid int,
demograpgics xml);

insert into storeArchive( rowguid,name,sealespersonid,demograpgics)
select ss.rowguid,ss.Name,ss.SalesPersonID,ss.Demographics
from sales.Store ss

select* 
from storeArchive



select @@VERSION


select @@SERVERNAME





--day3
----1.	Display FirstName and LastName for persons that are Female and single under the age of 40 using CTE.

with ctee
as
(
select pp.FirstName,pp.LastName 
from Person.Person pp
where  pp.Title like 'MRS' 
)

select* from ctee



--2.	Make a new table with the same data in  FirstName, LastName in Person table using CTE
go
with cte 
as 
(

   SELECT*
    FROM Person.Person
)


select* from cte

go

)
)



-----day 6

---1.3.	 Divide the products into 30 segments according to their weight to handle some operations in shipment 
--.use AdventureWorks[Product table]


select pp.Name,pp.Weight
	   ,ROW_NUMBER() over(order by pp.Weight) as "raw number"
	   --,rank() over(order by pp.Weight) as "rank"  	
      -- ,DENSE_RANK() over(order by st_age) as "Dense = exact ranking"  
	   ,NTILE(30) over(order by pp.Weight ) as group3          --divided into 3 groups
    from Production.Product pp
	where pp.Weight is not null
	----------------------------------


	



------------------
----2.	Write a query to display the sum of the vacation hours in each job title for each gender, 
--then the sum for each job title and the total summation.
--use AdventureWorks [employee table]




	select HrE.JobTitle,HrE.Gender, sum(HrE.VacationHours) 
from HumanResources.Employee  HrE 
GROUP BY rollup  (HrE.Gender,HrE.JobTitle)


------------this
select HrE.JobTitle,HrE.Gender, sum(HrE.VacationHours) 
from HumanResources.Employee  HrE 
GROUP BY cube  (HrE.Gender,HrE.JobTitle)
-----------------




---bouns 
--bonus: Display the average vacation hours in each job title for each gender like the following table
go
select  sum(Gender='f') as fmale,sum( Gender='m') as male, JobTitl
from (
select HrE.JobTitle, avg(HrE.VacationHours) ,HrE.Gender
from HumanResources.Employee  HrE as l
GROUP BY rollup  (HrE.Gender,HrE.JobTitle) 

go
-----this

select  JobTitle, sum(Gender='f') as fmale,sum( Gender='m') as male
from (
select HrE.JobTitle, HrE.Gender ,avg(HrE.VacationHours)  
from HumanResources.Employee  HrE
GROUP BY cube (HrE.Gender,HrE.JobTitle)
)

GROUP BY rollup (JobTitle)




go
--GROUP BY rollup  (HrE.Gender,HrE.JobTitle) 
--union all
select JobTitle , sum(Gender='f') as fmale,sum( Gender='m') as male
from (
select HrE.JobTitle,HrE.Gender, avg(HrE.VacationHours) 
from HumanResources.Employee  HrE 
GROUP BY cube  (HrE.Gender,HrE.JobTitle))
--order by JobTitle
GROUP BY rollup  (JobTitle) 
go

------------------
SELECT Computers, Science, Programming, Business
FROM (
  SELECT Price, Category FROM dbo.Books
) Books
PIVOT ( 
    MAX(Price) FOR Category IN (Computers, Science, Programming, Business)
) Result;


select column1, '' as Female, Gender as Male from tablename where gender = 'Male'
union
select column1, Gender as Female, '' as Male from tablename where gender = 'Female'



declare @sal int



open c1
fetch c1 into @sal



while @@FETCH_STATUS = 0
begin
if(@sal >3000)
update Instructor Set Salary=Salary*1.2
where current of c1



else
update Instructor Set Salary=Salary*1.1
where current of c1
fetch c1 into @sal
end

close c1
deallocate c1