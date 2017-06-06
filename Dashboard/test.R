install.packages("reshape")
library(reshape)

temp <- subset(data,select = -c(X))
temp <- subset(temp, select = c("year","robbery_rate","assault_rate","rape_rate","murder_rate"))
#temp <- melt(temp)

mdf <- melt(temp, id.vars="year", value.name=c("robbery_rate","rape_rate"))

ggplot(mdf, aes(x=year,y=value, colour=variable))+
  geom_line()
