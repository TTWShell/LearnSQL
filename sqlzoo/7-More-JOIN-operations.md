# [https://sqlzoo.net/wiki/More_JOIN_operations](https://sqlzoo.net/wiki/More_JOIN_operations)


movie
id	title	yr	director	budget	gross 

actor
id	name 

casting
movieid	actorid	ord

![https://sqlzoo.net/w/images/5/50/Movie2-er.png](https://sqlzoo.net/w/images/5/50/Movie2-er.png)

[More details about the database.](https://sqlzoo.net/wiki/More_details_about_the_database.)

## 题目

### 1. 1962 movies

List the films where the yr is 1962 [Show id, title]

```SQL
SELECT id, title FROM movie WHERE yr = 1962;
```

### 2. When was Citizen Kane released?

Give year of 'Citizen Kane'.

```SQL
SELECT yr FROM movie WHERE title = 'Citizen Kane';
```

### 3. Star Trek movies

List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.

```SQL
SELECT id, title, yr FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;
```

### 4. id for actor Glenn Close

What id number does the actor 'Glenn Close' have?

```SQL
SELECT id FROM actor WHERE name = 'Glenn Close';
```

### 5. id for Casablanca

What is the id of the film 'Casablanca'

```SQL
SELECT id FROM movie WHERE title = 'Casablanca';
```

### 6. Cast list for Casablanca

Obtain the cast list for 'Casablanca'.

what is a cast list?
The cast list is the names of the actors who were in the movie.

Use movieid=11768, (or whatever value you got from the previous question)

```SQL
SELECT actor.name FROM actor
JOIN casting ON casting.actorid = actor.id 
WHERE casting.movieid=11768;
```

### 7. Alien cast list

Obtain the cast list for the film 'Alien'

```SQL
SELECT actor.name FROM actor
JOIN casting ON casting.actorid = actor.id 
WHERE casting.movieid=(SELECT id FROM movie WHERE title = 'Alien');

SELECT actor.name FROM actor
JOIN casting ON casting.actorid = actor.id
JOIN movie ON casting.movieid = movie.id
WHERE movie.title = 'Alien';
```

### 8. Harrison Ford movies

List the films in which 'Harrison Ford' has appeared

```SQL
SELECT movie.title FROM movie
JOIN casting ON casting.movieid = movie.id
JOIN actor ON actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford';
```

### 9. Harrison Ford as a supporting actor

List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

```SQL
SELECT movie.title FROM movie
JOIN casting ON casting.movieid = movie.id
JOIN actor ON actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford' AND casting.ord != 1;
```

### 10. Lead actors in 1962 movies

List the films together with the leading star for all 1962 films.

```SQL
SELECT movie.title, actor.name FROM movie
JOIN casting ON casting.movieid = movie.id
JOIN actor ON actor.id = casting.actorid
WHERE movie.yr = 1962 AND casting.ord = 1;
```

### 11. Busy years for Rock Hudson

Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

```SQL
SELECT movie.yr, COUNT(movie.title) FROM movie 
JOIN casting ON movie.id=casting.movieid
JOIN actor ON casting.actorid=actor.id
WHERE actor.name='Rock Hudson'
GROUP BY movie.yr
HAVING COUNT(movie.title) > 2;
```

### 12. Lead actor in Julie Andrews movies

List the film title and the leading actor for all of the films 'Julie Andrews' played in.

Did you get "Little Miss Marker twice"?
Julie Andrews starred in the 1980 remake of Little Miss Marker and not the original(1934).

Title is not a unique field, create a table of IDs in your subquery

```SQL
SELECT DISTINCT movie.title, actor.name FROM movie
JOIN casting ON movie.id=casting.movieid
JOIN actor ON casting.actorid=actor.id
WHERE casting.ord = 1 AND casting.movieid IN (
    SELECT movieid FROM casting 
    WHERE actorid = (
        SELECT id FROM actor WHERE name='Julie Andrews'
    )
) 
ORDER BY movie.title;

SELECT DISTINCT m.title, a.name FROM (
    SELECT movie.* FROM movie 
    JOIN casting ON casting.movieid = movie.id
    JOIN actor ON actor.id = casting.actorid
    WHERE actor.name = 'Julie Andrews' 
) AS m JOIN (
    SELECT actor.name, casting.movieid FROM actor 
    JOIN casting ON casting.actorid = actor.id 
    WHERE casting.ord = 1
) AS a ON a.movieid = m.id
ORDER BY m.title;
```

### 13. Actors with 15 leading roles

Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.

```SQL
SELECT actor.name FROM actor
JOIN casting ON casting.actorid = actor.id 
WHERE casting.ord = 1 
GROUP BY actor.name
HAVING COUNT(casting.movieid) >= 15
ORDER BY actor.name;
```

### 14.

List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

```SQL
SELECT movie.title, COUNT(casting.actorid) FROM movie
JOIN casting ON casting.movieid = movie.id
WHERE movie.yr = 1978
GROUP BY movie.title
ORDER BY COUNT(casting.actorid) DESC, movie.title;
```

### 15.

List all the people who have worked with 'Art Garfunkel'.

```SQL
SELECT DISTINCT m.name FROM (
    SELECT movie.id, actor.name FROM movie
    JOIN casting ON casting.movieid = movie.id
    JOIN actor ON actor.id = casting.actorid
    WHERE actor.name != 'Art Garfunkel'
) AS m JOIN (
    SELECT actor.name, casting.movieid FROM casting
    JOIN actor ON casting.actorid = actor.id
    WHERE actor.name = 'Art Garfunkel'
) AS a ON a.movieid = m.id;
```
