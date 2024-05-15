drop database if exists hospital_m_s;

create database hospital_m_s;
use hospital_m_s;

drop table if exists admin;
drop table if exists doctor;
drop table if exists pharmacy;
drop table if exists nurse;
drop table if exists registration;
drop table if exists patient;
drop table if exists rooms;
drop table if exists receptionist;
drop table if exists bill;
drop table if exists laboratory;

create table admin(
admin_id int(5) primary key,
pass varchar(10),
name varchar(15),
gender varchar(7),
email_id varchar(20),
phone_no int(10),
cabin int(5),
salary int(10),
address varchar(40)
);

create table doctor(
doc_id int(5) primary key,
pass varchar(10),
name varchar(15),
gender varchar(7),
dept varchar(7),
specialization varchar(10),
cabin int(5),
phone_no int(10),
personal_address varchar(40)
);

create table pharmacy(
med_bill_no int(5) primary key,
patient_name varchar(15),
amt decimal(10,2)
);


create table nurse(
nurse_id int(5) primary key,
pass varchar(10),
name varchar(15),
gender varchar(7),
location varchar(10),
salary int(10),
email_id varchar(20),
phone_no int(10),
personal_address varchar(40)
);

create table registration(
Date date,
service_dept varchar(20),
problem varchar(40)
);

create table rooms(
roomno int(5) primary key,
location varchar(10)
);

create table patient(
patient_id int(5) primary key,
pass varchar(7),
patient_name varchar(15),
phone_no int(10),
patient_address varchar(40),
age int(3),
gender varchar(7),
roomno int(5),
patient_type varchar(10),
foreign key(roomno) references rooms(roomno)
);


create table receptionist(
reception_id int(5) primary key,
pass varchar(7),
name varchar(15),
gender varchar(7),
salary int(7),
email_id varchar(20),
phone_no varchar(10),
personal_address varchar(40)
);

create table bill(
bill_no varchar(5) primary key,
patient_name varchar(15),
amt decimal(10,2)
);

create table laboratory(
technician_id int(5) primary key,
pass varchar(7),
name varchar(20),
gender varchar(7),
location varchar(10),
salary int(10),
email_id varchar(20),
phone_no int(10),
personal_address varchar(40)
);








