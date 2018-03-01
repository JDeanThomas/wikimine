# have to figure out how to coerce class TextDocument to work 
# rename
# replace RWeka with other tokenizer

options(mc.cores=1)

vecTok <- function(text, N){
    text <- TextDocument(text)
    ntokenizer <- function(x, tokens) function(x) {RWeka::NGramTokenizer(x, RWeka::Weka_control(min = tokens, max = tokens))}    
    ctrl <- list(tokenize = ntokenizer(tokens=N),
            tolower = TRUE, wordLengths = c(4, Inf))
    vec <- termFreq(text, control = ctrl)
    return(vec)
}
 
system.time(freqVec <- vecTok(wiki, 2))