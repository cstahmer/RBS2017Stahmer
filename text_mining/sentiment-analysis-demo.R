
# In this script I will go through the basics of sentiment analysis using two
# different packages, sentimentr and RSentiment.
#
# RSentiment is the Stanford NLP wrapper to functions in Java that perform
# sentiment analysis. This needs no introduction.
#
# sentimentr is a package on CRAN created by trinkr
# Github documentation found here:
# https://github.com/trinker/sentimentr
#
# Here is the creator's description of the package:
# "In my own work I need better accuracy than a simple dictionary lookup; something 
# that considers valence shifters yet optimizes speed which the Stanford's parser 
# does not. This leads to a trade off of speed vs. accuracy. Simply, sentimentr 
# attempts to balance accuracy and speed."
#
# Andoni



# RSentiment --------------------------------------------------------------

# This is the Stanford NLP approach to sentiment analysis. Note that this 
# is a wrapper to Java functions, which introduces other possibilities for
# error. It also runs relatively slowly on large datasets. Unfortunately, we
# are working here with a large dataset. In any case, it is up to you which
# method you want to choose. Stanford NLP is the gold standard of NLP today.

# This method takes a couple steps to get a text ready for processing.
# Say you have convered your pdf to text already. You can read in the text
# and perform sentiment analysis by sentence as such.


###################################
#         configuration           #
###################################

# set working directory
setwd("~/RBSDigitalApproaches/RBS2017Stahmer/text_mining/")

# set the file path
var_filePath_character = "data/plain_text/emerson.txt"

###################################
#        Operational Code         #
###################################

packages = c('RSentiment')
invisible( lapply(packages, function(pkg) {
  if (require(pkg, character.only = TRUE, quietly = TRUE)) return()
  else install.packages(pkg, quiet = TRUE)
} ))
library(RSentiment)

# load the file to be analized into a character vector
# the resulting vector will have as many elements as
# lines in the file with the contents of each line
# contained in its own element.
var_textLines_vector <- readLines(var_filePath_character)

# collapse the vector of lines into a single character 
# vector
var_text_string <- paste(var_textLines_vector, collapse = " ")

# now break up into sentences
obj_sentence_annotator = Maxent_Sent_Token_Annotator()
sentence.boundaries = annotate(var_text_string, obj_sentence_annotator)
sentences = var_text_string[sentence.boundaries]

# Now that we broke up our string into sentences, we can apply the sentiment
# analysis functions. Choose one depending on what you want

calculate_sentiment(sentences) # returns categories (positive, negative, ...)

calculate_score(sentences) # returns numbers (1, 5, -2, ...)

# Notice these functions work on vectors. This is important. I'll explain later
# how you can apply these functions on your dataset specifically.


# sentimentr --------------------------------------------------------------

# This is the sentimentr approach to sentiment analysis. It is lightweight, fast
# and accurate. I would suggest using both approaches on your dataset, test the
# accuracy and speed of each, then make your decision on which to go with. Both will
# give you good, consistent results.

packages = c('sentimentr')
invisible( lapply(packages, function(pkg) {
  if (require(pkg, character.only = TRUE, quietly = TRUE)) return()
  else install.packages(pkg, quiet = TRUE)
} ))
library(sentimentr)

# Same as before
pdf = readLines('~/Desktop/faculty-hiring/sample-recommendation-letter.txt')
pdf = paste0(pdf, collapse = ' ')
pdf = gsub('\\t|\\r|\\n', ' ', pdf)
pdf = gsub('\\s+', ' ', pdf)
pdf = trimws(pdf)

# Sentiment analysis by sentence
sentiment(pdf)
# Notice that this returns a data frame. If you want just the column with
# sentiments, use:
#  sentiment(pdf)$sentiment

# Sentiment analysis by document
sentiment_by(pdf, by=NULL)

# That's it! the sentiment() and sentiment_by() functions work on vectors out
# of the box. No prepping needed. If you want to analyze by sentence, use
# sentiment_by(). I like sentiment_by() because it gives you a standard
# deviation as well, and saves you steps if you want to analyze by the entire 
# document. You can always get the sd yourself by doing:
#  sd(sentiment(pdf)$sentiment)

# For your dataset, since it's in a csv, with everything you want to analyze
# in one column, I would do something like this.
data = read.csv('ENTER/FILEPATH/HERE')

calculate_sentiment(data$text)
calculate_score(data$text)

sentiment(data$text)
sentiment_by(data$text, by=NULL)

# Know that the RSentiment functions will assume you are doing sentiment analysis
# by document. If you want to break them up into sentences, you will need to do this
# yourself doing something like this:
break_into_sentences <- function(x){
  var_text_string = as.String(x)
  obj_sentence_annotator = Maxent_Sent_Token_Annotator()
  sentence.boundaries = annotate(var_text_string, obj_sentence_annotator)
  sentences = var_text_string[sentence.boundaries]
}
data$text = lapply(pdf, break_into_sentences)
lapply(data$text, calculate_sentiment)

# The sentimentr function sentiment_by() does this for you, so you don't need to worry
# about breaking it into sentence. It does it implicitly. But you can still use
# sentiment() if you do want to do it by document.


