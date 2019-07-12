library(ggplot2)
library(reshape2)

data <- read.table("/Users/luohao/drive/vienna/amphioxus/segmental_duplication/test.txt")
df <- data.frame(spe=data[,1],wg=data[,2],intra=data[,3])
df1 <- melt(df,id.vars = c("spe"),variable.name ="chr",value.name ="perc")

ggplot(df1,aes(x=spe,y=perc,fill=chr)) + geom_bar(stat="identity") + coord_flip()
