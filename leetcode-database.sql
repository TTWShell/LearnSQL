# 175. Combine Two Tables
SELECT p.FirstName, p.LastName, a.City, a.State FROM Person AS p
Left JOIN Address AS a ON p.PersonId = a.PersonId;

# 176. Second Highest Salary
SELECT (
    SELECT DISTINCT Salary FROM Employee
    ORDER BY Salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;  -- 外层select as 解决 null问题

# 177. Nth Highest Salary
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  # https://www.mysqltutorial.org/variables-in-stored-procedures.aspx
  DECLARE K INT DEFAULT N - 1;
  RETURN (
      # Write your MySQL query statement below.
      SELECT (
          SELECT DISTINCT Salary FROM Employee
          ORDER BY Salary DESC
          LIMIT 1 OFFSET K
      ) AS SecondHighestSalary
  );
END

# 178. Rank Scores
SELECT Score, (
        SELECT COUNT(DISTINCT Score) FROM Scores
        WHERE Score >= S.Score
    ) AS Rank
FROM Scores AS S
ORDER BY Score DESC; -- 568 ms

SELECT Score, (
        SELECT COUNT(*) FROM (
            SELECT DISTINCT Score AS s FROM Scores
        ) AS t WHERE s >= Score
    ) Rank
FROM Scores ORDER BY Score DESC; -- 207 ms

SELECT s.Score, COUNT(DISTINCT t.Score) AS Rank
FROM Scores s
JOIN Scores t ON s.Score <= t.Score
GROUP BY s.Id
ORDER BY s.Score DESC; -- 639 ms

# 180. Consecutive Numbers
SELECT DISTINCT a.Num AS ConsecutiveNums FROM Logs a
JOIN logs b
JOIN logs c
WHERE
    a.Id = b.Id-1 AND b.Id = c.Id-1 AND
    a.Num = b.Num AND b.Num = c.Num;

SELECT DISTINCT Num AS ConsecutiveNums
FROM (
    SELECT *, @cnt := equal_last * @cnt + 1 AS cnt
        FROM (
            SELECT Num, @prev = (@prev := Num
        ) AS equal_last
    FROM Logs, (SELECT @prev := -1) init) tmp, (SELECT @cnt := 0) init1
) AS tmp1
WHERE cnt > 2;

# 181. Employees Earning More Than Their Managers
SELECT a.Name AS Employee FROM Employee a
JOIN Employee b ON a.ManagerId = b.Id
WHERE a.Salary > b.Salary; -- 541ms

SELECT Name AS 'Employee'
FROM Employee
INNER JOIN
    (
        SELECT DISTINCT E1.Id AS 'ManId', E1.Salary AS 'ManSalary'
        FROM Employee E1
        INNER JOIN Employee E2
        ON E1.Id = E2.ManagerId
    ) Manager
    ON Employee.ManagerId = Manager.ManId
WHERE Employee.Salary > Manager.ManSalary; -- 301ms

# 182. Duplicate Emails
SELECT Email FROM Person GROUP BY Email HAVING COUNT(*) > 1;

# 183. Customers Who Never Order
SELECT C.Name AS Customers FROM Customers AS C
LEFT JOIN Orders AS O ON C.Id = O.CustomerId
WHERE O.Id IS NULL;

SELECT Name AS Customers
FROM Customers
WHERE Id NOT IN (SELECT CustomerId FROM orders);

# 184. Department Highest Salary
SELECT D.Name AS Department, E.Name AS Employee, E.Salary AS Salary
FROM Employee AS E
JOIN Department AS D ON E.DepartmentId = D.Id
WHERE E.Salary = (
    SELECT MAX(Salary)
    FROM Employee
    WHERE DepartmentId = E.DepartmentId
); -- 654 ms

SELECT D.Name AS Department, E.Name AS Employee, E.Salary AS Salary
FROM Employee E, (
        SELECT MAX(Salary) AS Salary, DepartmentId
        FROM Employee
        GROUP BY DepartmentId
    ) AS M
JOIN Department AS D ON M.DepartmentId = D.Id
WHERE E.Salary = M.Salary AND E.DepartmentId = M.DepartmentId; -- 278ms

# 185. Department Top Three Salaries
SELECT D.Name AS Department, E.Name AS Employee, E.Salary AS Salary
FROM Employee AS E
JOIN Department AS D ON E.DepartmentId = D.Id
WHERE E.Salary >= IFNULL((
    SELECT DISTINCT Salary
    FROM Employee
    WHERE DepartmentId = E.DepartmentId
    ORDER BY Salary DESC
    LIMIT 1 OFFSET 2
), 0)
ORDER BY Department, Employee, Salary DESC; -- 907ms

SELECT d.Name Department, ranked.Name Employee, ranked.Salary Salary
FROM
	# Rank employee salaries within the same department using subquery.
    (SELECT Name,
		# A simpler case @rank := IF(@department = DepartmentId, @rank + 1, 1) would set different ranks for same salaries.
        @rank := IF(
			@department = DepartmentId,
			IF(@salary = Salary, @rank, @rank + 1),
			1) AS rank,
        @department := DepartmentId AS DepartmentId,
        @salary := Salary AS Salary
    FROM Employee, (SELECT @rank := 0, @department := 0, @salary := 0) AS vars
    ORDER BY DepartmentId ASC, Salary DESC
	) ranked
INNER JOIN Department d ON d.Id = ranked.DepartmentId
WHERE ranked.rank <= 3; -- 380 ms

# 196. Delete Duplicate Emails
DELETE FROM Person
WHERE Id NOT IN (
    SELECT p.Id FROM (
        SELECT MIN(Id) Id FROM Person GROUP BY Email
    ) AS p
); -- faster

DELETE p2 FROM Person AS p1
JOIN Person AS p2 ON p2.Email = p1.Email WHERE p2.Id > p1.Id;

DELETE p2 FROM Person AS p1, Person AS p2
WHERE p1.Email = p2.Email AND p2.Id > p1.Id;

# 197. Rising Temperature
SELECT B.Id FROM Weather AS A
JOIN Weather AS B ON A.RecordDate = DATE_SUB(B.RecordDate, interval 1 day)
WHERE A.Temperature < B.Temperature;

SELECT Id
FROM (
        SELECT
            Id,
            if(Temperature>@prev,if(datediff(RecordDate,@prev_date)=1, 1, 0), 0)
            AS flag,
            @prev:=Temperature,
            @prev_date:=RecordDate
        FROM
            Weather, (SELECT @prev:=1000,@prev_date:="1994-08-01") init
        ORDER BY
            RecordDate
    ) AS t
WHERE
    t.flag > 0;

# 262. Trips and Users
SELECT T.Request_at AS Day, ROUND(
        SUM(
            CASE WHEN T.Status = 'completed' THEN 0 ELSE 1 END
        ) / COUNT(*)
    , 2) AS 'Cancellation Rate'
FROM Trips AS T
JOIN Users AS UC ON UC.Users_Id = T.Client_Id
JOIN Users AS UD ON UD.Users_Id = T.Driver_Id
WHERE
    T.Request_at BETWEEN '2013-10-01' AND '2013-10-03' AND
    UC.Banned = 'No' AND
    UD.Banned = 'No'
GROUP BY Day;