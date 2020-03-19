# [https://sqlzoo.net/wiki/SQLZOO:SELECT_from_WORLD_Tutorial/zh](https://sqlzoo.net/wiki/SQLZOO:SELECT_from_WORLD_Tutorial/zh)

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

### 1. Introduction

閱讀此表的注意事項 觀察運行一個簡單的SQL命令的結果。

```SQL
SELECT name, continent, population FROM world;
```

### 2. Large Countries

如何使用WHERE來篩選記錄。 顯示具有至少2億人口的國家名稱。 2億是200000000，有八個零。

```SQL
SELECT name FROM world WHERE population>200000000;
```
### 3. Per capita GDP

找出有至少200百萬(2億)人口的國家名稱，及人均國內生產總值。

```SQL
SELECT name, GDP/population FROM world WHERE population>200000000;
```

### 4. South America In millions

顯示'South America'南美洲大陸的國家名字和以百萬為單位人口數。 將人口population 除以一百萬(1000000)得可得到以百萬為單位人口數。

```SQL
SELECT name, population/1000000 FROM world WHERE continent = 'South America';
```

### 5. France, Germany, Italy

顯示法國，德國，意大利(France, Germany, Italy)的國家名稱和人口。

```SQL
SELECT name, population FROM world WHERE name IN ('France', 'Germany', 'Italy');
```

### 6. United

顯示包含單詞“United”為名稱的國家。

```SQL
SELECT name FROM world WHERE name LIKE "%United%";
```

### 7. Two ways to be big

成為大國的兩種方式：如果它有3百萬平方公里以上的面積，或擁有250百萬(2.5億)以上人口。

展示大國的名稱，人口和面積。

```SQL
SELECT name,  population, area FROM world
WHERE area > 3000000 or population > 250000000;
```

### 8. One or the other (but not both)

美國、印度和中國(USA, India, China)是人口又大，同時面積又大的國家。排除這些國家。

顯示以人口或面積為大國的國家，但不能同時兩者。顯示國家名稱，人口和面積。

```SQL
SELECT name,  population, area FROM world
WHERE
    (area > 3000000 or population > 250000000) and
    not (area > 3000000 and population > 250000000);
```

### 9. Rounding

除以為1000000（6個零）是以百萬計。除以1000000000（9個零）是以十億計。使用 ROUND 函數來顯示的數值到小數點後兩位。

對於南美顯示以百萬計人口，以十億計2位小數GDP。

```SQL
SELECT name,  ROUND(population/1000000, 2), ROUND(gdp/1000000000, 2) FROM world
WHERE continent = 'South America';
```

### 10. Trillion dollar economies

顯示國家有至少一個萬億元國內生產總值（萬億，也就是12個零）的人均國內生產總值。四捨五入這個值到最接近1000。

顯示萬億元國家的人均國內生產總值，四捨五入到最近的$ 1000。

```SQL
SELECT name, ROUND(gdp/population, -3) FROM world
WHERE gdp > 1000000000000;
```

### 11. Name and capital have the same length

```SQL
# en版本
/*
Greece has capital Athens.

Each of the strings 'Greece', and 'Athens' has 6 characters.

Show the name and capital where the name and the capital have the same number of characters.

You can use the LENGTH function to find the number of characters in a string
*/
SELECT name, capital
FROM world
WHERE LENGTH(name)=LENGTH(capital);

# zh版本
/*
The CASE statement shown is used to substitute North America for Caribbean in the third column.

Show the name - but substitute Australasia for Oceania - for countries beginning with N.
*/
SELECT name,
    CASE
        WHEN continent='Oceania' THEN 'Australasia'
    ELSE continent END
FROM world
 WHERE name LIKE 'N%';
```

### 12. Matching name and capital

```SQL
# en版本
/*
The capital of Sweden is Stockholm. Both words start with the letter 'S'.

Show the name and the capital where the first letters of each match. Don't include countries where the name and the capital are the same word.
You can use the function LEFT to isolate the first character.
You can use <> as the NOT EQUALS operator.
*/
SELECT name, capital FROM world
WHERE
    name != capital AND
    LEFT(name, 1) = LEFT(capital, 1);

# zh版本
/*
Show the name and the continent - but substitute Eurasia for Europe and Asia; substitute America - for each country in North America or South America or Caribbean. Show countries beginning with A or B
*/
SELECT name,
    CASE
        WHEN continent IN ('Europe', 'Asia') THEN 'Eurasia'
        WHEN continent IN ('North America', 'South America', 'Caribbean') THEN 'America'
    ELSE continent END
 FROM world
WHERE name LIKE 'A%' or name LIKE 'B%';
```

### 13. All the vowels

```SQL
# en版本
/*
Equatorial Guinea and Dominican Republic have all of the vowels (a e i o u) in the name. They don't count because they have more than one word in the name.

Find the country that has all the vowels and no spaces in its name.

You can use the phrase name NOT LIKE '%a%' to exclude characters from your results.
The query shown misses countries like Bahamas and Belarus because they contain at least one 'a'
*/
SELECT name FROM world
WHERE
    name LIKE '%a%' AND
    name LIKE '%e%' AND
    name LIKE '%i%' AND
    name LIKE '%o%' AND
    name LIKE '%u%' AND
    name NOT LIKE '% %';

# zh版本
/*
Put the continents right...

Oceania becomes Australasia
Countries in Eurasia and Turkey go to Europe/Asia
Caribbean islands starting with 'B' go to North America, other Caribbean islands go to South America
Show the name, the original continent and the new continent of all countries.
*/
SELECT name, continent AS original_continent,
    CASE
        WHEN continent='Oceania' THEN 'Australasia'
        WHEN continent IN ('Eurasia', 'Turkey') THEN 'Europe/Asia'
        WHEN continent='Caribbean' AND name LIKE 'B%' THEN 'North America'
        WHEN continent='Caribbean' AND name NOT LIKE 'B%' THEN 'South America'
    ELSE continent END AS new_continent
FROM world
ORDER BY name;
```