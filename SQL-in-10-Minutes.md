# 10分钟学会SQL

读完本文你可以快速学习SQL的知识点（主要是检索），需要你有一定的数据库表结构常识，或者至少懂一些类似excel、csv的知识。

表设计及数据可以从[这里](https://forta.com/books/0672336073/)下载。

以PostgreSQL为例：

    psql -U postgres -d SQL_in_10_Minutes -f ~/Downloads/TeachYourselfSQL_PostgreSQL/create.txt
    psql -U postgres -d SQL_in_10_Minutes -f ~/Downloads/TeachYourselfSQL_PostgreSQL/populate.txt

## 什么是SQL？

SQL(发音为字母 S-Q-L 或 sequel)是 Structured Query Language(结构化查询语言)的缩写。
 设计 SQL 的目的是很好地完成一项任务——提供一种从数据库中读写数据的简单有效的方法。

## 检索数据

使用 SELECT 语句从表中检索一个或多个数据列。

关键点：1. 想检索什么；2. 从什么地方检索。

语法：

```SQL
SELECT 列名称[, 列名称] FROM 表名称;
SELECT * FROM 表名称;
```

例子：

```SQL
SELECT prod_id FROM Products;
SELECT prod_id, prod_name, prod_price FROM Products;
SELECT * FROM Products;  -- 实际生产环境不可能使用。原因：不可控，变更表设计一定会导致业务层变动
SELECT DISTINCT vend_id FROM Products; /* DISTINCT 关键字作用于所有的列，不仅仅是跟在其后的那一列 */
# 在一行的开始处使用#，这一整行都将作为注释
```

## 排序

为了明确地排序用 SELECT 语句检索出的数据，可使用 ORDER BY 子句。

```SQL
SELECT prod_name FROM Products ORDER BY prod_name;
SELECT prod_id, prod_price, prod_name FROM Products ORDER BY prod_price, prod_name;
SELECT prod_id, prod_price, prod_name FROM Products ORDER BY 2, 3;  -- 按列位置排序，不建议使用
# 默认 ASC(ASCENDING) 升序，可以使用 DESC(DESCENDING) 降序
SELECT prod_id, prod_price, prod_name FROM Products ORDER BY prod_price DESC, prod_name ASC;
/* 
DESC 关键字只应用到直接位于其前面的列名
如果想在多个列上进行降序排序，必须对每一列指定 DESC 关键字。
在对文本性数据进行排序时，A 与 a 相同吗?a 位于 B 之前，还是 Z 之后?
这些问题不是理论问题，其答案取决于数据库的设置方式。
*/
```

## 过滤数据

数据库表一般包含大量的数据，很少需要检索表中的所有行。通常只会根据特定操作或报告的需要提取表数据的子集。只检索所需数据需要指定搜索条件(search criteria)，搜索条件也称为过滤条件(filter condition)。

在 SELECT 语句中，数据根据 WHERE 子句中指定的搜索条件进行过滤。 WHERE 子句在表名(FROM 子句)之后给出。

```SQL
SELECT prod_name, prod_price FROM Products WHERE prod_price = 3.49;
```

**WHERE子句操作符：**

| 操作符 | 说明 | 操作符 | 说明 |
| -- | -- | -- | -- |
| = | 等于 | > | 大于 |
| <> | 不等于 | >= | 大于等于 |
| != | 不等于|  !> | 不大于 |  
| < | 小于 | BETWEEN | 在指定的两个值之间 |
| <= | 小于等于 | IS NULL | 为NULL值 |
| !< | 不小于 |

```
SELECT prod_name, prod_price FROM Products WHERE prod_price BETWEEN 5 AND 10;
SELECT cust_name FROM CUSTOMERS WHERE cust_email IS NULL;
```

## 高级数据过滤

SQL 允许给出多个 WHERE 子句。这些子句有两 种使用方式，**即以 AND 子句或 OR 子句的方式使用。**

```SQL
SELECT prod_id, prod_price, prod_name FROM Products WHERE vend_id = 'DLL01' AND prod_price <= 4;
SELECT prod_name, prod_price FROM Products WHERE vend_id = 'DLL01' OR vend_id = 'BRS01';
```

混合使用 OR AND 关键字，加上圆括号()，以明确优先级。

**IN 操作符用来指定条件范围，范围中的每个条件都可以进行匹配。**

```SQL
SELECT prod_name, prod_price
FROM Products
WHERE vend_id IN ( 'DLL01', 'BRS01' ) -- IN 操作符完成了与 OR 相同的功能
ORDER BY prod_name;
```

**NOT WHERE 子句中用来否定其后条件的关键字。**

```SQL
SELECT prod_name
FROM Products
WHERE NOT vend_id = 'DLL01' ORDER BY prod_name;
```

## 用通配符进行过滤

学习什么是通配符、如何使用通配符以及怎样使用 LIKE 操作符进行通配搜索，以便对数据进行复杂过滤。

### 两个概念：

**通配符(wildcard)：** 用来匹配值的一部分的特殊字符。
**搜索模式(search pattern)：** 由字面值、通配符或两者组合构成的搜索条件。

### 通配符：

**百分号(%)通配符：** 最常使用的通配符是百分号(%)。在搜索串中，%表示任何字符出现任意次
数。
通配符%看起来像是可以匹配任何东西，但有个例外，这就是 NULL。 子句WHERE prod_name LIKE '%'不会匹配产品名称为NULL的行。
**下划线(_)通配符：** 只匹配 单个字符，而不是多个字符。
**方括号([ ])通配符：** 方括号([])通配符用来指定一个字符集，它必须匹配指定位置(通配 符的位置)的一个字符。
[!JM] 或者 [^JM] 需要用!而不是^来否定一个集合。

### 使用通配符的技巧：

正如所见，SQL 的通配符很有用。但这种功能是有代价的，即通配符搜索一般比前面讨论的其他搜索要耗费更长的处理时间。这里给出一些使用通配符时要记住的技巧。

1. 不要过度使用通配符。如果其他操作符能达到相同的目的，应该使用 其他操作符。
2. 在确实需要使用通配符时，也尽量不要把它们用在搜索模式的开始处。把通配符置于开始处，搜索起来是最慢的。
3. 仔细注意通配符的位置。如果放错地方，可能不会返回想要的数据。

## 创建计算字段

计算字段并不实际存在于数据库表中。计算字段是运行时在 SELECT 语句内创建的。

对于列之间的计算、拼接、去除某些字符等操作。

```SQL
SELECT Concat(vend_name, ' (', Trim(vend_country), ')') AS vend_title
FROM Vendors
ORDER BY vend_name;

SELECT prod_id,
       quantity,
item_price,
       quantity*item_price AS expanded_price
FROM OrderItems
WHERE order_num = 20008;
```

## 使用函数处理数据

大多数 SQL 实现支持以下类型的函数。

1. 用于处理文本字符串(如删除或填充值，转换值为大写或小写)的文本函数。
2. 用于在数值数据上进行算术操作(如返回绝对值，进行代数运算)的数值函数。
3. 用于处理日期和时间值并从这些值中提取特定成分(如返回两个日期之差，检查日期有效性)的日期和时间函数。
4. 返回 DBMS 正使用的特殊信息(如返回用户登录信息)的系统函数。

函数不仅可以用于 SELECT 后面的列名，它还可以作为 SELECT 语句的其他成分，如在 WHERE 子句中使用，在其他 SQL 语句中使用等。

### 常用的文本处理函数

| 函数 |  说明 | 
| --- |  --- | 
| LEFT()(或使用子字符串函数) |  返回字符串左边的字符 | 
| LENGTH()(也使用DATALENGTH()或LEN()) |  返回字符串的长度 | 
| LOWER()(Access使用LCASE()) |  将字符串转换为小写 | 
| LTRIM() |  去掉字符串左边的空格 | 
| RIGHT()(或使用子字符串函数) |  返回字符串右边的字符 | 
| RTRIM() |  去掉字符串右边的空格 | 
| SOUNDEX() |  返回字符串的SOUNDEX值 | 
| UPPER()(Access使用UCASE()) |  将字符串转换为大写 | 

SOUNDEX 是一个将任何文本串转换为描述其语音表示的字母数字模式的算法。SOUNDEX 考虑了类似的发音字符和音节，使得能对字符串进行发音比较而不是字母比较。虽然 SOUNDEX 不是 SQL 概念，但多数 DBMS 都提供对 SOUNDEX 的支持。

### 日期和时间处理函数

通常不一致，具体看使用的数据的文档。

### 数值处理函数

数值处理函数仅处理数值数据。这些函数一般主要用于代数、三角或几何运算，因此不像字符串或日期时间处理函数使用那么频繁。各数据库实现基本一致。

| 函数 | 说明 |
| --- | --- |
| ABS() | 返回一个数的绝对值 |
| COS() | 返回一个角度的余弦 |
| EXP() | 返回一个数的指数值 |
| PI() | 返回圆周率 |
| SIN() | 返回一个角度的正弦 |
| SQRT() | 返回一个数的平方根 |
| TAN() | 返回一个角度的正切 |

## 汇总数据

我们经常需要汇总数据而不用把它们实际检索出来，为此 SQL 提供了专门的函数。使用这些函数，SQL 查询可用于检索数据，以便分析和报表生成。这种类型的检索例子有:

1. 确定表中行数(或者满足某个条件或包含某个特定值的行数);
2. 获得表中某些行的和;
3. 找出表列(或所有行或某些特定的行)的最大值、最小值、平均值。

**聚集函数(aggregate function):** 对某些行运行的函数，计算并返回一个值。

| 函数 | 说明 |
| --- | --- |
| AVG() | 返回某列的平均值 |
| COUNT() | 返回某列的行数 |
| MAX() | 返回某列的最大值 |
| MIN() | 返回某列的最小值 |
| SUM() | 返回某列值之和 |

```SQL
SELECT AVG(prod_price) AS avg_price FROM Products; 
/*
使用 COUNT(*)对表中行的数目进行计数，不管表列中包含的是空值 (NULL)还是非空值;
使用 COUNT(column)对特定列中具有值的行进行计数，忽略 NULL 值。
*/
SELECT COUNT(*) AS num_cust FROM Customers; -- 5
SELECT COUNT(cust_email) AS num_cust FROM Customers; -- 3
# MAX MIN 函数在某些数据库实现里对文本也可使用，返回排序的第一个/最后一个

SELECT SUM(quantity) AS items_ordered FROM OrderItems
WHERE order_num = 20005;

SELECT SUM(item_price*quantity) AS total_price FROM OrderItems
WHERE order_num = 20005;
```

**聚集不同值：** 只包含不同的值，指定 DISTINCT 参数。

```SQL
SELECT AVG(DISTINCT prod_price) AS avg_price FROM Products
WHERE vend_id = 'DLL01';
```

**组合聚集函数:**

目前为止的所有聚集函数例子都只涉及单个函数。但实际上，SELECT 语句可根据需要包含多个聚集函数.

```SQL
SELECT COUNT(*) AS num_items,
       MIN(prod_price) AS price_min,
       MAX(prod_price) AS price_max,
       AVG(prod_price) AS price_avg
 FROM Products;
```

## 分组数据

分组数据：用于汇总表内容的子集。使用分组可以将数据分为多个逻辑组， 对每个组进行聚集计算。例如：统计每个省份城市的数量。
这涉及两个新SELECT 语句子句: `GROUP BY` 子句和 `HAVING` 子句。

**GROUP BY 子句指示 DBMS 分组数据，然后对每个组而不是整 个结果集进行聚集。**

在使用GROUP BY子句前，需要知道一些重要的规定。
1. GROUP BY 子句可以包含任意数目的列，因而可以对分组进行嵌套，更细致地进行数据分组。
2. 如果在 GROUP BY 子句中嵌套了分组，数据将在最后指定的分组上进行汇总。换句话说，在建立分组时，指定的所有列都一起计算(所以不能从个别的列取回数据)。
3. GROUP BY 子句中列出的每一列都必须是检索列或有效的表达式(但不能是聚集函数)。如果在 SELECT 中使用表达式，则必须在 GROUP BY 子句中指定相同的表达式。不能使用别名。
4. 大多数 SQL 实现不允许 GROUP BY 列带有长度可变的数据类型(如文本或备注型字段)。
5. 除聚集计算语句外，SELECT 语句中的每一列都必须在 GROUP BY 子句中给出。
6. 如果分组列中包含具有 NULL 值的行，则 NULL 将作为一个分组返回。 如果列中有多行 NULL 值，它们将分为一组。
7. **GROUP BY子句必须出现在WHERE子句之后，ORDER BY子句之前。**

```SQL
SELECT vend_id, COUNT(*) AS num_prods
FROM Products
GROUP BY vend_id;
```

**WHERE 过滤行，而 HAVING 过滤分组。过滤的语法和之前介绍的一样。**

```SQL
SELECT cust_id, COUNT(*) AS orders FROM Orders
GROUP BY cust_id
HAVING COUNT(*) >= 2;
```

**HAVING 和 WHERE 的差别：**

这里有另一种理解方法，WHERE 在数据分组前进行过滤，HAVING 在数据分组后进行过滤。这是一个重要的区别，WHERE 排除的行不包括在分组中。这可能会改变计算值，从而影响 HAVING 子句中基于这些值过滤掉的分组。

```SQL
SELECT vend_id, COUNT(*) AS num_prods FROM Products
WHERE prod_price >= 4
GROUP BY vend_id
HAVING COUNT(*) >= 2;
```

**GROUP BY 和 ORDER BY 区别：**

| ORDER BY | GROUP BY |
| --- | --- |
| 对产生的输出排序 | 对行分组，但输出可能不是分组的顺序 |
| 任意列都可以使用(甚至非选择的列也可以使用) | 只可能使用选择列或表达式列，而且必须使用每个选择列表达式 |
| 不一定需要 | 如果与聚集函数一起使用列(或表达式)，则必须使用 |

一般在使用 GROUP BY 子句时，应该也给出 ORDER BY 子句。这是保 证数据正确排序的唯一方法。千万不要仅依赖GROUP BY排序数据。

**SELECT子句及其顺序：**

| 子句 | 说明 | 是否必须使用 |
| --- | --- | --- |
| SELECT | 要返回的列或表达式 | 是 |
| FROM | 从中检索数据的表 | 仅在从表选择数据时使用 |
| WHERE | 行级过滤 | 否 |
| GROUP BY | 分组说明 | 仅在按组计算聚集时使用 |
| HAVING | 组级过滤 | 否 |
| ORDER BY | 输出排序顺序 | 否 |


## 使用子查询

SQL 还允许创建子查询(subquery)，即嵌套在其他查询中的查询。

注意：作为子查询的 SELECT 语句只能查询单个列。企图检索多个列将返回错误。

### 利用子查询进行过滤

```SQL
FROM Customers
WHERE cust_id IN (
    SELECT cust_id FROM Orders WHERE order_num IN (
        SELECT order_num FROM OrderItems WHERE prod_id = 'RGAN01'
    )
);
```

### 创建计算字段

```SQL
SELECT cust_name, cust_state, (
        SELECT COUNT(*)
        FROM Orders
        WHERE Orders.cust_id = Customers.cust_id
    ) AS orders
FROM Customers
ORDER BY cust_name;
```

## 联结表

将数据分解为多个表能更有效地存储，更方便地处理。问题：如果数据存储在多个表中，怎样用一条 SELECT 语句就检索出数据呢?

答案是使用联结。简单说，联结是一种机制，用来在一条 SELECT 语句 中关联表，因此称为联结。使用特殊的语法，可以联结多个表返回一组 输出，联结在运行时关联表中正确的行。

**联结不是物理实体。换句话说，它在实际的数据库表 中并不存在。DBMS 会根据需要建立联结，它在查询执行期间一直存在。**

```SQL
SELECT vend_name, prod_name, prod_price FROM Vendors, Products
WHERE Vendors.vend_id = Products.vend_id;

SELECT vend_name, prod_name, prod_price FROM Vendors INNER JOIN Products
ON Vendors.vend_id = Products.vend_id;
```

SQL 不限制一条 SELECT 语句中可以联结的表的数目。创建联结的基本规则也相同。首先列出所有表，然后定义表之间的关系。

```SQL
SELECT prod_name, vend_name, prod_price, quantity FROM OrderItems, Products, Vendors
WHERE Products.vend_id = Vendors.vend_id
AND OrderItems.prod_id = Products.prod_id AND order_num = 20007;
```

## 创建高级联结

迄今为止，我们使用的只是内联结或等值联结的简单联结。现在来看三种其他联结:自联结(self-join)、自然联结(natural join)和外联结(outer join)。

### 自联结

```SQL
SELECT cust_id, cust_name, cust_contact FROM Customers
WHERE cust_name = (SELECT cust_name
 FROM Customers
WHERE cust_contact = 'Jim Jones');

SELECT c1.cust_id, c1.cust_name, c1.cust_contact FROM Customers AS c1, Customers AS c2
WHERE c1.cust_name = c2.cust_name
AND c2.cust_contact = 'Jim Jones';

SELECT c1.cust_id, c1.cust_name, c1.cust_contact FROM Customers AS c1 
JOIN Customers AS c2 
    ON c1.cust_name = c2.cust_name AND c2.cust_contact = 'Jim Jones';
```

### 自然联结

无论何时对表进行联结，应该至少有一列不止出现在一个表中(被联结的列)。标准的联结(前一课中介绍的内联结)返回所有数据，相同的列甚至多次出现。自然联结排除多次出现，使每一列只返回一次。

```SQL
SELECT C.*, O.order_num, O.order_date, OI.prod_id, OI.quantity, OI.item_price
FROM Customers AS C, Orders AS O, OrderItems AS OI WHERE C.cust_id = O.cust_id
AND OI.order_num = O.order_num AND prod_id = 'RGAN01';
```

### 外联结

许多联结将一个表中的行与另一个表中的行相关联，但有时候**需要包含没有关联行的那些行。**

```SQL
# 内联结
SELECT Customers.cust_id, Orders.order_num FROM Customers INNER JOIN Orders
ON Customers.cust_id = Orders.cust_id;

# 外联结
SELECT Customers.cust_id, Orders.order_num FROM Customers LEFT OUTER JOIN Orders
ON Customers.cust_id = Orders.cust_id;
SELECT Customers.cust_id, Orders.order_num FROM Customers RIGHT OUTER JOIN Orders
ON Orders.cust_id = Customers.cust_id;
```

在使用 OUTER JOIN 语法时，必须使用 RIGHT 或 LEFT 关键字指定包括其所有行的表(RIGHT 指出的是 OUTER JOIN 右边的表，而 LEFT 指出的是 OUTER JOIN 左边的表)。

### 使用带聚集函数的联结

```SQL
SELECT Customers.cust_id, COUNT(Orders.order_num) AS num_ord
FROM Customers LEFT OUTER JOIN Orders ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;
```

### 使用联结和联结条件

在总结讨论联结的这两课前，有必要汇总一下联结及其使用的要点。

1. 注意所使用的联结类型。一般我们使用内联结，但使用外联结也有效。
2. 关于确切的联结语法，应该查看具体的文档，看相应的 DBMS 支持何种语法(大多数 DBMS 使用这两课中描述的某种语法)。
3. 保证使用正确的联结条件(不管采用哪种语法)，否则会返回不正确的数据。
4. 应该总是提供联结条件，否则会得出笛卡儿积。
5. 在一个联结中可以包含多个表，甚至可以对每个联结采用不同的联结类型。虽然这样做是合法的，一般也很有用，但应该在一起测试它们前分别测试每个联结。这会使故障排除更为简单。

## 组合查询

利用 UNION 操作符将多条 SELECT 语句组合成一个结果集。

主要有两种情况需要使用组合查询:

1. 在一个查询中从不同的表返回结构数据;
2. 对一个表执行多个查询，按一个查询返回数据。

```SQL
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';
```

### UNION规则

1. UNION 必须由两条或两条以上的 SELECT 语句组成，语句之间用关键字 UNION 分隔(因此，如果组合四条 SELECT 语句，将要使用三个 UNION 关键字)。
2. UNION 中的每个查询必须包含相同的列、表达式或聚集函数(不过，各个列不需要以相同的次序列出)。
3. 列数据类型必须兼容:类型不必完全相同，但必须是 DBMS 可以隐含转换的类型(例如，不同的数值类型或不同的日期类型)。

UNION 从查询结果集中自动去除了重复的行;换句话说，它的行为与一 条 SELECT 语句中使用多个 WHERE 子句条件一样。
这是 UNION 的默认行为，如果愿意也可以改变它。事实上，如果想返回 所有的匹配行，可使用UNION ALL而不是UNION。

### 对组合查询结果排序

SELECT 语句的输出用 ORDER BY 子句排序。在用 UNION 组合查询时，只 能使用一条 ORDER BY 子句，它必须位于最后一条 SELECT 语句之后。对 于结果集，不存在用一种方式排序一部分，而又用另一种方式排序另一部分的情况，因此不允许使用多条ORDER BY子句。

```SQL
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
UNION
SELECT cust_name, cust_contact, cust_email FROM Customers
WHERE cust_name = 'Fun4All'
ORDER BY cust_name, cust_contact;
```
