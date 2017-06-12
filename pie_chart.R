library(ggplot2)
library(scales)
library(reshape2)

#http://www.sthda.com/english/wiki/ggplot2-pie-chart-quick-start-guide-r-software-and-data-visualization
pie_crimes <- washington[, -c(2, 6, 7, 8)] #remove Property, Burglary, and Larceny_Theft
pie_chart <-melt(pie_crimes, id.vars='School', variable_name='Crime')
colnames(pie_chart) <- c('School', 'Crime', 'Count')

bp <- ggplot(pie_chart, aes(x="Crime", y=Count, fill=Crime))+
   geom_bar(width = 1, stat = "identity")
bp

pie <- bp + coord_polar("y", start=0) + scale_fill_brewer(palette="Paired")
pie
