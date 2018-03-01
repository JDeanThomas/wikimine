# ****TOTALLY WORKS NOW****
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


    
testDF <- NgramAlt2(Test, 3)    
testDF <- NgramAlt(Test) #works, takes no n arg, produces only n length
testDF <- NgramFunc(Test, 2) #works, takes n arg, produces only n lenght
testDF <- NgramFuncTest(Test, 3) #creates a TDM and DF seems 

