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