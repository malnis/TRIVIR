needs(stringi);
needs(stringr);
needs(tm);
needs(corpus);
needs(textstem);
needs(ngram);

#When running the code from RStudio, you need to comment the lines above and uncomment the lines bellow
# library("stringi");
# library("stringr")
# library(tm)
# library(corpus)
# library(textstem)
# library(ngram)

extractCorpus <- function(input, dirName, source){
  if (source == "ieee"){
    extractIEEE(input, dirName);
  }else if (source == "parsifal"){
    extractParsifal(input, dirName);
  }else if (source == "scopus"){
    extractScopus(input, dirName);
  }
}

defaultPreprocess <-function(text, withoutstopwords){
  connBase <- file("stop-word-list.txt",open="rt")
  stopwordlist <- readLines(connBase);
  close(connBase);
  
  text <- tolower(text);
  text <- gsub("<[^>]*>","", text)
  if (withoutstopwords){
    text <- removeWords(text,stopwordlist)
  }
  text <- gsub("\\W"," ", text)
  text <- gsub("\\d"," ", text)
  text <- str_squish(text);

  return(text)
}

extractIEEE <- function(input, dirName){
  corpus <- read.csv(file = input, header=TRUE, check.names=FALSE)
  #Create the directory for the files
  dir.create(sprintf("../../data/%s", dirName));
  
  for (i in 1:length(corpus[,1])){
    title <- iconv(corpus[i,'Document Title'], to = "utf8");
    author <- iconv(corpus[i,'Authors'], to = "utf8");
    abstract <-iconv(corpus[i, 'Abstract'], to = "utf8");
    year <- corpus[i, 'Publication_Year'];
    keywords <- iconv(corpus[i, 'Author Keywords'], to = "utf8");
    article <- paste(title, author, year, abstract, keywords, sep = "\n");
    
    title <- defaultPreprocess(title, FALSE)
    if (nchar(title) > 100){
      title <- substring(title, 1, 100);
    }
    conn<-file(sprintf("../../data/%s/%s.txt", dirName, title), encoding = "utf8")
    
    writeLines(article, conn)
    close(conn)
  }
}

extractParsifal <- function(input, dirName){
  #Retrieve csv 
  corpus <- read.csv(file= input, header=TRUE, check.names=FALSE);
  #Create the directory for the files
  dir.create(sprintf("../../data/%s", dirName));
  
  for (i in 1:length(corpus[,1])){
    title <- iconv(corpus[i,'title'], to = "utf8");
    author <- iconv(corpus[i,'author'], to = "utf8");
    abstract <-iconv(corpus[i, 'abstract'], to = "utf8");
    year <- corpus[i, 'year'];
    keywords <- iconv(corpus[i, 'author_keywords'], to = "utf8");
    
    if (keywords == ""){
      keywords <- iconv(corpus[i, 'keywords'], to = "utf8");
    }
    
    if (abstract != ""){
      article <- paste(title, author, year, abstract, keywords, sep = "\n");
    }else{
      article <- paste(title, author, year, keywords, sep = "\n");}
    
    
    title <- defaultPreprocess(title, FALSE)
    if (nchar(title) > 100){
      title <- substring(title, 1, 100);
    }
    
    conn<-file(sprintf("../../data/%s/%s.txt", dirName, title), encoding = "utf8")
    
    writeLines(article, conn)
    close(conn)
  }
  
}

extractScopus <- function(input, dirName){
  #Retrieve csv 
  corpus <- read.csv(file= input, header=TRUE, check.names=FALSE);
  #Create the directory for the files
  dir.create(sprintf("../../data/%s", dirName));
  
  for (i in 1:length(corpus[,1])){
    title <- iconv(corpus[i,'Title'], to = "utf8");
    author <- iconv(corpus[i,1], to = "utf8");
    abstract <-iconv(corpus[i, 'Abstract'], to = "utf8");
    year <- corpus[i, 'Year'];
    keywords <- iconv(corpus[i, 'Author Keywords'], to = "utf8");
    article <- paste(title, author, year, abstract, keywords, sep = "\n");
    
    title <- defaultPreprocess(title, FALSE)
    if (nchar(title) > 100){
      title <- substring(title, 1, 100);
    }
    conn<-file(sprintf("../../data/%s/%s.txt", dirName, title), encoding = "utf8")
    
    writeLines(article, conn)
    close(conn)
  }
}