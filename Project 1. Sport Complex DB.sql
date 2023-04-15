Create database sports_booking;

use sports_booking;

create table members (
id varchar(255) primary key,
password varchar(200) not null,
email varchar(200) not null,
member_since timestamp not null default now(),
payment_due decimal(4,2) not null default 0
);

create table  pending_terminations (
id varchar(255) primary key,
email varchar(200) not null, 
request_date timestamp default now(),
payment_due decimal(4,2) not null default 0
);

create table rooms (
id varchar(255) primary key,
room_type varchar(200) not null, 
price decimal(6,2) not null
);

create table bookings (
Id int auto_increment primary key,
room_id varchar(255) not null,
booked_date date not null,
booked_time time not null,
member_id varchar(255) not null,
datetime_of_booking timestamp default now() not null,
payment_status varchar(100) default 'Unpaid' not null,
constraint uc1 unique (room_id, booked_date, booked_time)
);
 
Alter table bookings 
Add constraint fk1 foreign key(member_id) references members(Id) on update cascade on delete cascade,
Add constraint fk2 foreign key(room_id) references rooms(id) on update cascade on delete cascade;

insert into members values 
('afeil', 'feil1988<3', 'Abdul.Feil@hotmail.com', '2017-04-15 12:10:13', 0),
('amely_18', 'loseweightin18', 'Amely.Bauch91@yahoo.com', '2018-02-06 16:48:43', 0),
('bbahringer', 'iambeau17', 'Beaulah_Bahringer@yahoo.com', '2017-12-28 05:36:50', 0),
('little31', 'whocares31', 'Anthony_Little31@gmail.com', '2017-06-01 21:12:11', 10),
('macejkovic73', 'jadajeda12', 'Jada.Macejkovic73@gmail.com', '2017-05-30 17:30:22', 0),
('marvin1', 'if0909mar', 'Marvin_Schulist@gmail.com', '2017-09-09 02:30:49', 10),
('nitzsche77', 'bret77@#', 'Bret_Nitzsche77@gmail.com', '2018-01-09 17:36:49', 0),
('noah51', '18Oct1976#51', 'Noah51@gmail.com', '2017-12-16 22:59:46', 0),
('oreillys', 'reallycool#1', 'Martine_OReilly@yahoo.com', '2017-10-12 05:39:20', 0),
('wyattgreat', 'wyatt111', 'Wyatt_Wisozk2@gmail.com', '2017-07-18 16:28:35', 0);

select * from members;

insert into rooms values 
('AR', 'Archery Range', 120),
('B1', 'Badminton Court', 8), 
('B2', 'Badminton Court', 8), 
('MPF1', 'Multi Purpose Field', 50), 
('MPF2', 'Multi Purpose Field', 60), 
('T1', 'Tennis Court', 10), 
('T2', 'Tennis Court', 10);

select * from rooms;

insert into bookings values
(1, 'AR', '2017-12-26', '13:00:00', 'oreillys', '2017-12-20 20:31:27', 'Paid'),
(2, 'MPF1', '2017-12-30', '17:00:00', 'noah51', '2017-12-22 05:22:10', 'Paid'),
(3, 'T2', '2017-12-31', '16:00:00', 'macejkovic73', '2017-12-28 18:14:23', 'Paid'),
(4, 'T1', '2018-03-05', '08:00:00', 'little31', '2018-02-22 20:19:17', 'Unpaid'),
(5, 'MPF2', '2018-03-02', '11:00:00', 'marvin1', '2018-03-01 16:13:45', 'Paid'),
(6, 'B1', '2018-03-28', '16:00:00', 'marvin1', '2018-03-23 22:46:36', 'Paid'),
(7, 'B1', '2018-04-15', '14:00:00', 'macejkovic73', '2018-04-12 22:23:20', 'Cancelled'),
(8, 'T2', '2018-04-23', '13:00:00', 'macejkovic73', '2018-04-19 10:49:00', 'Cancelled'),
(9, 'T1', '2018-05-25', '10:00:00', 'marvin1', '2018-05-21 11:20:46', 'Unpaid'),
(10, 'B2', '2018-06-12', '15:00:00', 'bbahringer', '2018-05-30 14:40:23', 'Paid');

select * from bookings;

#view

create view booking_details as 
select rooms.id, rooms.room_type, bookings.booked_date, bookings.booked_time, bookings.member_id, 
bookings.datetime_of_booking, rooms.price, bookings.payment_status from bookings join rooms on bookings.room_id = rooms.id
order by bookings.id;

select * from  booking_details


#--------------Stored Procedure-------------------------------------------------------------------

-- 1.The first stored procedure is for inserting a new member into the members table.

Delimiter $$
create procedure insert_new_member(in P_id varchar(255), in P_password varchar(255), in P_email varchar(255))
begin
insert into members (id, password, email) values (P_id, P_Password, P_email);
end $$
delimiter ;


Alter table members add column age int;

-- 2.this procedure is for deleting a member from the members table.

Delimiter $$
create procedure delete_member(in P_id varchar(255))
begin 
delete from members where id = P_id;
end $$
delimiter ;

-- 3. Next, we’ll code two stored procedures to help us update data in the members table --update_member_password and update_member_email

Delimiter $$
create procedure update_member_password(in P_id varchar(200), in P_Password varchar(200))
begin
update members set password = P_Password where id = P_id;
end $$
Delimiter ;

Delimiter $$
create procedure update_member_email(in P_id varchar(200), in P_email varchar(200))
begin
update members set password = P_email where id = P_id;
end $$
Delimiter ;

-- 4.The make_booking procedure is for making a new booking. 

Delimiter $$
create procedure make_booking(in p_room_id varchar(255) , in p_booked_date date, in p_booked_time time, in p_member_id varchar(255))
begin
declare v_price decimal(6,2);
declare v_payment_due decimal(6,2);
select price into v_price from rooms where id = p_room_id;
insert into bookings (room_id, booked_date, booked_time, member_id) values (p_room_id, p_booked_date, p_booked_time, p_member_id);
select payment_due into v_payment_due from members where id = p_member_id;
update members set payment_due = v_payment_due + v_price where id = p_member_id;
end $$ 
delimiter ;

-- 5. update_payment procedure.

Delimiter $$
create procedure update_payment(in P_id varchar(255))
begin 
declare v_member_id varchar(100);
declare v_payment_due decimal(6,2);
declare v_price decimal (6,2);
update bookings set payment_status = 'paid' where id = P_id;
SELECT member_id, price INTO v_member_id, v_price FROM bookings WHERE id = p_id;
SELECT payment_due INTO v_payment_due FROM members WHERE id = v_member_id;
UPDATE members SET payment_due = v_payment_due - v_price WHERE id = v_member_id;
end $$
delimiter ;
drop procedure update_payment
-- 6. CREATE PROCEDURE view_bookings 

Delimiter $$
create procedure booking_details(in p_id VARCHAR(255))
begin
select * from booking_details where id = p_id;
end $$
delimiter ;

-- .7 Create procedure_Search_room
delimiter $$
CREATE PROCEDURE search_room (IN p_room_type VARCHAR(255), IN
p_booked_date DATE, IN p_booked_time TIME)
BEGIN
SELECT * FROM rooms WHERE id NOT IN (SELECT room_id FROM bookings 
WHERE booked_date = p_booked_date AND booked_time = p_booked_time AND payment_status != 'Cancelled') 
AND room_type = p_room_type;
END $$

-- 8. Create Procedure  cancel_booking

Delimiter $$

CREATE PROCEDURE cancel_booking (IN p_booking_id INT, OUT
p_message VARCHAR(255))
BEGIN
DECLARE v_cancellation INT;
DECLARE v_member_id VARCHAR(255);
DECLARE v_payment_status VARCHAR(255);
DECLARE v_booked_date DATE;
DECLARE v_price DECIMAL(6, 2);
DECLARE v_payment_due VARCHAR(255);
SET v_cancellation = 0;
SELECT member_id, booked_date, price, payment_status INTO v_member_id, v_booked_date, v_price, v_payment_status FROM
member_bookings WHERE id = p_booking_id;
SELECT payment_due INTO v_payment_due FROM members WHERE id = v_member_id;
IF curdate() >= v_booked_date THEN SELECT 'Cancellation cannot be done on/after the booked date' INTO p_message;
ELSEIF v_payment_status = 'Cancelled' OR v_payment_status = 'Paid' THEN
SELECT 'Booking has already been cancelled or paid' INTO p_message;
ELSE
UPDATE bookings SET payment_status = 'Cancelled' WHERE id = p_booking_id;
SET v_payment_due = v_payment_due - v_price;
SET v_cancellation = check_cancellation (p_booking_id);
IF v_cancellation >= 2 THEN SET v_payment_due = v_payment_due + 10;
END IF;
UPDATE members SET payment_due = v_payment_due
WHERE id = v_member_id;
SELECT 'Booking Cancelled' INTO p_message;
END IF;
END $$

-- ------------------------ Trigger-----------------------------------------
Delimiter $$
Create Trigger payment_check before delete on members for each row 
begin
DECLARE v_payment_due DECIMAL(6, 2);
select payment_due into v_payment_due from members where id = old.id;
If v_payment_due > 0 then
insert into pending_terminations(id, email, payment_due) values (old.id, old.email, old.payment_due);
end if;
end $$
Delimiter ;

-- --------------------------------------Create Procedure----------------------------------
Delimiter $$
CREATE FUNCTION check_cancellation (p_booking_id INT) RETURNS INT
DETERMINISTIC
BEGIN
DECLARE v_done INT;
DECLARE v_cancellation INT;
DECLARE v_current_payment_status VARCHAR(255);
DECLARE cur CURSOR FOR
SELECT payment_status FROM bookings WHERE member_id =(SELECT member_id FROM bookings WHERE id = p_booking_id) ORDER BY
datetime_of_booking DESC;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
SET v_done = 0;
SET v_cancellation = 0;
OPEN cur;
cancellation_loop : LOOP
FETCH cur INTO v_current_payment_status;
IF v_current_payment_status != 'Cancelled' OR v_done = 1 THEN LEAVE cancellation_loop;
ELSE SET v_cancellation = v_cancellation + 1;
END IF;
END LOOP;
CLOSE cur;
RETURN v_cancellation;
END $$
DELIMITER ;

-- -------------------------------------------------Testing the Dataset--------------------------

SELECT * FROM members;
SELECT * FROM pending_terminations;
SELECT * FROM bookings;
SELECT * FROM rooms;

CALL insert_new_member ('angelolott', '1234abcd', 'AngeloNLott@gmail.com');

SELECT * FROM members ORDER BY member_since DESC;

CALL delete_member ('afeil');
CALL delete_member ('little31');

SELECT * FROM members;
SELECT * FROM pending_terminations;

CALL update_member_password ('noah51', '18Oct1976');
CALL update_member_email ('noah51', 'noah51@hotmail.com');
SELECT * FROM members;

SELECT * FROM members WHERE id = 'marvin1';
SELECT * FROM bookings WHERE member_id = 'marvin1';

CALL update_payment (9);
SELECT * FROM members WHERE id = 'marvin1';
SELECT * FROM bookings WHERE member_id = 'marvin1';

CALL search_room('Archery Range', '2017-12-26', '13:00:00');
CALL search_room('Badminton Court', '2018-04-15', '14:00:00');
CALL search_room('Badminton Court', '2018-06-12', '15:00:00');
CALL make_booking ('AR', '2017-12-26', '13:00:00', 'noah51');

CALL make_booking ('T1', CURDATE() + INTERVAL 2 WEEK, '11:00:00', 'noah51');
CALL make_booking ('AR', CURDATE() + INTERVAL 2 WEEK, '11:00:00', 'macejkovic73');
SELECT * FROM bookings;

