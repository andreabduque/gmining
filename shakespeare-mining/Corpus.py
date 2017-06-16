import pandas as pd
# from nltk.corpus import MTECorpusReader

class Corpus:
    #Receives path of the folder containing the files and a pandas dataset metadata
    def __init__(self, folder, metadata, choice='clean'):
        self.folder = folder
        self.metadata = metadata
        #The set of the metadata desired to make a corpus
        self.setMeta = metadata

        if(choice == 'clean'):
            self.makeCleanCorpus()

    #Excluded from the analysis:
    #-Shared Plays, Unknown and Uncertain
    #-Plays without genre
    #Authors with less than 5 works
    def makeCleanCorpus(self):
        #Drop plays without genre
        df = self.metadata[pd.notnull(self.metadata['genre'])]
        #Keep only single author plays
        df = df.loc[df['author'].map(lambda x: ';' not in x and '(?)' not in x and 'anon.' not in x)]
        #Keep only authors with more than 5 works
        count = df.groupby(['author']).count()
        subgroup = count[count['title'] > 5]
        df = df.loc[df['author'].map(lambda x: x in subgroup.index)]

        #Here we have a small set from the huge corpus
        self.setMeta = df

        # self.makeCorpus()
        #Make the corpus!
        return self

    def getCorpus(self):
        return self.setMeta, self.setMeta.apply(lambda row: self.folder + "/" + row['filenumber'] + '.csv', axis=1).tolist()

    def saveCorpus(self):
        self.setMeta.to_csv("setMeta.csv", sep=',')



    #Exclude from the analysis:
    #-Plays without genre
    def makeCorpusWithoutMissingGenre(self):
        pass
    #makes the corpus using setMeta
    # def makeCorpus(self):
    #     #pega a coluna e da ''.join(lista) e manda assim mermo.
    #     # MTECorpusReader('/home/abd/Workspace/gmining/shakespeare-mining', '.*\.xml')
    #
    #     #pra cada arquivo, ver se ta no dataset. se tiver le esta merda
    #     self.setMeta['filenumber'].apply(lambda x: print(x))
