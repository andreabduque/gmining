library(XML)

#TO-DO: do this for all books in Folger Corpus folder

doc <- xmlTreeParse("Oth.xml")
title_book <- xmlValue(xpathApply(doc[[1]][[1]][[1]], "//title")[[1]])
