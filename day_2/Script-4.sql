SELECT 
	animals.name,
	animals.species,
	diets.*
FROM animals INNER JOIN diets 
ON animals.diet_id = diets.id;


SELECT 
	a.name AS animal_name,
	a.species,
	d.*
FROM animals AS a INNER JOIN diets AS d
ON a.diet_id = d.id;


SELECT 
	animals.name,
	animals.species,
	animals.age,
	diets.diet_type
FROM animals INNER JOIN diets
ON animals.diet_id = diets.id 
WHERE animals.age > 4;


SELECT 
	count(a.id), 
	d.diet_type
FROM animals AS a INNER JOIN diets AS d
ON a.diet_id = d.id
GROUP BY d.diet_type;

SELECT 
	a.*,
	d.diet_type
FROM animals AS a INNER JOIN diets AS d
ON a.diet_id = d.id 
WHERE d.diet_type = 'herbivore';


SELECT 
	animals.name,
	animals.species,
	diets.*
FROM animals LEFT JOIN diets 
ON animals.diet_id = diets.id;


SELECT 
	animals.name,
	animals.species,
	diets.*
FROM animals RIGHT JOIN diets 
ON animals.diet_id = diets.id;

SELECT 
	count(a.species),
	d.diet_type
FROM animals AS a RIGHT JOIN diets AS d 
ON a.diet_id = d.id
GROUP BY d.diet_type
ORDER BY d.diet_type ASC ;


SELECT 
	a.*,
	d.*
FROM animals AS a FULL JOIN diets AS d
ON a.diet_id = d.id;

---- Join in many- to -many relationships -----
--“Each animal is cared for by many keepers, and each keeper cares for many animals”---

--“Get a rota for the keepers and the animals they look after, 
--ordered first by animal name, and then by day.”

SELECT 
	a.name AS animal_name,
	a.species,
	cs.DAY,
	k.name AS keeper_name
FROM
	animals AS a INNER JOIN care_schedule AS cs 
	ON a.id = cs.animal_id INNER JOIN keepers AS k 
	ON cs.keeper_id = k.id 
ORDER BY animal_name, cs.DAY;	

----Schedule only for snake----

SELECT 
	a.name AS animal_name,
	a.species,
	cs.DAY,
	k.name AS keeper_name
FROM
	animals AS a INNER JOIN care_schedule AS cs 
	ON a.id = cs.animal_id INNER JOIN keepers AS k 
	ON cs.keeper_id = k.id 
WHERE a.species = 'Snake'
ORDER BY cs.DAY;

-----Self joins -----
SELECT *
FROM keepers ;

--“Get a table showing the name of each keeper, 
--together with their manager’s name (if they have a manager).”

SELECT 
	k.name AS employee_name,
	m.name AS manager_name
FROM keepers AS k LEFT JOIN keepers AS m
ON k.manager_id = m.id;



