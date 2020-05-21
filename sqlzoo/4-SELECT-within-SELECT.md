# [https://sqlzoo.net/wiki/SELECT_within_SELECT_Tutorial](https://sqlzoo.net/wiki/SELECT_within_SELECT_Tutorial)

此教程教我們在SELECT查詢中使用別一個SELECT查詢，進行一些更複雜的查詢。

| name | continent | area | population | gdp |
| --- | --- | --- | --- | --- |
| Afghanistan | Asia | 652230 | 25500100 | 20343000000 |
| Albania | Europe | 28748 | 2831741 | 12960000000 |
| Algeria | Africa | 2381741 | 37100000 | 188681000000 |
| Andorra | Europe | 468 | 78115 | 3712000000 |
| Angola | Africa | 1246700 | 20609294 | 100990000000 |
| .... |

name:國家名稱
continent:洲份
area:面積
population:人口
gdp:國內生產總值

## 题目

### 1. Bigger than Russia

列出每個國家的名字 name，當中人口 population 是高於俄羅斯'Russia'的人口。

```SQL
SELECT name FROM world
WHERE
    population > (
        SELECT population FROM world
        WHERE name='Russia');
```

### 2. Richer than UK

列出歐州每國家的人均GDP，當中人均GDP要高於英國'United Kingdom'的數值。

```SQL
SELECT name FROM world
WHERE
    continent='Europe' AND
    gdp/population > (
        SELECT gdp/population FROM world
        WHERE name='United Kingdom'
    );
```

### 3. Neighbours of Argentina and Australia

在阿根廷Argentina 及 澳大利亞 Australia所在的洲份中，列出當中的國家名字 name 及洲分 continent 。按國字名字順序排序

```SQL
SELECT name, continent FROM world
WHERE
    continent IN (
        SELECT continent FROM world
        WHERE
            name IN ('Argentina', 'Australia')
    )
ORDER BY name;
```

### 4. Between Canada and Poland

哪一個國家的人口比加拿大Canada的多，但比波蘭Poland的少?列出國家名字name和人口population 。

```SQL
SELECT name, population FROM world
WHERE
    population > (
        SELECT population FROM world
        WHERE
            name='Canada'
    ) AND
    population < (
        SELECT population FROM world
        WHERE
            name='Poland'
    );
```

### 5. Percentages of Germany

Germany德國（人口8000萬），在Europe歐洲國家的人口最多。Austria奧地利（人口850萬）擁有德國總人口的11％。

顯示歐洲的國家名稱name和每個國家的人口population。以德國的人口的百分比作人口顯示。

```SQL
SELECT name, CONCAT(
    ROUND(population * 100/(
        SELECT population FROM world WHERE name='Germany'
    ), 0), '%') FROM world
WHERE continent='Europe';
```

### 6. Bigger than every country in Europe

哪些國家的GDP比Europe歐洲的全部國家都要高呢? [只需列出 name 。] (有些國家的記錄中，GDP是NULL，沒有填入資料的。)

```SQL
SELECT name FROM world
WHERE
   gdp > (
       SELECT MAX(gdp) from world WHERE continent='Europe'
   );
```

### 7. Largest in each continent

在每一個州中找出最大面積的國家，列出洲份 continent, 國家名字 name 及面積 area。 (有些國家的記錄中，AREA是NULL，沒有填入資料的。)

```SQL
SELECT continent, name, area FROM world x
WHERE area >= (
    SELECT MAX(area) FROM world y WHERE y.continent=x.continent);
# 这里仅仅是学习select子句，实际可以这么写
SELECT b.continent, b.name, b.area FROM (
    SELECT continent, MAX(area) as max_area FROM world GROUP BY continent
) AS a
JOIN world AS b
ON a.continent = b.continent AND a.max_area = b.area;
```

### 8. First country of each continent (alphabetically)

列出洲份名稱，和每個洲份中國家名字按子母順序是排首位的國家名。(即每洲只有列一國)

```SQL
SELECT continent, name FROM world x
WHERE
    name=(
        SELECT name FROM world y
        WHERE x.continent=y.continent
        ORDER BY name LIMIT 1
    );

```

## Difficult Questions That Utilize Techniques Not Covered In Prior Sections

### 9.

找出洲份，當中全部國家都有少於或等於 25000000 人口. 在這些洲份中，列出國家名字name，continent 洲份和population人口。

```SQL
SELECT name, continent, population FROM world x
WHERE
   (SELECT MAX(population) FROM world y
    WHERE x.continent=y.continent
    ) <= 25000000;
```

### 10.

有些國家的人口是同洲份的所有其他國的3倍或以上。列出 國家名字name 和 洲份 continent。

```SQL
# 解法1，all func
SELECT name,  continent FROM world x
WHERE
    population/3 >= ALL(
        SELECT population FROM world y
        WHERE
            x.continent=y.continent AND
            y.population>0 AND
            y.name!=x.name
   );
# 解法2
SELECT name,  continent FROM world x
WHERE
    population >= (
        SELECT MAX(population)*3 FROM world y
        WHERE
            x.continent=y.continent AND
            y.name!=x.name
   );
```
