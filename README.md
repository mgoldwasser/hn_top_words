# Hacker News Top Words
This code tries to make some sense of the most commonly used words in Hacker News titles. This also provides metrics around the average score of titles containing that word, and the median score of titles containing that word.

# Installation
There is no need to run any of the code - the results are part of the repo in hn_top_words.csv

If you would like to reproduce these results:

1. Export the "stories" table from fh-bigquery:hackernews to csv  (https://bigquery.cloud.google.com/table/fh-bigquery:hackernews.stories?pli=1)
2. Download the CSV to a local file called hn.csv
3. Copy the dataset to postgres and begin analysis using the command: 

<code>psql -h [your postgres host] -d [your postgres database name] -U [your postgres username] -f analyze_hn.sql</code>
