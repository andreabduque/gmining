import pandas as pd
import numpy as np
import scipy as scp
from bs4 import BeautifulSoup
import os.path
import re

#TO DO
#Differentiate stage and speaker lines

#Word types
unclear_types = {0:"", 1:"unidentified letter", 2:"unidentified punct", 3:"missing word", 4:"missing span"}

def parse(url):
    #Dataframe columns
    original = [] #Column of standardized words
    lemma = []    #Lemmatized words
    unclear_kind = [] #Word quality
    sentence_id = [] #Sentence number
    speakers = []   #Who is talking at the play

    count_unclear = 0
    sentence_marker = 0
    sentence_pointer = ""

    if(os.path.isfile(url)):
        parsed_page = BeautifulSoup(open(url),"xml")

        for word in parsed_page.findAll("w"):
            #Get sentence number
            aux = word.find_next_siblings(unit="sentence")
            if(aux != sentence_pointer):
                #Get new sentence end
                sentence_pointer = aux
                #If end sentence is not found, assume that is the same sentence.
                if(sentence_pointer != []):
                    sentence_marker += 1
            sentence_id.append(sentence_marker)

            #Get speaker
            speaker = word.find_previous("sp")
            if(speaker):
                who = re.split('-', speaker.get("who"))[1]
            else:
                who = ""
            speakers.append(who)

            #Get standardized word
            if(word.choice):
                ori = word.choice.reg.text
            else:
                ori = word.text
            original.append(ori)

            #Get lemma
            lem = word.get('lemma')
            lemma.append(lem)

            #Get word quality
            bad = 0
            if("●" in lem or "●" in ori):
                 bad = 1
            elif("〈…〉" in lem or "〈…〉" in ori):
                 bad = 2
            elif("〈◊〉" in lem or "〈◊〉" in ori):
                 bad = 3
            elif("▪" in lem or  "▪" in ori):
                 bad = 4
            unclear_kind.append(unclear_types[bad])

            if(bad):
                count_unclear += 1
                #Dont include bad word in dataset
                ori = ""
                lem = ""
        #Get defect rate
        defect_rate = float(count_unclear/len(lemma))*100

    return original, lemma, defect_rate, unclear_kind, sentence_id, speakers
