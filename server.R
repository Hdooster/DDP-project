library(shiny)
library(reshape2)
total_economicdamage_peryear <- read.csv("total_economicdamage_peryear.csv", sep=",", header=T)
total_fatalities_peryear <- read.csv("total_fatalities_peryear.csv", sep=",", header=T)
total_injuries_peryear <- read.csv("total_injuries_peryear.csv", sep=",", header=T)

total_economicdamage_peryear <- total_economicdamage_peryear[,-1]
total_fatalities_peryear <- total_fatalities_peryear[,-1]
total_injuries_peryear <- total_injuries_peryear[,-1]

evtypes <<- sort(unique(total_economicdamage_peryear$event_class))

#setting the data straight
damageyear <- merge(total_economicdamage_peryear,total_fatalities_peryear,by=(c("year","event_class")))
colnames(damageyear) <- c("year","event_class","eco","fat")
damageyear <- merge(damageyear,total_injuries_peryear,by=(c("year","event_class")))
colnames(damageyear) <- c("year","event_class","eco","fat","injuries")


data <- damageyear

## Define a server for the Shiny app
shinyServer(function(input, output) {
  
  
  
  
  dataInput <- reactive({
    dcast_var <<- ifelse(input$ecoinjfat=="Million USD",'eco',ifelse(input$ecoinjfat=="Injuries",'injuries','fat'))
    data2 <- dcast(data,year ~ event_class,value.var=dcast_var)
    data2[is.na(data2)] <- 0
    
    reactdata <- subset(data2, subset=(year == input$year))
    as.matrix(reactdata)
  })
 
  output$finalPlot <- renderPlot({
    
    ## Render a barplot
    barplot(dataInput(),
            main=paste(input$evtype, "in", input$year),
            ylab=ifelse(dcast_var=='eco',"USD","Persons"),
            xlab="Event Type")
  })
})