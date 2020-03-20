# [https://sqlzoo.net/wiki/The_JOIN_operation](https://sqlzoo.net/wiki/The_JOIN_operation)

![https://sqlzoo.net/w/images/c/ce/FootballERD.png](https://sqlzoo.net/w/images/c/ce/FootballERD.png)


game
| id | mdate | stadium | team1 | team2 |
| --- | --- | --- | --- | --- |
| 1001 | 8 June 2012 | National Stadium, Warsaw | POL | GRE |
| 1002 | 8 June 2012 | Stadion Miejski (Wroclaw) | RUS | CZE |
| 1003 | 12 June 2012 | Stadion Miejski (Wroclaw) | GRE | CZE |
| 1004 | 12 June 2012 | National Stadium, Warsaw | POL | RUS |
| ... |

goal
| matchid | teamid | player | gtime |
|  --- | --- | --- | --- |
| 1001 | POL | Robert Lewandowski | 17 |
| 1001 | GRE | Dimitris Salpingidis | 51 |
| 1002 | RUS | Alan Dzagoev | 15 |
| 1002 | RUS | Roman Pavlyuchenko | 82 |
| ... |

eteam
| id | teamname | coach |
|  --- | --- | --- |
| POL | Poland | Franciszek Smuda |
| RUS | Russia | Dick Advocaat
| CZE | Czech Republic | Michal Bilek |
| GRE | Greece | Fernando Santos |
| ... |

此教程是介召 JOIN的使用，讓你合拼2個或更多的表格。數據庫的表格貯存了在波蘭 Poland 和烏克欄 Ukraine的歐洲國家盃2012的賽事和入球資料。

## 题目

### 1.

第一個例子列出球員姓氏為'Bender'的入球數據。 * 表示列出表格的全部欄位，簡化了寫matchid, teamid, player, gtime語句。

修改此SQL以列出 賽事編號matchid 和球員名 player ,該球員代表德國隊Germany入球的。要找出德國隊球員，要檢查: teamid = 'GER'

```SQL
SELECT matchid, player
FROM goal
WHERE
    teamid = 'GER';
```

### 2.

由以上查詢，你可見Lars Bender's 於賽事 1012入球。.現在我們想知道此賽事的對賽隊伍是哪一隊。

留意在 goal 表格中的欄位 matchid ，是對應表格game的欄位id。我們可以在表格 game中找出賽事1012的資料。

只顯示賽事1012的 id, stadium, team1, team2

```SQL
SELECT id, stadium, team1, team2
  FROM game
WHERE id = 1012;
```

### 3.

我們可以利用JOIN來同時進行以上兩個步驟。

    SELECT *
        FROM game JOIN goal ON (id=matchid)

語句FROM 表示合拼兩個表格game 和 goal的數據。語句 ON 表示如何找出 game中每一列應該配對goal中的哪一列 -- goal的 id 必須配對game的 matchid 。 簡單來說，就是
ON (game.id=goal.matchid)

以下SQL列出每個入球的球員(來自goal表格)和場館名(來自game表格)

修改它來顯示每一個德國入球的球員名，隊伍名，場館和日期。

```SQL
SELECT goal.player, goal.teamid, game.stadium, game.mdate
FROM game
JOIN goal ON game.id = goal.matchid
WHERE goal.teamid = 'GER';
```

### 4.

使用上題相同的 JOIN語句，

列出球員名字叫Mario (player LIKE 'Mario%')有入球的 隊伍1 team1, 隊伍2 team2 和 球員名 player

```SQL
SELECT  game.team1, game.team2, goal.player
FROM goal
INNER JOIN game ON goal.matchid = game.id
WHERE goal.player LIKE 'Mario%';
```

### 5.

表格eteam 貯存了每一國家隊的資料，包括教練。你可以使用語句 goal JOIN eteam on teamid=id來合拼 JOIN 表格goal 到 表格eteam。

列出每場球賽中首10分鐘gtime<=10有入球的球員 player, 隊伍teamid, 教練coach, 入球時間gtime

```SQL
SELECT goal.player, goal.teamid, eteam.coach, goal.gtime
FROM goal
JOIN eteam ON goal.teamid = eteam.id
WHERE goal.gtime<=10;
```

### 6.

要合拼JOIN 表格game 和表格 eteam，你可以使用
game JOIN eteam ON (team1=eteam.id)
或
game JOIN eteam ON (team2=eteam.id)
注意欄位id同時是表格game 和表格 eteam的欄位，你要清楚指出eteam.id而不是只用id

列出'Fernando Santos'作為隊伍1 team1 的教練的賽事日期，和隊伍名。

```SQL
SELECT game.mdate, eteam.teamname
FROM eteam
JOIN game ON game.team1 = eteam.id
WHERE eteam.coach = 'Fernando Santos';
```

### 7.

列出場館 'National Stadium, Warsaw'的入球球員。

```SQL
SELECT goal.player
FROM game
JOIN goal ON goal.matchid = game.id
WHERE game.stadium = 'National Stadium, Warsaw';

SELECT goal.player
FROM goal
JOIN game ON game.id=goal.matchid
WHERE game.stadium='National Stadium, Warsaw';
```

### 8.

以下例子找出德國-希臘Germany-Greece 的八強賽事的入球
修改它，只列出全部賽事，射入德國龍門的球員名字。

HINT
找非德國球員的入球，德國可以在賽事中作team1 隊伍１（主）或team2隊伍２（客）。 你可以用teamid!='GER' 來防止列出德國球員。 你可以用DISTINCT來防止球員出現兩次以上。

```SQL
SELECT DISTINCT player
FROM goal
JOIN game ON game.id = goal.matchid
WHERE goal.teamid != 'GER' AND (game.team1 = 'GER' OR game.team2 = 'GER')
ORDER BY player;
```

### 9.

列出隊伍名稱 teamname 和該隊入球總數
COUNT and GROUP BY
你應該在SELECT語句中使用COUNT(*)和使用GROUP BY teamname

```SQL
SELECT eteam.teamname, COUNT(goal.player)
FROM eteam
JOIN goal ON eteam.id=goal.teamid
GROUP BY eteam.teamname
ORDER BY teamname;
```

### 10.

列出場館名和在該場館的入球數字。

```SQL
SELECT game.stadium, COUNT(goal.gtime)
FROM game
JOIN goal ON goal.matchid = game.id
GROUP BY game.stadium
ORDER BY game.stadium;
```

### 11.

每一場波蘭'POL'有參與的賽事中，列出賽事編號 matchid, 日期date 和入球數字。

```SQL
SELECT goal.matchid, game.mdate, COUNT(goal.teamid)
FROM goal
RIGHT JOIN game ON goal.matchid = game.id
WHERE (game.team1 = 'POL' OR game.team2 = 'POL')
GROUP BY goal.matchid
ORDER BY goal.matchid;
```

### 12.

每一場德國'GER'有參與的賽事中，列出賽事編號 matchid, 日期date 和德國的入球數字。

```SQL
SELECT game.id, game.mdate, COUNT(goal.gtime)
FROM goal
JOIN game ON goal.matchid = game.id
WHERE goal.teamid = 'GER'
GROUP BY goal.matchid
ORDER BY goal.matchid;
```

### 13.

List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
| mdate | team1 | score1 | team2 | score2 |
| --- | --- | --- | --- | --- |
| 1 July 2012 | ESP | 4 | ITA | 0 |
| 10 June 2012 | ESP | 1 | ITA | 1 |
| 10 June 2012 | IRL | 1 | CRO | 3 |
| ... |

Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. You could SUM this column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2.

```SQL
SELECT game.mdate, game.team1,
    SUM(CASE WHEN goal.teamid=game.team1 THEN 1 ELSE 0 END) AS score1,
    game.team2,
    SUM(CASE WHEN goal.teamid=game.team2 THEN 1 ELSE 0 END) AS score2
FROM game
LEFT OUTER JOIN goal ON goal.matchid = game.id
GROUP BY goal.matchid
ORDER BY game.mdate, goal.matchid, game.team1, game.team2;
```
