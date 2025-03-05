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

--3. tund 