#############    Calculate log prob with kneser ney       ########################
addKNUnigram <- function(df, df2, df3, D1=D){
    # modify df. we operate for each term in df
    bigrams <- nrow(df2)
    
    #    CDotWord <- function(word) nrow(df2[df2$start==word,]) 
    CDotWord <- function(word) sum(df2$start==word) 
    
    print("calculate word dot")
    setkey(df2, end)    
    CWordDot <- function(word) nrow(df2[word]) # how many bigram begins with word
    NWordDot <- vapply(df$term, CWordDot, numeric(1))
    
    print("calculate dot word")
    setkey(df2, start)
    CDotWord <- function(word) nrow(df2[word]) # how many bigram ends with word
    NDotWord <- vapply(df$term, CDotWord, numeric(1))
    
    df$Pcont <- NDotWord/ bigrams
    
    print("calculate dot word dot")
    #NWork, in how many trigram the word ist (in the middle)
    
    setkey(df3, mid)
    CDotWordDot <- function(word) nrow(df3[word])
    NDotWordDot <- vapply(df$term, CDotWordDot, numeric(1))
    
    
    df$lambda <- (D1 /NWordDot) * NDotWordDot
    # TBD eliminate Nan
    
    df$NDotWordDot <- NDotWordDot
    df[is.nan(df$lambda),"lambda"] <- 0
    
    # reset the keys
    setkey(df2, term)  
    setkey(df3, term)  
    return(df)
}
addKNBigram <- function(df, df2, df3, D2=D){
    # modify df2. we operate for each term in df2
    # need df2 already processed
    
    setkey(df3, post)
    CDotW1W2 <- function(w1w2) nrow(df3[w1w2])
    NDotW1W2 <- vapply(df2$term, CDotW1W2, numeric(1))
    
    setkey(df3, pre)
    CW1W2Dot <- function(w1w2) nrow(df3[w1w2])
    NW1W2Dot <- vapply(df2$term, CW1W2Dot, numeric(1))
    
    w2 <- vapply(strsplit(as.character(df2$term), split=" "), '[', character(1L), 1)
    w3 <- vapply(strsplit(as.character(df2$term), split=" "), '[', character(1L), 2)
    
    #     # df already indexed on term (doing 3 times is ineffic.)-------------------
    #     Clambda1 <- function(word) df[word]$lambda
    #     NlambdaW2 <- vapply(w2, Clambda1, numeric(1))
    #     CPcont1 <- function(word) df[word]$Pcont 
    #     NPcontW3 <- vapply(w3, CPcont1, numeric(1))
    #     CDotWordDot <- function(word) df[word]$NDotWordDot
    #     NDotWordDot <- vapply(w2, CDotWordDot, numeric(1))
    
    #--------------------------------------------------------------------------
    CWord <- function(word) (df[word])
    PWord <- sapply(w2, CWord, simplify = "array")
    NDotWordDot <- unlist(PWord[,"NDotWordDot",])
    NlambdaW2   <- unlist(PWord[,"lambda",])
    NPcontW3    <- unlist(PWord[,"Pcont",])
    
    df2$lambda2 <- (D2 /df2$cnt) * NW1W2Dot
    
    df2$Pcont2 <- pmax(NDotW1W2 -D2, 0) / NDotWordDot + NlambdaW2 * NPcontW3
    df2[is.nan(df2$Pcont2),"lambda2"] <- 0
    setkey(df3, term)  
    return(df2)
}
addKNTrigram <- function(df2, df3, D3=D){
    # modify df3. we operate for each term in df3
    w1 <- vapply(strsplit(as.character(df3$term), split=" "), '[', character(1L), 1)
    w2 <- vapply(strsplit(as.character(df3$term), split=" "), '[', character(1L), 2)
    w3 <- vapply(strsplit(as.character(df3$term), split=" "), '[', character(1L), 3)
    w1w2 <- paste(w1, w2, sep=" ")
    w2w3 <- paste(w2, w3, sep=" ")
    # semplify like bigram (beware that are two distinct index)
    FcW1W2 <- function(w1w2) df2[w1w2]$cnt
    NcW1W2 <- vapply(w1w2, FcW1W2, numeric(1))
    
    FlambdaW1W2 <- function(w1w2)  df2[w1w2]$lambda2
    NlambdaW1W2 <- vapply(w1w2, FlambdaW1W2, numeric(1))
    
    FprobW2W3 <- function(w2w3) df2[w2w3]$Pcont2
    NprobW2W3 <- vapply(w2w3, FprobW2W3, numeric(1))
    
    
    MaxLikelTerm <- pmax(df3$cnt-D3,0)/NcW1W2
    
    df3$PKN <- MaxLikelTerm + NlambdaW1W2 * NprobW2W3
    return(df3)
}
#-------------------------
# fourth phase: calculate probability
RELOAD04 <- F
if(RELOAD04){
    system.time(ntddf <-  addKNUnigram(tddf, tddf2, tddf3))
    system.time(ntddf2 <- addKNBigram(ntddf, tddf2, tddf3))
    system.time(ntddf3 <- addKNTrigram(ntddf2, tddf3))
    
    save(ntddf,  file= paste(datadir, "ntddf.save",  sep="\\"))
    save(ntddf2, file= paste(datadir, "ntddf2.save", sep="\\"))
    save(ntddf3, file= paste(datadir, "ntddf3.save", sep="\\"))
}else{
    load(file=paste(datadir, "ntddf.save",  sep="\\"))
    load(file=paste(datadir, "ntddf2.save", sep="\\"))
    load(file=paste(datadir, "ntddf3.save", sep="\\"))
}
#
