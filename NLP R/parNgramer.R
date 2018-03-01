# remeber to look into calling fucktions from pkg namespaces from cluster nodes

taungram <- function(text, n = 1, tolower = FALSE, split = "[[:space:]]+") {
    r <- tau::textcnt(text, method = 'string', n = n, tolower = tolower, split = split)
    return(Reduce(c, sapply(1:length(r), function(x) rep(names(r[x]), r[x]))))
}


ngramrr <- function(x, char = FALSE, ngmin = 1, ngmax = 2, rmEOL = TRUE) {
    if (ngmin > ngmax) {
        stop("ngmax must be higher than ngmin")
    }
    y <- paste(x, collapse = " ") 
    sentencelength <- length(unlist(strsplit(y, split = " ")))
    if (sentencelength > ngmax) {
        return(Reduce(c, Map(function(n) taungram(y, n), seq(from = ngmin, to = ngmax))))
    } else {
        return(Reduce(c, Map(function(n) taungram(y, n), seq(from = ngmin, to = sentencelength ))))
    }
}

NgramAlt2 <- function(Corpus, N){
    tdm <- TermDocumentMatrix(Corpus, control = list(tokenize = function(x) ngramrr(x, ngmax = N)))
    df <- dfConvert(tdm, N)
    return(df)
}

NgramFunc <- function(Corpus, N){
    ntokenizer <- function(x, tokens) function(x) {RWeka::NGramTokenizer(x, RWeka::Weka_control(min = tokens, max = tokens))}
    tdm <-   TermDocumentMatrix(Corpus, control = list(tokenize = ntokenizer(tokens=N), bounds = list(global = c(1,Inf))))
    df <- dfConvert(tdm, N)
    return(df)
}



taungram <- function(text, n = 1, tolower = FALSE, split = "[[:space:]]+") {
    r <- tau::textcnt(text, method = 'string', n = n, tolower = tolower, split = split)
    w <-(Reduce(c, sapply(1:length(r), function(x) rep(names(r[x]), r[x]))))
    }
    
    
wikitdm <- TermDocumentMatrix(WIKI, control = list(tokenize = function(x) ngramrr(x, ngmax = 3)))

tdm <- TermDocumentMatrix(Test, control = list(tokenize = function(x) ngramrr(x, ngmax = 3)))
df <- dfConvert(tdm)

tdm <- TermDocumentMatrix(Explode2, control = list(tokenize = function(x) ngramrr(x, ngmax = 3)))
df <- dfConvert(tdm)


# ^.*[.?!] has ^. adding punctuation followed by space and capital rule should catch only sentences. Figure that out.
# .[.?!] works for splitting sentences in this func, but stil assumes each line is line.

# regex for matching sentence, string ending in [.?!] proceeded by any character unless  
(?<![A-Z][a-z])([!?.])(?=\s*[A-Z])\s*
#replacement
\1\n
# R's ridiculous regex version. Must use perl=TRUE
(?<![A-Z][a-z])([!?.])(?=[[:space:]][A-Z])[[:space:]]*

# i coiuld stingsplit it, but it's lopping off punct. Might not matter
explode2 <- strsplit(explode, split = "(?<![A-Z][a-z])([!?.])(?=[[:space:]][A-Z])[[:space:]]*", perl=TRUE)
# also works, weird, still lops off punc except last line
                                       (?<![A-Z][a-z])([!?.][[:space:]])(?=[A-Z])[[:space:]]* 
                                       (?<![A-Z][a-z][!?.])([[:space:]])(?=[A-Z])[[:space:]]* 
# unlisting vecotr after strsplit breaks TM_Map operations. YET ANOUTHER BUG.
    
news2 <- gsub(news, '?<![A-Z][a-z])([!?.])(?=[[:space:]][A-Z])[[:space:]]*',".\n")

    