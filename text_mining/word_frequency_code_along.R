# load required library
library(tm)

# set working directory
setwd("~/RBSDigitalApproaches/RBS2017Stahmer/text_mining/")

# identify the text file to analyze
text_file = "data/plain_text/mshelley.txt"

# identify the word of interest
word_of_interest = "monster"

# identify a file location to save frequency
# analysis
output_file <-"~/RBSDigitalApproaches/output/word_frequency.csv"

###################################
#        Operational Code         #
###################################

# load the file to be analized into a character vector.
# The resulting vector will have as many elements as
# lines in the file with the contents of each line
# contained in a character vector.
text_lines <- readLines(text_file)

# collapse the vector of lines into a single element
text_blob <- paste(text_lines, collapse = " ")

# change to lowercase
text_lowercase <- tolower(text_blob)

# remove stopwords
text_unstopped <- removeWords(text_lowercase, stopwords('english'))

# use the below line to remove any other tokens
# text_unstopped <- removeWords(text_unstopped, "s")

# convert to a list of words
words_list <- strsplit(text_unstopped, "\\W")

# convert back into a vector
words_vector <- unlist(words_list)

# find any elements that are blank
words_no_blanks  <-  which(words_vector!="")

# create a new vector tha thas no empty elements
cleaned_word_list <-  words_vector[words_no_blanks]

# setup a frequency table
freq_table <- table(cleaned_word_list)

# sort the frequency table
sorted_freq_table <- sort(freq_table , decreasing=T)

# to get freq for given word:
sorted_freq_table["earth"]

# convert to relative frequencies
sorted_relative_freqs <- 100*(sorted_freq_table/sum(sorted_freq_table))

print(sorted_relative_freqs[1:50])

# run the command below in your console to find the 
# relative frequency of any word
print(sorted_relative_freqs["went"])


# plot the word frequencies
num_to_plot <- 10
plot(sorted_relative_freqs[1:num_to_plot], main="Relative Word Frequency", type="b", xlab="Top Ten Words", ylab="Percentage of Full Text", xaxt ="n") 
axis(1, 1:num_to_plot, labels=names(sorted_relative_freqs [1:num_to_plot]))

# save the results to a csv file
write.csv(sorted_freq_table, file = output_file)

# calcuate how many of the total words are
# the word of interest
woi_hits <- length(cleaned_word_list[which(cleaned_word_list==word_of_interest)])

# calculate total word count
total_words <- length(cleaned_word_list)

# calcuate the percentage frequency of the
# word of interest
woi_percent <- 100 * (woi_hits / total_words)

print(paste("The word ", word_of_interest, " comprises ", woi_percent, "percent of the text."))

