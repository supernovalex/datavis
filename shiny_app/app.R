library(shiny)
library(shinythemes)

# ui
ui = fluidPage(
    theme = shinytheme("united"), 
    navbarPage("Crimes in London", 
               tabPanel("Crimes data", 
                        sidebarPanel(
                            tags$h3("Crime data"), 
                            textInput(inputId = "txtLocation", label = "Location:", value = "London"), 
                            textInput(inputId = "txtBrief", label = "Brief Description", value = "")
                        ), 
                        mainPanel(
                            h1("About the crime"), 
                            h4("Description"), 
                            verbatimTextOutput("txtOutput")
                        )
               ), 
               tabPanel("Histogram", 
                        sidebarPanel(), 
                        mainPanel()
               )
    )
)

# server
server = function(input, output) {
    output$txtOutput = renderText(paste(input$txtLocation, input$txtBrief, sep = "\n\n"))
}

# run
shinyApp(ui = ui, server = server)