library(dplyr)
library(stringr)
library(gutenbergr)
library(tibble)
library(tm)

#Setting working Directory
dir <- "/home/abd/Documentos/gutenberg-mining"
setwd(dir)

source("R/download-utils.R")

#Download metadata from all shakespeare's books from Gutenberg
shakespeare_metadata <- gutenberg_metadata %>%
  filter(author == "Shakespeare, William",
         language == "en",
         !str_detect(title, "Works"),
         has_text) %>%
  distinct( gutenberg_id, title, author)

#Download all shakespeare's books from Gutenberg and save it in a list of books
#to_download <- shakespeare_metadata %>% distinct(gutenberg_id)

#Download two books of ID 1502 and 1041
to_download <- c(1502,1041)
debug_metadata <- rbind(shakespeare_metadata %>% filter(gutenberg_id == to_download[1]), 
                        shakespeare_metadata %>% filter(gutenberg_id == to_download[2]))


#Download books 
receive <- lapply(to_download, gutenberg_download)
#Keeping only the book content
receive <- lapply(receive, dropdown)

#Creating text Corpus
myCorpus <- Corpus(VectorSource(receive))
#Adding metadata
it <- 0
myCorpus = tm_map(myCorpus, adding_meta <-function(x) {
  it <<- it +1
  meta(x, "author") <- debug_metadata[[it, 3]]
  meta(x, "title") <- debug_metadata[[it,2]]
  meta(x, "id") <- debug_metadata[[it,1]]
  return(x)
})
save(myCorpus, file = "data/corpus.RData")
