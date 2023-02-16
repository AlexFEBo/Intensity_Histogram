library(shiny)
library(tidyverse)
library(here)





###### Define UI ######
ui <- fluidPage(
  
  # Title
  titlePanel("Intensity Histogram"),
  
  # Sidebar buttons
  sidebarLayout(
    sidebarPanel(
     
    # Change scale box + conditional panels for changing scale
     checkboxInput(inputId = "set_scale",
                    label = "Set scale",
                    value = FALSE),
     
     conditionalPanel(
       condition = 'input.set_scale == true',
       textInput("x_axis", "X scale (min, max)", value = "")
     ),
     
     conditionalPanel(
       condition = 'input.set_scale == true',
       textInput("y_axis", "Y scale (min, max)", value = "")
     ),
     
     # Buttons for Binwidth, Axis names, Legend position, Legend title, Legend
     # conditions
     
      sliderInput("userbin",
                  label = "Binwidth:",
                  min = 1,
                  max = 200,
                  value = 5,
                  step = 1),
      
      textInput("X_axis", 
               "Name for X axis", 
               value = "" ),
     
      textInput("Y_axis",
               "Name for Y axis",
               value = "" ),
     
      radioButtons("legend_position",
                   "Legend position",
                   list("right", "top", "bottom", "left", "none")),
     
      textInput("legend_title",
                "Legend Title",
                value = "" ),
     
      textInput("legend_labels",
                "Conditions (condition1, condition2",
                value = "" )
    ),
    
    
    # Show the plot
    mainPanel(
      plotOutput("histPlot")
    )
  )
)

###### Define server logic ######

server <- function(input, output) {
  
  output$histPlot <- renderPlot({ 
  # Creates variables corresponding to user input (UI)
    # Variable for condition (UI)
    legendlab <- unlist(strsplit(input$legend_labels,",")) 
    # Variables for x and y ranges(UI)
    y_range  <- as.numeric(strsplit(input$y_axis,","))
    x_range  <- as.numeric(strsplit(input$x_axis,","))
    # Example dataframe
    df        <- read.csv("df.csv")
    

    p <- ggplot(df, 
                aes(x=Value, fill=id)) +
      geom_histogram(binwidth = input$userbin) +
      labs(y=input$Y_axis, x =input$X_axis) +
      theme_light(base_size = 16) +
      theme(legend.position = input$legend_position) +
      scale_fill_discrete(name = input$legend_title, labels = legendlab) +
      scale_y_continuous(expand = c(0, NA)) +
      scale_x_continuous(expand = c(0, NA)) 
      # Test using xlim(min, max) for defining the scale (add if statement as well)
    
    print(p)
})

}  

# Run the app ----
shinyApp(ui = ui, server = server)