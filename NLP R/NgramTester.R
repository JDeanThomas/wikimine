#tokenizer test

library(tm)
library(slam)
library(plyr)
library(data.table)
library(parallel)
library(ngramrr)
#library(foreach)
library(tau)

options(mc.cores=8)
system.time(news2 <- sample(readLines("./final/en_US/news2.txt", 200000)))
#system.time(news2 <- strsplit(news2, split = "(?<![A-Z][a-z])([!?.])(?=[[:space:]][A-Z])[[:space:]]*", perl=TRUE))
system.time(News2 <- Corpus(VectorSource(news2)))
system.time(News2 <- tm_map(News2, content_transformer(tolower)))
system.time(news3 <- tm_map(news3, stripWhitespace))

news3 <- PlainTextDocument(news2)

options(mc.cores=1)
system.time(TauNews2DF <- NgramAlt2(News2, 4))

options(mc.cores=8)
system.time(TauNews2DFmc <- NgramAlt2(News2, 4))

lsos()


options(mc.cores=8)
system.time(news <- sample(readLines("./final/en_US/en_US.news.txt", 200000)))
system.time(news <- strsplit(news, split = "(?<![A-Z][a-z])([!?.])(?=[[:space:]][A-Z])[[:space:]]*", perl=TRUE))
system.time(News <- Corpus(VectorSource(news)))
system.time(News <- tm_map(News, content_transformer(tolower)))
system.time(News <- tm_map(News, stripWhitespace))

options(mc.cores=1)
system.time(WekaNewsDF <- NgramFunc(News, 4))
system.time(TauNewsDF <- NgramAlt2(News, 4))

options(mc.cores=8)
system.time(WekaNewsDFmc <- NgramFunc(News, 4))
system.time(TauNewsDFmc <- NgramAlt2(News, 4))

lsos()