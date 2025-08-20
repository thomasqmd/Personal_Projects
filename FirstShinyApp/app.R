#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(ggthemes)

library(tidyquant)

# thematic_shiny()

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Stock Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            # sliderInput("bins",
            #             "Number of bins:",
            #             min = 1,
            #             max = 50,
            #             value = 30),
            textInput("Symbol",
                      "Enter a symbol",
                      value = "AAPL")
            #actionButton("update", "Update View")
        ),
        

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        #x    <- faithful[, 2]
        #bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        # hist(x, breaks = bins, col = 'darkgray', border = 'white',
        #      xlab = 'Waiting time to next eruption (in mins)',
        #      main = 'Histogram of waiting times')
        
        # ggplot histogram
        # ggplot(data = faithful, aes(x = eruptions)) +
        #   geom_histogram(aes(y = after_stat(density)),
        #                  position = 'identity',
        #                  bins = input$bins,
        #                  fill = "lightblue",
        #                  color = "darkblue") +
        #   geom_density(alpha = .25,
        #                lwd = 1.5,
        #                color = "salmon",
        #                lty = 5) + 
        #   labs(xlab = "Eruption Duration",
        #        title = "Histogram of Eruption durations")
        stock_data <- tq_get(input$Symbol)
        ggplot(data = stock_data, aes(x = date))
        ggplot(data = stock_data, 
               aes(x = date, 
                   open = open, 
                   high = high, 
                   low = low, 
                   close = close)) + 
          geom_candlestick() +
          geom_smooth()
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
