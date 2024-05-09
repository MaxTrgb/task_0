CREATE TABLE departments (
	id SERIAL PRIMARY KEY NOT NULL,
	building int NOT NULL CHECK (building > 0 AND building < 6),
	name varchar(100) NOT NULL UNIQUE
);

CREATE TABLE wards (
	id SERIAL PRIMARY KEY NOT NULL,
	name varchar(20) NOT NULL UNIQUE,
	places int NOT NULL CHECK (places > 0),
	department_id int NOT NULL,
	
	FOREIGN KEY(department_id) REFERENCES departments(id)
);

CREATE TABLE doctors (
	id SERIAL PRIMARY KEY NOT NULL,	
	name varchar(255) NOT NULL,
	surname varchar(255) NOt NULL,
	salary int NOT NULL CHECK (salary > 0),
	premium int	NOT NULL DEFAULT 0 CHECK (premium >= 0) 
);

CREATE TABLE examinations(
	id SERIAL PRIMARY KEY NOT NULL,	
	name varchar(100) NOT NULL UNIQUE
);

CREATE TABLE doctors_examinations(
	id SERIAL PRIMARY KEY NoT NULL,	
	end_time int NOT NULL CHECK(end_time > start_time),
	start_time int NOT NULL CHECK (start_time >= 8 AND start_time <= 18),
	doctor_id int NOT NULL,
	examination_id int NOT NULL,
	ward_id int NOT NULL,	
	FOREIGN KEY(doctor_id) REFERENCES doctors(id),
	FOREIGN KEY(examination_id) REFERENCES examinations(id),
	FOREIGN KEY(ward_id) REFERENCES wards(id)	
);

INSERT INTO departments(building, name) VALUES
(1, 'emergency'),
(2, 'cardiology'),
(3, 'pediatric'),
(4, 'neurology'),
(5, 'radiology')
;


INSERT INTO wards(name, places, department_id) VALUES
('ward1', 1, 1),
('ward2', 2, 2),
('ward3', 3, 1),
('ward4', 2, 2),
('ward5', 4, 3),
('ward6', 3, 3),
('ward7', 2, 1),
('ward8', 1, 4),
('ward9', 4, 4),
('ward10', 3, 4),
('ward11', 2, 4),
('ward12', 1, 5),
('ward13', 2, 5),
('ward14', 3, 5)
;

INSERT INTO doctors(name, surname, salary, premium) VALUES
('Greg', 'House', 200000, 2000),
('Eric', 'Foreman', 110000, 2000),
('Robert', 'Chase', 100000, 2000),
('Allison', 'Cameron', 120000, 1000),
('Lisa', 'Caddy', 170000, 1500),
('James', 'Willson', 80000, 1000)
;
INSERT INTO examinations (name) VALUES
('General Checkup'),
('MRI Scan'),
('Echocardiogram');

INSERT INTO doctors_examinations (end_time, start_time, doctor_id, examination_id, ward_id) VALUES
(12, 10, 1, 1, 1),
(15, 13, 2, 2, 2),
(14, 9, 3, 3, 3),
(16, 11, 4, 1, 4),
(13, 9, 5, 2, 5),
(17, 12, 6, 3, 6);



--вивести к-сть палат місткість яких більша за 2

SELECT COUNT(id) 
FROM wards 
WHERE places > 2;



--вивести назви корпусів та к-сть палат у кожному із них

SELECT departments.building, COUNT(places) FROM wards
JOIN departments ON departments.id = department_id
GROUP BY departments.building;



--вивести назви відділень та к-сть палат у кожному

SELECT departments.name, COUNT(places) FROM wards
JOIN departments ON departments.id = department_id
GROUP BY departments.name;



--вивести назви відділень та сумарну надбавку лікарів в кожному

SELECT departments.name, SUM(doctors.premium) AS total_premium
FROM departments
JOIN wards ON departments.id = wards.department_id
JOIN doctors ON wards.department_id = departments.id
GROUP BY departments.name;



--Вивести назви відділень, у яких проводять обстеження 5 та більше лікарів

SELECT departments.name AS department_name
FROM departments 
JOIN wards  ON departments.id = wards.department_id
JOIN doctors_examinations ON wards.id = doctors_examinations.ward_id
GROUP BY departments.name
HAVING COUNT(DISTINCT doctors_examinations.doctor_id) >= 2;



--Вивести кількість лікарів та їх сумарну зарплату (сума ставки та надбавки)

SELECT COUNT(id) AS total_doctors, SUM(salary)+SUM(premium) AS total_doctors_salary
FROM doctors;



--Вивести середню зарплату (сума ставки та надбавки) лікарів

SELECT AVG(salary+premium) AS average_salary
FROM doctors;



--Вивести назви палат із мінімальною місткістю

SELECT name 
FROM wards
WHERE places = (SELECT MIN(places) FROM wards);



--Вивести в яких із корпусів 1, 2 та 4, сумарна кількість місць у палатах перевищує 5. 
--При цьому враховувати лише палати з кількістю місць більше 2

SELECT DISTINCT departments.building
FROM departments 
JOIN wards ON departments.id = wards.department_id
WHERE departments.building IN (1, 2, 4)
  AND wards.places > 2
GROUP BY departments.building
HAVING SUM(wards.places) > 5;
