--First, create the table, called 'hn' in the code below
CREATE TABLE hn (id bigint,
    by varchar,
    score int,
    time int,
    time_ts timestamp,
    title text,
    url varchar,
    text text,
    deleted bool,
    dead bool,
    descendants int,
    author varchar
)
;

-- This copies data from the hn.csv file to the hn table
\COPY hn FROM 'hn.csv' WITH DELIMITER ',' CSV HEADER;

/*
The following median function is taken from the postgresql Wiki
https://wiki.postgresql.org/wiki/Aggregate_Median
*/

CREATE FUNCTION _final_median(anyarray) RETURNS float8 AS $$ 
  WITH q AS
  (
     SELECT val
     FROM unnest($1) val
     WHERE VAL IS NOT NULL
     ORDER BY 1
  ),
  cnt AS
  (
    SELECT COUNT(*) AS c FROM q
  )
  SELECT AVG(val)::float8
  FROM 
  (
    SELECT val FROM q
    LIMIT  2 - MOD((SELECT c FROM cnt), 2)
    OFFSET GREATEST(CEIL((SELECT c FROM cnt) / 2.0) - 1,0)  
  ) q2;
$$ LANGUAGE SQL IMMUTABLE;
 
CREATE AGGREGATE MEDIAN(anyelement) (
  SFUNC=array_append,
  STYPE=anyarray,
  FINALFUNC=_final_median,
  INITCOND='{}'
);

--END MEDIAN FUNCTION


--This is where average and median scores are computed for each word
SELECT token, 
       AVG(LEAST(score, 200)) avg_score, --the average score. Scores are capped at 200 to prevent outliers from inflating scores. 
       MEDIAN(score) median_score, 
       COUNT(*) word_count
FROM (
    SELECT unnest(STRING_TO_ARRAY(regexp_replace(lower(title), '[^a-z0-9 ]+', ' ', 'g'), ' ')) token, 
           score
    FROM hn
    WHERE title IS NOT NULL
    AND COALESCE(dead, FALSE) != True
    AND COALESCE(deleted, FALSE) != True
) s
GROUP BY 1
HAVING COUNT(*) > 30 --the word needs to appear a minimum of 30 times, this helps ensure some level of statistical certainty
ORDER BY 2 DESC
LIMIT 1000 --the query is limited to the top thousand words, but this clause can be removed for a more comprehensive list
;

