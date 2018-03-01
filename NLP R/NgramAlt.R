NgramAlt <- function(Corpus, N){
    scan2_tokenizer <- function(x, N)
        scan(text = as.character(x), what = "character", quote = "", 
            strip.white=TRUE, blank.lines.skip=TRUE, quite = TRUE)
    tdm <- TermDocumentMatrix(Corpus, control = list(tokenize = scan2_tokenizer(tokens=N), 
            bounds = list(global = c(1,Inf))))
    df <- dfConvert(tdm, N)
    return(df)
}

# Working version that counts unigrams. Fully parallel, 100% thread/core useage, though does not scale linearly 
#   on smallish data due to overhead. May scale better on larger data. May scale better with less overhead
#   using parallel apply functional (map()?). Single thread performance is orders of magnitude faster than
#   calling RWeka::NGramnTokenizer from tm:TermDocumentMatrix

NgramAlt <- function(Corpus){
    scan2_tokenizer <- function(x, N)
        scan(text = as.character(x), what = "character", quote = "", 
             strip.white=TRUE, blank.lines.skip=TRUE, quiet = TRUE)
    tdm <-   TermDocumentMatrix(Corpus, control = list(tokenize = scan2_tokenizer, bounds = list(global = c(1,Inf))))
    df <- dfConvert(tdm, N)
    return(df)
}

strip.white=TRUE
blank.lines.skip=TRUE
nmax=N # set nmax to length of data for object. scans in faster.



getTokenizers <-
    function()
        c("MC_tokenizer", "scan_tokenizer")

# http://www.cs.utexas.edu/users/dml/software/mc/
MC_tokenizer <-
    NLP::Token_Tokenizer(function(x)
    {
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

scan_tokenizer <-
    NLP::Token_Tokenizer(function(x)
        scan(text = as.character(x), what = "character", quote = "", quiet = TRUE))