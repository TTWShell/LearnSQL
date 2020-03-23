# [https://sqlzoo.net/wiki/Using_Null](https://sqlzoo.net/wiki/Using_Null)


teacher
| id | dept | name | phone | mobile |
| --- | --- | --- | --- | --- |
| 101 | 1 | Shrivell | 2753 | 07986 555 1234 |
| 102 | 1 | Throd | 2754 | 07122 555 1920 |
| 103 | 1 | Splint | 2293 |  |
| 104 |  | Spiregrain | 3287 |  |
| 105 | 2 | Cutflower | 3212 | 07996 555 6574 |
| 106 |  | Deadyawn | 3345 | | 
| ... |

dept
| id | name |
|  --- | --- |
| 1 | Computing |
| 2 | Design |
| 3 | Engineering |
| ... |

## Teachers and Departments

The school includes many departments. Most teachers work exclusively for a single department. Some teachers have no department.

[Selecting NULL values.](https://sqlzoo.net/wiki/Selecting_NULL_values.)

# 题目

## NULL, INNER JOIN, LEFT JOIN, RIGHT JOIN

### 1.

List the teachers who have NULL for their department.

Why we cannot use =

You might think that the phrase dept=NULL would work here but it doesn't - you can use the phrase dept IS NULL

That's not a proper explanation.

```SQL
SELECT name FROM teacher WHERE dept IS NULL;
```

### 2. 

Note the INNER JOIN misses the teachers with no department and the departments with no teacher.

```SQL
SELECT teacher.name, dept.name 
FROM teacher
INNER JOIN dept ON (teacher.dept=dept.id);
```

### 3. 

Use a different JOIN so that all teachers are listed.

```SQL
SELECT teacher.name, dept.name 
FROM teacher
LEFT JOIN dept ON (teacher.dept=dept.id);
```
### 4. 

Use a different JOIN so that all departments are listed.

```SQL
SELECT teacher.name, dept.name 
FROM teacher
RIGHT JOIN dept ON (teacher.dept=dept.id);
```

## Using the [COALESCE](https://sqlzoo.net/wiki/COALESCE) function

### 5. 

Use COALESCE to print the mobile number. Use the number '07986 444 2266' if there is no number given. Show teacher name and mobile number or '07986 444 2266'

COALESCE takes any number of arguments and returns the first value that is not null.

    COALESCE(x,y,z) = x if x is not NULL
    COALESCE(x,y,z) = y if x is NULL and y is not NULL
    COALESCE(x,y,z) = z if x and y are NULL but z is not NULL
    COALESCE(x,y,z) = NULL if x and y and z are all NULL

```SQL
SELECT name, COALESCE(mobile, '07986 444 2266') FROM teacher;
```

### 6. 

Use the COALESCE function and a LEFT JOIN to print the teacher name and department name. Use the string 'None' where there is no department.

```SQL
SELECT teacher.name, COALESCE(dept.name, 'None') FROM teacher
LEFT JOIN dept ON dept.id = teacher.dept;
```

### 7. 

Use COUNT to show the number of teachers and the number of mobile phones.

```SQL
SELECT COUNT(teacher.name), COUNT(teacher.mobile) FROM teacher;
```

### 8. 

Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the Engineering department is listed.

```SQL
SELECT dept.name, COUNT(teacher.id) FROM teacher
RIGHT JOIN dept ON teacher.dept = dept.id
GROUP BY dept.name;

SELECT dept.name, COUNT(teacher.id) FROM dept
LEFT JOIN teacher ON teacher.dept = dept.id
GROUP BY dept.name;
```

## Using [CASE](https://sqlzoo.net/wiki/CASE)

### 9. 

Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise.

```SQL
SELECT teacher.name, CASE WHEN teacher.dept IN (1, 2) THEN 'Sci' ELSE 'Art' END 
FROM teacher
LEFT JOIN dept ON teacher.dept = dept.id;
```

### 10. 

Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, show 'Art' if the teacher's dept is 3 and 'None' otherwise.

```SQL
SELECT teacher.name, CASE 
    WHEN teacher.dept IN (1, 2) THEN 'Sci' 
    WHEN teacher.dept = 3 THEN 'Art' 
    ELSE 'None' END 
FROM teacher
LEFT JOIN dept ON teacher.dept = dept.id;
```

# [previously Scottish Parliament](https://sqlzoo.net/wiki/Scottish_Parliament)

## Scottish Parliament

The data includes all Members of the Scottish Parliament (MSPs) in 1999. Most MSPs belong to a political party. Some parties have a leader who is an MSP. There are two tables:

msp
| Name | Party | Constituency |
| --- | --- | --- |
| Adam MSP, Brian | SNP | North East Scotland |
| Aitken MSP, Bill | Con | Glasgow |
| Alexander MSP, Ms Wendy | Lab | Paisley North |
| ... Total number of records: 129 |

party
| Code | Name | Leader |
| --- | --- | --- |
| Con | Conservative | McLetchie MSP, David |
| Green | Green |  |
| Lab | Labour | Dewar MSP, Rt Hon Donald |
| ... Total number of records: 9 |

[Selecting NULL values](https://sqlzoo.net/wiki/Selecting_NULL_values.)

## Dealing with NULL

### 1.

One MSP was kicked out of the Labour party and has no party. Find him.

Why we cannot use =
You might think that the phrase dept=NULL would work here. It doesn't. This is because NULL "propogates". Any normal expression that includes NULL is itself NULL, thus the value of the expressions 2+NULL and party || NULL and NULL=NULL for example are all NULL.

Theory

The NULL value does not cause a type error, however it does infect everything it touches with NULL-ness. We call this element the bottom value for the algebra - but we don't snigger because we are grown-ups. [Bottom Type.](http://c2.com/cgi/wiki?BottomType)

```SQL
SELECT msp.name FROM msp WHERE party IS NULL;
```

### 2.

Obtain a list of all parties and leaders.

```SQL
SELECT name, leader FROM party;
```

### 3.

Give the party and the leader for the parties which have leaders.

```SQL
SELECT name, leader FROM party WHERE leader IS NOT NULL;
```

### 4.

Obtain a list of all parties which have at least one MSP.

```SQL
SELECT DISTINCT party.name FROM party
LEFT JOIN msp ON msp.party = party.code
GROUP BY party.name
HAVING COUNT(msp.party) > 0;

SELECT DISTINCT( party.name )
FROM party JOIN msp ON party.code = msp.party
WHERE  msp.name IS NOT NULL;
```

## [Outer joins](https://sqlzoo.net/wiki/Outer_joins)

### 5.

Obtain a list of all MSPs by name, give the name of the MSP and the name of the party where available. Be sure that Canavan MSP, Dennis is in the list. Use ORDER BY msp.name to sort your output by MSP.

```SQL
SELECT msp.name, party.name FROM msp
LEFT JOIN party ON msp.party = party.code
ORDER BY msp.name;
```

### 6.

Obtain a list of parties which have MSPs, include the number of MSPs.

```SQL
SELECT party.name, COUNT(msp.name) FROM party
JOIN msp ON msp.party = party.code
GROUP BY party.name;
```

### 7.

A list of parties with the number of MSPs; include parties with no MSPs.

```SQL
SELECT party.name, COUNT(msp.name) FROM party
LEFT JOIN msp ON msp.party = party.code
GROUP BY party.name;
```
