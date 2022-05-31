--1	Display the Department id, name and SSN and the name of its manager.

select d.Dname,d.Dnum, d.MGRSSN, e.Fname
from Departments  d, Employee  e
where e.ssn= d.MGRSSN

--	Display the name of the departments and the name of the projects under its control.


select d.Dname,d.Dnum, d.MGRSSN, e.Pname
from Departments  d, Project  e
where D.Dnum=e.Dnum



--	2display all the employees in department 30 whose salary from 1000 to 2000 LE monthly.

select e.Fname
from Employee  e
where e.Dno=30 and Salary between 1000 and 2000  




--3	Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
select e.Fname
from Employee e inner join   Works_for  wf on  e.SSN=wf.ESSn
inner join Project p on p.Pnumber=wf.Pno
where e.Dno=10 and wf.Hours>=10 and p.Pname='AL Rabwah'



--4	Find the names of the employees who directly supervised with Kamel Mohamed.*******
go
select e.Fname,e.Lname
from  Employee e, Employee s
where e.Superssn= s.SSN and s.Fname='Kamel' and s.Lname='Mohamed' 
go

SELECT e.SSN AS "Emp_ID",e.Fname AS "Employee Name",e.Lname
FROM Employee e, Employee s
WHERE  e.Superssn= s.SSN and s.Superssn=(select s.SSN from Employee b where b.Fname='Kamel' and b.Lname='Mohamed')


--5	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
select e.Fname,e.Lname, p.Pname
from Employee e inner join   Works_for  wf on  e.SSN=wf.ESSn
inner join Project p on p.Pnumber=wf.Pno
order by p.Pname


--6	For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate

select p.Pnumber, e.Fname,e.Lname,d.Dname
from Project p , Departments d,  Employee e
where d.Dname=p.Dnum and e.SSN=d.MGRSSN


--	Display All Data of the mangers
select*
from  Departments d,  Employee e
where  e.SSN=d.MGRSSN

--7	Display All Employees data and the data of their dependents even if they have no dependents

select*
from Employee left outer join Dependent
on   Employee.SSN  =Dependent.ESSN





---day 2
--1  1.	Fill the Create a view “v_Emp_Projec” that will display the project name and the number of employees working on it
go
 create view v_Emp_Projec
as
select count(e.SSN) as counttion, p.Pname
from Employee e inner join   Works_for  wf on  e.SSN=wf.ESSn
inner join Project p on p.Pnumber=wf.Pno
group by  p.Pname
go
select* from v_Emp_Projec

--1.	2.	Create a view named  “v_count “ that will display the project name and the number of hours for each one


GO
CREATE VIEW v_count
as
select sum(wf.Hours) as sumtotalitems,p.Pname
from Project p inner join   Works_for  wf on  p.Pnumber=wf.Pno
group by p.Pname

go


select* from v_count

--3*****  	Create a view named ” v_project_30H” that will display the 
--project name for the project that'll last for less than 30 hours, use the previously created view “v_count”
GO
/*create view v_project30h
as
select p.Pname
from Project p inner join   Works_for  wf on  p.Pnumber=wf.Pno
where   
group by p.Pname*/

GO

create view v_project30hh
as
select s.Pname
from v_count s
where s.sumtotalitems<30
GO


select* from v_project30hh 
go
---4.	Delete the views  “v_project_30H” and “v_count”

DROP VIEW [v_count];
DROP VIEW v_project30hh;


--*******    5.	Display the project name that contains the letter “c” Use the previous view created in “v_Emp_Project”

/*create view v_pro
as
select p.Pname
from Project p 
where p.Pname like '%c%' */
go
create view v_pro
as
select vep.Pname
from v_Emp_Projec vep
where vep.Pname like '%c%'

go

select* from v_pro

--add6 	some dates then create view name “v_2021_check” that will display employee no.
--which must be from the first of January and the last of December 2021.
--Note: this view will be used to insert data so make sure that the coming new data matches the condition

--
ALTER TABLE  Works_for     ---just run a select query 
ADD entr_date date ;

select*
from Works_for


go
CREATE RULE range_dateeee 
AS   
@range  between '2021-1-1' AND  '2021-12-30'; 
go

sp_bindrule 
go
/*INSERT INTO Works_for ( entr_date)
VALUES ( '2015-06-24');*/





--creat view
go
create view v_2021_checkk
as 
select e.SSN 
from Employee e join Works_for wf on e.SSN=wf.ESSn
where enter_date between '2021-1-1' and  '2021-12-30'


go

alter view v_2021_checkk
with encryption
as
select e.SSN 
from Employee e join Works_for wf on e.SSN=wf.ESSn
where enter_date between '2021-1-1' and  '2021-12-30'
with check option
go

--Insert into v_2021_checkk (name,bod) values ('ahmed', '2020-12-15')

insert into v_2021_checkk
values(112233,100,400,'2021-2-1') 
 
 drop view v_2021_checkk

 


--7.***	Create a temporary table [Session-based] to save the employee's name and birth date.
go
create table #employe(

name nvarchar(50) ,
bod date
)

go
Insert into #employe (name,bod) values ('ahmed', '2020-12-15')
Insert into #employe (name,bod) values ('ali' ,'2020.12.15')
Insert into #employe (name,bod) values ('alaa ','2020/12/15')
Insert into #employe (name,bod) values (' ola','20201215')
Insert into #employe(name,bod) values ('alayan' ,'2020-5-2')
 
 go

 select* from #employe
 go
drop table #employe







----day 33

--1.	Create the following schema and transfer the following tables to it  
--A.	Company Schema
--i.	Department table (Programmatically) 
--ii.	Project table (visually)
go
create schema Company
go
alter schema Company transfer Department
go
alter schema Company transfer Project
go


--B. Human Resource Schema
--i.	  Employee table (Programmatically)
create schema Hr
go
alter schema Hr transfer Employee
go



 
--2.	Create a new user data type named loc with the following Criteria:
•      -- nchar(2)
•      -- default: NY
•      -- create a rule for this Data type: values in (NY, DS, KW)) and associate it to the location column
go
CREATE TYPE UDD1 FROM nchar(2)  NOT NULL;



go
create default d22 as 'NY'
--go
--sp_bindrule greaterthan100 , OverTimeNewDT
go
sp_bindefault d2 , UDD
go
create rule uudr as @value in ('NY', 'DS',' KW')
go
sp_bindrule uudr , UDD1
go

--3.	  Create a New table Named newStudent, and use the new UDD(user-defined datatype) on it.
--a.    Make the ID column and don’t make it identity.

CREATE TABLE newStudent (
    StudenID int,
    LastName varchar(255),
   loc   varchar(25)
);
alter table newStudent
alter column loc UDD1


--4.	 Create a new sequence for the ID values of the previous table.
--a.     Insert 3 records in the table using the sequence.
go
CREATE SEQUENCE valid11
 as int
START WITH 1
INCREMENT BY 1;

go
insert into [dbo].newStudent ([StudenID],[LastName],[loc]) 
values(NEXT VALUE FOR valid11,'fff','ny');
go
insert into [dbo].newStudent ([StudenID],[LastName],[loc]) 
values(NEXT VALUE FOR valid11,'fff','ds');

go
insert into [dbo].newStudent ([StudenID],[LastName],[loc]) 
values(NEXT VALUE FOR valid11,'fff','kw');
go

--b.    Delete the second row of the table.

DELETE FROM newStudent WHERE newStudent.StudenID=2;

select* from  newStudent


--c.     Insert 2 other records using the sequence.
go
insert into [dbo].newStudent ([StudenID],[LastName],[loc]) 
values(NEXT VALUE FOR valid11,'fff','ny');
go
insert into [dbo].newStudent ([StudenID],[LastName],[loc]) 
values(NEXT VALUE FOR valid11,'fff','ds');


select* from  newStudent
--d.    Can you insert another record without using the sequence? Try it! Can you do the same if it was an identity column?
insert into [dbo].newStudent ([StudenID],[LastName],[loc]) 
values(35,'fff','ds');
select* from  newStudent

--e.    Can you edit the value, if the ID column is in any of the inserted records? Try it!


update [dbo].newStudent
set [StudenID]=12
where [StudenID]=5

--f.      Can you use the same sequence to insert in another table?

--yes
--g.     If yes, do you think that the sequence will start from its initial value in the new 
--table and insert the same IDs that were inserted in the old table?
CREATE TABLE newStudent222 (
    StudenID int,
    LastName varchar(255),
   loc   varchar(25)
);
go
insert into [dbo].newStudent222([StudenID],[LastName],[loc]) 
values(NEXT VALUE FOR valid11,'fff','ds');
go
select* from  newStudent222

--h.    How to skip some values from the sequence not to be inserted in the table? Try it.RESTART WITH 1 ; 


--i.       Can you do the same with the Identity column?



--j.      What’re the differences between the Identity column and Sequence?



ALTER SEQUENCE Samples.IDLabel  
RESTART WITH 1 ; 


-----------------day44

--1.	Create a function that takes the project number and displays all employees in this project.


go

create function getempname( @did int=10)
returns table
as 
return 
(
   select  e.Fname ,e.Lname,e.SSN
	from Employee e inner join   Works_for  wf on  e.SSN=wf.ESSn
inner join Project p on p.Pnumber=wf.Pno
where e.Dno=10 and wf.Hours>=10 and p.Pnumber=@did
)
go
select * from getempname(100)

go

-----proc

create  proc getempname1 @did int=10
as 
select  e.Fname ,e.Lname,e.SSN
	from Employee e inner join   Works_for  wf on  e.SSN=wf.ESSn
inner join Project p on p.Pnumber=wf.Pno
where e.Dno=10 and wf.Hours>=10 and p.Pnumber=@did


getempname1 100







-----day5



---3.	 Create a stored procedure that will check for the number of total employees in the
-- project no.100  if they are more than 3 print a message to the user “'The number of employees in the project 100 is 3 or more 
--” if they are less display a message to the user “'The following employees work for the project 100” in addition to the first name
---and last name of each one. [Company DB] 
go
alter  proc empnanum
as
declare @t int=(select count(e.SSN) as counttion
from Employee e inner join   Works_for  wf on  e.SSN=wf.ESSn
inner join Project p on p.Pnumber=wf.Pno
where p.Pnumber=100
)
IF (@t >=3)
BEGIN

   Select 'The number of employees in the project 100 is 3 or more'

END
ELSE
BEGIN
   SELECT  'The number of employees in the project 100 is lessthan 3'  
END
select  e.Fname,e.Lname
from Employee e inner join   Works_for  wf on  e.SSN=wf.ESSn
inner join Project p on p.Pnumber=wf.Pno
where p.Pnumber=100

go

execute empnanum




---- 4.	  Create a stored procedure that will be used in case there is an old employee has left the project 
--and a new one becomes instead him. The procedure should take 3 parameters (old Emp. SSN, new Emp. SSN, and the project no.)
---and it will be used to update the works_on table. 

--Note: Don’t forget to check if the old employee already exists in the table and he works on that project too [Company DB] ***

create table history22 
(
OldId int ,
_NewId int ,
projectno int,
name varchar(500),
date date
)
go
alter trigger empst 
on works_for 
after update 
as
if update(ESSn)
begin
declare @oldid int , @newid int,@prono int    
select @newid =ESSn from inserted
select @prono =Pno from inserted
select  @oldid = ESSn from deleted
insert into history22 values (@oldid , @newid ,@prono, SUSER_NAME() , GETDATE())

end

go


alter  proc empup13   @oldEmpSSN int , @newEmpSSN int,   @prono  int 
	as
	IF EXISTS
(
    SELECT essn  from works_for wf where  wf.ESSn=@oldEmpSSN
    
) 
begin
	update works_for set Essn = @newEmpSSN ,  Pno=@prono where ESSn = @oldEmpSSN
	select * from history22
end 


go

 empup13  0,112233,100

go

select * from history22
go
--else
--begin
--select 'the old emp is not EXISTS'
--end






---55.	    Create an Audit table with the following structureThis table will be used to audit the update trials on the
--Budget column (Project table, Company DB)
--:If a user updated the Hours column then the project no., the user name that made that update,-
--the date of the modification and the value of the old and the new Hours will be inserted into the Audit table
--Note: This process will take place if the user updated the Hours column only*****

create  table history55
(
OldId int ,
_NewId int ,
proj int,
name varchar(500),
date date
)

go

alter trigger t55
on works_for
after update 
as
if update(Hours)
begin
declare @oldid int , @newid int ,@pro int
select @newid =Hours from inserted
select  @oldid = Hours from deleted
select @pro =Pno from inserted
insert into history55 values (@oldid , @newid ,@pro ,SUSER_NAME() , GETDATE())
end

go

update works_for set Hours = 30 where Hours = 10
select * from history55








--666.	 Create a trigger that prevents the insertion Process for the Employee table in March [Company DB]. ***


---first way

create trigger t65+
on employee
 after insert 
as









-----------------------------scond way

create table historyinsertion6
(
emp int,
name varchar(50),
datee date,
)
go
alter trigger t65
on employee
after  insert 
as
declare @d varchar(30) =format(getdate(),'MMM')
declare @note1 int
select  @note1 =SSN from inserted
insert into historyinsertion6 values(@note1, SUSER_NAME() , GETDATE())
if(@d like 'may' )
begin
rollback transaction
end


go

insert into employee (employee.ssn) values(0000)
go
select*
from employee 
go






--77.	 Create a trigger that prevents users from altering any table in Company

create trigger pervent 
on database 
for alter_table
as
select 'altering not allow'
rollback




ENABLE TRIGGER pervent ON DATABASE
GO
DISABLE TRIGGER pervent ON DATABASE
GO

drop trigger  pervent








-----------day6
--1.4.	 Write a query to select the third project that took a long time (works_for table). use Company_SD

SELECT *
FROM (
	  SELECT  Pno, ROW_NUMBER() OVER(  ORDER BY Hours desc) AS rk
      FROM Works_for wf
      ) 
      AS NewTable
WHERE rk=3;


--● 	 try to redo it use CTE
go
with ctee
as
(
SELECT  Pno, ROW_NUMBER() OVER(  ORDER BY Hours desc) AS rkk
 FROM Works_for wf
      
)

select * from ctee
where rkk=3
go






-----------------day777
--3.	Create a cursor for the Employee table that increases
-- Employee salary by 10% if Salary <3000  and increases it by 20% if Salary >=3000. Use company DB


declare c1 cursor
for 
    select e.Salary
	from Employee e

for update

declare @sal int

open c1
fetch c1 into @sal 

while @@FETCH_STATUS = 0
  begin 
    if(@sal >=3000)
	  update Employee Set Salary=Salary*1.2
	  where current of c1 

    else 
	   update Employee Set Salary=Salary*1.1
	    where current of c1 
    fetch c1 into @sal 
  end
 -- select @sal
 
close c1
deallocate c1



select e.Salary from Employee e






