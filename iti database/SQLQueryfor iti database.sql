use ITI
go


--1.	Display instructor Name and Department Name  Note: display all the instructors if they are attached to a department or not
select i.Ins_Name, d.Dept_Name
from Department d right outer join Instructor i
on d.Dept_Id=i.Dept_Id



--2.	Display student full name and the name of the course he is taking For only courses which have a grade
select s.St_Fname,s.St_Lname,c.Crs_Name
from Student s, Stud_Course sc, Course c
where  s.St_Id=sc.St_Id and c.Crs_Id = sc.Crs_Id and sc.grade is not null

SELECT
s.St_Fname,s.St_Lname,c.Crs_Name 
 FROM student s
JOIN Stud_Course sc
ON s.St_Id = sc.St_Id
 JOIN course c
ON c.Crs_Id = sc.Crs_Id sc.grade is not null



--3.	Display number of courses for each topic name
select count(*)
from Course c , Topic t
where  t.Top_Id= c.Top_Id
-----ubdate
select count(*), t.Top_Id,t.Top_Name
from Course c , Topic t
where  t.Top_Id= c.Top_Id
group by t.Top_Id




--4.	Display max and min salary for instructors
select max(i.Salary), min(i.Salary)
from Instructor i

--5.	Display instructors who have salaries less than the average salary of all instructors.***
select i.Ins_Name
from Instructor i
where i.Salary< (SELECT AVG(i.salary)
                     FROM Instructor i )

--6.	Display the Department name that contains the instructor who receives the minimum salary.*****
select  d.Dept_Name
from Department d inner join Instructor i on  d.Dept_Id=i.Dept_Id
where i.Salary = (SELECT min(i.salary) FROM Instructor i)




--7.	Select max two salaries in instructor table
/*SELECT TOP 2 i.Salary FROM Instructor i
ORDER BY  i.Salary*/


/*SELECT i.Salary FROM Instructor i
order by i.Ins_Name
LIMIT 2;*/


SELECT MAX(i.Salary) FROM Instructor i 
union all
SELECT MAX(i.Salary) FROM Instructor i
  WHERE i.Salary NOT IN (SELECT MAX(Salary) FROM Instructor i )



  select  top(2)i.Salary
from Instructor i
order by i.Salary desc

  select* from  Instructor



  declare  @x int=10
  select









 ---day2
 --1.	 Create a view that displays the student's full name, and course name if the student has a grade of more than 50.

 create view stco
as
 select s.St_Fname,s.St_Lname,c.Crs_Name
from Student s, Stud_Course sc, Course c
where  s.St_Id=sc.St_Id and c.Crs_Id = sc.Crs_Id and sc.grade >50

select * from stco


--22.	*** Create an Encrypted view that displays manager names and the topics they teach.
go
 create view  vvv1
 with encryption
 as
select
  t.Top_Name ,i.Ins_Name
from  Instructor i join  Department d on d.Dept_Id=i.Dept_Id
  JOIN Ins_Course ic  on i.Ins_Id =ic.Ins_Id
 join course c on c.Crs_Id = ic.Crs_Id
 join Topic t on t.Top_Id=c.Top_Id 

  
 go

  select* from vvv1




--33.	  Create a view “V1” that displays student data for a student who lives in Alex or Cairo.

--Note: Prevent the users from running the following query 
--Update V1 set st_address=’tanta’ Where st_address=’alex’.
go
 create view v11
as
Select st_id,st_fname,st_address
	from Student
	where st_address='cairo' or  st_address='alex'
	with check option
	go

select * from v1
drop view v1



update  v11
set  st_address ='tanta' where  st_address='alex'










-----------------day4

---2.	 Create a scalar function that takes a date and returns the month name of that date.
----ex: giving the function '2009/5/12' as a parameter will return 'May' *****
go
create function GettNamee1(@date date)
returns varchar(20)
  begin 
        
		 
		declare @name varchar(20)
		select @name=  (month(@date))

		
		return @name
  end 
  go



  select   dbo.GettNamee1('2009/5/12')








  go

  create function GettNamee134(@datee date)
returns varchar(20)
  begin 
        
		 
		declare @namee varchar(20)
		--select @namee=  (month(@datee))
	select       @namee=	(format (@datee, 'MMMM'))

		
		return @namee
  end
  go

    select dbo.GettNamee134('2009/5/12')





	--------------------------procc
	go
alter proc GettNamee1345 @datee varchar(100) ,@namee varchar(5000) output
as
	--declare @namee varchar(5000)
		--select @namee=  (month(@datee))
	select  @namee=	(format (convert(date,@datee), 'MMMM'))


go



declare @nn varchar(5000) 
execute  GettNamee1345 '2009/5/12' ,@nn output
select @nn





---3.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
go

create function t2n2(@x int ,@y int)
returns @t1 table (id int )
as
begin 
      if @x< @y
	  begin
	  while @x<@y
	 begin
	 set @x+=1
	 if(@x=@y)
	break
	 insert into @t1 VALUES(@x)

	     
		 end
      end
  else 
    begin 
	 while @y<@x
	        begin
	 	     set @y+=1
			  if(@y=@x)
		         break
		 	 insert into @t1 VALUES(@y)

	          end
	end
	return
end

	go

	 select* from t2n2(5,10)




	 ------proc
	 

  go
alter proc tt2tt   @x int  ,@y int 
as
select* from t2n2(@x,@y)
go



tt2tt 5  ,10







---4.	 Create a tabled valued function that takes Student No. and returns Department Name with Student full name.
go
alter function getestname( @did int=10)
 returns    @t table (de varchar(30) , sname varchar(60))
as
begin
  if @did = (select  s.St_Id   from Student s where s.St_Id=@did)
	  insert into @t
   select  s.St_Fname+' '+s.St_Lname,d.Dept_Name
	from student s  join   Department  d on  d.Dept_Id=s.Dept_Id
	where s.St_Id=@did

   return
end
go
select * from getestname(1)


go

----proc
  go
create proc stnade   @did int  
as
 select  s.St_Fname+' '+s.St_Lname,d.Dept_Name
from student s  join   Department  d on  d.Dept_Id=s.Dept_Id
where s.St_Id=(select s.St_Id   from Student s where s.St_Id=@did)
go
    
stnade 1

 --5.	Create a scalar function that takes Student ID and returns a message to the user 
---a.	If the first name and Last name are null then display 'First name & last name are null'
---b.	If the first name is null then display 'first name is null'
---c.	If the last name is null then display 'last name is null'
---d.	Else display 'First name & last name are not null'**********

go
alter function GetStudentNam2(@id int)
returns varchar(60)
as
 begin 
  declare @n3 varchar(60) 
      declare @n varchar(60)
	  select  @n= s.St_Fname from Student s where s.St_Id=@id
	  
	   declare @n2 varchar(60)
	   select  @n2= s.St_Lname from Student s where s.St_Id=@id

	   if (@n is null and @n2 is null)
	   set @n3 ='First name & last name are null'
	   else if (@n is null )
	   set @n3 ='First name'
	   else if  ( @n2 is null)
	   set @n3 ='last name are null'
	    else   
	   set @n3 ='last name and the second is exeet null'
	  
	  
	   
	  return @n3

 end
 go
  select dbo.GetStudentNam2(1)

 go


 ------proc
 alter proc stnadenull   @did int  ,@n3 varchar(1000) output
as
 
      declare @n varchar(60)
	  select  @n= s.St_Fname from Student s where s.St_Id=@did
	  
	   declare @n2 varchar(60)
	   select  @n2= s.St_Lname from Student s where s.St_Id=@did

	   if (@n is null and @n2 is null)
	   set @n3 ='First name & last name are null'
	   else if (@n is null )
	   set @n3 ='First name'
	   else if  ( @n2 is null)
	   set @n3 ='last name are null'
	    else   
	   set @n3 ='last name and the second is exeet null'


	   go
 declare @c varchar(100) 
execute stnadenull  1 , @c output
select @c

go

go
---6.	Create a function that takes an integer that represents the format of the Manager's hiring date and displays
--e department name, Manager Name, and hiring date with this format.  ex: giving the function 100 as a parameter will return the date like ‘Jan 1 2000’ or any other type of format.
 go
 alter function GettName12(@date int)
returns table
as
return
  ( 
        
		 
 select  format (d.Manager_hiredate, 'dddd:MMMM-yyyy') as ss,d.Dept_Name
from   Department d 
where d.Dept_Id=@date
 
  
  )
  go

  --select format (.Manager_hiredate, 'dddd:MMMM-yyyy')

 

  select* from GettName12(10)

  select* from Department



  --------proc
  go
 alter proc ssnn1  @did int
 as
  declare @name varchar(100)  , @form varchar(100)   
  
select  format (d.Manager_hiredate, 'dddd:MMMM-yyyy') ,d.Dept_Name
from   Department d 
where d.Dept_Id=@did


go

ssnn1 10

go

---7.	Create multi-statements table-valued function that takes a string as a parameter
--a.	If string='first name' returns the student's first name 
---b.	If string='last name' returns the student's last name 
---c.	If string='full name' returns Full Name from student table 
---Note: try  “ISNULL” function
go
alter function GetStudentNam33(@ename varchar(60))
returns @t table ( eename varchar(1000), eename2 varchar(1000))
as
 begin 
  
      declare @n varchar(60),@n2 varchar(60),@n0 varchar(60),@n3 varchar(60)

	  select  @n3='the name nt'
	  if  EXISTS (select   s.St_Fname from Student s where s.St_Id=(select Student.St_Id from Student where Student.St_Fname=@ename))
	   begin
	 insert into @t(eename) select   s.St_Fname from Student s where s.St_Id=(select Student.St_Id from Student where Student.St_Fname=@ename)
	 end
	 else if EXISTS (select s.St_Lname from Student s where s.St_Id=(select Student.St_Id from Student where Student.St_Lname=@ename) )
	 begin
	insert into @t(eename2)  select  s.St_Lname from Student s where s.St_Id=(select Student.St_Id from Student where Student.St_Lname=@ename)
	end
	else if EXISTS ( select s.St_Fname+''+s.St_Lname from Student s where s.St_Id=(select Student.St_Id from Student where Student.St_Lname=@ename))
	begin
   insert into @t(eename,eename2)   select s.St_Fname,s.St_Lname from Student s where s.St_Id=(select Student.St_Id from Student where Student.St_Lname=@ename)
   end
 else 
insert into @t   select eename=@n3
	  return 
	  end
	  go

	  select* from GetStudentNam33('hassan')
	  go
	 select* from Student


	 -----proc
	  --alter proc ssnn1  @did int
-- as





---8.	Write a query that returns the Student No and Student first name without the last char

go
select  substring(s.St_Fname,1,len(s.St_Fname)-1)as ss,s.St_Id
from  student s
go


----proc 
go
create proc ssname  @did int
as
select  substring(s.St_Fname,1,len(s.St_Fname)-1)as ss,s.St_Id
from  student s
where s.St_Id=@did

go
ssname 1

go


---9.	 Write a query that takes the columns list and table name into variables and then returns the result of this query “Use execute function”

--declare @col varchar(10) ='Ins_Name' , @tab varchar(10)='instructor'
--select @col from @tab


declare @col varchar(10) ='Ins_Name' , @tab varchar(10)='instructor'
execute('select '+@col+' from '+ @tab)

----proc
go
create proc exc  @col varchar(10) ='Ins_Name' , @tab varchar(10)='instructor'
as
execute('select '+@col+' from '+ @tab)
go

exc
go


--------------------------------------day5


--1.	 Create a stored procedure to show the number of students per department.[use ITI DB]

go
 create proc Stdnum
as 
select count(s.St_Id), d.Dept_Name
from student s inner join Department d
on s.Dept_Id= d.Dept_Id
group by  d.Dept_Name

go

 execute Stdnum
---2.	Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]. “Print a message
--for the user to tell him that he can’t insert a new record in that table--”.

go
create trigger t6
on [Department]
instead of  insert 
as
select 'can’t insert a new record in that table' 


go

insert into [Department] ([Department].Dept_Id) values(71)





---88.	 Create a trigger on the student table after inserting to add a row in the Student Audit table (Server User Name, Date, Note)
--where the note will be “[username] Inserted New row with Key=[Key Value] ***
-- in table [table name]”.[use ITI DB] ****



create table historyinsertion3
(
studen_id int,
name varchar(50),
datee date,
notee varchar(500)
)
go

create  trigger tt1
on student 
after insert
as
begin
declare @note1 int
select  @note1 =St_Id from inserted
insert into historyinsertion3 values(@note1, SUSER_NAME() , GETDATE(),SUSER_NAME()+' '+'insertad new row with '
+CONVERT(varchar(20),@note1)+' '+'in table students')
end

go

insert into student(student.St_Id) values(1300)
go
select * from historyinsertion3

select * from student



--9.	 Create a trigger on the student table to prevent deleting and instead add a row in the Student 
--Audit table (Server User Name, Date, Note) where the note will be “[username] tried to delete a row with Key=[Key Value]”.
--[use ITI DB]
create table historyinsertion4
(
studen_id int,
name varchar(50),
datee date,
notee varchar(500)

)
go

 alter  trigger tt2
on student 
after delete
as
begin
declare @note int
select  @note =St_Id from deleted
insert into historyinsertion4 values(@note, SUSER_NAME() , GETDATE(),SUSER_NAME()+''+'deleted new row with '
+CONVERT(varchar(20),@note)+''+'in table students')
end

go

DELETE FROM student   WHERE student.Dept_Id=23
go
select* from historyinsertion4

--------------------------------------------------
--------------------------------------------------
create table historyinsertion60
(
name varchar(50),
datee date,
notee varchar(500)
)
go

 create  trigger tt23
on student 
instead of  delete
as
begin
declare @id int
select  @id =St_Id from deleted
insert into historyinsertion60 values(SUSER_NAME() , GETDATE(),SUSER_NAME()+' '+'deleted new row with '+CONVERT(varchar(20),@id)+' '+'in table students')
end

go

DELETE FROM student   WHERE student.Dept_Id=23
go
select* from historyinsertion60
go
select* from student



----------------day6
--1.	using one of the Ranking Functions
--1.1.	  Write a query to rank the students according to their ages in each dept without gapping in ranking.use ITI

select st_fname,st_age,Dept_Id,ROW_NUMBER() over(PARTITION BY Dept_Id order by st_age desc) as "order by age"
from student s


--1.2.	Write a query to select the highest two salaries-all ones, not the first
--highest two salaries- for instructors in Each Department who have salaries.use ITI
select*
from( select i.salary, i.Dept_Id,i.Ins_Name, ROW_NUMBER() over(PARTITION BY Dept_Id order by i.salary desc) as rk 
from Instructor i
where  salary is not null ) as l
WHERE rk<=2;
-------------

SELECT *
FROM (
	  SELECT *, ROW_NUMBER() OVER(PARTITION BY i.Dept_id ORDER BY i.Salary desc) AS rk
      FROM Instructor i
      ) 
      AS NewTable
WHERE rk<=2;




------
---3 Create an index on column (Hiredate) that allow u to cluster the data in the table Department use ITI. What will happen?


create  clustered index iii on Department(Manager_hiredate )

create  nonclustered index ii on Department(Manager_hiredate )

--4.	Create an index that allows u to enter unique ages in the student table. What will happen?

 create  unique clustered index  ss on student(st_age )
 create  nonclustered index  sss on student(st_age )

 ----------------

 --5.	Create a non-clustered index on column(Dept_Manager) that allows you to enter
 --a unique instructor id in the table Department. What will happen?

 create  unique clustered index  dms on Department(Dept_Manager )

 create  nonclustered index  dms on Department(Dept_Manager )





 --6.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding”
 go
 create view vvv12
 with schemabinding

as
   select i.Ins_Name , i.Dept_Id 
   from dbo.Instructor i join dbo.Department d
   on  i.Dept_Id=d.Dept_Id 
   where Dept_Name in('SD','Java')

   go

--create  nonclustered index  vii on vvv1(Ins_Name,Dept_Id )

go
drop view vvv1
go
select * from vvv1 --with (NOExpand) 
 where  Dept_Name in('SD','Java')
 go




 -----------------------------------day7

 --1.	use ITI. find the count of times that Ahmed appears Khalid after Khalid in the st_Fname column



declare cc cursor
for
select St_Fname 
from student

for read only
 declare @stf varchar(30),@count int =0
open cc
fetch cc into @stf
while @@FETCH_STATUS = 0
begin
if(@stf = 'khaled')
begin
fetch cc into @stf
if(@stf = 'ahmed')
    set @count+=1
	end
fetch cc into @stf 
  end
 select @count
close cc
deallocate cc


-------
--2.	Try to display all students' first names in one cell separated by a comma. Using Cursor 

select St_Fname  --[Ahmed , Amr , Mona , 
   from Student


declare c1 cursor
for 
    select St_Fname  
   from Student
   where St_Fname is not null

   for read only

declare @name varchar(20) , @AllNames varchar(500) = ''

open c1
fetch c1 into @name 

while @@FETCH_STATUS = 0
  begin 
     set @AllNames = @AllNames +' , ' + @name  
	 fetch c1 into @name 
  end
  select @AllNames
close c1
deallocate c1


------
u

--EXEC sp_configure 'clr enabled', 1;
--RECONFIGURE;
--EXEC sp_configure 'clr strict security', 0; 
--RECONFIGURE;

EXEC sp_configure 'show advanced options', 1 
RECONFIGURE; 
EXEC sp_configure 'clr strict security', 0; 
RECONFIGURE;


--4.	Create a SQL CLR function that takesa character and returns the number of occurrences in 
--the students' first name in ITI DB--number of occurrences in the students' first name in ITI DB
go
declare @n varchar(100),@t varchar(100)='A'
select @n=s.St_Fname from  [dbo].[Student] s  where s.St_Id=1
select  [ITI].[dbo].[counchar](@n,@t)  as re

select @n

go

--5.	Create a SQL CLR function that takes a department manager‘s hire date with a specific id
--and returns neither was it leap year or not.use company DB
go
use Company_SD

go
declare @c date
select @c= [MGRStart Date]  from[dbo].[Departments]   where [dbo].[Departments].MGRSSN =968574

select  [Company_SD].[dbo].[leap](@c) as res

go
go







