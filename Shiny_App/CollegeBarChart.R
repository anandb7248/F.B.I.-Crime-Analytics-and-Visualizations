library(ggplot2)
library(scales)
library(reshape2)

college <- read.csv('./Data/College_Crime_Rate.csv')
head(college)
names(college)
college$X<-NULL
yr <- 2015

head(college)

#dfr<-college[, -c(1,3)]
crimes <- college[, -c(1, 3)]
crimes <-melt(crimes, id.vars='School', variable_name='Crime')
colnames(crimes)[3] <- 'Count'
crimes$Count[2537] <- 1131 #count was 1,131. The ',' will coerce to NA
crimes$Count <- as.numeric(as.character(college_crime$Count))

p <- ggplot(crimes,aes(School,Count,fill=Crime)) + 
  geom_bar(position='fill',stat='identity') + 
  theme(axis.text.x = element_text(angle=90,hjust=1))
p


washington <-college[which(college$State=='WASHINGTON'), ] #get all universities within chosen state
washington <-washington[, -c(1,3)] # remove State, and Student_Enrollement columns

washington_crimes<-melt(washington, id.vars='School', variable_name='Crime')
colnames(washington_crimes)[3] <- 'Count'
washington_crimes$Count<-as.numeric(as.character(washington_crimes$Count))
washington_crimes

w <- ggplot(washington_crimes,aes(x=School,y = Count, fill=Crime)) + 
   geom_bar(stat='identity') +
   theme(axis.text.x = element_text(angle=90,hjust=1)) +
   labs(title='State of Washington ', 
        x='University', y='Ocurrences')
w

head(washington)
head(washington_crimes)

states <- unique(college$State)
states <- as.character(states)
write.csv(states, file='states.csv')
n <-names(which(sapply(college,class)=='integer'))
college[, n]<-sapply(college[,n],as.character)
college[,n]<-sapply(college[,n],as.numeric)
sapply(college,class)

#ggplot(washington_crimes,aes(x=School, Count, fill=Crime))
