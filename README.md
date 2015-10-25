# Hacker News Top Keywords
This code tries to make some sense of the most commonly used words in Hacker News titles. This also provides metrics around the average score for titles containing that word, and the median score for titles containing that word.

# Installation
There is no need to run any of the code - the results are already in git.

If you would like to reproduce these results:

1. Export the stories table from fh-bigquery:hackernews to csv  (https://bigquery.cloud.google.com/table/fh-bigquery:hackernews.stories?pli=1)
2. Download the CSV to a local file
3. Copy the dataset to postgres and begin analysis using 

<code>psql -h [your postgres host] -d [your postgres database name] -U [your postgres username] -f analyze_hn.sql</code>
