# [https://sqlzoo.net/wiki/SUM_and_COUNT](https://sqlzoo.net/wiki/SUM_and_COUNT)

## World Country Profile: Aggregate functions

此教程是有關群組函數，例如COUNT, SUM 和 AVG。群組函數把多個數值運算，得出結果只有一個數值。例如SUM函數會把數值2,4,和5運算成結果11。

表同前面练习。

name:國家名稱
continent:洲份
area:面積
population:人口
gdp:國內生產總值

## 题目

### You might want to look at these examples first

[Using SUM, Count, MAX, DISTINCT and ORDER BY.](https://sqlzoo.net/wiki/Using_SUM,_Count,_MAX,_DISTINCT_and_ORDER_BY)

1. The total population and GDP of Europe.

    ```SQL
    SELECT SUM(population), SUM(gdp) FROM bbc WHERE region = 'Europe';
    ```
2. What are the regions?

    ```SQL
    SELECT DISTINCT region FROM bbc;
    ```
3. Show the name and population for each country with a population of more than 100000000. Show countries in descending order of population.

    ```SQL
    SELECT name, population FROM bbc
    WHERE population > 100000000
    ORDER BY population DESC;
    ```

### 1. Total world population

展示世界的總人口。

    world(name, continent, area, population, gdp)

```SQL
SELECT SUM(population) FROM world;
```

### 2. List of continents

列出所有的洲份, 每個只有一次。

```SQL
SELECT DISTINCT continent FROM world;
```

### 3. GDP of Africa

找出非洲(Africa)的GDP總和。

```SQL
SELECT SUM(gdp) FROM world WHERE continent = 'Africa';
```

### 4. Count the big countries

有多少個國家具有至少百萬(1000000)的面積。

```SQL
SELECT COUNT(name) FROM world WHERE area >= 1000000;
```

### 5. Baltic states population

('France','Germany','Spain')（“法國”，“德國”，“西班牙”）的總人口是多少？

```SQL
SELECT SUM(population) FROM world WHERE name IN ('France','Germany','Spain');
```

### [Using GROUP BY and HAVING](https://sqlzoo.net/wiki/Using_GROUP_BY_and_HAVING.)

GROUP BY and HAVING

By including a GROUP BY clause functions such as SUM and COUNT are applied to groups of items sharing values. When you specify GROUP BY continent the result is that you get only one row for each different value of continent. All the other columns must be "aggregated" by one of SUM, COUNT ...

The HAVING clause allows use to filter the groups which are displayed. The WHERE clause filters rows before the aggregation, the HAVING clause filters after the aggregation.

If a ORDER BY clause is included we can refer to columns by their position.

1. For each continent show the number of countries:

    world(name, continent, area, population, gdp)

    ```SQL
    SELECT continent, COUNT(name) FROM world GROUP BY continent;
    ```

2. For each continent show the total population:

    ```SQL
    SELECT continent, SUM(population) FROM world GROUP BY continent;
    ```
3. WHERE and GROUP BY. The WHERE filter takes place before the aggregating function. For each relevant continent show the number of countries that has a population of at least 200000000.

    ```SQL
    SELECT continent, COUNT(name)
    FROM world
    WHERE population>200000000
    GROUP BY continent;
    ```
4. GROUP BY and HAVING. The HAVING clause is tested after the GROUP BY. You can test the aggregated values with a HAVING clause. Show the total population of those continents with a total population of at least half a billion.

    ```SQL
    SELECT continent, SUM(population)
    FROM world
    GROUP BY continent
    HAVING SUM(population)>500000000;
    ```

### 6. Counting the countries of each continent

對於每一個洲份，顯示洲份和國家的數量。

```SQL
SELECT continent, COUNT(name) FROM world
GROUP BY continent;
```

### 7. Counting big countries in each continent

對於每一個洲份，顯示洲份和至少有1000萬人(10,000,000)口國家的數目。

```SQL
SELECT continent, COUNT(name) FROM world
WHERE population>10000000
GROUP BY continent;
```

### 8. Counting big continents

列出有至少100百萬(1億)(100,000,000)人口的洲份。

```SQL
SELECT continent FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000;
```
