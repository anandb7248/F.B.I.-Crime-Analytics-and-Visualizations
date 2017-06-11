us_crime <- read.csv('01_crime_in_the_united_states_1996-2015.csv')
data <- read.csv("2015_crimerates_bystate.csv",stringsAsFactors = F) #used to output choropleth plot

data <- data[, -1]

colnames(data) <- c('State', 'Population', 'Violent', 'Murder',
                    'Rape', 'Robbery','Assult', 'Property',
                    'Burglary', 'Larceny_Theft', 'Vehicle_Theft')
write.csv(data, file='2015_crimerates_by_state.csv')
