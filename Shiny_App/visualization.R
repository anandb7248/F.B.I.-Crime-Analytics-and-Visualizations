library(ggplot2)
library(reshape)
library(magrittr)
library(maps)
library(plotrix)

zz <- apply(us_crime, mean)
ggplot(us_crime, aes(x=))

columns <- c('murder', 'rape', 'robbery', 'assault', 'Burglary')
zz <- subset(us_crime, select=c('murder', 'rape', 'robbery', 'assault', 'Burglary'))

zz$murder <- as.character(zz$murder)
