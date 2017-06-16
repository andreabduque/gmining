import pandas as pd
from Corpus import Corpus
from View import View

#Reading Corpus metadata and getting corpus files paths
meta = pd.read_csv("metadata.csv", sep=",")
corpus = Corpus("newCorpus", meta, choice='clean')
corpus.saveCorpus()
corpusMeta, corpusFiles = corpus.getCorpus()

#Create a view from a Clean Corpus
feature = View(corpusMeta, corpusFiles)

#Term Document Matrices
# feature.createTDM(featureType='lemma', stopWords=True)
# feature.createTDM(featureType='lemma', stopWords=False)
#
# feature.createTDM(featureType='standard', stopWords=True)
# feature.createTDM(featureType='standard', stopWords=False)

feature.createFDM(featureType='lemma', stopWords=True)
feature.createFDM(featureType='lemma', stopWords=False)

feature.createFDM(featureType='standard', stopWords=True)
feature.createFDM(featureType='standard', stopWords=False)
