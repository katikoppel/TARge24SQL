-- 1tund 26.02.25
-- loome db
create database TARge24

--db valimine
use TARge24

--db kustutamine
drop database TARge24

--2tund 05.03.2025

--tabeli loomine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'Male')
insert into Gender (Id, Gender)
values(1, 'Female'),
(3, 'Unknown')

--vaatame tabeli andmeid
select * from Gender

create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

--andmete sisestamine
insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'c@c.com', 1),
(6, 'Antman', 'ant"ant.com', 2),
(8, NULL, NULL, 2)

select * from Person

--võõtvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

-- kui sisestad uue rea andmeid ja ei ole sisestanud GenderId alla väärtust, siis 
-- see automaatselt sisestab sellele reale väärtuse 3 nagu meil on unknown
alter table Person
add constraint DF_Person_GenderId
default 3 for GenderId

select * from Person

insert into Person (Id, Name, Email)
values (7, 'Spiderman', 'spider@s.com')

--piirangu kustutamine
alter table Person
drop constraint DF_Person_GenderId

--lisame veeru
alter table Person
add Age nvarchar(10)

--lisame nr piirangu vanuse siestamisel
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

--rea kustutamine
delete from Person where Id = 8

select * from Person

--kuidas uuendada andmeid
update Person
set Age = 19
where Id = 7

select * from Person

--lisame veeru juurde
alter table Person
add City nvarchar(50)

--kõik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
--kõik, kes ei ela Gothamis
select * from Person where City != 'Gotham'
select * from Person where City <> 'Gotham'

--näitab teatud vanusega olevaid inimesi
select * from Person where Age = 100 or Age = 45 or Age = 19
select * from Person where Age in (100, 45, 19)

--näitab teatud vanusevahemikus olevaid inimesi
select * from Person where Age between 27 and 31

--wildcard e näitab kõik g-tähega linnad
select * from Person where City like 'g%'
select * from Person where City like '%g%'

--näitab kõiki, kellel ei ole @-märki emailis
select * from Person where Email not like '%@%'

--näitab kõiki, kellel on emailis ees ja peale @-märki ainult üks täht
select * from Person where Email like '_@_.com'

--kõik, kellel nimes ei ole esimene täht W, A, S
select * from Person where Name Like '[^WAS]%'
select * from Person

--kõik, kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

--kõik, kes elavad välja toodud linnades ja on nooremad
--kui 30 a
select * from Person where City in ('Gotham', 'New York') 
and Age < 30

--kuvab tähestikulises järjekorras inimesi ja võtab aluseks nime
select * from Person order by Name
--kuvab vastupidises järjestuses
select * from Person order by Name desc

--võtab kolm esimest rida
select TOP 3 * from Person

--kolm esimest, aga tabeli järjestus on Age ja siis Name
select top 3 Age, Name from Person

--3. tund 12.03.2025

--näita esimesed 50% tabelis
select top 50 percent * from Person

--järjestab vanuse järgi isikud
--see päring ei järjesta numbreid õigesti kuna Age on nvarchar
select * from Person order by Age desc

--castime Age int andmetüübiks ja siis järjestab õigesti
select * from Person order by CAST(Age as Int)

--kõikide isikute koondvanus
select sum(cast(Age as int)) as [Total Age] from Person

--kõige noorem isik
select min(cast(Age as int)) from Person
--kõige vanem isik
select max(cast(Age as int)) from Person

--näeme konkreetsetes linnades olevate isikute koondvanust
--enne oli Age nvarchar, aga enne päringut muudame selle int-iks
select City, sum(Age) as TotalAge from Person group by City

--nüüd muudame muutuja andmetüüpi koodiga
alter table Person
alter column Name nvarchar(25)

--- kuvab esimeses reas välja toodud järjestuses ja kuvab Age-i TotalAge-ks
--- järjestab City-s olevate nimede järgi ja siis GenderId järgi
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId order by City

---näitab, mitu rida on selles tabelis
select count(*) from Person
select * from Person

--näitab tulemust, et mitu inimest on GenderId väärtusega 2 konkreetses linnas
--veel arvutab vanuse kokku
select City, GenderId, sum(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
from Person
where GenderId = '2'
group by GenderId, City

insert into Person values
(10, 'Black Panther', 'b@b.com', 2, 34, 'New York')

---näitab ära inimeste koondvanuse, kelle vanus on vähemalt 29 a
--kui palju neid igas linnas elab
select GenderId, City, sum(Age) as TotalAge, count(Id)
as [Total Person(s)]
from Person
group by GenderId, City having sum(Age) > 29


--loome tabelid Employees ja Department
create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (1, 'Tom', 'Male', '4000', 1),
(2, 'Pam', 'Female', '3000', 3),
(3, 'John', 'Male', '3500', 1),
(4, 'Sam', 'Male', '4500', 2),
(5, 'Todd', 'Male', '2800', 2),
(6, 'Ben', 'Male', '7000', 1),
(7, 'Sara', 'Female', '4800', 3),
(8, 'Valarie', 'Female', '5500', 1),
(9, 'James', 'Male', '6500', NULL),
(10, 'Russell', 'Male', '8800', NULL)

insert into Department (Id, DepartmentName, Location, DepartmentHead)
values (1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')

select * from Department
select * from Employees

--left join
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

--arvutab kõikide palgad kokku
select sum(cast(Salary As Int)) from Employees
--kõige väiksema palgasaaja palk
select min(cast(Salary As Int)) from Employees
--ühe kuu palgafond linnade lõikes
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.Id
group by Location

alter table Employees
add City nvarchar(30)

--sooline eripära palkade osas
select City, Gender, sum(cast(Salary as int)) as TotalSalary from Employees
group by City, Gender
--sama nagu eelmine, aga linnad on tähestikulises järjekorras
select City, Gender, sum(cast(Salary as int)) as TotalSalary from Employees
group by City, Gender 
order by City

--loeb ära , mitu rida andmeid on tabelis,
--* asemele võib panna ka muid veergude nimetusi
select count(DepartmentId) from Employees

--mitu töötajat on soo ja linna kaupa selles tabelis
select Gender, City,
count (Id) as [Total Employee(s)]
from Employees
group by Gender, City

--näitab kõik mehed linnade kaupa
select Gender, City,
count (Id) as [Total Employee(s)]
from Employees
where Gender = 'Male'
group by Gender, City

--näitab kõik naised linnade kaupa
select Gender, City,
count (Id) as [Total Employee(s)]
from Employees
group by Gender, City
having Gender = 'Female'

--kelle palk on vähemalt üle 4000
select * from Employees where Salary > 4000

--kõigil, kellel on palk üle 4000 ja arvutab need kokku ning näitab soo kaupa
select Gender, City, sum(cast(Salary as int)) as TotalSalary, count (Id) as [Total Employee(s)]
from Employees
group by Gender, City
having sum(cast(Salary as int)) > 4000

--loome tabeli, milles hakatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)
insert into Test1 values('X')
select * from Test1

--kustutage ära City veerg Employees tabelist
alter table Employees
drop column City

--inner join
--kuvab neid, kellel on DepartmentName all olemas väärtus
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--left join
--kuidas saada kõik andmed Employees tabelist kätte
select Name, Gender, Salary, DepartmentName
from Employees
left join Department --võib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

--right join
--kuidas saada DepartmentName alla uus nimetus e antud juhul Other Department
select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id

--full outer join
--kuidas saada kõikide tabelite väärtused ühte päringusse
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department
on Employees.DepartmentId = Department.Id

--cross join võtab kaks allpool olevat tabelit kokku ja korrutab need omavahel läbi
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department

--päringu sisuce loogika
select ColumnList
from LeftTable
joinType RightTable
on JoinCondition

--4.tund 19.03.2025
--kuidas kuvada ainult need isikud, kellel on DepartmentName NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department 
on Employees.DepartmentId = Department.Id 
where Employees.DepartmentId is NULL

--kuidas saame Department tabelis oleva rea, kus on NULL
select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null


--full join
--mõlema tabeli mitte-kattuvate väärtustega read kuvab välja
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.Id is null

--saame muuta tabeli nimetust, alguses vana tabeli nimi ja siis uus soovitud 
sp_rename 'Department123', 'Department'

--teeme left join-i, aga Employees tabeli nimetus on lühendina: E
select E.Name as Employee, M.Name as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

alter table Employees
add ManagerId int

--inner join
--kuvab ainult ManagerId all olevate isikute väärtuseid
select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--cross join
--kõik saavad kõikide ülemused olla
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M

select isnull('Kati', 'No Manager') as Manager

--NULL asemel kuvab No Manager
select coalesce(NULL, 'No Manager') as Manager

---neil, kellel ei ole ülemust, siis paneb neile No Manager teksti
select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--teeme päringu, kus kasutame case-i
select E.Name as Employee, case when M.Name is null then 'No Manager'
else M.Name end as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--lisame tabelisse uued veerud
alter table Employees
add MiddleName nvarchar(30)
alter table Employees
add LastName nvarchar(30)

--muudame veeru nime
sp_rename 'Employees.Name', 'FirstName'

--uuendame andmed
update Employees
set FirstName = 'Tom', MiddleName = 'Nick', LastName = 'Jones'
where Id = 1

update Employees
set FirstName = 'Pam', LastName = 'Anderson'
where Id = 2

update Employees
set FirstName = 'John'
where Id = 3

update Employees
set FirstName = 'Sam', LastName = 'Smith'
where Id = 4

update Employees
set FirstName = NULL, MiddleName = 'Todd', LastName = 'Someone'
where Id = 5

update Employees
set FirstName = 'Ben', MiddleName = 'Ten', LastName = 'Sven'
where Id = 6

update Employees
set FirstName = 'Sara', LastName = 'Connor'
where Id = 7

update Employees
set FirstName = 'Valarie', MiddleName = 'Balerine'
where Id = 8

update Employees
set FirstName = 'James', MiddleName = '007', LastName = 'Bond'
where Id = 9

update Employees
set FirstName = NULL, LastName = 'Crowe'
where Id = 10

select * from Employees

--igast reast võtab esimesena täidetud lahtri ja kuvab ainult seda
select Id, coalesce(FirstName, MiddleName, LastName) as Name 
from Employees

--loome kaks tabelit juurde
create table IndianCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

--sisestame tabelisse andmeid
insert into IndianCustomers (Name, Email)
values ('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers

--kasutame union all - see näitab kõiki ridu
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers

--korduvate väärtustega read pannakse ühte ja ei korrata
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers

--kasuta union all ja sorteeri nime järgi
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers
order by Name

--stored procedure
create procedure spGetEmployees
as begin
	select FirstName, Gender from Employees
end

--kutsuda stored procedure esile
spGetEmployees
exec spGetEmployees
execute spGetEmployees

create proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

--kutsume selle sp esile ja selle puhul tuleb sisestada parameetrid
spGetEmployeesByGenderAndDepartment 'Male', 1

--niimoodi saab sp tahetud järjekorrast mööda minna, kui ise paned muutujad paika
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'Male'

--saab sp sisu vaadata result vaates
sp_helptext spGetEmployeesByGenderAndDepartment

--kuidas muuta sp-d ja võti peale panna, et keegi teine peale teie ei saaks muuta
alter proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
with encryption --paneb võtme peale
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

sp_helptext spGetEmployeesByGenderAndDepartment

--sp tegemine
create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
	select @EmployeeCount = count(Id) from Employees where Gender = @Gender
end

--annab tulemuse, kus loendab ära nõuetele vastavad read
--prindib ka tulemuse kirja teel
declare @TotalCount int
execute spGetEmployeeCountByGender 'Female', @TotalCount out
if(@TotalCount = 0)
	print '@TotalCount is null'
else
	print '@Total is not null'
print @TotalCount


--näitab ära, et mitu rida vastab nõuetele
declare @TotalCount int
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Male'
print @TotalCount

--sp sisu vaatamine
sp_help spGetEmployeeCountByGender
--tabeli info
sp_help Employees
--kui soovid sp teksti näha
sp_helptext spGetEmployeeCountByGender

--millest sõltub see sp
sp_depends spGetEmployeeCountByGender
--vaatame tabeli sõltuvust
sp_depends Employees

--
create proc spGetNameById
@Id int,
@Name nvarchar(20) output
as begin
	select @Id = Id, @Name = FirstName from Employees
end
--veateadet ei näita, aga tulemust ka ei ole
spGetNameById 1, 'Tom'

--töötav variant
declare @FirstName nvarchar(20)
execute spGetNameById 1, @Firstname output
print 'Name of the employee = ' + @FirstName

--uus sp
create proc spGetNameById1
@Id int,
@Name nvarchar(20) output
as begin
	select @Id = Id, @Name = FirstName from Employees where Id = @Id
end

declare @FirstName nvarchar(20)
execute spGetNameById1 1, @Firstname output
print 'Name of the employee = ' + @FirstName

--5 tund 26.03.2025

declare
@FirstName nvarchar(20)
execute spGetNameById1 1, @FirstName out
print 'Name = ' + @FirstName

create proc spGetNameById2
@Id int
as begin
	return (select FirstName from Employees where Id = @Id)
end


--tuleb veateade, kuna kutsusime valja int-i, aga Tom on string
declare @EmployeeName nvarchar(50)
execute @EmployeeName = spGetNameById2 1
print 'Name of the employee = ' + @EmployeeName

--sisseehitatud string funktsioonid
--see konverteerib ASCII tahe vaartuse numbriks
select ASCII('a')
--kuvab A-tahe 
select char(65)

--prindime kogu tahestiku valja
declare @Start int
set @Start = 97
while (@Start <= 122)
begin 
	select char (@Start)
	set @Start = @Start + 1
end

---eemaldame tuhjad kohad sulgudes vasakult poolt
select ltrim('            Hello')

select * from Employees

--tuhikute eemaldamine veerust
select ltrim(FirstName) as [First Name], MiddleName, LastName from Employees

--paremalt poolt eemaldab tuhjad stringid
select rtrim('     Hello              --                ')

--- 5 tund 26.03.2025

declare 
@FirstName nvarchar(20)
execute spGetNameById1 1, @FirstName out
print 'Name = ' + @FirstName

create proc spGetnameById2
@Id int 
as begin
	return (select FirstName from Employees where Id = @Id)
end

-- tuleb veateade kuna kutsusime v'lja int-i, aga Tom on string
declare @EmployeeName nvarchar(50)
execute @EmployeeName = spGetNameById2 1
print 'Name of the employee = ' + @EmployeeName

-- sisseehitatud string funktsioonid
-- see konverteerib ASCII tähe väärtuse numbriks
select ASCII('a')
-- kuvab A-tähe
select char(65)

---prindime kogu tähestiku välja
declare @Start int
set @Start = 97
while (@Start <= 122)
begin 
	select char (@Start)
	set @Start = @Start + 1
end

---eemaldame tühjad kohad sulgudes vasakult poolt
select ltrim('             Hello')

select * from Employees

--tühikute eemaldamine veerust
select LTRIM(FirstName) as [First Name], MiddleName, LastName from Employees

---paremalt poolt eemaldab tühjad stringid
select rtrim('    Hello     --      ')

-- 6 tund 02.04.2025

--keerab kooloni sees olevad andmed vastupidiseks
--vastavalt upper ja lower-ga saan muuta märkide suurust
--reverse funktsioon pöörab kõik ümber
select REVERSE(upper(ltrim(FirstName))) as [First Name], MiddleName, lower(LastName) as LastName,
RTRIM(LTRIM(FirstName)) + ' ' + MiddleName + ' ' + LastName as FullName
from Employees

--näitab, et mitu tähte on sõnal ja loeb tühikud sisse
select FirstName, len(FirstName) as [Total Characters] from Employees
--eemaldame t[hikud ja ei loe sisse ????
select FirstName, len(ltrim(FirstName)) as [Total Characters] from Employees
select * from Employees

--left, right ja substring
--vasakult poolt neli esimest tähte
select LEFT('ABCDEF', 4)
--paremalt poolt kolm tähte
select RIGHT('ABCDEF', 3)

--kuvab @-tähemärgi asetust
select CHARINDEX('@', 'sara@aaa.com')

--esimene nr peale komakohta näitab, et mitmendast alustab 
--ja siis mitu nr peale seda kuvada
select SUBSTRING('pam@bbb.com', 4, 4)

--- @-märgist kuvab kom tähemärki. Viimase nr saab määrata pikkust
select substring('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 1, 2)

--peale @-märki reguleerib tähemärkide pikkuse näitamist
select substring('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 1, 
len('pam@bbb.com') - charindex('@', 'pam@bbb.com')) 


alter table Employees
add Email nvarchar(20)

select * from Employees

update Employees set Email = 'Tom@aaa.com' where Id = 1
update Employees set Email = 'Pam@bbb.com' where Id = 2
update Employees set Email = 'John@aaa.com' where Id = 3
update Employees set Email = 'Sam@bbb.com' where Id = 4
update Employees set Email = 'Todd@bbb.com' where Id = 5
update Employees set Email = 'Ben@ccc.com' where Id = 6
update Employees set Email = 'Sara@ccc.com' where Id = 7
update Employees set Email = 'Valarie@aaa.com' where Id = 8
update Employees set Email = 'James@bbb.com' where Id = 9
update Employees set Email = 'Russel@bbb.com' where Id = 10

---tahame teada saada domeeninimed emailides
select SUBSTRING(Email, CHARINDEX('@', Email) + 1,
len(Email) - charindex('@', Email)) as EmailDomain
from Employees

--lisame *-märgi alates teatud kohast
select FirstName, LastName,
	SUBSTRING(Email, 1, 2) + REPLICATE('*', 5) + --peale teist tähemärki paneb viis tärni
	SUBSTRING(Email, CHARINDEX('@', Email), len(Email) - CHARINDEX('@', Email)+1) as Email --kuni @-märgini on dünaamiline
from Employees

---kolm korda näitab stringis olevat väärtust
select REPLICATE('asd', 3)

-- kuidas sisestada tühikut kahe nime vahele
select space(5)

--tühikute arv kahe nime vahel
select FirstName + space(20) + LastName as FullName
from Employees

--PATINDEX
--sama, mis charindex, aga dünaamilisem ja saab kasutada wildcardi
select Email, PATINDEX('%@aaa.com', Email) as FirstOccurence
from Employees
where PATINDEX('%@aaa.com', Email) > 0 ---leian kõik selle domeeni esindajad ja
-- alates mitmendast märgist algab @

--- kõik .com-d asendatakse .net-ga
select Email, REPLACE(Email, '.com', '.net') as ConvertedEmail
from Employees

--soovin asendada peale esimest märki kolm tähte viie tärniga
--peate kasutama stuff-i
select FirstName, LastName, Email,
	stuff(Email, 2, 3, '*****') as StuffedEmail
from Employees

---- ajaühikute tabel
create table DateTime
(
c_time time,
c_date date,
c_smalldatetime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

select * from DateTime

---konkreetse masina kellaaeg
select GETDATE(), 'GETDATE()'

insert into DateTime
values (getdate(), getdate(), getdate(), getdate(), getdate(), getdate())

--muudame tabeli andmeid
update DateTime set c_datetimeoffset = '2025-04-02 14:06:17.0566667 +10:00'
where c_datetimeoffset = '2025-04-02 14:06:17.0566667 +00:00'

select CURRENT_TIMESTAMP, 'CURRENT TIMESTAMP' -- aja päring
-- leida veel kolm aja päringut
select SYSDATETIME(), 'SYSDATETIME' --natuke täpsem aja päring
select SYSDATETIMEOFFSET(), 'SYSDATETIMEOFFSET' --täpne aeg koos ajalise nihkega UTC suhtes
select GETUTCDATE(), 'GETUTCDATE' --utc aeg

---
select isdate('asd') --tagastab 0 kuna string ei ole date
select isdate(GETDATE()) --tagastab 1 kuna on aeg
select isdate('2025-04-02 14:06:17.0566667') --tagastab 0 kuna max 3 numbrit peale koma tohib olla
select isdate('2025-04-02 14:06:17.056') --tagastab 1
select day(getdate()) -- annab tänase päeva nr
select day('01/31/2025')-- annab stringis oleva kp ja järjestus peab olema õige
select month(getdate()) -- annab jooksva kuu arvu
select month('01/31/2025') --annab stringis oleva kuu nr
select year(getdate()) -- annab jooksva aasta arvu
select year('01/31/2025') --annab stringis oleva aasta nr

create table EmployeesWithDates
(
	Id nvarchar(2),
	Name nvarchar(20),
	DateOfBirth datetime
)

INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (1, 'Sam', '1980-12-30 00:00:00.000');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (2, 'Pam', '1982-09-01 12:02:36.260');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (3, 'John', '1985-08-22 12:03:30.370');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (4, 'Sara', '1979-11-29 12:59:30.670');

--- kuidas võtta ühest veerust andmeid ja selle abil luua uued veerud
select Name, DateOfBirth, DATENAME(WEEKDAY, DateOfBirth) as [Day], --vt DoB veerust päeva ja kuvab päeva nimetuse s]nana
	MONTH(DateOfBirth) as MonthNumber,  -- vt DoB veerust kp-d ja kuvab kuu nr
	DATENAME(Month, DateOfBirth) as [MonthName], -- vt DoB veerust kp-d ja kuvab kuu sõnana
	Year(DateOfBirth) as [Year] -- võtab DoB veerust aasta
from EmployeesWithDates

-- tund 7 09.04.25
select DATEPART(WEEKDAY, '2025-01-29 12:59:30.670') --näitab nelja kuna USA nädal algab pühapaevaga
select DATEPART(month, '2025-01-29 12:59:30.670')
select dateadd(day, 20, '2025-01-29 12:59:30.670') --liidab stringis olevale kp-le 20 päeva juurde
select dateadd(day, -20, '2025-01-29 12:59:30.670') --lahutab 20 päeva maha
select datediff(month, '11/30/2024', '01/30/2024') --kuvab kahe stringi vahel olevat kuudevahelist aega
select datediff(year, '11/30/2020', '01/30/2025') --kuvab kahe stringi vahel olevat aastatevahelist aega

create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
	declare @tempdate datetime, @years int, @months int, @days int
		select @tempdate = @DOB

		select @years = datediff(year, @tempdate, getdate()) - case when (month(@DOB) > month(getdate())) or (month(@DOB)
		= MONTH(getdate()) and day(@DOB) > day(getdate())) then 1 else 0 end
		select @tempdate = dateadd(year, @years, @tempdate)

		select @months = datediff(month, @tempdate, getdate()) - case when day(@DOB) > day(getdate()) then 1 else 0 end
		select @tempdate = dateadd(month, @months, @tempdate)

		select @days = datediff(day, @tempdate, getdate())

	declare @Age nvarchar(50)
		set @Age = cast(@years as nvarchar(4)) + ' Years ' + cast(@months as nvarchar(2)) + ' Months ' + cast(@days as nvarchar(2)) + 
		' Days old'
	return @Age
end

--saame vaadata kasutajate vanust
select Id, Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age 
from EmployeesWithDates

--kui kasutame seda funktsiooni, 
--siis saame teada tänase paeva vahet stringis valja tooduga
select DBO.fnComputeAge('11/30/2010')

--number peale DOB muutujat naitab, kuidas kuvada DOB-d
select Id, Name, DateOfBirth, 
convert(nvarchar, DateOfBirth, 104) as ConvertedDOB
from EmployeesWithDates

select Id, Name, Name + ' - ' + cast(Id as nvarchar) as [Name-Id]
from EmployeesWithDates

select cast(getdate() as date) --tänane kp
select convert(date, getdate()) --tänane kp

---matemaatilised funktsioonid
select abs(-101.5) --abs on absoluutväärtus ja miinus võetakse ära
select ceiling(15.2) --ümardab suurema täisarvu poole
select ceiling(-15.2) --tulemus on -15 ja suurendab positiivse täisarvu poole
select floor(15.2) --ümardab väiksema täisarvu poole
select floor(-15.2) --ümardab väiksema täisarvu poole
select power(2, 4) --2 astmes 4
select square(9) --antud juhul 9 ruudus
select sqrt(81) --ruutjuur, annab vastuse 9

select rand() --annab suvalise nr
select floor(rand() * 100) --korrutab 100-ga iga suvalise nr

--iga kord näitab 10 suvalist numbrit
declare @Counter int
set @Counter = 1
while (@Counter <= 10)
	begin
		print floor(rand() * 10)
		set @Counter = @Counter + 1
	end

select round(850.556, 2) --ümardab 2 kohta peale koma, tulemus on 850.560
select round(850.556, 2, 1) --ümardab allapoole, tulemus 850.550
select round(850.556, 1) --ümardab 1 koha peale koma
select round(850.556, 1, 1) --ümardab allapoole
select round(850.556, -2) --ümardab täisarvu üles
select round(850.556, -1) --ümardab täisarvu alla

---
create function dbo.CalculateAge(@DOB date)
returns int
as begin
declare @Age int

set @Age = datediff(year, @DOB, GETDATE()) - 
	case
		when (month(@DOB) > month(getdate())) or
			(month(@DOB) > month(getdate()) and day(@DOB) > day(getdate()))
			then 1
			else 0
			end
		return @Age
end

exec CalculateAge '08/14/2010'

--arvutab välja, kui vana on isik ja võtab arvesse kuud ja päevad
--antud juhul näitab kõike, kes on üle 36 a vanad
select Id, Name, dbo.CalculateAge(DateOfBirth) as Age from EmployeesWithDates
where dbo.CalculateAge(DateOfBirth) > 42

--inline table valued functions
alter table  EmployeesWithDates
add DepartmentId int
alter table  EmployeesWithDates
add Gender nvarchar(10)

select * from EmployeesWithDates

INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (5, 'Todd', '1978-11-29 12:59:30.670');

--scalare function annab mingis vahemikus olevaid andmeid, aga 
--inline table values ei kasuta begin ja neid funktsioone
--scalar annab väärtused ja inline annab tabeli

create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table
as
return (select Id, Name, DateOfBirth, DepartmentId, Gender
		from EmployeesWithDates
		where Gender = @Gender)

--kõik naissoost töötajad
select * from fn_EmployeesByGender('female')

select * from fn_EmployeesByGender('female')
where Name = 'Pam'

select * from Department

select Name, Gender, DepartmentName
from fn_EmployeesByGender('male') E
join Department D on D.Id = E.DepartmentId

--inline funktsioon 
create function fn_GetEmployees()
returns table as
return (select Id, Name, cast(DateOfBirth as date)
		as DOB
		from EmployeesWithDates)

select * from fn_GetEmployees()

--teha multi-state funktsioon
--peab defineerima uue tabeli veerud koos muutujatega
--Id int, Name nvarchar(20), DOB date
--funktsiooni nimi on fn_MS_getEmployees()
create function fn_MS_GetEmployees()
returns @Table Table(Id int, name nvarchar(20), DOB date)
as begin
    insert into @Table
    select Id, Name, cast(DateOfBirth as date) from EmployeesWithDates
    return
end

select * from fn_MS_getEmployees()

update fn_GetEmployees() set Name = 'Sam1' where Id = 1 --saab muuta andmeid
update fn_MS_GetEmployees() set Name = 'Sam 1' where Id = 1 --ei saa muuta andmeid multistate puhul

--deterministic ja non-deterministic 
select count(*) from EmployeesWithDates
select square(3) --kõik tehtemärgid on deterministic funktsioonid,
--sinna kuuluvad veel sum, avg ja square

--non-deterministic
select getdate()
select CURRENT_TIMESTAMP
select rand() --see funktsioon saab olla mõlemas kategoorias, kõik oleneb sellest
--kas sulgudes on 1 või ei ole midagi

--loome funktsiooni
create function fn_GetNameById(@id int)
returns nvarchar(30)
as begin
	return(select Name from EmployeesWithDates where Id = @id)
end

select dbo.fn_GetNameById(1)

alter function fn_getEmployeeNameById(@Id int)
returns nvarchar(20)
with encryption
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end

--muudame ülevalpool olevat funktsiooni
--Kindlasti tabeli ette panna dbo.TabeliNimi
alter function dbo.fn_getEmployeeNameById(@Id int)
returns nvarchar(20)
with schemabinding
as begin
	return (select Name from dbo.EmployeesWithDates where Id = @Id)
end

--ei saa kustutada tabeleid ilma funktsiooni kustutamata
drop table dbo.EmployeesWithDates

---temporary tables 

--- #-märgi ette panemisel saame aru, et tegemist on temp tabeliga
-- seda tabelit saab ainult selles päringus avada
create table #PersonDetails(Id int, Name nvarchar(20))

insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'John')
insert into #PersonDetails values(3, 'Todd')

select * from #PersonDetails

select Name from sysobjects
where Name like '#PersonDetails%'

--kustuta temp tabel
drop table #PersonDetails

create proc spCreateLocalTempTable
as begin
create table #PersonDetails(Id int, Name nvarchar(20))

insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'John')
insert into #PersonDetails values(3, 'Todd')

select * from #PersonDetails
end

exec spCreateLocalTempTable

--globaalse temp tabeli tegemine
create table ##PersonDetails(Id int, Name nvarchar(20))

--Erinevused lokaalse ja globaalse ajutise tabeli osas:
--1. Lokaalsed ajutised tabelid on ühe #-märgiga,
--aga globaalsel on 2 tükki.
--2. SQL server lisab suvalisi numbreid lokaalse ajutise tabeli nimesse, 
--aga globaalse puhul seda ei ole.
--3. Lokaalsed on nähtavad ainult selles sessioonis,
--mis on selle loonud, aga globaalsed on nähtavad kõikides sessioonides.
--4.Lokaalsed ajutised tabelid on automaatselt kustutatud,
--kui selle loonud sessioon on kinni pandud,
--aga globaalsed ajutised tabelid lõpetatakse alles
--peale viimase ühenduse lõpetamist.

--8. tund 16.04.2025

--index
create table EmployeeWithSalary
(
Id int primary key,
Name nvarchar(35),
Salary int,
Gender nvarchar(10)
)

insert into EmployeeWithSalary (Id, Name, Salary, Gender)
values (1, 'Sam', 2500, 'Male'),
(2, 'Pam', 6500, 'Female'),
(3, 'John', 4500, 'Male'),
(4, 'Sara', 5500, 'Female'),
(5, 'Todd', 3100, 'Male')

--Miks indeksid?
--Indekseid kasutatakse päringute tegemisel, mis annavad meile kiiresti andmeid.
--Indekseid luuakse tabelites ja vaadetes. Indeks tabelis või vaates on samasugune raamatu indeksile.

--Kui raamatus ei oleks indeksit ja tahaksin leida üles konkreetse peatüki,
--siis sa peaksid kogu raamatu läbi vaatama.

--Kui indeks on olemas, siis vaatad peatüki lk numbrit ja liigud vastavale lk-le.

--Raamatuindeks aitab oluliselt kiiremini üles leida vajaliku peatüki.
--Sama teevad ka tabeli ja vaate indeksid serveris.

--Õigete indeksite eksisteerimine lühendab oluliselt päringu tulemust.
--Kui indeksit ei ole, siis päring teeb kogu tabeli ülevaatuse
--ja seda kutsutakse Table Scan-iks ja see on halb jõudlusele.

select  * from EmployeeWithSalary
where Salary > 5000 and Salary < 7000

--loome indeksi, mis asetab palga kahanevasse järjestusse
create index IX_Employee_Salary
on EmployeeWithSalary (Salary asc)

select * from EmployeeWithSalary

--indeksi kutsumine: IX_Employee_Salary
select * from EmployeeWithSalary
with (index(IX_Employee_Salary))

select Name, Salary from EmployeeWithSalary with(index = IX_Employee_Salary)

--saame teada, et mis on selle tabeli primaarvõti ja index
exec sys.sp_helpindex @objname = 'EmployeeWithSalary'

--saame vaadata tabelit koos selle sisuga alates väga detailsest infost
select
	TableName = t.name,
	IndexName = ind.name,
	IndexId = ind.index_id,
	ColumnId = ic.index_column_id,
	ColumnName = col.name,
	ind.*,
	ic.*,
	col.*
from
	sys.indexes ind
inner join
	sys.index_columns ic on ind.object_id = ic.object_id and ind.index_id = ic.index_id
inner join
	sys.columns col on ic.object_id = col.object_id and ic.column_id = col.column_id
inner join
	sys.tables t on ind.object_id = t.object_id
where
	ind.is_primary_key = 0
	and ind.is_unique = 0
	and ind.is_unique_constraint = 0
	and t.is_ms_shipped = 0
order by 
	t.name, ind.name, ind.index_id, ic.is_included_column, ic.key_ordinal;

--indexi kustutamine
drop index EmployeeWithSalary.IX_Employee_Salary

--Indeksi tüübid:
--1. Klastrites olevad
--2. Mitte-klastris olevad
--3. Unikaalsed
--4. Filtreeritud
--5. XML
--6. Täistekst
--7. Ruumiline
--8. Veerusäilitav
--9. Veergude indeksid
--10. Välja arvatud veergudega indeksid

--klastris olev indeks määrab ära tabelis oleva füüsilise järjestuse
--ja selle tulemusel saab tabelis olla ainult 1 klastris olev indeks

create table EmployeeCity
(
Id int primary key,
Name nvarchar(50),
Salary int,
Gender nvarchar(10),
City nvarchar(50)
)

exec sp_helpindex EmployeeCity

--andmete õige järjestuse loovad klastris olevad indeksid ja kasutab selleks nr-t
--põhjuseks Id kasutamisel tuleneb selle primaarvõtmest
insert into EmployeeCity values(3, 'John', 4500, 'Male', 'New York')
insert into EmployeeCity values(1, 'Sam', 2500, 'Male', 'London')
insert into EmployeeCity values(4, 'Sara', 5500, 'Female', 'Tokyo')
insert into EmployeeCity values(5, 'Todd', 3100, 'Male', 'Toronto')
insert into EmployeeCity values(2, 'Pam', 6500, 'Male', 'Sydney')

--klastris olevad indeksid dikteerivad säilitatud andmete järjestuse tabelis
--ja seda saab klastrite puhul olla ainult üks

select * from EmployeeCity

create clustered index IX_EmployeeCity_Name
on EmployeeCity(Name)
--annab veateate, et tabelis saab olla ainult üks klastris olev indeks,
--kui soovid uut indeksit luua, siis kustuta olemasolev

--saame luue ainult ühe klastris oleva indeksi tabeli peale
--klastris olev indeks on analoogne telefoni suunakoodile

--loome composite indeksi
--enne tuleb kõik teised klastris olevad indeksid ära kustutada
create clustered index IX_Employee_Gender_Salary
on EmployeeCity(Gender desc, Salary asc)

--kui teed select päringu sellele tabelile, siis peaksid nägema andmeid,
--mis on järjestatud selliselt:
--Esimeseks võetake aluseks Gender veerg kahanevas järjestuses
--ja siis Salary veerg tõusvas järjestuses
select * from EmployeeCity

--mitte klastris olev index
create nonclustered index IX_EmployeeCity_Name
on EmployeeCity(Name)
--teeme päringu tabelile
select * from EmployeeCity

--erinevused kahe indeksi vahel
--1. ainult üks klastris olev indeks saab olla tabeli peale,
--mitte-klastris olevaid indekseid saab olla mitu
--2. klastris olevad indeksid on kiiremad kuna indeks peab tagasi viitama tabelile
--Juhul, kui selekteeritud veerg ei ole olemas indeksis
--3. Klastris olev indeks määratleb ära tabeli ridade salvestusjärjestuse
--ja ei nõua kettal lisa ruumi. Samas mitte klastris olevad indeksid on
--salvestatud tabelist eraldi ja nõuab lisa ruumi.

create table EmployeeFirstName
(
	Id int primary key,
	FirstName nvarchar(50),
	LastName nvarchar(50),
	Salary int,
	Gender nvarchar(10),
	City nvarchar(50)
)

exec sp_helpindex EmployeeFirstName

--ei saa sisestada kahte samasuguse Id väärtusega rida
insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'John', 'Menco', 2500, 'Male', 'London')

--
drop index EmployeeFirstName.PK__Employee__3214EC076DCE1243
--kui käivitad ülevalpool oleva koodi, siis tuleb veateade
--et SQL server kasutab UNIQUE indeksit jõustamaks väärtuse unikaalsust ja primaarvõtit
--koodiga unikaalseid indekseid ei saa kustutada, aga käsitsi saab

--sisestame uuesti
insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'John', 'Menco', 2500, 'Male', 'London')

--unikaalset indeksit kasutatakse kindlustamaks väärtuste unikaalsust (sh primaarvõti)
create unique nonclustered index UIX_Employee_FirstName_LastName
on EmployeeFirstName(FirstName, LastName)

--tabel tühjaks
truncate table EmployeeFirstName

--lisame uue unikaalse piirangu
alter table EmployeeFirstName
add constraint UQ_EmployeeFirstName_City
unique nonclustered(City)

--ei luba tabelisse väärtusega uut Londonit
insert into EmployeeFirstName values(3, 'John1', 'Menco1', 3000, 'Male', 'London')

--saab vaadata indeksite nimekirja
exec sp_helpconstraint EmployeeFirstName

--1. Vaikimisi primaarvõti loob unikaalse klastris oleva indeksi, samas unikaalne piirang
--loob unikaalse mitte-klastris olevea indeksi
--2. Unikaalset indeksit või piirangut ei saa luua olemasolevasse tabelisse, 
--kui tabel juba sisaldab väärtusi võtmeveerus
--3. Vaikimisi korduvaid väärtuseid ei ole veerus lubatud,
--kui peaks olema unikaalne indeks või piirang. Nt, kui tahad sisestada 10 rida andmeid,
--millest 5 sisaldavad korduvaid andmeid, siis kõik 10 lükatakse tagasi. Kui soovin ainult 5 rea
--tagasi lükkamist ja ülejäänud 5 rea sisestamist, siis selleks kasutatakse IGNORE_DUP_KEY

create unique index IX_EmployeeFirstName 
on EmployeeFirstName(City)
with ignore_dup_key 

insert into EmployeeFirstName values(3, 'John', 'Menco', 3512, 'Male', 'London')
insert into EmployeeFirstName values(4, 'John', 'Menco', 3111, 'Male', 'London1')
insert into EmployeeFirstName values(4, 'John', 'Menco', 3222, 'Male', 'London1')

select * from EmployeeFirstName
--enne ignore käsku oleks kõik kolm rida tagasi lükatud, aga
--nüüd läks keskmine rida läbi kuna linna nimi oli unikaalne

--view
--view on salvestatud SQL-i päring. Saab käsitleda ka virtuaalse tabelina
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

--loome view
create view vEmployeesByDepartment
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

--view päringu esile kutsumine
select * from vEmployeesByDepartment

--view ei salvesta andmeid vaikimisi
--seda tasub võtta, kui salvestatud virtuaalse tabelina

--milleks vaja view-d:
--saab kasutada andmebaasi skeemi keerukuse lihtsustamiseks,
--mitte IT-inimesele
--piiratud ligipääs andmetele, ei näe kõiki veerge

--teeme view, kus näeb ainult IT-töötajaid
--view nimi on vITEmployeesInDepartment
--kasutame tabeleid Employees ja Department
create view vITEmployeesInDepartment
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id
where DepartmentName = 'IT'
--ülevalpool olevcar päringut saab liigitada reataseme turvalisuse alla
--tahan ainult näidata IT osakonna töötajaid
select * from vITEmployeesInDepartment

--veeru taseme turvalisus
--peale selecti määratled veergude näitamise ära
alter view vEmployeesInDepartmentSalaryNoShow
as
select FirstName, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id
--Salary veergu ei näita
select * from vEmployeesInDepartmentSalaryNoShow

--saab kasutada esitlemiseks koondandmeid ja üksikajalikke andmeid
--view, mis tagastab summeeritud andmeid
create view vEmployeesCountByDepartment
as
select DepartmentName, count(Employees.Id) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId =  Department.Id
group by DepartmentName

select * from vEmployeesCountByDepartment

--kui soovid vaadata view sisu
sp_helptext vEmployeesCountByDepartment
--muutmine
alter view vEmployeesCountByDepartment
--kustutamine
drop view vEmployeesCountByDepartment

--view uuendused
update vEmployeesDataExceptSalary
set [FirstName] = 'Tom' where Id = 2

create view vEmployeesDataExceptSalary
as
select Id, FirstName, Gender, DepartmentId
from Employees

--kustutame ja sisestame andmeid
delete from vEmployeesDataExceptSalary where Id = 2
insert into vEmployeesDataExceptSalary (Id, Gender, DepartmentId, FirstName)
values(2, 'Female', 2, 'Pam')

--9 tund 23.04.2025

--indekseeritud view
--MS SQL-is on indekseeritud nime all ja
--Oracle-s kutsutakse materjaliseeritud view-ks

create table Product
(
Id int primary key,
Name nvarchar(20),
UnitPrice int
)

insert into Product values (1, 'Books', 20)
insert into Product values (2, 'Pens', 14)
insert into Product values (3, 'Pencils', 11)
insert into Product values (4, 'Clips', 10)

create table ProductSales
(
Id int,
QuantitySold int
)

insert into ProductSales values (1, 10)
insert into ProductSales values (3, 23)
insert into ProductSales values (4, 21)
insert into ProductSales values (2, 12)
insert into ProductSales values (1, 13)
insert into ProductSales values (3, 12)
insert into ProductSales values (4, 13)
insert into ProductSales values (1, 11)
insert into ProductSales values (2, 12)
insert into ProductSales values (1, 14)

--loome view, mis annab meile veerud TotalSales ja TotalTransaction

create view vTotalSalesByProduct
with schemabinding
as
select Name,
sum(isnull((QuantitySold * UnitPrice), 0)) as TotalSales,
COUNT_BIG(*) as TotalTransactions
from dbo.ProductSales
join dbo.Product
on dbo.Product.Id = dbo.ProductSales.Id
group by Name

--kui soovid luua indeksi view sisse, siis peab järgima teatud reegleid
--1. view tuleb luua koos schemabinding-ga
--2. kui lisafunktsioon select list viitab väljendile ja selle tulemuseks
--võib olla NULL, siis asendusväärtus peaks olema täpsustatud.
--Antud juhul kasutasime ISNULL funktsiooni asendamaks NULL väärtust
--3. kui GroupBy on täpsustatud, siis view select list peab
--sisaldama COUNT_BIG(*) väljendit
--4. Baastabelis peaksid view-d olema viidatud kaheosalise nimega
--ehk antud juhul dbo.Product ja dbo.ProductSales.

select * from vTotalSalesByProduct

create unique clustered index UIX_vTotalSalesByProduct_Name
on vTotalSalesByProduct(Name)
--paneb selle view tähestikulisse järjekorda

--view piirangud

create view vEmployeeDetails
@Gender nvarchar(20)
as 
select Id, FirstName, Gender, DepartmentId
from Employees
where Gender = @Gender
--vaatesse ei saa kaasa panna parameetreid e antud juhul Gender

create function fnEmployeeDetails(@Gender nvarchar(20))
returns table
as return
(select Id, FirstName, Gender, DepartmentId
from Employees where Gender = @Gender)

--funktsiooni esile kutsumine koos parameetriga
select * from fnEmployeeDetails('male')

--order by kasutamine
--tuleb teha view, mille nimeks on vEmployeeDetailsSorted
--order by-s tuleb kasutada Id-d

create view vEmployeeDetailsSorted
as 
select TOP 100 PERCENT Id, FirstName, Gender, DepartmentId
from Employees
order by Id;
--ilma select top 100 percent ei saa kasutada view-s order by-d
select * from vEmployeeDetailsSorted

--temp table kasutamine
create table ##TestTempTable (Id int, FirstName nvarchar(20), Gender nvarchar(10))

insert into ##TestTempTable values(101, 'Martin', 'Male'),
(102, 'Joe', 'Female'),
(103, 'Pam', 'Female'),
(104, 'James', 'Male')

create view vOnTempTable
as
select Id, FirstName, Gender
from ##TestTempTable
--temp table-s ei saa kasutada view-d

--Triggerid

--kokku on kolme tüüpi: DML, DDL, LOGON

--trigger on stored procedure eriliik, mis automaatselt käivitud, kui mingi
--tegevus peaks andmebaasis aset leidma

--DML - data manipulation language
--DML-i põhilised käsklused: insert, update, delete
 
--DML triggereid saab klassifitseerida kahte tüüpi:
--1. After trigger (kutsutakse ka FOR triggeriks)
--2. Instead of trigger (selmet trigger e selle asemel trigger)

--after trigger käivitub peale sündmust, kui kuskil on tehtud insert, update ja delete

create table EmployeeAudit
(
Id int identity(1, 1) primary key,
AuditData nvarchar(1000)
)
--peale iga töötaja sisestamist tahame teada saada töötaja Id-d,
--päeva ja aega(millal sisestati)
--kõik andmed tulevad EmployeeAudit tabelisse

create trigger trEmployeeForInsert
on Employees
for insert
as begin
declare @Id int
select @Id = Id from inserted
insert into EmployeeAudit
values('New employee with Id = ' + cast(@Id as nvarchar(5)) + ' is added at '
+ cast(getdate() as nvarchar(20)))
end

select * from Employees

insert into Employees values
(11, 'Bob', 'Blob', 'Bomb', 'Male', 3000, 1, 3)

select * from EmployeeAudit

--delete trigger 
create trigger trEmployeeForDelete
on Employees
for delete 
as begin
	declare @Id int
	select @Id = Id from deleted

	insert into EmployeeAudit
	values('An existing employee with Id =' + cast(@Id as nvarchar(5)) + ' is deleted at ' 
	+ cast(getdate() as nvarchar(20)))
end

delete from Employees where Id = 11
select * from EmployeeAudit

--update trigger
alter trigger trEmployeeForUpdate
on Employees
for update
as begin
	--muutujate deklareerimine
	declare @Id int
	declare @OldGender nvarchar(20), @NewGender nvarchar(20)
	declare @OldSalary int, @NewSalary int
	declare @OldDepartmentId int, @NewDepartmentId int
	declare @OldManagerId int, @NewManagerId int
	declare @OldFirstName nvarchar(20), @NewFirstName nvarchar(20)
	declare @OldMiddleName nvarchar(20), @NewMiddleName nvarchar(20)
	declare @OldLastName nvarchar(20),@NewLastName nvarchar(20)
	
	--muutuja, kuhu läheb lõpptekst
	declare @AuditString nvarchar(1000)

	--laeb kõik uuendatud andmed temp table alla
	select * into #TempTable
	from inserted

	--kaib läbi kõik andmed temp table-s
	while(exists(select Id from #TempTable))
	begin
		set @AuditString = ''
		--selekteerib esimese rea andmed temp table-st
		select top 1 @Id = Id, @NewGender = Gender,
		@NewSalary = Salary, @NewDepartmentId = DepartmentId,
		@NewManagerId = ManagerId, @NewFirstName = FirstName,
		@NewMiddleName = MiddleName, @NewLastName = LastName
		from #TempTable
		--võtab vanad andmed kustutatud tabelist
		select @OldGender = Gender,
		@OldSalary = Salary, @OldDepartmentId = DepartmentId,
	    @OldManagerId = ManagerId, @OldFirstName = FirstName,
		@OldMiddleName = MiddleName, @OldLastName = LastName
		from deleted where Id = @Id

		--loob audit stringi dünaamiliselt
		set @AuditString = 'Employee with Id = ' + cast(@Id as nvarchar(4)) + ' changed '
		if(@OldGender <> @NewGender)
			set @AuditString = @AuditString + ' Gender from ' + @OldGender + ' to ' +
			@NewGender

		if(@OldSalary <> @NewSalary)
			set @AuditString = @AuditString + ' Salary from ' + cast(@OldSalary as nvarchar(20)) 
			+ ' to ' + cast(@NewSalary as nvarchar(10))

		if(@OldDepartmentId <> @NewDepartmentId)
			set @AuditString = @AuditString + ' DepartmentId from ' + cast(@OldDepartmentId as nvarchar(20)) 
			+ ' to ' + cast(@NewDepartmentId as nvarchar(10))

		if(@OldManagerId <> @NewManagerId)
			set @AuditString = @AuditString + ' ManagerId from ' + cast(@OldManagerId as nvarchar(20)) 
			+ ' to ' + cast(@NewManagerId as nvarchar(10))

		if(@OldFirstName <> @NewFirstName)
			set @AuditString = @AuditString + ' FirstName from ' + @OldFirstName + ' to ' +
			@NewFirstName

		if(@OldMiddleName <> @NewMiddleName)
			set @AuditString = @AuditString + ' MiddleName from ' + @OldMiddleName + ' to ' + 
			@NewMiddleName

		if(@OldLastName <> @NewLastName)
			set @AuditString = @AuditString + ' LastName from ' + @OldLastName + ' to ' +
			@NewLastName

		insert into dbo.EmployeeAudit values (@AuditString)
		--kustutab temp table-st rea, et saaksime liikuda uue rea juurde
		delete from #TempTable where Id = @Id
	end
end

update Employees set FirstName = 'test2', Salary = 4000, MiddleName = 'test6'
where Id = 10

select * from Employees
select * from EmployeeAudit

--instead of trigger
create table Employee
(
Id int primary key,
Name nvarchar(30),
Gender nvarchar(10),
DepartmentId int
)

insert into Employee values(1, 'John', 'Male', 3),
(2, 'Mike', 'Male', 2),
(3, 'Pam', 'Female', 1),
(4, 'Todd', 'Male', 4),
(5, 'Sara', 'Female', 1),
(6, 'Ben', 'Male', 3)

create view vEmployeeDetails
as
select Employee.Id, Name, Gender, DepartmentName
from Employee 
join Department
on Employee.DepartmentId = Department.Id

select * from vEmployeeDetails

insert into vEmployeeDetails values(7, 'Valarie', 'Female', 'IT')
--tuleb veateade
--nüüd vaatame, kuidas saab instead of trigger-ga seda probleemi lahendada

create trigger tr_vEmployeeDetails_InsteadOfInsert
on vEmployeeDetails
instead of insert
as begin
	declare @DeptId int

	select @DeptId = dbo.Department.Id
	from Department
	join inserted
	on inserted.DepartmentName = Department.DepartmentName

	if(@DeptId is null)
		begin
		raiserror('Invalid department name. Statement terminated', 16, 1)
		return
	end

	insert into dbo.Employee(Id, Name, Gender, DepartmentId)
	select Id, Name, Gender, @DeptId
	from inserted
end

--raiserror funktsioon
--selle eesmärk on tuua välja veateade, kui DepartmentName veerus ei ole väärtust
--ja ei klapi uue sisestatud väärtusega.
--Esimene on parameeter on veateate sisu, teine on veataseme nr
--(nr 16 tähendab üldiseid vigu),
--kolmas on olek

--10. tund 30.04.2025
delete from Employee where Id = 6

update vEmployeeDetails
set Name = 'Johny', DepartmentName = 'IT'
where Id = 1
--ei saa uuendada andmeid, sest mitu tabelit on sellest mõjutatud

update vEmployeeDetails
set DepartmentName = 'HR'
where Id = 1

select * from Department

create trigger tr_vEmployeeDetails_InsteadOfUpdate
on vEmployeeDetails
instead of update
as begin

	if(update(Id))
	begin
		raiserror('Id cannot be changed', 16, 1)
		return
	end

	if(update(DepartmentName))
	begin
		declare @DeptId int
		select @DeptId = Department.Id
		from Department
		join inserted
		on inserted.DepartmentName = Department.DepartmentName

		if(@DeptId is null)
		begin
			raiserror('Invalid Department Name', 16, 1)
			return
		end

		update Employee set DepartmentId = @DeptId
		from inserted
		join Employee
		on Employee.Id = inserted.Id
	end

	if(update(Gender))
	begin
		update Employee set Gender = inserted.Gender
		from inserted
		join Employee
		on Employee.Id = inserted.Id
	end

	if(update(Name))
	begin
		update Employee set Name = inserted.Name
		from inserted
		join Employee
		on Employee.Id = inserted.Id
	end
end

update Employee set Name = 'John123', Gender = 'Male', DepartmentId = 3
where Id = 1

select * from vEmployeeDetails

--delete trigger
create view vEmployeeCount
as
select DepartmentId, DepartmentName, count(*) as TotalEmployees
from Employee
join Department
on Employee.DepartmentId = Department.Id
group by DepartmentName, DepartmentId

select * from vEmployeeCount

--tahan näha ainult neid osakondasid, kus on kaks ja rohkem töötajaid
--kasutada vEmployeeCount
select DepartmentName, TotalEmployees from vEmployeeCount
where TotalEmployees >= 2

select DepartmentName, DepartmentId, count(*) as TotalEmployees
into #TempEmployeeCount
from Employee
join Department
on Employee.DepartmentId = Department.Id
group by DepartmentName, DepartmentId

select * from #TempEmployeeCount

select DepartmentName, TotalEmployees
from #TempEmployeeCount
where TotalEmployees >= 2

select * from sys.triggers

create trigger trEmployeeDetails_InsteadOfDelete
on vEmployeeDetails
instead of delete
as begin
	delete Employee
	from Employee
	join deleted
	on Employee.Id = deleted.Id
end

delete from vEmployeeDetails where Id = 2

--päritud tabelid ja CTE
--CTE tähendab common table expression
select * from Employee

update Employee set Name = 'John'
where Id = 1

--CTE
with EmployeeCount(DepartmentName, DepartmentId, TotalEmployees)
as
	(
	select DepartmentName, DepartmentId, count(*) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName, DepartmentId
	)
select DepartmentName, TotalEmployees
from EmployeeCount
where TotalEmployees >= 2

--CTE-d võivad sarnaneda temp table-ga
--sarnane päritud tabelile ja ei ole salvestatud objektina
--ning kestab päringu ulatuses

--päritud tabel
select DepartmentName, TotalEmployees
from 
	(
	select DepartmentName, DepartmentId, count(*) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName, DepartmentId
	)
as EmployeeCount
where TotalEmployees >= 2

--mitu CTE-d järjest
with EmployeeCountBy_Payroll_IT_Dept(DepartmentName, Total)
as
	(
	select DepartmentName, count(Employee.Id) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	where DepartmentName in ('Payroll', 'IT')
	group by DepartmentName
	),
EmployeesCountBy_HR_Admin_Dept(DepartmentName, Total)
as
	(
	select DepartmentName, Count(Employee.Id) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName
	)
--kui on kaks CTE-d, siis unioni abil ühendada päringud
select * from EmployeeCountBy_Payroll_IT_Dept
union
select * from EmployeesCountBy_HR_Admin_Dept

--
with EmployeeCount(DepartmentId, TotalEmployees)
as 
	(
	select DepartmentId, count(*) as TotalEmployees
	from Employee
	group by DepartmentId
	)
--select 'Hello'
--peale CTE-d peab kohe tulema käsklus SELECT, INSERT, UPDATE või DELETE
--kui proovid midagi muud, siis tuleb veateade
select DepartmentName, TotalEmployees
from Department
join EmployeeCount
on Department.Id = EmployeeCount.DepartmentId
order by TotalEmployees

--uuendamine CTE-s
--loome lihtsa CTE
with Employees_Name_Gender
as
	(
	select Id, Name, Gender from Employee
	)
select * from Employees_Name_Gender

--uuendame andmeid läbi CTE
with Employees_Name_Gender
as
	(
	select Id, Name, Gender from Employee
	)
update Employees_Name_Gender set Gender = 'Male' where Id = 1

select * from Employee

--kasutame joini CTE tegemisel
with EmployeesByDepartment
as
	(
	select Employee.Id, Name, Gender, DepartmentName
	from Employee
	join Department
	on Department.Id = Employee.DepartmentId
	)
select * from EmployeesByDepartment

--kasutame joini ja muudame ühes tabelis andmeid
with EmployeesByDepartment
as
	(
	select Employee.Id, Name, Gender, DepartmentName
	from Employee
	join Department
	on Department.Id = Employee.DepartmentId
	)
update EmployeesByDepartment set Name = 'Pam' where Id = 3

select * from Employee

--kasutame joini ja muudame mõlemas tabelis andmeid
with EmployeesByDepartment
as
	(
	select Employee.Id, Name, Gender, DepartmentName
	from Employee
	join Department
	on Department.Id = Employee.DepartmentId
	)
update EmployeesByDepartment set Gender = 'Male', DepartmentName = 'IT' 
where Id = 1
--ei luba mitmes tabelis korraga andmeid muuta

with EmployeesByDepartment
as
	(
	select Employee.Id, Name, Gender, DepartmentName
	from Employee
	join Department
	on Department.Id = Employee.DepartmentId
	)
update EmployeesByDepartment set DepartmentName = 'IT' 
where Id = 1

--kokkuvõte CTE-st
--1. kui CTE baseerub ühel tabelil, siis uuendus töötab
--2. kui CTE baseerub mitmel tabelil, siis tuleb veateade
--3. kui CTE baseerub mitmel tabelil ja tahame muuta ainult ühte tabelit, 
--siis uuendus saab tehtud

--korduv CTE
--CTE, mis iseendale viitab, kutsutakse korduvaks CTE-ks
--kui tahad andmeid näidata hierarhiliselt
truncate table Employee

insert into Employee (Id, Name, ManagerId)
values (1, 'Tom', 2),
(2, 'Josh', null),
(3, 'Mike', 2),
(4, 'John', 3),
(5, 'Pam', 1),
(6, 'Mary', 3),
(7, 'James', 1),
(8, 'Sam', 5),
(9, 'Simon', 1)

--üks võimalus on teha self join
--ja kuvada NULL veeru asemel Super Boss
select Emp.Name as [Employee Name],
ISNULL(Manager.Name, 'Super Boss') as [Manager Name]
from dbo.Employee Emp
left join Employee Manager
on Emp.ManagerId = Manager.Id

---
with EmployeesCTE(Id, Name, ManagerId, [Level])
as
(
	select Employee.Id, Name, ManagerId, 1
	from Employee
	where ManagerId is null

	union all

	select Employee.Id, Employee.Name,
	Employee.ManagerId, EmployeesCTE.[Level] + 1
	from Employee
	join EmployeesCTE
	on Employee.ManagerId = EmployeesCTE.Id
)
select EmpCTE.Name as Employee, ISNULL(MgrCTE.Name, 'Super Boss') as Manager,
EmpCTE.[Level]
from EmployeesCTE EmpCTE
left join EmployeesCTE MgrCTE
on EmpCTE.ManagerId = MgrCTE.Id

--PIVOT 
create table ProductSales
(
SalesAgent nvarchar(50),
SalesCountry nvarchar(50),
SalesAmount int
)

truncate table ProductSales
select * from ProductSales

insert into ProductSales
values('Tom', 'UK', 200),
('John', 'US', 180),
('John', 'UK', 260),
('David', 'India', 450),
('Tom', 'India', 350),
('David', 'US', 200),
('Tom', 'US', 130),
('John', 'India', 540),
('John', 'UK', 120),
('David', 'UK', 220),
('John', 'UK', 420),
('David', 'US', 320),
('Tom', 'US', 340),
('Tom', 'UK', 660),
('John', 'India', 430),
('David', 'India', 230),
('David', 'India', 280),
('Tom', 'UK', 480),
('John', 'UK', 360),
('David', 'UK', 140)

select * from ProductSales

select SalesCountry, SalesAgent, sum(SalesAmount) as Total
from ProductSales
group by SalesCountry, SalesAgent
order by SalesCountry, SalesAgent

--pivot näide
select SalesAgent, India, US, UK
from ProductSales
pivot
(
sum(SalesAmount) for SalesCountry in([India], [US], [UK])
)
as PivotTable

--päring muudab unikaalsete veergude väärtust (India, US ja UK) SalesCountry veerus
--omaette veergudeks koos veergude SalesAmount liitmisega

create table ProductSalesWithId
(
Id int primary key,
SalesAgent nvarchar(50),
SalesCountry nvarchar(50),
SalesAmount int
)

insert into ProductSalesWithId
values(1, 'Tom', 'UK', 200),
(2, 'John', 'US', 180),
(3, 'John', 'UK', 260),
(4, 'David', 'India', 450),
(5, 'Tom', 'India', 350),
(6, 'David', 'US', 200),
(7, 'Tom', 'US', 130),
(8, 'John', 'India', 540),
(9, 'John', 'UK', 120),
(10, 'David', 'UK', 220),
(11, 'John', 'UK', 420),
(12, 'David', 'US', 320),
(13, 'Tom', 'US', 340),
(14, 'Tom', 'UK', 660),
(15, 'John', 'India', 430),
(16, 'David', 'India', 230),
(17, 'David', 'India', 280),
(18, 'Tom', 'UK', 480),
(19, 'John', 'UK', 360),
(20, 'David', 'UK', 140)


---
select SalesAgent, India, US, UK
from ProductSalesWithId
pivot
(
sum(SalesAmount) for SalesCountry in([India], [US], [UK])
)
as PivotTable

--põhjuseks on Id veeru olemasolu ProductSalesWithId, mida võetakse arvesse
--pööramise ja grupeerimise järgi

select SalesAgent, India, US, UK
from 
(
	select SalesAgent, SalesCountry, SalesAmount from ProductSalesWithId
)
as SourceTable
pivot
(
sum(SalesAmount) for SalesCountry in (India, US, UK)
)
as PivotTable

--UNPIVOT
--kasutada ProductSalesWithId
select Id, FromAgentOrCountry, CountryOrAgent 
from 
(
select Id, SalesAgent, SalesCountry
from ProductSalesWithId
) 
as SourceTable
unpivot
(
CountryOrAgent for FromAgentOrCountry in (SalesAgent, SalesCountry)
) 
as PivotTable

--transactions
--transaction jälgib järgmisi samme
--1. selle algus
--2. käivitab DB käske
--3. kontrollib vigu. Kui on viga, siis taastab algse oleku

create table MailingAddress
(
Id int not null primary key,
EmployeeNumber int,
HouseNumber nvarchar(50),
StreetAddress nvarchar(50),
City nvarchar(10),
PostalCode nvarchar(20)
)

insert into MailingAddress
values(1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

create table PhysicalAddress
(
Id int not null primary key,
EmployeeNumber int,
HouseNumber nvarchar(50),
StreetAddress nvarchar(50),
City nvarchar(10),
PostalCode nvarchar(20)
)

insert into PhysicalAddress
values(1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

create procedure spUpdateAddress
as begin
	begin try
		begin transaction
			update MailingAddress set City = 'LONDON'
			where MailingAddress.Id = 1 and EmployeeNumber = 101

			update PhysicalAddress set City = 'LONDON'
			where PhysicalAddress.Id = 1 and EmployeeNumber = 101
		commit transaction
	end try
	begin catch
		rollback tran
	end catch
end

spUpdateAddress

select * from MailingAddress
select * from PhysicalAddress

alter proc spUpdateAddress
as begin
	begin try
		begin transaction
			update MailingAddress set City = 'LONDON 12'
			where MailingAddress.Id = 1 and EmployeeNumber = 101

			update PhysicalAddress set City = 'LONDON LONDON'
			where PhysicalAddress.Id = 1 and EmployeeNumber = 101
		commit transaction
	end try
	begin catch
		rollback tran
	end catch
end

--kui teine uuendus ei lähe läbi, siis esimene ei lähe ka läbi
--kõik uuendused peavad läbi minema