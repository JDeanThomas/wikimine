require(tm)
require(RWeka)
require(parallel)

en <- Corpus(VectorSource(wiki))

enall <- tm_map(en, content_transformer(tolower))
enall <- tm_map(enall, removePunctuation)
enall <- tm_map(enall, removeNumbers)
enall <- tm_map(enall, removeWords, stopwords("english"))
# enall <- tm_map(enall, stemDocument,language = ("english"))
enall <- tm_map(enall, stripWhitespace)

# extract the n-gram for modeling

ctrl <- list(tokenize = words, bounds = list(global = c(1,Inf)))
options(mc.cores=4)
BigramTokenizer <- function(x) {RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 2, max = 2))}
ctrl2 <- list(tokenize = BigramTokenizer, bounds = list(global = c(1,Inf)))
TrigramTokenizer <- function(x) {RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 3, max = 3))}
ctrl3 <- list(tokenize = TrigramTokenizer, bounds = list(global = c(1,Inf)))
en.tdm <- TermDocumentMatrix(enall,control = ctrl)
en.bitdm <- TermDocumentMatrix(enall,control = ctrl2)
en.tritdm <- TermDocumentMatrix(enall,control = ctrl3)

rm(ctrl, ctrl2, ctrl3)

library(slam)
freq <- rowapply_simple_triplet_matrix(en.tdm,sum)
freqbi <- rowapply_simple_triplet_matrix(en.bitdm,sum)
freqtri <- rowapply_simple_triplet_matrix(en.tritdm,sum)
firstname <- sapply(strsplit(names(freqbi), ' '), function(a) a[1])
secname <- sapply(strsplit(names(freqbi), ' '), function(a) a[2])
firsttriname <- sapply(strsplit(names(freqtri), ' '),function(a) a[1])
sectriname <- sapply(strsplit(names(freqtri), ' '),function(a) a[2])
tritriname <- sapply(strsplit(names(freqtri), ' '),function(a) a[3])
# length(words1 <- unique(names(freq)))
# length(words2 <- unique(c(secname,firstname)))
# length(words3 <- unique(c(tritriname,sectriname,firsttriname)))
# length(finalwords3 <- intersect(intersect(words1,words2),words3))
# length(finalwords2 <- intersect(words1,words2))

# get the final n-gram dataframe

unigramDF <- data.frame(names(freq),freq,stringsAsFactors = F)
bigramDF <- data.frame(names(freqbi),freqbi,firstname,secname,stringsAsFactors = F)
trigramDF <- data.frame(names(freqtri),freqtri,paste(firsttriname,sectriname),tritriname,stringsAsFactors = F)
names(unigramDF) <- c('unigram','freq')
names(bigramDF) <- c('bigram','freq','unigram','name')
names(trigramDF) <- c('trigram','freq','bigram','name')
save(unigramDF,bigramDF,trigramDF,file = 'data/ngram.RData')
load('data/ngram.RData')