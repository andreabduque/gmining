library(readxl)
library(XML)
library(parallel)
path_list <- c("all/small")
dir <- DirSource(path_list)

#https://rpubs.com/msundar/large_data_analysis

setwd("/home/abd/corpora/corpus-SHC/all")

shc_metadata <- read_excel("/home/abd/corpora/corpus-SHC/SHC_Playlist.xlsx")

all_files <- lapply(shc_metadata$filenumber, function(x) {
              algo <- paste0(x, ".xml")
              return(algo)
              } )

all_tokens <- mclapply(all_files, function(x){
                if(file.exists(x)){
                  doc <- xmlInternalTreeParse(x)
                  # tokens <- xpathApply(doc, "//*[@lemma]", xmlGetAttr, "lemma")
                }
                else{
                  tokens <- NULL
                }
                
                return(tokens)
              }, mc.cores=3)

