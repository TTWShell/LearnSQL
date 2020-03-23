# [https://sqlzoo.net/wiki/NSS_Tutorial](https://sqlzoo.net/wiki/NSS_Tutorial)

| Field | Type |
| --- | --- |
| ukprn | varchar(8) |
| institution | varchar(100) |
| subject | varchar(60) |
| level | varchar(50) |
| question | varchar(10) |
| A_STRONGLY_DISAGREE | int(11) |
| A_DISAGREE | int(11) |
| A_NEUTRAL | int(11) |
| A_AGREE | int(11) |
| A_STRONGLY_AGREE | int(11) |
| A_NA | int(11) |
| CI_MIN | int(11) |
| score | int(11) |
| CI_MAX | int(11) |
| response | int(11) |
| sample | int(11) |
| aggregate | char(1) |

## National Student Survey 2012

The National Student Survey http://www.thestudentsurvey.com/ is presented to thousands of graduating students in UK Higher Education. The survey asks 22 questions, students can respond with STRONGLY DISAGREE, DISAGREE, NEUTRAL, AGREE or STRONGLY AGREE. The values in these columns represent PERCENTAGES of the total students who responded with that answer.

The table nss has one row per institution, subject and question.


## Contents

### 1. Check out one row

The example shows the number who responded for:

question 1
at 'Edinburgh Napier University'
studying '(8) Computer Science'
Show the the percentage who STRONGLY AGREE

```SQL
SELECT A_STRONGLY_AGREE FROM nss
WHERE 
    question = 'Q01'
   AND institution = 'Edinburgh Napier University'
   AND subject = '(8) Computer Science';
```

### 2. Calculate how many agree or strongly agree

Show the institution and subject where the score is at least 100 for question 15.

```SQL
SELECT institution, subject FROM nss WHERE question='Q15' AND score >= 100;
```

### 3. Unhappy Computer Students

Show the institution and score where the score for '(8) Computer Science' is less than 50 for question 'Q15'

```SQL
SELECT institution,score FROM nss
WHERE 
    question = 'Q15'
    AND score < 50
    AND subject = '(8) Computer Science';
```

### 4. More Computing or Creative Students?

Show the subject and total number of students who responded to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.

HINT
You will need to use SUM over the response column and GROUP BY subject

```SQL
SELECT subject, SUM(response) FROM nss
WHERE 
    question='Q22'
    AND subject IN ('(8) Computer Science', '(H) Creative Arts and Design')
GROUP BY subject;
```

### 5. Strongly Agree Numbers

Show the subject and total number of students who A_STRONGLY_AGREE to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.

HINT
The A_STRONGLY_AGREE column is a percentage. To work out the total number of students who strongly agree you must multiply this percentage by the number who responded (response) and divide by 100 - take the SUM of that.

```SQL
SELECT subject, SUM(A_STRONGLY_AGREE/100*response) FROM nss
WHERE 
    question = 'Q22'
    AND subject IN ('(8) Computer Science', '(H) Creative Arts and Design')
GROUP BY subject;
```

### 6. Strongly Agree, Percentage

Show the percentage of students who A_STRONGLY_AGREE to question 22 for the subject '(8) Computer Science' show the same figure for the subject '(H) Creative Arts and Design'.

Use the ROUND function to show the percentage without decimal places.

```SQL
SELECT subject,
    ROUND(SUM(A_STRONGLY_AGREE * response) / SUM(response), 0)
FROM nss
WHERE 
    question = 'Q22'
    AND subject IN ('(8) Computer Science', '(H) Creative Arts and Design')
GROUP BY subject;
```

### 7. Scores for Institutions in Manchester

Show the average scores for question 'Q22' for each institution that include 'Manchester' in the name.

The column score is a percentage - you must use the method outlined above to multiply the percentage by the response and divide by the total response. Give your answer rounded to the nearest whole number.

```SQL
SELECT institution,
    ROUND(SUM(score * response) / SUM(response), 0)
FROM nss
WHERE  
    question = 'Q22'
    AND institution LIKE '%Manchester%'
GROUP BY institution;
```

### 8. Number of Computing Students in Manchester

Show the institution, the total sample size and the number of computing students for institutions in Manchester for 'Q01'.

```SQL
SELECT institution,
    SUM(sample),
    SUM(
        CASE WHEN subject = '(8) Computer Science' THEN sample
        ELSE 0 END
    )
FROM nss
WHERE  
    institution LIKE '%Manchester%'
    AND question = 'Q01'
GROUP BY institution;  
```
