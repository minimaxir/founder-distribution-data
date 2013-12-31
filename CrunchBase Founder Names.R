library(RJSONIO)
library(RCurl)

api_key = "INSERT API KEY HERE"
name <- "Y Combinator"

investments <- read.csv("crunchbase_monthly_export_investments_dec.csv",header=T, fileEncoding="latin1")

companies_names <- unique(as.character(investments[which(investments$investor_name==name),]$company_name))

companies_fund <- investments[which(investments$company_name %in% companies_names),]
companies_fund <- companies_fund[which(companies_fund$investor_name==name),]

male_names <- as.character(unlist(read.table("male.txt")))
female_names <- as.character(unlist(read.table("female.txt")))

getGender <- function(firstName) {
	return (ifelse(firstName %in% male_names,"Male",
			ifelse(firstName %in% female_names,"Female","--")))
			}


url <- "http://api.crunchbase.com/v/1/company/"
companies <- as.character(companies_fund$company_name)
funded_year <- as.character(companies_fund$funded_year)
permalink <- apply(as.array(as.character(companies_fund$company_permalink)),1, function(x) strsplit(x,"/")[[1]][3])

count <- 1
nrows <- 10000


data<- data.frame(a=rep(NA,nrows), b=rep(NA,nrows), c=rep(NA,nrows),d=rep(NA,nrows), e=rep(NA,nrows),f=rep(NA,nrows))

names(data) <- c("first_name","last_name","gender","title","company","year_funded")


for (i in 1:length(companies)) {

  try ({
  company <- companies[i]
  JSON_data <- fromJSON(paste(url,permalink[i],".js?api_key=",api_key,sep=""))
  
  
  if(!is.null(JSON_data$relationships) & length(JSON_data$relationships) > 0) {
    
  employees <- JSON_data$relationships  
  
    for (j in 1:length(employees)) {
      employee <- employees[[j]]
      if (grepl("[fF]ounder",employee$title)) {
        data[count,] <- c(employee$person[1],employee$person[2],getGender(employee$person[1]),employee$title, company, funded_year[i]) 
        count <- count + 1
                                            
      }
      }

}
  }, silent=T)
}

data <- na.omit(data)
new_data <- data[!duplicated(data[,c(1,2,6)]),]

write.csv(new_data,paste(tolower(name),"founder-names.csv"),row.names=F)

new_data <- new_data[which(new_data$gender!="--"),]

gender_year <- aggregate(cbind(new_data$gender,new_data$year_funded),by=list(new_data$gender,new_data$year_funded),length)

write.csv(gender_year,paste(tolower(name),"gender-distribution.csv"),row.names=F)