## Data Matters 2021: Text Analysis with R
## Activity 1: Read in one text file with metadata and explore it in R

# 1. Read structured text data from a file into R with the readtext package.

install.packages("readtext")
library(readtext)

# 2. Use the ? to learn more about the package
?readtext


# 3. Read data in with the readtext() function
reviews <- readtext("hotelreviews.csv", text_field = "reviews.text", encoding = "utf8")

# 4. Use View() to see the data in a tab
View(reviews)

# 5. Use names() to see the column headers
names(reviews)

# 6. Use str() to see the structure of the dataset and attributes of each column
str(reviews)

# 7. Use $ to look at the contents of a column of data. Look at reviews.title
reviews$reviews.title

# 8. Use unique() to see unique values in a categorical data column, such as city
unique(reviews$city)


## Practice: TED Talks. Use R to read in a file with TED talks from 2017. Answer questions below.

# 9. Practice. Read in the file "ted_talks17.csv"
ted_talks <- readtext("ted_talks17.csv")

# 10. Practice. How many rows and columns does the file have? What data types to the fields have?
str(ted_talks)

# 11. Practice. Use names() to see the column headers.
names(ted_talks)

# 12. Practice. How many unique values for the variable month_filmed are there?
unique(ted_talks$month_filmed)

# 13. Practice. Look at the contents of the description column using the $.
ted_talks$description







