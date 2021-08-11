-----------------------------------------------------------------
--Creating and Analysing Doctors DATABASE 
--Author : amandineteagho11@gmail.com
--Last Modified:-
-----------------------------------------------------------------
--notes:
--SQL, SQLite
-----------------------------------------------------------------
-------------------------------------------------------------
--creating tables statement: https://www.sqlite.org/lang_createtable.html

--------------------------------------------------------------
drop table if exists works_in;
drop table if exists wards;
drop table if exists doctors;
drop table if exists depends;

--first table
create table if not exists doctors(
	coded   int,
	named    text,
	speciald text,
    --primary key
	CONSTRAINT pk_doctors PRIMARY KEY  (coded)	
	
);

--second table with foreign key

create table if not exists wards(
	codew  int,
	namew  text,
	coded  int,
    --primary key
	CONSTRAINT pk_wards PRIMARY KEY  (codew)
	CONSTRAINT fk_wards_doctors FOREIGN KEY (coded) REFERENCES doctors  (Coded)
);



--table with a date
create table if not exists works_in(
	coded  int,
	codew  int,
	codewi  int,
	datewi  text,
	hourcount  int,
    --primary key
	CONSTRAINT pk_works_in PRIMARY KEY  (coded, codew, codewi)
	CONSTRAINT fk_works_in_doctors FOREIGN KEY (coded) REFERENCES doctors  (Coded)
	CONSTRAINT fk_works_in_wards FOREIGN KEY (codew) REFERENCES doctors  (Codew)
);


create table if not exists depends(
	codew_parent  int,
	codew_child  int,
    --primary key
	CONSTRAINT pk_depends PRIMARY KEY  (codew_parent,codew_child)
	CONSTRAINT fk_depends_wards_p FOREIGN KEY (codew_parent) REFERENCES doctors  (codew)
	CONSTRAINT fk_depends_wards_c FOREIGN KEY (codew_child) REFERENCES doctors  (codew)
);



--inserting lines

insert into doctors(coded, named, speciald) values (1,"Dr. A", "surgery");
insert into doctors(coded, named, speciald) values (2, "Dr. B", "generalist");
insert into doctors(coded, named, speciald) values (3, "Dr. C" , "generalist");

insert into wards(coded, namew, coded) values (1,"Emergency" , 1);
insert into wards(coded, namew, coded) values (2, "Cardiology", 3);

--verifying that the insertions worked
select d.* from doctors d;     --to print the whole list of doctors in doctors
select w.codew, w.namew, w.codew, d.named
	from wards w, doctors d
	where w.coded = d.coded;


select w.* from wards w;



--to manage upper and lower case, use core function
--https://www.sqlite.org/lang_corefunc.html

--deleting a line used in a foreign key
delete from doctors where lower(named) = 'dr. C';    --delete in wards and doctors tables
------>SQLite deletes 2 lines [the wards and the doctor )

--testing the date format

insert into works_in(coded, codew, datewi, hourcount) values (1,1,strftime('%Y-%m-%d','2018-01-02'), 8 );
insert into works_in(coded, codew, datewi, hourcount) values (2,1,strftime('%Y-%m-%d','2018-01-02'), 9);
insert into works_in(coded, codew, datewi, hourcount) values (3,2,strftime('%Y-%m-%d','2018-01-02'),6 );


--verifying that the insertions worked
 select d.coded, d.named, sum(wi.hourcount) as totalhours
	from  doctors d, works_in wi
	where d.coded = wi.coded
	group by d.named;

	
--query the data dictionary
--first possibility
pragma table_info(doctors);	

--using sqlit_master table
select sm.name from sqlite_master sm
    where   sm.type = 'table';
--what is inside sqlite_master
 select sm.* from sqlite_master sm;
 --unreadable
 select sm.type, sm.name from sqlite_master sm;
 
 
--exporting a table to a csv file
--using internal commands that start  by "."
--enable table header display
.headers on 
--import/export mode
.mode csv
--output path
.output doctors.csv
--write the queries
select d.coded, d.named, d.speciald from doctors d;
--exit sqlite
.quit
 