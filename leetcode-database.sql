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
