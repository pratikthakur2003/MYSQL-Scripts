drop database if exists portal;
create database portal;
use portal;

drop table if exists evs_tbl_user_credentials;
drop table if exists evs_tbl_user_profile;
drop table if exists evs_tbl_election;
drop table if exists evs_tbl_party;
drop table if exists evs_tbl_candidate;
drop table if exists evs_tbl_application;
drop table if exists evs_tbl_result;
drop table if exists evs_tbl_eo;
drop table if exists evs_tbl_voter_details;

create table evs_tbl_user_credentials
(userid varchar(6) primary key,
password varchar(20) not null,
usertype varchar(1),
loginstatus int(1),
check((usertype = 'A' or usertype='E' or usertype = 'V') and (loginstatus = 0 or loginstatus = 1)));

create table evs_tbl_user_profile
(userid varchar(6),
firstname varchar(15) not null,
lastname varchar(15) not null,
dateofbirth date not null,
gender varchar(7) not null,
street varchar(30) not null,
location varchar(15) not null,
city varchar(15) not null,
state varchar(15) not null,
pincode varchar(10) not null,
mobileno varchar(10) not null,
emailid varchar(30),
foreign key(userid) references evs_tbl_user_credentials(userid),
check(length(mobileno) = 10 and mobileno regexp '^[0-9]+$')
);

create table evs_tbl_election
(electionid varchar(6) primary key,
name varchar(15) not null,
electiondate date not null,
district varchar(15) not null,
constituency varchar(15) not null,
countingdate date not null
);

create table evs_tbl_party
(partyid varchar(6) primary key,
name varchar(20) not null,
leader varchar(20) not null,
symbol varchar(40) not null
);


create table evs_tbl_candidate
(candidateid varchar(6) primary key,
name varchar(20) not null,
electionid varchar(6),
partyid varchar(6),
district varchar(20) not null,
constituency varchar(20) not null,
dateofbirth date not null,
mobileno varchar(10) not null,
address varchar(50) not null,
emailid varchar(20),
foreign key(electionid) references evs_tbl_election(electionid),
foreign key(partyid) references evs_tbl_party(partyid),
check(length(mobileno) = 10 and mobileno regexp '^[0-9]+$')
);

create table evs_tbl_application
(userid varchar(6),
constituency varchar(20) not null,
passedstatus int(2) not null check(passedstatus=1 or passedstatus=2 or passedstatus=3),
approvedstatus int(2) not null check(approvedstatus=0 or approvedstatus=1),
voterid varchar(8) primary key
);

create table evs_tbl_result
(serialno int(6) primary key auto_increment,
electionid varchar(6),
candidateid varchar(6),
votecount int(5) not null,
foreign key(electionid) references evs_tbl_election(electionid),
foreign key(candidateid) references evs_tbl_candidate(candidateid)
);

create table evs_tbl_eo
(electoralofficerid varchar(6) primary key,
constituency varchar(25) not null
);

create table evs_tbl_voter_details
(serialno int(6) primary key auto_increment,
candidateid varchar(6),
electionid varchar(6),
voterid varchar(6),
foreign key(electionid) references evs_tbl_election(electionid),
foreign key(candidateid) references evs_tbl_candidate(candidateid),
foreign key(voterid) references evs_tbl_application(voterid)
);

drop trigger if exists trg_userid;
drop trigger if exists trg_voterid;

delimiter //
create trigger trg_userid
before insert on evs_tbl_user_profile
for each row
begin
declare old_userid varchar(6);
set old_userid = New.userid;
set New.userid = concat(substr(New.firstname,1,2), New.userid);
with tb as (select userid from evs_tbl_user_credentials)
update evs_tbl_user_credentials set userid = New.userid where userid = old_userid;
end //

create trigger trg_voterid
before insert on evs_tbl_application
for each row
begin
set New.voterid = concat(substr(New.userid, 1, 2), substr(New.constituency, 1, 2), New.voterid);
end //

delimiter ;


/*
insert into evs_tbl_user_credentials values('1001','pratik_pwd','A',1);
insert into evs_tbl_user_credentials values('1002','krishna_pwd','E',0);

insert into evs_tbl_user_profile values('1001','Pratik','Thakur','2004-09-06','MALE','LIMDA','PU','SURAT','GUJ','393001','1234567890','pratik@gmail.com');

insert into evs_tbl_user_profile values('1002','Pratik','Thakur','2004-09-06','MALE','LIMDA','PU','SURAT','GUJ','393001','1234567890','pratik@gmail.com');

insert into evs_tbl_application values('Pr1002', 'Bharuch',1,0, 1005);

select * from evs_tbl_user_credentials;
select * from evs_tbl_user_profile;
select * from evs_tbl_application;

*/


