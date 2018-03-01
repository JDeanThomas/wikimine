library(tm)
library(slam)
library(plyr)
library(data.table)
library(parallel)
library(ngramrr)
library(foreach)
library(tau)
library(magrittr)
library(RWeka)
library(stringi)
library(ggplot2)
library(scales)


#load function scripts in dir
sapply(list.files(pattern="[.]R$", path="R/", full.names=TRUE), source)

#load function script dirrectly
if(!exists("NgramFuc", mode="function")) source("NgramFunc.R")

# write TDM -> matrix -> data.frame

# write TDM to matrix first (~1/3+ inflation in size)
triMatrix <- inspect(en.tritdm)
# write maxtix (~2.5% infation in size from matrix)
triDF <- as.data.frame(triMatrix, stringsAsFactors = FALSE)
# print table (attempts to coerce to matrix or DF, not for class TDM)
write.table(triDF)

# sparse matrix (compacts matrix to ~13% of original size), but different class. 
#Size becomes identical if sparcity = .5, 2X if Sparcity = 0
require(Matrix)
triMatrix <- inspect(en.bitdm)
triMatrix <- Matrix(sparse=TRUE)

# SLAM simple_triplet_matrix usually more efficent than class Matrix


counts <- rowapply_simple_triplet_matrix(en.tritdm, sum)
tdmDT <- data.table(term = Terms(en.tritdm), cnt = counts)


options(mc.cores=1)

cores <- detectCores()
options(mc.cores=7)

# Theoretically I can forace a text file corpus (one sentence per line)
#   into a TDM and pre-process in one call. Might be more efficent. 
#           ALT
# Creat a term frequencey vector termFreq of nGrams from class TextDocument
#   Tokenization function is called on construction, pre-processing can be
#   handled on termFreq creation as well

system.time(TXT <-Corpus(VectorSource(txt)))
# parallizes nicely. test individual calls. Build function?
            system.time(TXT <- tm_map(TXT, content_transformer(tolower)) )
            #system.time(TXT <- tm_map(TXT, removePunctuation) )
            #system.time(TXT <- tm_map(TXT, removeNumbers) )
            #system.time(TXT <- tm_map(TXT, removeWords, stopwords("english")) )
            system.time(TXT <- tm_map(TXT, stripWhitespace) )

system.time(Twitter <-Corpus(VectorSource(twitterSample)))
# parallizes nicely. test individual calls. Build function?
system.time(Twitter <- tm_map(Twitter, content_transformer(tolower)) )
system.time(Twitter <- tm_map(Twitter, stripWhitespace) )
#system.time(Twitter <- tm_map(Twitter, removeNumbers) )


# tokenizer trials  

#myfunc with RWeka (not parallel)
system.time(dttf <- NgramFunc(Twitter, 3))

system.time(NewsDF <- NgramFunc(News, 3))

# in progress NLP tokenizer hack
system.time(dttf <- NgramFunc(WIKI, 3))

#RTextTools alt
matrix <- create_matrix(WIKI2, ngramLength=1)

create_matrix(textColumns, language="english", minDocFreq=1, maxDocFreq=Inf, 
              minWordLength=3, maxWordLength=Inf, ngramLength=1, originalMatrix=NULL, 
              removeNumbers=FALSE, removePunctuation=TRUE, removeSparseTerms=0, 
              removeStopwords=TRUE,  stemWords=FALSE, stripWhitespace=TRUE, toLower=TRUE, 
              weighting=weightTf)r

#tau still maybe an optiont. Look into textcnt options
system.time(sapply(WIKI2, textcnt, method = "ngram"))

# ngramrr works, and parallel. Works with VCorpus
#   Store Ngram counts in one vector of vector by count?
#   Order count by dcending ordder?


system.time(wikiTDM <- TermDocumentMatrix(wiki, control = list(tokenize = function(x) ngramrr(x, ngmax = 4))))





    options(mc.cores=4)
system.time(tddf  <- loadNGram(enall, 1))
system.time(tddf2 <- pasteNGram(enall, 2))
system.time(tddf3 <- pasteNGram(corpfiles, 3))
system.time(tddf4 <- pasteNGram(corpfiles, 4))

typeof(biMatrix)
class(biMatrix)


# takes a list of TermDocumentMatrices and gives word count for all of them in dataframes and rbinds everything.
combineddf <- do.call(rbind, lapply(tdm_list, function (x) {
    data.frame(apply(x, 1, sum))
}))
takes a list of TermDocumentMatrices and gives word count for all of them in dataframes and rbinds everything.

install.packages(c("devtools", "NLP", "tm", "RWeka", "stringi", "ggplot2", "scales", 
    "slam","plyr", "dplyr", "RTextTools", "caret", "markovchain", "data.table", "XML", 
    "GridExtra", "tm.plugin.dc", "tm.plugin.webmining", "magrittr", "doMC",
    "doSnow", "doParallel", "snowfall", "Rcmdr", "RcmdrPlugin.temis", "foreach", 
    "tau", "ngrammr", "scales", "tidyr", "Shiny", "packrat", "Leaflet", "DT",
    "knitr", "Haven", "readxl", "ggvis", "shinydashboards", "htmlwidgets", "lubridate",
    "rgl", "network3D", "threeJS", "googleVis", "car", "mgcv", "lme4", "nlme",
    "vcd", "glmnet", "maptools", "maps", "ggmaps", "zoo", "xts", "quantmod",
    "XML", "httr", "rjson", "RSQLite", "xlsx", "reshape", "reshape", "rJava", "Rcurl",
    "randomForrest", "e1071", "mcgv", "RcppEigen", "SparseM", "manipulate", "RColorBrewer",
    "colorspace", "reshape2", "labeling"), type="source", clean=TRUE)
