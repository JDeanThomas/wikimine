# Working version that counts N-grams into TDM from VCorpus usig N-gram algorithm from NLP 
#   package and base::scan and modifying source code of function NLP:getTokenizers called from
#   tm::TermDocumentMatrix:tokenize and loading modified source into local enviroment. 
#   Fully parallel, 100% thread/core useage, though does not scale linearly on "smallish" 
#   data due to overhead. May scale better on larger data. May scale better with less overhead 
#   using parallel apply functional (map()?). Single thread performance is orders of magnitude 
#   faster than calling RWeka::NGramnTokenizer from tm:TermDocumentMatrix:tokenize.

NgramAlt2 <- function(Corpus, N){
    scan_tokenizer_v.2 <- function(x, N)
        scan(text = as.character(x), what = "character", quote = "", 
            strip.white=TRUE, blank.lines.skip=TRUE, quiet = TRUE)
    tdm <- TermDocumentMatrix(Corpus, control = list(tokenize = scan_tokenizer_v.2(tokens=N), 
            bounds = list(global = c(1,Inf))))
    df <- dfConvert(tdm, N)
    return(df)
}

# Convert TDM to data.table, purge Hapax legomena.
dfConvert <- function(tdm, N){  
    counts <- rowapply_simple_triplet_matrix(tdm, sum)
    tdmDT <- data.table(term = Terms(tdm), count = counts)
    setkey(tdmDT, term)
    # purge hapax (keep all unigram hapax)
    #if(NOHAPAX==T&N>1){
    #dfft <- dfft[dfft$cnt>1,]
    return(tdmDT)
}

# Modified source code of NPL:getToeknizers loaded into local enviroment of NgramAlt
getTokenizers <- function() c("MC_tokenizer", "scan_tokenizer", "scan_tokenizer_v.2")

# http://www.cs.utexas.edu/users/dml/software/mc/
MC_tokenizer <- NLP::Token_Tokenizer(function(x) {
        x <- as.character(x)
        ASCII_letters <- "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        id <- sprintf("[%s]+", ASCII_letters)
        http <- sprintf("(http://%s(\\.%s)*)", id, id)
        email <- sprintf("(%s@%s(\\.%s)*)", id, id, id)
        http_or_email <- sprintf("%s|%s", http, email)
        
        c(unlist(regmatches(x, gregexpr(http_or_email, x))),
          unlist(strsplit(gsub(http_or_email, "", x),
                          sprintf("[^%s]", ASCII_letters))))
})

scan_tokenizer <- NLP::Token_Tokenizer(function(x)
        scan(text = as.character(x), what = "character", quote = "", quiet = TRUE))

scan_tokenizer_v.2 <- NLP::Token_Tokenizer(function(x)
        scan(text = as.character(x), what = "character", quote = "", quiet = TRUE))

