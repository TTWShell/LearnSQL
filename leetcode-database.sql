# 175. Combine Two Tables
SELECT p.FirstName, p.LastName, a.City, a.State FROM Person AS p
Left JOIN Address AS a ON p.PersonId = a.PersonId;