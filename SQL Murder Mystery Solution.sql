-- Exploring the Database Structure

SELECT name 
  FROM sqlite_master
 WHERE type = 'table'

-- Retriving Crime Scene Report

SELECT *
  FROM crime_scene_report
   WHERE type LIKE 'murder'
   AND date = 20180115
   AND city LIKE 'SQL City';

-- List of Potential Witness 

SELECT id, name, address_street_name
  FROM person
 WHERE address_street_name LIKE 'Northwestern Dr'
    OR name LIKE 'Annabel%' AND address_street_name LIKE 'Franklin Ave';

-- Identify where the crime took place

SELECT fb.person_id, fb.event_name, fb.date, p.name
  FROM facebook_event_checkin AS fb
  JOIN person AS p
    ON fb.person_id = p.id
 WHERE p.id = 16371;

SELECT fb.person_id, fb.event_name, fb.date, p.name, p.address_street_name
  FROM facebook_event_checkin AS fb
  JOIN person AS p
    ON fb.person_id = p.id
 WHERE event_name LIKE 'The Funky Grooves Tour'; -- Identify the list of people at the crime scene

/* Two witnesses are Annabel Miller & Morty Schapiro */ 
 
-- Testimonies from Witnesses

SELECT I.person_id, I.transcript, p.name, p.address_street_name
  FROM interview AS I
  JOIN person AS P
    ON I.person_id = p.id  
 WHERE p.id = 14887
    OR p.id = 16371;
	
-- List of Gold Gym Membership Members

SELECT gf.id, gf.person_id, gf.name, gf.membership_status 
  FROM get_fit_now_member AS gf
  JOIN person AS p
    ON gf.person_id = p.id
 WHERE gf.id LIKE '48Z%'
   AND gf.membership_status = 'gold';
   
-- List of Male Drivers with plate numbers with H42W

SELECT dl.gender, dl.plate_number, p.id, p.name, p.address_street_name
  FROM drivers_license AS dl
  JOIN person AS p
    ON dl.id = p.license_id
 WHERE dl.plate_number LIKE '%H42W%'
   AND dl.gender = 'male';
 
 -- List of gym members who checked in on Jan 9th
 
 SELECT c.membership_id, c.check_in_date, gf.person_id, p.name
   FROM get_fit_now_check_in AS c
   JOIN get_fit_now_member AS gf
     ON c.membership_id = gf.id
   JOIN person AS p
     ON gf.person_id = p.id
  WHERE c.check_in_date = 20180109
   AND gf.id LIKE '48Z%'
   AND gf.membership_status = 'gold'
    OR p.name LIKE 'Annabel Miller';
	
-- Identifying the murderer
	
INSERT INTO solution VALUES (1, 'Jeremy Bowers');

SELECT value 
  FROM solution;

-- Murderer Transcript Interview

SELECT i.person_id, i.transcript, p.name
  FROM interview AS i
  JOIN person AS p
    ON i.person_id = p.id 
 WHERE p.id = '67318';
 
-- Identifying the real murderer

SELECT p.id, dl.height, dl.hair_color, dl.car_make, dl.car_model, p.name, p.ssn
  FROM drivers_license AS dl
  JOIN person AS p
    ON dl.id = p.license_id
 WHERE dl.gender LIKE 'female'
   AND dl.car_model = 'Model S'
   AND dl.hair_color LIKE 'red'
   AND dl.car_make = 'Tesla';
 
SELECT person_id, event_name, COUNT(person_id) 
  FROM facebook_event_checkin
 WHERE event_name LIKE 'SQL Symphony Concert'
   AND date BETWEEN 20171201 AND 20171231
 GROUP BY person_id
HAVING COUNT(person_id) = 3;
  
-- Real murderer solution
  
INSERT INTO solution VALUES (1, 'Miranda Priestly');

SELECT value 
  FROM solution;


  
