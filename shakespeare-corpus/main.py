import pandas as pd
import numpy as np
import scipy as scp
# from bs4 import BeautifulSoup
import glob, os, re
from parseTEI import parse

#Getting SHC corpus
oldMetadata =  pd.read_excel("554-metadata.xlsx")
shcMetadata = pd.read_excel("SHC_Playlist.xlsx")

os.chdir("/home/abd/backup_andrea/all")
allBookIDs = []
allBookFiles = []

for file in glob.glob("*.xml"):
    #Get book ID
    filenumber = re.split('SHC-', file)[1]
    bookID = re.split('.xml', filenumber)[0]
    allBookIDs.append(bookID)
    allBookFiles.append(filenumber)

shcMetadata['filenumber'] = shcMetadata['filenumber'].map(lambda x: re.split('SHC-', x)[1])

# newMetadata = oldMetadata.loc[oldMetadata['playfile'].isin(allBookIDs)]
# newMetadata = newMetadata[["playfile", "author", "author 2", "author 3", "author 4", "author 5", "translator", "title", "genre", "date of writing"]]
#Make new columns
shcMetadata["genre"] = ""
shcMetadata["defect rate"] = ""

for i, book in enumerate(shcMetadata['filenumber']):
    row = oldMetadata.loc[oldMetadata['playfile'] == book]

    if(row["genre"].empty):
        #If ID search fails, find by name
        shcTitle = shcMetadata.loc[i,"title"] + " "
        row = oldMetadata.loc[oldMetadata['title'].map(lambda x: x in shcTitle)]

    #If none of the searches has failed
    if(not row["genre"].empty):
        #Add genre
        shcMetadata.loc[i,"genre"] = row["genre"].values[0]
        allAuthors = []
        for c in [ "author", "author 2", "author 3", "author 4", "author 5"]:
            if(not pd.isnull(row[c]).values[0]):
                allAuthors.append(row[c].values[0] + "; ")

        #It is what it is
        everybody = ''.join(allAuthors)
        if(everybody[-1] == " "):
            everybody = everybody[:-1]
            if(everybody[-1] == ";"):
                everybody = everybody[:-1]

        shcMetadata.loc[i, "author"] =  everybody

        #Now that we have some metadata, lets parse the files and make more data
        print("SHC-" + book + ".xml")
        original, lemma, defect_rate, unclear_kind, sentence_id, speakers = parse("SHC-" + book + ".xml")

        if(original and lemma):
            #Put defect rate in metadata
            shcMetadata.loc[i, "defect rate"] =  round(defect_rate,2)
            #Make book dataframe
            df = pd.DataFrame(data={'standard': original, 'lemma': lemma,
                                    'sentence number': sentence_id,
                                    'speaker': speakers, 'unclear': unclear_kind})
            df.to_csv("/home/abd/backup_andrea/all/parsed/SHC-" + book + ".csv", sep=',')
        else:
            print("SHC-" + book + ".xml" + " does not exist. Remove from metadata.")
        break

shcMetadata.to_csv("shc_new.csv", sep=',')

# notFound = list(set(allBookIDs) -  set(newMetadata["playfile"]))
#To DO
#Search shakespeare by title
#duas categorias: unknown (tem anon) e uncertain (tem mais de um autor e tem (?) junto) e shared (disputed)
#N authors
#status: unknown, uncertain, shared, single
