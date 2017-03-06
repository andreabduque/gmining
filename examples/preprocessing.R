library(gmining)
#library(wordcloud)
library(cibm.utils)
library(GGally)
library(intergraph)

#Loading corpus for preprocessing already downloaded from Gutenberg
load("data/corpus_big_random.RData")

myCorpus <- sample(myCorpus)
#Convert to lower case
myCorpus <- tm_map(myCorpus, content_transformer(tolower))

#remove everything that is not a english letter or space
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))

#Stemming Words
copyMyCorpus <- myCorpus
myCorpus <- tm_map(myCorpus, stemDocument)
#Takes a long time
#Return to original
#myCorpus <- lapply(myCorpus, stemCompletion2, dictionary=copyMyCorpus)
#myCorpus <- Corpus(VectorSource(myCorpus))

tdm <- TermDocumentMatrix(myCorpus, control=list(wordLengths=c(1,Inf)))
dtm <- DocumentTermMatrix(myCorpus, control=list(wordLengths=c(1,Inf)))

#Find frequent terms
freq_terms = findFreqTerms(tdm, lowfreq=50)
#rownames(tdm)

#Plot word cloud
#set.seed(142)
#freq <- colSums(as.matrix(dtm))
#wordcloud(names(freq), freq, max.words=150)

freqMatrix <- as.matrix(tdm)
#Jessen-Shannon distance Matrix
distMatrix <- distance(freqMatrix, method = "JS", save.dist = FALSE, col.wise = TRUE, file = NULL)
#Clusters MST-KNN
gmstknn <- mstknn(distMatrix,min.size = 3, verbose = FALSE)
authors_vec <- get_authors_list(myCorpus)
#Labelling vertices by authors
#http://www.shizukalab.com/toolkits/sna/plotting-networks-pt-2
V(gmstknn)$authors= unlist(lapply(authors_vec, function(x){  unlist(strsplit(x, ","))[1]}))
V(gmstknn)$Title = unlist(lapply(get_titles_list(myCorpus), str_replace_all, "(Volume )|(The )|(the )|(of )|(A )|(a )|(Edgar Allan )", ""))
#path <- paste(getwd(),"/figs/results_cluster", sep='')
#png(filename=path)
#plot(gmstknn, vertex.label = 'Title')
#plot(gmstknn)
ggnet2(gmstknn, color = "authors",  palette = "Set2", label = "Title", label.trim = 20, label.alpha = 0.75, label.size = 2.5, node.size = 8, layout.exp = 0.5, label.dist = 3)
#dev.off()
