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
data2 <- dcast(data,year ~ event_class)
data2[is.na(data2)] <- 0

## Define a server for the Shiny app
shinyServer(function(input, output) {
  
#  output$evtypeControls <- renderUI({
#    if(1) {
#      checkboxGroupInput('evtypes', 'Event types', evtypes, selected=evtypes)
#    }
#  })

  dataInput <- reactive({
    reactdata <- subset(data2, subset=(year == input$year))
    as.matrix(reactdata)
  })
 
  output$plot1 <- renderPlot({
    
    ## Render a barplot
    barplot(dataInput(),
            main=paste(input$evtype, "in", input$year),
            ylab="Consumption (in EUR)",
            xlab="Weeks (Jan to Dec)")
  })
})