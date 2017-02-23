library(dplyr)
library(stringr)
library(gutenbergr)
library(tm)
library(NLP)

stemCompletion2 <- function(x, dictionary) {
  x <- unlist(strsplit(as.character(x), " "))
  # Unexpectedly, stemCompletion completes an empty string to
  # a word in dictionary. Remove empty string to avoid above issue.
  x <- x[x != ""]
  x <- stemCompletion(x, dictionary=dictionary)
  x <- paste(x, sep="", collapse=" ")
  PlainTextDocument(stripWhitespace(x))
}

get_authors_list <- function(myCorpus){

  authors_list <- mapply(meta, myCorpus, "author")

  return(authors_list)

}

get_titles_list <- function(myCorpus){
  titles_list <- mapply(meta, myCorpus, "title")
  return(titles_list)
}
