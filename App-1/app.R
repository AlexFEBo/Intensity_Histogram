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
     
      selectInput("legend_position",
                  "Choose the legend position",
                  choices = c("Right", "Top", "Bottom", "Left", "None"),
                  selected = "Right"),
     
      # radioButtons("legend_position",
      #              "Legend position",
      #              list("right", "top", "bottom", "left", "none")),
     
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

# Example dataframe
df        <- read.csv("df.csv")

###### Define server logic ######

server <- function(input, output) {
  
  output$histPlot <- renderPlot({ 
  # Creates variables corresponding to user input (UI)
    # Variable for condition (UI)
    legendlab <- unlist(strsplit(input$legend_labels,",")) 
    # Variables for x and y ranges(UI)
    y_range  <- as.numeric(unlist(strsplit(input$y_axis,",")))
    x_range  <- as.numeric(unlist(strsplit(input$x_axis,",")))
    legend_pos <- switch (input$legend_position,
                       "Right" = "right",
                       "Top" = "top",
                       "Bottom" = "bottom",
                       "Left" = "left",
                       "None" = "none")
    
    # Draw the histogram with ggplot and using UI
    ggplot(df, 
           aes(x=Value, 
               fill=id)) +
      geom_histogram(binwidth = input$userbin) +
      labs(y=input$Y_axis, x =input$X_axis) +
      theme(legend.position = legend_pos) +
      scale_fill_discrete(name = input$legend_title,
                          labels = legendlab) +
      # Below are classic axis range (0 to maximal value from df)
      scale_y_continuous(expand = c(0, NA)) +
      scale_x_continuous(expand = c(0, NA)) 
    })
  }  

######  Run the app ######

shinyApp(ui = ui, server = server)