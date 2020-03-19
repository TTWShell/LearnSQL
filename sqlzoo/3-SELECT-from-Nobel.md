# [https://sqlzoo.net/wiki/SELECT_from_Nobel_Tutorial](https://sqlzoo.net/wiki/SELECT_from_Nobel_Tutorial)

## nobel 諾貝爾獎得獎者

我們繼續練習簡單的單一表格SQL查詢。

這個教程是有關諾貝爾獎得獎者的：

```
nobel(yr, subject, winner)
```

yr: 年份
subject: 獎項
winner: 得獎者

### 1. Winners from 1950

更改查詢以顯示1950年諾貝爾獎的獎項資料。

```SQL
SELECT yr, subject, winner FROM nobel WHERE yr = 1950;
```

### 2. 1962 Literature

顯示誰贏得了1962年文學獎(Literature)。

```SQL
SELECT winner FROM nobel
WHERE yr = 1962 AND subject = 'Literature';
```

### 3. Albert Einstein

顯示“愛因斯坦”('Albert Einstein') 的獲獎年份和獎項。

```SQL
SELECT yr, subject
FROM nobel
WHERE winner='Albert Einstein';
```

### 4. Recent Peace Prizes

顯示2000年及以後的和平獎(‘Peace’)得獎者。

```SQL
SELECT winner
FROM nobel
WHERE yr>=2000 AND subject='Peace';
```

### 5. Literature in the 1980's

顯示1980年至1989年(包含首尾)的文學獎(Literature)獲獎者所有細節（年，主題，獲獎者）。

```SQL
SELECT yr, subject, winner
FROM nobel
WHERE
    yr BETWEEN 1980 AND 1989 AND subject='Literature';
    # WHERE yr >=1980 AND yr<=1989 AND subject='Literature';
```

### 6. Only Presidents

顯示總統獲勝者的所有細節：

* 西奧多•羅斯福 Theodore Roosevelt
* 伍德羅•威爾遜 Woodrow Wilson
* 吉米•卡特 Jimmy Carter

```SQL
SELECT * FROM nobel
WHERE winner in (
    'Theodore Roosevelt',
    'Woodrow Wilson',
    'Jimmy Carter');
```

### 7. John

顯示名字為John 的得獎者。 (注意:外國人名字(First name)在前，姓氏(Last name)在後)

```SQL
SELECT winner FROM nobel WHERE winner LIKE 'John%';
```

### 8. Chemistry and Physics from different years

顯示1980年物理學(physics)獲獎者，及1984年化學獎(chemistry)獲得者。

```SQL
SELECT yr, subject, winner FROM nobel
WHERE
    (yr=1980 AND subject='physics') OR
    (yr=1984 AND subject='chemistry');
```

### 9. Exclude Chemists and Medics

查看1980年獲獎者，但不包括化學獎(Chemistry)和醫學獎(Medicine)。

```SQL
SELECT yr, subject, winner FROM nobel
WHERE yr=1980 AND subject NOT IN ('Chemistry', 'Medicine');
```

### 10. Early Medicine, Late Literature

顯示早期的醫學獎(Medicine)得獎者（1910之前，不包括1910），及近年文學獎(Literature)得獎者（2004年以後，包括2004年）。

```SQL
SELECT yr, subject, winner FROM nobel
WHERE
    (yr<1910 AND subject='Medicine') OR
    (yr>=2004 AND subject='Literature');
```

### 11. Umlaut

Find all details of the prize won by PETER GRÜNBERG.

```SQL
SELECT * FROM nobel
WHERE winner LIKE 'PETER GRÜNBERG';
```

### 12. Apostrophe

查找尤金•奧尼爾EUGENE O'NEILL得獎的所有細節 Find all details of the prize won by EUGENE O'NEILL

```SQL
SELECT * FROM nobel
WHERE winner LIKE 'EUGENE O\'NEILL';
```

### 13. Knights of the realm

騎士列隊 Knights in order

列出爵士的獲獎者、年份、獎頁(爵士的名字以Sir開始)。先顯示最新獲獎者，然後同年再按名稱順序排列。

```SQL
SELECT winner, yr, subject FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr desc, subject;
```

### 14. Chemistry and Physics last

The expression subject IN ('Chemistry','Physics') can be used as a value - it will be 0 or 1.

Show the 1984 winners and subject ordered by subject and winner name; but list Chemistry and Physics last.

```SQL
SELECT winner, subject FROM nobel
WHERE yr=1984
ORDER BY
    subject IN ('Physics','Chemistry'),
    subject,
    winner;
```
