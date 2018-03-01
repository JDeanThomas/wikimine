NgramFunc <- function(Corpus, N){
    ntokenizer <- function(x, tokens) function(x) {RWeka::NGramTokenizer(x, 	RWeka::Weka_control(min = tokens, max = tokens))}
    tdm <-   TermDocumentMatrix(Corpus, control = list(tokenize = ntokenizer(tokens=N), 	bounds = list(global = c(1,Inf))))
    df <- dfConvert(tdm, N)
    return(df)
}

dfConvert <- function(tdm, N){
    counts <- rowapply_simple_triplet_matrix(tdm, sum)
    tdmDT <- data.table(term = Terms(tdm), count = counts)
    setkey(tdmDT, term)
    # purge hapax (keep always unigram hapax)
    #if(NOHAPAX==T&N>1){
    #dfft <- dfft[dfft$cnt>1,]
    return(tdmDT)
}

