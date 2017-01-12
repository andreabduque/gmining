library(dplyr)
library(stringr)
library(gutenbergr)
library(tibble)
library(tm)

#Script which creates a corpus from gutenberg

#Setting working Directory
dir <- "/home/abd/Documentos/gutenberg-mining"
setwd(dir)

source("R/download-utils.R")

#Reading list of books to be downloaded
books <- read.table("data/book_dataset.csv", stringsAsFactors=F, row.names=NULL, sep = ',', header = TRUE)
#Get books metadata
metadata_books <- mapply(download_book_metadata, books$Author, books$Title)
#Get books content
content_books <- download_books(metadata_books[1,])

#Make the corpus
myCorpus <- gutenberg_corpus(content_books, metadata_books)

save(myCorpus, file = "data/corpus2.RData")
