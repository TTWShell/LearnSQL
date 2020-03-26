-- 175. Combine Two Tables
SELECT p.FirstName, p.LastName, a.City, a.State FROM Person AS p
Left JOIN Address AS a ON p.PersonId = a.PersonId;

-- 176. Second Highest Salary
SELECT (
    SELECT DISTINCT Salary FROM Employee
    ORDER BY Salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary; -- 外层select as 解决 null问题