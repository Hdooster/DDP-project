library(shiny)

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(
    
    # Give the page a title
    titlePanel("Storm destruction per year and type"),
    
    # Generate a row with a sidebar
    sidebarLayout(
      
      # Define the sidebar with one input
      sidebarPanel(
          
        selectInput("ecoinjfat", "Type of damage:",
                    choices=c("Economic","Injuries","Casualties")),
        selectInput("year", "Year:",
                    choices=c(1950:2011))
      ),
        
      # Create a spot for the barplot
      mainPanel(
        plotOutput("finalPlot"),
        tabPanel("About",
                 mainPanel(
                   includeText("LICENSE.txt")
                 )
        )
        )
      )
    )
  )